# Sổ tay IT & Script

> Trang mục lục tập trung cho các script, câu lệnh và ghi chú vận hành. Chọn nhóm bên dưới để tra cứu nhanh; mỗi nhóm có README riêng và liên kết đến các tài liệu hiện có.

## Tổng quan thư mục

| Nhóm | Nội dung | Đi đến |
|---|---|---|
| **Windows** | CMD, Registry, dịch vụ Windows, domain và script quản trị | [Mở thư mục Windows](Windows/README.md) |
| **PowerShell** | Tự động hóa quản trị, phần mềm, tài khoản và mạng | [Mở thư mục PowerShell](PowerShell/README.md) |
| **Linux** | Ubuntu Server, Nginx, systemd, SMB/CIFS và vận hành server | [Mở thư mục Linux](Linux/README.md) |
| **Network** | FortiGate, DNS, VPN và SD-WAN | [Mở thư mục Network](Network/README.md) |
| **CSharp** | C# snippets, API và Blazor | [Mở thư mục CSharp](CSharp/README.md) |
| **SQL** | PostgreSQL, truy vấn và hàm SQL | [Mở thư mục SQL](SQL/README.md) |
| **Tools** | Tiện ích và các script hoàn chỉnh dùng chung | [Mở thư mục Tools](Tools/README.md) |

## Sơ đồ nhanh

```text
Script/
├── CSharp/
│   └── README.md
├── Linux/
│   └── README.md
├── Network/
│   └── README.md
├── PowerShell/
│   └── README.md
├── SQL/
│   └── README.md
├── Tools/
│   └── README.md
├── Windows/
│   ├── Clear-LastLogon.bat
│   ├── Clear-LastLogon.md
│   └── README.md
├── docs/
│   └── WebASS-MN-Ubuntu-Notes.md
└── README.md
```

## Tài liệu nổi bật

### Linux / Ubuntu

- [Sổ tay quản trị Ubuntu — WebASS-MN](docs/WebASS-MN-Ubuntu-Notes.md) — ghi chú Nginx, HTTPS/SSL, SMB/CIFS, `/etc/fstab`, systemd và cấu hình ứng dụng .NET.
- [Danh mục Linux](Linux/README.md) — lối vào các ghi chú và lệnh quản trị Linux.

### Windows

- [Clear Last Logon](Windows/Clear-LastLogon.md) — hướng dẫn và lưu ý khi xóa các giá trị hiển thị tài khoản đăng nhập gần nhất trên màn hình Windows.
- [Script Clear-LastLogon.bat](Windows/Clear-LastLogon.bat) — tệp lệnh đi kèm.

## Quy ước bổ sung tài liệu

1. Đặt script trong thư mục theo nền tảng hoặc mục đích.
2. Với script cần hướng dẫn, tạo một tệp Markdown cùng tên, ví dụ `TenScript.ps1` và `TenScript.md`.
3. Trong README của thư mục, thêm liên kết đến từng script/tài liệu kèm mô tả ngắn, yêu cầu quyền và cách chạy.
4. Khi thêm nhóm mới hoặc tài liệu quan trọng, cập nhật lại trang mục lục này.
5. Không lưu mật khẩu, token, private key hoặc thông tin xác thực thật trong Git.

---
*Cập nhật mục lục: 14/10/2026.*
