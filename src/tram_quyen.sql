use master
go
----Them cac Login 
create login QLVT_TONGGIAMDOC with password='YourStrong@Passw0rd'
go
create login QLVT_ADMIN with password='YourStrong@Passw0rd'
go
create login QLVT_GIAMDOC with password='YourStrong@Passw0rd'
go
create login QLVT_PGIAMDOC with password='YourStrong@Passw0rd'
go
create login QLVT_NHANVIEN with password='YourStrong@Passw0rd'
go
create login QLVT_QUANLY with password='YourStrong@Passw0rd'
go
use qlvattu
go
-----Them cac User
create user ADMIN for login QLVT_ADMIN
go
create user GIAMDOC for login QLVT_GIAMDOC
go
create user PGIAMDOC for login QLVT_PGIAMDOC
go
create user NHANVIEN for login QLVT_NHANVIEN
go
create user QUANLY for login QLVT_QUANLY
go
-----Them Role
Create role Admins -----Role Admin
go
Grant select,Insert,update,delete on CHINHANH to Admins
Grant select,Insert,update,delete on NHACUNGCAP to Admins
Grant select,Insert,update,delete on KHACHHANG to Admins
Grant select,Insert,update,delete on KHO to Admins
Grant select,Insert,update,delete on NHANVIEN to Admins
Grant select,Insert,update,delete on PHIEUNHAP to Admins
Grant select,Insert,update,delete on PHIEUXUAT to Admins
go
Create role NhanVien -----Role NhanVien
go
Grant select,Insert on NHACUNGCAP to NhanVien
Grant select,Insert on KHACHHANG to NhanVien
Grant select,Insert on PHIEUNHAP to NhanVien
Grant select,Insert on PHIEUXUAT to NhanVien
go
Create role GIAMDOC  -----Role GiamDoc
go
Grant select,Insert,update on NHACUNGCAP to GIAMDOC
Grant select,Insert,update on KHACHHANG to GIAMDOC
Grant select,Insert,update on PHIEUNHAP to GIAMDOC
Grant select,Insert,update on PHIEUXUAT to GIAMDOC
go
Create role PGIAMDOC  -----Role PGiamDoc
go
Grant select,Insert,update on NHACUNGCAP to PGIAMDOC
Grant select,Insert,update on KHACHHANG to PGIAMDOC
Grant select,Insert,update on PHIEUNHAP to PGIAMDOC
Grant select,Insert,update on PHIEUXUAT to PGIAMDOC
go
Create role QUANLY  -----Role Quanly
go
Grant select,Insert,update,delete on NHANVIEN to QUANLY
Grant select,Insert,update,delete on NHACUNGCAP to QUANLY
Grant select,Insert,update,delete on KHACHHANG to QUANLY
Grant select,delete on PHIEUNHAP to QUANLY
Grant select,delete on PHIEUXUAT to QUANLY
go
-----Them Members vao Role
Sp_addRoleMember @rolename='Admins', @membername='ADMIN'
go
Sp_addRoleMember @rolename='GIAMDOC', @membername='GIAMDOC'
go
Sp_addRoleMember @rolename='PGIAMDOC', @membername='PGIAMDOC'
go
Sp_addRoleMember @rolename='QUANLY', @membername='QUANLY'
go
Sp_addRoleMember @rolename='NhanVien', @membername='NHANVIEN'
go
