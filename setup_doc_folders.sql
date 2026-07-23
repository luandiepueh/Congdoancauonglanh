-- ============================================================
-- THƯ MỤC TÀI LIỆU (doc_folders) — chạy 1 lần trong Supabase SQL Editor
-- Cho phép admin tự tạo/sửa/xóa thư mục để nhóm tài liệu, thay vì 5 loại cố định.
-- documents.category vẫn là TEXT tự do như cũ — chỉ khớp theo tên với doc_folders.name,
-- nên không cần đổi cột/kiểu dữ liệu của bảng documents đang có dữ liệu thật.
-- ============================================================

CREATE TABLE public.doc_folders (
    id         UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    name       TEXT        NOT NULL UNIQUE,
    icon       TEXT        DEFAULT '📁',
    color      TEXT        DEFAULT '#e8eaf6',
    sort_order INTEGER     DEFAULT 0,
    created_by UUID        REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.doc_folders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "anon_read_doc_folders" ON public.doc_folders FOR SELECT USING (TRUE);
CREATE POLICY "auth_all_doc_folders"  ON public.doc_folders FOR ALL   USING (auth.role() = 'authenticated');

-- Seed 5 thư mục từ các category đang dùng, để tài liệu hiện có tự động rơi vào đúng thư mục
INSERT INTO public.doc_folders (name, icon, color, sort_order) VALUES
    ('Biểu mẫu',   '📊', '#e8eaf6', 1),
    ('Hướng dẫn',  '📖', '#e3f2fd', 2),
    ('Quy chế',    '📋', '#e8f5e9', 3),
    ('Quyết định', '📜', '#fff3e0', 4),
    ('Khác',       '📄', '#f5f5f5', 5)
ON CONFLICT (name) DO NOTHING;
