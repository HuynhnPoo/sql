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
(N'Nguyễn Văn A', '1990-05-15', N'Nam', N'Hà Nội', '0901234567', 'an.nguyen@email.com', N'Quản lý', '2020-08-01', 15000000),
(N'Trần Thị B', '1992-11-20', N'Nữ', N'Hà Nội', '0987654321', 'b.tran@email.com', N'Nhân viên bán hàng', '2021-03-10', 8000000),
(N'Lê Văn C', '1988-07-05', N'Nam', N' Hà Nội', '0912345678', 'c.le@email.com', N'Kế toán', '2022-01-15', 10000000),
(N'Phạm Thị D', '1995-02-28', N'Nữ', N'Nam Định', '0978901234', 'd.pham@email.com', N'Thu ngân', '2022-05-20', 7500000),
(N'Hoàng Văn E', '1991-09-10', N'Nam', N'Thái Bình', '0934567890', 'e.hoang@email.com', N'Nhân viên kho', '2023-07-01', 8500000),
(N'Vũ Thị F', '1993-04-01', N'Nữ', N' HCM', '0965432109', 'f.vu@email.com', N'Marketing', '2023-11-05', 9500000),
(N'Đặng Văn G', '1989-12-25', N'Nam', N' Bắc Ninh', '0941234567', 'g.dang@email.com', N'IT', '2024-02-10', 12000000),
(N'Bùi Thị H', '1994-06-30', N'Nữ', N'Bắc Giang', '0928765432', 'h.bui@email.com', N'Chăm sóc khách hàng', '2024-06-15', 8200000),
(N'Cao Văn I', '1996-01-20', N'Nam', N'Hà Nam', '0909876543', 'i.cao@email.com', N'Bảo vệ', '2024-09-01', 7000000),
(N'Lê Văn G', '1992-11-18', N'Nam', N'HCM', '0901111001', 'g.le@email.com', N'Nhân viên bán hàng', '2023-01-15', 8200000),
(N'Phạm Thị H', '1987-05-03', N'Nữ', N'Lạng Sơn', '0982222002', 'h.pham@email.com', N'Kế toán', '2021-07-20', 9500000),
(N'Hoàng Văn I', '1995-09-25', N'Nam', N'Lai Châu', '0913333003', 'i.hoang@email.com', N'Thu ngân', '2024-03-10', 7000000),
(N'Trần Thị K', '1990-03-12', N'Nữ', N'Cao Bằng', '0974444004', 'k.tran@email.com', N'Nhân viên kho', '2022-09-05', 7800000),
(N'Vũ Văn L', '1998-07-01', N'Nam', N'Hưng Yên', '0935555005', 'l.vu@email.com', N'Marketing', '2025-01-01', 9000000),
(N'Đặng Thị M', '1983-12-10', N'Nữ', N'Yên bái', '0966666006', 'm.dang@email.com', N'IT', '2020-11-20', 12500000),
(N'Bùi Văn N', '1996-04-17', N'Nam', N'Ninh Bình', '0947777007', 'n.bui@email.com', N'Chăm sóc khách hàng', '2023-05-25', 8000000),
(N'Cao Thị O', '1991-08-28', N'Nữ', N' Hà Nội', '0928888008', 'o.cao@email.com', N'Bảo vệ', '2024-08-15', 6800000),
(N'Mai Văn P', '1999-01-05', N'Nam', N' Hà Nội', '0909999009', 'p.mai@email.com', N'Thực tập sinh', '2025-04-01', 5200000),
(N'Lý Thị Q', '1985-06-20', N'Nữ', N' Hà Nội', '0910111010', 'q.ly@email.com', N'Quản lý kho', '2022-02-10', 9200000),
(N'Vương Văn R', '1993-11-02', N'Nam', N' Hà Nội', '0981222011', 'r.vuong@email.com', N'Bán hàng online', '2023-08-25', 7900000),
(N'Ngô Thị S', '1988-02-15', N'Nữ', N'Hà Nội', '0932333012', 's.ngo@email.com', N'Kỹ thuật viên', '2021-01-01', 11500000),
(N'Phùng Văn T', '1997-05-28', N'Nam', N'Nghệ An', '0963444013', 't.phung@email.com', N'Lễ tân', '2024-09-20', 6700000),
(N'Trịnh Thị U', '1990-09-10', N'Nữ', N'Hà Nội', '0944555014', 'u.trinh@email.com', N'Nhân viên giao hàng', '2025-05-15', 7300000),
(N'Hồ Văn V', '1994-12-25', N'Nam', N'Thái Bình', '0925666015', 'v.ho@email.com', N'Tuyển dụng', '2023-12-01', 8500000),
(N'Bạch Thị X', '1989-07-08', N'Nữ', N'Thái Bình', '0906777016', 'x.bach@email.com', N'Trưởng nhóm bán hàng', '2024-04-10', 10800000),
(N'Sầm Văn Y', '1996-01-20', N'Nam', N' Hà Nội', '0977888017', 'y.sam@email.com', N'Nhân viên hỗ trợ', '2022-06-25', 7700000),
(N'Quách Thị Z', '1991-04-03', N'Nữ', N'Hà Nội', '0938999018', 'z.quach@email.com', N'Phân tích dữ liệu', '2025-02-01', 11200000),
(N'Uông Văn AA', '1999-09-15', N'Nam', N'Nam Định', '0969000019', 'aa.uong@email.com', N'Thực tập sinh marketing', '2024-10-15', 5300000),
(N'Phan Thị BB', '1984-03-01', N'Nữ', N'Hà Nội', '0911222020', 'bb.phan@email.com', N'Kiểm toán viên', '2023-03-01', 12200000),
(N'Lâm Văn CC', '1997-07-18', N'Nam', N'Bắc cạn', '0982333021', 'cc.lam@email.com', N'Nhân viên lễ tân', '2024-11-30', 6900000),
(N'Trần Thị DD', '1992-10-25', N'Nữ', N'Thanh Hóa', '0933444022', 'dd.tran@email.com', N'Chuyên viên nhân sự', '2022-07-10', 9800000),
(N'Đỗ Văn EE', '1987-01-10', N'Nam', N'Hà Nội', '0964555023', 'ee.do@email.com', N'Nhân viên kinh doanh', '2025-01-01', 8100000),
(N'Nguyễn Thị FF', '1995-05-03', N'Nữ', N'Hòa Bình', '0945666024', 'ff.nguyen@email.com', N'Nhân viên kỹ thuật', '2023-04-20', 10200000),
(N'Lê Văn GG', '1990-08-20', N'Nam', N'Hà Nội', '0926777025', 'gg.le@email.com', N'Marketing executive', '2021-09-01', 9400000),
(N'Phạm Thị HH', '1998-12-05', N'Nữ', N'Hà Nội', '0907888026', 'hh.pham@email.com', N'Nhân viên kho', '2024-07-15', 7600000),
(N'Hoàng Văn II', '1983-03-15', N'Nam', N'Yên Bái', '0988999027', 'ii.hoang@email.com', N'Trưởng phòng kinh doanh', '2022-10-05', 14500000),
(N'Trần Thị JJ', '1996-07-01', N'Nữ', N'Quảng Ninh', '0919000028', 'jj.tran@email.com', N'Phó phòng marketing', '2024-12-10', 11200000),
(N'Vũ Văn KK', '1991-10-18', N'Nam', N'Hải Phòng', '0970111029', 'kk.vu@email.com', N'Nhân viên hành chính', '2023-03-01', 7100000),
(N'Đặng Thị LL', '1999-02-25', N'Nữ', N'Hải Dương', '0931222030', 'll.dang@email.com', N'Quản lý dự án', '2025-05-20', 13800000),
(N'Bùi Văn MM', '1986-06-10', N'Nam', N'Hải Phòng', '0962333031', 'mm.bui@email.com', N'Kiểm soát chất lượng', '2022-08-01', 10000000),
(N'Cao Thị NN', '1994-11-22', N'Nữ', N'Hà Nội', '0943444032', 'nn.cao@email.com', N'Chuyên viên tài chính', '2024-01-15', 11800000),
(N'Mai Văn OO', '1989-04-05', N'Nam', N'Hà Nội', '0924555033', 'oo.mai@email.com', N'Nhân viên nhập liệu', '2023-06-10', 6500000),
(N'Lý Thị PP', '1997-08-12', N'Nữ', N'Hà Nội', '0905666034', 'pp.ly@email.com', N'Trưởng nhóm kỹ thuật', '2025-02-25', 15000000),
(N'Vương Văn QQ', '1982-12-28', N'Nam', N'Hà Nội', '0986777035', 'qq.vuong@email.com', N'Phó phòng nhân sự', '2021-11-01', 12500000),
(N'Ngô Thị RR', '1995-03-03', N'Nữ', N'Hà Nội', '0937888036', 'rr.ngo@email.com', N'Nhân viên thống kê', '2024-09-05', 8800000),
(N'Phùng Văn SS', '1990-07-15', N'Nam', N'Bình Định', '0968999037', 'ss.phung@email.com', N'Chuyên viên đào tạo', '2022-03-10', 10500000),
(N'Trịnh Thị TT', '1998-11-20', N'Nữ', N'Hà Nội', '0949000038', 'tt.trinh@email.com', N'Thư ký', '2025-01-20', 6200000),
(N'Hồ Văn UU', '1983-04-01', N'Nam', N'Nam Định', '0920111039', 'uu.ho@email.com', N'Quản lý chi nhánh', '2023-07-01', 16000000),
(N'Bạch Thị VV', '1996-08-17', N'Nữ', N'HCM', '0901222040', 'vv.bach@email.com', N'Nhân viên marketing online', '2024-04-15', 9100000),
(N'Sầm Văn WW', '1991-12-03', N'Nam', N'HCM', '0972333041', 'ww.sam@email.com', N'Thiết kế đồ họa', '2022-09-20', 10800000),
(N'Quách Thị XX', '1999-05-10', N'Nữ', N'HCM', '0933444042', 'xx.quach@email.com', N'Nhân viên lễ tân', '2025-02-01', 7000000),
(N'Uông Văn YY', '1984-09-25', N'Nam', N'Hà Nội', '0964555043', 'yy.uong@email.com', N'Chuyên viên mua hàng', '2023-12-10', 9600000),
(N'Phan Thị ZZ', '1997-01-01', N'Nữ', N'Bắc Giang', '0945666044', 'zz.phan@email.com', N'Nhân viên bán vé', '2024-08-25', 7400000),
(N'Lâm Văn AAA', '1992-04-17', N'Nam', N'Hà Nam', '0926777045', 'aaa.lam@email.com', N'Kỹ sư phần mềm', '2022-05-01', 13000000),
(N'Trần Thị BBB', '1987-08-28', N'Nữ', N'Bắc Giang', '0907888046', 'bbb.tran@email.com', N'Chuyên viên kiểm toán', '2025-03-15', 11500000),
(N'Mai Thị K', '1992-08-12', N'Nữ', N'Hà Nam', '0977654321', 'k.mai@email.com', N'Thực tập sinh', '2025-01-05', 5000000),
(N'Trịnh Thị Quỳnh', '1992-07-09', N'Nữ', N'Hà Nam', '0980123456', 'quynh.trinh@example.com', N'Nhân viên hành chính', '2023-08-10', 8800000),
(N'Nguyễn Văn Lâm', '1990-03-03', N'Nam', N'Hà Nội', '0991123456', 'lam.nguyen@example.com', N'Nhân viên IT', '2022-09-15', 9700000),
(N'Phạm Thị Hồng', '1995-06-11', N'Nữ', N'TP.HCM', '0902123456', 'hong.pham@example.com', N'Chuyên viên tư vấn', '2023-12-05', 8900000),
(N'Lê Văn Đạo', '1989-10-22', N'Nam', N'Đà Nẵng', '0913123456', 'dao.le@example.com', N'Kỹ sư phần mềm', '2021-07-20', 12300000),
(N'Hoàng Thị Nhung', '1993-01-17', N'Nữ', N'Quảng Trị', '0924123456', 'nhung.hoang@example.com', N'Nhân viên kế toán', '2022-05-11', 8600000),
(N'Ngô Văn Đức', '1988-04-30', N'Nam', N'Thái Nguyên', '0935123456', 'duc.ngo@example.com', N'Quản trị hệ thống', '2023-03-18', 11000000),
(N'Trần Thị Kim', '1997-09-25', N'Nữ', N'Ninh Bình', '0946123456', 'kim.tran@example.com', N'Chuyên viên truyền thông', '2024-04-04', 9400000),
(N'Phan Văn Toàn', '1991-12-01', N'Nam', N'Bắc Giang', '0957123456', 'toan.phan@example.com', N'Nhân viên kỹ thuật', '2022-12-01', 9900000),
(N'Thái Thị Hòa', '1994-08-06', N'Nữ', N'Nam Định', '0968123456', 'hoa.thai@example.com', N'Chuyên viên đào tạo', '2024-01-15', 10000000),
(N'Hà Văn Tùng', '1987-11-29', N'Nam', N'Lạng Sơn', '0979123456', 'tung.ha@example.com', N'Nhân viên vận hành', '2021-11-01', 8800000),
(N'Đinh Thị Hạnh', '1996-02-18', N'Nữ', N'Thanh Hóa', '0980123467', 'hanh.dinh@example.com', N'Nhân viên CSKH', '2023-05-05', 8600000),
(N'Nguyễn Văn Bình', '1992-05-23', N'Nam', N'Tuyên Quang', '0991123478', 'binh.nguyen@example.com', N'Bảo trì hệ thống', '2022-08-10', 9300000),
(N'Phạm Thị Yến', '1990-06-30', N'Nữ', N'Bình Định', '0902123489', 'yen.pham@example.com', N'Chuyên viên PR', '2023-10-01', 9700000),
(N'Lý Văn Khánh', '1993-03-27', N'Nam', N'Kiên Giang', '0913123490', 'khanh.ly@example.com', N'Thiết kế giao diện', '2023-06-20', 10400000),
(N'Đỗ Thị Trang', '1995-11-12', N'Nữ', N'Hậu Giang', '0924123411', 'trang.do@example.com', N'Nhân viên nhân sự', '2022-10-15', 9200000),
(N'Cao Văn Bình', '1989-08-14', N'Nam', N'Bến Tre', '0935123422', 'binh.cao@example.com', N'Kế toán trưởng', '2021-03-01', 12500000),
(N'Trương Thị Linh', '1996-01-04', N'Nữ', N'Đồng Tháp', '0946123433', 'linh.truong@example.com', N'Nhân viên chăm sóc KH', '2024-03-01', 8500000),
(N'Bùi Văn Trí', '1990-09-16', N'Nam', N'Tây Ninh', '0957123444', 'tri.bui@example.com', N'Quản lý kỹ thuật', '2022-12-20', 11400000),
(N'Trần Thị Mai', '1994-04-09', N'Nữ', N'An Giang', '0968123455', 'mai.tran@example.com', N'Trợ lý Giám đốc', '2024-01-05', 9900000),
(N'Nguyễn Văn Phú', '1988-07-05', N'Nam', N'Long An', '0979123466', 'phu.nguyen@example.com', N'Trưởng bộ phận IT', '2021-05-10', 14000000),
(N'Lê Thị Hoa', '1993-12-20', N'Nữ', N'Hà Tĩnh', '0980123477', 'hoa.le@example.com', N'Nhân viên bán hàng', '2023-07-15', 8200000),
(N'Hoàng Văn Long', '1992-10-03', N'Nam', N'Phú Thọ', '0991123488', 'long.hoang@example.com', N'Nhân viên tài chính', '2022-09-25', 9700000),
(N'Phạm Thị Dung', '1991-01-25', N'Nữ', N'Hòa Bình', '0902123499', 'dung.pham@example.com', N'Trợ lý hành chính', '2023-04-01', 8600000),
(N'Trịnh Văn Khôi', '1987-05-11', N'Nam', N'Quảng Nam', '0913123410', 'khoi.trinh@example.com', N'Chuyên viên hệ thống', '2022-07-01', 11800000),
(N'Nguyễn Thị Lệ', '1993-03-21', N'Nữ', N'Cần Thơ', '0933123456', 'le.nguyen@example.com', N'Nhân viên thống kê', '2023-11-10', 9200000),
(N'Phạm Văn Định', '1991-06-14', N'Nam', N'Nghệ An', '0944123456', 'dinh.pham@example.com', N'Thủ kho', '2022-08-20', 8700000),
(N'Lê Thị Hằng', '1996-12-05', N'Nữ', N'Bình Dương', '0955123456', 'hang.le@example.com', N'Nhân viên chăm sóc khách hàng', '2024-05-30', 8600000),
(N'Hoàng Văn Kiên', '1988-05-19', N'Nam', N'Đồng Nai', '0966123456', 'kien.hoang@example.com', N'IT Helpdesk', '2023-07-01', 9800000),
(N'Ngô Thị Ngọc', '1995-10-02', N'Nữ', N'Hậu Giang', '0977123456', 'ngoc.ngo@example.com', N'Marketing', '2024-01-01', 9400000),
(N'Bùi Văn Phong', '1990-11-17', N'Nam', N'Tây Ninh', '0988123456', 'phong.bui@example.com', N'Nhân viên kỹ thuật', '2023-06-01', 10500000),
(N'Vũ Thị Mai', '1987-02-26', N'Nữ', N'Bến Tre', '0999123456', 'mai.vu@example.com', N'Trưởng phòng nhân sự', '2021-09-15', 13500000),
(N'Trần Văn Tiến', '1992-08-08', N'Nam', N'Hưng Yên', '0901123456', 'tien.tran@example.com', N'Nhân viên kho', '2023-04-01', 7600000),
(N'Đặng Thị Yến', '1994-09-30', N'Nữ', N'Lào Cai', '0912123456', 'yen.dang@example.com', N'Thư ký', '2025-01-10', 6700000),
(N'Cao Văn Trường', '1991-12-15', N'Nam', N'Sơn La', '0923123456', 'truong.cao@example.com', N'Bảo vệ', '2023-11-20', 7000000),
(N'Phan Thị Hương', '1990-04-25', N'Nữ', N'Lâm Đồng', '0934123456', 'huong.phan@example.com', N'Nhân viên hành chính', '2022-10-01', 8800000),
(N'Mai Văn Hoàn', '1985-01-05', N'Nam', N'Tuyên Quang', '0945123456', 'hoan.mai@example.com', N'Kiểm toán viên', '2023-05-15', 11500000),
(N'Quách Thị Tuyết', '1997-06-21', N'Nữ', N'Phú Yên', '0956123456', 'tuyet.quach@example.com', N'Chuyên viên nhân sự', '2024-06-25', 9800000),
(N'Nguyễn Minh Hải', '1989-03-11', N'Nam', N'Hà Tĩnh', '0967123456', 'hai.nguyen@example.com', N'Phân tích dữ liệu', '2022-07-01', 11000000),
(N'Trịnh Văn Hoàng', '1993-12-29', N'Nam', N'Quảng Ngãi', '0978123456', 'hoang.trinh@example.com', N'Quản lý chất lượng', '2021-12-10', 12500000),
(N'Đỗ Thị Bích', '1996-07-06', N'Nữ', N'Bạc Liêu', '0989123456', 'bich.do@example.com', N'Chuyên viên đào tạo', '2024-03-05', 10200000),
(N'Lý Văn Cường', '1991-09-18', N'Nam', N'Quảng Bình', '0990123456', 'cuong.ly@example.com', N'IT', '2022-06-20', 12200000),
(N'Bạch Thị Thủy', '1995-05-27', N'Nữ', N'An Giang', '0902134567', 'thuy.bach@example.com', N'Marketing online', '2023-09-01', 9500000),
(N'Trần Quốc Việt', '1992-01-14', N'Nam', N'Vĩnh Long', '0913145678', 'viet.tran@example.com', N'Thiết kế đồ họa', '2024-02-15', 10800000),
(N'Hồ Thị Hạnh', '1998-11-02', N'Nữ', N'Trà Vinh', '0924156789', 'hanh.ho@example.com', N'Phó phòng tài chính', '2025-03-01', 11700000),
(N'Ngô Văn Huy', '1990-08-24', N'Nam', N'Ninh Thuận', '0935167890', 'huy.ngo@example.com', N'Trưởng nhóm kiểm toán', '2021-10-01', 13500000),
(N'Đặng Thị Thanh', '1994-03-18', N'Nữ', N'Kon Tum', '0946178901', 'thanh.dang@example.com', N'Nhân viên kinh doanh', '2023-11-10', 8100000),
(N'Cao Văn Hòa', '1988-10-07', N'Nam', N'Gia Lai', '0957189012', 'hoa.cao@example.com', N'Nhân viên hỗ trợ', '2023-06-25', 7700000),
(N'Bùi Thị Duyên', '1993-01-31', N'Nữ', N'Bình Thuận', '0968190123', 'duyen.bui@example.com', N'Nhân viên marketing', '2024-01-20', 9000000),
(N'Vương Minh Phát', '1987-12-12', N'Nam', N'Cà Mau', '0979201234', 'phat.vuong@example.com', N'Chuyên viên tài chính', '2023-02-01', 11600000),

(N'Lê Minh Quân', '1990-08-22', N'Nam', N'Bình Dương', '0903001001', 'quan.le@example.com', N'Kỹ sư thiết kế', '2023-06-01', 10800000),
(N'Trần Thị Hương', '1992-04-17', N'Nữ', N'Bình Phước', '0913001002', 'huong.tran@example.com', N'Chuyên viên pháp lý', '2022-03-12', 9900000),
(N'Nguyễn Văn Khoa', '1989-02-09', N'Nam', N'Cần Thơ', '0923001003', 'khoa.nguyen@example.com', N'Nhân viên nghiên cứu', '2021-11-09', 9500000),
(N'Phan Thị Lệ', '1996-12-28', N'Nữ', N'Sóc Trăng', '0933001004', 'le.phan@example.com', N'Nhân viên hậu cần', '2024-02-22', 8800000),
(N'Đỗ Văn Tâm', '1993-05-05', N'Nam', N'Kon Tum', '0943001005', 'tam.do@example.com', N'Kỹ thuật viên phần mềm', '2022-07-18', 10200000),
(N'Võ Thị Thu', '1995-10-21', N'Nữ', N'Nghệ An', '0953001006', 'thu.vo@example.com', N'Nhân viên hành chính', '2023-05-30', 8700000),
(N'Huỳnh Văn Sơn', '1991-07-14', N'Nam', N'Bạc Liêu', '0963001007', 'son.huynh@example.com', N'Trưởng phòng kỹ thuật', '2021-01-25', 12500000),
(N'Lý Thị Hồng', '1990-09-30', N'Nữ', N'Lâm Đồng', '0973001008', 'hong.ly@example.com', N'Nhân viên kiểm toán', '2022-08-10', 9400000),
(N'Bùi Văn Đức', '1987-11-11', N'Nam', N'Tiền Giang', '0983001009', 'duc.bui@example.com', N'Quản lý sản xuất', '2020-12-05', 11200000),
(N'Nguyễn Thị Hằng', '1994-03-15', N'Nữ', N'Quảng Bình', '0993001010', 'hang.nguyen@example.com', N'Chuyên viên tuyển dụng', '2023-06-10', 9300000),
(N'Phạm Văn Lâm', '1988-01-01', N'Nam', N'Hậu Giang', '0904001011', 'lam.pham@example.com', N'Kỹ thuật điện', '2021-04-04', 10100000),
(N'Trương Thị Bích', '1992-02-02', N'Nữ', N'Tây Ninh', '0914001012', 'bich.truong@example.com', N'Chuyên viên đào tạo', '2022-02-14', 9700000),
(N'Cao Văn Phước', '1993-12-12', N'Nam', N'Bình Thuận', '0924001013', 'phuoc.cao@example.com', N'Nhân viên bảo trì', '2023-10-01', 8800000),
(N'Lê Thị Thắm', '1996-06-06', N'Nữ', N'Bến Tre', '0934001014', 'tham.le@example.com', N'Nhân viên thư viện', '2023-09-15', 8500000),
(N'Thân Văn Kiệt', '1989-03-23', N'Nam', N'Trà Vinh', '0944001015', 'kiet.than@example.com', N'Giám sát sản xuất', '2022-11-01', 10900000),
(N'Nguyễn Thị Diễm', '1995-01-18', N'Nữ', N'Cà Mau', '0954001016', 'diem.nguyen@example.com', N'Nhân viên kế hoạch', '2024-03-20', 9000000),
(N'Vũ Văn Thành', '1990-10-10', N'Nam', N'Hà Nội', '0964001017', 'thanh.vu@example.com', N'Trưởng nhóm dự án', '2021-08-08', 11500000),
(N'Tô Thị Liên', '1993-07-19', N'Nữ', N'Nam Định', '0974001018', 'lien.to@example.com', N'Nhân viên báo cáo', '2022-06-05', 8700000),
(N'Hồ Văn Nghĩa', '1991-11-27', N'Nam', N'Khánh Hòa', '0984001019', 'nghia.ho@example.com', N'Chuyên viên nghiên cứu', '2021-12-15', 9900000),
(N'Trần Thị Cúc', '1994-08-08', N'Nữ', N'An Giang', '0994001020', 'cuc.tran@example.com', N'Kế toán thuế', '2023-02-17', 9400000),
(N'Lê Văn Hòa', '1988-12-05', N'Nam', N'Sơn La', '0905001021', 'hoa.le@example.com', N'Nhân viên logistics', '2022-01-25', 9600000),
(N'Đinh Thị Dung', '1995-09-15', N'Nữ', N'Hưng Yên', '0915001022', 'dung.dinh@example.com', N'Nhân viên tư vấn', '2023-12-12', 8800000),
(N'Phan Văn Sáng', '1987-06-11', N'Nam', N'Hải Dương', '0925001023', 'sang.phan@example.com', N'Chuyên viên CNTT', '2021-05-18', 11000000),
(N'Vũ Thị Minh', '1992-03-03', N'Nữ', N'Tuyên Quang', '0935001024', 'minh.vu@example.com', N'Nhân viên pháp chế', '2023-01-01', 9200000),
(N'Trịnh Văn Lộc', '1989-05-26', N'Nam', N'Phú Yên', '0945001025', 'loc.trinh@example.com', N'Trưởng phòng vận hành', '2020-10-10', 13000000),
(N'Hoàng Thị Hà', '1991-07-01', N'Nữ', N'Hải Phòng', '0955001026', 'ha.hoang@example.com', N'Nhân viên chăm sóc khách hàng', '2022-04-04', 8900000),
(N'Tống Văn Quang', '1993-04-14', N'Nam', N'Bắc Ninh', '0965001027', 'quang.tong@example.com', N'Quản lý dữ liệu', '2023-09-09', 9900000),
(N'Ngô Thị Kiều', '1996-01-11', N'Nữ', N'Yên Bái', '0975001028', 'kieu.ngo@example.com', N'Chuyên viên văn hóa doanh nghiệp', '2022-03-30', 9200000),
(N'Tạ Văn Duy', '1990-02-28', N'Nam', N'Hòa Bình', '0985001029', 'duy.ta@example.com', N'Nhân viên kỹ thuật', '2021-06-06', 9700000),
(N'Mai Thị Tươi', '1995-05-05', N'Nữ', N'Lai Châu', '0995001030', 'tuoi.mai@example.com', N'Chuyên viên sự kiện', '2023-07-07', 8800000),

(N'Bùi Văn Hưng', '1988-06-22', N'Nam', N'Bình Dương', '0906001031', 'hung.bui@example.com', N'Kỹ sư cơ khí', '2021-09-09', 10200000),
(N'Nguyễn Thị Nga', '1993-03-10', N'Nữ', N'Quảng Ngãi', '0916001032', 'nga.nguyen@example.com', N'Nhân viên phân tích', '2022-08-12', 9500000),
(N'Đoàn Văn Phú', '1987-12-25', N'Nam', N'Hà Tĩnh', '0926001033', 'phu.doan@example.com', N'Kỹ thuật viên bảo trì', '2020-11-17', 9200000),
(N'Lê Thị Trang', '1994-04-01', N'Nữ', N'Quảng Trị', '0936001034', 'trang.le@example.com', N'Chuyên viên chăm sóc khách hàng', '2023-03-21', 8900000),
(N'Phạm Văn Bảo', '1990-08-30', N'Nam', N'Ninh Bình', '0946001035', 'bao.pham@example.com', N'Nhân viên kiểm định', '2021-07-01', 9400000),
(N'Trịnh Thị Quỳnh', '1992-10-18', N'Nữ', N'Long An', '0956001036', 'quynh.trinh@example.com', N'Chuyên viên nhân sự', '2023-01-20', 9100000),
(N'Tống Văn Tiến', '1989-01-15', N'Nam', N'Lào Cai', '0966001037', 'tien.tong@example.com', N'Nhân viên kho', '2022-05-05', 8700000),
(N'Hoàng Thị Mai', '1996-12-03', N'Nữ', N'Bắc Kạn', '0976001038', 'mai.hoang@example.com', N'Chuyên viên tiếp thị', '2023-08-16', 9000000),
(N'Nguyễn Văn Duy', '1991-09-27', N'Nam', N'Hà Nội', '0986001039', 'duy.nguyen@example.com', N'Chuyên viên tài chính', '2020-10-30', 9700000),
(N'Lý Thị Hạnh', '1994-06-19', N'Nữ', N'Đồng Tháp', '0996001040', 'hanh.ly@example.com', N'Kỹ sư điện', '2022-12-10', 9500000),
(N'Phan Văn Tùng', '1992-11-09', N'Nam', N'Quảng Nam', '0907001041', 'tung.phan@example.com', N'Nhân viên đào tạo', '2021-02-15', 9100000),
(N'Lê Thị Nhi', '1995-07-23', N'Nữ', N'Thái Bình', '0917001042', 'nhi.le@example.com', N'Nhân viên kế hoạch', '2023-11-11', 8800000),
(N'Cao Văn Dương', '1988-02-05', N'Nam', N'Vĩnh Long', '0927001043', 'duong.cao@example.com', N'Chuyên viên IT', '2022-07-07', 10000000),
(N'Trương Thị Yến', '1993-01-12', N'Nữ', N'Lạng Sơn', '0937001044', 'yen.truong@example.com', N'Kỹ sư xây dựng', '2021-12-01', 9700000),
(N'Ngô Văn Hữu', '1990-05-08', N'Nam', N'Kiên Giang', '0947001045', 'huu.ngo@example.com', N'Trưởng nhóm vận hành', '2023-06-06', 10500000),
(N'Tạ Thị Phương', '1996-09-29', N'Nữ', N'Điện Biên', '0957001046', 'phuong.ta@example.com', N'Nhân viên truyền thông', '2022-09-01', 8800000),
(N'Đỗ Văn Phước', '1989-07-17', N'Nam', N'Cao Bằng', '0967001047', 'phuoc.do@example.com', N'Kỹ sư điện tử', '2021-03-03', 9900000),
(N'Bùi Thị Lý', '1995-03-30', N'Nữ', N'Bắc Giang', '0977001048', 'ly.bui@example.com', N'Nhân viên lễ tân', '2023-04-04', 8500000),
(N'Nguyễn Văn Phát', '1987-08-04', N'Nam', N'Yên Bái', '0987001049', 'phat.nguyen@example.com', N'Chuyên viên phân tích dữ liệu', '2020-08-08', 10500000),
(N'Lê Thị Hương Giang', '1994-11-22', N'Nữ', N'Thái Nguyên', '0997001050', 'giang.le@example.com', N'Nhân viên hỗ trợ kỹ thuật', '2022-02-02', 9300000),
(N'Trần Văn Hiếu', '1990-10-01', N'Nam', N'Quảng Ninh', '0908001051', 'hieu.tran@example.com', N'Nhân viên chăm sóc thiết bị', '2021-06-30', 9400000),
(N'Vũ Thị Thanh', '1992-04-16', N'Nữ', N'Bình Phước', '0918001052', 'thanh.vu@example.com', N'Chuyên viên tuyển sinh', '2023-07-07', 8900000),
(N'Phan Văn Chính', '1988-06-06', N'Nam', N'Bến Tre', '0928001053', 'chinh.phan@example.com', N'Nhân viên hậu cần', '2022-10-10', 9100000),
(N'Trương Thị Hòa', '1996-02-02', N'Nữ', N'Tiền Giang', '0938001054', 'hoa.truong@example.com', N'Nhân viên hành chính văn phòng', '2023-05-05', 8700000),
(N'Cao Văn Hiển', '1991-12-25', N'Nam', N'Trà Vinh', '0948001055', 'hien.cao@example.com', N'Nhân viên kỹ thuật máy', '2022-11-11', 9500000),
(N'Lý Thị Xuân', '1993-09-09', N'Nữ', N'Khánh Hòa', '0958001056', 'xuan.ly@example.com', N'Chuyên viên chiến lược', '2021-04-04', 9900000),
(N'Ngô Văn Định', '1989-01-01', N'Nam', N'Nghệ An', '0968001057', 'dinh.ngo@example.com', N'Nhân viên vận chuyển', '2020-03-03', 8700000),
(N'Hoàng Thị Thu Hà', '1994-05-15', N'Nữ', N'Bạc Liêu', '0978001058', 'thu.hoang@example.com', N'Nhân viên chăm sóc nội dung', '2023-09-09', 9000000),
(N'Phạm Văn Khôi', '1990-03-18', N'Nam', N'An Giang', '0988001059', 'khoi.pham@example.com', N'Chuyên viên dự án', '2022-06-06', 9600000),
(N'Nguyễn Thị Mỹ Linh', '1996-06-06', N'Nữ', N'Phú Thọ', '0998001060', 'mylinh.nguyen@example.com', N'Nhân viên quan hệ công chúng', '2023-08-08', 8800000),
(N'Trần Văn Cường', '1988-07-14', N'Nam', N'Quảng Bình', '0909001061', 'cuong.tran@example.com', N'Chuyên viên mua sắm', '2021-01-01', 9400000),
(N'Lê Thị Thanh Thảo', '1992-12-12', N'Nữ', N'Đồng Nai', '0919001062', 'thao.le@example.com', N'Chuyên viên đào tạo nội bộ', '2022-12-12', 9100000),
(N'Tạ Văn Bằng', '1987-10-10', N'Nam', N'Hưng Yên', '0929001063', 'bang.ta@example.com', N'Giám sát công trình', '2020-10-10', 10100000),
(N'Bùi Thị Ngân', '1993-05-25', N'Nữ', N'Kiên Giang', '0939001064', 'ngan.bui@example.com', N'Nhân viên điều phối', '2023-01-01', 8800000),
(N'Cao Văn Lực', '1990-01-19', N'Nam', N'Bắc Ninh', '0949001065', 'luc.cao@example.com', N'Nhân viên nghiên cứu thị trường', '2022-03-03', 9400000),
(N'Trương Thị Huyền', '1995-04-04', N'Nữ', N'Hà Nam', '0959001066', 'huyen.truong@example.com', N'Chuyên viên bảo hiểm', '2023-03-03', 9100000),
(N'Đỗ Văn Lợi', '1989-06-30', N'Nam', N'Hòa Bình', '0969001067', 'loi.do@example.com', N'Nhân viên vận hành máy', '2021-07-07', 9300000),
(N'Vũ Thị Oanh', '1994-09-09', N'Nữ', N'Ninh Thuận', '0979001068', 'oanh.vu@example.com', N'Nhân viên phân tích kinh doanh', '2023-05-15', 9500000),

(N'Đặng Thị Loan', '1994-02-02', N'Nữ', N'Vĩnh Phúc', '0924123421', 'loan.dang@example.com', N'Nhân viên phân tích dữ liệu', '2024-05-01', 10100000);

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
(N'Nguyễn Thị Hồng', '0901234501', N'12 Nguyễn Trãi, Hà Nội', 'hong.nguyen@email.com', 200),
(N'Lê Văn Dũng', '0912345602', N'45 Trần Hưng Đạo, TP.HCM', 'dung.le@email.com', 180),
(N'Trần Thị Mai', '0923456703', N'78 Lê Lợi, Đà Nẵng', 'mai.tran@email.com', 150),
(N'Phạm Văn Khoa', '0934567804', N'99 Hai Bà Trưng, Hải Phòng', 'khoa.pham@email.com', 240),
(N'Hoàng Thị Ngọc', '0945678905', N'23 Nguyễn Văn Cừ, Huế', 'ngoc.hoang@email.com', 170),
(N'Đặng Văn Minh', '0956789006', N'56 Lê Duẩn, Cần Thơ', 'minh.dang@email.com', 210),
(N'Bùi Thị Lan', '0967890107', N'10 Trần Phú, Bắc Ninh', 'lan.bui@email.com', 190),
(N'Vũ Văn Hùng', '0978901208', N'67 Đinh Tiên Hoàng, Thanh Hóa', 'hung.vu@email.com', 220),
(N'Ngô Thị Hạnh', '0989012309', N'34 Nguyễn Huệ, Ninh Bình', 'hanh.ngo@email.com', 165),
(N'Lý Văn Sơn', '0990123410', N'89 Phan Đình Phùng, Hà Nam', 'son.ly@email.com', 230),
(N'Phan Thị Huệ', '0901123411', N'21 Cầu Giấy, Hà Nội', 'hue.phan@email.com', 150),
(N'Huỳnh Văn Tài', '0912234512', N'76 Nguyễn Khuyến, TP.HCM', 'tai.huynh@email.com', 180),
(N'Cao Thị Tuyết', '0923345613', N'33 Phạm Văn Đồng, Đà Nẵng', 'tuyet.cao@email.com', 200),
(N'Mai Văn Hiếu', '0934456714', N'88 Nguyễn Trãi, Cần Thơ', 'hieu.mai@email.com', 210),
(N'Tô Thị Bình', '0945567815', N'17 Phan Chu Trinh, Hải Dương', 'binh.to@email.com', 195),
(N'Châu Văn Toàn', '0956678916', N'42 Điện Biên Phủ, Vũng Tàu', 'toan.chau@email.com', 160),
(N'Lâm Thị Nhung', '0967789017', N'61 Tôn Đức Thắng, Quảng Ngãi', 'nhung.lam@email.com', 175),
(N'Tống Văn Quân', '0978890118', N'84 Nguyễn Đình Chiểu, Đà Lạt', 'quan.tong@email.com', 220),
(N'Kiều Thị Giang', '0989901219', N'19 Hùng Vương, Bắc Giang', 'giang.kieu@email.com', 205),
(N'Triệu Văn Phúc', '0991012320', N'35 Trưng Trắc, Hải Phòng', 'phuc.trieu@email.com', 185),
(N'Tạ Thị Hương', '0902123421', N'72 Nguyễn Du, Hà Nội', 'huong.ta@email.com', 240),
(N'Thạch Văn Duy', '0913234522', N'38 Trần Quang Khải, TP.HCM', 'duy.thach@email.com', 190),
(N'Dương Thị Kim', '0924345623', N'27 Lê Lai, Đà Nẵng', 'kim.duong@email.com', 215),
(N'Đoàn Văn Hoài', '0935456724', N'64 Phạm Hùng, Huế', 'hoai.doan@email.com', 175),
(N'Thái Thị Thanh', '0946567825', N'14 Nguyễn Bỉnh Khiêm, Cần Thơ', 'thanh.thai@email.com', 185),
(N'Hứa Văn Thắng', '0957678926', N'83 Nguyễn Tri Phương, Bình Dương', 'thang.hua@email.com', 170),
(N'Thân Thị Trinh', '0968789027', N'25 Tân Sơn Nhì, Đồng Nai', 'trinh.than@email.com', 160),
(N'Tăng Văn Hào', '0979890128', N'46 Lý Chính Thắng, Hà Nội', 'hao.tang@email.com', 200),
(N'Mạc Thị Thảo', '0980901239', N'30 Nguyễn Gia Thiều, TP.HCM', 'thao.mac@email.com', 195),
(N'La Văn Tùng', '0992012340', N'58 Trần Bình Trọng, Hà Tĩnh', 'tung.la@email.com', 180),
(N'Từ Thị Mai', '0903012341', N'13 Nguyễn Phong Sắc, Quảng Trị', 'mai.tu@email.com', 160),
(N'Liễu Văn Bảo', '0914123442', N'66 Nguyễn Kiệm, Bắc Ninh', 'bao.lieu@email.com', 190),
(N'Triều Thị Quỳnh', '0925234543', N'39 Trường Chinh, Thái Bình', 'quynh.trieu@email.com', 185),
(N'Từ Văn Đức', '0936345644', N'20 Trần Cao Vân, Bình Phước', 'duc.tu@email.com', 210),
(N'Vi Thị Ngân', '0947456745', N'77 Lạc Long Quân, Quảng Nam', 'ngan.vi@email.com', 175),
(N'Trình Văn Nam', '0958567846', N'55 Trần Hữu Dực, Hưng Yên', 'nam.trinh@email.com', 220),
(N'Lữ Thị Liên', '0969678947', N'28 Xô Viết Nghệ Tĩnh, Nghệ An', 'lien.lu@email.com', 200),
(N'Hầu Văn Khánh', '0970789048', N'60 Phan Bội Châu, Hà Giang', 'khanh.hau@email.com', 170),
(N'Triệu Thị Duyên', '0981890149', N'31 Trần Đại Nghĩa, Sơn La', 'duyen.trieu@email.com', 185),
(N'Bàng Văn Hòa', '0992901250', N'74 Trần Nhật Duật, Tuyên Quang', 'hoa.bang@email.com', 160),
(N'Giàng Thị Mỵ', '0904012351', N'36 Nguyễn Cảnh Chân, Lào Cai', 'my.giang@email.com', 150),
(N'Tạ Văn Khôi', '0915123452', N'10 Nguyễn Hữu Cảnh, TP.HCM', 'khoi.ta@email.com', 180),
(N'Tống Thị Hân', '0926234553', N'59 Trần Khánh Dư, Hà Nội', 'han.tong@email.com', 170),
(N'Cổ Văn Sỹ', '0937345654', N'28 Tạ Quang Bửu, Đà Nẵng', 'sy.co@email.com', 160),
(N'Phùng Thị Hằng', '0948456755', N'81 Lê Thánh Tông, Cần Thơ', 'hang.phung@email.com', 200),
(N'Tôn Văn Hữu', '0959567856', N'44 Nguyễn Tất Thành, Hải Phòng', 'huu.ton@email.com', 215),
(N'Trịnh Thị Nhã', '0960678957', N'22 Lương Ngọc Quyến, Thái Nguyên', 'nha.trinh@email.com', 180),
(N'Quách Văn Tâm', '0971789058', N'75 Lê Văn Lương, Hà Nội', 'tam.quach@email.com', 170),
(N'Đinh Thị Yến', '0982890159', N'47 Nguyễn Văn Linh, Huế', 'yen.dinh@email.com', 200),
(N'Thạch Văn Lâm', '0993901260', N'31 Quang Trung, Đồng Nai', 'lam.thach@email.com', 210),
(N'Từ Thị Hoa', '0905012361', N'53 Nguyễn Văn Huyên, Hà Nội', 'hoa.tu@email.com', 175),
(N'Triệu Văn Bình', '0916123462', N'29 Cách Mạng Tháng Tám, TP.HCM', 'binh.trieu@email.com', 160),
(N'Lê Thị Lệ', '0927234563', N'70 Điện Biên Phủ, Đà Nẵng', 'le.le@email.com', 185),
(N'Nguyễn Văn Hải', '0938345664', N'35 Hoàng Diệu, Cần Thơ', 'hai.nguyen@email.com', 190),
(N'Phạm Thị Quyên', '0949456765', N'84 Võ Thị Sáu, Hải Dương', 'quyen.pham@email.com', 200),
(N'Bùi Văn Đạt', '0950567866', N'11 Phan Xích Long, Bình Dương', 'dat.bui@email.com', 165),
(N'Trương Thị Thu', '0961678967', N'23 Tôn Đức Thắng, Quảng Nam', 'thu.truong@email.com', 175),
(N'Đoàn Văn Tú', '0972789068', N'36 Hùng Vương, Tây Ninh', 'tu.doan@email.com', 180),
(N'Huỳnh Thị Như', '0983890169', N'88 Nguyễn Trãi, Lâm Đồng', 'nhu.huynh@email.com', 210),
(N'Hồ Văn Quý', '0994901270', N'60 Lê Đại Hành, Kon Tum', 'quy.ho@email.com', 190),
(N'Châu Thị Thanh', '0906012371', N'25 Nguyễn An Ninh, Long An', 'thanh.chau@email.com', 160),
(N'Phan Văn Thọ', '0917123472', N'49 Trần Hưng Đạo, Vĩnh Long', 'tho.phan@email.com', 200),
(N'Hứa Thị Phương', '0928234573', N'67 Nguyễn Văn Trỗi, Hà Nam', 'phuong.hua@email.com', 170),
(N'Lâm Văn Hậu', '0939345674', N'34 Nguyễn Hồng Đào, TP.HCM', 'hau.lam@email.com', 180),
(N'Cao Thị Tươi', '0951456776', N'20 Nguyễn Khuyến, Huế', 'tuoi.cao@email.com', 160),
(N'Tăng Văn Vinh', '0962567877', N'41 Tân Kỳ Tân Quý, Hà Nội', 'vinh.tang@email.com', 175),
(N'Lý Thị Duyên', '0973678978', N'58 Lê Quang Định, Bà Rịa', 'duyen.ly@email.com', 195),
(N'Triều Văn Tấn', '0984789079', N'15 Nguyễn Thiện Thuật, Bắc Ninh', 'tan.trieu@email.com', 185),
(N'Kiều Thị Hà', '0995890180', N'77 Nguyễn Hoàng, Hà Giang', 'ha.kieu@email.com', 160),
(N'Thân Văn Vũ', '0906901281', N'33 Trần Quốc Hoàn, Quảng Bình', 'vu.than@email.com', 190),
(N'Từ Thị Vân', '0917012382', N'45 Phan Văn Trị, Ninh Thuận', 'van.tu@email.com', 200),
(N'Đặng Văn Nam', '0928123483', N'19 Hoàng Văn Thụ, Nghệ An', 'nam.dang@email.com', 180),
(N'Hoàng Thị Tuyết', '0939234584', N'26 Nguyễn Công Trứ, Phú Yên', 'tuyet.hoang@email.com', 160),
(N'Tống Văn Tân', '0950345685', N'61 Trương Công Định, Lào Cai', 'tan.tong@email.com', 175),
(N'Ngô Thị Huệ', '0961456786', N'80 Nguyễn Du, Yên Bái', 'hue.ngo@email.com', 185),
(N'Mai Văn Duy', '0972567887', N'17 Nguyễn Tri Phương, Gia Lai', 'duy.mai@email.com', 195),
(N'La Thị Nhàn', '0983678988', N'38 Hòa Bình, Bắc Kạn', 'nhan.la@email.com', 210),
(N'Võ Văn Khải', '0994789089', N'43 Hoàng Quốc Việt, Đồng Tháp', 'khai.vo@email.com', 175),
(N'Tạ Thị Ánh', '0905890190', N'27 Bạch Đằng, Trà Vinh', 'anh.ta@email.com', 200),
(N'Tô Văn Trung', '0916901291', N'54 Nguyễn Trãi, TP.HCM', 'trung.to@email.com', 160),
(N'Chử Thị Như', '0927012392', N'32 Phan Đăng Lưu, Hà Nội', 'nhu.chu@email.com', 185),
(N'Nguyễn Thị Kim Chi', '0938123493', N'68 Hùng Vương, Vĩnh Phúc', 'kimchi.nguyen@email.com', 210),
(N'Phạm Văn Khánh', '0949234594', N'21 Trần Văn Ơn, An Giang', 'khanh.pham@email.com', 190),
(N'Lê Thị Nhàn', '0950345695', N'14 Nguyễn Văn Cừ, Sóc Trăng', 'nhan.le@email.com', 175),
(N'Đinh Văn Đoàn', '0961456796', N'72 Trường Sa, Hậu Giang', 'doan.dinh@email.com', 185),
(N'Đoàn Thị Cúc', '0972567897', N'11 Hoàng Hoa Thám, Kiên Giang', 'cuc.doan@email.com', 200),
(N'Bạch Văn Ngọc', '0983678998', N'35 Trần Bình, Hòa Bình', 'ngoc.bach@email.com', 165),
(N'Vi Thị Lài', '0994789099', N'47 Nguyễn Văn Cừ, Cao Bằng', 'lai.vi@email.com', 180),
(N'Chu Văn Long', '0905890100', N'26 Đinh Tiên Hoàng, Điện Biên', 'long.chu@email.com', 190),
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

(N'Công ty TNHH Sản xuất Minh Đức', N'Hà Nội', '0241234567', 'info@minhduc.com'),
(N'Nhà cung cấp Thiết bị Công Nghệ Bình Minh', N'Đà Nẵng', '0236556677', 'support@binhminh.vn'),
(N'Công ty Xuất khẩu Thăng Long', N'Bình Dương', '0274412345', 'contact@thanglong.vn'),
(N'Nhà phân phối Vật liệu Xây dựng Phú Thọ', N'Vĩnh Phúc', '0211990088', 'factoryphutho@vatlieu.vn'),
(N'Tổ chức Thương mại Quốc tế Hải Minh', N'Quảng Ngãi', '0256937456', 'sales@haiminh.com'),
(N'Công ty Hóa chất Thành Hưng', N'Bắc Ninh', '0222334455', 'order@hoachatthanhhung.com'),
(N'Nhà cung cấp Thiết bị điện Toàn Cầu', N'Hồ Chí Minh', '0281234567', 'info@toancau.vn'),
(N'Xưởng chế tạo Cơ khí Hoàng Nam', N'Hải Phòng', '0222345678', 'factoryhoangnam@chetao.com'),
(N'Tổng công ty Xây dựng Long Phát', N'Hà Nam', '0223334445', 'contact@tongcongtylongphat.com'),
(N'Hợp tác xã Nông sản Vân Nam', N'Thái Nguyên', '0208112299', 'cooperativevannam@hoptac.vn'),
(N'Công ty Kỹ thuật Điện tử Gia Hòa', N'Quảng Ninh', '0233456789', 'technicalgiahoa@congty.com'),
(N'Nhà cung cấp Lắp đặt Hệ thống An Phát', N'Lạng Sơn', '0201234567', 'installanphat@lapdat.com'),
(N'Nhà phân phối Sản phẩm Mới Tiến Phát', N'Hưng Yên', '0221993456', 'distributiontienphat@sanpham.vn'),
(N'Xưởng chế tạo Kim loại Phúc Lộc', N'Thái Bình', '0222112233', 'factoryphucloc@kimloai.vn'),
(N'Công ty Thiết bị Y tế Hòa Bình', N'Hải Dương', '0202223344', 'medicalhoabinh@thietbiyte.vn'),
(N'Nhà cung cấp Dịch vụ Thực phẩm Thảo Nguyên', N'Vĩnh Long', '0270857632', 'service@thao.nguyen.vn'),
(N'Công ty TNHH Vật liệu Xây dựng Toàn Cầu', N'Bắc Giang', '0223456789', 'material@toancau.vn'),
(N'Tổng công ty Dịch vụ Logistic Bắc Trung Nam', N'Nghệ An', '0236541234', 'logistics@btc.com'),
(N'Nhà phân phối Thiết bị Cơ khí Đồng Nai', N'Đồng Nai', '0257889922', 'distributedd@congnghiep.vn'),
(N'Công ty TNHH Sản phẩm Gia dụng Nhật Bản', N'Hà Nội', '0249123456', 'products@nhatban.com'),
(N'Nhà cung cấp Dịch vụ Mạng Thông tin Hải Đăng', N'Hồ Chí Minh', '0287654321', 'network@haidang.vn'),
(N'Xưởng chế tạo Linh kiện Ô tô Tân Thành', N'Quảng Nam', '0234567890', 'factorytanthanh@linhkien.vn'),
(N'Công ty TNHH Công nghệ Mới Sài Gòn', N'Hồ Chí Minh', '0281238765', 'newtech@saigon.com'),
(N'Nhà cung cấp Sản phẩm Điện tử Bình An', N'Hà Nội', '0245566778', 'electronics@binhan.com'),
(N'Tổ chức Dịch vụ Du lịch Sông Hồng', N'Hải Phòng', '0227123456', 'tourism@songhong.vn'),
(N'Nhà phân phối Dược phẩm An Bình', N'Quảng Ngãi', '0256345678', 'pharmacy@anbinh.vn'),
(N'Công ty Cổ phần Dầu khí Đông Á', N'Quảng Trị', '0239945678', 'oil@donga.vn'),
(N'Tổng công ty Vận tải Quốc tế Tiến Lên', N'Phú Thọ', '0209876543', 'transport@tienlen.vn'),
(N'Nhà cung cấp Thực phẩm sạch Hoa Sen', N'Thái Nguyên', '0212666666', 'food@hoasen.vn'),
(N'Xưởng chế tạo Máy móc Công nghiệp Trường Thành', N'Bắc Ninh', '0221998866', 'machinery@truongthanh.vn'),
(N'Công ty Dịch vụ Sửa chữa Ô tô Hoàng Gia', N'Hà Nội', '0241122334', 'carrepair@hoanggia.vn'),

(N'Công ty Sản phẩm Điện Gia Dụng Lioa', N'Khu công nghiệp Lào Cai', '0212123456', 'contact@lioa.com.vn'),
(N'Công ty Thực phẩm Tươi Sống Vinmart', N'Hà Nội', '0243123456', 'info@vinmart.com.vn'),
(N'Nhà phân phối Đồ Gia Dụng Tupperware', N'TP.HCM', '0287654321', 'sales@tupperware.vn'),
(N'Công ty Đồ điện tử Samsung Việt Nam', N'Khu công nghiệp Bình Dương', '0274234567', 'support@samsung.vn'),
(N'Nhà cung cấp Mỹ phẩm Scenti', N'Hà Nội', '0248765432', 'service@scenti.com.vn'),
(N'Nhà cung cấp Thực phẩm An Toàn Vina', N'Đà Nẵng', '0236334555', 'contact@vinatao.com.vn'),
(N'Công ty Thực phẩm Tiện Lợi Nestlé', N'TP.HCM', '0282233445', 'care@nestle.vn'),
(N'Nhà cung cấp Điện thoại Di Động FPT', N'Hà Nội', '0244444555', 'support@fptmobile.vn'),
(N'Công ty Phụ kiện Ô tô Mai Linh', N'Hải Phòng', '0222333444', 'info@mailinhome.vn'),
(N'Nhà cung cấp Nước giải khát Coca-Cola', N'Bắc Ninh', '0223456789', 'sales@cokecorp.vn'),
(N'Công ty Vật liệu xây dựng VinaHome', N'Hà Nội', '0241213145', 'info@vinahome.vn'),
(N'Nhà cung cấp Sản phẩm Thời trang H&M', N'TP.HCM', '0286767889', 'contact@hm.com.vn'),
(N'Công ty Thực phẩm Ánh Dương', N'Quảng Ninh', '0234837383', 'support@anhduongfood.vn'),
(N'Nhà phân phối Đồ điện tử Sony', N'Bình Dương', '0274747474', 'help@sony.com.vn'),
(N'Công ty Cung cấp Tỏi sạch Hồng Phát', N'Vĩnh Phúc', '0211382828', 'contact@hongphat.com.vn'),
(N'Nhà cung cấp Sản phẩm Bảo vệ gia đình Honeywell', N'Hà Nội', '0242525222', 'service@honeywell.vn'),
(N'Công ty Giày dép Nike', N'TP.HCM', '0281292929', 'support@nike.com.vn'),
(N'Nhà cung cấp Thiết bị y tế Medtronic', N'Hải Dương', '0226789098', 'info@medtronic.vn'),
(N'Nhà cung cấp Máy tính Dell Việt Nam', N'Bắc Giang', '0229876543', 'contact@dell.vn'),
(N'Nhà phân phối Sữa tươi Vinamilk', N'Hà Nội', '0249001020', 'sales@vinamilk.vn'),
(N'Công ty Hàng gia dụng Philips', N'Hồ Chí Minh', '0281234567', 'info@philips.vn'),
(N'Nhà cung cấp Thực phẩm sạch Gạo Lúa', N'Thái Nguyên', '0201112233', 'sales@gaolua.com.vn'),
(N'Công ty Đồ chơi trẻ em Lego', N'Bình Dương', '0274234455', 'contact@lego.vn'),
(N'Nhà cung cấp Sản phẩm nội thất IKEA', N'TP.HCM', '0289876543', 'service@ikea.vn'),
(N'Công ty Vận chuyển và Logistics Grab', N'Đà Nẵng', '0236234343', 'support@grab.vn'),
(N'Nhà cung cấp Bánh kẹo Mondelez', N'Hà Nội', '0245432189', 'info@mondelez.vn'),
(N'Công ty Tupperware Việt Nam', N'TP.HCM', '0285678934', 'contact@tupperware.vn'),
(N'Nhà cung cấp Đồ gia dụng Bluestone', N'Bắc Giang', '0223456712', 'info@bluestone.vn'),
(N'Công ty Dược phẩm Sanofi', N'TP.HCM', '0287654345', 'support@sanofi.vn'),
(N'Nhà phân phối Hóa mỹ phẩm P&G', N'Quảng Ngãi', '0234567890', 'service@pg.com.vn'),
(N'Công ty Máy móc và Thiết bị Siemens', N'Vĩnh Phúc', '0213123456', 'help@siemens.vn'),
(N'Nhà cung cấp Dụng cụ thể thao Adidas', N'Hà Nội', '0248765431', 'sales@adidas.vn'),

(N'Công ty Chế biến thực phẩm Minh Dương', N'Hà Nội', '0242333445', 'sales@minhduongfood.vn'),
(N'Nhà cung cấp Điện tử LG', N'TP.HCM', '0286364747', 'support@lg.com.vn'),
(N'Công ty Nước giải khát PepsiCo', N'Bình Dương', '0274747477', 'contact@pepsico.vn'),
(N'Nhà cung cấp Thực phẩm Sữa Ba Vì', N'Hà Nội', '0245454545', 'info@bavi.com.vn'),
(N'Công ty Vận tải và Logistics DHL', N'Hồ Chí Minh', '0282222333', 'support@dhl.com.vn'),
(N'Nhà cung cấp Điện thoại Huawei', N'Bắc Ninh', '0222333444', 'service@huawei.vn'),
(N'Công ty Nội thất Hòa Phát', N'TP.HCM', '0282333445', 'contact@hoaphat.vn'),
(N'Nhà phân phối Thực phẩm Vietfood', N'Hà Nội', '0242123456', 'sales@vietfood.vn'),
(N'Công ty Sản xuất Nhựa An Phú', N'Bắc Giang', '0222345678', 'info@anphu.vn'),
(N'Nhà cung cấp Thực phẩm dinh dưỡng Abbott', N'TP.HCM', '0284534343', 'care@abbott.vn'),
(N'Công ty Máy móc công nghiệp Daewoo', N'Bình Dương', '0274332211', 'info@daewoo.vn'),
(N'Nhà cung cấp Thực phẩm hữu cơ GreenFood', N'Đà Nẵng', '0236333232', 'contact@greenfood.vn'),
(N'Công ty Tư vấn bất động sản Vinhomes', N'Hà Nội', '0242123457', 'info@vinhomes.vn'),
(N'Nhà cung cấp Hóa mỹ phẩm L’Oreal', N'Hồ Chí Minh', '0287654321', 'care@loreal.com.vn'),
(N'Công ty Giày thể thao Puma', N'Bắc Ninh', '0221112233', 'support@puma.vn'),
(N'Nhà phân phối Máy tính bảng Apple', N'Hà Nội', '0246758492', 'support@apple.vn'),
(N'Công ty Sản phẩm Chăm sóc sức khỏe Unilever', N'Bắc Giang', '0221334455', 'service@unilever.vn'),
(N'Nhà cung cấp Tủ lạnh Panasonic', N'Hồ Chí Minh', '0282111222', 'contact@panasonic.vn'),
(N'Công ty Hệ thống điện Schneider', N'Vĩnh Phúc', '0211252323', 'support@schneider.vn'),
(N'Nhà cung cấp Dụng cụ văn phòng Stationery', N'TP.HCM', '0286458789', 'info@stationery.vn'),
(N'Công ty Thiết bị máy tính Acer', N'Bắc Ninh', '0223456789', 'contact@acer.vn'),
(N'Nhà phân phối Đồ gia dụng Sharp', N'TP.HCM', '0282223344', 'sales@sharp.vn'),
(N'Công ty Giày dép Converse', N'Bình Dương', '0274112233', 'service@converse.vn'),
(N'Nhà cung cấp Máy rửa bát Bosch', N'Hà Nội', '0246556777', 'info@bosch.vn'),
(N'Công ty Thiết bị văn phòng Epson', N'Hồ Chí Minh', '0288756655', 'support@epson.vn'),
(N'Nhà phân phối Đồ chơi trẻ em Mattel', N'Hà Nội', '0249777888', 'contact@mattel.vn'),
(N'Công ty Vật liệu xây dựng BMC', N'Bắc Giang', '0222334444', 'sales@bmc.vn'),
(N'Nhà cung cấp Thực phẩm Nhật Bản Takara', N'TP.HCM', '0281333444', 'contact@takara.vn'),
(N'Công ty Điện máy Vinh', N'Hà Nội', '0249990000', 'sales@vinh.vn'),
(N'Nhà phân phối Thiết bị điện Schneider', N'Vĩnh Phúc', '0211113333', 'service@schneider.vn'),
(N'Công ty Vật liệu nội thất An Cường', N'Bắc Ninh', '0222334555', 'info@ancuong.vn'),
(N'Nhà cung cấp Tỏi đen Mộc Sơn', N'Hà Nội', '0248383738', 'support@mocson.com.vn'),
(N'Công ty Cung cấp Hạt giống quốc tế', N'TP.HCM', '0286677889', 'contact@hatgiong.vn'),
(N'Nhà cung cấp Dược phẩm AstraZeneca', N'Hà Nội', '0242123232', 'sales@astrazeneca.vn'),
(N'Công ty Thực phẩm Gia vị Vissan', N'TP.HCM', '0282233445', 'info@vissan.vn'),
(N'Nhà cung cấp Hệ thống điện Hitachi', N'Bắc Giang', '0222344556', 'support@hitachi.vn'),
(N'Công ty Hàng tiêu dùng P&G', N'TP.HCM', '0282222333', 'info@pg.com.vn'),
(N'Nhà cung cấp Đồ gia dụng Moulinex', N'Bắc Ninh', '0222333444', 'service@moulinex.vn'),
(N'Công ty Dụng cụ điện cầm tay Makita', N'Đà Nẵng', '0232333445', 'contact@makita.vn'),
(N'Nhà cung cấp Thực phẩm Hữu cơ Organic', N'Hà Nội', '0243333445', 'info@organic.vn'),
(N'Công ty Thực phẩm nhập khẩu Daily Foods', N'TP.HCM', '0281122334', 'sales@dailyfoods.vn'),
(N'Nhà cung cấp Thiết bị thông minh Xiaomi', N'Hà Nội', '0243334455', 'contact@xiaomi.vn'),
(N'Công ty Sản phẩm chăm sóc gia đình Ariel', N'Bình Dương', '0274736289', 'care@ariel.vn'),
(N'Nhà phân phối Thiết bị giáo dục BenQ', N'TP.HCM', '0286767676', 'support@benq.vn'),
(N'Công ty Bánh kẹo Kinh Đô', N'Bắc Giang', '0222345678', 'contact@kinhdo.vn'),
(N'Nhà cung cấp Dụng cụ thể thao Nike', N'Hà Nội', '0241234567', 'info@nike.vn'),
(N'Công ty Máy lạnh Daikin', N'Bắc Ninh', '0222333445', 'service@daikin.vn'),
(N'Nhà phân phối Sản phẩm siêu thị Big C', N'TP.HCM', '0289888777', 'sales@bigc.vn'),
(N'Công ty Thiết bị điện LG', N'Hà Nội', '0242333344', 'support@lg.com.vn'),
(N'Nhà cung cấp Đồ gia dụng Cuckoo', N'Bắc Giang', '0222334567', 'info@cuckoo.vn'),
(N'Công ty Vận chuyển Grab', N'TP.HCM', '0286677889', 'support@grab.vn'),
(N'Nhà phân phối Phụ kiện điện thoại Anker', N'Hà Nội', '0242333345', 'sales@anker.vn'),
(N'Công ty Thực phẩm quốc tế Masan', N'TP.HCM', '0282222334', 'support@masan.vn'),

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

----- tạo bảng view

---danh sach nhan vien
CREATE VIEW vw_DanhSachNhanVien AS
SELECT MaNV, HoTen, NgaySinh, GioiTinh, ChucVu
FROM NhanVien;
go 
--- danh sach san pham
CREATE VIEW vw_DanhSachSanPham AS
SELECT sp.MaSP, sp.TenSP, lsp.TenLoaiSP, sp.GiaBan, sp.SoLuongTonKho
FROM SanPham sp
JOIN LoaiSanPham lsp ON sp.MaLoaiSP = lsp.MaLoaiSP;

go 
---nhan vien ban duoc nhieu nhat
CREATE VIEW v_NhanVienBanDuocNhieuNhat AS
SELECT TOP 1 nv.MaNV, nv.HoTen, SUM(hdb.TongTien) AS TongTienBan
FROM HoaDonBan hdb
JOIN NhanVien nv ON hdb.MaNV = nv.MaNV
GROUP BY nv.MaNV, nv.HoTen
ORDER BY TongTienBan DESC;

go 
--- sản phẩm sap hêt hạn
CREATE VIEW v_SanPhamSapHetHan AS
SELECT MaSP, TenSP, HanSuDung
FROM SanPham
WHERE HanSuDung IS NOT NULL AND HanSuDung <= DATEADD(day, 30, GETDATE()) AND HanSuDung >= GETDATE();

go
---Doanh thu thoe loai san pham
CREATE VIEW v_DoanhThuTheoLoaiSanPhamThang AS
SELECT lsp.TenLoaiSP, SUM(cthdb.ThanhTien) AS DoanhThu
FROM ChiTietHDBan cthdb
JOIN SanPham sp ON cthdb.MaSP = sp.MaSP
JOIN LoaiSanPham lsp ON sp.MaLoaiSP = lsp.MaLoaiSP
JOIN HoaDonBan hdb ON cthdb.MaHDBan = hdb.MaHDBan
WHERE YEAR(hdb.NgayBan) = YEAR(GETDATE()) AND MONTH(hdb.NgayBan) = MONTH(GETDATE())
GROUP BY lsp.TenLoaiSP;

go
---tong so luong nhaop theo nha cung cap
CREATE VIEW v_TongSoLuongNhapTheoNCCThang AS
SELECT ncc.TenNCC, SUM(cthdn.SoLuong) AS TongSoLuongNhap
FROM ChiTietHDNhap cthdn
JOIN HoaDonNhap hdn ON cthdn.MaHDNhap = hdn.MaHDNhap
JOIN NhaCungCap ncc ON hdn.MaNCC = ncc.MaNCC
WHERE YEAR(hdn.NgayNhap) = YEAR(GETDATE()) AND MONTH(hdn.NgayNhap) = MONTH(GETDATE())
GROUP BY ncc.TenNCC;

go
---bang view top 5 sang pham ban chay nhat thanh

CREATE VIEW v_Top5SanPhamBanChayNhatThang AS
SELECT TOP 5 sp.MaSP, sp.TenSP, SUM(cthdb.SoLuong) AS TongSoLuongBan
FROM ChiTietHDBan cthdb
JOIN SanPham sp ON cthdb.MaSP = sp.MaSP
JOIN HoaDonBan hdb ON cthdb.MaHDBan = hdb.MaHDBan
WHERE YEAR(hdb.NgayBan) = YEAR(GETDATE()) AND MONTH(hdb.NgayBan) = MONTH(GETDATE())
GROUP BY sp.MaSP, sp.TenSP
ORDER BY TongSoLuongBan DESC;
go
-- khach hang tiem nang
CREATE VIEW v_KhachHangTiemNang AS
SELECT kh.MaKH, kh.HoTen, kh.DiemTichLuy
FROM KhachHang kh
WHERE kh.MaKH NOT IN (
    SELECT DISTINCT MaKH
    FROM HoaDonBan
    WHERE NgayBan >= DATEADD(month, -3, GETDATE())
)
ORDER BY kh.DiemTichLuy DESC;

go
---- bang biew so luong chenh lech kiem kho
CREATE VIEW v_SoLuongChenhLechKiemKho AS
SELECT
    pkk.MaPhieuKK,
    pkk.NgayKiemKho,
    nv.HoTen AS NguoiKiemKho,
    sp.TenSP,
    ctpkk.SoLuongThucTe,
    ctpkk.SoLuongHeThong,
    ctpkk.ChenhLech
FROM PhieuKiemKho pkk
JOIN ChiTietPhieuKiemKho ctpkk ON pkk.MaPhieuKK = ctpkk.MaPhieuKK
JOIN SanPham sp ON ctpkk.MaSP = sp.MaSP
JOIN NhanVien nv ON pkk.MaNV = nv.MaNV;

go
----- bang view  san pham cap nhat them
CREATE VIEW v_SanPhamCanNhapThem AS
SELECT sp.MaSP, sp.TenSP, sp.SoLuongTonKho, SUM(cthdb.SoLuong) AS SoLuongBanTrongThang
FROM SanPham sp
JOIN ChiTietHDBan cthdb ON sp.MaSP = cthdb.MaSP
JOIN HoaDonBan hdb ON cthdb.MaHDBan = hdb.MaHDBan
WHERE sp.SoLuongTonKho < 20
  AND YEAR(hdb.NgayBan) = YEAR(GETDATE()) AND MONTH(hdb.NgayBan) = MONTH(GETDATE())
GROUP BY sp.MaSP, sp.TenSP, sp.SoLuongTonKho
HAVING SUM(cthdb.SoLuong) > 50;

go
--- bang view chi tiet khuyen mai ten san pham va ten khuuyen mai
CREATE VIEW v_ChiTietKhuyenMaiVoiTenSPVaTenKM AS
SELECT km.TenKM, sp.TenSP
FROM ChiTietKhuyenMai ctkm
JOIN KhuyenMai km ON ctkm.MaKM = km.MaKM
JOIN SanPham sp ON ctkm.MaSP = sp.MaSP;

go
--bang vew có thong ke nhap xuat hang thang
CREATE VIEW v_ThongKeNhapXuatTonThang AS
SELECT
    sp.MaSP,
    sp.TenSP,
    SUM(CASE WHEN YEAR(hdn.NgayNhap) = YEAR(GETDATE()) AND MONTH(hdn.NgayNhap) = MONTH(GETDATE()) THEN cthdn.SoLuong ELSE 0 END) AS TongSoLuongNhapThang,
    SUM(CASE WHEN YEAR(hdb.NgayBan) = YEAR(GETDATE()) AND MONTH(hdb.NgayBan) = MONTH(GETDATE()) THEN cthdb.SoLuong ELSE 0 END) AS TongSoLuongXuatThang,
    sp.SoLuongTonKho AS TonHienTai
FROM SanPham sp
LEFT JOIN ChiTietHDNhap cthdn ON sp.MaSP = cthdn.MaSP
LEFT JOIN HoaDonNhap hdn ON cthdn.MaHDNhap = hdn.MaHDNhap
LEFT JOIN ChiTietHDBan cthdb ON sp.MaSP = cthdb.MaSP
LEFT JOIN HoaDonBan hdb ON cthdb.MaHDBan = hdb.MaHDBan
GROUP BY sp.MaSP, sp.TenSP, sp.SoLuongTonKho;

go

---bảng view nhan vien co hoa don cao nhat
CREATE VIEW v_NhanVienCoHoaDonBanCaoNhat AS
SELECT TOP 1 nv.MaNV, nv.HoTen, SUM(hdb.TongTien) AS TongGiaTriBan
FROM NhanVien nv
JOIN HoaDonBan hdb ON nv.MaNV = hdb.MaNV
WHERE YEAR(hdb.NgayBan) = YEAR(GETDATE())
GROUP BY nv.MaNV, nv.HoTen
ORDER BY TongGiaTriBan DESC;

go
--bảng view SanPhamLoiNhuanCaoNhatThang
CREATE VIEW v_SanPhamLoiNhuanCaoNhatThang AS
SELECT TOP 1
    sp.MaSP,
    sp.TenSP,
    SUM(cthdb.SoLuong * (sp.GiaBan - sp.GiaNhap)) AS TongLoiNhuan
FROM ChiTietHDBan cthdb
JOIN SanPham sp ON cthdb.MaSP = sp.MaSP
JOIN HoaDonBan hdb ON cthdb.MaHDBan = hdb.MaHDBan
WHERE YEAR(hdb.NgayBan) = YEAR(GETDATE()) AND MONTH(hdb.NgayBan) = MONTH(GETDATE())
GROUP BY sp.MaSP, sp.TenSP
ORDER BY TongLoiNhuan DESC;

--- store proucedure
go
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

-------------apdung khuyen cho san pham
CREATE PROCEDURE sp_ApDungKhuyenMaiChoSanPham (
    @MaKM INT,
    @DanhSachMasP VARCHAR(MAX) -- Chuỗi các MasP cách nhau bởi dấu phẩy
)
AS
BEGIN
    -- Kiểm tra mã khuyến mãi có tồn tại
    IF NOT EXISTS (SELECT 1 FROM KhuyenMai WHERE MaKM = @MaKM)
    BEGIN
        RAISERROR('Mã khuyến mãi không tồn tại.', 16, 1);
        RETURN;
    END

    -- Tách chuỗi MasP thành các giá trị riêng lẻ
    DECLARE @MasPTach INT;
    DECLARE @DanhSachMasPTach TABLE (MasP INT);

    WHILE LEN(@DanhSachMasP) > 0
    BEGIN
        IF CHARINDEX(',', @DanhSachMasP) > 0
        BEGIN
            SELECT @MasPTach = CAST(SUBSTRING(@DanhSachMasP, 1, CHARINDEX(',', @DanhSachMasP) - 1) AS INT);
            SET @DanhSachMasP = SUBSTRING(@DanhSachMasP, CHARINDEX(',', @DanhSachMasP) + 1, LEN(@DanhSachMasP));
        END
        ELSE
        BEGIN
            SELECT @MasPTach = CAST(@DanhSachMasP AS INT);
            SET @DanhSachMasP = '';
        END

        IF ISNUMERIC(@MasPTach) = 1 AND EXISTS (SELECT 1 FROM SanPham WHERE MasP = CAST(@MasPTach AS INT))
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM ChiTietKhuyenMai WHERE MaKM = @MaKM AND MasP = CAST(@MasPTach AS INT))
            BEGIN
                INSERT INTO ChiTietKhuyenMai (MaKM, MasP)
                VALUES (@MaKM, CAST(@MasPTach AS INT));
            END
        END
        ELSE IF ISNUMERIC(@MasPTach) = 0 AND LEN(LTRIM(RTRIM(@MasPTach))) > 0
        BEGIN
            RAISERROR('Mã sản phẩm không hợp lệ: %s', 16, 1, @MasPTach);
            RETURN;
        END
        ELSE IF NOT EXISTS (SELECT 1 FROM SanPham WHERE MasP = CAST(@MasPTach AS INT)) AND ISNUMERIC(@MasPTach) = 1
        BEGIN
            RAISERROR('Mã sản phẩm không tồn tại: %s', 16, 1, @MasPTach);
            RETURN;
        END
    END
END;
GO


------------ lấy theo san pham theo loai
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