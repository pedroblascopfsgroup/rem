--/*
--#########################################
--## AUTOR=José Antonio Gigante
--## FECHA_CREACION=20200310
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6626
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizacion registros 
--## INSTRUCCIONES:  
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
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6626';
	V_NUM_REGISTROS NUMBER; -- Cuenta los registros actualizados
	
    TYPE T_TABLA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_TABLA IS TABLE OF T_TABLA;

    M_TABLA T_ARRAY_TABLA := T_ARRAY_TABLA(
      --|TBJ_NUM_TRABAJO|-----------------------
	    T_TABLA('9000248498')
		,T_TABLA('9000248499')
		,T_TABLA('9000248501')
		,T_TABLA('9000222555')
		,T_TABLA('9000222557')
		,T_TABLA('9000180526')
		,T_TABLA('9000180552')
		,T_TABLA('9000180531')
    ); 
    V_TMP_TABLA T_TABLA;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INFO]: MARCANDO BORRADO LÓGICO '|| V_TABLA);
	V_NUM_REGISTROS := 0;
    FOR I IN M_TABLA.FIRST .. M_TABLA.LAST
      LOOP
	  V_TMP_TABLA := M_TABLA(I);

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
		EXECUTE IMMEDIATE V_SQL;	
		V_NUM_REGISTROS := V_NUM_REGISTROS + 1;
	END LOOP;
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han gestionado en total '||V_NUM_REGISTROS||' registros en la tabla '||V_ESQUEMA||'.'||V_TABLA||'');
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
