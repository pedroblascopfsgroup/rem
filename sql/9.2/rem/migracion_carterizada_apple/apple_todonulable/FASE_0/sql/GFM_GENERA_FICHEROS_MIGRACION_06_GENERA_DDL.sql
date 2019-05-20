--/*
--##########################################
--## AUTOR= Miguel Sanchez
--## FECHA_CREACION=20181204
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=MIGRACION-APPLE
--## INCIDENCIA_LINK=HREOS-4932
--## PRODUCTO=NO
--## 
--## Finalidad: GFM
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
SET LINESIZE 32000;
SET PAGESIZE 40000;
SET LONG 50000;

DECLARE

V_INTERFAZ VARCHAR2(1024 CHAR);
V_TEXTO VARCHAR2(1024 CHAR);
V_INPUT VARCHAR2(1024 CHAR);

CURSOR C IS
SELECT 
   GFM.NOMBRE_CAMPO ||' '||
   CASE 
       WHEN UPPER(GFM.TIPO_CAMPO) LIKE '%DATE%' THEN 'DATE' 
       WHEN UPPER(GFM.TIPO_CAMPO) LIKE '%CHAR%' THEN (SELECT 'VARCHAR2('||REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(GFM.TIPO_CAMPO,' ',''),'VARCHAR (',''),'CHAR)',''),')',''),'VARCHAR(',''),'CHAR(',''),'VARCHAR2(','')||' CHAR)' FROM DUAL)
       WHEN UPPER(GFM.TIPO_CAMPO) LIKE '%NUMBER%' AND  (UPPER(GFM.TIPO_CAMPO) NOT LIKE '%,%' OR UPPER(GFM.TIPO_CAMPO) LIKE '%,0%')THEN (SELECT 'NUMBER('||REPLACE(upper(REPLACE(upper(REPLACE(upper(REPLACE(upper(REPLACE(upper(GFM.TIPO_CAMPO),'NUMBER (','')),')','')),',0)','')),'NUMBER(','')),'NUMBER','')||')' FROM DUAL)
       WHEN UPPER(GFM.TIPO_CAMPO) LIKE '%NUMBER%' AND  UPPER(GFM.TIPO_CAMPO)  LIKE '%,%' AND UPPER(GFM.TIPO_CAMPO) NOT LIKE '%,0%' THEN (SELECT 'NUMBER('||REPLACE(upper(REPLACE(upper(REPLACE(upper(REPLACE(upper(GFM.TIPO_CAMPO),')','')),',0)','')),'NUMBER(','')),'NUMBER','')||')' FROM DUAL)
   END 
   ||' '||
   CASE WHEN UPPER(GFM.REQUERIDO) like '%SI%' THEN 'NOT NULL' END || ',' 
   AS CAMPO
FROM GFM_GENERA_FICHEROS_MIGRACION GFM
ORDER BY GFM.ORDEN;
 
CURSOR COM IS 
SELECT  
 'EXECUTE IMMEDIATE ''COMMENT ON COLUMN '' || V_ESQUEMA_1 || ''.[TABLA].'||GFM.NOMBRE_CAMPO||' IS '''''||GFM.COMENTARIO||''''''';'
FROM GFM_GENERA_FICHEROS_MIGRACION GFM
ORDER BY GFM.ORDEN;

BEGIN

       DBMS_OUTPUT.PUT_LINE('--/*
--######################################### 
--## AUTOR=Marco Muñoz / Miguel Sanchez
--## FECHA_CREACION=20181126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-4793
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración ''[TABLA]''
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := ''REM01'';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := ''REMMASTER'';       --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLA VARCHAR2(40 CHAR) := ''[TABLA]'';

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''''||V_TABLA||'''' AND OWNER= ''''||V_ESQUEMA_1||'''';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE(''[INFO] TABLA ''||V_ESQUEMA_1||''.''||V_TABLA||'' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.'');

                EXECUTE IMMEDIATE ''DROP TABLE ''||V_ESQUEMA_1||''.''||V_TABLA||'''';
                
        END IF;

        EXECUTE IMMEDIATE ''
        CREATE TABLE ''||V_ESQUEMA_1||''.''||V_TABLA||''
        ('); 
    OPEN C;
    LOOP
        FETCH C INTO V_INPUT;
        EXIT WHEN C%NOTFOUND;
       DBMS_OUTPUT.PUT_LINE(V_INPUT);  


    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )''
        ;

        DBMS_OUTPUT.PUT_LINE(''[INFO] ''||V_ESQUEMA_1||''.''||V_TABLA||'' CREADA'');');
        
    OPEN COM;
    LOOP
        FETCH COM INTO V_INPUT;
        EXIT WHEN COM%NOTFOUND;
       DBMS_OUTPUT.PUT_LINE(V_INPUT);  


    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' 
    IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

                EXECUTE IMMEDIATE ''GRANT ALL ON "''||V_ESQUEMA_1||''"."''||V_TABLA||''" TO "''||V_ESQUEMA_2||''" WITH GRANT OPTION'';

                DBMS_OUTPUT.PUT_LINE(''[INFO] PERMISOS SOBRE LA TABLA ''||V_ESQUEMA_1||''.''||V_TABLA||'' OTORGADOS A ''||V_ESQUEMA_2||''''); 

	END IF;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line(''[ERROR] Se ha producido un error en la ejecucion:''||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line(''-----------------------------------------------------------'');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
');

  EXCEPTION

    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);

    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
