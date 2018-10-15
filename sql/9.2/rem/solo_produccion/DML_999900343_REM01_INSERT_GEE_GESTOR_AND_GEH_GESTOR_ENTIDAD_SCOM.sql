--/*
--##########################################
--## AUTOR=PIER GOTTA 
--## FECHA_CREACION=20181002
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=rREMVIP-2080
--## PRODUCTO=NO
--##
--## Finalidad: Reasignar gestores SCOM
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-2080';
    
 BEGIN

 V_SQL := 'DELETE FROM '||V_ESQUEMA||'.TMP_GEST_GCOM_SCOM';

  EXECUTE IMMEDIATE V_SQL;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han eliminado '||SQL%ROWCOUNT||' registros en la tabla TMP_GEST_GCOM_SCOM');
 
 V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_GEST_GCOM_SCOM (
                ACT_ID,
                USU_ID,
                GEE_ID,
                GEH_ID,
                TIPO_GESTOR
            )
            SELECT 
                ACT.ACT_ID
                , USU.USU_ID
                , '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL GEE_ID
                , '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL GEH_ID
                , GEST.TIPO_GESTOR
            FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
            JOIN '||V_ESQUEMA||'.V_GESTORES_ACTIVO GEST ON ACT.ACT_ID = GEST.ACT_ID AND GEST.TIPO_GESTOR = ''SCOM''
            JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEST.USERNAME
            AND ACT.BORRADO = 0 
	    AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''01'') 
	    AND ACT.DD_TCR_ID = (SELECT DD_TCR_ID FROM '||V_ESQUEMA||'.DD_TCR_TIPO_COMERCIALIZAR WHERE DD_TCR_CODIGO = ''02'') 
	    AND ACT.DD_SCM_ID IN (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO <> ''05'')
		  ';
		  

  EXECUTE IMMEDIATE V_SQL;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la tabla TMP_GEST_GCOM_SCOM');

 V_SQL := 'DELETE FROM '||V_ESQUEMA||'.TMP_GEST_GCOM_SCOM WHERE ACT_ID IN(
	   SELECT GAC.ACT_ID FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC, '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE WHERE GEE.GEE_ID = GAC.GEE_ID AND GEE.USUARIOCREAR = ''REMVIP-2080''
	   AND GEE.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SCOM''))';

  EXECUTE IMMEDIATE V_SQL;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han eliminado '||SQL%ROWCOUNT||' registros en la tabla TMP_GEST_GCOM_SCOM');

 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH 
            USING (SELECT DISTINCT GAH.GEH_ID, GAH.ACT_ID FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH 
            	JOIN '||V_ESQUEMA||'.TMP_GEST_GCOM_SCOM TMP ON TMP.ACT_ID = GAH.ACT_ID
           	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = TMP.ACT_ID AND TMP.TIPO_GESTOR = ''SCOM''
           	AND ACT.BORRADO = 0 
		AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''01'') 
	  	AND ACT.DD_TCR_ID = (SELECT DD_TCR_ID FROM DD_TCR_TIPO_COMERCIALIZAR WHERE DD_TCR_CODIGO = ''02'') 
	    	AND ACT.DD_SCM_ID IN (SELECT DD_SCM_ID FROM DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO <> ''05'')) AUX
            ON (AUX.GEH_ID = GEH.GEH_ID)
            WHEN MATCHED THEN UPDATE SET GEH.GEH_FECHA_HASTA = SYSDATE, GEH.USUARIOMODIFICAR = ''REMVIP-2080'', GEH.FECHAMODIFICAR = SYSDATE
            WHERE GEH.GEH_FECHA_HASTA IS NULL AND GEH.USUARIOCREAR != ''REMVIP-2080'' 
            AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SCOM'')';
		  

  EXECUTE IMMEDIATE V_SQL;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han updateado '||SQL%ROWCOUNT||' registros en la tabla GEH_GESTOR_ENTIDAD_HIST');

 V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD (
	            GEE_ID,
	            USU_ID,
	            DD_TGE_ID,
	            VERSION,
	            USUARIOCREAR,
	            FECHACREAR,
	            BORRADO)
	        SELECT
	            TMP.GEE_ID,
	            TMP.USU_ID,
	            TGE.DD_TGE_ID,
	            0,
	            ''REMVIP-2080'',
	            SYSDATE,
	            0
	        FROM '||V_ESQUEMA||'.TMP_GEST_GCOM_SCOM TMP
	        JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = TMP.TIPO_GESTOR
            WHERE TMP.TIPO_GESTOR = ''SCOM''';
		  

  EXECUTE IMMEDIATE V_SQL;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la tabla GEE_GESTOR_ENTIDAD');

 V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO (
	            GEE_ID,
	            ACT_ID)
	        SELECT
	            TMP.GEE_ID,
	            TMP.ACT_ID
	        FROM '||V_ESQUEMA||'.TMP_GEST_GCOM_SCOM TMP WHERE TMP.TIPO_GESTOR = ''SCOM''';
		  

  EXECUTE IMMEDIATE V_SQL;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la tabla GAC_GESTOR_ADD_ACTIVO');
  
 V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (
	            GEH_ID,
	            USU_ID,
	            DD_TGE_ID,
	            GEH_FECHA_DESDE,
	            GEH_FECHA_HASTA,
	            VERSION,
	            USUARIOCREAR,
	            FECHACREAR,
	            BORRADO)
	        SELECT
	            TMP.GEH_ID,
	            TMP.USU_ID,
	            TGE.DD_TGE_ID,
	            SYSDATE AS GEH_FECHA_DESDE,
	            NULL AS GEH_FECHA_HASTA,
	            1 AS VERSION,
	            ''REMVIP-2080'' AS USUARIOCREAR,
	            SYSDATE AS FECHACREAR,
	            0 AS BORRADO
	        FROM '||V_ESQUEMA||'.TMP_GEST_GCOM_SCOM TMP
	        JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = TMP.TIPO_GESTOR
            WHERE TMP.TIPO_GESTOR = ''SCOM''';
  
  EXECUTE IMMEDIATE V_SQL;
 
  DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la tabla GEH_GESTOR_ENTIDAD_HIST');

 V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO (
	            GEH_ID,
	            ACT_ID)
	        SELECT
	            TMP.GEH_ID,
	            TMP.ACT_ID
	        FROM '||V_ESQUEMA||'.TMP_GEST_GCOM_SCOM TMP
            WHERE TMP.TIPO_GESTOR LIKE ''SCOM''';
  
  EXECUTE IMMEDIATE V_SQL;
 
  DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la tabla GAH_GESTOR_ACTIVO_HISTORICO');

 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
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
