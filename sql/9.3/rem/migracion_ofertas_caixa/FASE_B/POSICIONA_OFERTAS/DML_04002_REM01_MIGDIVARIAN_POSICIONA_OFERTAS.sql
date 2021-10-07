--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200210
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-9419
--## PRODUCTO=NO
--## 
--## Finalidad: Posicionamiento de ofertas.
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

    V_TABLA1 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL';  -- Tabla objetivo
    V_TABLA2 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_DETALLE';  -- Tabla objetivo
    V_TABLA3 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_OFR_TAP_EEC';  -- Tabla objetivo
    V_TABLA4 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_RESUMEN';  -- Tabla objetivo
    V_TABLA5 VARCHAR2(50 CHAR) := 'POSICIONAMIENTO_COMERCIAL_LOG';  -- Tabla objetivo
    V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
    V_SENTENCIA VARCHAR2(2000 CHAR);
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] COMIENZA EL PROCESO DE POSICIONAMIENTO DE OFERTAS.');
    DBMS_OUTPUT.PUT_LINE('[INICIO] PARTE II. Reposicionar.');

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas...');
	
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME IN ('''||V_TABLA1||''','''||V_TABLA2||''','''||V_TABLA3||''','''||V_TABLA4||''','''||V_TABLA5||''') AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 5 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] Existen las tablas '||V_TABLA1||','||V_TABLA2||','||V_TABLA3||','||V_TABLA4||','||V_TABLA5||'');

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.POSICIONAMIENTO_COMERCIAL_OFR_TAP_EEC WHERE PROCESADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS < 1 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] No hay expedientes a procesar. Por favor, revisar POSICIONAMIENTO_COMERCIAL_OFR_TAP_EEC (Procesado) o que POSICIONAMIENTO_COMERCIAL esté rellena.');
            DBMS_OUTPUT.PUT_LINE('[INFO] Si POSICIONAMIENTO_COMERCIAL_OFR_TAP_EEC está vacía. Habrá que asegurarse de que hemos cargado previamente POSICIONAMIENTO_COMERCIAL y se ha calculado el posicionamiento en SP_010_WHEREAMI_COMERCIAL.');

            execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04002_REM01_MIGDIVARIAN_POSICIONA_OFERTAS][WARNING] No hay expedientes a procesar. Por favor, revisar POSICIONAMIENTO_COMERCIAL_OFR_TAP_EEC (Procesado) o que POSICIONAMIENTO_COMERCIAL esté rellena.'' from dual';
            execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04002_REM01_MIGDIVARIAN_POSICIONA_OFERTAS][WARNING] Si POSICIONAMIENTO_COMERCIAL_OFR_TAP_EEC está vacía. Habrá que asegurarse de que hemos cargado previamente POSICIONAMIENTO_COMERCIAL y se ha calculado el posicionamiento en SP_010_WHEREAMI_COMERCIAL.'' from dual';	
            commit;

        ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO] Comienza el reposicionamiento de expedientes. Perímetro > POSICIONAMIENTO_COMERCIAL_OFR_TAP_EEC.');
			DBMS_OUTPUT.PUT_LINE('[INFO] Se irán tirando en tandas de 100 a AVANCE_TRAMITE_SIN_PL_OUTPUT.');

            execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04002_REM01_MIGDIVARIAN_POSICIONA_OFERTAS][INFO] Llamamos a SP_011_POSICIONA_COMERCIAL_V2 (Ésto se ha logado desde fuera de SP_011_POSICIONA_COMERCIAL_V2, concretamente en DML_04002_REM01_MIGDIVARIAN_POSICIONA_OFERTAS).'' from dual';
            commit;

			REM01.SP_011_POSICIONA_COMERCIAL_V2(V_USUARIO);

            execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04002_REM01_MIGDIVARIAN_POSICIONA_OFERTAS][FIN] Finalizado SP_011_POSICIONA_COMERCIAL_V2 (Ésto se ha logado desde fuera de SP_011_POSICIONA_COMERCIAL_V2, concretamente en DML_04002_REM01_MIGDIVARIAN_POSICIONA_OFERTAS).'' from dual';
            commit;

            v_msql := '
            select count(1)
            from '||v_esquema||'.POSICIONAMIENTO_COMERCIAL_OFR_TAP_EEC pos
            inner join '||v_esquema||'.ofr_ofertas ofr
            on ofr.ofr_num_oferta = pos.ofr_cod_oferta
            inner join '||v_esquema||'.eco_expediente_comercial eco
            on eco.ofr_id = ofr.ofr_id
            left join '||v_esquema||'.dd_eec_est_exp_comercial eecsupuesto
            on eecsupuesto.dd_eec_codigo = pos.dd_eec_codigo
            left join '||v_esquema||'.dd_eec_est_exp_comercial eccreal
            on eccreal.dd_eec_id = eco.dd_eec_id
            where eecsupuesto.dd_eec_id <> eccreal.dd_eec_id
            ';
            execute immediate v_msql into v_num_tablas;

            IF V_NUM_TABLAS < 1 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] Todos los Expedientes procesados tienen su Estado asignado correctamente en funcion al posicionamiento.');

                execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_05002_REM01_MIGDIVARIAN_POSICIONA_TRABAJOS][INFO] Todos los Expedientes procesados tienen su Estado asignado correctamente en funcion al posicionamiento.'' from dual';
                commit;

            ELSE

                DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||' Expedientes procesados no tienen su Estado asignado correctamente en funcion al posicionamiento.');

                execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_05002_REM01_MIGDIVARIAN_POSICIONA_TRABAJOS][WARNING] '||V_NUM_TABLAS||' Expedientes procesados no tienen su Estado asignado correctamente en funcion al posicionamiento.'' from dual';
                commit;

            END IF;

            V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA3||' where procesado = ''0''';
            EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

            IF V_NUM_TABLAS < 1 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] Se han procesado TODAS las ofertas. (Se ha comprobado mirando el campo PROCESADO de la tabla '''||V_TABLA3||'''');

                execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04002_REM01_MIGDIVARIAN_POSICIONA_OFERTAS][INFO] Se han procesado TODAS las ofertas. (Se ha comprobado mirando el campo PROCESADO de la tabla '||V_TABLA3||').'' from dual';
                commit;

            ELSE

                DBMS_OUTPUT.PUT_LINE('[WARNING] El proceso de posicionamiento ha finalizado pero quedan '||V_NUM_TABLAS||' ofertas por procesar. (Se ha comprobado mirando el campo PROCESADO de la tabla '''||V_TABLA3||'''');

                execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04002_REM01_MIGDIVARIAN_POSICIONA_OFERTAS][WARNING] El proceso de posicionamiento ha finalizado pero quedan '||V_NUM_TABLAS||' ofertas por procesar. (Se ha comprobado mirando el campo PROCESADO de la tabla '||V_TABLA3||').'' from dual';
                commit;

            END IF;

		END IF;

	ELSE

		DBMS_OUTPUT.PUT_LINE('[ERROR] NO existe alguna/s de las tablas necesarias; '''||V_TABLA1||''', '''||V_TABLA1||''','''||V_TABLA2||''','''||V_TABLA3||''','''||V_TABLA4||''' y '''||V_TABLA5||'''');

        execute immediate 'insert into '||v_esquema||'.'||V_TABLA5||' (hecho) select ''[DML_04002_REM01_MIGDIVARIAN_POSICIONA_OFERTAS][ERROR] NO existe alguna/s de las tablas necesarias; '||V_TABLA1||', '||V_TABLA1||','||V_TABLA2||','||V_TABLA3||','||V_TABLA4||' y '||V_TABLA5||'.'' from dual';
        commit;

	END IF; 

EXCEPTION
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
