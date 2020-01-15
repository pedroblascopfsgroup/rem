--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200114
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6008
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
   ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-6008';
   V_SQL VARCHAR2(4000 CHAR);	
   V_PAR VARCHAR( 1024 CHAR );
   V_RET VARCHAR( 1024 CHAR );  

   V_GEE VARCHAR( 15 CHAR ) := '0';  
   V_GEH VARCHAR( 15 CHAR ) := '0';  
  
BEGIN
  
   DBMS_OUTPUT.put_line('[INICIO]');



	V_SQL := ' 

		SELECT DISTINCT GEE.GEE_ID, GEH.GEH_ID
		FROM REM01.GEE_GESTOR_ENTIDAD GEE,
		REMMASTER.DD_TGE_TIPO_GESTOR TGE,
		REM01.GEH_GESTOR_ENTIDAD_HIST GEH,
		REM01.GAH_GESTOR_ACTIVO_HISTORICO GAH,
		REM01.ACT_ACTIVO ACT,
		REM01.GAC_GESTOR_ADD_ACTIVO GAC,
		REMMASTER.USU_USUARIOS USU
		WHERE 1 = 1
		AND GEE.DD_TGE_ID = TGE.DD_TGE_ID
		AND GEH.DD_TGE_ID = GEE.DD_TGE_ID
		AND GEH.USU_ID    = GEE.USU_ID
		AND GAH.GEH_ID    = GEH.GEH_ID
		AND GAH.ACT_ID = ACT.ACT_ID
		AND ACT_NUM_ACTIVO = ''6998373''
		AND TGE.DD_TGE_CODIGO = ''HAYAGBOINM''
		AND GAC.GEE_ID = GEE.GEE_ID
		AND GAC.ACT_ID = ACT.ACT_ID
		AND GEE.USU_ID = USU.USU_ID	
	      ';
	
	EXECUTE IMMEDIATE V_SQL INTO V_GEE, V_GEH;


	DBMS_OUTPUT.PUT_LINE('[INFO] Registros a tratar '||SQL%ROWCOUNT||' ');  
	DBMS_OUTPUT.PUT_LINE('[INFO] GEE_ID = ' || V_GEE );  
	DBMS_OUTPUT.PUT_LINE('[INFO] GEH_ID = ' || V_GEH ); 
 
-----------------------------------------------------------------------------------------------------------------

       IF V_GEE != '0' THEN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrar Gestor - GAC ');
										
	 V_SQL := 'DELETE 
		   FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO
		   WHERE GEE_ID = ' || V_GEE ;

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados '||SQL%ROWCOUNT||' GAC ');  

       END IF;	


-----------------------------------------------------------------------------------------------------------------

       IF V_GEH <> '0' THEN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrar Gestor - GAH ');
										
	 V_SQL := 'DELETE 
		   FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO
		   WHERE GEH_ID = ' || V_GEH ;

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados '||SQL%ROWCOUNT||' GAH ');  

       END IF;	

-----------------------------------------------------------------------------------------------------------------

       IF V_GEH <> '0' THEN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrar Gestor - GEH ');
										
	 V_SQL := 'DELETE 
		   FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST
		   WHERE GEH_ID = ' || V_GEH ;

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados '||SQL%ROWCOUNT||' GEH ');  

       END IF;	

-----------------------------------------------------------------------------------------------------------------

       IF V_GEE <> '0' THEN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Borrar Gestor - GEE ');
										
	 V_SQL := 'DELETE 
		   FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD
		   WHERE GEE_ID = ' || V_GEE ;

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados '||SQL%ROWCOUNT||' GEE ');  

       END IF;	

-----------------------------------------------------------------------------------------------------------------

    
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
