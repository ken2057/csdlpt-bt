-- Viết 1 View tên là DS_Vattu in ra ds tất cả các vật tư có trong công ty
-- Kết quả dạng xuất: MAVT, TênVT
go
create view DS_Vattu 
as
	select MAVT, TENVT
	from QLVT_TRAM_1.qlvattu.dbo.VATTU

-- Viết 1 SP  in ra PX do NV có @manv trong @ngay
-- Số phiếu, Ngay, HotenNV, TrịGia
go
create proc sp_PhieuXuat_theoNV_ngay
	@manv varchar(5),
	@ngay datetime
as
begin
	if exists (select * from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN where MANV = @manv)
	begin
		select *
		from 
			(select HotenNV 
				from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN 
				where manv = @manv) NV,
			(select mapx, ngayxuat, soluong * dongia as TriGia 
				from QLVT_TRAM_1.qlvattu.dbo.PHIEUXUAT 
				where manv = @manv
					and ngayxuat = @ngay)
	end
	else if exists (select * from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN where MANV = @manv)
	begin
		select *
		from 
			(select HotenNV 
				from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN 
				where manv = @manv) NV,
			(select mapx, ngayxuat, soluong * dongia as TriGia 
				from QLVT_TRAM_2.qlvattu.dbo.PHIEUXUAT 
				where manv = @manv
					and ngayxuat = @ngay)
	end
	else
	begin
		raiserror('Nhân viên này không tồn tại', 16,1)
		return
	end
end

-- Viết 1 SP in ra các PN do NV có @manv vào @ngay
go
create proc sp_PhieuNhap_theoNV_ngay
	@manv varchar(5),
	@ngay datetime
as
begin
	if exists (select * from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN where MANV = @manv)
	begin
		select *
		from 
			(select HotenNV 
				from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN 
				where manv = @manv) NV,
			(select MAPN, NGAYNHAP, soluong * dongia as TriGia 
				from QLVT_TRAM_1.qlvattu.dbo.PHIEUNHAP
				where manv = @manv
					and NGAYNHAP = @ngay)
	end
	else if exists (select * from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN where MANV = @manv)
	begin
		select *
		from 
			(select HotenNV 
				from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN 
				where manv = @manv) NV,
			(select MAPN, NGAYNHAP, soluong * dongia as TriGia 
				from QLVT_TRAM_2.qlvattu.dbo.PHIEUNHAP 
				where manv = @manv
					and NGAYNHAP = @ngay)
	end
	else
	begin
		raiserror('Nhân viên này không tồn tại', 16,1)
		return
	end
end

--C4, C14
-- Viết 1 SP xoá ra các PN do NV có @manv vào @ngay
go
create proc sp_XoaPhieuNhap
	@manv varchar(5),
	@ngay datetime
as
begin
	if exists (select * from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN where MANV = @manv)
	begin
		Delete from QLVT_TRAM_1.qlvattu.dbo.PHIEUNHAP where MANV = @manv and NGAYNHAP = @ngay
		Delete from QLVT_MAY_CHU.qlvattu.dbo.PHIEUNHAP where MANV = @manv and NGAYNHAP = @ngay
	end
	else if exists (select * from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN where MANV = @manv)
	begin
		Delete from QLVT_TRAM_2.qlvattu.dbo.PHIEUNHAP where MANV = @manv and NGAYNHAP = @ngay
		Delete from QLVT_MAY_CHU.qlvattu.dbo.PHIEUNHAP where MANV = @manv and NGAYNHAP = @ngay
	end
	else
	begin
		raiserror('Nhân viên này không tồn tại', 16,1)
		return
	end
end

--C5, C15
-- Viết 1 SP xoá ra các PN do NV có @manv vào @ngay
go
create proc sp_XoaPhieuXuat
	@manv varchar(5),
	@ngay datetime
as
begin
	if exists (select * from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN where MANV = @manv)
	begin
		Delete from QLVT_TRAM_1.qlvattu.dbo.PHIEUXUAT where MANV = @manv and NGAYXUAT = @ngay
		Delete from QLVT_MAY_CHU.qlvattu.dbo.PHIEUXUAT where MANV = @manv and NGAYXUAT = @ngay
	end
	else if exists (select * from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN where MANV = @manv)
	begin
		Delete from QLVT_TRAM_2.qlvattu.dbo.PHIEUXUAT where MANV = @manv and NGAYXUAT = @ngay
		Delete from QLVT_MAY_CHU.qlvattu.dbo.PHIEUXUAT where MANV = @manv and NGAYXUAT = @ngay
	end
	else
	begin
		raiserror('Nhân viên này không tồn tại', 16,1)
		return
	end
end

--C6
-- View DS_NHANVIEN in ra ds NV trong 2 chi nhánh
-- theo thứ tự tăng dần của mã chi nhánh, 
-- trong từng chi nhánh thì tăng theo tên, họ
go
Create View DS_NHANVIEN
as
	select tbl.MACN, tbl.MANV, tbl.HOTENNV
	from (select * from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN 
		UNION
		select * from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN) as tb
	Order by MACN, HOTENNV ASC

--C7
-- Viết SP ThongTin_Phieu để liệt kê các vật tư thuộc có @SoPhieu
-- kết quả các cột: TênVT, SL, DonGia, Ngay, LoaiPhieu, HoTenNV
go
create proc sp_ThongTin_Phieu
	@sophieu varchar(5)
as
begin
	if exists (select * from QLVT_TRAM_1.qlvattu.dbo.PHIEUNHAP where MAPN = @sophieu)
	begin
		select TENVT, SOLUONG, DONGIA, NGAYNHAP, 'Phieu Nhap' as LOAIPHIEU, HOTENNV
		from (select SOLUONG, DONGIA, NGAYNHAP, MANV, MAVT from QLVT_TRAM_1.qlvattu.dbo.PHIEUNHAP where MAPN = @sophieu) as pn
			inner join QLVT_TRAM_1.qlvattu.dbo.VATTU as vt on pn.MAVT = vt.MAVT
			inner join (select MANV, HOTENNV from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN) as nv on pn.MANV = nv.MANV
	end

	else if exists (select * from QLVT_TRAM_2.qlvattu.dbo.PHIEUNHAP where MAPN = @sophieu)
	begin
		select TENVT, SOLUONG, DONGIA, NGAYNHAP, 'Phieu Nhap' as LOAIPHIEU, HOTENNV
		from (select SOLUONG, DONGIA, NGAYNHAP, MANV, MAVT from QLVT_TRAM_2.qlvattu.dbo.PHIEUNHAP where MAPN = @sophieu) as pn
			inner join QLVT_TRAM_1.qlvattu.dbo.VATTU as vt on pn.MAVT = vt.MAVT
			inner join (select MANV, HOTENNV from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN) as nv on pn.MANV = nv.MANV
	end

	else if exists (select * from PHIEUXUAT where MAPX = @sophieu)
	begin
		select TENVT, SOLUONG, DONGIA, NGAYXUAT, 'Phieu Xuat' as LOAIPHIEU, HOTENNV
		from (select SOLUONG, DONGIA, NGAYXUAT, MANV, MAVT from QLVT_TRAM_1.qlvattu.dbo.PHIEUXUAT where MAPX = @sophieu) as px
			inner join QLVT_TRAM_1.qlvattu.dbo.VATTU as vt on px.MAVT = vt.MAVT
			inner join (select MANV, HOTENNV from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN) as nv on px.MANV = nv.MANV
	end

	else if exists (select * from QLVT_TRAM_2.qlvattu.dbo.PHIEUXUAT where MAPX = @sophieu)
	begin
		select TENVT, SOLUONG, DONGIA, NGAYXUAT, 'Phieu Xuat' as LOAIPHIEU, HOTENNV
		from (select SOLUONG, DONGIA, NGAYXUAT, MANV, MAVT from QLVT_TRAM_2.qlvattu.dbo.PHIEUXUAT where MAPX = @sophieu) as pn
			inner join QLVT_TRAM_1.qlvattu.dbo.VATTU as vt on pn.MAVT = vt.MAVT
			inner join (select MANV, HOTENNV from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN) as nv on pn.MANV = nv.MANV
	end

	else
	begin
		raiserror('Phiếu này không tồn tại', 16,1)
		return
	end
end

--C9
-- SP update HoTenNV
go
Create proc sp_Update_HOTENNV
	@manv varchar(5),
	@hotennv nvarchar(50)
as
begin
	if exists (select * from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN where MANV = @manv)
	begin
		Update QLVT_TRAM_1.qlvattu.dbo.NHANVIEN
		set HOTENNV = @hotennv
		where MANV = @manv

		Update QLVT_MAY_CHU.qlvattu.dbo.NHANVIEN
		set HOTENNV = @hotennv
		where MANV = @manv
	end

	else if exists (select * from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN where MANV = @manv)
	begin
		Update QLVT_TRAM_2.qlvattu.dbo.NHANVIEN
		set HOTENNV = @hotennv
		where MANV = @manv

		Update QLVT_MAY_CHU.qlvattu.dbo.NHANVIEN
		set HOTENNV = @hotennv
		where MANV = @manv
	end

	else
	begin
		raiserror('Không tồn tại nhân viên này',16,1)
		return
	end
end

--C11
-- SP tính doanh thu theo từng tháng của 2 chi nhánh
-- TenCN Tháng Năm DoanhThu
go
create view _DoanhThu as
select MANV, MONTH(NGAYXUAT) as THANG, YEAR(NGAYXUAT) as NAM, (SOLUONG * DONGIA) as DOANHTHU
from (select * from QLVT_TRAM_1.qlvattu.dbo.PHIEUXUAT 
	UNION ALL
	select * from QLVT_TRAM_2.qlvattu.dbo.PHIEUXUAT) as tbl
go
create view v_NV_CN as
select MANV, TENCN
from (select MANV, MACN from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN 
		UNION 
		select MANV, MACN from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN) as nv
	inner join
	(select MACN, TENCN from QLVT_TRAM_1.qlvattu.dbo.CHINHANH 
		UNION 
		select MACN, TENCN from QLVT_TRAM_2.qlvattu.dbo.CHINHANH) as cn
	on nv.MACN = cn.MACN
go
create proc sp_TinhDoanhThu
as
begin
	select TENCN, THANG, NAM, sum(DOANHTHU) as TongDoanhThu
	from v_DoanhThuNV as vdt 
		inner join 
		v_NV_CN as vnvcn
		on vdt.MANV = vnvcn.MANV
	group by TENCN, THANG, NAM, DOANHTHU
end

--C12
go
create proc sp_DoanhThuNV @manv varchar(5)
as
begin
	select THANG, NAM, SUM(DOANHTHU) as TongDoanhThu
	from v_DoanhThuNV
	where MANV = @manv
	group by THANG, NAM, DOANHTHU
end

--C13
go
create proc sp_SLNhapVT
as
begin
	select MAVT, MACN, SUM(SOLUONG) as SOLGNHAP
	from (select MAVT, SOLUONG, MANV from QLVT_TRAM_1.qlvattu.dbo.PHIEUNHAP) as pn 
	inner join (select MANV, MACN from QLVT_TRAM_1.qlvattu.dbo.NHANVIEN) as nv
	on pn.MANV = nv.MANV
	group by MAVT, MACN, SOLUONG
	UNION
	select MAVT, MACN, SUM(SOLUONG) as SOLGNHAP
	from (select MAVT, SOLUONG, MANV from QLVT_TRAM_2.qlvattu.dbo.PHIEUNHAP) as pn 
	inner join (select MANV, MACN from QLVT_TRAM_2.qlvattu.dbo.NHANVIEN) as nv
	on pn.MANV = nv.MANV
	group by MAVT, MACN, SOLUONG
end