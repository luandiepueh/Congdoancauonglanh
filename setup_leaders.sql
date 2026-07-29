-- ============================================================
-- GIỚI THIỆU & BAN CHẤP HÀNH (Leaders) — chạy 1 lần trong Supabase SQL Editor
-- Dùng chung storage bucket 'attachments' đã có sẵn cho ảnh chân dung (path leaders/...)
-- ============================================================

-- 1. Nội dung giới thiệu chung (lịch sử, sứ mệnh...) — bảng 1 dòng, admin sửa qua trang Giới thiệu
CREATE TABLE public.org_profile (
    id         SMALLINT     PRIMARY KEY DEFAULT 1 CHECK (id = 1),
    intro      TEXT,
    updated_at TIMESTAMPTZ  DEFAULT NOW()
);
INSERT INTO public.org_profile (id, intro) VALUES (1, '') ON CONFLICT (id) DO NOTHING;

ALTER TABLE public.org_profile ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_read_org_profile" ON public.org_profile FOR SELECT USING (TRUE);
CREATE POLICY "auth_update_org_profile" ON public.org_profile FOR UPDATE USING (auth.role() = 'authenticated');

-- 2. Danh sách Ban Chấp hành / Ban Thường trực
CREATE TABLE public.leaders (
    id            UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    full_name     TEXT        NOT NULL,
    role          TEXT        NOT NULL,
    photo_url     TEXT,
    phone         TEXT,
    email         TEXT,
    display_order INT         NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.leaders ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_read_leaders" ON public.leaders FOR SELECT USING (TRUE);
CREATE POLICY "auth_all_leaders"  ON public.leaders FOR ALL   USING (auth.role() = 'authenticated');
