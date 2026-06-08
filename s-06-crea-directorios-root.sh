#!/bin/bash

export ORACLE_SID=free
export UNAM_HOME=/unam

echo "1. Verificando y preparando directorio estándar para data files del CDB\$ROOT y PDB\$SEED"

if [ -d "/opt/oracle/oradata/${ORACLE_SID^^}" ]; then
  echo "Directorio para data files estándar ya existe."
else
  echo "Creando directorios para data files raíz y semilla"  
  mkdir -p /opt/oracle/oradata/${ORACLE_SID^^}/pdbseed
  chown -R oracle:oinstall /opt/oracle/oradata
  chmod -R 750 /opt/oracle/oradata  
fi;

echo "2. Preparando permisos para los discos de Capas de Almacenamiento (Datafiles del Proyecto)"
chown -R oracle:oinstall ${UNAM_HOME}/bda/pf/c0
chown -R oracle:oinstall ${UNAM_HOME}/bda/pf/c1
chown -R oracle:oinstall ${UNAM_HOME}/bda/pf/c2
chmod -R 750 ${UNAM_HOME}/bda/pf/c0
chmod -R 750 ${UNAM_HOME}/bda/pf/c1
chmod -R 750 ${UNAM_HOME}/bda/pf/c2

echo "3. Preparando directorios para Redo Logs, Control files y FRA"

# Core 1
if [ ! -d "${UNAM_HOME}/bda/pf/core/d01" ]; then
  mkdir -p ${UNAM_HOME}/bda/pf/core/d01
fi
chown -R oracle:oinstall ${UNAM_HOME}/bda/pf/core/d01
chmod -R 750 ${UNAM_HOME}/bda/pf/core/d01

# Core 2
if [ ! -d "${UNAM_HOME}/bda/pf/core/d02" ]; then
  mkdir -p ${UNAM_HOME}/bda/pf/core/d02
fi
chown -R oracle:oinstall ${UNAM_HOME}/bda/pf/core/d02
chmod -R 750 ${UNAM_HOME}/bda/pf/core/d02

# FRA
if [ ! -d "${UNAM_HOME}/bda/pf/fra" ]; then
  mkdir -p ${UNAM_HOME}/bda/pf/fra
fi
chown -R oracle:oinstall ${UNAM_HOME}/bda/pf/fra
chmod -R 750 ${UNAM_HOME}/bda/pf/fra

echo "Mostrando directorios listos:"
ls -ld /opt/oracle/oradata/${ORACLE_SID^^}
ls -ld ${UNAM_HOME}/bda/pf/core/d0*
ls -ld ${UNAM_HOME}/bda/pf/fra

read -p "Eliminando contenido de directorios en caso de existir [Enter] para continuar, Ctrl-C para cancelar"

rm -f /opt/oracle/oradata/${ORACLE_SID^^}/*.dbf
rm -f /opt/oracle/oradata/${ORACLE_SID^^}/pdbseed/*.dbf

rm -f ${UNAM_HOME}/bda/pf/core/d01/*
rm -f ${UNAM_HOME}/bda/pf/core/d02/*
rm -rf ${UNAM_HOME}/bda/pf/fra/*

rm -f ${UNAM_HOME}/bda/pf/c0/d01/*.dbf
rm -f ${UNAM_HOME}/bda/pf/c1/d01/*.dbf
rm -f ${UNAM_HOME}/bda/pf/c1/d02/*.dbf
rm -f ${UNAM_HOME}/bda/pf/c2/d01/*.dbf

echo "Entorno limpio y listo."
