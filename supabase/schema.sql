create table if not exists public.questions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  question text not null check (length(trim(question)) > 0),
  answer text,
  created_at timestamptz not null default now(),
  answered_at timestamptz
);
create index if not exists questions_user_created on public.questions(user_id,created_at desc);
alter table public.questions enable row level security;
create policy "owner_select" on public.questions for select to authenticated using ((select auth.uid()) = user_id);
create policy "owner_insert" on public.questions for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "owner_update" on public.questions for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "owner_delete" on public.questions for delete to authenticated using ((select auth.uid()) = user_id);
