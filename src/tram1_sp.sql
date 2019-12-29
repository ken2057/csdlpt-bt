--------------------------------------------------------------------
-- SP
--------------------------------------------------------------------
use qlvattu
-- TABLE CHINHANH
go
-- insert
create proc sp_Them_ChiNhanh
	@MaCN varchar(5),
	@TenCN nvarchar(50),
	@SoDT nvarchar(50)
as
begin
	-- kiểm tra mã chi nhánh đã tồn tại chưa.
	if exists (select * from ChiNhanh where MACN = @MaCN)
	begin
		raiserror('Mã chi nhánh đã tồn tại', 16, 1)
		return
	end
	-- da insert vao tram_1 hoac tram_2 => insert vao may_chu
	set xact_abort on
	begin distributed tran
		insert into ChiNhanh values (@MaCN, @TenCN, 'TPHCM', @SoDT)
		insert into QLVT_LINKED_SERVER.qlvattu.dbo.ChiNhanh values (@MaCN, @TenCN, 'TPHCM', @SoDT)
	commit tran
end
go
-- delete
create proc sp_Xoa_ChiNhanh
	@MaCN varchar(5)
as
begin
	if not exists (select * from ChiNhanh where MACN = @MaCN)
	begin
		raiserror('Mã chi nhánh không tồn tại', 16, 1)
		return
	end
	-- đã delete trong trạm 1 hoặc 2 => delete ở MAY_CHU
	set xact_abort on
	begin distributed tran
		delete QLVT_LINKED_SERVER.qlvattu.dbo.ChiNhanh where MACN = @MaCN
		delete ChiNhanh where MACN = @MaCN
	commit tran
end
-- update
go
create proc sp_Sua_ChiNhanh
	@MaCN varchar(5),
	@TenCN nvarchar(50),
	@SoDT nvarchar(50)
as
begin
	set xact_abort on
	begin distributed tran
		update ChiNhanh set TenCN = @TenCN, SoDT = @SoDT where MaCN = @MaCN
		update QLVT_LINKED_SERVER.qlvattu.dbo.ChiNhanh set TenCN = @TenCN, SoDT = @SoDT where MaCN = @MaCN
	commit tran
end
go
--insert
create proc sp_Them_Kho
	@TenKho nvarchar(20),
	@DcKho nvarchar(50),
	@MaCN varchar(5)
as
begin
	declare @MaKho varchar(5)
	select @MaKho = 'CN1' + count(MaKho) from Kho
	set xact_abort on
	begin distributed tran
		insert Kho values (@MaKho, @TenKho, @DcKho, @MaCN)
		insert QLVT_LINKED_SERVER.qlvattu.dbo.ChiNhanh values (@MaKho, @TenKho, @DcKho, @MaCN)
	commit tran
end
-- delete
go
create proc sp_Xoa_Kho
	@MaKho varchar(5)
as
begin
	if not exists (select * from Kho where MaKho = @MaKho)
	begin
		raiserror('Mã kho không tồn tại', 16, 1)
		return
	end
	-- đã delete trong trạm 1 hoặc 2 => delete ở MAY_CHU
	set xact_abort on
	begin distributed tran
		delete Kho where MaKho = @MaKho
		delete QLVT_LINKED_SERVER.qlvattu.dbo.Kho where MaKho = @MaKho
	commit tran
end
go
-- update
create proc sp_Sua_Kho
	@MaKho varchar(5),
	@TenKho nvarchar(20),
	@DcKho nvarchar(50)
as
begin	
	set xact_abort on
	begin distributed tran
		update kho set TenKho = @TenKho, DcKho = @DcKho where MaKho = @MaKho
		update QLVT_LINKED_SERVER.qlvattu.dbo.kho set TenKho = @TenKho, DcKho = @DcKho where MaKho = @MaKho
	commit tran
end
-- TABLE VATTU
-- insert
go
create proc sp_Them_VatTu
	@TenVT nvarchar(50),
	@QuiCach nvarchar(20),
	@DVTinh nvarchar(20)
as
begin
	declare @MaVT varchar(5)
	select @MaVT = 'VT' + count(*) from VatTu
	set xact_abort on
	begin distributed tran
		insert into QLVT_LINKED_SERVER.qlvattu.dbo.VatTu values (@MaVT, @TenVT, @QuiCach, @DVTinh)
		insert into VatTu values (@MaVT, @TenVT)
		insert into QLVT_TRAM_2.qlvattu.dbo.VatTu values (@MaVT, @QuiCach, @DVTinh)
	commit tran
end
-- delete
go
create proc sp_Xoa_VatTu
	@MaVT varchar(5)
as
begin
	-- kiểm tra mã vật tư không tồn tại
	if not exists (select MAVT from VATTU where MAVT = @MaVT)
	begin
		raiserror('Mã vật tư không tồn tại', 16, 1)
		return
	end
	-- delete
	set xact_abort on
	begin distributed tran
		delete QLVT_LINKED_SERVER.qlvattu.dbo.VatTu where MAVT = @MaVT
		delete VatTu where MAVT = @MaVT
		delete QLVT_TRAM_2.qlvattu.dbo.VatTu where MAVT = @MaVT
	commit tran
end
-- update
go
create proc sp_Sua_VatTu
	@MaVT varchar(5),
	@TenVT nvarchar(50),
	@QuiCach nvarchar(20),
	@DVTinh nvarchar(20)
as
begin
	-- kiểm tra mã vật tư không tồn tại
	if not exists (select MAVT from VatTu where MAVT = @MaVT)
	begin
		raiserror('Mã vật tư không tồn tại', 16, 1)
		return
	end
	-- update
	set xact_abort on
	begin distributed tran
		update QLVT_LINKED_SERVER.qlvattu.dbo.VatTu
		set TENVT = @TenVT, QUICACH = @QuiCach, DVTINH = @DVTinh
		where MAVT = @MaVT

		update VatTu
		set TENVT = @TenVT
		where MAVT = @MaVT

		update QLVT_TRAM_2.qlvattu.dbo.VatTu
		set QUICACH = @QuiCach, DVTINH = @DVTinh
		where MAVT = @MaVT
	commit tran
end	
-- TABLE NHANVIEN
-- insert
go
create proc sp_Them_NhanVien
	@manv varchar(5),
	@HOTENNV nvarchar(50), 
	@NGAYSINH DateTime,
	@GIOITINH bit, --(0– Nam; 1- Nữ)
	@DIACHI nvarchar(50),
	@LOAINV nvarchar(50), --Biên chế/không biên chế
	@NGAYVAOLAM DateTime,
	@LUONGCB Integer,
	@GHICHU nvarchar(max),
	@HINHANH image,
	@MACN varchar(5) 
as
begin
	set xact_abort on
	begin distributed tran
		insert into NHANVIEN values (@MANV, @HOTENNV, @NGAYSINH, @GIOITINH, @DIACHI, @LOAINV, @NGAYVAOLAM, @LUONGCB, @GHICHU, @HINHANH, @MACN)
		insert into QLVT_LINKED_SERVER.qlvattu.dbo.NhanVien
		values (@MANV, @HOTENNV, @NGAYSINH, @GIOITINH, @DIACHI, @LOAINV, @NGAYVAOLAM, @LUONGCB, @GHICHU, @HINHANH, @MACN)
	commit tran
end
go
-- delete
create proc sp_Xoa_NhanVien
	@MANV varchar(5)
as
begin
	set xact_abort on
	begin distributed tran
		delete NhanVien where MANV = @MANV
		delete QLVT_LINKED_SERVER.qlvattu.dbo.NhanVien where MANV = @MANV
	commit tran
end
-- update
go
create proc sp_Sua_NhanVien
	@MANV varchar(5),
	@HOTENNV nvarchar(50)
as
begin
	set xact_abort on
	begin distributed tran
		update NhanVien set HOTENNV = @HOTENNV where manv = @manv
		update QLVT_LINKED_SERVER.qlvattu.dbo.NhanVien set HOTENNV = @HOTENNV where manv = @manv
	commit tran
end
-- table KHACHHANG
-- insert
go
create proc sp_Them_KhachHang
	@MAKH varchar(5),
	@HOTENKH nvarchar(50),
	@DIACHI nvarchar(50),
	@DIENTHOAI text,
	@FAX text
as
begin
	-- insert
	set xact_abort on
	begin distributed tran
		insert into QLVT_LINKED_SERVER.qlvattu.dbo.KhachHang values (@MAKH, @HOTENKH, @DIACHI, @DIENTHOAI, @FAX)
		insert into KhachHang values (@MAKH, @HOTENKH, @DIACHI)
		insert into QLVT_TRAM_2.qlvattu.dbo.KhachHang values (@MAKH, @DIENTHOAI, @FAX)
	commit tran
end
go
-- delete
create proc sp_Xoa_KhachHang
	@MAKH varchar(5)
as
begin
-- kiểm tra mã khách hàng
	if not exists (select MAKH from KhachHang where MAKH = @MAKH)
	begin
		raiserror('Mã khách hàng không tồn tại', 16, 1)
		return
	end
	-- delete
	set xact_abort on
	begin distributed tran
		delete QLVT_LINKED_SERVER.qlvattu.dbo.KhachHang where MAKH = @MAKH
		delete KhachHang where MAKH = @MAKH
		delete QLVT_TRAM_2.qlvattu.dbo.KhachHang where MAKH = @MAKH
	commit tran
end
go
-- update
create proc sp_Sua_KhachHang
	@MAKH varchar(5),
	@HOTENKH nvarchar(50),
	@DIACHI nvarchar(50),
	@DIENTHOAI text,
	@FAX text
as
begin
	-- kiểm tra mã khách hàng
	if not exists (select MAKH from KhachHang where MAKH = @MAKH)
	begin
		raiserror('Mã khách hàng không tồn tại', 16, 1)
		return
	end
	-- update
	set xact_abort on
	begin distributed tran
		update QLVT_LINKED_SERVER.qlvattu.dbo.KhachHang
		set HOTENKH = @HOTENKH, DIACHI = @DIACHI, DIENTHOAI = @DIENTHOAI, FAX = @FAX
		where MAKH = @MAKH

		update KhachHang
		set HOTENKH = @HOTENKH, DIACHI = @DIACHI
		where MAKH = @MAKH

		update QLVT_TRAM_2.qlvattu.dbo.KhachHang
		set DIENTHOAI = @DIENTHOAI, FAX = @FAX
		where MAKH = @MAKH
	commit tran
end
--talbe NHACUNGCAP
-- insert
go
create proc sp_Them_NhaCungCap
	@MANCC varchar(5),
	@TENNCC nvarchar(50),
	@DIACHI nvarchar(50),
	@DIENTHOAI text,
	@FAX text
as
begin
	-- kiểm tra mã nhà cung cấp
	if exists (select MANCC from NHACUNGCAP where MANCC = @MANCC)
	begin
		raiserror('Mã nhà cung cấp đã tồn tại', 16, 1)
		return
	end
	-- insert
	set xact_abort on
	begin distributed tran
		insert into QLVT_LINKED_SERVER.qlvattu.dbo.NHACUNGCAP values (@MANCC, @TENNCC, @DIACHI, @DIENTHOAI, @FAX)
		insert into NHACUNGCAP values (@MANCC, @TENNCC, @DIACHI)
		insert into QLVT_TRAM_2.qlvattu.dbo.NHACUNGCAP values (@MANCC, @DIENTHOAI, @FAX)
	commit tran
end
go
-- delete
create proc sp_Xoa_NhaCungCap
	@MANCC varchar(5)
as
begin
	-- kiểm tra mã nhà cung cấp
	if not exists (select MANCC from NHACUNGCAP where MANCC = @MANCC)
	begin
		raiserror('Mã nhà cung cấp không tồn tại', 16, 1)
		return
	end
	-- delete
	set xact_abort on
	begin distributed tran
		delete QLVT_LINKED_SERVER.qlvattu.dbo.NHACUNGCAP where MANCC = @MANCC
		delete NHACUNGCAP where MANCC = @MANCC
		delete QLVT_TRAM_2.qlvattu.dbo.NHACUNGCAP where MANCC = @MANCC
	commit tran
end
go
-- update
create proc sp_Sua_NhaCungCap
	@MANCC varchar(5),
	@TENNCC nvarchar(50),
	@DIACHI nvarchar(50),
	@DIENTHOAI text,
	@FAX text
as
begin
	-- kiểm tra mã nhà cung cấp
	if not exists (select MANCC from NHACUNGCAP where MANCC = @MANCC)
	begin
		raiserror('Mã nhà cung cấp không tồn tại', 16, 1)
		return
	end
	-- insert
	set xact_abort on
	begin distributed tran
		update QLVT_LINKED_SERVER.qlvattu.dbo.NHACUNGCAP
		set TENNCC = @TENNCC, DIACHI = @DIACHI, DIENTHOAI = @DIENTHOAI, FAX = @FAX
		where MANCC = @MANCC

		update NHACUNGCAP
		set TENNCC = @TENNCC, DIACHI = @DIACHI
		where MANCC = @MANCC

		update QLVT_TRAM_2.qlvattu.dbo.NHACUNGCAP
		set DIENTHOAI = @DIENTHOAI, FAX = @FAX
		where MANCC = @MANCC
	commit tran
end
go
-- table PHIEUNHAP
-- insert
create proc sp_Them_PhieuNhap
	@MAPN varchar(5),
	@NGAYNHAP DateTime,
	@MANCC varchar(5),
	@LYDO nvarchar(max),
	@MAKHO varchar(5),
	@MAVT varchar(5),
	@SOLUONG int,
	@DONGIA int,
	@MANV varchar(5)
as
begin
	-- kiểm tra mã phiếu nhập
	if exists (select MAPN from PHIEUNHAP where MAPN = @MAPN)
	begin
		raiserror('Mã phiếu nhập đã tồn tại', 16, 1)
		return
	end
	-- kiểm tra mã nhà cung cấp
	if not exists (select MANCC from NHACUNGCAP where MANCC = @MANCC)
	begin
		raiserror('Mã nhà cung cấp không tồn tại', 16, 1)
		return
	end
	-- kiểm tra mã kho
	if not exists (select MAKHO from Kho where MAKHO = @MAKHO)
	begin
		raiserror('Mã kho không không tại', 16, 1)
		return
	end
	-- kiểm tra mã vật tư
	if not exists (select MAVT from VatTu where MAVT = @MAVT)
	begin
		raiserror('Mã vật tư không tồn tại', 16, 1)
		return
	end
	-- kiểm tra mã nhân viên
	if not exists (select MANV from NhanVien where MANV = @MANV)
	begin
		raiserror('Mã nhân viên không tồn tại', 16, 1)
		return
	end
	-- insert
	set xact_abort on
	begin distributed tran
		insert into QLVT_LINKED_SERVER.qlvattu.dbo.PHIEUNHAP
		values (@MAPN, @NGAYNHAP, @MANCC, @LYDO, @MAKHO, @MAVT, @SOLUONG, @DONGIA, @MANV)
		insert into PHIEUNHAP values (@MAPN, @NGAYNHAP, @MANCC, @LYDO, @MAKHO, @MAVT, @SOLUONG, @DONGIA, @MANV)
	commit tran
end
go
-- delete
create proc sp_Xoa_PhieuNhap
	@MAPN varchar(5)
as
begin
	-- kiểm tra mã nhà phiếu nhâp
	if not exists (select MAPN from PHIEUNHAP where MAPN = @MAPN)
	begin
		raiserror('Mã phiếu nhâp không tồn tại', 16, 1)
		return
	end
	-- delete
	set xact_abort on
	begin distributed tran
		delete QLVT_LINKED_SERVER.qlvattu.dbo.PHIEUNHAP where MAPN = @MAPN
		delete PHIEUNHAP where MAPN = @MAPN
	commit tran
end
go
-- update
create proc sp_Sua_PhieuNhap
	@MAPN varchar(5),
	@LYDO nvarchar(max)
as
begin
	-- kiểm tra mã phiếu nhập
	if not exists (select MAPN from PHIEUNHAP where MAPN = @MAPN)
	begin
		raiserror('Mã phiếu nhập không tồn tại', 16, 1)
		return
	end
	-- update
	set xact_abort on
	begin distributed tran
		update PHIEUNHAP set LYDO = @LYDO where MAPN = @MAPN
		update QLVT_LINKED_SERVER.qlvattu.dbo.PHIEUNHAP set LYDO = @LYDO where MAPN = @MAPN
	commit tran
end
go
-- table PHIEUXUAT
-- insert
create proc sp_Them_phieuxuat
	@MAPX varchar(5),
	@NGAYXUAT DateTime,
	@MAKH varchar(5),
	@LYDO nvarchar(max),
	@MAKHO varchar(5),
	@MAVT varchar(5),
	@SOLUONG int,
	@DONGIA int,
	@MANV varchar(5)
as
begin
	-- kiểm tra mã phiếu nhập
	if exists (select MAPX from phieuxuat where MAPX = @MAPX)
	begin
		raiserror('Mã phiếu nhập đã tồn tại', 16, 1)
		return
	end
	-- kiểm tra mã khách hàng
	if not exists (select MAKH from KhachHang where MAKH = @MAKH)
	begin
		raiserror('Mã nhà cung cấp không tồn tại', 16, 1)
		return
	end
	-- kiểm tra mã kho
	if not exists (select MAKHO from Kho where MAKHO = @MAKHO)
	begin
		raiserror('Mã kho không không tại', 16, 1)
		return
	end
	-- kiểm tra mã vật tư
	if not exists (select MAVT from VatTu where MAVT = @MAVT)
	begin
		raiserror('Mã vật tư không tồn tại', 16, 1)
		return
	end
	-- kiểm tra mã nhân viên
	if not exists (select MANV from NhanVien where MANV = @MANV)
	begin
		raiserror('Mã nhân viên không tồn tại', 16, 1)
		return
	end
	-- insert
	set xact_abort on
	begin distributed tran
		insert into QLVT_LINKED_SERVER.qlvattu.dbo.PHIEUXUAT values (@MAPX,@NGAYXUAT, @MAKH, @LYDO, @MAKHO, @MAVT, @SOLUONG, @DONGIA, @MANV)
		insert into phieuxuat values (@MAPX, @NGAYXUAT, @MAKH, @LYDO, @MAKHO, @MAVT, @SOLUONG, @DONGIA, @MANV)
	commit tran
end
go
-- delete
create proc sp_Xoa_MAPX
	@mapx varchar(5)
as
begin
	-- kiểm tra mã nhà phiếu nhâp
	if not exists (select mapx from phieuxuat where mapx = @mapx)
	begin
		raiserror('Mã phiếu nhâp không tồn tại', 16, 1)
		return
	end
	-- delete
	set xact_abort on
	begin distributed tran
		delete QLVT_LINKED_SERVER.qlvattu.dbo.phieuxuat where mapx = @mapx
		delete phieuxuat where mapx = @mapx
	commit tran
end
go
-- update
create proc sp_Sua_MAPX
	@mapx varchar(5),
	@LYDO nvarchar(max)
as
begin
	-- kiểm tra mã phiếu nhập
	if not exists (select mapx from phieuxuat where mapx = @mapx)
	begin
		raiserror('Mã phiếu nhập không tồn tại', 16, 1)
		return
	end
	-- update
	set xact_abort on
	begin distributed tran
		update phieuxuat set LYDO = @LYDO where mapx = @mapx
		update QLVT_LINKED_SERVER.qlvattu.dbo.phieuxuat set LYDO = @LYDO where mapx = @mapx
	commit tran
end
go
create proc sp_get_kho
as
begin
	select * from kho
end
go
create proc sp_get_chinhanh
as
begin
	select * from ChiNhanh
end
go
create proc sp_get_nhanvien
as
begin
	select * from nhanvien
end
go
create proc sp_get_khachhang
as
begin
	select T1.makh, HOTENKH, DIACHI, DIENTHOAI, FAX
	from
		(select * from QLVT_TRAM_2.qlvattu.dbo.KhachHang) T2
		join (select * from KhachHang) T1
		on T1.MAKH = T2.MAKH
end
go
create proc sp_get_vattu
as
begin
	select T1.MaVT, tenvt, QuiCach, DVTinh
	from
		(select * from QLVT_TRAM_2.qlvattu.dbo.VATTU) T2
		join (select * from VATTU) T1
		on T1.MaVT = T2.MaVT
end
go
create proc sp_get_nhacungcap
as
begin
	select T1.mancc, Tenncc, DIACHI, DIENTHOAI, FAX
	from
		(select * from QLVT_TRAM_2.qlvattu.dbo.nhacungcap) T2
		join (select * from nhacungcap) T1
		on T1.MANCC = T2.MANCC
end
go
create proc sp_get_phieunhap
as
begin
	select * from phieunhap
end
go
create proc sp_get_phieuxuat
as
begin
	select * from phieuxuat
end
go
create proc sp_get_phieuxuat_theoNV
	@maNV varchar(5)
as
begin
	select * from phieuxuat where maNV like '%'+@maNV+'%'
end
go
create proc sp_get_phieunhap_theoNCC
	@MANCC varchar(5)
as
begin
	select * from phieunhap where mancc like '%'+@MANCC+'%'
end
go