--/*
--#########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20190404
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-3870
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar la tabla GEE
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.    
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
BEGIN	

   DBMS_OUTPUT.PUT_LINE('[INFO] INICIO DEL PROCESO DE ACTUALIZACION');			         
			                                       
      V_SQL := '
     MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
	   USING (
	    SELECT GEE.GEE_ID FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
	    LEFT JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
	    LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GAC.ACT_ID  AND ACT.BORRADO = 0
	    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
	    LEFT JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
	    WHERE SCR.DD_SCR_CODIGO = ''138'' AND TGE.DD_TGE_CODIGO =''SUPACT'' AND GEE.BORRADO = 0
	) AUX
	   ON (GEE.GEE_ID = AUX.GEE_ID)
	   WHEN MATCHED THEN UPDATE SET 
	    GEE.USU_ID = (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''manpuapple'')
	    , GEE.USUARIOMODIFICAR = ''REMVIP-3870''
	    , GEE.FECHAMODIFICAR = SYSDATE
      ';
      
      DBMS_OUTPUT.PUT_LINE(V_SQL);		            
     EXECUTE IMMEDIATE V_SQL;   
      
      V_SQL := '
     MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
	   USING (
	    SELECT GEE.GEE_ID FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
	    LEFT JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
	    LEFT JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = GAC.ACT_ID  AND ACT.BORRADO = 0
	    LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
	    LEFT JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
	    WHERE SCR.DD_SCR_CODIGO = ''138'' AND TGE.DD_TGE_CODIGO =''SPUBL'' AND GEE.BORRADO = 0
	) AUX
	   ON (GEE.GEE_ID = AUX.GEE_ID)
	   WHEN MATCHED THEN UPDATE SET 
	    GEE.USU_ID = (SELECT USU.USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = ''manpuapple'')
	    , GEE.USUARIOMODIFICAR = ''REMVIP-3870''
	    , GEE.FECHAMODIFICAR = SYSDATE
      ';
      
	    DBMS_OUTPUT.PUT_LINE(V_SQL);		               
	    EXECUTE IMMEDIATE V_SQL; 
	    COMMIT;
  
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD COMPUTE STATISTICS');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD ANALIZADA.');
      
    DBMS_OUTPUT.PUT_LINE('[FIN] LA TABLA GEE_GESTOR_ENTIDAD SE HA ACTUALIZADO CORRECTAMENTE');
 
 
EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;

/

EXIT
