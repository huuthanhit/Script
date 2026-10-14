# Clear Last Logon

**Nền tảng:** Windows 10/11  
**Yêu cầu:** Mở CMD hoặc chạy tệp BAT bằng quyền Administrator.

## Mục đích

Xóa ba giá trị Registry dùng hiển thị người đăng nhập gần nhất trên màn hình logon:

- `LastLoggedOnUser`
- `LastLoggedOnSAMUser`
- `LastLoggedOnDisplayName`

Thao tác này **không xóa tài khoản Windows** và không xóa lịch sử đăng nhập trong Event Log.

## Cách chạy

1. Đọc nội dung script trước khi chạy.
2. Mở terminal bằng quyền Administrator.
3. Chạy [Clear-LastLogon.bat](Clear-LastLogon.bat).
4. Kiểm tra màn hình đăng nhập sau khi thực hiện.

## Lưu ý

- Chính sách hệ thống hoặc lần đăng nhập tiếp theo có thể ghi lại các giá trị này.
- Thử nghiệm trên máy kiểm tra trước khi triển khai diện rộng.
- Script sửa Registry; chỉ chạy khi đã hiểu tác động và được phép quản trị máy.

[← Về danh mục Windows](README.md) · [← Về trang mục lục sổ tay](../README.md)
