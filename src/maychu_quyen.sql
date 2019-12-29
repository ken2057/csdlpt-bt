use master
go
----Them cac Login 
create login QLVT_TONGGIAMDOC with password='YourStrong@Passw0rd' 
go
create login QLVT_ADMIN with password='YourStrong@Passw0rd' 
go
use qlvattu
go
create user TONGGIAMDOC for login QLVT_TONGGIAMDOC
create user ADMIN for login QLVT_ADMIN
go
Create role Admins
go
Grant select,Insert,update,delete on CHINHANH to Admins
Grant select,Insert,update,delete on NHACUNGCAP to Admins
Grant select,Insert,update,delete on KHACHHANG to Admins
Grant select,Insert,update,delete on KHO to Admins
Grant select,Insert,update,delete on NHANVIEN to Admins
Grant select,Insert,update,delete on PHIEUNHAP to Admins
Grant select,Insert,update,delete on PHIEUXUAT to Admins
go
Create role TGD -----Role TONGGIAMDOC
go
Grant select,Insert,update,delete on CHINHANH to TGD
Grant select,Insert,update,delete on NHACUNGCAP to TGD
Grant select,Insert,update,delete on KHACHHANG to TGD
Grant select,Insert,update,delete on KHO to TGD
Grant select,Insert,update,delete on NHANVIEN to TGD
Grant select,Insert,update,delete on PHIEUNHAP to TGD
Grant select,Insert,update,delete on PHIEUXUAT to TGD
go
-----Them Members vao Role
sp_addrolemember @rolename='Admins', @membername='ADMIN'
go
sp_addrolemember @rolename='TGD', @membername='TONGGIAMDOC'
go