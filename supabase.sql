-- نفّذ هذا الملف في Supabase > SQL Editor
create extension if not exists pgcrypto;
create table if not exists public.visitors (
 id uuid primary key default gen_random_uuid(), name text not null, grade text,
 created_at timestamptz not null default now()
);
create table if not exists public.pdf_chunks (
 id uuid primary key default gen_random_uuid(), content text not null,
 document_name text not null, created_at timestamptz not null default now()
);
create table if not exists public.questions (
 id uuid primary key default gen_random_uuid(), visitor_id uuid references public.visitors(id) on delete set null,
 visitor_name text not null, question text not null, answer text not null,
 created_at timestamptz not null default now()
);
alter table public.visitors enable row level security;
alter table public.pdf_chunks enable row level security;
alter table public.questions enable row level security;
-- الطلاب: إنشاء سجل زيارة وسؤال، وقراءة مقاطع المادة فقط.
create policy "public insert visitors" on public.visitors for insert to anon with check (true);
create policy "public read pdf chunks" on public.pdf_chunks for select to anon using (true);
create policy "public insert questions" on public.questions for insert to anon with check (true);
-- المدير: بعد إنشاء حسابه في Authentication، امنح المستخدمين المسجلين صلاحية الإدارة.
create policy "authenticated manage visitors" on public.visitors for all to authenticated using (true) with check (true);
create policy "authenticated manage pdf chunks" on public.pdf_chunks for all to authenticated using (true) with check (true);
create policy "authenticated manage questions" on public.questions for all to authenticated using (true) with check (true);
