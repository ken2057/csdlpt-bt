use qlvattu
go
exec sp_dropserver @server = 'QLVT_TRAM_1', @droplogins = 'droplogins'
go
exec sp_dropserver @server = 'QLVT_LINKED_SERVER', @droplogins = 'droplogins'
go
--Tạo Link Server
-- Tạo linked server kết nối từ máy ảo TRAM_2 đến MAY_CHU:
EXEC master.dbo.sp_addlinkedserver
@server = N'QLVT_LINKED_SERVER',
@provider = N'SQLOLEDB',
@datasrc = N'192.168.1.12\DESKTOP-31CC9RR,1433',
@srvproduct = ''
go
-- Thực hiện kết nối, đăng nhập MAY_CHU:
EXEC master.dbo.sp_addlinkedsrvlogin
@rmtsrvname = N'QLVT_LINKED_SERVER',
@useself = N'False',
@locallogin = NULL,
@rmtuser = N'sa', -- Thay tên đăng nhập và mật khẩu phù hợp của MAY_CHU
@rmtpassword = '123'
go
-- Tạo linked server kết nối từ máy ảo TRAM_2 đến TRAM_1:
EXEC master.dbo.sp_addlinkedserver
@server = N'QLVT_TRAM_1',
@provider = N'SQLOLEDB',
@datasrc = N'tcp:10.0.75.1,51431',
@srvproduct = ''
go
-- Thực hiện kết nối, đăng nhập TRAM_1:
EXEC master.dbo.sp_addlinkedsrvlogin
@rmtsrvname = N'QLVT_TRAM_1',
@useself = N'False',
@locallogin = NULL,
@rmtuser = N'sa', -- Thay tên đăng nhập và mật khẩu phù hợp của TRAM_2
@rmtpassword = 'YourStrong@Passw0rd'
go
--exec sp_dropserver @server = 'QLVT_LINKED_SERVER', @droplogins = 'droplogins'
--exec sp_linkedservers
--------------------------------------------------------------------