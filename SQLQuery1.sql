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