--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180925
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-783
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##   
--## INSTRUCCIONES:  
--## VERSIONES:
--##   0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(30 CHAR):= 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(30 CHAR):= 'DD_MRF_MAIL_REJ_FACTURAS';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR):= 'REMVIP-783';
	PL_OUTPUT VARCHAR2(32000 CHAR);

    TYPE T_JBV IS TABLE OF VARCHAR2(250 CHAR);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV('01','noreply.rem@haya.es','abotella@haya.es','lgomezc@haya.es, dgutierrez@haya.es, guardias.rem@pfsgroup.es, gustavo.mora@pfsgroup.es','Retorno UVEM de detalle de gastos con IVA ','Se adjunta excel con retorno UVEM de detalle de gastos con IVA.','URFACREJ.xlsx')
	); 
	V_TMP_JBV T_JBV;

BEGIN

	PL_OUTPUT := '[INICIO]' || CHR(10);

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	LOOP

		V_TMP_JBV := V_JBV(I);

		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (DD_MRF_ID,DD_MRF_CODIGO,DD_MRF_DE,DD_MRF_PARA,DD_MRF_CC,DD_MRF_ASUNTO
				,DD_MRF_CUERPO,DD_MRF_ADJUNTO,USUARIOCREAR,FECHACREAR) 
			SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, '''||V_TMP_JBV(1)||''', '''||V_TMP_JBV(2)||''','''||V_TMP_JBV(3)||''','''||V_TMP_JBV(4)||''','''||V_TMP_JBV(5)||'''
				,'''||V_TMP_JBV(6)||''','''||V_TMP_JBV(7)||''','''||V_USUARIO||''', SYSDATE
			FROM DUAL
			WHERE NOT EXISTS (
					SELECT 1
					FROM '||V_ESQUEMA||'.'||V_TABLA||' MRF
					WHERE MRF.DD_MRF_CODIGO = '''||V_TMP_JBV(1)||'''
				)';
		EXECUTE IMMEDIATE V_SQL;
		
		IF SQL%ROWCOUNT = 1 THEN
			PL_OUTPUT := PL_OUTPUT || '	[INFO] Se ha creado el correo tipo para ' || V_TMP_JBV(4) || CHR(10);
		ELSIF SQL%ROWCOUNT = 0 THEN
			PL_OUTPUT := PL_OUTPUT || '	[INFO] Ya existe correo tipo para ' || V_TMP_JBV(4) || CHR(10);
		END IF;

	END LOOP;

	PL_OUTPUT := PL_OUTPUT || '[FIN]' || CHR(10);

	COMMIT;

	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

EXCEPTION
    WHEN OTHERS THEN
 PL_OUTPUT := PL_OUTPUT ||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE) || CHR(10);
 PL_OUTPUT := PL_OUTPUT ||'-----------------------------------------------------------' || CHR(10);
 PL_OUTPUT := PL_OUTPUT ||SQLERRM || CHR(10);
 DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
 ROLLBACK;
 RAISE;
END;
/
EXIT;