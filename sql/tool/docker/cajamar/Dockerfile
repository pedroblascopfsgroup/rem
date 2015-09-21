FROM filemon/oracle_11g

ENV INSTALLER_DIR /pfssettup/BBDD-SCRIPTS
ENV DUMP_DIR /pfssettup/DUMP

COPY SQL-SCRIPTS $INSTALLER_DIR
COPY DUMP $DUMP_DIR

RUN $ORACLE_HOME/bin/sqlplus system/admin@localhost:1521/orcl @/pfssettup/BBDD-SCRIPTS/script.sql



