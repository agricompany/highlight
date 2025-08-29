@echo off
chcp 65001 >nul
echo.
echo ================================
echo  👤 CRIANDO USUÁRIO ADMIN
echo ================================
echo.

echo 🔥 Problema: Usuário admin não existe no banco
echo 💡 Solução: Criar usuário admin no PostgreSQL

echo.
echo 1. Verificando se PostgreSQL está funcionando...
docker exec highlight-postgres psql -U highlight -d highlight -c "SELECT version();"

if %errorlevel% neq 0 (
    echo ❌ PostgreSQL não está funcionando!
    pause
    exit /b 1
)

echo.
echo 2. Criando usuário admin no banco...
echo Inserindo usuário: admin@highlight.io / password

docker exec highlight-postgres psql -U highlight -d highlight -c "
INSERT INTO admins (id, email, password, created_at, updated_at) 
VALUES (
    'admin-001', 
    'admin@highlight.io', 
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 
    NOW(), 
    NOW()
) ON CONFLICT (email) DO NOTHING;
"

echo.
echo 3. Verificando se usuário foi criado...
docker exec highlight-postgres psql -U highlight -d highlight -c "SELECT id, email FROM admins WHERE email = 'admin@highlight.io';"

echo.
echo 4. Verificando tabelas existentes...
docker exec highlight-postgres psql -U highlight -d highlight -c "\dt" | findstr admin

echo.
echo 5. Se não existe tabela admins, vamos criar...
docker exec highlight-postgres psql -U highlight -d highlight -c "
CREATE TABLE IF NOT EXISTS admins (
    id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
"

echo.
echo 6. Inserindo usuário novamente...
docker exec highlight-postgres psql -U highlight -d highlight -c "
INSERT INTO admins (id, email, password, created_at, updated_at) 
VALUES (
    'admin-001', 
    'admin@highlight.io', 
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 
    NOW(), 
    NOW()
) ON CONFLICT (email) DO NOTHING;
"

echo.
echo 7. Verificação final...
docker exec highlight-postgres psql -U highlight -d highlight -c "SELECT id, email FROM admins;"

echo.
echo 🎉 CREDENCIAIS PARA LOGIN:
echo   URL: http://localhost:3000
echo   Email: admin@highlight.io
echo   Senha: password
echo.
echo 💡 Nota: O hash $2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi
echo    corresponde à senha "password" em bcrypt
echo.

pause
