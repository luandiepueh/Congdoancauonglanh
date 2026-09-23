-- ============================================================
-- SITE_VIEWS — đếm lượt truy cập trang chủ công khai
-- Chạy 1 lần trong Supabase SQL Editor khi triển khai
-- ============================================================

CREATE TABLE public.site_views (
    id          INTEGER     PRIMARY KEY DEFAULT 1,
    view_count  BIGINT      NOT NULL DEFAULT 0,
    updated_at  TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT site_views_single_row CHECK (id = 1)
);

INSERT INTO public.site_views (id, view_count) VALUES (1, 0);

ALTER TABLE public.site_views ENABLE ROW LEVEL SECURITY;

-- Chỉ admin (đã đăng nhập) mới đọc được số liệu, không cho anon đọc/ghi trực tiếp
CREATE POLICY "auth_read_site_views" ON public.site_views FOR SELECT USING (auth.role() = 'authenticated');

-- Hàm tăng lượt truy cập — gọi từ trang chủ công khai (anon) qua RPC, bypass RLS
CREATE OR REPLACE FUNCTION increment_site_view()
RETURNS VOID LANGUAGE sql SECURITY DEFINER AS $$
    UPDATE public.site_views SET view_count = view_count + 1, updated_at = NOW() WHERE id = 1;
$$;
