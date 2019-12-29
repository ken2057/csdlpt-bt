@ECHO OFF
rem ----------------------------------------------------------------
set user=sa
set pass=YourStrong^@Passw0rd
set tram1=tcp:10.0.75.1,51431
set tram2=tcp:10.0.75.1,51432
echo ----------------------------------------------------------------
echo Install db maychu
sqlcmd -i src/maychu_db.sql
echo -
echo Install db tram1
sqlcmd -S %tram1% -U %user% -P "%pass%" -i src/tram1_db.sql
echo -
echo Install db tram2
sqlcmd -S %tram2% -U %user% -P "%pass%" -i src/tram2_db.sql
echo ----------------------------------------------------------------
echo Add quyen maychu
sqlcmd -i src/maychu_quyen.sql
echo -
echo Add quyen tram1
sqlcmd -S %tram1% -U %user% -P "%pass%" -i src/tram_quyen.sql
echo -
echo Add quyen tram2
sqlcmd -S %tram2% -U %user% -P "%pass%" -i src/tram_quyen.sql
echo ----------------------------------------------------------------
echo Install link server
sqlcmd -i src/maychu_link.sql
TIMEOUT /T 3 /NOBREAK
echo -
echo Install link tram1
sqlcmd -S %tram1% -U %user% -P "%pass%" -i src/tram1_link.sql
TIMEOUT /T 3 /NOBREAK
echo -
echo Install link tram2
sqlcmd -S %tram2% -U %user% -P "%pass%" -i src/tram2_link.sql
TIMEOUT /T 3 /NOBREAK
echo ----------------------------------------------------------------
echo Add sp
echo Install sp tram1
sqlcmd -S %tram1% -U %user% -P "%pass%" -i src/tram1_sp.sql
TIMEOUT /T 3 /NOBREAK
echo -
echo Install sp tram2
sqlcmd -S %tram2% -U %user% -P "%pass%" -i src/tram2_sp.sql
TIMEOUT /T 3 /NOBREAK
echo ----------------------------------------------------------------
echo Add data
sqlcmd -i src/maychu_data.sql
echo ----------------------------------------------------------------
echo Done
docker ps --format Name:{{.Names}}\t\tPort:{{.Ports}} --filter name=^/sql
pause