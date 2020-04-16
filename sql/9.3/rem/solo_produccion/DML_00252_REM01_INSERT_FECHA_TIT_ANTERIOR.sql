--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200416
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7021
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES: Insertar en la tabla AUX_REMVIP_7021 para modificar la fecha de aprobacion de las valoraciones.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= 'REM_IDX'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo de ID

    V_TABLA VARCHAR2(30 CHAR) := 'AUX_REMVIP_7021';  -- Tabla objetivo
    V_SENTENCIA VARCHAR2(2000 CHAR);
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIMOS EN LA TABLA'||V_ESQUEMA||'.'||V_TABLA||' LOS DATOS.');
	
	V_MSQL := 'SELECT 1 FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN

		V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT USING
			(SELECT ACT.ACT_ID, TO_DATE(AUX.FECHA_ANTERIOR_TITULO, ''yyyymmdd'') AS FECHA_TIT_ANTERIOR
			FROM '||V_ESQUEMA||'.AUX_REMVIP_7021 AUX 
			JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO
			) AUX ON (ACT.ACT_ID = AUX.ACT_ID)
			WHEN MATCHED THEN UPDATE SET
			ACT.ACT_FECHA_TITULO_ANTERIOR = AUX.FECHA_TIT_ANTERIOR,
			ACT.FECHAMODIFICAR = SYSDATE,
			ACT.USUARIOMODIFICAR = ''REMVIP-7021''';
    DBMS_OUTPUT.put_line(V_SQL);    
    DBMS_OUTPUT.put_line(V_MSQL);    
			EXECUTE IMMEDIATE V_SQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

	ELSE
		DBMS_OUTPUT.PUT_LINE('No existe la tabla '''||V_TABLA||'''');
	END IF;

	COMMIT;

	V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''1''); END;';
	EXECUTE IMMEDIATE V_SENTENCIA;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');    

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(V_SQL);    
    DBMS_OUTPUT.put_line(ERR_MSG);    
    ROLLBACK;
    RAISE;        

END;
/
EXIT;
