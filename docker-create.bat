@ECHO OFF
echo ----------------------------------------------------------------
rem find image, if not exists install
echo Find image mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04

docker images | findstr "2019-GA-ubuntu-16.04" | findstr "mcr.microsoft.com/mssql/server" > NUL
if "%errorlevel%"=="0" ( ^
	ECHO Image exist ) ^
else ( ECHO Install image && docker pull mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04)

echo ----------------------------------------------------------------
echo Check container exists and rerun

docker container ps --all | findstr "tram1" > NUL
if "%errorlevel%"=="0" ( ^
	ECHO tram1 exist, rerun tram1 ^
	docker stop tram1 && docker start tram1 ) ^
	else ( ECHO Create container tram1
	rem docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<YourStrong@Passw0rd>" --name tram1 -p 51431:1433 -d mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04
	docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" -e 'MSSQL_RPC_PORT=136' -e 'MSSQL_DTC_TCP_PORT=51000' --name tram1 -p 51431:1433 -p 136:135 -p 51000:51000 -d mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04
	TIMEOUT /T 5 /NOBREAK )
echo ----------------------------------------------------------------
docker container ps --all | findstr "tram2" > NUL
if "%errorlevel%"=="0" ( ^
	ECHO tram2 exist, rerun tram2 ^
	docker stop tram2 && docker start tram2 ) ^
	else ( ECHO Create container tram2
	rem docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<YourStrong@Passw0rd>" --name tram2 -p 51432:1433 -d mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04
	docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" -e 'MSSQL_RPC_PORT=135' -e 'MSSQL_DTC_TCP_PORT=51000' --name tram2 -p 51432:1433 -p 137:135 -p 51001:51001 -d mcr.microsoft.com/mssql/server:2019-GA-ubuntu-16.04
	TIMEOUT /T 5 /NOBREAK )
echo ----------------------------------------------------------------

echo Done
docker ps --format Name:{{.Names}}\t\tPort:{{.Ports}} --filter name=^/sql
pause

