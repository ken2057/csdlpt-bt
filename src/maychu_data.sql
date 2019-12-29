use qlvattu
go
print 'chinhanh'
go
insert into chinhanh values ('cn1', 'cn1', N'TPHCM', '123')
insert into chinhanh values ('cn2', 'cn2', N'Ha Noi', '123')
insert into qlvt_tram_1.qlvattu.dbo.chinhanh select * from chinhanh where diadiem  = N'TPHCM'
insert into qlvt_tram_2.qlvattu.dbo.chinhanh select * from chinhanh where diadiem  = N'Ha Noi'
go
print 'kho'
go
insert into kho values ('kho1', 'kho1', 'SVH', 'cn1')
insert into kho values ('kho2', 'kho2', 'HN', 'cn2')
insert into qlvt_tram_1.qlvattu.dbo.kho values ('kho1', 'kho1', 'SVH', 'cn1')
insert into qlvt_tram_2.qlvattu.dbo.kho values ('kho2', 'kho2', 'HN', 'cn2')
go
print 'vattu'
go
insert into vattu values ('vt1', 'vt1', '', 'cai')
insert into vattu values ('vt2', 'vt2', '', 'chai')
insert into vattu values ('vt3', 'vt3', '', 'thung')
insert into vattu values ('vt4', 'vt4', '', 'lon')
insert into qlvt_tram_1.qlvattu.dbo.vattu select mavt, tenvt from vattu
insert into qlvt_tram_2.qlvattu.dbo.vattu select mavt, quicach, dvtinh from vattu
go
print 'nhanvien'
go
insert into nhanvien values ('nv1', 'duy', '1998/10/9', 0, 'SVH', N'Bien che', getdate(), 20000000, '', null, 'cn1')
insert into nhanvien values ('nv2', 'duy2', '1998/1/9', 0, 'LG', N'Khong bien che', getdate(), 1000000, '', null, 'cn2')
insert into qlvt_tram_1.qlvattu.dbo.nhanvien values ('nv1', 'duy', '1998/10/9', 0, 'SVH', N'Bien che', getdate(), 20000000, '', null, 'cn1')
insert into qlvt_tram_2.qlvattu.dbo.nhanvien values ('nv2', 'duy2', '1998/1/9', 0, 'LG', N'Khong bien che', getdate(), 1000000, '', null, 'cn2')
go
print 'khachhang'
go
insert into khachhang values ('kh1', 'nghi', 'svh', '324', '123')
insert into khachhang values ('kh2', 'bui', 'svh', '324', '123')
insert into khachhang values ('kh3', 'hieu', 'svh', '324', '123')
insert into khachhang values ('kh4', 'son', 'svh', '324', '123')
insert into qlvt_tram_1.qlvattu.dbo.khachhang select makh, HOTENKH, diachi from khachhang
insert into qlvt_tram_2.qlvattu.dbo.khachhang select makh, dienthoai, fax from khachhang
go
print 'nhacungcap'
go
insert into nhacungcap values ('ncc1', 'google', 'svg', '325', '123')
insert into nhacungcap values ('ncc2', 'bing', 'svc', '314', '113')
insert into qlvt_tram_1.qlvattu.dbo.nhacungcap select mancc, TENNCC, diachi from nhacungcap
insert into qlvt_tram_2.qlvattu.dbo.nhacungcap select mancc, dienthoai, fax from nhacungcap
go
print 'phieunhap'
go
insert into phieunhap values ('1', getdate(), 'ncc1', null, 'kho1', 'vt1', 1, 100, 'nv1')
insert into phieunhap values ('2', getdate(), 'ncc1', null, 'kho1', 'vt2', 1, 100, 'nv1')
insert into phieunhap values ('3', getdate(), 'ncc2', null, 'kho2', 'vt3', 1, 100, 'nv2')
insert into phieunhap values ('4', getdate(), 'ncc2', null, 'kho2', 'vt4', 1, 100, 'nv2')
insert into qlvt_tram_1.qlvattu.dbo.phieunhap select * from phieunhap where manv='nv1'
insert into qlvt_tram_2.qlvattu.dbo.phieunhap select * from phieunhap where manv='nv2'
go
print 'phieuxuat'
go
insert into phieuxuat values ('1', getdate(), 'kh1', null, 'kho1', 'vt1', 1, 100, 'nv1')
insert into phieuxuat values ('2', getdate(), 'kh2', null, 'kho1', 'vt2', 1, 100, 'nv1')
insert into phieuxuat values ('3', getdate(), 'kh3', null, 'kho2', 'vt3', 1, 100, 'nv2')
insert into phieuxuat values ('4', getdate(), 'kh4', null, 'kho2', 'vt4', 1, 100, 'nv2')
insert into qlvt_tram_1.qlvattu.dbo.phieuxuat select * from phieuxuat where manv='nv1'
insert into qlvt_tram_2.qlvattu.dbo.phieuxuat select * from phieuxuat where manv='nv2'
go