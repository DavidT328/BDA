CONNECT sys/"Hola1234*" as sysdba

PROMPT === 1. Configurando el Modo Compartido (Shared Server) ===
ALTER SYSTEM SET shared_servers = 3 SCOPE=BOTH;
ALTER SYSTEM SET max_shared_servers = 20 SCOPE=BOTH;
ALTER SYSTEM SET dispatchers = '(PROTOCOL=TCP)(DISPATCHERS=2)' SCOPE=BOTH;

PROMPT === 2. Configurando el Modo Pooled (DRCP) ===
EXECUTE DBMS_CONNECTION_POOL.START_POOL();

BEGIN
    DBMS_CONNECTION_POOL.CONFIGURE_POOL(
        pool_name => 'SYS_DEFAULT_CONNECTION_POOL', 
        minsize   => 2, 
        maxsize   => 10
    );
END;
/
CONNECT sys/"Hola1234*"@media as sysdba
ALTER SYSTEM DISABLE RESTRICTED SESSION;

CONNECT sys/"Hola1234*"@exi as sysdba
ALTER SYSTEM DISABLE RESTRICTED SESSION;