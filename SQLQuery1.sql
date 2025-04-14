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
(N'Mai Thị K', '1992-08-12', N'Nữ', N'Hà Nam', '0977654321', 'k.mai@email.com', N'Thực tập sinh', '2025-01-05', 5000000);

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