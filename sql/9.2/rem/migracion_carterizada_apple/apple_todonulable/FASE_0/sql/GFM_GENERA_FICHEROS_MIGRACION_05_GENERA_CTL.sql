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
V_MAPEO VARCHAR2(1024 CHAR);
V_TEXTO VARCHAR2(1024 CHAR);
V_INPUT VARCHAR2(1024 CHAR);

CURSOR C IS
WITH TIPO as (
    SELECT ORDEN, CASE  WHEN UPPER(TIPO_CAMPO) LIKE '%NUMBER%' THEN 'NUMBER' WHEN UPPER(TIPO_CAMPO) LIKE '%DATE%' THEN TIPO_CAMPO  WHEN UPPER(TIPO_CAMPO) LIKE '%CHAR%' THEN 'CHAR' END AS TIPO FROM GFM_GENERA_FICHEROS_MIGRACION

),
TAMANO AS (
    SELECT ORDEN,
    CASE 
        WHEN TIPO_CAMPO LIKE '%NUMBER%' AND TIPO_CAMPO LIKE '%,%' THEN 
            to_char(REPLACE(REPLACE(SUBSTR(TIPO_CAMPO, 1, INSTR(REPLACE(TIPO_CAMPO,'NUMBER (',''),',')-1),'NUMBER(',''),')','')+1)
        WHEN TIPO_CAMPO LIKE '%NUMBER%' THEN 
            to_char(REPLACE(REPLACE(REPLACE(TIPO_CAMPO,'NUMBER (',''),'NUMBER(',''),')','')+1)
        WHEN TIPO_CAMPO LIKE '%CHAR%' THEN 
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TIPO_CAMPO,'VARCHAR (',''),'VARCHAR2(',''),'VARCHAR(',''),'CHAR(',''),')',''),' CHAR','')
        WHEN TIPO_CAMPO LIKE '%DATE%' THEN 
            '8' 
    END AS TAMANO,
    CASE 
         WHEN TIPO_CAMPO LIKE '%NUMBER%' AND TIPO_CAMPO LIKE '%,%' THEN  
            REPLACE(SUBSTR(TIPO_CAMPO, (INSTR(TIPO_CAMPO,',')+1),LENGTH(TIPO_CAMPO)),')','')
        END AS DECI

FROM GFM_GENERA_FICHEROS_MIGRACION

),
TAMANO_ACUM AS (
    SELECT 
    ORDEN,
    (SELECT sum(tamano) from TAMANO TAM  where TAM.orden<=GFM.orden) AS ACUM
    FROM GFM_GENERA_FICHEROS_MIGRACION GFM

)
SELECT  GFM.NOMBRE_CAMPO || ' POSITION(' || (ACUM.ACUM - TAM.TAMANO+1)  || ':' || ACUM.ACUM  ||') ' || 

CASE 
        WHEN TIPO_CAMPO LIKE '%NUMBER%' THEN 
            'INTEGER EXTERNAL '
        WHEN TIPO_CAMPO LIKE '%CHAR%' THEN 
            'CHAR ' 
        WHEN TIPO_CAMPO LIKE '%DATE (DDMMYYYY)%' THEN 
           'DATE ''DDMMYYYY'' '
        WHEN TIPO_CAMPO LIKE '%DATE' or TIPO_CAMPO LIKE '%DATE (YYYYMMDD)%' THEN 
           'DATE ''YYYYMMDD'' '
    END || 
CASE 
        WHEN UPPER(GFM.REQUERIDO) LIKE '%NO%' THEN 
            'NULLIF('||GFM.NOMBRE_CAMPO||'=BLANKS) '
    END ||
    CASE 
        WHEN TIPO_CAMPO LIKE '%NUMBER%' THEN 
            CASE 
            WHEN TAM.DECI  is null  THEN 
            '"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:'||GFM.NOMBRE_CAMPO||'),'';'','' ''), ''\"'',''''),'''''''',''''),2,'||(TAM.TAMANO-1)||'))",'
            ELSE
            '"CASE WHEN (:'||GFM.NOMBRE_CAMPO||') IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:'||GFM.NOMBRE_CAMPO||',1,'||(TAM.TAMANO-TAM.DECI)||')||'',''||SUBSTR(:'||GFM.NOMBRE_CAMPO||','||(TAM.TAMANO-TAM.DECI+1)||','||TAM.DECI||')),'';'','' ''), ''\"'',''''),'''''''','''')) END",'
            END   
        WHEN TIPO_CAMPO LIKE '%CHAR%' THEN 
            '"REPLACE(REPLACE(REPLACE(TRIM(:'||GFM.NOMBRE_CAMPO||'),'';'','' ''), ''\"'',''''),'''''''','''')",'
        WHEN TIPO_CAMPO LIKE '%DATE%' THEN 
           '"REPLACE(:'||GFM.NOMBRE_CAMPO||', ''00000000'', '''')",'
    END 
FROM GFM_GENERA_FICHEROS_MIGRACION GFM
JOIN TIPO TIPO ON TIPO.ORDEN=GFM.ORDEN
JOIN TAMANO TAM ON TAM.ORDEN=GFM.ORDEN
JOIN TAMANO_ACUM ACUM ON ACUM.ORDEN=GFM.ORDEN
ORDER BY GFM.ORDEN ;
 


BEGIN



       DBMS_OUTPUT.PUT_LINE('OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE ''./CTLs_DATs/DATs/[MAPEO].dat''
BADFILE ''./CTLs_DATs/bad/[MAPEO].bad''
DISCARDFILE ''./CTLs_DATs/rejects/[MAPEO].bad''
INTO TABLE REM01.[TABLA]
TRUNCATE
TRAILING NULLCOLS
('); 
    OPEN C;
    LOOP
        FETCH C INTO V_INPUT;
        EXIT WHEN C%NOTFOUND;
       DBMS_OUTPUT.PUT_LINE(V_INPUT);  


    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('VALIDACION CONSTANT "0"	
)
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
