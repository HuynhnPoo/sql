--=================================================================Nhóm 2======================================================================================---
--- --------------------------------------Quản Lý Cửa Hàng Tiện Lợi ------------------------------------------------------------------

-----------------------------------------------------tạo database--------------------------------------------
create database QLCHTL
on(
	NAME='QLCHTL_DATA',
	FILENAME ='D:\QLCHTL_DATA.mdf',
	SIZE=10MB,
	MAXSIZE=100MB,
	FILEGROWTH=5MB
)
LOG on(
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
    MaNV int identity(1,1)primary key,
    HoTen nvarchar(255),
    NgaySinh date,
    GioiTinh nvarchar(10) CHECK (GioiTinh IN (N'Nam', N'Nữ')),
    DiaChi nvarchar(255),
   SDT varchar(20) NOT NULL ,
   Email varchar(255) ,
    ChucVu nvarchar(50) NOT NULL,
    NgayVaoLam date,
    Luong DECIMAL(10, 2) CHECK (Luong > 0)
);
go

-- Bảng KhachHang
create table KhachHang (
    MaKH int identity(1,1)primary key,
    HoTen nvarchar(255) NOT NULL,
    SDT varchar(20) NOT NULL ,
    DiaChi nvarchar(255),
    Email varchar(255) ,
    DiemTichLuy int DEFAULT 0
);
go
-- Bảng NhaCungCap
create table NhaCungCap (
    MaNCC int identity(1,1)primary key,
    TenNCC nvarchar(255) NOT NULL ,
    DiaChi nvarchar(255),
    SDT varchar(20) ,
    Email varchar(255) 
);
go
-- Bảng LoaiSanPham
create table LoaiSanPham (
    MaLoaiSP int identity(1,1)primary key,
    TenLoaiSP nvarchar(255) NOT NULL,
    MoTa nvarchar(MAX)
);
go
-- Bảng SanPham
create table SanPham (
    MasP int primary key,
    TenSP nvarchar(255) NOT NULL,
    MaLoaiSP int NOT NULL,
    MaNCC int NOT NULL,
    DonViTinh nvarchar(50) NOT NULL,
    GiaNhap DECIMAL(10, 2) NOT NULL CHECK (GiaNhap >= 0),
    GiaBan DECIMAL(10, 2) NOT NULL CHECK (GiaBan >= 0),
    SoLuongTonKho int NOT NULL CHECK (SoLuongTonKho >= 0) DEFAULT 0,
    HanSuDung date,
    MoTa nvarchar(MAX),
    FOREIGN KEY (MaLoaiSP) REFERENCES LoaiSanPham(MaLoaiSP),
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);
go
-- Bảng KhuyenMai
create table KhuyenMai (
    MaKM int identity(1,1)primary key,
    TenKM nvarchar(40),
    NgayBatDau date,
    NgayKetThuc date,
    PhanTramGiamGia DECIMAL(5, 2) CHECK (PhanTramGiamGia BETWEEN 0 AND 100),
    MoTa nvarchar(MAX)
);
go
-- Bảng ChiTietKhuyenMai
create table ChiTietKhuyenMai (
    MaKM int NOT NULL,
    MasP int NOT NULL,
   primary key (MaKM, MasP),
    FOREIGN KEY (MaKM) REFERENCES KhuyenMai(MaKM),
    FOREIGN KEY (MasP) REFERENCES SanPham(MasP)
);
go
-- Bảng HoaDonBan
create table HoaDonBan (
    MaHDBan int identity(1,1)primary key,
    MaNV int NOT NULL,
    MaKH int NOT NULL,
    NgayBan dateTIME DEFAULT GETdate(),
    TongTien DECIMAL(10, 2) NOT NULL CHECK (TongTien >= 0),
    DiemSuDung int DEFAULT 0 CHECK (DiemSuDung >= 0),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);
go
-- Bảng ChiTietHDBan
create table ChiTietHDBan (
    MaHDBan int NOT NULL,
    MasP int NOT NULL,
      SoLuong int NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(10, 2) NOT NULL CHECK (DonGia >= 0),
    ThanhTien DECIMAL(10, 2) NOT NULL CHECK (ThanhTien >= 0),
   primary key (MaHDBan, MasP),
    FOREIGN KEY (MaHDBan) REFERENCES HoaDonBan(MaHDBan),
    FOREIGN KEY (MasP) REFERENCES SanPham(MasP)
);
go
-- Bảng HoaDonNhap
create table HoaDonNhap (
    MaHDNhap int identity(1,1)primary key,
    MaNV int NOT NULL,
    MaNCC int NOT NULL,
    NgayNhap dateTIME NOT NULL DEFAULT GETdate(),
    TongTien DECIMAL(10, 2) NOT NULL CHECK (TongTien >= 0),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC)
);
go
-- Bảng ChiTietHDNhap
create table ChiTietHDNhap (
   MaHDNhap int NOT NULL,
    MasP int NOT NULL,
    SoLuong int NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(10, 2) NOT NULL CHECK (DonGia >= 0),
    ThanhTien DECIMAL(10, 2) NOT NULL CHECK (ThanhTien >= 0),
   primary key (MaHDNhap, MasP),
    FOREIGN KEY (MaHDNhap) REFERENCES HoaDonNhap(MaHDNhap),
    FOREIGN KEY (MasP) REFERENCES SanPham(MasP)
);
go
-- Bảng PhieuKiemKho
create table PhieuKiemKho (
    MaPhieuKK int identity(1,1)primary key,
    MaNV int NOT NULL,
    NgayKiemKho dateTIME NOT NULL DEFAULT GETdate(),
    MoTa nvarchar(MAX),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);
go
-- Bảng ChiTietPhieuKiemKho
create table ChiTietPhieuKiemKho (
     MaPhieuKK int NOT NULL,
    MasP int NOT NULL,
    SoLuongThucTe int NOT NULL CHECK (SoLuongThucTe >= 0),
    SoLuongHeThong int NOT NULL CHECK (SoLuongHeThong >= 0),
    ChenhLech int NOT NULL,
   primary key (MaPhieuKK, MasP),
    FOREIGN KEY (MaPhieuKK) REFERENCES PhieuKiemKho(MaPhieuKK),
    FOREIGN KEY (MasP) REFERENCES SanPham(MasP)
);
go

-----------------------------------------------------thêm dữ liệu vào bảng --------------------------------------------
-- Bảng NhanVien
insert into NhanVien (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, Email, ChucVu, NgayVaoLam, Luong) VALUES
(N'Nguyễn Văn A', '1990-05-15', N'Nam', N'Hà Nội', '090123467', 'annguyen@email.com', N'Quản lý', '2020-08-01', 15000000),
(N'Trần Thị B', '1992-11-20', N'Nữ', N'Hà Nội', '098765321', 'btran@email.com', N'Nhân viên bán hàng', '2021-03-10', 8000000),
(N'Lê Văn C', '1988-07-05', N'Nam', N' Hà Nội', '091245678', 'cle@email.com', N'Kế toán', '2022-01-15', 10000000),
(N'Phạm Thị D', '1995-02-28', N'Nữ', N'Nam Định', '098901234', 'dpham@email.com', N'Thu ngân', '2022-05-20', 7500000),
(N'Hoàng Văn E', '1991-09-10', N'Nam', N'Thái Bình', '034567890', 'ehoang@email.com', N'Nhân viên kho', '2023-07-01', 8500000),
(N'Vũ Thị F', '1993-04-01', N'Nữ', N' HCM', '096543219', 'fvu@email.com', N'Marketing', '2023-11-05', 9500000),
(N'Đặng Văn G', '1989-12-25', N'Nam', N' Bắc Ninh', '041234567', 'gdang@email.com', N'IT', '2024-02-10', 12000000),
(N'Bùi Thị H', '1994-06-30', N'Nữ', N'Bắc Giang', '098765432', 'hbui@email.com', N'Chăm sóc khách hàng', '2024-06-15', 8200000),
(N'Cao Văn I', '1996-01-20', N'Nam', N'Hà Nam', '090876543', 'icao@email.com', N'Bảo vệ', '2024-09-01', 7000000),
(N'Lê Văn G', '1992-11-18', N'Nam', N'HCM', '090111001', 'gle@email.com', N'Nhân viên bán hàng', '2023-01-15', 8200000),
(N'Phạm Thị H', '1987-05-03', N'Nữ', N'Lạng Sơn', '098222002', 'hham@emil.com', N'Kế toán', '2021-07-20', 9500000),
(N'Hoàng Văn I', '1995-09-25', N'Nam', N'Lai Châu', '091333303', 'hoang@email.com', N'Thu ngân', '2024-03-10', 7000000),
(N'Trần Thị K', '1990-03-12', N'Nữ', N'Cao Bằng', '097444400', 'ran@email.com', N'Nhân viên kho', '2022-09-05', 7800000),
(N'Vũ Văn L', '1998-07-01', N'Nam', N'Hưng Yên', '093555505', 'vu@email.com', N'Marketing', '2025-01-01', 9000000),
(N'Đặng Thị M', '1983-12-10', N'Nữ', N'Yên bái', '096666606', 'mdang@email.com', N'IT', '2020-11-20', 12500000),
(N'Bùi Văn N', '1996-04-17', N'Nam', N'Ninh Bình', '094777007', 'nbui@email.com', N'Chăm sóc khách hàng', '2023-05-25', 8000000),
(N'Cao Thị O', '1991-08-28', N'Nữ', N' Hà Nội', '092888008', 'ocao@email.com', N'Bảo vệ', '2024-08-15', 6800000),
(N'Mai Văn P', '1999-01-05', N'Nam', N' Hà Nội', '090999009', 'pmai@email.com', N'Thực tập sinh', '2025-04-01', 5200000),
(N'Lý Thị Q', '1985-06-20', N'Nữ', N' Hà Nội', '091011010', 'qly@email.com', N'Quản lý kho', '2022-02-10', 9200000),
(N'Vương Văn R', '1993-11-02', N'Nam', N' Hà Nội', '981222011', 'rvuong@email.com', N'Bán hàng online', '2023-08-25', 7900000),
(N'Ngô Thị S', '1988-02-15', N'Nữ', N'Hà Nội', '093333012', 'sngo@email.com', N'Kỹ thuật viên', '2021-01-01', 11500000),
(N'Phùng Văn T', '1997-05-28', N'Nam', N'Nghệ An', '963444013', 'tphung@email.com', N'Lễ tân', '2024-09-20', 6700000),
(N'Trịnh Thị U', '1990-09-10', N'Nữ', N'Hà Nội', '094455501', 'utrinh@email.com', N'Nhân viên giao hàng', '2025-05-15', 7300000),
(N'Hồ Văn V', '1994-12-25', N'Nam', N'Thái Bình', '092566605', 'vho@email.com', N'Tuyển dụng', '2023-12-01', 8500000),
(N'Bạch Thị X', '1989-07-08', N'Nữ', N'Thái Bình', '090677016', 'xbach@email.com', N'Trưởng nhóm bán hàng', '2024-04-10', 10800000),
(N'Sầm Văn Y', '1996-01-20', N'Nam', N' Hà Nội', '097788017', 'ysam@email.com', N'Nhân viên hỗ trợ', '2022-06-25', 7700000),
(N'Quách Thị Z', '1991-04-03', N'Nữ', N'Hà Nội', '093899018', 'zquach@email.com', N'Phân tích dữ liệu', '2025-02-01', 11200000),
(N'Uông Văn AA', '1999-09-15', N'Nam', N'Nam Định', '069000019', 'a.uong@email.com', N'Thực tập sinh marketing', '2024-10-15', 5300000),
(N'Phan Thị BB', '1984-03-01', N'Nữ', N'Hà Nội', '091222020', 'bb.phan@mail.com', N'Kiểm toán viên', '2023-03-01', 12200000),
(N'Lâm Văn CC', '1997-07-18', N'Nam', N'Bắc cạn', '082333021', 'cclam@email.com', N'Nhân viên lễ tân', '2024-11-30', 6900000),
(N'Trần Thị DD', '1992-10-25', N'Nữ', N'Thanh Hóa', '933444022', 'ddtran@email.com', N'Chuyên viên nhân sự', '2022-07-10', 9800000),
(N'Đỗ Văn EE', '1987-01-10', N'Nam', N'Hà Nội', '096555023', 'eedo@email.com', N'Nhân viên kinh doanh', '2025-01-01', 8100000),
(N'Nguyễn Thị FF', '1995-05-03', N'Nữ', N'Hòa Bình', '945666024', 'ffnguyen@email.com', N'Nhân viên kỹ thuật', '2023-04-20', 10200000),
(N'Lê Văn GG', '1990-08-20', N'Nam', N'Hà Nội', '092677025', 'gge@email.com', N'Marketing executive', '2021-09-01', 9400000),
(N'Phạm Thị HH', '1998-12-05', N'Nữ', N'Hà Nội', '090888026', 'hham@email.com', N'Nhân viên kho', '2024-07-15', 7600000),
(N'Hoàng Văn II', '1983-03-15', N'Nam', N'Yên Bái', '098999027', 'ioang@email.com', N'Trưởng phòng kinh doanh', '2022-10-05', 14500000),
(N'Trần Thị JJ', '1996-07-01', N'Nữ', N'Quảng Ninh', '019000028', 'tran@email.com', N'Phó phòng marketing', '2024-12-10', 11200000),
(N'Vũ Văn KK', '1991-10-18', N'Nam', N'Hải Phòng', '090111029', 'vu@eail.com', N'Nhân viên hành chính', '2023-03-01', 7100000),
(N'Đặng Thị LL', '1999-02-25', N'Nữ', N'Hải Dương', '031222030', 'dang@email.com', N'Quản lý dự án', '2025-05-20', 13800000),
(N'Bùi Văn MM', '1986-06-10', N'Nam', N'Hải Phòng', '062333031', 'mbui@email.com', N'Kiểm soát chất lượng', '2022-08-01', 10000000),
(N'Cao Thị NN', '1994-11-22', N'Nữ', N'Hà Nội', '094344032', 'nao@email.com', N'Chuyên viên tài chính', '2024-01-15', 11800000),
(N'Mai Văn OO', '1989-04-05', N'Nam', N'Hà Nội', '094555033', 'oo.mai@emaádl.com', N'Nhân viên nhập liệu', '2023-06-10', 6500000),
(N'Lý Thị PP', '1997-08-12', N'Nữ', N'Hà Nội', '090666034', 'pp@email.com', N'Trưởng nhóm kỹ thuật', '2025-02-25', 15000000),
(N'Vương Văn QQ', '1982-12-28', N'Nam', N'Hà Nội', '086777035', 'qq.uong@email.com', N'Phó phòng nhân sự', '2021-11-01', 12500000),
(N'Ngô Thị RR', '1995-03-03', N'Nữ', N'Hà Nội', '093788036', 'r.ngo@email.com', N'Nhân viên thống kê', '2024-09-05', 8800000),
(N'Phùng Văn SS', '1990-07-15', N'Nam', N'Bình Định', '096899037', 'shung@email.com', N'Chuyên viên đào tạo', '2022-03-10', 10500000),
(N'Trịnh Thị TT', '1998-11-20', N'Nữ', N'Hà Nội', '09490038', 'trinh@email.com', N'Thư ký', '2025-01-20', 6200000),
(N'Hồ Văn UU', '1983-04-01', N'Nam', N'Nam Định', '092111039', 'uuo@email.com', N'Quản lý chi nhánh', '2023-07-01', 16000000),
(N'Bạch Thị VV', '1996-08-17', N'Nữ', N'HCM', '090122040', 'vvch@email.com', N'Nhân viên marketing online', '2024-04-15', 9100000),
(N'Sầm Văn WW', '1991-12-03', N'Nam', N'HCM', '097233041', 'wwam@email.com', N'Thiết kế đồ họa', '2022-09-20', 10800000),
(N'Quách Thị XX', '1999-05-10', N'Nữ', N'HCM', '09344042', 'xquach@email.com', N'Nhân viên lễ tân', '2025-02-01', 7000000),
(N'Uông Văn YY', '1984-09-25', N'Nam', N'Hà Nội', '064555043', 'yuong@email.com', N'Chuyên viên mua hàng', '2023-12-10', 9600000),
(N'Phan Thị ZZ', '1997-01-01', N'Nữ', N'Bắc Giang', '095666044', 'zphan@email.com', N'Nhân viên bán vé', '2024-08-25', 7400000),
(N'Lâm Văn AAA', '1992-04-17', N'Nam', N'Hà Nam', '092777045', 'aaalam@email.com', N'Kỹ sư phần mềm', '2022-05-01', 13000000),
(N'Trần Thị BBB', '1987-08-28', N'Nữ', N'Bắc Giang', '0908046', 'bbbtran@email.com', N'Chuyên viên kiểm toán', '2025-03-15', 11500000),
(N'Mai Thị K', '1992-08-12', N'Nữ', N'Hà Nam', '09776541', 'kmai@email.com', N'Thực tập sinh', '2025-01-05', 5000000),
(N'Trịnh Thị Quỳnh', '1992-07-09', N'Nữ', N'Hà Nam', '09803456', 'quynhinh@gmail.com', N'Nhân viên hành chính', '2023-08-10', 8800000),
(N'Nguyễn Văn Lâm', '1990-03-03', N'Nam', N'Hà Nội', '09913456', 'lamguyen@gmail.com', N'Nhân viên IT', '2022-09-15', 9700000),
(N'Phạm Thị Hồng', '1995-06-11', N'Nữ', N'TP.HCM', '090212346', 'hongham@gmail.com', N'Chuyên viên tư vấn', '2023-12-05', 8900000),
(N'Lê Văn Đạo', '1989-10-22', N'Nam', N'Đà Nẵng', '091312456', 'daoe@gmail.com', N'Kỹ sư phần mềm', '2021-07-20', 12300000),
(N'Hoàng Thị Nhung', '1993-01-17', N'Nữ', N'Quảng Trị', '924123456', 'nhuhoang@gmail.com', N'Nhân viên kế toán', '2022-05-11', 8600000),
(N'Ngô Văn Đức', '1988-04-30', N'Nam', N'Thái Nguyên', '0325123456', 'ducngo@gmail.com', N'Quản trị hệ thống', '2023-03-18', 11000000),
(N'Trần Thị Kim', '1997-09-25', N'Nữ', N'Ninh Bình', '09123456', 'kimtran@gmail.com', N'Chuyên viên truyền thông', '2024-04-04', 9400000),
(N'Phan Văn Toàn', '1991-12-01', N'Nam', N'Bắc Giang', '093123456', 'toanphan@gmail.com', N'Nhân viên kỹ thuật', '2022-12-01', 9900000),
(N'Thái Thị Hòa', '1994-08-06', N'Nữ', N'Nam Định', '096234885', 'hoathai@gmail.com', N'Chuyên viên đào tạo', '2024-01-15', 10000000),
(N'Hà Văn Tùng', '1987-11-29', N'Nam', N'Lạng Sơn', '09912346', 'tungha@gmail.com', N'Nhân viên vận hành', '2021-11-01', 8800000),
(N'Đinh Thị Hạnh', '1996-02-18', N'Nữ', N'Thanh Hóa', '09008012367', 'hanhdinh@gmail.com', N'Nhân viên CSKH', '2023-05-05', 8600000),
(N'Nguyễn Văn Bình', '1992-05-23', N'Nam', N'Tuyên Quang', '09881123478', 'binhguyen@gmail.com', N'Bảo trì hệ thống', '2022-08-10', 9300000),
(N'Phạm Thị Yến', '1990-06-30', N'Nữ', N'Bình Định', '0902124889', 'yenm@gmail.com', N'Chuyên viên PR', '2023-10-01', 9700000),
(N'Lý Văn Khánh', '1993-03-27', N'Nam', N'Kiên Giang', '091123490', 'khanhly@gmail.com', N'Thiết kế giao diện', '2023-06-20', 10400000),
(N'Đỗ Thị Trang', '1995-11-12', N'Nữ', N'Hậu Giang', '092413411', 'trangdo@gmail.com', N'Nhân viên nhân sự', '2022-10-15', 9200000),
(N'Cao Văn Bình', '1989-08-14', N'Nam', N'Bến Tre', '093512334422', 'binhao@gmail.com', N'Kế toán trưởng', '2021-03-01', 12500000),
(N'Trương Thị Linh', '1996-01-04', N'Nữ', N'Đồng Tháp', '046123433', 'linhruong@gmail.com', N'Nhân viên chăm sóc KH', '2024-03-01', 8500000),
(N'Bùi Văn Trí', '1990-09-16', N'Nam', N'Tây Ninh', '09571233444', 'triui@gmail.com', N'Quản lý kỹ thuật', '2022-12-20', 11400000),
(N'Trần Thị Mai', '1994-04-09', N'Nữ', N'An Giang', '09681234525', 'mairan@gmail.com', N'Trợ lý Giám đốc', '2024-01-05', 9900000),
(N'Nguyễn Văn Phú', '1988-07-05', N'Nam', N'Long An', '09791234626', 'phguyen@gmail.com', N'Trưởng bộ phận IT', '2021-05-10', 14000000),
(N'Lê Thị Hoa', '1993-12-20', N'Nữ', N'Hà Tĩnh', '098012477', 'hole@gmail.com', N'Nhân viên bán hàng', '2023-07-15', 8200000),
(N'Hoàng Văn Long', '1992-10-03', N'Nam', N'Phú Thọ', '099113488', 'longhoang@gmail.com', N'Nhân viên tài chính', '2022-09-25', 9700000),
(N'Phạm Thị Dung', '1991-01-25', N'Nữ', N'Hòa Bình', '09021234299', 'dungpham@gmail.com', N'Trợ lý hành chính', '2023-04-01', 8600000),
(N'Trịnh Văn Khôi', '1987-05-11', N'Nam', N'Quảng Nam', '091312340', 'khoi2rinh@gmail.com', N'Chuyên viên hệ thống', '2022-07-01', 11800000),
(N'Nguyễn Thị Lệ', '1993-03-21', N'Nữ', N'Cần Thơ', '0933123426', 'le2nguyen@gmail.com', N'Nhân viên thống kê', '2023-11-10', 9200000),
(N'Phạm Văn Định', '1991-06-14', N'Nam', N'Nghệ An', '0942412456', 'dinh2ham@gmail.com', N'Thủ kho', '2022-08-20', 8700000),
(N'Lê Thị Hằng', '1996-12-05', N'Nữ', N'Bình Dương', '095512456', 'hangle@gmail.com', N'Nhân viên chăm sóc khách hàng', '2024-05-30', 8600000),
(N'Hoàng Văn Kiên', '1988-05-19', N'Nam', N'Đồng Nai', '096123456', 'kienhoang@gmail.com', N'IT Helpdesk', '2023-07-01', 9800000),
(N'Ngô Thị Ngọc', '1995-10-02', N'Nữ', N'Hậu Giang', '097723456', 'ngocgo@gmail.com', N'Marketing', '2024-01-01', 9400000),
(N'Bùi Văn Phong', '1990-11-17', N'Nam', N'Tây Ninh', '098123456', 'phongbui@gmail.com', N'Nhân viên kỹ thuật', '2023-06-01', 10500000),
(N'Vũ Thị Mai', '1987-02-26', N'Nữ', N'Bến Tre', '099912456', 'maiu@gmail.com', N'Trưởng phòng nhân sự', '2021-09-15', 13500000),
(N'Trần Văn Tiến', '1992-08-08', N'Nam', N'Hưng Yên', '001123456', 'tienn@gmail.com', N'Nhân viên kho', '2023-04-01', 7600000),
(N'Đặng Thị Yến', '1994-09-30', N'Nữ', N'Lào Cai', '091123456', 'yeng@gmail.com', N'Thư ký', '2025-01-10', 6700000),
(N'Cao Văn Trường', '1991-12-15', N'Nam', N'Sơn La', '923123456', 'truongao@gmail.com', N'Bảo vệ', '2023-11-20', 7000000),
(N'Phan Thị Hương', '1990-04-25', N'Nữ', N'Lâm Đồng', '034123456', 'huonghan@gmail.com', N'Nhân viên hành chính', '2022-10-01', 8800000),
(N'Mai Văn Hoàn', '1985-01-05', N'Nam', N'Tuyên Quang', '045123456', 'hoanai@gmail.com', N'Kiểm toán viên', '2023-05-15', 11500000),
(N'Quách Thị Tuyết', '1997-06-21', N'Nữ', N'Phú Yên', '096123456', 'tuyetquach@gmail.com', N'Chuyên viên nhân sự', '2024-06-25', 9800000),
(N'Nguyễn Minh Hải', '1989-03-11', N'Nam', N'Hà Tĩnh', '067123456', 'hainguyen@gmail.com', N'Phân tích dữ liệu', '2022-07-01', 11000000),
(N'Trịnh Văn Hoàng', '1993-12-29', N'Nam', N'Quảng Ngãi', '0978123456', 'hoanginh@gmail.com', N'Quản lý chất lượng', '2021-12-10', 12500000),
(N'Đỗ Thị Bích', '1996-07-06', N'Nữ', N'Bạc Liêu', '0989123456', 'bicho@gmail.com', N'Chuyên viên đào tạo', '2024-03-05', 10200000),
(N'Lý Văn Cường', '1991-09-18', N'Nam', N'Quảng Bình', '0990123456', 'cuongly@gmail.com', N'IT', '2022-06-20', 12200000),
(N'Bạch Thị Thủy', '1995-05-27', N'Nữ', N'An Giang', '0902134567', 'thuych@gmail.com', N'Marketing online', '2023-09-01', 9500000),
(N'Trần Quốc Việt', '1992-01-14', N'Nam', N'Vĩnh Long', '0913145678', 'vietran@gmail.com', N'Thiết kế đồ họa', '2024-02-15', 10800000),
(N'Hồ Thị Hạnh', '1998-11-02', N'Nữ', N'Trà Vinh', '0924156789', 'hanhho@gmail.com', N'Phó phòng tài chính', '2025-03-01', 11700000),
(N'Ngô Văn Huy', '1990-08-24', N'Nam', N'Ninh Thuận', '0935167890', 'huyngo@gmail.com', N'Trưởng nhóm kiểm toán', '2021-10-01', 13500000),
(N'Đặng Thị Thanh', '1994-03-18', N'Nữ', N'Kon Tum', '0946178901', 'thanhdang@gmail.com', N'Nhân viên kinh doanh', '2023-11-10', 8100000),
(N'Cao Văn Hòa', '1988-10-07', N'Nam', N'Gia Lai', '0957189012', 'hoaao@gmail.com', N'Nhân viên hỗ trợ', '2023-06-25', 7700000),
(N'Bùi Thị Duyên', '1993-01-31', N'Nữ', N'Bình Thuận', '0968190123', 'duyenbui@gmail.com', N'Nhân viên marketing', '2024-01-20', 9000000),
(N'Vương Minh Phát', '1987-12-12', N'Nam', N'Cà Mau', '0979201234', 'phatuong@gmail.com', N'Chuyên viên tài chính', '2023-02-01', 11600000),
(N'Lê Minh Quân', '1990-08-22', N'Nam', N'Bình Dương', '0903001001', 'quanle@gmail.com', N'Kỹ sư thiết kế', '2023-06-01', 10800000),
(N'Trần Thị Hương', '1992-04-17', N'Nữ', N'Bình Phước', '0913001002', 'huongtran@gmail.com', N'Chuyên viên pháp lý', '2022-03-12', 9900000),
(N'Nguyễn Văn Khoa', '1989-02-09', N'Nam', N'Cần Thơ', '0923001003', 'khoaguyen@gmail.com', N'Nhân viên nghiên cứu', '2021-11-09', 9500000),
(N'Phan Thị Lệ', '1996-12-28', N'Nữ', N'Sóc Trăng', '0933001004', 'lehan@gmail.com', N'Nhân viên hậu cần', '2024-02-22', 8800000),
(N'Đỗ Văn Tâm', '1993-05-05', N'Nam', N'Kon Tum', '0943001005', 'tamo@gmail.com', N'Kỹ thuật viên phần mềm', '2022-07-18', 10200000),
(N'Võ Thị Thu', '1995-10-21', N'Nữ', N'Nghệ An', '0953001006', 'thu.vo@gmail.com', N'Nhân viên hành chính', '2023-05-30', 8700000),
(N'Huỳnh Văn Sơn', '1991-07-14', N'Nam', N'Bạc Liêu', '0963001007', 'son.huynh@gmail.com', N'Trưởng phòng kỹ thuật', '2021-01-25', 12500000),
(N'Lý Thị Hồng', '1990-09-30', N'Nữ', N'Lâm Đồng', '0973001008', 'hong.ly@gmail.com', N'Nhân viên kiểm toán', '2022-08-10', 9400000),
(N'Bùi Văn Đức', '1987-11-11', N'Nam', N'Tiền Giang', '0983001009', 'duc.bui@gmail.com', N'Quản lý sản xuất', '2020-12-05', 11200000),
(N'Bùi Văn huy', '1997-11-11', N'Nam', N'an Giang', '0983771009', 'ducnii@gmail.com', N'Bán Hàng', '2023-12-05', 112000),
(N'Nguyễn Thị Hằng', '1994-03-15', N'Nữ', N'Quảng Bình', '0993001010', 'hang.nguyen@gmail.com', N'Chuyên viên tuyển dụng', '2023-06-10', 9300000),
(N'Phạm Văn Lâm', '1988-01-01', N'Nam', N'Hậu Giang', '0904001011', 'lam.pham@gmail.com', N'Kỹ thuật điện', '2021-04-04', 10100000),
(N'Trương Thị Bích', '1992-02-02', N'Nữ', N'Tây Ninh', '0914001012', 'bich.truong@gmail.com', N'Chuyên viên đào tạo', '2022-02-14', 9700000),
(N'Cao Văn Phước', '1993-12-12', N'Nam', N'Bình Thuận', '0924001013', 'phuoc.cao@gmail.com', N'Nhân viên bảo trì', '2023-10-01', 8800000),
(N'Lê Thị Thắm', '1996-06-06', N'Nữ', N'Bến Tre', '0934001014', 'tham.le@gmail.com', N'Nhân viên thư viện', '2023-09-15', 8500000),
(N'Thân Văn Kiệt', '1989-03-23', N'Nam', N'Trà Vinh', '0944001015', 'kiet.than@gmail.com', N'Giám sát sản xuất', '2022-11-01', 10900000),
(N'Nguyễn Thị Diễm', '1995-01-18', N'Nữ', N'Cà Mau', '0954001016', 'diem.nguyen@gmail.com', N'Nhân viên kế hoạch', '2024-03-20', 9000000),
(N'Vũ Văn Thành', '1990-10-10', N'Nam', N'Hà Nội', '0964001017', 'thanh.vu@gmail.com', N'Trưởng nhóm dự án', '2021-08-08', 11500000),
(N'Tô Thị Liên', '1993-07-19', N'Nữ', N'Nam Định', '0974001018', 'lien.to@gmail.com', N'Nhân viên báo cáo', '2022-06-05', 8700000),
(N'Hồ Văn Nghĩa', '1991-11-27', N'Nam', N'Khánh Hòa', '0984001019', 'nghia.ho@gmail.com', N'Chuyên viên nghiên cứu', '2021-12-15', 9900000),
(N'Trần Thị Cúc', '1994-08-08', N'Nữ', N'An Giang', '0994001020', 'cuc.tran@gmail.com', N'Kế toán thuế', '2023-02-17', 9400000),
(N'Lê Văn Hòa', '1988-12-05', N'Nam', N'Sơn La', '0905001021', 'hoa.le@gmail.com', N'Nhân viên logistics', '2022-01-25', 9600000),
(N'Đinh Thị Dung', '1995-09-15', N'Nữ', N'Hưng Yên', '0915001022', 'dung.dinh@gmail.com', N'Nhân viên tư vấn', '2023-12-12', 8800000),
(N'Phan Văn Sáng', '1987-06-11', N'Nam', N'Hải Dương', '0925001023', 'sang.phan@gmail.com', N'Chuyên viên CNTT', '2021-05-18', 11000000),
(N'Vũ Thị Minh', '1992-03-03', N'Nữ', N'Tuyên Quang', '0935001024', 'minh.vu@gmail.com', N'Nhân viên pháp chế', '2023-01-01', 9200000),
(N'Trịnh Văn Lộc', '1989-05-26', N'Nam', N'Phú Yên', '0945001025', 'loc.trinh@gmail.com', N'Trưởng phòng vận hành', '2020-10-10', 13000000),
(N'Hoàng Thị Hà', '1991-07-01', N'Nữ', N'Hải Phòng', '0955001026', 'ha.hoang@gmail.com', N'Nhân viên chăm sóc khách hàng', '2022-04-04', 8900000),
(N'Tống Văn Quang', '1993-04-14', N'Nam', N'Bắc Ninh', '0965001027', 'quang.tong@gmail.com', N'Quản lý dữ liệu', '2023-09-09', 9900000),
(N'Ngô Thị Kiều', '1996-01-11', N'Nữ', N'Yên Bái', '0975001028', 'kieu.ngo@gmail.com', N'Chuyên viên văn hóa doanh nghiệp', '2022-03-30', 9200000),
(N'Tạ Văn Duy', '1990-02-28', N'Nam', N'Hòa Bình', '0985001029', 'duy.ta@gmail.com', N'Nhân viên kỹ thuật', '2021-06-06', 9700000),
(N'Mai Thị Tươi', '1995-05-05', N'Nữ', N'Lai Châu', '0995001030', 'tuoi.mai@gmail.com', N'Chuyên viên sự kiện', '2023-07-07', 8800000),
(N'Bùi Văn Hưng', '1988-06-22', N'Nam', N'Bình Dương', '0906001031', 'hung.bui@gmail.com', N'Kỹ sư cơ khí', '2021-09-09', 10200000),
(N'Nguyễn Thị Nga', '1993-03-10', N'Nữ', N'Quảng Ngãi', '0916001032', 'nga.nguyen@gmail.com', N'Nhân viên phân tích', '2022-08-12', 9500000),
(N'Đoàn Văn Phú', '1987-12-25', N'Nam', N'Hà Tĩnh', '0926001033', 'phu.doan@gmail.com', N'Kỹ thuật viên bảo trì', '2020-11-17', 9200000),
(N'Lê Thị Trang', '1994-04-01', N'Nữ', N'Quảng Trị', '0936001034', 'trang.le@gmail.com', N'Chuyên viên chăm sóc khách hàng', '2023-03-21', 8900000),
(N'Phạm Văn Bảo', '1990-08-30', N'Nam', N'Ninh Bình', '0946001035', 'bao.pham@gmail.com', N'Nhân viên kiểm định', '2021-07-01', 9400000),
(N'Trịnh Thị Quỳnh', '1992-10-18', N'Nữ', N'Long An', '0956001036', 'quynhtrinh@gmail.com', N'Chuyên viên nhân sự', '2023-01-20', 9100000),
(N'Tống Văn Tiến', '1989-01-15', N'Nam', N'Lào Cai', '0966001037', 'tien.tong@gmail.com', N'Nhân viên kho', '2022-05-05', 8700000),
(N'Hoàng Thị Mai', '1996-12-03', N'Nữ', N'Bắc Kạn', '0976001038', 'mai.hoang@gmail.com', N'Chuyên viên tiếp thị', '2023-08-16', 9000000),
(N'Nguyễn Văn Duy', '1991-09-27', N'Nam', N'Hà Nội', '0986001039', 'duy.nguyen@gmail.com', N'Chuyên viên tài chính', '2020-10-30', 9700000),
(N'Cao Văn Lực', '1990-01-19', N'Nam', N'Bắc Ninh', '0949001065', 'luc.cao@gmail.com', N'Nhân viên nghiên cứu thị trường', '2022-03-03', 9400000),
(N'Trương Thị Huyền', '1995-04-04', N'Nữ', N'Hà Nam', '0959001066', 'huyen.truong@gmail.com', N'Chuyên viên bảo hiểm', '2023-03-03', 9100000),
(N'Đỗ Văn Lợi', '1989-06-30', N'Nam', N'Hòa Bình', '0969001067', 'loi.do@gmail.com', N'Nhân viên vận hành máy', '2021-07-07', 9300000),
(N'Vũ Thị Oanh', '1994-09-09', N'Nữ', N'Ninh Thuận', '0979001068', 'oanh.vu@gmail.com', N'Nhân viên phân tích kinh doanh', '2023-05-15', 9500000),
(N'Đặng Thị Loan', '1994-02-02', N'Nữ', N'Vĩnh Phúc', '0924123421', 'loan.dang@gmail.com', N'Nhân viên phân tích dữ liệu', '2024-05-01', 10100000);
go
-- Bảng KhachHang
insert into KhachHang (HoTen, SDT, DiaChi, Email, DiemTichLuy) VALUES
(N'Lê Thị M', '093123456', N'30 Đường Bà Triệu, Hà Nội', 'mle@email.com', 150),
(N'Phan Văn N', '0988765432', N'60 Phố Tràng Thi, Hà Nội', 'n.phan@email.com', 200),
(N'Hoàng Thị O', '0911223344', N'90 Đường Hai Bà Trưng, Hà Nội', 'o.hoang@email.com', 100),
(N'Trịnh Văn P', '0977889900', N'120 Đường Nguyễn Du, Hà Nội', 'p.trinh@email.com', 250),
(N'Vũ Thị Q', '0933445566', N'150 Đường Lý Thường Kiệt, Hà Nội', 'q.vu@email.cm', 180),
(N'Ngô Văn R', '0966554433', N'180 Đường Trần Hưng Đạo, Hà Nội', 'r.ngo@email.com', 220),
(N'Bùi Thị S', '0944667788', N'210 Đường Quang Trung, Hà Nội', 's.bui@email.com', 160),
(N'Đào Văn T', '0922778899', N'240 Đường Tây Hồ, Hà Nội', 't.dao@email.com', 190),
(N'Lâm Thị U', '0909998877', N'270 Đường Âu Cơ, Hà Nội', 'u.lam@email.com', 230),
(N'Lâm manh tu', '0339998877', N'270 thanh xuân, Hà Nội', 'tub@email.com', 170),
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
(N'Đoàn Thị Cúc', '097256797', N'11 Hoàng Hoa Thám, Kiên Giang', 'cuc.doan@email.com', 200),
(N'Bạch Văn Ngọc', '098368998', N'35 Trần Bình, Hòa Bình', 'ngoc.bach@email.com', 165),
(N'Vi Thị Lài', '099478999', N'47 Nguyễn Văn Cừ, Cao Bằng', 'lai.vi@email.com', 180),
(N'Chu Văn Long', '090590100', N'26 Đinh Tiên Hoàng, Điện Biên', 'long.chu@email.com', 190),
(N'Hà Văn V', '098111233', N'300 Đường Láng Hạ, Hà Nội', 'v.ha@email.com', 170);
go
-- Bảng NhaCungCap
insert into NhaCungCap (TenNCC, DiaChi, SDT, Email) VALUES

(N'Công ty ABC', N'Khu công nghiệp X, Hà Nội', '024123467', 'info@abc.com'),
(N'Nhà cung cấp XYZ', N'Khu công nghiệp Y, Hà Nội', '0249876543', 'sales@xyz.vn'),
(N'Doanh nghiệp 123', N'Thành phố Hồ Chí Minh', '0281122334', 'contact@123.net'),
(N'Đơn vị Thương Mại 456', N'Đà Nẵng', '02365567', 'support@456.org'),
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
(N'Nhà cung cấp Dụng cụ thể thao Nike', N'Hà Nội', '0241234567', 'info@nike.vn'),
(N'Công ty Máy lạnh Daikin', N'Bắc Ninh', '0222333445', 'service@daikin.vn'),
(N'Nhà phân phối Sản phẩm siêu thị Big C', N'TP.HCM', '0289888777', 'sales@bigc.vn'),
(N'Công ty Thiết bị điện LG', N'Hà Nội', '0242333344', 'support@lg.com.vn'),
(N'Nhà cung cấp Đồ gia dụng Cuckoo', N'Bắc Giang', '0222334567', 'info@cuckoo.vn'),
(N'Công ty Vận chuyển Grab', N'TP.HCM', '0286677889', 'support@grab.vn'),
(N'Nhà phân phối Phụ kiện điện thoại Anker', N'Hà Nội', '0242333345', 'sales@anker.vn'),
(N'Công ty Thực phẩm quốc tế Masan', N'TP.HCM', '0282222334', 'support@masan.vn'),
(N'Hợp tác xã E', N'Hà Nam', '0226554433', 'cooperativeE@hoptac.com');

go
-- Bảng LoaiSanPham
insert into LoaiSanPham (TenLoaiSP, MoTa) VALUES
(N'Điện tử', N'Các sản phẩm điện tử gia dụng và cá nhân'),
(N'Gia dụng', N'Đồ dùng trong nhà'),
(N'Thực phẩm', N'Các loại thực phẩm và đồ uống'),
(N'Thời trang', N'Quần áo, giày dép và phụ kiện'),
(N'Sách', N'Các loại sách và tạp chí'),
(N'Đồ chơi', N'Đồ chơi cho trẻ em'),
(N'Mỹ phẩm', N'Sản phẩm chăm sóc sắc đẹp'),
(N'Văn phòng phẩm', N'Đồ dùng văn phòng'),
(N'Dụng cụ thể thao', N'Các sản phẩm phục vụ thể dục thể thao'),
(N'Đồ dùng cá nhân', N'Các vật dụng cá nhân hàng ngày'),
(N'Đồ nội thất', N'Các sản phẩm nội thất cho nhà ở và văn phòng'),
(N'Trang sức', N'Nhẫn, vòng cổ, bông tai và phụ kiện trang sức'),
(N'Đồ dùng nhà bếp', N'Dụng cụ và thiết bị phục vụ nấu ăn'),
(N'Thực phẩm hữu cơ', N'Các loại thực phẩm được sản xuất theo tiêu chuẩn hữu cơ'),
(N'Thời trang trẻ em', N'Quần áo và phụ kiện dành cho trẻ em'),
(N'Đồ chơi giáo dục', N'Đồ chơi hỗ trợ học tập và phát triển trí tuệ'),
(N'Sản phẩm chăm sóc tóc', N'Sản phẩm chăm sóc và tạo kiểu tóc'),
(N'Thiết bị văn phòng', N'Máy in, máy scan và thiết bị văn phòng khác'),
(N'Phụ kiện thể thao', N'Băng bảo vệ, túi thể thao và phụ kiện thể thao'),
(N'Sản phẩm chăm sóc sức khỏe', N'Thực phẩm bổ sung và thiết bị y tế cá nhân'),
(N'Đồ trang trí nhà cửa', N'Các sản phẩm trang trí nội thất và ngoại thất'),
(N'Thức ăn thú cưng', N'Thức ăn cho chó, mèo và các vật nuôi khác'),
(N'Phụ kiện ô tô', N'Phụ kiện và đồ dùng cho xe hơi'),
(N'Đồ uống nhập khẩu', N'Các loại đồ uống nhập khẩu từ nước ngoài'),
(N'Thời trang nam', N'Quần áo và phụ kiện dành riêng cho nam giới'),
(N'Đồ chơi ngoài trời', N'Đồ chơi sử dụng ngoài trời cho trẻ em'),
(N'Sản phẩm dưỡng da', N'Kem dưỡng, serum và sản phẩm chăm sóc da'),
(N'Vở và sách giáo khoa', N'Vở học sinh và sách giáo khoa các cấp'),
(N'Đồ dùng leo núi', N'Thiết bị và phụ kiện cho môn leo núi'),
(N'Sản phẩm vệ sinh cá nhân', N'Xà phòng, dầu gội và sản phẩm vệ sinh'),
(N'Đồ dùng phòng ngủ', N'Chăn, ga, gối, nệm và phụ kiện phòng ngủ'),
(N'Phụ kiện thú cưng', N'Vòng cổ, chuồng và đồ chơi cho thú cưng'),
(N'Phụ kiện xe máy', N'Mũ bảo hiểm, găng tay và phụ kiện xe máy'),
(N'Thực phẩm đông lạnh', N'Thực phẩm bảo quản đông lạnh'),
(N'Thời trang nữ', N'Quần áo và phụ kiện dành riêng cho nữ giới'),
(N'Đồ chơi công nghệ', N'Đồ chơi sử dụng công nghệ cao như robot'),
(N'Sản phẩm tẩy trang', N'Nước tẩy trang và sản phẩm làm sạch da'),
(N'Bút và mực cao cấp', N'Bút mực, bút bi cao cấp cho văn phòng'),
(N'Dụng cụ yoga', N'Thảm yoga, dây kháng lực và phụ kiện yoga'),
(N'Thiết bị đo sức khỏe', N'Máy đo huyết áp, nhiệt kế và thiết bị y tế'),
(N'Đồ dùng phòng khách', N'Bàn ghế, kệ tivi và đồ trang trí phòng khách'),
(N'Đồ dùng chăm sóc thú cưng', N'Sản phẩm vệ sinh và chăm sóc thú cưng'),
(N'Thiết bị an ninh', N'Camera giám sát, khóa thông minh'),
(N'Thực phẩm chế biến sẵn', N'Thực phẩm đóng hộp và chế biến sẵn'),
(N'Phụ kiện thời trang', N'Túi xách, thắt lưng và khăn choàng'),
(N'Đồ chơi lắp ráp', N'Đồ chơi lắp ráp như LEgo và mô hình'),
(N'Sản phẩm chăm sóc môi', N'Son dưỡng và sản phẩm chăm sóc môi'),
(N'Thiết bị lưu trữ', N'USB, ổ cứng ngoài và thẻ nhớ'),
(N'Đồ dùng bơi lội', N'Áo bơi, kính bơi và phụ kiện bơi lội'),
(N'Sản phẩm chăm sóc răng miệng', N'Kem đánh răng, bàn chải và nước súc miệng'),
(N'Đồ dùng phòng tắm', N'Khăn tắm, kệ đựng đồ và phụ kiện phòng tắm'),
(N'Đồ dùng dã ngoại', N'Lều, túi ngủ và dụng cụ cắm trại'),
(N'Thiết bị chiếu sáng', N'Đèn LED, đèn bàn và đèn trang trí'),
(N'Thực phẩm dinh dưỡng', N'Sữa bột, thực phẩm bổ sung dinh dưỡng'),
(N'Đồng hồ thời trang', N'Đồng hồ đeo tay thời trang'),
(N'Đồ chơi sáng tạo', N'Đồ chơi khuyến khích sáng tạo và tư duy'),
(N'Sản phẩm chống nắng', N'Kem chống nắng và sản phẩm bảo vệ da'),
(N'Giấy và sản phẩm giấy', N'Giấy in, giấy ghi chú và sản phẩm giấy'),
(N'Dụng cụ thể dục tại nhà', N'Máy chạy bộ, tạ và thiết bị tập gym'),
(N'Thiết bị chăm sóc cá nhân', N'Máy cạo râu, máy sấy tóc và thiết bị cá nhân'),
(N'Đồ dùng sân vườn', N'Cây cảnh, dụng cụ làm vườn và đồ trang trí'),
(N'Phụ kiện công nghệ', N'Tai nghe, sạc dự phòng và vỏ điện thoại'),
(N'Thiết bị âm thanh', N'Loa Bluetooth, tai nghe và hệ thống âm thanh'),
(N'Thực phẩm nhập khẩu', N'Thực phẩm nhập khẩu từ các nước'),
(N'Ba lô và túi du lịch', N'Ba lô, vali và túi du lịch'),
(N'Đồ chơi vận động', N'Xe trượt, bóng và đồ chơi vận động'),
(N'Sản phẩm làm sạch da', N'Sữa rửa mặt và sản phẩm làm sạch da'),
(N'Thiết bị mạng', N'Router, modem và thiết bị kết nối mạng'),
(N'Đồ dùng trượt tuyết', N'Ván trượt tuyết và phụ kiện trượt tuyết'),
(N'Sản phẩm chăm sóc mắt', N'Kính áp tròng và sản phẩm chăm sóc mắt'),
(N'Đồ dùng nhà ăn', N'Bát, đĩa, ly và đồ dùng nhà ăn'),
(N'Đồ dùng cắm trại', N'Bếp dã ngoại, ghế gấp và đồ dùng cắm trại'),
(N'Thiết bị giám sát', N'Camera an ninh và thiết bị giám sát'),
(N'Thực phẩm chức năng', N'Vitamin và thực phẩm bổ sung sức khỏe'),
(N'Mũ và nón thời trang', N'Mũ lưỡi trai, mũ len và nón thời trang'),
(N'Đồ chơi mô hình', N'Mô hình xe, máy bay và tàu hỏa'),
(N'Sản phẩm chăm sóc cơ thể', N'Sữa tắm và sản phẩm chăm sóc cơ thể'),
(N'Máy tính và phụ kiện', N'Laptop, bàn phím và chuột máy tính'),
(N'Dụng cụ câu cá', N'Cần câu, lưỡi câu và phụ kiện câu cá'),
(N'Sản phẩm chăm sóc trẻ em', N'Sữa tắm, kem dưỡng dành cho trẻ em'),
(N'Đồ dùng vệ sinh nhà cửa', N'Chổi, cây lau nhà và sản phẩm vệ sinh'),
(N'Đồ dùng lễ hội', N'Đồ trang trí Giáng sinh, Tết và lễ hội'),
(N'Thiết bị điện gia dụng', N'Quạt điện, máy sưởi và thiết bị gia dụng'),
(N'Thực phẩm khô', N'Hạt, trái cây sấy và thực phẩm khô'),
(N'Phụ kiện tóc', N'Kẹp tóc, dây buộc tóc và phụ kiện tóc'),
(N'Đồ chơi tương tác', N'Đồ chơi có tính năng tương tác với trẻ'),
(N'Sản phẩm làm đẹp cao cấp', N'Mỹ phẩm và sản phẩm làm đẹp cao cấp'),
(N'Thiết bị trình chiếu', N'Máy chiếu và phụ kiện trình chiếu'),
(N'Đồ dùng lướt sóng', N'Ván lướt sóng và phụ kiện lướt sóng'),
(N'Sản phẩm chăm sóc móng', N'Sơn móng tay và dụng cụ chăm sóc móng'),
(N'Đồ dùng học tập', N'Cặp sách, đồ dùng học sinh và học cụ'),
(N'Đồ dùng tiệc tùng', N'Bong bóng, nến và đồ trang trí tiệc'),
(N'Thiết bị thông minh', N'Đồng hồ thông minh và thiết bị IoT'),
(N'Thực phẩm chay', N'Thực phẩm dành cho người ăn chay'),
(N'Túi xách thời trang', N'Túi xách thời trang cho nam và nữ'),
(N'Đồ chơi khoa học', N'Bộ thí nghiệm và đồ chơi khoa học'),
(N'Sản phẩm chống lão hóa', N'Kem chống lão hóa và sản phẩm dưỡng da'),
(N'Thiết bị lưu điện', N'Bộ lưu điện và thiết bị dự phòng điện'),
(N'Dụng cụ golf', N'Gậy golf, bóng golf và phụ kiện golf'),
(N'Sản phẩm chăm sóc da nhạy cảm', N'Sản phẩm dành cho da nhạy cảm');
go
-- Bảng SanPham
insert into SanPham (MasP,TenSP, MaLoaiSP, MaNCC, DonViTinh, GiaNhap, GiaBan, SoLuongTonKho, HanSuDung, MoTa) VALUES
(1,N'Tivi Samsung Smart 4K 55 inch', 1, 1, N'Chiếc', 8000000, 12000000, 50, NULL, N'Tivi thông minh màn hình lớn'),
(2,N'Nồi cơm điện Sharp 1.8L', 2, 2, N'Chiếc', 300000, 500000, 100, NULL, N'Nồi cơm điện dung tích lớn'),
(3,N'Mì gói Hảo Hảo', 3, 3, N'Thùng', 60000, 90000, 200, '2025-07-30', N'Mì ăn liền phổ biến'),
(4,N'Áo sơ mi nam trắng', 4, 4, N'Chiếc', 150000, 250000, 80, NULL, N'Áo sơ mi công sở'),
(5,N'Sách Đắc Nhân Tâm', 5, 5, N'Cuốn', 50000, 80000, 150, NULL, N'Sách self-help nổi tiếng'),
(6,N'Ô tô đồ chơi điều khiển', 6, 6, N'Chiếc', 200000, 350000, 70, NULL, N'Ô tô điều khiển từ xa'),
(7,N'Kem chống nắng Sunplay SPF50+', 7, 7, N'Chai', 80000, 120000, 120, '2026-03-15', N'Kem chống nắng hiệu quả'),
(8, N'Bút bi Thiên Long', 8, 8, N'Hộp', 25000, 40000, 300, NULL, N'Bút bi chất lượng tốt'),
(9, N'Giày đá bóng Adidas', 9, 9, N'Đôi', 500000, 800000, 60, NULL, N'Giày đá bóng chuyên nghiệp'),
(10 ,N'Bàn chải đánh răng Oral-B', 10, 10, N'Cây', 20000, 35000, 250, NULL, N'Bàn chải đánh răng mềm'),
(11,N'Laptop Dell XPS 13', 11, 11, N'Chiếc', 15000000, 20000000, 30, NULL, N'Laptop cao cấp, hiệu năng mạnh'),
(12,N'Máy giặt LG Inverter 9kg', 12, 12, N'Chiếc', 5000000, 7500000, 40, NULL, N'Máy giặt tiết kiệm điện'),
(13,N'Nước ngọt Coca-Cola 1.5L', 13, 13, N'Thùng', 120000, 180000, 150, '2025-12-31', N'Nước ngọt giải khát phổ biến'),
(14,N'Quần jeans nam Levi’s', 14, 14, N'Chiếc', 400000, 600000, 90, NULL, N'Quần jeans thời trang'),
(15,N'Sách Nhà Giả Kim', 15, 15, N'Cuốn', 60000, 100000, 120, NULL, N'Tiểu thuyết nổi tiếng thế giới'),
(16,N'Xe đẩy đồ chơi trẻ em', 16, 16, N'Chiếc', 150000, 250000, 80, NULL, N'Xe đẩy đồ chơi an toàn'),
(17,N'Sữa rửa mặt Cetaphil 500ml', 17, 17, N'Chai', 200000, 300000, 100, '2026-06-30', N'Sữa rửa mặt dịu nhẹ'),
(18,N'Vở học sinh 200 trang', 188, 18, N'Cuốn', 15000, 25000, 500, NULL, N'Vở học sinh chất lượng cao'),
(19,N'Găng tay bóng chày Wilson', 19, 19, N'Đôi', 300000, 450000, 50, NULL, N'Găng tay bóng chày chuyên dụng'),
(20,N'Kem đánh răng Colgate 180g', 20, 20, N'Tuýp', 30000, 50000, 200, '2026-01-15', N'Kem đánh răng bảo vệ răng'),
(21,N'Máy xay sinh tố Philips', 21, 21, N'Chiếc', 600000, 900000, 60, NULL, N'Máy xay đa năng, bền bỉ'),
(22,N'Điện thoại iPhone 14 Pro', 21, 22, N'Chiếc', 20000000, 27000000, 25, NULL, N'Điện thoại cao cấp, camera sắc nét'),
(23,N'Bánh quy Cosy 500g', 23, 23, N'Hộp', 50000, 80000, 180, '2025-10-20', N'Bánh quy thơm ngon'),
(24,N'Áo khoác nữ Uniqlo', 24, 24, N'Chiếc', 300000, 500000, 70, NULL, N'Áo khoác thời trang, ấm áp'),
(25,N'Sách Lược Sử Thời Gian', 25, 25, N'Cuốn', 80000, 120000, 100, NULL, N'Sách khoa học hấp dẫn'),
(26,N'Búp bê Barbie thời trang', 26, 26, N'Chiếc', 100000, 180000, 90, NULL, N'Búp bê thời trang cho trẻ em'),
(27,N'Nước hoa Dior Sauvage 100ml', 27, 27, N'Chai', 1500000, 2000000, 40, NULL, N'Nước hoa nam cao cấp'),
(28,N'Bút chì Faber-Castell', 28, 28, N'Hộp', 20000, 35000, 400, NULL, N'Bút chì chất lượng cao'),
(29,N'Túi thể thao Nike', 29, 29, N'Chiếc', 250000, 400000, 60, NULL, N'Túi thể thao bền, tiện dụng'),
(30,N'Sữa tắm Dove 1L', 30, 30, N'Chai', 100000, 150000, 120, '2026-04-30', N'Sữa tắm dưỡng ẩm da'),
(31,N'Tủ lạnh Samsung 300L', 31, 31, N'Chiếc', 7000000, 10000000, 35, NULL, N'Tủ lạnh tiết kiệm điện'),
(32,N'Bánh mì sandwich Kinh Đô', 32, 32, N'Gói', 25000, 40000, 200, '2025-09-15', N'Bánh mì mềm thơm'),
(33,N'Váy maxi nữ thời trang', 33, 33, N'Chiếc', 200000, 350000, 80, NULL, N'Váy maxi nhẹ nhàng, thanh lịch'),
(34,N'Sách Hài Hước Một Chút', 34, 34, N'Cuốn', 40000, 70000, 130, NULL, N'Sách hài hước giải trí'),
(35,N'Đồ chơi xếp hình LEgo 500 mảnh', 35, 35, N'Hộp', 300000, 450000, 70, NULL, N'Xếp hình sáng tạo cho trẻ'),
(36,N'Son môi L’Oreal Paris', 36, 36, N'Thỏi', 120000, 180000, 100, '2026-02-28', N'Son môi màu sắc thời thượng'),
(37,N'Tẩy bút chì Pelikan', 37, 37, N'Cục', 10000, 20000, 600, NULL, N'Tẩy sạch, không để lại vết'),
(38,N'Nước tẩy trang Bioderma 500ml', 38, 38, N'Chai', 250000, 350000, 80, '2026-05-31', N'Nước tẩy trang dịu nhẹ'),
(39,N'Máy pha cà phê De’Longhi', 39, 39, N'Chiếc', 2000000, 3000000, 20, NULL, N'Máy pha cà phê chuyên nghiệp'),
(40,N'Sữa tươi Vinamilk 1L', 40, 40, N'Hộp', 20000, 35000, 250, '2025-11-30', N'Sữa tươi nguyên chất'),
(41,N'Áo thun nam Zara', 41, 41, N'Chiếc', 100000, 180000, 100, NULL, N'Áo thun nam thời trang'),
(42,N'Sách Tư Duy Nhanh Và Chậm', 42, 42, N'Cuốn', 90000, 140000, 110, NULL, N'Sách tâm lý học nổi tiếng'),
(43,N'Bộ đồ chơi nấu ăn trẻ em', 43, 43, N'Bộ', 150000, 250000, 85, NULL, N'Đồ chơi nấu ăn an toàn'),
(44,N'Mặt nạ dưỡng da Innisfree', 44, 44, N'Miếng', 15000, 25000, 300, '2026-03-31', N'Mặt nạ dưỡng da tự nhiên'),
(45,N'Bút mực Parker', 45, 45, N'Cây', 500000, 800000, 50, NULL, N'Bút mực cao cấp'),
(46,N'Giày chạy bộ asics', 46, 46, N'Đôi', 600000, 900000, 60, NULL, N'Giày chạy bộ êm ái'),
(47,N'Xà phòng rửa tay Lifebuoy 500ml', 47, 47, N'Chai', 40000, 60000, 150, '2026-07-31', N'Xà phòng diệt khuẩn'),
(48,N'Máy hút bụi Dyson', 48, 48, N'Chiếc', 4000000, 6000000, 25, NULL, N'Máy hút bụi không dây mạnh mẽ'),
(49,N'Kẹo dẻo Haribo 200g', 49, 49, N'Gói', 30000, 50000, 200, '2025-12-15', N'Kẹo dẻo trái cây ngon'),
(50,N'Áo len nữ H&M', 50, 50, N'Chiếc', 200000, 350000, 80, NULL, N'Áo len ấm áp, thời trang'),
(51,N'Sách Bố Già', 51, 51, N'Cuốn', 70000, 110000, 120, NULL, N'Tiểu thuyết kinh điển'),
(52,N'Đồ chơi robot biến hình', 52, 52, N'Chiếc', 250000, 400000, 70, NULL, N'Robot biến hình thú vị'),
(53,N'Toner Thayers 355ml', 53, 53, N'Chai', 150000, 220000, 90, '2026-04-30', N'Toner dưỡng da không cồn'),
(54,N'Bộ bút màu 24 màu Crayola', 54, 54, N'Hộp', 80000, 120000, 200, NULL, N'Bút màu an toàn cho trẻ'),
(55,N'Bóng đá Mitre', 55, 55, N'Quả', 150000, 250000, 100, NULL, N'Bóng đá chất lượng cao'),
(56,N'Sữa dưỡng thể Nivea 400ml', 56, 56, N'Chai', 100000, 150000, 120, '2026-06-30', N'Sữa dưỡng thể dưỡng ẩm'),
(57,N'Loa Bluetooth JBL Flip 5', 57, 57, N'Chiếc', 1500000, 2000000, 40, NULL, N'Loa Bluetooth âm thanh chất lượng'),
(58,N'Bánh snack Lay’s 100g', 58, 58, N'Gói', 15000, 25000, 300, '2025-10-31', N'Bánh snack giòn tan'),
(59,N'Quần short nam Adidas', 59, 59, N'Chiếc', 200000, 350000, 90, NULL, N'Quần short thể thao thoải mái'),
(60,N'Sách Sapiens', 60, 60, N'Cuốn', 100000, 150000, 110, NULL, N'Sách lịch sử nhân loại'),
(61,N'Bộ đồ chơi bác sĩ trẻ em', 61, 61, N'Bộ', 200000, 350000, 80, NULL, N'Đồ chơi bác sĩ an toàn'),
(62,N'Serum The Ordinary Niacinamide', 62, 62, N'Chai', 200000, 300000, 100, '2026-05-31', N'Serum dưỡng da hiệu quả'),
(63,N'Bút highlighter Stabilo', 63, 63, N'Cây', 20000, 35000, 250, NULL, N'Bút highlighter màu sắc tươi sáng'),
(64,N'Mũ bóng chày Nike', 64, 64, N'Chiếc', 150000, 250000, 80, NULL, N'Mũ bóng chày thời trang'),
(65,N'Nước súc miệng Listerine 500ml', 65, 65, N'Chai', 80000, 120000, 150, '2026-03-31', N'Nước súc miệng diệt khuẩn'),
(66,N'Máy lọc không khí Xiaomi', 66, 66, N'Chiếc', 2000000, 3000000, 30, NULL, N'Máy lọc không khí thông minh'),
(67,N'Trà xanh C2 500ml', 67, 67, N'Thùng', 90000, 140000, 200, '2025-11-15', N'Trà xanh giải khát'),
(68,N'Áo khoác gió Columbia', 68, 68, N'Chiếc', 500000, 800000, 60, NULL, N'Áo khoác gió chống thấm'),
(69,N'Sách 7 Thói Quen Hiệu Quả', 69, 69, N'Cuốn', 80000, 120000, 100, NULL, N'Sách phát triển bản thân'),
(70,N'Bộ đồ chơi siêu nhân', 70, 70, N'Bộ', 250000, 400000, 70, NULL, N'Đồ chơi siêu nhân hấp dẫn'),
(71,N'Kem dưỡng ẩm CeraVe 340g', 71, 71, N'Hũ', 250000, 350000, 80, '2026-07-31', N'Kem dưỡng ẩm cho da khô'),
(72,N'Bút gel Muji', 72, 72, N'Cây', 20000, 35000, 300, NULL, N'Bút gel mực mịn'),
(73,N'Gậy bóng chày Louisville', 73, 73, N'Cây', 400000, 600000, 50, NULL, N'Gậy bóng chày chất lượng'),
(74,N'Sữa rửa tay Method 300ml', 74, 74, N'Chai', 60000, 90000, 120, '2026-04-30', N'Sữa rửa tay tự nhiên'),
(75,N'Tai nghe Sony WH-1000XM5', 75, 75, N'Chiếc', 5000000, 7000000, 20, NULL, N'Tai nghe chống ồn cao cấp'),
(76,N'Bánh trung thu Kinh Đô', 76, 76, N'Hộp', 200000, 300000, 100, '2025-09-30', N'Bánh trung thu truyền thống'),
(77,N'Áo polo nam Lacoste', 77, 77, N'Chiếc', 300000, 500000, 80, NULL, N'Áo polo cao cấp'),
(78,N'Sách Harry Potter', 78, 78, N'Cuốn', 120000, 180000, 120, NULL, N'Tiểu thuyết giả tưởng nổi tiếng'),
(79,N'Đồ chơi máy bay điều khiển', 79, 79, N'Chiếc', 300000, 450000, 60, NULL, N'Máy bay điều khiển từ xa'),
(80,N'Sữa tắm Olay 650ml', 80, 80, N'Chai', 90000, 140000, 100, '2026-06-30', N'Sữa tắm dưỡng da mềm mại'),
(81,N'Máy ảnh Canon EOS M50', 81, 81, N'Chiếc', 8000000, 11000000, 15, NULL, N'Máy ảnh mirrorless chất lượng'),
(82,N'Nước tăng lực Red Bull 250ml', 82, 82, N'Thùng', 150000, 220000, 150, '2025-12-31', N'Nước tăng lực mạnh mẽ'),
(83,N'Quần tây nam Canifa', 83, 83, N'Chiếc', 250000, 400000, 90, NULL, N'Quần tây công sở lịch lãm'),
(84,N'Sách Thinking, Fast and Slow', 84, 84, N'Cuốn', 100000, 150000, 110, NULL, N'Sách tâm lý học sâu sắc'),
(85,N'Bộ đồ chơi xây dựng', 85, 85, N'Bộ', 200000, 350000, 80, NULL, N'Đồ chơi xây dựng sáng tạo'),
(86,N'Son dưỡng môi Burt’s Bees', 86, 86, N'Thỏi', 80000, 120000, 150, '2026-05-31', N'Son dưỡng môi tự nhiên'),
(87,N'Bút bi Pilot', 87, 87, N'Cây', 15000, 25000, 400, NULL, N'Bút bi mực đều'),
(88,N'Bóng rổ Spalding', 88, 88, N'Quả', 200000, 350000, 70, NULL, N'Bóng rổ chất lượng cao'),
(89,N'Nước rửa chén Seventh Generation', 89, 89, N'Chai', 70000, 100000, 120, '2026-04-30', N'Nước rửa chén thân thiện môi trường'),
(90,N'Máy in HP LaserJet', 90, 90, N'Chiếc', 3000000, 4500000, 20, NULL, N'Máy in laser hiệu quả'),
(91,N'Sữa chua Vinamilk 100g', 91, 91, N'Hộp', 5000, 10000, 500, '2025-11-30', N'Sữa chua bổ dưỡng'),
(92,N'Áo blazer nữ Mango', 92, 92, N'Chiếc', 400000, 600000, 60, NULL, N'Áo blazer thời trang công sở'),
(93,N'Sách The Alchemist', 93, 93, N'Cuốn', 60000, 100000, 130, NULL, N'Tiểu thuyết truyền cảm hứng'),
(94,N'Đồ chơi tàu hỏa trẻ em', 94, 94, N'Bộ', 250000, 400000, 70, NULL, N'Đồ chơi tàu hỏa thú vị'),
(95,N'Kem dưỡng da Neutrogena 50ml', 95, 95, N'Hũ', 200000, 300000, 90, '2026-06-30', N'Kem dưỡng da dịu nhẹ'),
(96,N'Bút chì màu Prismacolor', 96, 96, N'Hộp', 300000, 450000, 100, NULL, N'Bút chì màu chuyên nghiệp'),
(97,N'Vợt cầu lông Yonex', 97, 97, N'Cây', 500000, 800000, 50, NULL, N'Vợt cầu lông chất lượng'),
(98,N'Sữa tắm Palmolive 750ml', 98, 98, N'Chai', 80000, 120000, 120, '2026-05-31', N'Sữa tắm thơm mát'),
(99,N'Đồng hồ thông minh Apple Watch', 99, 99, N'Chiếc', 6000000, 9000000, 25, NULL, N'Đồng hồ thông minh cao cấp'),
(100,N'Bánh gạo Orion 200g', 100, 100, N'Gói', 20000, 35000, 200, '2025-11-15', N'Bánh gạo giòn ngon');

go
-- Bảng KhuyenMai
insert into KhuyenMai (TenKM, NgayBatDau, NgayKetThuc, PhanTramGiamGia, MoTa) VALUES
(N'Giảm giá cuối tuần', '2025-04-12', '2025-04-13', 15.00, N'Giảm 15% cho tất cả sản phẩm vào cuối tuần'),
(N'Khuyến mãi tháng 5', '2025-05-01', '2025-05-31', 10.00, N'Giảm 10% cho đơn hàng trên 500.000 VNĐ'),
(N'Mua 1 tặng 1', '2025-04-15', '2025-04-20', NULL, N'Mua một sản phẩm tặng một sản phẩm cùng loại'),
(N'Giảm đặc biệt cho thành viên', '2025-04-08', '2025-04-30', 20.00, N'Giảm 20% cho khách hàng có thẻ thành viên'),
(N'Ngày hội mua sắm', '2025-04-25', '2025-04-27', 25.00, N'Giảm giá sốc trong 3 ngày'),
(N'Chào hè rực rỡ', '2025-06-01', '2025-06-30', 12.00, N'Giảm 12% cho các sản phẩm mùa hè'),
(N'Black Friday sớm', '2025-11-01', '2025-11-30', 30.00, N'Giảm 30% cho một số mặt hàng'),
(N'Sinh nhật cửa hàng', '2025-07-15', '2025-07-20', 18.00, N'Giảm 18% nhân dịp sinh nhật cửa hàng'),
(N'Xả hàng cuối năm', '2025-12-20', '2025-12-31', 35.00, N'Giảm giá mạnh cuối năm'),
(N'Ưu đãi đặc biệt', '2025-04-10', '2025-04-15', 5.00, N'Giảm thêm 5% khi thanh toán online'),
(N'Giảm giá mùa đông', '2025-12-20', '2025-12-31', 35.00, N'Giảm 35% cho tất cả sản phẩm mùa đông'),
(N'Khuyến mãi Tết Nguyên Đán', '2026-01-25', '2026-02-05', 30.00, N'Giảm 30% cho tất cả sản phẩm dịp Tết'),
(N'Giảm giá cho đơn hàng online', '2025-09-15', '2025-09-25', 10.00, N'Giảm 10% cho đơn hàng đặt qua website'),
(N'Mua 1 tặng 1 sản phẩm thời trang', '2025-11-10', '2025-11-20', NULL, N'Mua 1 sản phẩm thời trang tặng 1 sản phẩm cùng loại'),
(N'Giảm giá cho sản phẩm trẻ em', '2025-06-01', '2025-06-10', 15.00, N'Giảm 15% cho tất cả sản phẩm dành cho trẻ em'),
(N'Khuyến mãi ngày quốc khánh', '2025-09-02', '2025-09-03', 20.00, N'Giảm 20% cho tất cả sản phẩm nhân dịp Quốc khánh'),
(N'Giảm giá cho khách hàng VIP', '2025-10-01', '2025-10-10', 25.00, N'Giảm 25% cho khách hàng đạt cấp VIP'),
(N'Giảm giá mùa hè', '2026-07-01', '2026-07-15', 15.00, N'Giảm 15% cho tất cả sản phẩm mùa hè'),
(N'Khuyến mãi Black Friday', '2025-11-28', '2025-11-30', 40.00, N'Giảm 40% cho tất cả sản phẩm trong dịp Black Friday'),
(N'Giảm giá cho sản phẩm nội thất', '2025-08-10', '2025-08-20', 20.00, N'Giảm 20% cho tất cả sản phẩm nội thất'),
(N'Giảm giá cho đơn hàng đầu tiên', '2026-01-01', '2026-01-15', 15.00, N'Giảm 15% cho đơn hàng đầu tiên của khách hàng mới'),
(N'Khuyến mãi ngày thiếu nhi', '2026-06-01', '2026-06-02', 25.00, N'Giảm 25% cho sản phẩm dành cho trẻ em nhân ngày 1/6'),
(N'Giảm giá cho sản phẩm văn phòng', '2025-09-20', '2025-09-30', 10.00, N'Giảm 10% cho tất cả sản phẩm văn phòng'),
(N'Giảm giá cho đơn hàng trên 500.000 VNĐ', '2025-11-01', '2025-11-10', 15.00, N'Giảm 15% cho đơn hàng từ 500.000 VNĐ trở lên'),
(N'Khuyến mãi ngày phụ nữ Việt Nam', '2025-10-20', '2025-10-21', 20.00, N'Giảm 20% cho tất cả sản phẩm dành cho phụ nữ'),
(N'Giảm giá cho sản phẩm đồ chơi', '2026-05-10', '2026-05-20', 15.00, N'Giảm 15% cho tất cả sản phẩm đồ chơi'),
(N'Giảm giá cho sản phẩm sách', '2025-12-01', '2025-12-10', 20.00, N'Giảm 20% cho tất cả sách và tài liệu học tập'),
(N'Khuyến mãi ngày nhà giáo', '2025-11-20', '2025-11-21', 15.00, N'Giảm 15% cho sản phẩm dành cho giáo viên và học sinh'),
(N'Giảm giá cho sản phẩm thực phẩm', '2026-03-01', '2026-03-15', 10.00, N'Giảm 10% cho tất cả sản phẩm thực phẩm'),
(N'Giảm giá cho khách hàng trung thành', '2026-02-01', '2026-02-10', 20.00, N'Giảm 20% cho khách hàng mua sắm trên 3 lần'),
(N'Khuyến mãi mùa xuân', '2026-03-01', '2026-03-15', 15.00, N'Giảm 15% cho tất cả sản phẩm mùa xuân'),
(N'Giảm giá cho sản phẩm xe đạp', '2025-07-10', '2025-07-20', 10.00, N'Giảm 10% cho tất cả xe đạp và phụ kiện'),
(N'Giảm giá cho sản phẩm chăm sóc cá nhân', '2026-04-01', '2026-04-15', 20.00, N'Giảm 20% cho sản phẩm chăm sóc cá nhân'),
(N'Khuyến mãi ngày môi trường', '2026-06-05', '2026-06-06', 15.00, N'Giảm 15% cho sản phẩm thân thiện với môi trường'),
(N'Giảm giá cho sản phẩm trang sức', '2025-12-15', '2025-12-25', 25.00, N'Giảm 25% cho tất cả sản phẩm trang sức'),
(N'Giảm giá cho đơn hàng giao nhanh', '2026-01-10', '2026-01-20', 10.00, N'Giảm 10% cho đơn hàng giao trong 24h'),
(N'Khuyến mãi ngày gia đình', '2026-06-28', '2026-06-29', 20.00, N'Giảm 20% cho sản phẩm dành cho gia đình'),
(N'Giảm giá cho sản phẩm giày dép', '2025-10-15', '2025-10-25', 15.00, N'Giảm 15% cho tất cả giày dép'),
(N'Giảm giá cho sản phẩm đồ gia dụng', '2026-02-20', '2026-02-28', 20.00, N'Giảm 20% cho tất cả đồ gia dụng'),
(N'Khuyến mãi ngày độc lập', '2026-09-02', '2026-09-03', 25.00, N'Giảm 25% cho tất cả sản phẩm nhân dịp Quốc khánh'),
(N'Giảm giá cho sản phẩm đồ uống', '2025-08-01', '2025-08-15', 10.00, N'Giảm 10% cho tất cả đồ uống đóng gói'),
(N'Giảm giá cho sản phẩm đồ điện', '2026-05-01', '2026-05-15', 15.00, N'Giảm 15% cho tất cả sản phẩm đồ điện'),
(N'Khuyến mãi ngày trung thu', '2025-09-15', '2025-09-16', 20.00, N'Giảm 20% cho sản phẩm bánh trung thu và lồng đèn'),
(N'Giảm giá cho sản phẩm đồ chơi giáo dục', '2026-07-01', '2026-07-15', 15.00, N'Giảm 15% cho đồ chơi giáo dục'),
(N'Giảm giá cho sản phẩm đồ dùng học tập', '2025-08-20', '2025-08-30', 10.00, N'Giảm 10% cho đồ dùng học tập'),
(N'Khuyến mãi ngày hội sách', '2026-04-21', '2026-04-23', 25.00, N'Giảm 25% cho tất cả sách trong ngày hội sách'),
(N'Giảm giá cho sản phẩm đồ bơi', '2026-06-15', '2026-06-30', 15.00, N'Giảm 15% cho tất cả đồ bơi và phụ kiện'),
(N'Giảm giá cho sản phẩm đồ trang trí', '2025-12-01', '2025-12-15', 20.00, N'Giảm 20% cho đồ trang trí Giáng sinh và năm mới'),
(N'Khuyến mãi ngày sức khỏe', '2026-04-07', '2026-04-08', 15.00, N'Giảm 15% cho sản phẩm chăm sóc sức khỏe'),
(N'Giảm giá cho sản phẩm đồ da', '2025-11-01', '2025-11-15', 20.00, N'Giảm 20% cho tất cả sản phẩm đồ da'),
(N'Giảm giá cho đơn hàng trên 2.000.000 VNĐ', '2026-03-10', '2026-03-20', 30.00, N'Giảm 30% cho đơn hàng từ 2.000.000 VNĐ trở lên'),
(N'Giảm giá mùa thu', '2025-09-01', '2025-09-15', 15.00, N'Giảm 15% cho các sản phẩm mùa thu'),
(N'Khuyến mãi ngày lễ lao động', '2025-05-01', '2025-05-02', 20.00, N'Giảm 20% cho tất cả sản phẩm nhân dịp 1/5'),
(N'Giảm giá cho sản phẩm công nghệ', '2025-10-01', '2025-10-10', 25.00, N'Giảm 25% cho các sản phẩm công nghệ'),
(N'Mua 2 tặng 1', '2025-06-10', '2025-06-15', NULL, N'Mua 2 sản phẩm tặng 1 sản phẩm bất kỳ'),
(N'Giảm giá cho sản phẩm thời trang nam', '2025-07-01', '2025-07-10', 18.00, N'Giảm 18% cho tất cả sản phẩm thời trang nam'),
(N'Khuyến mãi ngày hội thể thao', '2025-08-15', '2025-08-20', 20.00, N'Giảm 20% cho sản phẩm thể thao và ngoài trời'),
(N'Giảm giá cho sản phẩm làm đẹp', '2025-11-15', '2025-11-25', 15.00, N'Giảm 15% cho các sản phẩm chăm sóc sắc đẹp'),
(N'Ưu đãi khách hàng mới', '2025-05-20', '2025-05-30', 10.00, N'Giảm 10% cho khách hàng mua sắm lần đầu'),
(N'Giảm giá cho sản phẩm điện tử', '2025-12-10', '2025-12-20', 22.00, N'Giảm 22% cho các sản phẩm điện tử'),
(N'Khuyến mãi ngày hội công nghệ', '2026-01-15', '2026-01-20', 30.00, N'Giảm 30% cho các sản phẩm công nghệ cao'),
(N'Giảm giá cho sản phẩm đồ chơi ngoài trời', '2025-06-20', '2025-06-30', 12.00, N'Giảm 12% cho đồ chơi ngoài trời'),
(N'Giảm giá cho đơn hàng trên 1.000.000 VNĐ', '2025-09-10', '2025-09-20', 20.00, N'Giảm 20% cho đơn hàng từ 1.000.000 VNĐ trở lên'),
(N'Khuyến mãi ngày hội thời trang', '2025-10-10', '2025-10-15', 25.00, N'Giảm 25% cho tất cả sản phẩm thời trang'),
(N'Giảm giá cho sản phẩm đồ dùng bếp', '2025-11-01', '2025-11-10', 15.00, N'Giảm 15% cho các sản phẩm đồ dùng nhà bếp'),
(N'Giảm giá cho sản phẩm chăm sóc sức khỏe', '2026-02-15', '2026-02-25', 18.00, N'Giảm 18% cho sản phẩm chăm sóc sức khỏe'),
(N'Khuyến mãi ngày hội trẻ em', '2026-06-01', '2026-06-03', 20.00, N'Giảm 20% cho tất cả sản phẩm dành cho trẻ em'),
(N'Giảm giá cho sản phẩm đồ uống giải nhiệt', '2025-07-15', '2025-07-25', 10.00, N'Giảm 10% cho đồ uống giải nhiệt mùa hè'),
(N'Giảm giá cho sản phẩm đồ trang trí', '2025-12-15', '2025-12-25', 25.00, N'Giảm 25% cho đồ trang trí nội thất'),
(N'Khuyến mãi ngày hội mua sắm online', '2025-08-01', '2025-08-10', 15.00, N'Giảm 15% cho đơn hàng đặt qua ứng dụng'),
(N'Giảm giá cho sản phẩm đồ dùng cá nhân', '2026-03-01', '2026-03-10', 12.00, N'Giảm 12% cho các sản phẩm đồ dùng cá nhân'),
(N'Giảm giá cho sản phẩm thời trang nữ', '2025-09-20', '2025-09-30', 20.00, N'Giảm 20% cho tất cả sản phẩm thời trang nữ'),
(N'Khuyến mãi ngày hội sức khỏe', '2026-04-07', '2026-04-09', 15.00, N'Giảm 15% cho sản phẩm hỗ trợ sức khỏe'),
(N'Giảm giá cho sản phẩm đồ chơi công nghệ', '2025-10-20', '2025-10-30', 18.00, N'Giảm 18% cho đồ chơi công nghệ cao'),
(N'Giảm giá cho đơn hàng giao hàng miễn phí', '2025-11-10', '2025-11-20', 10.00, N'Giảm 10% cho đơn hàng giao hàng miễn phí'),
(N'Khuyến mãi ngày hội nội thất', '2026-01-10', '2026-01-15', 25.00, N'Giảm 25% cho tất cả sản phẩm nội thất'),
(N'Giảm giá cho sản phẩm thời trang trẻ em', '2025-06-15', '2025-06-25', 15.00, N'Giảm 15% cho thời trang trẻ em'),
(N'Giảm giá cho sản phẩm đồ dùng văn phòng', '2025-08-10', '2025-08-20', 12.00, N'Giảm 12% cho đồ dùng văn phòng phẩm'),
(N'Khuyến mãi ngày hội gia đình', '2026-06-28', '2026-06-30', 20.00, N'Giảm 20% cho sản phẩm dành cho gia đình'),
(N'Giảm giá cho sản phẩm đồ chơi lắp ráp', '2025-07-20', '2025-07-30', 15.00, N'Giảm 15% cho đồ chơi lắp ráp'),
(N'Giảm giá cho sản phẩm thực phẩm hữu cơ', '2026-03-15', '2026-03-25', 18.00, N'Giảm 18% cho thực phẩm hữu cơ'),
(N'Khuyến mãi ngày hội môi trường', '2026-06-05', '2026-06-07', 15.00, N'Giảm 15% cho sản phẩm thân thiện môi trường'),
(N'Giảm giá phụ kiện thời trang', '2025-09-15', '2025-09-25', 20.00, N'Giảm 20% cho các phụ kiện thời trang'),
(N'Giảm giá cho sản phẩm đồ điện gia dụng', '2025-12-01', '2025-12-10', 25.00, N'Giảm 25% cho đồ điện gia dụng'),
(N'Khuyến mãi ngày hội công nghệ thông tin', '2026-01-20', '2026-01-25', 30.00, N'Giảm 30% cho sản phẩm công nghệ thông tin'),
(N'Giảm giá cho sản phẩm đồ chơi giáo dục', '2025-06-01', '2025-06-10', 15.00, N'Giảm 15% cho đồ chơi giáo dục'),
(N'Giảm giá cho sản phẩm chăm sóc tóc', '2025-11-01', '2025-11-10', 12.00, N'Giảm 12% cho sản phẩm chăm sóc tóc'),
(N'Khuyến mãi ngày hội mua sắm trực tuyến', '2025-08-20', '2025-08-30', 20.00, N'Giảm 20% cho đơn hàng trực tuyến'),
(N'Giảm giá cho sản phẩm đồ uống dinh dưỡng', '2026-02-01', '2026-02-10', 15.00, N'Giảm 15% cho đồ uống dinh dưỡng'),
(N'Giảm giá cho sản phẩm đồ chơi sáng tạo', '2025-07-01', '2025-07-15', 18.00, N'Giảm 18% cho đồ chơi sáng tạo'),
(N'Khuyến mãi ngày hội sức khỏe cộng đồng', '2026-04-07', '2026-04-10', 20.00, N'Giảm 20% cho sản phẩm chăm sóc sức khỏe'),
(N'Giảm giá cho sản phẩm đồ dùng học sinh', '2025-08-15', '2025-08-25', 10.00, N'Giảm 10% cho đồ dùng học sinh'),
(N'Giảm giá thời trang thể thao', '2025-09-01', '2025-09-10', 15.00, N'Giảm 15% cho thời trang thể thao'),
(N'Khuyến mãi ngày hội công nghệ xanh', '2026-06-05', '2026-06-08', 25.00, N'Giảm 25% cho sản phẩm công nghệ thân thiện môi trường'),
(N'Giảm giá cho sản', '2025-12-15', '2025-12-25', 20.00, N'Giảm 20% cho tất cả sản phẩm trang trí nhà cửa'),
(N'Giảm giá cho sản phẩm đồ chơi nhập khẩu', '2025-06-20', '2025-06-30', 18.00, N'Giảm 18% cho đồ chơi nhập khẩu'),
(N'Khuyến mãi ngày hội du lịch', '2026-07-01', '2026-07-05', 15.00, N'Giảm 15% cho sản phẩm du lịch và dã ngoại'),
(N'Giảm giá phẩm đông lạnh', '2025-11-15', '2025-11-25', 12.00, N'Giảm 12% cho thực phẩm đông lạnh'),
(N'Giảm giá cho sản phẩm đồ dùng thể thao', '2025-08-01', '2025-08-10', 20.00, N'Giảm 20% cho đồ dùng thể thao'),
(N'Khuyến mãi ngày hội sáng tạo', '2026-03-01', '2026-03-05', 25.00, N'Giảm 25% cho sản phẩm hỗ trợ sáng tạo');
go
insert into ChiTietKhuyenMai (MaKM, MasP) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 3),
(5, 4),
(6, 5),
(4, 6),
(4, 7),
(5, 8),
(5, 9),
(6, 10),
(6, 11),
(7, 12),
(7, 13),
(8, 14),
(8, 15),
(9, 16),
(9, 17),
(10, 18),
(10, 19),
(11, 20),
(11, 21),
(12, 22),
(12, 23),
(13, 24),
(13, 25),
(14, 26),
(14, 27),
(15, 28),
(15, 29),
(16, 30),
(16, 31),
(17, 32),
(17, 33),
(18, 34),
(18, 35),
(19, 36),
(19, 37),
(20, 38),
(20, 39),
(21, 40),
(21, 41),
(22, 42),
(22, 43),
(23, 44),
(23, 45),
(24, 46),
(24, 47),
(25, 48),
(25, 49),
(26, 50),
(26, 51),
(27, 52),
(27, 53),
(28, 54),
(28, 55),
(29, 56),
(29, 57),
(30, 58),
(30, 59),
(31, 60),
(31, 61),
(32, 62),
(32, 63),
(33, 64),
(33, 65),
(34, 66),
(34, 67),
(35, 68),
(35, 69),
(36, 70),
(36, 71),
(37, 72),
(37, 73),
(38, 74),
(38, 75),
(39, 76),
(39, 77),
(40, 78),
(40, 79),
(41, 80),
(41, 62),
(42, 63),
(42, 64),
(43, 65),
(43, 66),
(44, 67),
(44, 68),
(45, 69),
(45, 70),
(46, 71),
(46, 72),
(47, 73),
(47, 74),
(48, 75),
(48, 76),
(49, 77),
(49, 78),
(50, 79),
(50, 80);
go
-- Bảng HoaDonBan
insert into HoaDonBan (MaNV, MaKH, NgayBan, TongTien, DiemSuDung) VALUES
(1, 1, GETdate(), 11400000, 0),
(2, 2, dateADD(day, -1, GETdate()), 450000, 10),
(3, 3, dateADD(day, -2, GETdate()), 72000, 5),
(4, 4, dateADD(day, -3, GETdate()), 225000, 15),
(5, 5, dateADD(day, -4, GETdate()), 315000, 0),
(6, 6, dateADD(day, -5, GETdate()), 108000, 20),
(7, 7, dateADD(day, -6, GETdate()), 84000, 0),
(8, 8, dateADD(day, -7, GETdate()), 36000, 10),
(9, 9, dateADD(day, -8, GETdate()), 760000, 25),
(10, 10, dateADD(day, -9, GETdate()), 31500, 0),
(11, 11, dateADD(day, -10, GETdate()), 1500000, 10),
(12, 12, dateADD(day, -11, GETdate()), 85000, 0),
(13, 13, dateADD(day, -12, GETdate()), 320000, 15),
(14, 14, dateADD(day, -13, GETdate()), 9500000, 30),
(15, 15, dateADD(day, -14, GETdate()), 45000, 0),
(16, 16, dateADD(day, -15, GETdate()), 180000, 5),
(17, 17, dateADD(day, -16, GETdate()), 2500000, 20),
(18, 18, dateADD(day, -17, GETdate()), 60000, 0),
(19, 19, dateADD(day, -18, GETdate()), 120000, 10),
(20, 20, dateADD(day, -19, GETdate()), 780000, 25),
(21, 21, dateADD(day, -20, GETdate()), 35000, 0),
(22, 22, dateADD(day, -21, GETdate()), 450000, 15),
(23, 23, dateADD(day, -22, GETdate()), 2000000, 0),
(24, 24, dateADD(day, -23, GETdate()), 95000, 5),
(25, 25, dateADD(day, -24, GETdate()), 300000, 10),
(26, 26, dateADD(day, -25, GETdate()), 15000000, 40),
(27, 27, dateADD(day, -26, GETdate()), 65000, 0),
(28, 28, dateADD(day, -27, GETdate()), 1800000, 20),
(29, 29, dateADD(day, -28, GETdate()), 420000, 15),
(30, 30, dateADD(day, -29, GETdate()), 75000, 0),
(31, 31, dateADD(day, -30, GETdate()), 250000, 10),
(32, 32, dateADD(day, -31, GETdate()), 3200000, 30),
(33, 33, dateADD(day, -32, GETdate()), 85000, 0),
(34, 34, dateADD(day, -33, GETdate()), 150000, 5),
(35, 35, dateADD(day, -34, GETdate()), 600000, 15),
(36, 36, dateADD(day, -35, GETdate()), 45000, 0),
(37, 37, dateADD(day, -36, GETdate()), 900000, 25),
(38, 38, dateADD(day, -37, GETdate()), 120000, 10),
(39, 39, dateADD(day, -38, GETdate()), 3500000, 0),
(40, 40, dateADD(day, -39, GETdate()), 65000, 5),
(41, 41, dateADD(day, -40, GETdate()), 180000, 0),
(42, 42, dateADD(day, -41, GETdate()), 2500000, 20),
(43, 43, dateADD(day, -42, GETdate()), 95000, 10),
(44, 44, dateADD(day, -43, GETdate()), 420000, 15),
(45, 45, dateADD(day, -44, GETdate()), 75000, 0),
(46, 46, dateADD(day, -45, GETdate()), 1500000, 30),
(47, 47, dateADD(day, -46, GETdate()), 320000, 5),
(48, 48, dateADD(day, -47, GETdate()), 85000, 0),
(49, 49, dateADD(day, -48, GETdate()), 600000, 25),
(50, 50, dateADD(day, -49, GETdate()), 120000, 10),
(51, 51, dateADD(day, -50, GETdate()), 9500000, 40),
(52, 52, dateADD(day, -51, GETdate()), 45000, 0),
(53, 53, dateADD(day, -52, GETdate()), 180000, 5),
(54, 54, dateADD(day, -53, GETdate()), 2500000, 20),
(55, 55, dateADD(day, -54, GETdate()), 65000, 0),
(56, 56, dateADD(day, -55, GETdate()), 420000, 15),
(57, 57, dateADD(day, -56, GETdate()), 75000, 10),
(58, 58, dateADD(day, -57, GETdate()), 150000, 0),
(59, 59, dateADD(day, -58, GETdate()), 3200000, 30),
(60, 60, dateADD(day, -59, GETdate()), 85000, 5),
(61, 61, dateADD(day, -60, GETdate()), 600000, 0),
(62, 62, dateADD(day, -61, GETdate()), 120000, 10),
(63, 63, dateADD(day, -62, GETdate()), 1800000, 25),
(64, 64, dateADD(day, -63, GETdate()), 45000, 0),
(65, 65, dateADD(day, -64, GETdate()), 95000, 5),
(66, 66, dateADD(day, -65, GETdate()), 250000, 15),
(67, 67, dateADD(day, -66, GETdate()), 1500000, 20),
(68, 68, dateADD(day, -67, GETdate()), 65000, 0),
(69, 69, dateADD(day, -68, GETdate()), 420000, 10),
(70, 70, dateADD(day, -69, GETdate()), 75000, 5),
(71, 71, dateADD(day, -70, GETdate()), 3200000, 30),
(72, 72, dateADD(day, -71, GETdate()), 85000, 0),
(73, 73, dateADD(day, -72, GETdate()), 180000, 15),
(74, 74, dateADD(day, -73, GETdate()), 600000, 10),
(75, 75, dateADD(day, -74, GETdate()), 120000, 0),
(76, 76, dateADD(day, -75, GETdate()), 9500000, 40),
(77, 77, dateADD(day, -76, GETdate()), 45000, 5),
(78, 78, dateADD(day, -77, GETdate()), 2500000, 20),
(79, 79, dateADD(day, -78, GETdate()), 65000, 0),
(80, 80, dateADD(day, -79, GETdate()), 420000, 15),
(81, 81, dateADD(day, -80, GETdate()), 75000, 10),
(82, 82, dateADD(day, -81, GETdate()), 150000, 0),
(83, 83, dateADD(day, -82, GETdate()), 3200000, 30),
(84, 84, dateADD(day, -83, GETdate()), 85000, 5),
(85, 85, dateADD(day, -84, GETdate()), 180000, 0),
(86, 86, dateADD(day, -85, GETdate()), 600000, 25),
(87, 87, dateADD(day, -86, GETdate()), 120000, 10),
(88, 88, dateADD(day, -87, GETdate()), 9500000, 40),
(89, 89, dateADD(day, -88, GETdate()), 45000, 0),
(90, 90, dateADD(day, -89, GETdate()), 2500000, 20),
(91, 91, dateADD(day, -90, GETdate()), 65000, 5),
(92, 92, dateADD(day, -91, GETdate()), 420000, 15),
(93, 93, dateADD(day, -92, GETdate()), 75000, 0),
(94, 94, dateADD(day, -93, GETdate()), 150000, 10),
(95, 95, dateADD(day, -94, GETdate()), 3200000, 30),
(96, 96, dateADD(day, -95, GETdate()), 85000, 0),
(97, 97, dateADD(day, -96, GETdate()), 180000, 5),
(98, 98, dateADD(day, -97, GETdate()), 600000, 25),
(99, 99, dateADD(day, -98, GETdate()), 120000, 10),
(100, 100, dateADD(day, -99, GETdate()), 9500000, 40);
go
-- Bảng ChiTietHDBan
insert into ChiTietHDBan (MaHDBan, MasP, SoLuong, DonGia, ThanhTien) VALUES
(1, 1, 1, 12000000, 12000000),
(2, 2, 1, 500000, 500000),
(3, 3, 1, 90000, 90000),
(4, 4, 1, 250000, 250000),
(5, 5, 1, 80000, 80000),
(6, 6, 1, 350000, 350000),
(7, 7, 1, 120000, 120000),
(8, 8, 1, 40000, 40000),
(9, 9, 1, 800000, 800000),
(10, 10, 1, 35000, 35000),
(11, 11, 1, 20000000, 20000000),
(12, 12, 1, 7500000, 7500000),
(13, 13, 2, 180000, 360000),
(14, 14, 1, 600000, 600000),
(15, 15, 2, 100000, 200000),
(16, 16, 1, 250000, 250000),
(17, 17, 3, 300000, 900000),
(18, 18, 5, 25000, 125000),
(19, 19, 1, 450000, 450000),
(20, 20, 2, 150000, 300000),
(21, 21, 1, 10000000, 10000000),
(22, 22, 3, 80000, 240000),
(23, 23, 1, 500000, 500000),
(24, 24, 2, 70000, 140000),
(25, 25, 1, 450000, 450000),
(26, 26, 1, 180000, 180000),
(27, 27, 2, 800000, 1600000),
(28, 28, 4, 35000, 140000),
(29, 29, 1, 900000, 900000),
(30, 30, 2, 60000, 120000),
(31, 31, 1, 27000000, 27000000),
(32, 32, 3, 80000, 240000),
(33, 33, 1, 350000, 350000),
(34, 34, 2, 180000, 360000),
(35, 35, 1, 120000, 120000),
(36, 36, 5, 25000, 125000),
(37, 37, 1, 400000, 400000),
(38, 38, 2, 50000, 100000),
(39, 39, 1, 800000, 800000),
(40, 40, 3, 35000, 105000),
(41, 41, 1, 6000000, 6000000),
(42, 42, 2, 50000, 100000),
(43, 43, 1, 350000, 350000),
(44, 44, 1, 120000, 120000),
(45, 45, 4, 25000, 100000),
(46, 46, 1, 250000, 250000),
(47, 47, 2, 150000, 300000),
(48, 48, 3, 120000, 360000),
(49, 49, 1, 2000000, 2000000),
(50, 50, 5, 25000, 125000),
(51, 51, 1, 9000000, 9000000),
(52, 52, 2, 35000, 70000),
(53, 53, 1, 400000, 400000),
(54, 54, 3, 50000, 150000),
(55, 55, 1, 150000, 150000),
(56, 56, 2, 120000, 240000),
(57, 57, 1, 800000, 800000),
(58, 58, 4, 25000, 100000),
(59, 59, 1, 3000000, 3000000),
(60, 60, 2, 60000, 120000),
(61, 61, 1, 3000000, 3000000),
(62, 62, 3, 35000, 105000),
(63, 63, 1, 350000, 350000),
(64, 64, 2, 140000, 280000),
(65, 65, 1, 120000, 120000),
(66, 66, 5, 25000, 125000),
(67, 67, 1, 600000, 600000),
(68, 68, 2, 90000, 180000),
(69, 69, 1, 1500000, 1500000),
(70, 70, 3, 50000, 150000),
(71, 71, 1, 7000000, 7000000),
(72, 72, 2, 30000, 60000),
(73, 73, 1, 300000, 300000),
(74, 74, 4, 80000, 320000),
(75, 75, 1, 120000, 120000),
(76, 76, 2, 150000, 300000),
(77, 77, 1, 450000, 450000),
(78, 78, 3, 35000, 105000),
(79, 79, 1, 2000000, 2000000),
(80, 80, 5, 25000, 125000),
(81, 81, 1, 900000, 900000),
(82, 82, 2, 60000, 120000),
(83, 83, 1, 350000, 350000),
(84, 84, 3, 100000, 300000),
(85, 85, 1, 150000, 150000),
(86, 86, 2, 120000, 240000),
(87, 87, 1, 800000, 800000),
(88, 88, 4, 25000, 100000),
(89, 89, 1, 3000000, 3000000),
(90, 90, 2, 50000, 100000),
(91, 91, 1, 7000000, 7000000),
(92, 92, 3, 35000, 105000),
(93, 93, 1, 400000, 400000),
(94, 94, 2, 120000, 240000),
(95, 95, 1, 150000, 150000),
(96, 96, 5, 25000, 125000),
(97, 97, 1, 600000, 600000),
(98, 98, 2, 80000, 160000),
(99, 99, 1, 2000000, 2000000),
(100, 100, 3, 50000, 150000);
go
-- Tiếp tục bảng HoaDonNhap
insert into HoaDonNhap (MaNV, MaNCC, NgayNhap, TongTien) VALUES
(2, 1, dateADD(day, -10, GETdate()), 7200000),
(3, 2, dateADD(day, -11, GETdate()), 15000000),
(4, 3, dateADD(day, -12, GETdate()), 540000),
(5, 4, dateADD(day, -13, GETdate()), 1200000),
(6, 5, dateADD(day, -14, GETdate()), 2100000),
(7, 6, dateADD(day, -15, GETdate()), 4800000),
(8, 7, dateADD(day, -16, GETdate()), 900000),
(9, 8, dateADD(day, -17, GETdate()), 10500000),
(10, 9, dateADD(day, -18, GETdate()), 3600000),
(1, 10, dateADD(day, -19, GETdate()), 1800000),
(11, 11, dateADD(day, -20, GETdate()), 2700000),
(12, 12, dateADD(day, -21, GETdate()), 6300000),
(13, 13, dateADD(day, -22, GETdate()), 4200000),
(14, 14, dateADD(day, -23, GETdate()), 8100000),
(15, 15, dateADD(day, -24, GETdate()), 1500000),
(16, 16, dateADD(day, -25, GETdate()), 9600000),
(17, 17, dateADD(day, -26, GETdate()), 3300000),
(18, 18, dateADD(day, -27, GETdate()), 5700000),
(19, 19, dateADD(day, -28, GETdate()), 2400000),
(20, 20, dateADD(day, -29, GETdate()), 6900000),
(21, 21, dateADD(day, -30, GETdate()), 3900000),
(22, 22, dateADD(day, -31, GETdate()), 8700000),
(23, 23, dateADD(day, -32, GETdate()), 1800000),
(24, 24, dateADD(day, -33, GETdate()), 5100000),
(25, 25, dateADD(day, -34, GETdate()), 3000000),
(26, 26, dateADD(day, -35, GETdate()), 7500000),
(27, 27, dateADD(day, -36, GETdate()), 4500000),
(28, 28, dateADD(day, -37, GETdate()), 9300000),
(29, 29, dateADD(day, -38, GETdate()), 2100000),
(30, 30, dateADD(day, -39, GETdate()), 6000000),
(31, 31, dateADD(day, -40, GETdate()), 3600000),
(32, 32, dateADD(day, -41, GETdate()), 7800000),
(33, 33, dateADD(day, -42, GETdate()), 2700000),
(34, 34, dateADD(day, -43, GETdate()), 6600000),
(35, 35, dateADD(day, -44, GETdate()), 4200000),
(36, 36, dateADD(day, -45, GETdate()), 8400000),
(37, 37, dateADD(day, -46, GETdate()), 2400000),
(38, 38, dateADD(day, -47, GETdate()), 6900000),
(39, 39, dateADD(day, -48, GETdate()), 3900000),
(40, 40, dateADD(day, -49, GETdate()), 9000000),
(41, 41, dateADD(day, -50, GETdate()), 3000000),
(42, 42, dateADD(day, -51, GETdate()), 7200000),
(43, 43, dateADD(day, -52, GETdate()), 4500000),
(44, 44, dateADD(day, -53, GETdate()), 8100000),
(45, 45, dateADD(day, -54, GETdate()), 2700000),
(46, 46, dateADD(day, -55, GETdate()), 6600000),
(47, 47, dateADD(day, -56, GETdate()), 3600000),
(48, 48, dateADD(day, -57, GETdate()), 7800000),
(49, 49, dateADD(day, -58, GETdate()), 2400000),
(50, 50, dateADD(day, -59, GETdate()), 6900000),
(51, 51, dateADD(day, -60, GETdate()), 4200000),
(52, 52, dateADD(day, -61, GETdate()), 8700000),
(53, 53, dateADD(day, -62, GETdate()), 3000000),
(54, 54, dateADD(day, -63, GETdate()), 7500000),
(55, 55, dateADD(day, -64, GETdate()), 3900000),
(56, 56, dateADD(day, -65, GETdate()), 9300000),
(57, 57, dateADD(day, -66, GETdate()), 2700000),
(58, 58, dateADD(day, -67, GETdate()), 6600000),
(59, 59, dateADD(day, -68, GETdate()), 4500000),
(60, 60, dateADD(day, -69, GETdate()), 8100000),
(61, 61, dateADD(day, -70, GETdate()), 2400000),
(62, 62, dateADD(day, -71, GETdate()), 7200000),
(63, 63, dateADD(day, -72, GETdate()), 3600000),
(64, 64, dateADD(day, -73, GETdate()), 7800000),
(65, 65, dateADD(day, -74, GETdate()), 3000000),
(66, 66, dateADD(day, -75, GETdate()), 6900000),
(67, 67, dateADD(day, -76, GETdate()), 4200000),
(68, 68, dateADD(day, -77, GETdate()), 8700000),
(69, 69, dateADD(day, -78, GETdate()), 2700000),
(70, 70, dateADD(day, -79, GETdate()), 6600000),
(71, 71, dateADD(day, -80, GETdate()), 3900000),
(72, 72, dateADD(day, -81, GETdate()), 9300000),
(73, 73, dateADD(day, -82, GETdate()), 2400000),
(74, 74, dateADD(day, -83, GETdate()), 7200000),
(75, 75, dateADD(day, -84, GETdate()), 4500000),
(76, 76, dateADD(day, -85, GETdate()), 8100000),
(77, 77, dateADD(day, -86, GETdate()), 3000000),
(78, 78, dateADD(day, -87, GETdate()), 6900000),
(79, 79, dateADD(day, -88, GETdate()), 3600000),
(80, 80, dateADD(day, -89, GETdate()), 7800000),
(81, 81, dateADD(day, -90, GETdate()), 2700000),
(82, 82, dateADD(day, -91, GETdate()), 6600000),
(83, 83, dateADD(day, -92, GETdate()), 4200000),
(84, 84, dateADD(day, -93, GETdate()), 8700000),
(85, 85, dateADD(day, -94, GETdate()), 2400000),
(86, 86, dateADD(day, -95, GETdate()), 7200000),
(87, 87, dateADD(day, -96, GETdate()), 3900000),
(88, 88, dateADD(day, -97, GETdate()), 9300000),
(89, 89, dateADD(day, -98, GETdate()), 3000000),
(90, 90, dateADD(day, -99, GETdate()), 6900000),
(91, 91, dateADD(day, -100, GETdate()), 4500000),
(92, 92, dateADD(day, -101, GETdate()), 8100000),
(93, 93, dateADD(day, -102, GETdate()), 2700000),
(94, 94, dateADD(day, -103, GETdate()), 6600000),
(95, 95, dateADD(day, -104, GETdate()), 3600000),
(96, 96, dateADD(day, -105, GETdate()), 7800000),
(97, 97, dateADD(day, -106, GETdate()), 2400000),
(98, 98, dateADD(day, -107, GETdate()), 7200000),
(99, 99, dateADD(day, -108, GETdate()), 4200000),
(100, 100, dateADD(day, -109, GETdate()), 8700000);
go
-- Bảng ChiTietHDNhap
insert into ChiTietHDNhap (MaHDNhap, MasP, SoLuong, DonGia, ThanhTien) VALUES
(1, 1, 10, 720000, 7200000),
(2, 2, 30, 500000, 15000000),
(3, 3, 60, 9000, 540000),
(4, 4, 8, 150000, 1200000),
(5, 5, 30, 70000, 2100000),
(6, 6, 20, 240000, 4800000),
(7, 7, 15, 60000, 900000),
(8, 8, 50, 210000, 10500000),
(9, 9, 8, 450000, 3600000),
(10, 10, 90, 20000, 1800000),
(11, 11, 20, 310000, 6200000),
(12, 12, 30, 466667, 14000000),
(13, 13, 80, 9500, 760000),
(14, 14, 11, 100000, 1100000),
(15, 15, 30, 90000, 2700000),
(16, 16, 45, 100000, 4500000),
(17, 17, 11, 90000, 990000),
(18, 18, 48, 225000, 10800000),
(19, 19, 74, 50000, 3700000),
(20, 20, 95, 20000, 1900000),
(21, 1, 41, 200000, 8200000),
(22, 2, 50, 250000, 12500000),
(23, 3, 80, 8000, 640000),
(24, 4, 10, 100000, 1000000),
(25, 5, 57, 43860, 2500000),
(26, 6, 47, 100000, 4700000),
(27, 7, 29, 30000, 870000),
(28, 8, 38, 250000, 9500000),
(29, 9, 62, 50000, 3100000),
(30, 10, 70, 25000, 1750000),
(31, 11, 65, 110000, 7150000),
(32, 12, 58, 250000, 14500000),
(33, 13, 57, 10000, 570000),
(34, 14, 9, 150000, 1350000),
(35, 15, 59, 50000, 2950000),
(36, 16, 41, 100000, 4100000),
(37, 17, 19, 50000, 950000),
(38, 18, 56, 200000, 11200000),
(39, 19, 68, 50000, 3400000),
(40, 20, 84, 25000, 2100000),
(41, 1, 82, 95000, 7800000),
(42, 2, 52, 250000, 13000000),
(43, 3, 59, 10000, 590000),
(44, 4, 25, 50000, 1250000),
(45, 5, 57, 50000, 2850000),
(46, 6, 44, 100000, 4400000),
(47, 7, 49, 20000, 980000),
(48, 8, 51, 200000, 10200000),
(49, 9, 66, 50000, 3300000),
(50, 10, 80, 20000, 1600000),
(51, 11, 85, 100000, 8500000),
(52, 12, 55, 250000, 13750000),
(53, 13, 53, 10000, 530000),
(54, 14, 10, 145000, 1450000),
(55, 15, 44, 50000, 2200000),
(56, 16, 46, 100000, 4600000),
(57, 17, 19, 50000, 950000),
(58, 18, 56, 205000, 11500000),
(59, 19, 71, 50000, 3550000),
(60, 20, 84, 25000, 2100000),
(61, 1, 85, 90000, 7650000),
(62, 2, 61, 200000, 12200000),
(63, 3, 79, 9000, 710000),
(64, 4, 10, 95000, 950000),
(65, 5, 61, 50000, 3050000),
(66, 6, 49, 100000, 4900000),
(67, 7, 51, 20000, 1020000),
(68, 8, 52, 210000, 10920000),
(69, 9, 74, 50000, 3700000),
(70, 10, 74, 25000, 1850000),
(71, 11, 53, 150000, 7950000),
(72, 12, 57, 250000, 14250000),
(73, 13, 65, 10000, 650000),
(74, 14, 12, 115000, 1380000),
(75, 15, 46, 50000, 2300000),
(76, 16, 43, 100000, 4300000),
(77, 17, 19, 50000, 970000),
(78, 18, 58, 200000, 11600000),
(79, 19, 65, 50000, 3250000),
(80, 20, 68, 25000, 1700000),
(81, 1, 83, 100000, 8300000),
(82, 2, 63, 200000, 12600000),
(83, 3, 67, 10000, 670000),
(84, 4, 10, 112000, 1120000),
(85, 5, 51, 50000, 2550000),
(86, 6, 48, 100000, 4800000),
(87, 7, 33, 30000, 990000),
(88, 8, 53, 200000, 10600000),
(89, 9, 69, 50000, 3450000),
(90, 10, 78, 25000, 1950000),
(91, 11, 47, 150000, 7050000),
(92, 12, 59, 250000, 14750000),
(93, 13, 58, 10000, 580000),
(94, 14, 13, 125000, 1625000),
(95, 15, 43, 50000, 2150000),
(96, 16, 42, 100000, 4200000),
(97, 17, 18, 50000, 900000),
(98, 18, 59, 200000, 11800000),
(99, 19, 65, 50000, 3250000),
(100, 20, 68, 25000, 1700000);
go
-- Bảng PhieuKiemKho
insert into PhieuKiemKho (MaNV, NgayKiemKho, MoTa) VALUES
(1, GETdate(), N'Kiểm kê hàng hóa định kỳ'),
(2, dateADD(day, -5, GETdate()), N'Kiểm tra số lượng hàng hóa sau nhập kho'),
(3, dateADD(day, -10, GETdate()), N'Kiểm kê đột xuất'),
(4, dateADD(day, -15, GETdate()), N'Kiểm tra hàng hóa sắp hết hạn'),
(5, dateADD(day, -20, GETdate()), N'Kiểm kê hàng hóa cuối tháng'),
(6, dateADD(day, -25, GETdate()), N'Kiểm tra hàng hóa bị lỗi'),
(7, dateADD(day, -30, GETdate()), N'Kiểm kê hàng hóa theo yêu cầu'),
(8, dateADD(day, -35, GETdate()), N'Kiểm tra số lượng hàng hóa sau bán'),
(9, dateADD(day, -40, GETdate()), N'Kiểm kê hàng hóa đặc biệt'),
(10, dateADD(day, -45, GETdate()), N'Kiểm tra hàng hóa tồn kho'),
(11, dateADD(day, -50, GETdate()), N'Kiểm kê hàng thực phẩm tươi'),
(12, dateADD(day, -55, GETdate()), N'Kiểm tra hàng hóa đông lạnh'),
(13, dateADD(day, -60, GETdate()), N'Kiểm kê hàng gia dụng'),
(14, dateADD(day, -65, GETdate()), N'Kiểm tra hàng hóa đồ uống'),
(15, dateADD(day, -70, GETdate()), N'Kiểm kê hàng hóa văn phòng phẩm'),
(16, dateADD(day, -75, GETdate()), N'Kiểm tra hàng hóa mỹ phẩm'),
(17, dateADD(day, -80, GETdate()), N'Kiểm kê hàng thời trang'),
(18, dateADD(day, -85, GETdate()), N'Kiểm tra hàng hóa điện tử'),
(19, dateADD(day, -90, GETdate()), N'Kiểm kê hàng thực phẩm đóng hộp'),
(20, dateADD(day, -95, GETdate()), N'Kiểm tra hàng hóa đồ chơi'),
(21, dateADD(day, -100, GETdate()), N'Kiểm kê hàng hóa chăm sóc cá nhân'),
(22, dateADD(day, -105, GETdate()), N'Kiểm tra hàng hóa đồ dùng bếp'),
(23, dateADD(day, -110, GETdate()), N'Kiểm kê hàng hóa tẩy rửa'),
(24, dateADD(day, -115, GETdate()), N'Kiểm tra hàng hóa thực phẩm chay'),
(25, dateADD(day, -120, GETdate()), N'Kiểm kê hàng hóa nhập khẩu'),
(26, dateADD(day, -125, GETdate()), N'Kiểm tra hàng hóa đồ uống có cồn'),
(27, dateADD(day, -130, GETdate()), N'Kiểm kê hàng hóa đồ dùng trẻ em'),
(28, dateADD(day, -135, GETdate()), N'Kiểm tra hàng hóa đồ dùng thú cưng'),
(29, dateADD(day, -140, GETdate()), N'Kiểm kê hàng hóa trang trí'),
(30, dateADD(day, -145, GETdate()), N'Kiểm tra hàng hóa thể thao'),
(31, dateADD(day, -150, GETdate()), N'Kiểm kê hàng hóa sức khỏe'),
(32, dateADD(day, -155, GETdate()), N'Kiểm tra hàng hóa thực phẩm hữu cơ'),
(33, dateADD(day, -160, GETdate()), N'Kiểm kê hàng hóa rau sạch'),
(34, dateADD(day, -165, GETdate()), N'Kiểm tra hàng hóa nước suối'),
(35, dateADD(day, -170, GETdate()), N'Kiểm kê hàng hóa bánh kẹo'),
(36, dateADD(day, -175, GETdate()), N'Kiểm tra hàng hóa sữa'),
(37, dateADD(day, -180, GETdate()), N'Kiểm kê hàng hóa mì gói'),
(38, dateADD(day, -185, GETdate()), N'Kiểm tra hàng hóa snack'),
(39, dateADD(day, -190, GETdate()), N'Kiểm kê hàng hóa dầu ăn'),
(40, dateADD(day, -195, GETdate()), N'Kiểm tra hàng hóa nước chấm'),
(41, dateADD(day, -200, GETdate()), N'Kiểm kê hàng hóa trà cà phê'),
(42, dateADD(day, -205, GETdate()), N'Kiểm tra hàng hóa bia rượu'),
(43, dateADD(day, -210, GETdate()), N'Kiểm kê hàng hóa khăn giấy'),
(44, dateADD(day, -215, GETdate()), N'Kiểm tra hàng hóa gạo'),
(45, dateADD(day, -220, GETdate()), N'Kiểm kê hàng hóa nước ép'),
(46, dateADD(day, -225, GETdate()), N'Kiểm tra hàng hóa đặc sản'),
(47, dateADD(day, -230, GETdate()), N'Kiểm kê hàng hóa sữa chua'),
(48, dateADD(day, -235, GETdate()), N'Kiểm tra hàng hóa thực phẩm nhanh'),
(49, dateADD(day, -240, GETdate()), N'Kiểm kê hàng hóa gia vị'),
(50, dateADD(day, -245, GETdate()), N'Kiểm tra hàng hóa nước tăng lực'),
(51, dateADD(day, -250, GETdate()), N'Kiểm kê hàng hóa vitamin'),
(52, dateADD(day, -255, GETdate()), N'Kiểm tra hàng hóa đồ nhựa'),
(53, dateADD(day, -260, GETdate()), N'Kiểm kê hàng hóa mứt Tết'),
(54, dateADD(day, -265, GETdate()), N'Kiểm tra hàng hóa bánh chưng'),
(55, dateADD(day, -270, GETdate()), N'Kiểm kê hàng hóa tương cà'),
(56, dateADD(day, -275, GETdate()), N'Kiểm tra hàng hóa rượu vang'),
(57, dateADD(day, -280, GETdate()), N'Kiểm kê hàng hóa bình sữa'),
(58, dateADD(day, -285, GETdate()), N'Kiểm tra hàng hóa nước mắm'),
(59, dateADD(day, -290, GETdate()), N'Kiểm kê hàng hóa hạt dưa'),
(60, dateADD(day, -295, GETdate()), N'Kiểm tra hàng hóa sữa chua uống'),
(61, dateADD(day, -300, GETdate()), N'Kiểm kê hàng hóa nồi áp suất'),
(62, dateADD(day, -305, GETdate()), N'Kiểm tra hàng hóa cải xanh'),
(63, dateADD(day, -310, GETdate()), N'Kiểm kê hàng hóa nước ép dứa'),
(64, dateADD(day, -315, GETdate()), N'Kiểm tra hàng hóa cà phê'),
(65, dateADD(day, -320, GETdate()), N'Kiểm kê hàng hóa dầu gội'),
(66, dateADD(day, -325, GETdate()), N'Kiểm tra hàng hóa kem đánh răng'),
(67, dateADD(day, -330, GETdate()), N'Kiểm kê hàng hóa đồ chơi trẻ em'),
(68, dateADD(day, -335, GETdate()), N'Kiểm tra hàng hóa đồ gia dụng'),
(69, dateADD(day, -340, GETdate()), N'Kiểm kê hàng hóa đồ điện'),
(70, dateADD(day, -345, GETdate()), N'Kiểm tra hàng hóa đồ đông lạnh'),
(71, dateADD(day, -350, GETdate()), N'Kiểm kê hàng hóa thực phẩm tươi'),
(72, dateADD(day, -355, GETdate()), N'Kiểm tra hàng hóa đồ uống có cồn'),
(73, dateADD(day, -360, GETdate()), N'Kiểm kê hàng hóa đồ dùng học tập'),
(74, dateADD(day, -365, GETdate()), N'Kiểm tra hàng hóa mỹ phẩm nam'),
(75, dateADD(day, -370, GETdate()), N'Kiểm kê hàng hóa thực phẩm chay'),
(76, dateADD(day, -375, GETdate()), N'Kiểm tra hàng hóa đồ dùng bếp'),
(77, dateADD(day, -380, GETdate()), N'Kiểm kê hàng hóa đồ vệ sinh'),
(78, dateADD(day, -385, GETdate()), N'Kiểm tra hàng hóa đồ chăm sóc trẻ'),
(79, dateADD(day, -390, GETdate()), N'Kiểm kê hàng hóa đồ dùng thú cưng'),
(80, dateADD(day, -395, GETdate()), N'Kiểm tra hàng hóa đồ trang trí'),
(81, dateADD(day, -400, GETdate()), N'Kiểm kê hàng hóa đồ thể thao'),
(82, dateADD(day, -405, GETdate()), N'Kiểm tra hàng hóa đồ điện tử nhỏ'),
(83, dateADD(day, -410, GETdate()), N'Kiểm kê hàng hóa đồ dùng văn phòng'),
(84, dateADD(day, -415, GETdate()), N'Kiểm tra hàng hóa đồ ăn vặt'),
(85, dateADD(day, -420, GETdate()), N'Kiểm kê hàng hóa đồ uống không cồn'),
(86, dateADD(day, -425, GETdate()), N'Kiểm tra hàng hóa đồ chăm sóc tóc'),
(87, dateADD(day, -430, GETdate()), N'Kiểm kê hàng hóa đồ dùng cá nhân'),
(88, dateADD(day, -435, GETdate()), N'Kiểm tra hàng hóa thực phẩm nhập khẩu'),
(89, dateADD(day, -440, GETdate()), N'Kiểm kê hàng hóa đồ dùng y tế'),
(90, dateADD(day, -445, GETdate()), N'Kiểm tra hàng hóa đồ chăm sóc da'),
(91, dateADD(day, -450, GETdate()), N'Kiểm kê hàng hóa đồ dùng nấu ăn'),
(92, dateADD(day, -455, GETdate()), N'Kiểm tra hàng hóa đồ dùng dã ngoại'),
(93, dateADD(day, -460, GETdate()), N'Kiểm kê hàng hóa đồ dùng ngủ'),
(94, dateADD(day, -465, GETdate()), N'Kiểm tra hàng hóa đồ dùng tắm'),
(95, dateADD(day, -470, GETdate()), N'Kiểm kê hàng hóa đồ dùng làm đẹp'),
(96, dateADD(day, -475, GETdate()), N'Kiểm tra hàng hóa đồ dùng gia đình'),
(97, dateADD(day, -480, GETdate()), N'Kiểm kê hàng hóa đồ dùng thời trang'),
(98, dateADD(day, -485, GETdate()), N'Kiểm tra hàng hóa đồ dùng công nghệ'),
(99, dateADD(day, -490, GETdate()), N'Kiểm kê hàng hóa đồ dùng giải trí'),
(100, dateADD(day, -495, GETdate()), N'Kiểm tra hàng hóa đồ dùng sức khỏe');
go
-- Bảng ChiTietPhieuKiemKho
insert into ChiTietPhieuKiemKho (MaPhieuKK, MasP, SoLuongThucTe, SoLuongHeThong, ChenhLech) VALUES
(1, 1, 50, 50, 0),
(1, 2, 102, 100, 2),
(2, 3, 200, 200, 0),
(2, 4, 78, 80, -2),
(3, 5, 150, 150, 0),
(3, 6, 72, 70, 2),
(4, 7, 118, 120, -2),
(4, 8, 300, 300, 0),
(5, 9, 60, 60, 0),
(5, 10, 248, 250, -2),
(6, 1, 100, 100, 0),
(6, 2, 95, 100, -5),
(7, 3, 110, 108, 2),
(7, 4, 90, 90, 0),
(8, 5, 130, 135, -5),
(8, 6, 80, 80, 0),
(9, 7, 120, 119, 1),
(9, 8, 145, 150, -5),
(10, 9, 60, 58, 2),
(10, 10, 200, 200, 0),
(11, 1, 101, 100, 1),
(11, 2, 102, 100, 2),
(12, 3, 199, 200, -1),
(12, 4, 85, 85, 0),
(13, 5, 140, 140, 0),
(13, 6, 68, 70, -2),
(14, 7, 117, 120, -3),
(14, 8, 310, 310, 0),
(15, 9, 63, 60, 3),
(15, 10, 245, 250, -5),
(16, 1, 48, 50, -2),
(16, 2, 103, 100, 3),
(17, 3, 205, 200, 5),
(17, 4, 82, 80, 2),
(18, 5, 149, 150, -1),
(18, 6, 75, 75, 0),
(19, 7, 122, 120, 2),
(19, 8, 298, 300, -2),
(20, 9, 59, 60, -1),
(20, 10, 260, 250, 10),
(21, 1, 50, 50, 0),
(21, 2, 98, 100, -2),
(22, 3, 198, 200, -2),
(22, 4, 81, 80, 1),
(23, 5, 155, 150, 5),
(23, 6, 74, 70, 4),
(24, 7, 121, 120, 1),
(24, 8, 302, 300, 2),
(25, 9, 62, 60, 2),
(25, 10, 240, 250, -10),
(26, 1, 49, 50, -1),
(26, 2, 105, 100, 5),
(27, 3, 201, 200, 1),
(27, 4, 77, 80, -3),
(28, 5, 145, 150, -5),
(28, 6, 73, 75, -2),
(29, 7, 119, 120, -1),
(29, 8, 295, 300, -5),
(30, 9, 61, 60, 1),
(30, 10, 255, 250, 5),
(31, 1, 52, 50, 2),
(31, 2, 97, 100, -3),
(32, 3, 203, 200, 3),
(32, 4, 83, 80, 3),
(33, 5, 151, 150, 1),
(33, 6, 70, 70, 0),
(34, 7, 115, 120, -5),
(34, 8, 299, 300, -1),
(35, 9, 65, 60, 5),
(35, 10, 245, 250, -5),
(36, 1, 50, 50, 0),
(36, 2, 100, 100, 0),
(37, 3, 200, 200, 0),
(37, 4, 80, 80, 0),
(38, 5, 150, 150, 0),
(38, 6, 70, 70, 0),
(39, 7, 120, 120, 0),
(39, 8, 300, 300, 0),
(40, 9, 60, 60, 0),
(40, 10, 250, 250, 0),
(41, 1, 55, 50, 5),
(41, 2, 110, 100, 10),
(42, 3, 190, 200, -10),
(42, 4, 85, 80, 5),
(43, 5, 160, 150, 10),
(43, 6, 65, 70, -5),
(44, 7, 130, 120, 10),
(44, 8, 280, 300, -20),
(45, 9, 58, 60, -2),
(45, 10, 240, 250, -10),
(46, 1, 51, 50, 1),
(46, 2, 99, 100, -1),
(47, 3, 202, 200, 2),
(47, 4, 82, 80, 2),
(48, 5, 148, 150, -2),
(48, 6, 78, 75, 3),
(49, 7, 124, 120, 4),
(49, 8, 310, 300, 10),
(50, 9, 66, 60, 6),
(50, 10, 265, 250, 15);
 go
-----------------------------------------------------query truy vấn các thành phần trong bảng -------------------------------------

----- tạo bảng view

---danh sach nhan vien
create view vw_DanhSachNhanVien as
select MaNV, HoTen, NgaySinh, GioiTinh, ChucVu
from NhanVien;
go 
--- danh sach san pham
create view vw_DanhSachSanPham as
select sp.MasP, sp.TenSP, lsp.TenLoaiSP, sp.GiaBan, sp.SoLuongTonKho
from SanPham sp
JOIN LoaiSanPham lsp on sp.MaLoaiSP = lsp.MaLoaiSP;

go 
---nhan vien ban duoc nhieu nhat
create view v_NhanVienBanDuocNhieuNhat as
select TOP 1 nv.MaNV, nv.HoTen, SUM(hdb.TongTien) as TongTienBan
from HoaDonBan hdb
JOIN NhanVien nv on hdb.MaNV = nv.MaNV
GROUP BY nv.MaNV, nv.HoTen
ORDER BY TongTienBan DESC;

go 
--- sản phẩm sap hêt hạn
create view v_SanPhamSapHetHan as
select MasP, TenSP, HanSuDung
from SanPham
where HanSuDung IS NOT NULL AND HanSuDung <= dateADD(day, 30, GETdate()) AND HanSuDung >= GETdate();

go
---Doanh thu thoe loai san pham
create view v_DoanhThuTheoLoaiSanPhamThang as
select lsp.TenLoaiSP, SUM(cthdb.ThanhTien) as DoanhThu
from ChiTietHDBan cthdb
JOIN SanPham sp on cthdb.MasP = sp.MasP
JOIN LoaiSanPham lsp on sp.MaLoaiSP = lsp.MaLoaiSP
JOIN HoaDonBan hdb on cthdb.MaHDBan = hdb.MaHDBan
where YEAR(hdb.NgayBan) = YEAR(GETdate()) AND MonTH(hdb.NgayBan) = MonTH(GETdate())
GROUP BY lsp.TenLoaiSP;

go
---tong so luong nhaop theo nha cung cap
create view v_TongSoLuongNhapTheonCCThang as
select ncc.TenNCC, SUM(cthdn.SoLuong) as TongSoLuongNhap
from ChiTietHDNhap cthdn
JOIN HoaDonNhap hdn on cthdn.MaHDNhap = hdn.MaHDNhap
JOIN NhaCungCap ncc on hdn.MaNCC = ncc.MaNCC
where YEAR(hdn.NgayNhap) = YEAR(GETdate()) AND MonTH(hdn.NgayNhap) = MonTH(GETdate())
GROUP BY ncc.TenNCC;

go
---bang view top 5 sang pham ban chay nhat thanh

create view v_Top5SanPhamBanChayNhatThang as
select TOP 5 sp.MasP, sp.TenSP, SUM(cthdb.SoLuong) as TongSoLuongBan
from ChiTietHDBan cthdb
JOIN SanPham sp on cthdb.MasP = sp.MasP
JOIN HoaDonBan hdb on cthdb.MaHDBan = hdb.MaHDBan
where YEAR(hdb.NgayBan) = YEAR(GETdate()) AND MonTH(hdb.NgayBan) = MonTH(GETdate())
GROUP BY sp.MasP, sp.TenSP
ORDER BY TongSoLuongBan DESC;
go
-- khach hang tiem nang
create view v_KhachHangTiemNang as
select kh.MaKH, kh.HoTen, kh.DiemTichLuy
from KhachHang kh
where kh.MaKH NOT IN (
    select DISTINCT MaKH
    from HoaDonBan
    where NgayBan >= dateADD(month, -3, GETdate())
)
ORDER BY kh.DiemTichLuy DESC;

go
---- bang biew so luong chenh lech kiem kho
create view v_SoLuongChenhLechKiemKho as
select
    pkk.MaPhieuKK,
    pkk.NgayKiemKho,
    nv.HoTen as NguoiKiemKho,
    sp.TenSP,
    ctpkk.SoLuongThucTe,
    ctpkk.SoLuongHeThong,
    ctpkk.ChenhLech
from PhieuKiemKho pkk
JOIN ChiTietPhieuKiemKho ctpkk on pkk.MaPhieuKK = ctpkk.MaPhieuKK
JOIN SanPham sp on ctpkk.MasP = sp.MasP
JOIN NhanVien nv on pkk.MaNV = nv.MaNV;

go
----- bang view  san pham cap nhat them
create view v_SanPhamCanNhapThem as
select sp.MasP, sp.TenSP, sp.SoLuongTonKho, SUM(cthdb.SoLuong) as SoLuongBanTrongThang
from SanPham sp
JOIN ChiTietHDBan cthdb on sp.MasP = cthdb.MasP
JOIN HoaDonBan hdb on cthdb.MaHDBan = hdb.MaHDBan
where sp.SoLuongTonKho < 20
  AND YEAR(hdb.NgayBan) = YEAR(GETdate()) AND MonTH(hdb.NgayBan) = MonTH(GETdate())
GROUP BY sp.MasP, sp.TenSP, sp.SoLuongTonKho
HAVING SUM(cthdb.SoLuong) > 50;

go
--- bang view chi tiet khuyen mai ten san pham va ten khuuyen mai
create view v_ChiTietKhuyenMaiVoiTenSPVaTenKM as
select km.TenKM, sp.TenSP
from ChiTietKhuyenMai ctkm
JOIN KhuyenMai km on ctkm.MaKM = km.MaKM
JOIN SanPham sp on ctkm.MasP = sp.MasP;

go
--bang vew có thong ke nhap xuat hang thang
create view v_ThongKeNhapXuatTonThang as
select
    sp.MasP,
    sp.TenSP,
    SUM(CasE WHEN YEAR(hdn.NgayNhap) = YEAR(GETdate()) AND MonTH(hdn.NgayNhap) = MonTH(GETdate()) THEN cthdn.SoLuong ELSE 0 end) as TongSoLuongNhapThang,
    SUM(CasE WHEN YEAR(hdb.NgayBan) = YEAR(GETdate()) AND MonTH(hdb.NgayBan) = MonTH(GETdate()) THEN cthdb.SoLuong ELSE 0 end) as TongSoLuongXuatThang,
    sp.SoLuongTonKho as TonHienTai
from SanPham sp
LEFT JOIN ChiTietHDNhap cthdn on sp.MasP = cthdn.MasP
LEFT JOIN HoaDonNhap hdn on cthdn.MaHDNhap = hdn.MaHDNhap
LEFT JOIN ChiTietHDBan cthdb on sp.MasP = cthdb.MasP
LEFT JOIN HoaDonBan hdb on cthdb.MaHDBan = hdb.MaHDBan
GROUP BY sp.MasP, sp.TenSP, sp.SoLuongTonKho;

go

---bảng view nhan vien co hoa don cao nhat
create view v_NhanVienCoHoaDonBanCaonhat as
select TOP 1 nv.MaNV, nv.HoTen, SUM(hdb.TongTien) as TongGiaTriBan
from NhanVien nv
JOIN HoaDonBan hdb on nv.MaNV = hdb.MaNV
where YEAR(hdb.NgayBan) = YEAR(GETdate())
GROUP BY nv.MaNV, nv.HoTen
ORDER BY TongGiaTriBan DESC;

go
--bảng view SanPhamLoiNhuanCaonhatThang
create view v_SanPhamLoiNhuanCaonhatThang as
select TOP 1
    sp.MasP,
    sp.TenSP,
    SUM(cthdb.SoLuong * (sp.GiaBan - sp.GiaNhap)) as TongLoiNhuan
from ChiTietHDBan cthdb
JOIN SanPham sp on cthdb.MasP = sp.MasP
JOIN HoaDonBan hdb on cthdb.MaHDBan = hdb.MaHDBan
where YEAR(hdb.NgayBan) = YEAR(GETdate()) AND MonTH(hdb.NgayBan) = MonTH(GETdate())
GROUP BY sp.MasP, sp.TenSP
ORDER BY TongLoiNhuan DESC;

--- store proucedure
go
-----------TimKiemSanPhamTheoTen-------------
create procedure sp_TimKiemSanPhamTheoTen (
    @TenSP nvarchar(255)
)
as
begin
    select *
    from SanPham
    where TenSP LIKE N'%' + @TenSP + N'%';
end
go

-----------sp_LayThongTinHoaDonBan-------------
create procedure sp_LayThongTinHoaDonBan (
    @MaHDBan int
)
as
begin
    select
        hdb.MaHDBan,
        nv.HoTen as TenNhanVien,
        kh.HoTen as TenKhachHang,
        hdb.NgayBan,
        ct.MasP,
        sp.TenSP,
        ct.SoLuong,
        ct.DonGia,
        ct.ThanhTien,
        hdb.TongTien,
        hdb.DiemSuDung
    from HoaDonBan hdb
    INNER JOIN NhanVien nv on hdb.MaNV = nv.MaNV
    INNER JOIN KhachHang kh on hdb.MaKH = kh.MaKH
    INNER JOIN ChiTietHDBan ct on hdb.MaHDBan = ct.MaHDBan
    INNER JOIN SanPham sp on ct.MasP = sp.MasP
    where hdb.MaHDBan = @MaHDBan;
end
go

-----------ThemNhanVien-------------
create procedure sp_ThemNhanVien (
    @HoTen nvarchar(255),
    @NgaySinh date,
    @GioiTinh nvarchar(10),
    @DiaChi nvarchar(255),
    @SDT varchar(20),
    @Email varchar(255),
    @ChucVu nvarchar(50),
    @NgayVaoLam date,
    @Luong DECIMAL(10, 2)
)
as
begin
    IF NOT EXISTS (select 1 from NhanVien where SDT = @SDT)
    begin
        IF @Email IS NULL OR NOT EXISTS (select 1 from NhanVien where Email = @Email)
        begin
            insert into NhanVien (HoTen, NgaySinh, GioiTinh, DiaChi, SDT, Email, ChucVu, NgayVaoLam, Luong)
            VALUES (@HoTen, @NgaySinh, @GioiTinh, @DiaChi, @SDT, @Email, @ChucVu, @NgayVaoLam, @Luong);
        end
        ELSE
        begin
            RAISERROR('Email đã tồn tại.', 16, 1);
            return;
        end
    end
    ELSE
    begin
        RAISERROR('Số điện thoại đã tồn tại.', 16, 1);
        return;
    end
end
go

-------------apdung khuyen cho san pham
create procedure sp_ApDungKhuyenMaiChoSanPham (
    @MaKM int,
    @DanhSachMasP varchar(MAX) -- Chuỗi các MasP cách nhau bởi dấu phẩy
)
as
begin
    -- Kiểm tra mã khuyến mãi có tồn tại
    IF NOT EXISTS (select 1 from KhuyenMai where MaKM = @MaKM)
    begin
        RAISERROR('Mã khuyến mãi không tồn tại.', 16, 1);
        return;
    end

    -- Tách chuỗi MasP thành các giá trị riêng lẻ
    DECLARE @MasPTach int;
    DECLARE @DanhSachMasPTach TABLE (MasP int);

    WHILE LEN(@DanhSachMasP) > 0
    begin
        IF CHARINDEX(',', @DanhSachMasP) > 0
        begin
            select @MasPTach = CasT(SUBSTRING(@DanhSachMasP, 1, CHARINDEX(',', @DanhSachMasP) - 1) as int);
            SET @DanhSachMasP = SUBSTRING(@DanhSachMasP, CHARINDEX(',', @DanhSachMasP) + 1, LEN(@DanhSachMasP));
        end
        ELSE
        begin
            select @MasPTach = CasT(@DanhSachMasP as int);
            SET @DanhSachMasP = '';
        end

        IF ISNUMERIC(@MasPTach) = 1 AND EXISTS (select 1 from SanPham where MasP = CasT(@MasPTach as int))
        begin
            IF NOT EXISTS (select 1 from ChiTietKhuyenMai where MaKM = @MaKM AND MasP = CasT(@MasPTach as int))
            begin
                insert into ChiTietKhuyenMai (MaKM, MasP)
                VALUES (@MaKM, CasT(@MasPTach as int));
            end
        end
        ELSE IF ISNUMERIC(@MasPTach) = 0 AND LEN(LTRIM(RTRIM(@MasPTach))) > 0
        begin
            RAISERROR('Mã sản phẩm không hợp lệ: %s', 16, 1, @MasPTach);
            return;
        end
        ELSE IF NOT EXISTS (select 1 from SanPham where MasP = CasT(@MasPTach as int)) AND ISNUMERIC(@MasPTach) = 1
        begin
            RAISERROR('Mã sản phẩm không tồn tại: %s', 16, 1, @MasPTach);
            return;
        end
    end
end;

go


------------ lấy theo san pham theo loai
create procedure sp_LaySanPhamTheoLoai (
    @MaLoaiSP int
)
as
begin
    IF EXISTS (select 1 from LoaiSanPham where MaLoaiSP = @MaLoaiSP)
    begin
        select sp.*
        from SanPham sp
        where sp.MaLoaiSP = @MaLoaiSP;
    end
    ELSE
    begin
        RAISERROR('Mã loại sản phẩm không tồn tại.', 16, 1);
        return;
    end
end
go


--- function

----------------------TinhTongTienHoaDonBan
create FUNCTIon fn_TinhTongTienHoaDonBan (@MaHDBan int)
returnS DECIMAL(10, 2)
as
begin
    DECLARE @TongTien DECIMAL(10, 2);

    select @TongTien = SUM(ThanhTien)
    from ChiTietHDBan
    where MaHDBan = @MaHDBan;

    return ISNULL(@TongTien, 0);
end
go

---------------LayTenNhanVien
create FUNCTIon fn_LayTenNhanVien (@MaNV int)
returnS nvarchar(255)
as
begin
    DECLARE @HoTen nvarchar(255);

    select @HoTen = HoTen
    from NhanVien
    where MaNV = @MaNV;

    return @HoTen;
end
go

--- trigger
----------------------CapNhatSoLuongTonKho_ChiTietHDNhap-------------
create trigger trg_CapNhatSoLuongTonKho_ChiTietHDNhap_Insert
on ChiTietHDNhap
AFTER INSERT
as
begin
    UPdate SanPham
    SET SoLuongTonKho = SoLuongTonKho + inserted.SoLuong
    from inserted
    where SanPham.MasP = inserted.MasP;
end
go


--------------------------NgayKetThucKhuyenMai
create trigger trg_NgayKetThucKhuyenMai
on KhuyenMai
AFTER INSERT, UPdate
as
begin
    IF EXISTS (select 1 from inserted where NgayKetThuc < NgayBatDau)
    begin
        RAISERROR('Ngày kết thúc khuyến mãi không được sớm hơn ngày bắt đầu.', 16, 1);
        ROLLBACK TRANSACTIon;
        return;
    end
end
go


------------------------CapNhatThanhTienChiTietHDBan
create trigger trg_CapNhatThanhTienChiTietHDBan_InsertUpdate
on ChiTietHDBan
AFTER INSERT, UPdate
as
begin
    UPdate ChiTietHDBan
    SET ThanhTien = inserted.SoLuong * inserted.DonGia
    from inserted
    where ChiTietHDBan.MaHDBan = inserted.MaHDBan AND ChiTietHDBan.MasP = inserted.MasP;
end
go

---------------------------------------------------------------end----------------------------------------
