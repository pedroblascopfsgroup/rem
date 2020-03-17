--/*
--#########################################
--## AUTOR=José Antonio Gigante
--## FECHA_CREACION=20200317
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6655
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion, inserción o borrado lógico de suplidos
--## INSTRUCCIONES:  M - Merge (update o insert)
--##				 D - Delete (Borrado lógico)
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_TABLA_2 VARCHAR2(100 CHAR) := 'ACT_TBJ_TRABAJO'; -- Variable para tabla de salida para el borrado
	V_TABLA VARCHAr(100 char) := 'ACT_PSU_PROVISION_SUPLIDO';
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);
	PL_OUTPUT VARCHAR2(32000 CHAR);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6655';
	V_NUM_REGISTROS NUMBER; -- Cuenta los registros actualizados
	
    TYPE T_TABLA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TABLA IS TABLE OF T_TABLA;
    
    M_TABLA T_ARRAY_TABLA := T_ARRAY_TABLA(
      --NUMERO_TRABAJO|SUPLIDO (PSU_IMPORTE)|CONCEPTO|DD_TAD_ID (Tipo de adelanto)|PSU_FECHA----
		T_TABLA('9000159764','131.12','Tasas CEE',2, 'M','17/03/2020')
		,T_TABLA('9000276602','12.05','Tasas CEE',2, 'D','25/01/2020')
    ); 
    V_TMP_TABLA T_TABLA;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZANDO '|| V_TABLA);
	V_NUM_REGISTROS := 0;
    FOR I IN M_TABLA.FIRST .. M_TABLA.LAST
      LOOP
	  V_TMP_TABLA := M_TABLA(I);
	  IF V_TMP_TABLA(5) = 'M' THEN -- MERGE
		V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' PSU
		USING 
			( SELECT 
				TBJ_ID
				FROM '||V_ESQUEMA||'.'||V_TABLA_2||'
				WHERE TBJ_NUM_TRABAJO = '||V_TMP_TABLA(1)||'
			) AUX
    	ON (AUX.TBJ_ID = PSU.TBJ_ID)
    	WHEN MATCHED THEN
			UPDATE SET
            PSU.PSU_IMPORTE = '||V_TMP_TABLA(2)||',
			PSU.USUARIOMODIFICAR = '''||V_USUARIO||''',
			PSU.FECHAMODIFICAR = SYSDATE
		WHEN NOT MATCHED THEN INSERT
			(PSU_ID, TBJ_ID, DD_TAD_ID, PSU_CONCEPTO, PSU_IMPORTE, PSU_FECHA, VERSION, BORRADO, USUARIOCREAR, FECHACREAR )
			VALUES
			(S_'||V_TABLA||'.NEXTVAL, '||V_TMP_TABLA(1)||', '||V_TMP_TABLA(4)||', '''||V_TMP_TABLA(3)||'''
			, '||V_TMP_TABLA(2)||',TO_DATE(SYSDATE, ''DD/MM/YYYY''), 0, 0, '''||V_USUARIO||''', SYSDATE)
			';
	ELSIF V_TMP_TABLA(5) = 'D' THEN -- DELETE
		 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' 
			SET FECHABORRAR = SYSDATE,
			BORRADO = 1,
			USUARIOBORRAR = '''||V_USUARIO||'''
			WHERE TBJ_ID = 
			(	SELECT TBJ_ID FROM '||V_ESQUEMA||'.'||V_TABLA_2||' 
				WHERE TBJ_NUM_TRABAJO = '||V_TMP_TABLA(1)||'
				AND BORRADO = 0
			)
		';
	END IF;
	EXECUTE IMMEDIATE V_SQL;	
		
	END LOOP;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han procesado en total '||SQL%ROWCOUNT||' registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'');
	COMMIT;

	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
      PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------'||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||SQLERRM||CHR(10);
      PL_OUTPUT := PL_OUTPUT ||V_SQL||CHR(10);
      DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
