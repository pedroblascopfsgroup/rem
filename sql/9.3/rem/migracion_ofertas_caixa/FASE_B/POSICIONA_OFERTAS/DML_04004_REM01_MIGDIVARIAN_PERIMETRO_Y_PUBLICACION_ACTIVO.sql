--/*
--######################################### 
--## AUTOR=Dean Ibañez Viño
--## FECHA_CREACION=20201120
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-12051
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización de checks de perímetros y checks de publicación de activos que se hayan vendido
--## 
--## INSTRUCCIONES:  
--## VERSIONES:
--## 		0.1 Versión inicial
--## 		0.2 HREOS-12051 Descomentado para BBVA
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

	V_TABLA_1 VARCHAR2(50 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO'; 		-- Tabla objetivo
	V_TABLA_2 VARCHAR2(50 CHAR) := 'ACT_APU_ACTIVO_PUBLICACION'; 	-- Tabla objetivo
	V_USUARIO VARCHAR2(50 CHAR) := 'MIG_BBVA';
	V_SENTENCIA VARCHAR2(2000 CHAR);
	Vven NUMBER(16,0); -- Activos vendidos
	Vper NUMBER(16,0); -- Activos con perímetro incorrecto
	Vpub NUMBER(16,0); -- Activos con publicación incorrecta

BEGIN

	--DBMS_OUTPUT.PUT_LINE('[INICIO] Comentado para BBVA. Estudiar si es necesario meterlo');

	DBMS_OUTPUT.PUT_LINE('[INICIO] Empezando procedimiento de corrección de checks de Perímetro y Publicación para activos vendidos:');

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando existencia de tablas...');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME IN ('''||V_TABLA_1||''', '''||V_TABLA_2||''') AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 2 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Existen las tablas '||V_TABLA_1||' y '||V_TABLA_2||'.');

		-- Número de activos vendidos:
		V_SQL := 'SELECT COUNT(*) FROM REM01.ACT_ACTIVO ACT 
			WHERE ACT.USUARIOCREAR = '''||V_USUARIO||''' AND
			ACT.DD_SCM_ID = 5
		';
		EXECUTE IMMEDIATE V_SQL INTO Vven;
		DBMS_OUTPUT.PUT_LINE('[INFO] Número de activos de BBVA vendidos: '||to_char(Vven)||'.');
		
		-- Número de activos que cumplen con los checks de Perímetro:
		V_SQL := 'SELECT COUNT(*) FROM REM01.ACT_ACTIVO ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_1||' PAC ON ACT.ACT_ID = PAC.ACT_ID
			WHERE ACT.USUARIOCREAR = '''||V_USUARIO||''' AND
			ACT.DD_SCM_ID = 5 AND
			PAC.PAC_CHECK_GESTIONAR = 1 AND
			PAC.PAC_CHECK_PUBLICAR = 0 AND
			PAC.PAC_CHECK_COMERCIALIZAR = 0 AND
			PAC.PAC_CHECK_FORMALIZAR = 0';
		EXECUTE IMMEDIATE V_SQL INTO Vper;
		DBMS_OUTPUT.PUT_LINE('[INFO] Número de activos de BBVA vendidos que cumplen con el Perímetro: '||to_char(Vper)||'.');
		DBMS_OUTPUT.PUT_LINE('[INFO] Corrigiendo si es necesario...');
		
		-- Corrigiendo:
		V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_1||' T1
			USING(
				SELECT PAC.PAC_ID FROM REM01.ACT_ACTIVO ACT 
				JOIN '||V_ESQUEMA||'.'||V_TABLA_1||' PAC ON ACT.ACT_ID = PAC.ACT_ID
				WHERE ACT.USUARIOCREAR = '''||V_USUARIO||''' AND ACT.DD_SCM_ID = 5 AND (
					PAC.PAC_CHECK_GESTIONAR = 0 OR
					PAC.PAC_CHECK_PUBLICAR = 1 OR
					PAC.PAC_CHECK_COMERCIALIZAR = 1 OR
					PAC.PAC_CHECK_FORMALIZAR = 1
				)
			) AUX
			ON (
				T1.PAC_ID = AUX.PAC_ID
			)
			WHEN MATCHED THEN UPDATE SET
				T1.PAC_CHECK_GESTIONAR = 1,
				T1.PAC_CHECK_PUBLICAR = 0,
				T1.PAC_CHECK_COMERCIALIZAR = 0,
				T1.PAC_CHECK_FORMALIZAR = 0,
				T1.PAC_CHECK_ADMISION = 0,
				T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
				T1.FECHAMODIFICAR = SYSDATE'
		;
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Número de correcciones hechas: '||SQL%ROWCOUNT||'.');


		-- Número de activos vendidos de BBVA que cumplen con los checks de Publicación:
		V_SQL := 'SELECT COUNT(*) FROM REM01.ACT_ACTIVO ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' APU ON ACT.ACT_ID = APU.ACT_ID
			WHERE ACT.USUARIOCREAR = '''||V_USUARIO||''' AND
				ACT.DD_SCM_ID = 5 AND
				APU.APU_CHECK_PUBLICAR_V = 1 AND
				APU.APU_CHECK_OCULTAR_V = 1 AND
				APU.DD_EPV_ID = 4'
		;
		EXECUTE IMMEDIATE V_SQL INTO Vpub;
		DBMS_OUTPUT.PUT_LINE('[INFO] Número de activos de BBVA vendidos que cumplen con la Publicación: '||to_char(Vpub)||'.');
		DBMS_OUTPUT.PUT_LINE('[INFO] Corrigiendo si es necesario...');
		
		-- Corrigiendo:
		V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_2||' T2
			USING(
				SELECT APU.APU_ID FROM REM01.ACT_ACTIVO ACT 
				JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' APU ON ACT.ACT_ID = APU.ACT_ID
				WHERE ACT.USUARIOCREAR = '''||V_USUARIO||''' AND ACT.DD_SCM_ID = 5 AND (
					APU.APU_CHECK_PUBLICAR_V = 0 OR
					APU.APU_CHECK_OCULTAR_V = 0 OR
					APU.DD_EPV_ID <> 4
				)
			) AUX
			ON (
				T2.APU_ID = AUX.APU_ID
			)
			WHEN MATCHED THEN UPDATE SET
				T2.APU_CHECK_PUBLICAR_V = 1,
				T2.APU_CHECK_OCULTAR_V = 1,
				T2.DD_EPV_ID = 4,
				T2.USUARIOMODIFICAR = '''||V_USUARIO||''',
				T2.FECHAMODIFICAR = SYSDATE'
		;
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Número de correcciones hechas: '||SQL%ROWCOUNT||'.');


		-- Comprobación de cumplimiento:
		V_SQL := 'SELECT COUNT(*) FROM REM01.ACT_ACTIVO ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' APU ON ACT.ACT_ID = APU.ACT_ID
			JOIN '||V_ESQUEMA||'.'||V_TABLA_1||' PAC ON ACT.ACT_ID = PAC.ACT_ID
			WHERE ACT.USUARIOCREAR = '''||V_USUARIO||''' AND
				ACT.DD_SCM_ID = 5 AND
				PAC.PAC_CHECK_GESTIONAR = 1 AND
				PAC.PAC_CHECK_PUBLICAR = 0 AND
				PAC.PAC_CHECK_COMERCIALIZAR = 0 AND
				PAC.PAC_CHECK_FORMALIZAR = 0 AND
				APU.APU_CHECK_PUBLICAR_V = 1 AND
				APU.APU_CHECK_OCULTAR_V = 1 AND
				APU.DD_EPV_ID = 4'
		;
		EXECUTE IMMEDIATE V_SQL INTO Vven;
		DBMS_OUTPUT.PUT_LINE('[INFO] Número de activos de BBVA vendidos que cumplen con el Perímetro y la Publicación: '||to_char(Vven)||'.');
		COMMIT;
		DBMS_OUTPUT.PUT_LINE('[FIN] Fin de las correcciones de Perímetro y Publicación para activos vendidos de BBVA.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[ERROR] NO existe alguna/s de las tablas necesarias; '''||V_TABLA_1||''', '''||V_TABLA_2||'''.');
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
