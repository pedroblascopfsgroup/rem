--/*
--######################################### 
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210820
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.8
--## INCIDENCIA_LINK=HREOS-14936
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--## 		0.1 Versión inicial HREOS-11893
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

	V_ESQUEMA VARCHAR2(25 CHAR)		:= 'REM01'; 	-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR)	:= 'REMMASTER';
	V_MSQL VARCHAR2(4000 CHAR);
	V_TABLA VARCHAR2(30 CHAR) 		:= 'MIG2_CAIXA_VOLUMETRIA_TABLAS';
	V_TABLA_2 VARCHAR2(30 CHAR) 	:= 'MIG2_RELACION_DAT_MIG_MODELO';  
	V_TABLA_3 VARCHAR2(30 CHAR) 	:= 'ALL_TABLES';
    V_COUNT_MIG NUMBER(5);
    TYPE valCurTyp IS REF CURSOR;
    v_val_cursor valCurTyp;
	v_stmt_val VARCHAR2(4000 CHAR);
	err_num NUMBER;
	err_msg VARCHAR2(2048);	
	vNOMBRE_INTERFAZ 	REM01.MIG2_RELACION_DAT_MIG_MODELO.FICHERO_DAT%TYPE;
	vNOMBRE_TABLA 		REM01.MIG2_RELACION_DAT_MIG_MODELO.TABLA_MIG%TYPE;
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] - Iniciamos proceso');

	DBMS_OUTPUT.PUT_LINE('[INFO] - Truncamos la tabla '||V_ESQUEMA||'.'||V_TABLA||'');

	V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
    EXECUTE IMMEDIATE V_MSQL;
   

	DBMS_OUTPUT.PUT_LINE('[INFO] - Tabla '||V_ESQUEMA||'.'||V_TABLA||' truncada');
	
		v_stmt_val := 'SELECT DISTINCT FICHERO_DAT, TABLA_MIG FROM '||V_ESQUEMA||'.'||V_TABLA_2||'';

	DBMS_OUTPUT.PUT_LINE('[INFO] EMPEZAMOS CURSOR');
	DBMS_OUTPUT.PUT_LINE('[INFO] - INSERTAMOS EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'');
	OPEN v_val_cursor FOR v_stmt_val;
		LOOP
			FETCH v_val_cursor INTO vNOMBRE_INTERFAZ, vNOMBRE_TABLA;
			EXIT WHEN v_val_cursor%NOTFOUND;
		
		V_MSQL := 'SELECT COUNT(1) FROM '||V_TABLA_3||' WHERE TABLE_NAME = '''||vNOMBRE_TABLA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_COUNT_MIG;

			IF V_COUNT_MIG > 0 THEN 
				DBMS_OUTPUT.PUT_LINE(vNOMBRE_TABLA);
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (MIG_NOMBRE_INTERFAZ, MIG_CANTIDAD_REGISTROS, MIG_CANTIDAD_REGISTROS_VALIDOS, FECHA) VALUES
				('''||vNOMBRE_INTERFAZ||''', (SELECT COUNT(1) FROM '||vNOMBRE_TABLA||'), (SELECT COUNT(1) FROM '||vNOMBRE_TABLA||' WHERE VALIDACION = 0), SYSDATE)';		
				EXECUTE IMMEDIATE V_MSQL;
			END IF;

	    END LOOP;

    CLOSE v_val_cursor;

	DBMS_OUTPUT.PUT_LINE('[INFO] - PROCESO FINALIZADO');

COMMIT;

EXCEPTION
	WHEN OTHERS THEN 
	DBMS_OUTPUT.PUT_LINE('KO!');
	ERR_NUM := SQLCODE;
	ERR_MSG := SQLERRM;
	DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
	DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	DBMS_OUTPUT.put_line(ERR_MSG);
	DBMS_OUTPUT.put_line(V_MSQL);
	ROLLBACK;
	RAISE;
END;
/
EXIT;
