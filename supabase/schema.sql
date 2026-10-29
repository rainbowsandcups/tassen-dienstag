-- Tassen-Dienstag: eine Zeile pro Person, angekreuzte Dienstage als Datumsliste.
-- Einmal im Supabase SQL Editor ausführen.

create table if not exists public.people (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 40),
  days date[] not null default '{}' check (cardinality(days) <= 20),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.people enable row level security;

-- Die Seite nutzt nur den öffentlichen Schlüssel (anon/publishable).
-- Erlaubt: lesen, Namen hinzufügen, Dienstage ankreuzen. Nicht erlaubt: löschen, Namen ändern.
revoke all on public.people from anon;
grant select, insert on public.people to anon;
grant update (days, updated_at) on public.people to anon;

drop policy if exists "alle lesen" on public.people;
drop policy if exists "alle eintragen" on public.people;
drop policy if exists "alle ankreuzen" on public.people;
create policy "alle lesen" on public.people for select to anon using (true);
create policy "alle eintragen" on public.people for insert to anon with check (true);
create policy "alle ankreuzen" on public.people for update to anon using (true) with check (true);

-- Live-Updates: andere sehen Klicks sofort.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'people'
  ) then
    alter publication supabase_realtime add table public.people;
  end if;
end $$;

-- Die Gruppe, in fester Reihenfolge.
insert into public.people (name, created_at)
select v.name, now() + (v.pos * interval '1 second')
from (values
  (1, 'Lotta'), (2, 'Hannah'), (3, 'Megan'),
  (4, 'Nicole'), (5, 'Tamara'), (6, 'Ellena')
) as v(pos, name)
where not exists (select 1 from public.people p where p.name = v.name);
