-- ============================================================
-- HÌNH ẢNH HOẠT ĐỘNG (Activities gallery) — chạy 1 lần trong Supabase SQL Editor
-- Dùng chung storage bucket 'attachments' đã có sẵn (public, 10MB, mọi loại ảnh) — không cần bucket mới.
-- ============================================================

CREATE TABLE public.activities (
    id          UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    title       TEXT        NOT NULL,
    description TEXT,
    image_url   TEXT        NOT NULL,
    event_date  DATE        DEFAULT CURRENT_DATE,
    created_by  UUID        REFERENCES auth.users(id),
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.activities ENABLE ROW LEVEL SECURITY;

-- Public đọc, admin (authenticated) ghi — cùng pattern với announcements/documents
CREATE POLICY "anon_read_activities" ON public.activities FOR SELECT USING (TRUE);
CREATE POLICY "auth_all_activities"  ON public.activities FOR ALL   USING (auth.role() = 'authenticated');
