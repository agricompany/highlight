@echo off
chcp 65001 >nul
echo.
echo ===============================
echo  🔐 GERADOR DE HASH CLICKHOUSE
echo ===============================
echo.

echo Gerando SHA256 hash da senha 'highlight123'...

rem Usando PowerShell para gerar o hash SHA256
powershell -Command "$senha = 'highlight123'; $bytes = [System.Text.Encoding]::UTF8.GetBytes($senha); $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes); $hashString = [System.BitConverter]::ToString($hash).Replace('-', '').ToLower(); Write-Host 'Senha: highlight123'; Write-Host 'SHA256 Hash:' $hashString"

echo.
echo Criando arquivo users-hash.xml com o hash correto...

rem Gerar o hash e salvar em variável
for /f "tokens=*" %%i in ('powershell -Command "$senha = 'highlight123'; $bytes = [System.Text.Encoding]::UTF8.GetBytes($senha); $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($bytes); [System.BitConverter]::ToString($hash).Replace('-', '').ToLower()"') do set HASH=%%i

echo Hash gerado: %HASH%

(
echo ^<?xml version="1.0"?^>
echo ^<clickhouse^>
echo     ^<users^>
echo         ^<default^>
echo             ^<!-- SHA256 hash da senha 'highlight123' --^>
echo             ^<password_sha256_hex^>%HASH%^</password_sha256_hex^>
echo             ^<networks^>
echo                 ^<ip^>::/0^</ip^>
echo             ^</networks^>
echo             ^<profile^>default^</profile^>
echo             ^<quota^>default^</quota^>
echo         ^</default^>
echo     ^</users^>
echo     
echo     ^<profiles^>
echo         ^<default^>
echo             ^<max_memory_usage^>4000000000^</max_memory_usage^>
echo             ^<use_uncompressed_cache^>0^</use_uncompressed_cache^>
echo             ^<load_balancing^>random^</load_balancing^>
echo         ^</default^>
echo     ^</profiles^>
echo     
echo     ^<quotas^>
echo         ^<default^>
echo             ^<interval^>
echo                 ^<duration^>3600^</duration^>
echo                 ^<queries^>0^</queries^>
echo                 ^<errors^>0^</errors^>
echo                 ^<result_rows^>0^</result_rows^>
echo                 ^<read_rows^>0^</read_rows^>
echo                 ^<execution_time^>0^</execution_time^>
echo             ^</interval^>
echo         ^</default^>
echo     ^</quotas^>
echo ^</clickhouse^>
) > "clickhouse-users\users-hash.xml"

echo.
echo ✅ Arquivo users-hash.xml criado com sucesso!
echo.
echo Para usar este arquivo, altere o docker-compose.yml:
echo   ./clickhouse-users/users-hash.xml:/etc/clickhouse-server/users.d/highlight-users.xml
echo.
pause
