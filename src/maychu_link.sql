use qlvattu
go
exec sp_dropserver @server = 'QLVT_TRAM_1', @droplogins = 'droplogins'
go
exec sp_dropserver @server = 'QLVT_TRAM_2', @droplogins = 'droplogins'
go
--Tạo Link Server
-- Tạo linked server kết nối từ máy ảo MAY_CHU đến TRAM_1:
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
@rmtuser = N'sa', -- Thay tên đăng nhập và mật khẩu phù hợp của TRAM_1
@rmtpassword = 'YourStrong@Passw0rd'
go
-- Tạo linked server kết nối từ máy ảo MAY_CHU đến TRAM_2:
EXEC master.dbo.sp_addlinkedserver
@server = N'QLVT_TRAM_2',
@provider = N'SQLOLEDB',
@datasrc = N'tcp:10.0.75.1,51432',
@srvproduct = ''
go
-- Thực hiện kết nối, đăng nhập TRAM_1:
EXEC master.dbo.sp_addlinkedsrvlogin
@rmtsrvname = N'QLVT_TRAM_2',
@useself = N'False',
@locallogin = NULL,
@rmtuser = N'sa', -- Thay tên đăng nhập và mật khẩu phù hợp của TRAM_1
@rmtpassword = 'YourStrong@Passw0rd'
--exec sp_dropserver @server = 'LINK4', @droplogins = 'droplogins'
--exec sp_linkedservers
go