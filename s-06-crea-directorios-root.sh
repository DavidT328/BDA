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
if [ ! -d "${UNAM_HOME}/bda/pf/c0/d02" ]; then
  mkdir -p ${UNAM_HOME}/bda/pf/c0/d02
fi
chown -R oracle:oinstall ${UNAM_HOME}/bda/pf/c0/d02
chmod -R 750 ${UNAM_HOME}/bda/pf/c0/d02

# Core 2
if [ ! -d "${UNAM_HOME}/bda/pf/c0/d03" ]; then
  mkdir -p ${UNAM_HOME}/bda/pf/c0/d03
fi
chown -R oracle:oinstall ${UNAM_HOME}/bda/pf/c0/d03
chmod -R 750 ${UNAM_HOME}/bda/pf/c0/d03

# FRA
if [ ! -d "${UNAM_HOME}/bda/pf/c0/fra" ]; then
  mkdir -p ${UNAM_HOME}/bda/pf/c0/fra
fi
chown -R oracle:oinstall ${UNAM_HOME}/bda/pf/c0/fra
chmod -R 750 ${UNAM_HOME}/bda/pf/c0/fra

echo "Mostrando directorios listos:"
ls -ld /opt/oracle/oradata/${ORACLE_SID^^}
ls -ld ${UNAM_HOME}/bda/pf/c0/d0*
ls -ld ${UNAM_HOME}/bda/pf/c0/fra

read -p "Eliminando contenido de directorios en caso de existir [Enter] para continuar, Ctrl-C para cancelar"

rm -f /opt/oracle/oradata/${ORACLE_SID^^}/*.dbf
rm -f /opt/oracle/oradata/${ORACLE_SID^^}/pdbseed/*.dbf

rm -f ${UNAM_HOME}/bda/pf/c0/d02/*
rm -f ${UNAM_HOME}/bda/pf/c0/d03/*
rm -rf ${UNAM_HOME}/bda/pf/c0/fra/*

rm -f ${UNAM_HOME}/bda/pf/c0/d01/*.dbf
rm -f ${UNAM_HOME}/bda/pf/c1/d01/*.dbf
rm -f ${UNAM_HOME}/bda/pf/c1/d02/*.dbf
rm -f ${UNAM_HOME}/bda/pf/c2/d01/*.dbf

echo "Entorno limpio y listo."