--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180525
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

    V_SQL 		VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA 	VARCHAR2(30 CHAR) := 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(30 CHAR) := 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA 	VARCHAR2(30 CHAR) := 'ACT_GES_DIST_GESTORES';
    ERR_NUM 	NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG 	VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO 	VARCHAR2(50 CHAR):= 'REMVIP-871';
	PL_OUTPUT 	VARCHAR2(32000 CHAR);

    TYPE T_JBV IS TABLE OF VARCHAR2(250 CHAR);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV('03','GIAFORM','01', 'gl03'),
		T_JBV('03','GIAFORM','02', 'montalvo03'),
		T_JBV('03','GIAFORM','03', 'montalvo03'),
		T_JBV('03','GIAFORM','04', 'uniges03'),
		T_JBV('03','GIAFORM','05', 'uniges03'),
		T_JBV('03','GIAFORM','06', 'montalvo03'),
		T_JBV('03','GIAFORM','08', 'montalvo03'),
		T_JBV('03','GIAFORM','07', 'uniges03'),
		T_JBV('03','GIAFORM','09', 'pinos03'),
		T_JBV('03','GIAFORM','18', 'gl03'),
		T_JBV('03','GIAFORM','11', 'montalvo03'),
		T_JBV('03','GIAFORM','12', 'montalvo03'),
		T_JBV('03','GIAFORM','17', 'montalvo03'),
		T_JBV('03','GIAFORM','13', 'gl03'),
		T_JBV('03','GIAFORM','14', 'montalvo03'),
		T_JBV('03','GIAFORM','15', 'montalvo03'),
		T_JBV('03','GIAFORM','16', 'montalvo03'),
		T_JBV('03','GIAFORM','10', 'garsa03'),
		T_JBV('03','GFORM','01', 'lmillan'),
		T_JBV('03','GFORM','01', 'iperezf'),
		T_JBV('03','GFORM','02', 'mganan'),
		T_JBV('03','GFORM','03', 'mganan'),
		T_JBV('03','GFORM','04', 'rmascaros'),
		T_JBV('03','GFORM','05', 'rmascaros'),
		T_JBV('03','GFORM','06', 'mganan'),
		T_JBV('03','GFORM','08', 'mganan'),
		T_JBV('03','GFORM','07', 'jespinosam'),
		T_JBV('03','GFORM','09', 'nbertran'),
		T_JBV('03','GFORM','09', 'jdella'),
		T_JBV('03','GFORM','09', 'sulldemoli'),
		T_JBV('03','GFORM','09', 'gcarles'),
		T_JBV('03','GFORM','18', 'acampos'),
		T_JBV('03','GFORM','11', 'mganan'),
		T_JBV('03','GFORM','12', 'mganan'),
		T_JBV('03','GFORM','17', 'mganan'),
		T_JBV('03','GFORM','13', 'acampos'),
		T_JBV('03','GFORM','13', 'tch'),
		T_JBV('03','GFORM','14', 'jespinosam'),
		T_JBV('03','GFORM','15', 'mganan'),
		T_JBV('03','GFORM','16', 'mganan'),
		T_JBV('03','GFORM','10', 'ptranche'),
		T_JBV('03','GFORM','10', 'jcarbonellm'),
		T_JBV('03','GFORM','10', 'agimenez'),
		T_JBV('03','GFORM','10', 'iss'),
		T_JBV('03','GFORM','10', 'cmartinez'),
		T_JBV('12','GGADM',NULL, 'tecnotra01'),
		T_JBV('12','GIAADMT',NULL, 'ogf02'),
		T_JBV('12','GIAFORM',NULL, 'ogf03')
	); 
	V_TMP_JBV T_JBV;

BEGIN

	PL_OUTPUT := '[INICIO]' || CHR(10);

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	LOOP

		V_TMP_JBV := V_JBV(I);

		V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
			USING (
			    SELECT GES.ID, '''||V_TMP_JBV(2)||''' TIPO_GESTOR, TO_NUMBER(CRA.DD_CRA_CODIGO) COD_CARTERA
			    	, TO_NUMBER(PRV.DD_PRV_CODIGO) COD_PROVINCIA, USU.USU_USERNAME, USU.USU_NOMBRE
			    FROM REMMASTER.USU_USUARIOS USU
			    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_CODIGO = '''||V_TMP_JBV(1)||'''
			    LEFT JOIN '||V_ESQUEMA||'.DD_CMA_COMAUTONOMA CMA ON CMA.DD_CMA_CODIGO = '''||V_TMP_JBV(3)||''' AND CMA.BORRADO = 0
			    LEFT JOIN '||V_ESQUEMA||'.ACT_CMP_COMAUTONOMA_PROVINCIA CMP ON CMP.DD_CMA_ID = CMA.DD_CMA_ID
			    LEFT JOIN REMMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = CMP.DD_PRV_ID
			    LEFT JOIN '||V_ESQUEMA||'.'||V_TABLA||' GES ON GES.COD_CARTERA = TO_NUMBER(CRA.DD_CRA_CODIGO) 
			        AND GES.COD_PROVINCIA = TO_NUMBER(PRV.DD_PRV_CODIGO) AND GES.COD_MUNICIPIO IS NULL 
			        AND GES.COD_POSTAL IS NULL AND GES.TIPO_GESTOR = '''||V_TMP_JBV(2)||'''
			    WHERE USU.BORRADO = 0 AND USU.USU_USERNAME = '''||V_TMP_JBV(4)||'''
			    ) T2
			ON (T1.ID = T2.ID)
			WHEN MATCHED THEN UPDATE SET
			    T1.USERNAME = T2.USU_USERNAME, T1.NOMBRE_USUARIO = T2.USU_NOMBRE
			    , T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
			WHEN NOT MATCHED THEN INSERT (T1.ID, T1.TIPO_GESTOR, T1.COD_CARTERA, T1.COD_PROVINCIA, T1.USERNAME
			    , T1.NOMBRE_USUARIO, T1.USUARIOCREAR, T1.FECHACREAR)
			VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, T2.TIPO_GESTOR, T2.COD_CARTERA, T2.COD_PROVINCIA, T2.USU_USERNAME
			    , T2.USU_NOMBRE, '''||V_USUARIO||''', SYSDATE)';
		EXECUTE IMMEDIATE V_SQL;
		
		IF SQL%ROWCOUNT > 0 THEN
			PL_OUTPUT := PL_OUTPUT || '	[INFO] Se ha fusionado la configuración para la cartera ' || V_TMP_JBV(1) || ', ' || V_TMP_JBV(2) || ', ' || V_TMP_JBV(3) || ', ' || V_TMP_JBV(4) || CHR(10);
		ELSIF SQL%ROWCOUNT = 0 THEN
			PL_OUTPUT := PL_OUTPUT || '	[INFO] No se ha fusionado la configuración para la cartera ' || V_TMP_JBV(1) || ', ' || V_TMP_JBV(2) || ', ' || V_TMP_JBV(3) || ', ' || V_TMP_JBV(4) || CHR(10);
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