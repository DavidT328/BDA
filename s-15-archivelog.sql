-- la ubicación 1 a la fra
alter system set log_archive_dest_1 = 'LOCATION=USE_DB_RECOVERY_FILE_DEST' scope=both;

-- ubicacion 2
alter system set log_archive_dest_2 = 'location=/unam/bda/pf/archivelogs_secundarios' scope=both;