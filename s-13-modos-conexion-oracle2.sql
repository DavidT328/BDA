connect sys/system2 as sysdba

-- habilitar modo compartido
alter system set shared_servers = 3 scope=both;
alter system set max_shared_servers = 20 scope=both;
alter system set dispatchers scope=both;

-- habilidad pool

execute DBMS_CONNECTION_POOL.START_POOL();
-- minimo y maximo de conexiones
EXECUTE DBMS_CONNECTION_POOL.ALTER_POOL(
    pool_name=>'SYS_DEFAULT_CONNECTION_POOL', 
    minsize=>2, 
    maxsize=>10
    );

--consulta para verificar el modo de conexión
select server 
from v$session
where audsid = SYS_CONTEXT('userenv', 'sessionid');
