-- ============================================================
-- BẢO MẬT GÓP Ý: tra cứu bằng MÃ RIÊNG thay vì bằng TÊN — chạy 1 lần trong Supabase SQL Editor
-- Lý do: trước đây RLS cho phép anon SELECT * toàn bộ bảng feedback (USING TRUE),
-- nghĩa là ai cũng có thể đọc được HẾT nội dung góp ý + phản hồi của người khác
-- (kể cả không qua giao diện web, gọi thẳng REST API cũng lấy được toàn bộ dữ liệu).
-- Migration này: (1) thêm mã tra cứu riêng cho từng góp ý, (2) đóng quyền đọc trực
-- tiếp bảng feedback của anon, (3) mở 1 hàm RPC chỉ trả về đúng 1 góp ý khớp mã.
-- ============================================================

-- 1. Thêm cột mã tra cứu + cờ ẩn danh
ALTER TABLE public.feedback ADD COLUMN IF NOT EXISTS lookup_code TEXT;
ALTER TABLE public.feedback ADD COLUMN IF NOT EXISTS is_anonymous BOOLEAN NOT NULL DEFAULT FALSE;

-- 2. Sinh mã tra cứu cho các góp ý cũ đã có (nếu chưa có mã)
UPDATE public.feedback
SET lookup_code = upper(substr(md5(random()::text || id::text), 1, 6))
WHERE lookup_code IS NULL;

ALTER TABLE public.feedback ALTER COLUMN lookup_code SET NOT NULL;
ALTER TABLE public.feedback ADD CONSTRAINT feedback_lookup_code_key UNIQUE (lookup_code);

-- 3. Đóng lỗ hổng: bỏ quyền đọc toàn bảng của anon
DROP POLICY IF EXISTS "anon_read_feedback" ON public.feedback;
CREATE POLICY "auth_read_feedback" ON public.feedback FOR SELECT USING (auth.role() = 'authenticated');

-- 4. Hàm tra cứu công khai — chỉ trả về (các) góp ý khớp ĐÚNG mã, không lộ toàn bảng
CREATE OR REPLACE FUNCTION public.get_feedback_by_code(p_code TEXT)
RETURNS SETOF public.feedback
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT * FROM public.feedback WHERE lookup_code = upper(trim(p_code));
$$;

REVOKE ALL ON FUNCTION public.get_feedback_by_code(TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_feedback_by_code(TEXT) TO anon, authenticated;
