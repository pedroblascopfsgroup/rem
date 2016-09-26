--/*
--##########################################
--## AUTOR= RAFAEL ARACIL LOPEZ
--## FECHA_CREACION=20160921
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-851
--## PRODUCTO=NO
--## 
--## Finalidad: Crear las tablas de INTERFAZ REM
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE

    V_ESQUEMA_MR VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    V_SQL VARCHAR2(4000 CHAR);
    V_MSQL_DROP VARCHAR2(4000 CHAR);
    V_MSQL_DROP_SEC VARCHAR2(4000 CHAR);
    V_TABLA VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;

    -- Otras variables

 BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');

V_TABLA :='APR_AUX_I_RU_INMO_ARR';
	DBMS_OUTPUT.PUT_LINE(' ');
	DBMS_OUTPUT.PUT_LINE('[INFO] crear Tabla: '||V_TABLA);
	--Comprobar si existe
V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA_MR||'''';
 	--DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

V_MSQL := 'CREATE TABLE '||V_ESQUEMA_MR||'.'||V_TABLA||' (
CODIGO_AGR_INMUEBLE NUMBER(9)
,IDENTIFICADOR_ACTIVO NUMBER(9)
,NUMERO_CONTRATO_ARR NUMBER(9)
,FECHA_INICIO_CONTRATO DATE
,FECHA_FIN_CONTRATO DATE
,IMPORTE_RENTA_ACTUAL NUMBER(15,2)
,CODIGO_SITUACION_CONTRATO NUMBER(2)
,FECHA_RES_CONTRATO DATE
)';

IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('    [INFO] '||V_TABLA||' no existe');
		--DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('    [INFO] TABLA '||V_TABLA||' creada');
ELSE
		DBMS_OUTPUT.PUT_LINE('    [INFO] La tabla '||V_TABLA||' ya existe');
		V_MSQL_DROP := 'DROP TABLE '||V_ESQUEMA_MR||'.'||V_TABLA;    
    		--DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL_DROP);
	EXECUTE IMMEDIATE V_MSQL_DROP;
		DBMS_OUTPUT.PUT_LINE('    [INFO] Borrada la tabla '||V_TABLA);
		--DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('    [INFO] TABLA '||V_TABLA||' creada');
END IF; 


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





