whenever sqlerror exit sql.sqlcode;

--/*
--##########################################
--## Author: #AUTOR#
--## Finalidad: Creación de tabla de registro de SQLs ejecutadas
--##########################################
--*/


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 
SET FEEDBACK OFF;

DECLARE
v_count number(3);
v_schema varchar(30) := '#ESQUEMA#';
v_constraint_count number(3);
v_sql varchar2(4000);

BEGIN

DBMS_OUTPUT.PUT_LINE('[START] Creación de la tabla RSR_REGISTRO_SQLS');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''RSR_REGISTRO_SQLS'' and owner = ''' || v_schema || '''' into v_count;

if v_count > 0 then
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema || '.RSR_REGISTRO_SQLS... Ya existe');
else 

EXECUTE IMMEDIATE 'CREATE TABLE '|| v_schema ||'.RSR_REGISTRO_SQLS
   (	
	RSR_ID NUMBER(16,0) NOT NULL PRIMARY KEY,
        RSR_NOMBRE_SCRIPT VARCHAR2(255 CHAR) NOT NULL,
	RSR_FECHACREACION VARCHAR2(20 CHAR) NOT NULL,
        RSR_ESQUEMA VARCHAR2(255 CHAR) NOT NULL,
	RSR_AUTOR VARCHAR2(100 CHAR),
	RSR_ARTEFACTO VARCHAR2(50 CHAR),
	RSR_VERSION_ARTEFACTO VARCHAR2(50 CHAR),
	RSR_INCIDENCIA_LINK VARCHAR2(255 CHAR),
	RSR_PRODUCTO VARCHAR2(2 CHAR),
        RSR_RESULTADO VARCHAR2(100 CHAR),
	RSR_INICIO TIMESTAMP,
        RSR_FIN TIMESTAMP,
	RSR_CONTENIDO_SQL BLOB,
        RSR_SALIDA_LOG VARCHAR2(4000 CHAR),
        RSR_ERROR_SQL VARCHAR2(255 CHAR))';

	DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| v_schema ||'.RSR_REGISTRO_SQLS... Tabla creada OK');

end if;

-- CREACION DE INDICES
SELECT COUNT(*) INTO v_count FROM ALL_INDEXES WHERE INDEX_NAME = 'IDX_RSR_REGISTRO_SQLS2' AND TABLE_OWNER=v_schema AND TABLE_NAME='RSR_REGISTRO_SQLS';    
IF v_count=0 THEN
    EXECUTE IMMEDIATE 'CREATE INDEX '|| v_schema ||'.IDX_RSR_REGISTRO_SQLS2 ON '|| v_schema ||'.RSR_REGISTRO_SQLS(RSR_NOMBRE_SCRIPT,RSR_FECHACREACION)';  
    DBMS_OUTPUT.PUT_LINE('CREATE INDEX '|| v_schema ||'.IDX_RSR_REGISTRO_SQLS2... Creado');
END IF;
  
SELECT COUNT(*) INTO v_count FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = 'S_RSR_REGISTRO_SQLS' AND SEQUENCE_OWNER=v_schema; 
   
IF v_count=0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE '|| v_schema ||'.S_RSR_REGISTRO_SQLS';  
    DBMS_OUTPUT.PUT_LINE('CREATE SEQUENCE '|| v_schema ||'.S_RSR_REGISTRO_SQLS... Creado');
END IF;


-- CREACIÓN DE LOS PROCEDIMIENTOS DE CONSULTA, INSERCIÓN INICIAL Y ACTUALIZACIÓN FINAL DE REGISTRO DE SQLS

EXCEPTION
     WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(SQLERRM);
          
          ROLLBACK;
          RAISE;

END;
/


CREATE OR REPLACE FUNCTION RSR_PASO2 (v_RSR_NOMBRE_SCRIPT IN VARCHAR2,
v_RSR_FECHACREACION IN VARCHAR2, v_RSR_ESQUEMA IN VARCHAR2) RETURN VARCHAR2

IS

v_count number(3);
v_schema varchar2(30) := '#ESQUEMA#';
v_sql varchar2(4000);

v_RESULTADO VARCHAR2(20) := 'OK';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[START] Comprobar si el script ' || v_RSR_NOMBRE_SCRIPT || 
      ' con fecha de creacion ' || v_RSR_FECHACREACION || 
      ' y esquema ' || v_RSR_ESQUEMA || 
      ' esta registrado como ejecutado en RSR_REGISTRO_SQLS');
    
    EXECUTE IMMEDIATE 'select count(1) from ' || v_schema || '.RSR_REGISTRO_SQLS WHERE RSR_NOMBRE_SCRIPT=''' || v_RSR_NOMBRE_SCRIPT 
      || ''' AND RSR_FECHACREACION = ''' || v_RSR_FECHACREACION || ''' AND RSR_ESQUEMA = ''' || v_RSR_ESQUEMA || ''' AND RSR_RESULTADO=''OK''' into v_count;
    
    if v_count > 0 then
      DBMS_OUTPUT.PUT_LINE('[INFO] Script ' || v_RSR_NOMBRE_SCRIPT || ' con fecha de creación ' || v_RSR_FECHACREACION || ' y esquema ' || v_RSR_ESQUEMA ||
     ' YA EJECUTADO');
      v_RESULTADO := 'YA_EXISTE';
    else 
      DBMS_OUTPUT.PUT_LINE('[INFO] Script ' || v_RSR_NOMBRE_SCRIPT || 
        ' con fecha de creación ' || v_RSR_FECHACREACION || 
        ' No se ha ejecutado');
    end if;
    
    RETURN (v_RESULTADO);
  
    EXCEPTION
         WHEN OTHERS THEN
              DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(SQLCODE));
              DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
              DBMS_OUTPUT.put_line(SQLERRM);          
              ROLLBACK;
              RAISE;
              RETURN 'KO';

END RSR_PASO2;
/


CREATE OR REPLACE PROCEDURE RSR_PASO3 (
  v_RSR_NOMBRE_SCRIPT IN VARCHAR2,
  v_RSR_ESQUEMA_EJECUCION IN VARCHAR2,
  v_RSR_AUTOR IN VARCHAR2,
  v_RSR_ARTEFACTO IN VARCHAR2,
  v_RSR_VERSION_ARTEFACTO IN VARCHAR2,
  v_RSR_FECHACREACION IN VARCHAR2,
  v_RSR_INCIDENCIA_LINK IN VARCHAR2,
  v_RSR_PRODUCTO IN VARCHAR) 
IS

v_count number(3);
v_schema varchar(30) := '#ESQUEMA#';
v_constraint_count number(3);
v_sql varchar2(4000);

BEGIN

DBMS_OUTPUT.PUT_LINE('[START] Inserción inicial de los datos de ejecución del script ' 
  || v_RSR_NOMBRE_SCRIPT || ' con fecha de creación ' 
  || v_RSR_FECHACREACION || ' con esquema ' 
  || v_RSR_ESQUEMA_EJECUCION || ' en RSR_REGISTRO_SQLS');

EXECUTE IMMEDIATE 'DELETE from ' || v_schema || '.RSR_REGISTRO_SQLS WHERE RSR_NOMBRE_SCRIPT=''' || v_RSR_NOMBRE_SCRIPT 
  || ''' AND RSR_FECHACREACION = ''' || v_RSR_FECHACREACION || ''' AND RSR_ESQUEMA = ''' || v_RSR_ESQUEMA_EJECUCION || ''' AND (RSR_RESULTADO IS NULL OR RSR_RESULTADO=''KO'')';

EXECUTE IMMEDIATE 'INSERT INTO ' || v_schema || '.RSR_REGISTRO_SQLS ' ||
  '(RSR_ID, RSR_NOMBRE_SCRIPT, RSR_FECHACREACION, RSR_ESQUEMA, RSR_AUTOR, RSR_ARTEFACTO, ' ||
  'RSR_VERSION_ARTEFACTO, RSR_INCIDENCIA_LINK, RSR_PRODUCTO, RSR_INICIO) ' ||
  ' VALUES (' || v_schema || '.S_RSR_REGISTRO_SQLS.nextval, ''' || v_RSR_NOMBRE_SCRIPT ||
  ''',''' || v_RSR_FECHACREACION || ''',''' || v_RSR_ESQUEMA_EJECUCION || ''',''' || v_RSR_AUTOR || 
  ''',''' || v_RSR_ARTEFACTO || ''',''' || v_RSR_VERSION_ARTEFACTO || ''',''' || v_RSR_INCIDENCIA_LINK ||
  ''',''' || v_RSR_PRODUCTO || ''', SYSDATE)';

EXCEPTION
     WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(SQLERRM);
          
          ROLLBACK;
          RAISE;

END;
/

CREATE OR REPLACE PROCEDURE RSR_PASO4 (
v_RSR_NOMBRE_SCRIPT IN VARCHAR2,
v_RSR_FECHACREACION IN VARCHAR2,
v_RSR_ESQUEMA_EJECUCION IN VARCHAR2,
v_RSR_RESULTADO IN VARCHAR2,
v_RSR_ERROR_SQL IN VARCHAR2
) IS

v_count number(3);
v_schema varchar(30) := '#ESQUEMA#';
v_constraint_count number(3);
v_sql varchar2(4000);

BEGIN

DBMS_OUTPUT.PUT_LINE('[START] Actualización final de los datos de ejecución del script ' 
  || v_RSR_NOMBRE_SCRIPT || ' con fecha de creación ' 
  || v_RSR_FECHACREACION || ' con esquema ' 
  || v_RSR_ESQUEMA_EJECUCION || ' en RSR_REGISTRO_SQLS');

EXECUTE IMMEDIATE 'UPDATE ' || v_schema || '.RSR_REGISTRO_SQLS SET ' ||
  'RSR_RESULTADO=''' || v_RSR_RESULTADO || ''',' ||
  'RSR_ERROR_SQL=''' || v_RSR_ERROR_SQL || ''',' ||
  'RSR_FIN=SYSDATE ' || 
  'WHERE RSR_NOMBRE_SCRIPT=''' || v_RSR_NOMBRE_SCRIPT || ''' AND ' ||
  'RSR_FECHACREACION=''' || v_RSR_FECHACREACION || ''' AND ' ||
  'RSR_ESQUEMA=''' || v_RSR_ESQUEMA_EJECUCION || '''';

EXCEPTION
     WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución: '||TO_CHAR(SQLCODE));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(SQLERRM);
          
          ROLLBACK;
          RAISE;

END;
/

exit
