# Sổ tay quản trị Ubuntu — WebASS-MN

> Tổng hợp từ cuộc trao đổi ngày 09/10/2026. Phân biệt cấu hình **đã xác nhận** với **đường dẫn/ví dụ cần kiểm tra**. Không lưu mật khẩu thực vào tài liệu này.

## Thông tin server
- Hostname: `WebASS-MN`
- IP: `10.233.8.40`
- Tài khoản quản trị: `admin.thanhnh17`
- Hệ điều hành: Ubuntu Server
- Web: Nginx, .NET 10 / Blazor; database PostgreSQL
- Kết nối client qua HTTPS cổng `443`
- Web folder đã quan sát: `/var/www/webapp/index.html`; đồng thời tồn tại `/var/www/html/`.

## 1. Cấu hình web
- Nginx tổng: `/etc/nginx/nginx.conf`
- Site definitions: `/etc/nginx/sites-available/`
- Site đang bật: `/etc/nginx/sites-enabled/`
- Web content: `/var/www/webapp/`
- Logs: `/var/log/nginx/access.log`, `/var/log/nginx/error.log`

Kiểm tra Nginx đang chạy web tĩnh hay reverse proxy:
```bash
sudo nginx -T 2>/dev/null | grep -nE 'server_name|listen|root|proxy_pass|ssl_certificate'
ls -lah /etc/nginx/sites-available/ /etc/nginx/sites-enabled/
```
Kiểm tra rồi reload sau khi chỉnh sửa:
```bash
sudo nginx -t && sudo systemctl reload nginx
```

## 2. Chứng chỉ HTTPS / SSL
- Thư mục CA/certificate thông dụng: `/etc/ssl/certs/`
- Private key thông dụng: `/etc/ssl/private/`
- Nếu dùng Certbot: `/etc/letsencrypt/live/`
- File chính xác Nginx đang dùng **chưa được xác nhận**; kiểm tra:
```bash
sudo nginx -T 2>/dev/null | grep -E 'ssl_certificate|ssl_certificate_key'
```
- Kiểm tra thời hạn cert sau khi tìm được đường dẫn:
```bash
sudo openssl x509 -in /DUONG_DAN/CERT.crt -noout -subject -issuer -dates
```
- Không lưu private key trong Git hoặc thư mục public web.

## 3. SMB shares
Windows SMB server: `10.235.64.19`.

| Windows share | Ubuntu mount | Tình trạng trong cuộc trao đổi |
|---|---|---|
| `\\\\10.235.64.19\\HinhanhCH` | `/mnt/HinhanhCH` | Đã mount thành công |
| `\\\\10.235.64.19\\Zip` | `/mnt/Backup40F` | Đã mount thành công (100G, còn 20G lúc kiểm tra) |
| `\\\\10.235.64.19\\ModelHelpdesk` | `/mnt/ModelAI` | Đã hướng dẫn cấu hình, chưa có kết quả xác nhận |

Kiểm tra:
```bash
findmnt -t cifs
df -hT | grep cifs
ls -lah /mnt/HinhanhCH /mnt/Backup40F /mnt/ModelAI
```

## 4. SMB credentials
Đường dẫn: `/etc/samba/admin.thanhnh17.cred`.
```ini
username=admin.thanhnh17
password=<MAT_KHAU_AD_HIEN_TAI>
domain=MASAN
```
Tạo/sửa bằng `sudo nano /etc/samba/admin.thanhnh17.cred`.
Bảo vệ:
```bash
sudo chown root:root /etc/samba/admin.thanhnh17.cred
sudo chmod 600 /etc/samba/admin.thanhnh17.cred
sudo ls -l /etc/samba/admin.thanhnh17.cred
```
Mật khẩu AD đổi 60 ngày/lần; phải cập nhật credentials và tái tạo kết nối SMB lúc an toàn. Việc sửa file không đổi thông tin xác thực của mount hiện hữu. Không chạy `cat`/dán nội dung chứa password vào log hoặc chat.

## 5. Tự động mount trong /etc/fstab
Sao lưu trước khi sửa:
```bash
sudo cp -a /etc/fstab /etc/fstab.bak
sudo nano /etc/fstab
```
Các dòng **mẫu** (kiểm tra tránh trùng trước khi thêm):
```fstab
//10.235.64.19/HinhanhCH /mnt/HinhanhCH cifs credentials=/etc/samba/admin.thanhnh17.cred,vers=3.0,_netdev,nofail,x-systemd.automount 0 0
//10.235.64.19/Zip /mnt/Backup40F cifs credentials=/etc/samba/admin.thanhnh17.cred,vers=3.0,_netdev,nofail,x-systemd.automount 0 0
//10.235.64.19/ModelHelpdesk /mnt/ModelAI cifs credentials=/etc/samba/admin.thanhnh17.cred,vers=3.0,_netdev,nofail,x-systemd.automount 0 0
```
Áp dụng/kiểm tra:
```bash
sudo systemctl daemon-reload
sudo mount -a
findmnt --verify --verbose
findmnt -t cifs
```
`x-systemd.automount` tạo autofs và kích hoạt SMB khi truy cập. Tránh mount thủ công trùng và không force unmount khi app đang sử dụng.

## 6. Secrets của ứng dụng .NET
- Không commit password/API keys vào `appsettings.json` public source.
- Đề xuất riêng: `/etc/webass/secrets.json` (chưa xác nhận đã tạo).
- Ví dụ cấu hình:
```json
{"Database":{"Password":"<SECRET>"},"Api":{"SecretKey":"<SECRET>"}}
```
- Nếu app chạy với user/group `webass` thực tế:
```bash
sudo chown root:webass /etc/webass/secrets.json
sudo chmod 640 /etc/webass/secrets.json
```
- Nạp trong C#:
```csharp
builder.Configuration.AddJsonFile("/etc/webass/secrets.json", optional: false, reloadOnChange: true);
```
- Chỉ dùng ở server; không expose secrets qua Blazor WebAssembly hoặc API response. File vẫn là plaintext trên disk; với yêu cầu bảo mật cao nên dùng secret manager.

## 7. Lệnh kiểm tra dịch vụ
```bash
hostnamectl
systemctl status nginx postgresql --no-pager
sudo nginx -t
sudo ss -lntp | grep -E ':443|:5432|:9090'
findmnt -t cifs
```

## 8. Ghi chú cần xác minh sau
- Tên file Nginx site đang hoạt động và `proxy_pass` đến .NET.
- Đường dẫn chứng chỉ HTTPS và private key thực tế.
- Tên service systemd chạy Blazor/.NET và tài khoản Linux chạy service.
- Nội dung `/etc/fstab` thực tế, tránh khai báo trùng.
- Mount `/mnt/ModelAI` đã hoạt động chưa.

---

## CẬP NHẬT 09/10/2026 — Xác nhận từ kết quả thực tế trên server

### Nginx và SSL (đã xác nhận)
- Cấu hình site: `/etc/nginx/sites-available/webapp`.
- Symlink site đang bật: `/etc/nginx/sites-enabled/webapp` → `/etc/nginx/sites-available/webapp`.
- Nginx lắng nghe `443 ssl` và `[::]:443 ssl`, `server_name _`.
- Chứng chỉ: `/etc/nginx/ssl/webass.crt`.
- Private key: `/etc/nginx/ssl/webass.key` (KHÔNG sao chép vào Git).
- Web root: `/var/www/webapp`, hiện có `index.html`.
- Có `proxy_pass https://127.0.0.1:9090` (Cockpit); chưa biết `location` cụ thể do output đã lọc.
- Thư mục `/var/www/webapp` thuộc `www-data:www-data`; `index.html` thuộc `root:root`, quyền đọc công khai.

### SMB đang mount (đã xác nhận bằng `findmnt -t cifs`)
| Share Windows | Mount Ubuntu | Trạng thái |
|---|---|---|
| `//10.235.64.19/HinhanhCH` | `/mnt/HinhanhCH` | CIFS rw, SMB 3.0 |
| `//10.235.64.19/Zip` | `/mnt/Backup40F` | CIFS rw, SMB 3.0 |
| `//10.235.64.19/ModelHelpdesk` | `/mnt/ModelAI` | CIFS rw, SMB 3.0 |

- `/mnt/ModelAI` chứa: `models`, `Modules`, `phanloai_yeucau.csv`, `phanvung.csv`.
- Tất cả mount đang hiển thị `uid=0,gid=0` (root); cần xem xét quyền cho user chạy ứng dụng trước khi yêu cầu .NET ghi dữ liệu.
- `/etc/fstab` có các mục `HinhanhCH` và `Backup40F`, nhưng kết quả grep chỉ hiện phần đầu của dòng (chưa xác minh đầy đủ tùy chọn).
- **Chưa có mục `/mnt/ModelAI` trong kết quả `/etc/fstab`**: đã mount thủ công nhưng chưa xác nhận tự mount sau reboot.

### Bổ sung tự mount cho ModelAI (kiểm tra trùng trước khi thêm)
```bash
sudo grep -n 'ModelHelpdesk\|ModelAI' /etc/fstab
sudo nano /etc/fstab
```
Thêm đúng **một** dòng nếu chưa tồn tại:
```fstab
//10.235.64.19/ModelHelpdesk /mnt/ModelAI cifs credentials=/etc/samba/admin.thanhnh17.cred,vers=3.0,_netdev,nofail,x-systemd.automount 0 0
```
Vì ModelAI đang mount thủ công, nên không cố mount đè lên hoặc ép unmount khi ứng dụng đang dùng. Để áp dụng an toàn, kiểm tra `sudo findmnt --verify --verbose` và `sudo systemctl daemon-reload`; sau đó lên lịch chuyển mount sang systemd automount khi không có ứng dụng truy cập, hoặc reboot trong cửa sổ bảo trì. Kiểm tra sau reboot bằng `ls /mnt/ModelAI` và `findmnt -t cifs`.

### Lệnh đọc cấu hình chi tiết nhưng không xuất secrets
```bash
sudo sed -n '1,240p' /etc/nginx/sites-available/webapp
sudo findmnt --verify --verbose
sudo systemctl status nginx --no-pager
sudo systemctl status cockpit.socket --no-pager
```
Lưu ý: nếu chia sẻ nội dung file cấu hình, rà soát và ẩn mật khẩu, token, private key trước.

### Những mục chưa xác minh
- Nội dung đầy đủ `/etc/nginx/sites-available/webapp` (đặc biệt `location`).
- Nội dung đầy đủ các dòng SMB trong `/etc/fstab`.
- Quyền và nội dung thực tế của `/etc/samba/admin.thanhnh17.cred` (không in mật khẩu).
- `/etc/webass/secrets.json` có tồn tại hay chưa; đây là đề xuất bảo mật cho .NET, không phải cấu hình đã xác nhận.
