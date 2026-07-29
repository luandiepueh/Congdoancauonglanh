-- ============================================================
-- QUYỀN LỢI ĐOÀN VIÊN (Benefits) — chạy 1 lần trong Supabase SQL Editor
-- ============================================================

CREATE TABLE public.benefits (
    id            UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    title         TEXT        NOT NULL,
    description   TEXT,
    icon          TEXT        NOT NULL DEFAULT 'bi-gift-fill',
    display_order INT         NOT NULL DEFAULT 0,
    created_at    TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.benefits ENABLE ROW LEVEL SECURITY;
CREATE POLICY "anon_read_benefits" ON public.benefits FOR SELECT USING (TRUE);
CREATE POLICY "auth_all_benefits"  ON public.benefits FOR ALL   USING (auth.role() = 'authenticated');

-- Dữ liệu mẫu — các chế độ phổ biến ở công đoàn cơ sở, admin có thể sửa/xóa/thêm
-- lại trong trang Quản trị > Quyền lợi đoàn viên
INSERT INTO public.benefits (title, description, icon, display_order) VALUES
('Tết Sum vầy',              'Quà Tết, vé xe/hỗ trợ chi phí về quê cho đoàn viên có hoàn cảnh khó khăn dịp Tết Nguyên đán.', 'bi-gift-fill',        1),
('Mái ấm Công đoàn',         'Hỗ trợ kinh phí xây mới, sửa chữa nhà ở cho đoàn viên có hoàn cảnh khó khăn về nhà ở.',        'bi-house-heart-fill', 2),
('Học bổng con CNVCLĐ',      'Học bổng, phần thưởng khuyến học cho con đoàn viên có thành tích học tập tốt.',                 'bi-mortarboard-fill', 3),
('Trợ cấp khó khăn',         'Thăm hỏi, trợ cấp đột xuất khi đoàn viên ốm đau, tai nạn, gặp khó khăn đột xuất.',              'bi-heart-pulse-fill', 4),
('Khám sức khỏe định kỳ',    'Tổ chức khám sức khỏe định kỳ hàng năm cho đoàn viên, người lao động.',                         'bi-clipboard2-pulse-fill', 5),
('Tham quan, nghỉ mát',      'Tổ chức các chuyến tham quan, du lịch, giao lưu hàng năm cho đoàn viên.',                        'bi-airplane-fill',    6);
