#!/bin/bash
#@Autor:          Erick Nava Santiago
#@Fecha creación: 30/05/2026
#@Descripción:    Agrega en tnsnames.ora los alias para habilitar los modos de conexión

cat << 'EOF' >> $ORACLE_HOME/network/admin/tnsnames.ora


USUARIOS_DEDICADO =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = usuarios_pdb)
    )
  )

USUARIOS_COMPARTIDO =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = SHARED)
      (SERVICE_NAME = usuarios_pdb)
    )
  )

USUARIOS_POOL =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = POOLED)
      (SERVICE_NAME = usuarios_pdb)
    )
  )
  
MEDIA_DEDICADO =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = media_pdb)
    )
  )

MEDIA_COMPARTIDO =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = SHARED)
      (SERVICE_NAME = media_pdb)
    )
  )

MEDIA_POOL =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = POOLED)
      (SERVICE_NAME = media_pdb)
    )
  )
EOF