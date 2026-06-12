connect sys/"Hola1234*" as sysdba

-- habilitar modo compartido
alter system set shared_servers = 3 scope=both;
alter system set max_shared_servers = 20 scope=both;
alter system set dispatchers='(PROTOCOL=TCP)' scope=both;

-- habilitar pool
execute DBMS_CONNECTION_POOL.START_POOL();

-- minimo y maximo de conexiones
BEGIN
    DBMS_CONNECTION_POOL.CONFIGURE_POOL(
        pool_name => 'SYS_DEFAULT_CONNECTION_POOL', 
        minsize => 2, 
        maxsize => 10
    );
END;
/

-- consulta para verificar el modo de conexión
select server 
from v$session
where audsid = SYS_CONTEXT('userenv', 'sessionid');
