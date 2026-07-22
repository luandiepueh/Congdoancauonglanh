# Design System — Công Đoàn Cơ Sở

Nguồn tham chiếu duy nhất cho màu sắc, khoảng cách, bo góc, và quy tắc khả năng tiếp cận dùng trong toàn app. Khi thêm component mới, tra bảng này trước khi tự đặt giá trị mới.

Xem báo cáo kiểm toán đầy đủ (kèm bằng chứng file:line) tại artifact đã publish trong phiên làm việc ngày 22/07/2026.

## 1. Màu sắc

Theme hiện tại ("Hope Blue") đúng hướng cho một cổng thông tin công đoàn — giữ nguyên tông màu, chỉ chuẩn hoá token còn thiếu.

| Token | Giá trị | Dùng cho |
|---|---|---|
| `--primary` | `#2563eb` | Thương hiệu, link, nút chính, focus ring |
| `--primary-light` | `#3b82f6` | Gradient, hover |
| `--primary-dark` | `#1d4ed8` | Header band, topbar, text nhấn mạnh |
| `--accent` | `#f59e0b` | Ghim (pinned), CTA phụ — **không** dùng làm màu chính |
| `--success` | `#10b981` | Trạng thái đã xử lý, badge thành công |
| `--danger` | `#ef4444` | Lỗi, hành động xoá |
| `--text` | `#1e293b` | Chữ chính |
| `--text-muted` | `#64748b` | Chữ phụ — **4.76:1 trên nền trắng, đạt AA** |
| ~~`#94a3b8`~~ | — | **Loại bỏ** — chỉ đạt 2.57:1, dùng sai ở `.anc-meta`, `.doc-meta`, `.nav-section-label`. Thay bằng `--text-muted`. |

Quy tắc: mọi cặp chữ/nền mới phải đạt tối thiểu 4.5:1 (chữ thường) hoặc 3:1 (chữ lớn ≥24px / đậm ≥18.66px). Không thêm màu xám mới ngoài bảng trên — dùng `--text-muted` cho mọi nhãn phụ, metadata, timestamp.

## 2. Bo góc (chuẩn hoá từ 8 giá trị rời rạc)

| Token | Giá trị | Dùng cho |
|---|---|---|
| `--r-sm` | 8–10px | Input, button nhỏ, badge |
| `--r-md` | 14–16px | Card nội dung (`anc-card`, `doc-card`, `app-card`) |
| `--r-lg` | 18–20px | Card nổi bật (`form-section`, `qa-card-v2`, `.glass`) |
| `--r-xl` | 24px | Modal lớn, `.login-box` |

Giá trị trang trí ngoài hệ (48/72px ở hero icon frame) không thuộc thang này — chỉ dùng cho hình trang trí một lần, không lặp lại cho component chức năng.

## 3. Khoảng cách & bóng đổ

- Giữ nhịp 4/8px hiện có trong padding component (đã nhất quán, không cần đổi).
- `--card-shadow: 0 2px 16px rgba(37,99,235,.10)` là bóng chuẩn cho card tĩnh. Bóng hover mạnh hơn (`0 12–16px 40–48px rgba(37,99,235,.15)`) chỉ dùng khi có `transform: translateY()` đi kèm — không thêm bóng nặng cho phần tử tĩnh.

## 4. Typography

`Be Vietnam Pro` — giữ nguyên, hỗ trợ dấu tiếng Việt tốt, không đổi. Thang cỡ chữ hiện tại (mô tả .78–.83rem, title .95–1.05rem, hero clamp) đã hợp lý, không cần thang mới.

## 5. Bắt buộc cho mọi component tương tác mới

Đây là phần thường bị bỏ sót — checklist khi thêm nút/thẻ/card mới:

- [ ] **Focus visible**: mọi phần tử bấm được (kể cả `<a>`/`<div>` dùng làm card) phải có vòng focus rõ — dùng `outline: 2-3px solid var(--primary); outline-offset: 2px`, không chỉ dựa vào focus mặc định của trình duyệt.
- [ ] **Bàn phím thao tác được**: nếu dùng `<div onclick>`, phải thêm `tabindex="0" role="button"` + xử lý `keydown` cho Enter/Space. Ưu tiên dùng `<button>`/`<a>` thật thay vì div giả lập.
- [ ] **Tên cho screen reader**: nút chỉ có icon (không có chữ) bắt buộc có `aria-label` mô tả hành động — không dùng `title` làm nhãn chính.
- [ ] **Label gắn input**: `<label for="id">` khớp với `id` của input/select/textarea tương ứng.
- [ ] **Vùng chạm ≥ 44×44px**: cho mọi nút/icon-button, kể cả khi icon nhỏ hơn (dùng padding để mở rộng vùng bấm).
- [ ] **`prefers-reduced-motion`**: animation lặp (`infinite`) hoặc hover-transform phải bọc trong `@media (prefers-reduced-motion: no-preference)`.
- [ ] **Trạng thái async có live region**: toast/loading/thông báo động dùng `role="status" aria-live="polite"` (thông tin) hoặc `role="alert"` (lỗi/khẩn).

## 6. Dọn dẹp đã biết

- `.qa-card` (css/style.css, legacy quick-access card) không còn được dùng ở bất kỳ trang HTML nào — chỉ `.qa-card-v2` đang chạy. Xoá an toàn khi dọn CSS.
- `.admin-sidebar` ẩn hoàn toàn dưới 768px (`display:none`) mà không có thay thế — cần offcanvas/hamburger trước khi coi admin panel là "responsive".
