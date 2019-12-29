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
	@DiaDiem nvarchar(50),
	@SoDT nvarchar(50)
as
begin
	-- kiểm tra mã chi nhánh đã tồn tại chưa
	if exists (select * from ChiNhanh where MACN = @MaCN)
	begin
		raiserror('Mã chi nhánh đã tồn tại', 16, 1)
		return
	end
	if @DiaDiem = 'TPHCM'
		insert into QLVT_TRAM_1.qlvattu.dbo.ChiNhanh
		values (@MaCN, @TenCN, @DiaDiem, @SoDT)
	else if @DiaDiem = 'Hà Nội'
		insert into QLVT_TRAM_2.qlvattu.dbo.ChiNhanh
		values (@MaCN, @TenCN, @DiaDiem, @SoDT)
	else
	begin
		raiserror('Thành phố không hợp lệ', 16, 1)
		return
	end
	-- da insert vao tram_1 hoac tram_2 => insert vao may_chu
	insert into CHINHANH
	values (@MaCN, @TenCN, @DiaDiem, @SoDT)
end
go
-- delete
create proc sp_Xoa_ChiNhanh
	@MaCN varchar(5)
as
begin
	if exists (select * from QLVT_TRAM_1.qlvattu.dbo.ChiNhanh where MACN = @MaCN)
		delete from QLVT_TRAM_1.qlvattu.dbo.ChiNhanh where MACN = @MaCN
	else if exists (select * from QLVT_TRAM_2.qlvattu.dbo.ChiNhanh where MACN = @MaCN)
		delete from QLVT_TRAM_2.qlvattu.dbo.ChiNhanh where MACN = @MaCN
	else
	begin
		raiserror('Mã chi nhánh không tồn tại', 16, 1)
		return 1
	end
	-- đã delete trong trạm 1 hoặc 2 => delete ở MAY_CHU
	delete from CHINHANH
	where MACN = @MaCN
end
-- update
go
create proc sp_Sua_ChiNhanh
	@MaCN varchar(5),
	@TenCN nvarchar(50),
	@DiaDiem nvarchar(50),
	@SoDT nvarchar(50)
as
begin
	-- lấy thông tin hiện tại của chi nhánh 
	select MACN, DIADIEM
	into #ThongTinChiNhanh
	from CHINHANH	
	where MACN = @MaCN
	-- kiểm tra có tồn tại chi nhánh không
	if not exists (select * from #ThongTinChiNhanh)
	begin
		raiserror('Chi nhánh không tồn tại', 16, 1)
		return 1
	end
	else
	begin
		-- trạm 1 update, DiaDiem không thay đổi
		if (select DiaDiem from #ThongTinChiNhanh) = 'TPHCM' and @DiaDiem = 'TPHCM'
			update QLVT_TRAM_1.qlvattu.dbo.ChiNhanh 
			set TenCN = @TenCN, DiaDiem = @DiaDiem, SoDT = @SoDT
			where MACN = @MaCN
		-- trạm 1 update, DiaDiem thay đổi
		else if (select DiaDiem from #ThongTinChiNhanh) = 'TPHCM' and @DiaDiem = 'Hà Nội'
		begin
			-- xóa ở TRAM_1
			delete from QLVT_TRAM_1.qlvattu.dbo.ChiNhanh where MACN = @MaCN
			-- thêm ở TRAM_2
			insert into QLVT_TRAM_2.qlvattu.dbo.ChiNhanh values (@MaCN, @TenCN, @DiaDiem, @SoDT)
		end
		-- trạm 2 update, DiaDiem không thay đổi
		else if (select DiaDiem from #ThongTinChiNhanh) = 'Hà Nội' and @DiaDiem = 'Hà Nội'
			update QLVT_TRAM_1.qlvattu.dbo.ChiNhanh 
			set TenCN = @TenCN, DiaDiem = @DiaDiem, SoDT = @SoDT
			where MACN = @MaCN
		else if (select DiaDiem from #ThongTinChiNhanh) = 'Hà Nội' and @DiaDiem = 'TPHCM'
		begin
			-- xóa ở TRAM_1
			delete from QLVT_TRAM_2.qlvattu.dbo.ChiNhanh where MACN = @MaCN		
			-- thêm ở TRAM_2
			insert into QLVT_TRAM_1.qlvattu.dbo.ChiNhanh values (@MaCN, @TenCN, @DiaDiem, @SoDT)
		end
		else
		begin
			raiserror('Thành phố không hợp lệ', 16, 1)
			return 2
		end
		-- update trong bảng chi nhánh ở TRAM_1 hoặc TRAM_2
		update ChiNhanh
		set TenCN = @TenCN, DiaDiem = @DiaDiem, SoDT = @SoDT
		where MaCN = @MaCN
	end
end
go
-- TABLE Kho
--insert
create proc sp_Them_Kho
	@MaKho varchar(5),
	@TenKho nvarchar(20),
	@DcKho nvarchar(50),
	@MaCN varchar(5)
as
begin
	-- Lấy thông tin chi nhánh
	select DIADIEM
	into #ThongTinChiNhanh
	from CHINHANH 
	where MACN = @MaCN
	-- kiểm tra chi nhánh tồn tại
	if exists (select * from #ThongTinChiNhanh)
	begin
		raiserror('Mã chi nhánh tồn tại', 16, 1)
		return
	end
	-- kiểm tra mã kho tồn tại
	if exists (select makho from kho where MAKHO = @MaKho)
	begin
		raiserror('Kho đã tồn tại', 16, 1)
		return
	end
	-- insert
	insert into KHO values(@MaKho, @TenKho, @DcKho, @MaCN)
	if (select Diadiem from #ThongTinChiNhanh) = 'TPHCM'
		-- trạm 1
		insert into QLVT_TRAM_1.qlvattu.dbo.Kho values(@MaKho, @TenKho, @DcKho, @MaCN)
	else
		-- trạm 2
		insert into QLVT_TRAM_2.qlvattu.dbo.Kho values(@MaKho, @TenKho, @DcKho, @MaCN)
end
-- delete
go
create proc sp_Xoa_Kho
	@MaKho varchar(5)
as
begin
	if not exists (select MaKho from Kho where MaKho = @MaKho)
	begin
		raiserror('Kho không tồn tại', 16, 1)
		return
	end
	-- Xóa 
	delete from kho where MAKHO = @MaKho
	if exists (select MAKHO from QLVT_TRAM_1.qlvattu.dbo.Kho where MAKHO = @MaKho)
		-- trạm 1
		delete from QLVT_TRAM_1.qlvattu.dbo.Kho where MAKHO = @MaKho
	else if exists (select MAKHO from QLVT_TRAM_2.qlvattu.dbo.Kho where MAKHO = @MaKho)
		-- trạm 2
		delete from QLVT_TRAM_2.qlvattu.dbo.Kho where MAKHO = @MaKho
end
go
-- update
create proc sp_Sua_Kho
	@MaKho varchar(5),
	@DcKho nvarchar(50)
as
begin
	-- Kiểm tra thông tin kho tồn tại
	if not exists (select MaKho from Kho where MaKho = @MaKho)
	begin
		raiserror('Kho không tồn tại', 16, 1)
		return
	end
	-- update
		-- cập nhật lại ở MAY_CHU
	update KHO
	set TENKHO = @TenKho, DCKHO = @DcKho, MACN = @MaCN
	where MAKHO = @MaKho
		-- tram 1
	if exists (select MaKho from QLVT_TRAM_1.qlvattu.dbo.Kho where MaKho = @MaKho)
		update QLVT_TRAM_1.qlvattu.dbo.Kho
		set DCKHO = @DcKho
		where MAKHO = @MaKho
	else if exists (select MaKho from QLVT_TRAM_2.qlvattu.dbo.Kho where MaKho = @MaKho)
	begin
		update QLVT_TRAM_2.qlvattu.dbo.Kho
		set DCKHO = @DcKho
		where MAKHO = @MaKho
	end
end
-- TABLE VATTU
-- insert
go
create proc sp_Them_VatTu
	@MaVT varchar(5),
	@TenVT nvarchar(50),
	@QuiCach nvarchar(20),
	@DVTinh nvarchar(20)
as
begin
	-- kiểm tra mã vật tư tồn tại
	if exists (select MAVT from VATTU where MAVT = @MaVT)
	begin
		raiserror('Mã vật tư đã tồn tại', 16, 1)
		return
	end
	-- insert
	insert into VATTU values (@MaVT, @TenVT, @QuiCach, @DVTinh)
	insert into QLVT_TRAM_1.qlvattu.dbo.VatTu values (@MaVT, @TenVT)
	insert into QLVT_TRAM_2.qlvattu.dbo.VatTu values (@MaVT, @QuiCach, @DVTinh)
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
	delete VATTU where MAVT = @MaVT
	delete QLVT_TRAM_1.qlvattu.dbo.VatTu where MAVT = @MaVT
	delete QLVT_TRAM_2.qlvattu.dbo.VatTu where MAVT = @MaVT
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
	if not exists (select MAVT from VATTU where MAVT = @MaVT)
	begin
		raiserror('Mã vật tư không tồn tại', 16, 1)
		return
	end
	-- update
	-- may chu
	update VATTU
	set TENVT = @TenVT, QUICACH = @QuiCach, DVTINH = @DVTinh
	where MAVT = @MaVT
	-- tram 1
	update QLVT_TRAM_1.qlvattu.dbo.VatTu
	set TENVT = @TenVT
	where MAVT = @MaVT
	-- tram 2
	update QLVT_TRAM_2.qlvattu.dbo.VatTu
	set QUICACH = @QuiCach, DVTINH = @DVTinh
	where MAVT = @MaVT
end	
-- TABLE NHANVIEN
-- insert
go
create proc sp_Them_NhanVien
	@MANV varchar(5),
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
	-- kiểm tra mã nhân viên
	if exists (select manv from NHANVIEN where MANV = @MANV)
	begin
		raiserror('Mã nhân viên đã tồn tại', 16, 1)
		return
	end
	-- kiểm tra chi địa chỉ chi nhánh hợp lệ
	if @DiaDiemCN = NULL
	begin
		raiserror('Chi nhánh không tồn tại', 16, 1)
		return
	end
	-- start
	-- may chu
	insert into NHANVIEN values (@MANV, @HOTENNV, @NGAYSINH, @GIOITINH, @DIACHI, @LOAINV, @NGAYVAOLAM, @LUONGCB, @GHICHU, @HINHANH, @MACN)
	if @DiaDiemCN = 'TPHCM'
		-- insert vào TRAM_1
		insert into QLVT_TRAM_1.qlvattu.dbo.NhanVien
		values (@MANV, @HOTENNV, @NGAYSINH, @GIOITINH, @DIACHI, @LOAINV, @NGAYVAOLAM, @LUONGCB, @GHICHU, @HINHANH, @MACN)
	else
		-- insert vào TRAM_2
		insert into QLVT_TRAM_2.qlvattu.dbo.NhanVien
		values (@MANV, @HOTENNV, @NGAYSINH, @GIOITINH, @DIACHI, @LOAINV, @NGAYVAOLAM, @LUONGCB, @GHICHU, @HINHANH, @MACN)
	
end
go
-- delete
create proc sp_Xoa_NhanVien
	@MANV varchar(5)
as
begin
	-- kiểm tra mã nhân viên
	if not exists (select manv from NHANVIEN where MANV = @MANV)
	begin
		raiserror('Mã nhân viên không tồn tại', 16, 1)
		return
	end
	-- may chu
	delete NhanVien where MANV = @MANV
	-- delete ở TRAM_1
	if exists (select manv from QLVT_TRAM_1.qlvattu.dbo.NhanVien where MANV = @MANV)
		delete QLVT_TRAM_1.qlvattu.dbo.NhanVien where MANV = @MANV
	-- delete ở TRAM_2
	else if exists (select manv from QLVT_TRAM_2.qlvattu.dbo.NhanVien where MANV = @MANV)
		delete QLVT_TRAM_2.qlvattu.dbo.NhanVien where MANV = @MANV
end
-- update
go
create proc sp_Sua_NhanVien
	@MANV varchar(5),
	@DIACHI nvarchar(50)
as
begin
	-- kiểm tra mã nhân viên
	if not exists (select manv from NHANVIEN where MANV = @MANV)
	begin
		raiserror('Mã nhân viên không tồn tại', 16, 1)
		return
	end
	-- update
	update NHANVIEN 
	set DIACHI = @DIACHI
	where MANV = @MANV
	-- trạm 1
	if exists (select MANV from QLVT_TRAM_1.qlvattu.dbo.NhanVien where MANV =@MANV)
		update QLVT_TRAM_1.qlvattu.dbo.NhanVien
		set DIACHI = @DIACHI
		where MANV = @MANV
	-- tram 2 
	else if exists (select MANV from QLVT_TRAM_2.qlvattu.dbo.NhanVien where MANV =@MANV)
		update QLVT_TRAM_2.qlvattu.dbo.NhanVien
		set DIACHI = @DIACHI
		where MANV = @MANV 
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
	-- kiểm tra mã khách hàng
	if exists (select MAKH from KHACHHANG where MAKH = @MAKH)
	begin
		raiserror('Mã khách hàng đã tồn tại', 16, 1)
		return
	end
	-- insert
	insert into KHACHHANG values (@MAKH, @HOTENKH, @DIACHI, @DIENTHOAI, @FAX)
	insert into QLVT_TRAM_1.qlvattu.dbo.KhachHang values (@MAKH, @HOTENKH, @DIACHI)
	insert into QLVT_TRAM_2.qlvattu.dbo.KhachHang values (@MAKH, @DIENTHOAI, @FAX)
end
go
-- delete
create proc sp_Xoa_KhachHang
	@MAKH varchar(5)
as
begin
	-- kiểm tra mã khách hàng
	if not exists (select MAKH from KHACHHANG where MAKH = @MAKH)
	begin
		raiserror('Mã khách hàng không tồn tại', 16, 1)
		return
	end
	-- delete
	delete KHACHHANG where MAKH = @MAKH
	delete QLVT_TRAM_1.qlvattu.dbo.KhachHang where MAKH = @MAKH
	delete QLVT_TRAM_2.qlvattu.dbo.KhachHang where MAKH = @MAKH
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
	if not exists (select MAKH from KHACHHANG where MAKH = @MAKH)
	begin
		raiserror('Mã khách hàng không tồn tại', 16, 1)
		return
	end
	-- insert
	-- may chu
	update KHACHHANG 
	set HOTENKH = @HOTENKH, DIACHI = @DIACHI, DIENTHOAI = @DIENTHOAI, FAX = @FAX
	where MAKH = @MAKH
	-- tram 1
	update QLVT_TRAM_1.qlvattu.dbo.KhachHang
	set HOTENKH = @HOTENKH, DIACHI = @DIACHI
	where MAKH = @MAKH
	-- tram 2
	update QLVT_TRAM_2.qlvattu.dbo.KhachHang
	set DIENTHOAI = @DIENTHOAI, FAX = @FAX
	where MAKH = @MAKH
	
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
	insert into NHACUNGCAP values (@MANCC, @TENNCC, @DIACHI, @DIENTHOAI, @FAX)
	insert into QLVT_TRAM_1.qlvattu.dbo.NHACUNGCAP values (@MANCC, @TENNCC, @DIACHI)
	insert into QLVT_TRAM_2.qlvattu.dbo.NHACUNGCAP values (@MANCC, @DIENTHOAI, @FAX)
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
	delete NHACUNGCAP where MANCC = @MANCC
	delete QLVT_TRAM_1.qlvattu.dbo.NHACUNGCAP where MANCC = @MANCC
	delete QLVT_TRAM_2.qlvattu.dbo.NHACUNGCAP where MANCC = @MANCC
	
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
	-- may chu
	update NHACUNGCAP 
	set TENNCC = @TENNCC, DIACHI = @DIACHI, DIENTHOAI = @DIENTHOAI, FAX = @FAX
	where MANCC = @MANCC
	-- tram 1
	update QLVT_TRAM_1.qlvattu.dbo.NHACUNGCAP
	set TENNCC = @TENNCC, DIACHI = @DIACHI
	where MANCC = @MANCC
	-- tram 2
	update QLVT_TRAM_2.qlvattu.dbo.NHACUNGCAP
	set DIENTHOAI = @DIENTHOAI, FAX = @FAX
	where MANCC = @MANCC
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
	if not exists (select MAKHO from KHO where MAKHO = @MAKHO)
	begin
		raiserror('Mã kho không không tại', 16, 1)
		return
	end
	-- kiểm tra mã vật tư
	if not exists (select MAVT from VATTU where MAVT = @MAVT)
	begin
		raiserror('Mã vật tư không tồn tại', 16, 1)
		return
	end
	-- kiểm tra mã nhân viên
	if not exists (select MANV from NHANVIEN where MANV = @MANV)
	begin
		raiserror('Mã nhân viên không tồn tại', 16, 1)
		return
	end
	-- insert
	-- may chu				
	insert into PHIEUNHAP 
	values (@MAPN, @NGAYNHAP, @MANCC, @LYDO, @MAKHO, @MAVT, @SOLUONG, @DONGIA, @MANV)
	-- tram 1
	if 	exists (select MANV from QLVT_TRAM_1.qlvattu.dbo.NhanVien where MANV = @MANV)
			and
		exists (select MANCC from QLVT_TRAM_1.qlvattu.dbo.NHACUNGCAP where MANCC = @MANCC)
			and
		exists (select MAKHO from QLVT_TRAM_1.qlvattu.dbo.Kho where MAKHO = @MAKHO)
			insert into QLVT_TRAM_1.qlvattu.dbo.PHIEUNHAP
			values (@MAPN, @NGAYNHAP, @MANCC, @LYDO, @MAKHO, @MAVT, @SOLUONG, @DONGIA, @MANV)
	-- tram 2
	else 
		if 	exists (select MANV from QLVT_TRAM_1.qlvattu.dbo.NhanVien where MANV = @MANV)
				and
			exists (select MANCC from QLVT_TRAM_1.qlvattu.dbo.NHACUNGCAP where MANCC = @MANCC)
				and
			exists (select MAKHO from QLVT_TRAM_1.qlvattu.dbo.Kho where MAKHO = @MAKHO)
				insert into QLVT_TRAM_2.qlvattu.dbo.PHIEUNHAP
				values (@MAPN, @NGAYNHAP, @MANCC, @LYDO, @MAKHO, @MAVT, @SOLUONG, @DONGIA, @MANV)
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
	delete PHIEUNHAP where MAPN = @MAPN
	delete QLVT_TRAM_1.qlvattu.dbo.PHIEUNHAP where MAPN = @MAPN
	delete QLVT_TRAM_2.qlvattu.dbo.PHIEUNHAP where MAPN = @MAPN
end
go
-- update
create proc sp_Sua_PhieuNhap
	@MAPN varchar(5),
	@NGAYNHAP DateTime
as
begin
	-- kiểm tra mã phiếu nhập
	if not exists (select MAPN from PHIEUNHAP where MAPN = @MAPN)
	begin
		raiserror('Mã phiếu nhập không tồn tại', 16, 1)
		return
	end
	-- may chu
	update PHIEUNHAP
	set NGAYNHAP = @NGAYNHAP
	where MAPN = @MAPN
	-- tram 1
	if exists (select MAPN from QLVT_TRAM_1.qlvattu.dbo.PHIEUNHAP where MAPN = @MAPN)
		update QLVT_TRAM_1.qlvattu.dbo.PHIEUNHAP
		set NGAYNHAP = @NGAYNHAP
		where MAPN = @MAPN
	-- tram 2
	else if exists (select MAPN from QLVT_TRAM_2.qlvattu.dbo.PHIEUNHAP where MAPN = @MAPN)
		update QLVT_TRAM_2.qlvattu.dbo.PHIEUNHAP
		set NGAYNHAP = @NGAYNHAP
		where MAPN = @MAPN
end
go