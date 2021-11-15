--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200210
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-9419
--## PRODUCTO=NO
--## 
--## Finalidad: Calculo de posicionamiento de ofertas.
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo de ID

    TABLA_INEXISTENTE EXCEPTION;

    V_TABLA1 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL';  -- Tabla objetivo
    V_TABLA2 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_DETALLE';  -- Tabla objetivo
    V_TABLA3 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_OFR_TAP_EEC';  -- Tabla objetivo
    V_TABLA4 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_RESUMEN';  -- Tabla objetivo
    V_TABLA5 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_LOG';  -- Tabla objetivo
    V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
    V_SENTENCIA VARCHAR2(2000 CHAR);
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] COMIENZA EL PROCESO DE POSICIONAMIENTO DE OFERTAS.');
    DBMS_OUTPUT.PUT_LINE('[INICIO] PARTE I. Cálculo.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas...');
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME IN ('''||V_TABLA1||''','''||V_TABLA2||''','''||V_TABLA3||''','''||V_TABLA4||''','''||V_TABLA5||''') AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 5 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] Existen las tablas '''||V_TABLA1||''', '''||V_TABLA1||''','''||V_TABLA2||''','''||V_TABLA3||''','''||V_TABLA4||''' y '''||V_TABLA5||'''');

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA1||'';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS < 1 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] '''||V_TABLA1||''' está vacía. Ésta es la tabla de la que parte el cálculo por lo tanto ha de estar rellena con las ofertas a calcular.');

            execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04001_REM01_MIGDIVARIAN_CALCULA_OFERTAS][WARNING] La tabla '||V_TABLA1||' está vacía. Ésta es la tabla de la que parte el cálculo por lo tanto ha de estar rellena con las ofertas a calcular.'' from dual';
		    commit;

        ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO] Comienza el cálculo del estado de las ofertas/expedientes comerciales conforme al Trámite de Venta Apple.');

            V_MSQL := 'SELECT COUNT(DISTINCT OFR_COD_OFERTA) FROM '||V_ESQUEMA||'.'||V_TABLA1||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            DBMS_OUTPUT.PUT_LINE('[INFO] Se realiza la llamada a SP_010_WHEREAMI_COMERCIAL para calcular '||V_NUM_TABLAS||' ofertas (distintas).');

            execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04001_REM01_MIGDIVARIAN_CALCULA_OFERTAS][INFO] Se realizará el cálculo para '||V_NUM_TABLAS||' ofertas (distintas).'' from dual';
            execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04001_REM01_MIGDIVARIAN_CALCULA_OFERTAS][INFO] Llamamos a SP_010_WHEREAMI_COMERCIAL (Ésto se ha logado desde fuera de SP_010_WHEREAMI_COMERCIAL, concretamente en DML_04001_REM01_MIGDIVARIAN_CALCULA_OFERTAS).'' from dual';
            commit;

			REM01.SP_010_WHEREAMI_COMERCIAL(V_USUARIO);

            execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04001_REM01_MIGDIVARIAN_CALCULA_OFERTAS][INFO] Finalizado SP_010_WHEREAMI_COMERCIAL (Ésto se ha logado desde fuera de SP_010_WHEREAMI_COMERCIAL, concretamente en DML_04001_REM01_MIGDIVARIAN_CALCULA_OFERTAS).'' from dual';
            commit;

            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA3||'';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            DBMS_OUTPUT.PUT_LINE('[INFO] Se ha calculado el posicionamiento para '||V_NUM_TABLAS||' ofertas.');

            execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04001_REM01_MIGDIVARIAN_CALCULA_OFERTAS][INFO] Se ha calculado el posicionamiento para '||V_NUM_TABLAS||' ofertas.'' from dual';
            commit;

        END IF;

	ELSE

        V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME IN ('''||V_TABLA5||''') AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS < 1 THEN

            DBMS_OUTPUT.PUT_LINE('[ERROR] NO existe alguna/s de las tablas necesarias; '''||V_TABLA1||''', '''||V_TABLA1||''','''||V_TABLA2||''','''||V_TABLA3||''','''||V_TABLA4||''' y '''||V_TABLA5||'''');
            
            RAISE TABLA_INEXISTENTE;
            
        ELSE

            DBMS_OUTPUT.PUT_LINE('[ERROR] NO existe alguna/s de las tablas necesarias; '''||V_TABLA1||''', '''||V_TABLA1||''','''||V_TABLA2||''','''||V_TABLA3||''','''||V_TABLA4||''' y '''||V_TABLA5||'''');

            execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04001_REM01_MIGDIVARIAN_CALCULA_OFERTAS][ERROR] NO existe alguna/s de las tablas necesarias; '||V_TABLA1||', '||V_TABLA1||','||V_TABLA2||','||V_TABLA3||','||V_TABLA4||' y '||V_TABLA5||'.'' from dual';
            commit;

            RAISE TABLA_INEXISTENTE;
            
        END IF;

	END IF; 

EXCEPTION
    WHEN TABLA_INEXISTENTE THEN
        dbms_output.put_line('[ERROR] Una de las tablas de POSICIONAMIENTO no existe. No se puede continuar.');
        ROLLBACK;
        RAISE;

  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);    
    ROLLBACK;
    RAISE;        

END;
/
EXIT;
