-- À exécuter une seule fois dans Supabase > SQL Editor.
-- Ces tables rendent la checklist et l'agenda partagés entre les organisateurs.
create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  label text not null,
  is_done boolean not null default false,
  created_at timestamptz not null default now()
);
create table if not exists public.agenda_items (
  id uuid primary key default gen_random_uuid(),
  item_date date,
  label text not null,
  created_at timestamptz not null default now()
);
alter table public.tasks enable row level security;
alter table public.agenda_items enable row level security;
drop policy if exists "Organizers manage tasks" on public.tasks;
create policy "Organizers manage tasks" on public.tasks
for all to authenticated
using (exists (select 1 from public.organizers where user_id = (select auth.uid())))
with check (exists (select 1 from public.organizers where user_id = (select auth.uid())));
drop policy if exists "Organizers manage agenda" on public.agenda_items;
create policy "Organizers manage agenda" on public.agenda_items
for all to authenticated
using (exists (select 1 from public.organizers where user_id = (select auth.uid())))
with check (exists (select 1 from public.organizers where user_id = (select auth.uid())));
