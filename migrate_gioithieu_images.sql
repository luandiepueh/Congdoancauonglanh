-- ============================================================
-- NÂNG CẤP: Giới thiệu chung hỗ trợ hình ảnh minh họa — chạy 1 lần trong Supabase SQL Editor
-- Chạy sau setup_leaders.sql (bảng org_profile đã tồn tại)
-- ============================================================

ALTER TABLE public.org_profile ADD COLUMN image_urls TEXT[] NOT NULL DEFAULT '{}';
