use master
go
if exists (select * from sysdatabases where name = 'qlvattu')
	drop database qlvattu
go
drop login QLVT_TONGGIAMDOC
drop login QLVT_ADMIN
drop login QLVT_PGIAMDOC
drop login QLVT_GIAMDOC
drop login QLVT_QUANLY
drop login QLVT_NHANVIEN
go
create database qlvattu
go
use qlvattu
go
create table CHINHANH(
	MACN varchar(5) Primary Key,
	TENCN nvarchar(50) NOT NULL,
	DIADIEM nvarchar(50) NOT NULL CONSTRAINT chk_DiaDiem_HCM check (DIADIEM = N'TPHCM'),
	SODT nvarchar(50) NOT NULL 	
)
go
create table KHO(
	MAKHO varchar(5) Primary Key,
	TENKHO nvarchar(20) NOT NULL,
	DCKHO nvarchar(50),
	MACN varchar(5) foreign key references CHINHANH
)
go
create table VATTU(
	MAVT varchar(5) Primary Key,
	TENVT nvarchar(50) NOT NULL
)
go
create table NHANVIEN(
	MANV varchar(5) Primary Key,
	HOTENNV nvarchar(50) NOT NULL,
	NGAYSINH DateTime,
	GIOITINH bit, -- (0– Nam; 1- Nữ)
	DIACHI nvarchar(50),
	LOAINV nvarchar(50) CONSTRAINT chk_LoaiNV check (LOAINV = N'Bien che' or LOAINV = N'Khong bien che'),
	NGAYVAOLAM DateTime,
	LUONGCB Integer,
	GHICHU nvarchar(max),
	HINHANH image,
	MACN varchar(5) foreign key references CHINHANH,
)
go
create table KHACHHANG(
	MAKH varchar(5) Primary Key,
	HOTENKH nvarchar(50) NOT NULL,
	DIACHI nvarchar(50)
)
go
create table NHACUNGCAP(
	MANCC varchar(5) Primary Key,
	TENNCC nvarchar(50) NOT NULL,
	DIACHI nvarchar(50)
)
go
create table PHIEUNHAP(
	MAPN varchar(5) Primary Key,
	NGAYNHAP DateTime,
	MANCC varchar(5) foreign key references NHACUNGCAP,
	LYDO nvarchar(max),
	MAKHO varchar(5) foreign key references KHO,
	MAVT varchar(5) foreign key references VATTU,
	SOLUONG int CONSTRAINT ck_SoLuong_0 check (soluong > 0),
	DONGIA int CONSTRAINT ck_DonGia_0 check (dongia > 0),
	MANV varchar(5) foreign key references NHANVIEN
)
go
create table PHIEUXUAT(
	MAPX varchar(5) Primary Key,
	NGAYXUAT DateTime,
	MAKH varchar(5) foreign key references KHACHHANG,
	LYDO nvarchar(max),
	MAKHO varchar(5) foreign key references KHO,
	MAVT varchar(5) foreign key references VATTU,
	SOLUONG int,
	DONGIA int,
	MANV varchar(5) foreign key references NHANVIEN
)
go
create table PHIEUNHAP_Audit (
	MAPN varchar(5) Primary Key,
	NGAYNHAP DateTime,
	MANCC varchar(5) foreign key references NHACUNGCAP,
	LYDO nvarchar(max),
	MAKHO varchar(5) foreign key references KHO,
	MAVT varchar(5) foreign key references VATTU,
	SOLUONG int CONSTRAINT ck_SoLuong_audit_0 check (soluong > 0),
	DONGIA int CONSTRAINT ck_DonGia_audit_0 check (dongia > 0),
	MANV varchar(5) foreign key references NHANVIEN,
	Audit_Type char(6),
	Date_Time_Stamp datetime
)
go
create table PHIEUXUAT_Audit (
	MAPX varchar(5) Primary Key,
	NGAYXUAT DateTime,
	MAKH varchar(5) foreign key references KHACHHANG,
	LYDO nvarchar(max),
	MAKHO varchar(5) foreign key references KHO,
	MAVT varchar(5) foreign key references VATTU,
	SOLUONG int,
	DONGIA int,
	MANV varchar(5) foreign key references NHANVIEN,
	Audit_Type char(6),
	Date_Time_Stamp datetime
)
go
create table _USER (
	UserID varchar(10) primary key,
	_Password varchar(30), 
	MaNV varchar(5), 
	Quyen varchar(15)
)
go
create trigger them_PHIEUNHAP
	on PHIEUNHAP
	for insert
as
begin
	insert into PHIEUNHAP_Audit select *, 'Insert', GETDATE() from inserted
end
go
create trigger xoa_PHIEUNHAP
	on PHIEUNHAP
	for delete
as
begin
	insert into PHIEUNHAP_Audit	select *, 'Delete', GETDATE() from deleted
end
go
create trigger sua_PHIEUNHAP
	on PHIEUNHAP
	for update
as
begin
	insert into PHIEUNHAP_Audit select *, 'Update', getdate() from deleted
end
go
--
create trigger them_PHIEUXUAT
	on PHIEUXUAT
	for insert
as
begin
	insert into PHIEUXUAT_Audit select *, 'Insert', GETDATE() from inserted
end
go
create trigger xoa_PHIEUXUAT
	on PHIEUXUAT
	for delete
as
begin
	insert into PHIEUXUAT_Audit	select *, 'Delete', GETDATE() from deleted
end
go
create trigger sua_PHIEUXUAT
	on PHIEUXUAT
	for update
as
begin
	insert into PHIEUXUAT_Audit select *, 'Update', getdate() from deleted
end
go