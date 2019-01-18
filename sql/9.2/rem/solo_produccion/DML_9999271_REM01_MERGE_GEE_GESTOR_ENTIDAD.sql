--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2975
--## PRODUCTO=NO
--## Finalidad:
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_TABLA VARCHAR2(25 CHAR):= 'GEE_GESTOR_ENTIDAD';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2975';
    
 BEGIN
 
 	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
			  USING (
			  	SELECT GEE.GEE_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' GEE
			  	JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GEE.GEE_ID = GAC.GEE_ID
			  	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GAC.ACT_ID
			  	JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''03''
			  	JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION LOC ON LOC.ACT_ID = ACT.ACT_ID
    			JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE ON BIE.BIE_LOC_ID = LOC.BIE_LOC_ID
			  	JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = BIE.DD_PRV_ID AND (DD_PRV_CODIGO = ''35'' OR DD_PRV_CODIGO = ''38'')
			  	JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_CODIGO = ''PTEC''
			    ) T2
			  ON (T1.GEE_ID = T2.GEE_ID)
			  WHEN MATCHED THEN UPDATE 
			    SET T1.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
			                    JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID AND PVE.PVE_COD_REM = 4491
			                    WHERE PVC.PVC_PRINCIPAL = 1)
			        ,T1.USUARIOMODIFICAR = ''REMVIP-2975''
			        ,T1.FECHAMODIFICAR = SYSDATE
			  ';
    				
	EXECUTE IMMEDIATE V_SQL;
      
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_TABLA||' actualizada correctamente ');
      
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
