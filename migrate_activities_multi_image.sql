-- ============================================================
-- NÂNG CẤP: Hoạt động hỗ trợ NHIỀU ẢNH / bài đăng — chạy 1 lần trong Supabase SQL Editor
-- Chạy sau setup_activities.sql (bảng activities đã tồn tại với cột image_url TEXT)
-- ============================================================

-- 1. Thêm cột mảng ảnh mới
ALTER TABLE public.activities ADD COLUMN image_urls TEXT[] NOT NULL DEFAULT '{}';

-- 2. Chuyển dữ liệu ảnh cũ (1 ảnh/hoạt động) sang mảng mới
UPDATE public.activities SET image_urls = ARRAY[image_url] WHERE image_url IS NOT NULL;

-- 3. Bỏ cột cũ (không còn dùng, mọi nơi trong code đã chuyển sang image_urls)
ALTER TABLE public.activities DROP COLUMN image_url;
