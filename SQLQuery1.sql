---Nhóm 7---
--- --------------------------------------Quản Lý Cửa Hàng Tiện Lợi ------------------------------------------------------------------

-----------------------------------------------------tạo database--------------------------------------------
create database QLCHTL
ON(
	NAME='QLCHTL_DATA',
	FILENAME ='D:\QLCHTL_DATA.mdf',
	SIZE=10MB,
	MAXSIZE=100MB,
	FILEGROWTH=5MB
)
LOG ON(
	NAME='QLCHTL_log',
	FILENAME ='D:\QLCHTL_DATA.ldf',
	SIZE=10MB,
	MAXSIZE=200MB,
	FILEGROWTH=3MB
)
go
USE QLCHTL

go


-----------------------------------------------------tạo bảng dữ liệu--------------------------------------------

--- Bảng NhanVien
create table NhanVien (
    MaNV INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(255),
    NgaySinh DATE,
    GioiTinh NVARCHAR(10) CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    DiaChi NVARCHAR(255),
   SDT VARCHAR(20) NOT NULL UNIQUE,
   Email VARCHAR(255) UNIQUE,
    ChucVu NVARCHAR(50) NOT NULL,
    NgayVaoLam DATE,
     Luong DECIMAL(10, 2) CHECK (Luong > 0)
);

-- Bảng KhachHang
create table KhachHang (
    MaKH INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(255) NOT NULL,
    SDT VARCHAR(20) NOT NULL UNIQUE,
    DiaChi NVARCHAR(255),
    Email VARCHAR(255) UNIQUE,
    DiemTichLuy INT DEFAULT 0
);

-- Bảng NhaCungCap
create table NhaCungCap (
    MaNCC INT IDENTITY(1,1) PRIMARY KEY,
    TenNCC NVARCHAR(255) NOT NULL UNIQUE,
    DiaChi NVARCHAR(255),
    SDT VARCHAR(20) UNIQUE,
    Email VARCHAR(255) UNIQUE
);

-- Bảng LoaiSanPham
create table LoaiSanPham (
    MaLoaiSP INT IDENTITY(1,1) PRIMARY KEY,
    TenLoaiSP NVARCHAR(255) NOT NULL,
    MoTa NVARCHAR(MAX)
);

-- Bảng SanPham
create table SanPham (
    MaSP INT IDENTITY(1,1) PRIMARY KEY,
    TenSP NVARCHAR(255) NOT NULL,
    MaLoaiSP INT NOT NULL,
    MaNCC INT NOT NULL,
    DonViTinh NVARCHAR(50) NOT NULL,
    GiaNhap DECIMAL(10, 2) NOT NULL CHECK (GiaNhap >= 0),
    GiaBan DECIMAL(10, 2) NOT NULL CHECK (GiaBan >= 0),
    SoLuongTonKho INT NOT NULL CHECK (SoLuongTonKho >= 0) DEFAULT 0,
    HanSuDung DATE,
    MoTa NVARCHAR(MAX),
    FOREIGN KEY (MaLoaiSP) REFERENCES LoaiSanPham(MaLoaiSP),
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);

-- Bảng KhuyenMai
create table KhuyenMai (
    MaKM INT IDENTITY(1,1) PRIMARY KEY,
    TenKM NVARCHAR(40),
    NgayBatDau DATE,
    NgayKetThuc DATE,
    PhanTramGiamGia DECIMAL(5, 2) CHECK (PhanTramGiamGia BETWEEN 0 AND 100),
    MoTa NVARCHAR(MAX)
);

-- Bảng ChiTietKhuyenMai
create table ChiTietKhuyenMai (
    MaKM INT NOT NULL,
    MaSP INT NOT NULL,
    PRIMARY KEY (MaKM, MaSP),
    FOREIGN KEY (MaKM) REFERENCES KhuyenMai(MaKM),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- Bảng HoaDonBan
create table HoaDonBan (
    MaHDBan INT IDENTITY(1,1) PRIMARY KEY,
    MaNV INT NOT NULL,
    MaKH INT NOT NULL,
    NgayBan DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(10, 2) NOT NULL CHECK (TongTien >= 0),
    DiemSuDung INT DEFAULT 0 CHECK (DiemSuDung >= 0),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- Bảng ChiTietHDBan
create table ChiTietHDBan (
    MaHDBan INT NOT NULL,
    MaSP INT NOT NULL,
      SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(10, 2) NOT NULL CHECK (DonGia >= 0),
    ThanhTien DECIMAL(10, 2) NOT NULL CHECK (ThanhTien >= 0),
    PRIMARY KEY (MaHDBan, MaSP),
    FOREIGN KEY (MaHDBan) REFERENCES HoaDonBan(MaHDBan),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- Bảng HoaDonNhap
create table HoaDonNhap (
    MaHDNhap INT IDENTITY(1,1) PRIMARY KEY,
    MaNV INT NOT NULL,
    MaNCC INT NOT NULL,
    NgayNhap DATETIME NOT NULL DEFAULT GETDATE(),
    TongTien DECIMAL(10, 2) NOT NULL CHECK (TongTien >= 0),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);

-- Bảng ChiTietHDNhap
create table ChiTietHDNhap (
   MaHDNhap INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(10, 2) NOT NULL CHECK (DonGia >= 0),
    ThanhTien DECIMAL(10, 2) NOT NULL CHECK (ThanhTien >= 0),
    PRIMARY KEY (MaHDNhap, MaSP),
    FOREIGN KEY (MaHDNhap) REFERENCES HoaDonNhap(MaHDNhap),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- Bảng PhieuKiemKho
create table PhieuKiemKho (
    MaPhieuKK INT IDENTITY(1,1) PRIMARY KEY,
    MaNV INT NOT NULL,
    NgayKiemKho DATETIME NOT NULL DEFAULT GETDATE(),
    MoTa NVARCHAR(MAX),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- Bảng ChiTietPhieuKiemKho
create table ChiTietPhieuKiemKho (
     MaPhieuKK INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuongThucTe INT NOT NULL CHECK (SoLuongThucTe >= 0),
    SoLuongHeThong INT NOT NULL CHECK (SoLuongHeThong >= 0),
    ChenhLech INT NOT NULL,
    PRIMARY KEY (MaPhieuKK, MaSP),
    FOREIGN KEY (MaPhieuKK) REFERENCES PhieuKiemKho(MaPhieuKK),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);
go



-----------------------------------------------------thêm dữ liệu vào bảng --------------------------------------------
-- Bảng NhanVien
INSERT INTO NhanVien (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, Email, ChucVu, NgayVaoLam, Luong) VALUES
(N'Nguyễn Văn A', '1990-05-15', N'Nam', N'123 Đường Trần Phú, Hà Nội', '0901234567', 'an.nguyen@email.com', N'Quản lý', '2020-08-01', 15000000),
(N'Trần Thị B', '1992-11-20', N'Nữ', N'456 Phố Huế, Hà Nội', '0987654321', 'b.tran@email.com', N'Nhân viên bán hàng', '2021-03-10', 8000000),
(N'Lê Văn C', '1988-07-05', N'Nam', N'789 Đường Giải Phóng, Hà Nội', '0912345678', 'c.le@email.com', N'Kế toán', '2022-01-15', 10000000),
(N'Phạm Thị D', '1995-02-28', N'Nữ', N'1011 Đường Láng, Hà Nội', '0978901234', 'd.pham@email.com', N'Thu ngân', '2022-05-20', 7500000),
(N'Hoàng Văn E', '1991-09-10', N'Nam', N'1213 Đường Tây Sơn, Hà Nội', '0934567890', 'e.hoang@email.com', N'Nhân viên kho', '2023-07-01', 8500000),
(N'Vũ Thị F', '1993-04-01', N'Nữ', N'1415 Đường Nguyễn Trãi, Hà Nội', '0965432109', 'f.vu@email.com', N'Marketing', '2023-11-05', 9500000),
(N'Đặng Văn G', '1989-12-25', N'Nam', N'1617 Đường Trường Chinh, Hà Nội', '0941234567', 'g.dang@email.com', N'IT', '2024-02-10', 12000000),
(N'Bùi Thị H', '1994-06-30', N'Nữ', N'1819 Đường Đại Cồ Việt, Hà Nội', '0928765432', 'h.bui@email.com', N'Chăm sóc khách hàng', '2024-06-15', 8200000),
(N'Cao Văn I', '1996-01-20', N'Nam', N'2021 Đường Kim Mã, Hà Nội', '0909876543', 'i.cao@email.com', N'Bảo vệ', '2024-09-01', 7000000),
(N'Mai Thị K', '1992-08-12', N'Nữ', N'2223 Đường Lạc Long Quân, Hà Nội', '0977654321', 'k.mai@email.com', N'Thực tập sinh', '2025-01-05', 5000000);

-- Bảng KhachHang
INSERT INTO KhachHang (HoTen, SDT, DiaChi, Email, DiemTichLuy) VALUES
(N'Lê Thị M', '0903123456', N'30 Đường Bà Triệu, Hà Nội', 'm.le@email.com', 150),
(N'Phan Văn N', '0988765432', N'60 Phố Tràng Thi, Hà Nội', 'n.phan@email.com', 200),
(N'Hoàng Thị O', '0911223344', N'90 Đường Hai Bà Trưng, Hà Nội', 'o.hoang@email.com', 100),
(N'Trịnh Văn P', '0977889900', N'120 Đường Nguyễn Du, Hà Nội', 'p.trinh@email.com', 250),
(N'Vũ Thị Q', '0933445566', N'150 Đường Lý Thường Kiệt, Hà Nội', 'q.vu@email.com', 180),
(N'Ngô Văn R', '0966554433', N'180 Đường Trần Hưng Đạo, Hà Nội', 'r.ngo@email.com', 220),
(N'Bùi Thị S', '0944667788', N'210 Đường Quang Trung, Hà Nội', 's.bui@email.com', 160),
(N'Đào Văn T', '0922778899', N'240 Đường Tây Hồ, Hà Nội', 't.dao@email.com', 190),
(N'Lâm Thị U', '0909998877', N'270 Đường Âu Cơ, Hà Nội', 'u.lam@email.com', 230),
(N'Hà Văn V', '0981112233', N'300 Đường Láng Hạ, Hà Nội', 'v.ha@email.com', 170);

-- Bảng NhaCungCap
INSERT INTO NhaCungCap (TenNCC, DiaChi, SDT, Email) VALUES
(N'Công ty ABC', N'Khu công nghiệp X, Hà Nội', '0241234567', 'info@abc.com'),
(N'Nhà cung cấp XYZ', N'Khu công nghiệp Y, Hà Nội', '0249876543', 'sales@xyz.vn'),
(N'Doanh nghiệp 123', N'Thành phố Hồ Chí Minh', '0281122334', 'contact@123.net'),
(N'Đơn vị Thương Mại 456', N'Đà Nẵng', '0236556677', 'support@456.org'),
(N'Tổ chức Bán Lẻ 789', N'Hải Phòng', '0225990011', 'marketing@789.com.vn'),
(N'Công ty Sản Xuất A', N'Bắc Ninh', '0222334455', 'order@sanxuatA.com'),
(N'Nhà phân phối B', N'Hưng Yên', '0221667788', 'distribute@phanphoiB.vn'),
(N'Xưởng Chế Tạo C', N'Vĩnh Phúc', '0211990088', 'factoryC@chetao.net'),
(N'Tổng công ty D', N'Thái Nguyên', '0208112299', 'general@tongcongtyD.org'),
(N'Hợp tác xã E', N'Hà Nam', '0226554433', 'cooperativeE@hoptac.com');

-- Bảng LoaiSanPham
INSERT INTO LoaiSanPham (TenLoaiSP, MoTa) VALUES
(N'Điện tử', N'Các sản phẩm điện tử gia dụng và cá nhân'),
(N'Gia dụng', N'Đồ dùng trong nhà'),
(N'Thực phẩm', N'Các loại thực phẩm và đồ uống'),
(N'Thời trang', N'Quần áo, giày dép và phụ kiện'),
(N'Sách', N'Các loại sách và tạp chí'),
(N'Đồ chơi', N'Đồ chơi cho trẻ em'),
(N'Mỹ phẩm', N'Sản phẩm chăm sóc sắc đẹp'),
(N'Văn phòng phẩm', N'Đồ dùng văn phòng'),
(N'Dụng cụ thể thao', N'Các sản phẩm phục vụ thể dục thể thao'),
(N'Đồ dùng cá nhân', N'Các vật dụng cá nhân hàng ngày');

-- Bảng SanPham
INSERT INTO SanPham (TenSP, MaLoaiSP, MaNCC, DonViTinh, GiaNhap, GiaBan, SoLuongTonKho, HanSuDung, MoTa) VALUES
(N'Tivi Samsung Smart 4K 55 inch', 1, 1, N'Chiếc', 8000000, 12000000, 50, NULL, N'Tivi thông minh màn hình lớn'),
(N'Nồi cơm điện Sharp 1.8L', 2, 2, N'Chiếc', 300000, 500000, 100, NULL, N'Nồi cơm điện dung tích lớn'),
(N'Mì gói Hảo Hảo', 3, 3, N'Thùng', 60000, 90000, 200, '2025-07-30', N'Mì ăn liền phổ biến'),
(N'Áo sơ mi nam trắng', 4, 4, N'Chiếc', 150000, 250000, 80, NULL, N'Áo sơ mi công sở'),
(N'Sách Đắc Nhân Tâm', 5, 5, N'Cuốn', 50000, 80000, 150, NULL, N'Sách self-help nổi tiếng'),
(N'Ô tô đồ chơi điều khiển', 6, 6, N'Chiếc', 200000, 350000, 70, NULL, N'Ô tô điều khiển từ xa'),
(N'Kem chống nắng Sunplay SPF50+', 7, 7, N'Chai', 80000, 120000, 120, '2026-03-15', N'Kem chống nắng hiệu quả'),
(N'Bút bi Thiên Long', 8, 8, N'Hộp', 25000, 40000, 300, NULL, N'Bút bi chất lượng tốt'),
(N'Giày đá bóng Adidas', 9, 9, N'Đôi', 500000, 800000, 60, NULL, N'Giày đá bóng chuyên nghiệp'),
(N'Bàn chải đánh răng Oral-B', 10, 10, N'Cây', 20000, 35000, 250, NULL, N'Bàn chải đánh răng mềm');

-- Bảng KhuyenMai
INSERT INTO KhuyenMai (TenKM, NgayBatDau, NgayKetThuc, PhanTramGiamGia, MoTa) VALUES
(N'Giảm giá cuối tuần', '2025-04-12', '2025-04-13', 15.00, N'Giảm 15% cho tất cả sản phẩm vào cuối tuần'),
(N'Khuyến mãi tháng 5', '2025-05-01', '2025-05-31', 10.00, N'Giảm 10% cho đơn hàng trên 500.000 VNĐ'),
(N'Mua 1 tặng 1', '2025-04-15', '2025-04-20', NULL, N'Mua một sản phẩm tặng một sản phẩm cùng loại'),
(N'Giảm đặc biệt cho thành viên', '2025-04-08', '2025-04-30', 20.00, N'Giảm 20% cho khách hàng có thẻ thành viên'),
(N'Ngày hội mua sắm', '2025-04-25', '2025-04-27', 25.00, N'Giảm giá sốc trong 3 ngày'),
(N'Chào hè rực rỡ', '2025-06-01', '2025-06-30', 12.00, N'Giảm 12% cho các sản phẩm mùa hè'),
(N'Black Friday sớm', '2025-11-01', '2025-11-30', 30.00, N'Giảm 30% cho một số mặt hàng'),
(N'Sinh nhật cửa hàng', '2025-07-15', '2025-07-20', 18.00, N'Giảm 18% nhân dịp sinh nhật cửa hàng'),
(N'Xả hàng cuối năm', '2025-12-20', '2025-12-31', 35.00, N'Giảm giá mạnh cuối năm'),
(N'Ưu đãi đặc biệt', '2025-04-10', '2025-04-15', 5.00, N'Giảm thêm 5% khi thanh toán online');

-- Bảng ChiTietKhuyenMai
INSERT INTO ChiTietKhuyenMai (MaKM, MaSP) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10);


-- Bảng HoaDonBan
INSERT INTO HoaDonBan (MaNV, MaKH, NgayBan, TongTien, DiemSuDung) VALUES
(1, 1, GETDATE(), 11400000, 0),
(2, 2, DATEADD(day, -1, GETDATE()), 450000, 10),
(3, 3, DATEADD(day, -2, GETDATE()), 72000, 5),
(4, 4, DATEADD(day, -3, GETDATE()), 225000, 15),
(5, 5, DATEADD(day, -4, GETDATE()), 315000, 0),
(6, 6, DATEADD(day, -5, GETDATE()), 108000, 20),
(7, 7, DATEADD(day, -6, GETDATE()), 84000, 0),
(8, 8, DATEADD(day, -7, GETDATE()), 36000, 10),
(9, 9, DATEADD(day, -8, GETDATE()), 760000, 25),
(10, 10, DATEADD(day, -9, GETDATE()), 31500, 0);

-- Bảng ChiTietHDBan
INSERT INTO ChiTietHDBan (MaHDBan, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(1, 1, 1, 12000000, 12000000),
(2, 2, 1, 500000, 500000),
(3, 3, 1, 90000, 90000),
(4, 4, 1, 250000, 250000),
(5, 5, 1, 80000, 80000),
(6, 6, 1, 350000, 350000),
(7, 7, 1, 120000, 120000),
(8, 8, 1, 40000, 40000),
(9, 9, 1, 800000, 800000),
(10, 10, 1, 35000, 35000);


-- Tiếp tục bảng HoaDonNhap
INSERT INTO HoaDonNhap (MaNV, MaNCC, NgayNhap, TongTien) VALUES
(2, 1, DATEADD(day, -10, GETDATE()), 7200000),
(3, 2, DATEADD(day, -11, GETDATE()), 15000000),
(4, 3, DATEADD(day, -12, GETDATE()), 540000),
(5, 4, DATEADD(day, -13, GETDATE()), 1200000),
(6, 5, DATEADD(day, -14, GETDATE()), 2100000),
(7, 6, DATEADD(day, -15, GETDATE()), 4800000),
(8, 7, DATEADD(day, -16, GETDATE()), 900000),
(9, 8, DATEADD(day, -17, GETDATE()), 10500000),
(10, 9, DATEADD(day, -18, GETDATE()), 3600000),
(1, 10, DATEADD(day, -19, GETDATE()), 1800000);

-- Bảng ChiTietHDNhap
INSERT INTO ChiTietHDNhap (MaHDNhap, MaSP, SoLuong, DonGia, ThanhTien) VALUES
(1, 1, 10, 720000, 7200000),
(2, 2, 30, 500000, 15000000),
(3, 3, 60, 9000, 540000),
(4, 4, 8, 150000, 1200000),
(5, 5, 30, 70000, 2100000),
(6, 6, 20, 240000, 4800000),
(7, 7, 15, 60000, 900000),
(8, 8, 50, 210000, 10500000),
(9, 9, 8, 450000, 3600000),
(10, 10, 90, 20000, 1800000);

-- Bảng PhieuKiemKho
INSERT INTO PhieuKiemKho (MaNV, NgayKiemKho, MoTa) VALUES
(1, GETDATE(), N'Kiểm kê hàng hóa định kỳ'),
(2, DATEADD(day, -5, GETDATE()), N'Kiểm tra số lượng hàng hóa sau nhập kho'),
(3, DATEADD(day, -10, GETDATE()), N'Kiểm kê đột xuất'),
(4, DATEADD(day, -15, GETDATE()), N'Kiểm tra hàng hóa sắp hết hạn'),
(5, DATEADD(day, -20, GETDATE()), N'Kiểm kê hàng hóa cuối tháng'),
(6, DATEADD(day, -25, GETDATE()), N'Kiểm tra hàng hóa bị lỗi'),
(7, DATEADD(day, -30, GETDATE()), N'Kiểm kê hàng hóa theo yêu cầu'),
(8, DATEADD(day, -35, GETDATE()), N'Kiểm tra số lượng hàng hóa sau bán'),
(9, DATEADD(day, -40, GETDATE()), N'Kiểm kê hàng hóa đặc biệt'),
(10, DATEADD(day, -45, GETDATE()), N'Kiểm tra hàng hóa tồn kho');

-- Bảng ChiTietPhieuKiemKho
INSERT INTO ChiTietPhieuKiemKho (MaPhieuKK, MaSP, SoLuongThucTe, SoLuongHeThong, ChenhLech) VALUES
(1, 1, 50, 50, 0),
(1, 2, 102, 100, 2),
(2, 3, 200, 200, 0),
(2, 4, 78, 80, -2),
(3, 5, 150, 150, 0),
(3, 6, 72, 70, 2),
(4, 7, 118, 120, -2),
(4, 8, 300, 300, 0),
(5, 9, 60, 60, 0),
(5, 10, 248, 250, -2);
 
 go
-----------------------------------------------------query truy vấn các thành phần trong bảng -------------------------------------

--- store proucedure

-----------TimKiemSanPhamTheoTen-------------
create PROCEDURE sp_TimKiemSanPhamTheoTen (
    @TenSP NVARCHAR(255)
)
AS
BEGIN
    SELECT *
    FROM SanPham
    WHERE TenSP LIKE N'%' + @TenSP + N'%';
END
go

-----------sp_LayThongTinHoaDonBan-------------
create PROCEDURE sp_LayThongTinHoaDonBan (
    @MaHDBan INT
)
AS
BEGIN
    SELECT
        hdb.MaHDBan,
        nv.HoTen AS TenNhanVien,
        kh.HoTen AS TenKhachHang,
        hdb.NgayBan,
        ct.MaSP,
        sp.TenSP,
        ct.SoLuong,
        ct.DonGia,
        ct.ThanhTien,
        hdb.TongTien,
        hdb.DiemSuDung
    FROM HoaDonBan hdb
    INNER JOIN NhanVien nv ON hdb.MaNV = nv.MaNV
    INNER JOIN KhachHang kh ON hdb.MaKH = kh.MaKH
    INNER JOIN ChiTietHDBan ct ON hdb.MaHDBan = ct.MaHDBan
    INNER JOIN SanPham sp ON ct.MaSP = sp.MaSP
    WHERE hdb.MaHDBan = @MaHDBan;
END
go

-----------ThemNhanVien-------------
CREATE PROCEDURE sp_ThemNhanVien (
    @HoTen NVARCHAR(255),
    @NgaySinh DATE,
    @GioiTinh NVARCHAR(10),
    @DiaChi NVARCHAR(255),
    @SDT VARCHAR(20),
    @Email VARCHAR(255),
    @ChucVu NVARCHAR(50),
    @NgayVaoLam DATE,
    @Luong DECIMAL(10, 2)
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE SDT = @SDT)
    BEGIN
        IF @Email IS NULL OR NOT EXISTS (SELECT 1 FROM NhanVien WHERE Email = @Email)
        BEGIN
            INSERT INTO NhanVien (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, Email, ChucVu, NgayVaoLam, Luong)
            VALUES (@HoTen, @NgaySinh, @GioiTinh, @DiaChi, @SDT, @Email, @ChucVu, @NgayVaoLam, @Luong);
        END
        ELSE
        BEGIN
            RAISERROR('Email đã tồn tại.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        RAISERROR('Số điện thoại đã tồn tại.', 16, 1);
        RETURN;
    END
END
go


CREATE PROCEDURE sp_ApDungKhuyenMaiChoSanPham (
    @MaKM INT,
    @DanhSachMaSP VARCHAR(MAX) -- Chuỗi các MaSP cách nhau bởi dấu phẩy
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM KhuyenMai WHERE MaKM = @MaKM)
    BEGIN
        RAISERROR('Mã khuyến mãi không tồn tại.', 16, 1);
        RETURN;
    END

    -- Tách chuỗi MaSP thành các giá trị riêng lẻ
    DECLARE @MaSPTach INT;
    DECLARE @DanhSachMaSPTach TABLE (MaSP INT);

    WHILE (LEN(@DanhSachMaSP) > 0)
    BEGIN
        IF (CHARINDEX(',', @DanhSachMaSP) > 0)
        BEGIN
            SELECT @MaSPTach = SUBSTRING(@DanhSachMaSP, 1, CHARINDEX(',', @DanhSachMaSP) - 1);
            SET @DanhSachMaSP = SUBSTRING(@DanhSachMaSP, CHARINDEX(',', @DanhSachMaSP) + 1, LEN(@DanhSachMaSP));
        END
        ELSE
        BEGIN
            SELECT @MaSPTach = @DanhSachMaSP;
            SET @DanhSachMaSP = '';
        END

        IF ISNUMERIC(@MaSPTach) = 1 AND EXISTS (SELECT 1 FROM SanPham WHERE MaSP = CAST(@MaSPTach AS INT))
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM ChiTietKhuyenMai WHERE MaKM = @MaKM AND MaSP = CAST(@MaSPTach AS INT))
            BEGIN
                INSERT INTO ChiTietKhuyenMai (MaKM, MaSP)
                VALUES (@MaKM, CAST(@MaSPTach AS INT));
            END
        END
        ELSE IF ISNUMERIC(@MaSPTach) = 0 AND LEN(TRIM(@MaSPTach)) > 0
        BEGIN
            RAISERROR('Mã sản phẩm không hợp lệ: %s', 16, 1, @MaSPTach);
            RETURN;
        END
        ELSE IF NOT EXISTS (SELECT 1 FROM SanPham WHERE MaSP = CAST(@MaSPTach AS INT)) AND ISNUMERIC(@MaSPTach) = 1
        BEGIN
            RAISERROR('Mã sản phẩm không tồn tại: %s', 16, 1, @MaSPTach);
            RETURN;
        END
    END
END
GO

CREATE PROCEDURE sp_LaySanPhamTheoLoai (
    @MaLoaiSP INT
)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM LoaiSanPham WHERE MaLoaiSP = @MaLoaiSP)
    BEGIN
        SELECT sp.*
        FROM SanPham sp
        WHERE sp.MaLoaiSP = @MaLoaiSP;
    END
    ELSE
    BEGIN
        RAISERROR('Mã loại sản phẩm không tồn tại.', 16, 1);
        RETURN;
    END
END
GO


--- function

----------------------TinhTongTienHoaDonBan
CREATE FUNCTION fn_TinhTongTienHoaDonBan (@MaHDBan INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TongTien DECIMAL(10, 2);

    SELECT @TongTien = SUM(ThanhTien)
    FROM ChiTietHDBan
    WHERE MaHDBan = @MaHDBan;

    RETURN ISNULL(@TongTien, 0);
END
GO

---------------LayTenNhanVien
CREATE FUNCTION fn_LayTenNhanVien (@MaNV INT)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @HoTen NVARCHAR(255);

    SELECT @HoTen = HoTen
    FROM NhanVien
    WHERE MaNV = @MaNV;

    RETURN @HoTen;
END
GO

--- trigger

----------------------CapNhatSoLuongTonKho_ChiTietHDNhap
CREATE TRIGGER trg_CapNhatSoLuongTonKho_ChiTietHDNhap_Insert
ON ChiTietHDNhap
AFTER INSERT
AS
BEGIN
    UPDATE SanPham
    SET SoLuongTonKho = SoLuongTonKho + inserted.SoLuong
    FROM inserted
    WHERE SanPham.MaSP = inserted.MaSP;
END
GO


--------------------------NgayKetThucKhuyenMai
CREATE TRIGGER trg_NgayKetThucKhuyenMai
ON KhuyenMai
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE NgayKetThuc < NgayBatDau)
    BEGIN
        RAISERROR('Ngày kết thúc khuyến mãi không được sớm hơn ngày bắt đầu.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END
GO


------------------------CapNhatThanhTienChiTietHDBan
CREATE TRIGGER trg_CapNhatThanhTienChiTietHDBan_InsertUpdate
ON ChiTietHDBan
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE ChiTietHDBan
    SET ThanhTien = inserted.SoLuong * inserted.DonGia
    FROM inserted
    WHERE ChiTietHDBan.MaHDBan = inserted.MaHDBan AND ChiTietHDBan.MaSP = inserted.MaSP;
END
GO

---------------------------------------------------------------end----------------------------------------