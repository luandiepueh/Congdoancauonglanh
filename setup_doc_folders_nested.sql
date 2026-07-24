-- ============================================================
-- THƯ MỤC CON (nested doc_folders) — chạy 1 lần trong Supabase SQL Editor
-- Yêu cầu đã chạy setup_doc_folders.sql trước đó.
-- Cho phép admin tạo thư mục con bên trong 1 thư mục cha
-- (VD: Biểu mẫu > Thành lập CĐ, Biểu mẫu > Đại hội) để gom nhóm file
-- thay vì để hàng chục file rời rạc trong 1 thư mục phẳng.
-- ============================================================

ALTER TABLE public.doc_folders
  ADD COLUMN IF NOT EXISTS parent_id UUID REFERENCES public.doc_folders(id) ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_doc_folders_parent_id ON public.doc_folders(parent_id);
