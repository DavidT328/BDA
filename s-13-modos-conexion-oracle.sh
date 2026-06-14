#!/bin/bash
#@Autor:          Erick Nava Santiago
#@Fecha creación: 30/05/2026
#@Descripción:    Agrega en tnsnames.ora los alias para habilitar los modos de conexión

cat << 'EOF' >> $ORACLE_HOME/network/admin/tnsnames.ora
-- Todas las conexiones se guardan en oracle tnsnames.

FREE =
	(DESCRIPTION =
          (ADDRESS_LIST =
            (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
          )
          (CONNECT_DATA =
            (SERVICE_NAME = free.fi.unam)
          )
	)

FREE_DEDICATED =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = free.fi.unam)
    )
  )


FREE_SHARED =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = SHARED)
      (SERVICE_NAME = free.fi.unam)
    )
  )



FREE_POOLED =
  (DESCRIPTION =
    (ADDRESS_LIST =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
   )
   (CONNECT_DATA =
     (SERVICE_NAME = free.fi.unam)
     (SERVER=POOLED)
   )
)



USUARIOS =
	(DESCRIPTION =
          (ADDRESS_LIST =
            (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
          )
          (CONNECT_DATA =
            (SERVICE_NAME = usuarios_pdb.fi.unam)
          )
	)


USUARIOS_DEDICATED =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = usuarios_pdb.fi.unam)
    )
  )

USUARIOS_SHARED =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = SHARED)
      (SERVICE_NAME = usuarios_pdb.fi.unam)
    )
  )



USUARIOS_POOLED =
  (DESCRIPTION =
    (ADDRESS_LIST =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
   )
   (CONNECT_DATA =
     (SERVICE_NAME = usuarios_pdb.fi.unam)
     (SERVER=POOLED)
   )
)






MEDIA =
	(DESCRIPTION =
          (ADDRESS_LIST =
            (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
          )
          (CONNECT_DATA =
            (SERVICE_NAME = media_pdb.fi.unam)
          )
	)


MEDIA_DEDICATED =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = media_pdb.fi.unam)
    )
  )

MEDIA_SHARED =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = SHARED)
      (SERVICE_NAME = media_pdb.fi.unam)
    )
  )



MEDIA_POOLED =
  (DESCRIPTION =
    (ADDRESS_LIST =
    (ADDRESS = (PROTOCOL = TCP)(HOST = h-ens-proy-final.fi.unam)(PORT = 1521))
   )
   (CONNECT_DATA =
     (SERVICE_NAME = media_pdb.fi.unam)
     (SERVER=POOLED)
   )
)
EOF