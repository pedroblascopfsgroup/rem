--/*
--#########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20200214
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6611
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
   V_SQL VARCHAR2(4000 CHAR);	
   V_PAR VARCHAR( 1024 CHAR );
   V_RET VARCHAR( 1024 CHAR );  

   V_GEE VARCHAR( 15 CHAR ) := '0';  
   V_GEH VARCHAR( 15 CHAR ) := '0';  
  
   ----------------------------------
	CURSOR CPOS IS SELECT DISTINCT GEE.GEE_ID, GEH.GEH_ID
	FROM #ESQUEMA#.GEE_GESTOR_ENTIDAD GEE
	INNER JOIN #ESQUEMA_MASTER#.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID
	INNER JOIN #ESQUEMA#.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.DD_TGE_ID = GEE.DD_TGE_ID AND GEH.USU_ID = GEE.USU_ID
	INNER JOIN #ESQUEMA#.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.GEH_ID = GEH.GEH_ID
	INNER JOIN #ESQUEMA#.ACT_ACTIVO ACT ON GAH.ACT_ID = ACT.ACT_ID
	INNER JOIN #ESQUEMA#.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID AND GAC.ACT_ID = ACT.ACT_ID
	INNER JOIN #ESQUEMA_MASTER#.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID	
	WHERE  ACT_NUM_ACTIVO in (
								6991817, 
								6963481, 
								6963487,
								6965873
							 )
	AND TGE.DD_TGE_CODIGO IN (
								'HAYAGBOINM',
								'HAYASBOINM'
							 );
   ----------------------------------
   
BEGIN
  
   DBMS_OUTPUT.put_line('[INICIO]');
   
   FOR NCP IN CPOS LOOP
			
   			
   
   		IF NCP.GEE_ID IS NOT NULL THEN
   			V_GEE := NCP.GEE_ID;  
   		END IF;
   		
   		IF NCP.GEH_ID IS NOT NULL THEN
   			V_GEH := NCP.GEH_ID;  
   		END IF; 
   		-----------------------------------------------------------------------------------------------------------------
		
		IF V_GEE != '0' THEN
														
			V_SQL := 'DELETE 
				FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO
				WHERE GEE_ID = ' || NCP.GEE_ID ;
			
			EXECUTE IMMEDIATE V_SQL;
				
			DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO DE LA TABLA '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO REGISTRO CON GEE_ID = ' || NCP.GEE_ID || ' Y GEH_ID = ' || NCP.GEH_ID); 
		END IF;	
		
		
		-----------------------------------------------------------------------------------------------------------------
		
		IF V_GEH != '0' THEN
		
			V_SQL := 'DELETE 
				FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO
				WHERE GEH_ID = ' || NCP.GEH_ID ;
			
			EXECUTE IMMEDIATE V_SQL;
		
			DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO DE LA TABLA '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO REGISTRO CON GEE_ID = ' || NCP.GEE_ID || ' Y GEH_ID = ' || NCP.GEH_ID); 

   		END IF;	
		
		-----------------------------------------------------------------------------------------------------------------
		
		IF V_GEH != '0' THEN
		
			DBMS_OUTPUT.PUT_LINE('[INICIO] Borrar Gestor - GEH ');
												
			V_SQL := 'DELETE 
				FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST
				WHERE GEH_ID = ' || V_GEH ;
		
			EXECUTE IMMEDIATE V_SQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO DE LA TABLA '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST REGISTRO CON GEE_ID = ' || NCP.GEE_ID || ' Y GEH_ID = ' || NCP.GEH_ID); 

   		END IF;	
		
		-----------------------------------------------------------------------------------------------------------------
		
		IF V_GEE != '0' THEN
		
			DBMS_OUTPUT.PUT_LINE('[INICIO] Borrar Gestor - GEE ');
												
			V_SQL := 'DELETE 
				FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD
				WHERE GEE_ID = ' || V_GEE ;
			
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO DE LA TABLA '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD REGISTRO CON GEE_ID = ' || NCP.GEE_ID || ' Y GEH_ID = ' || NCP.GEH_ID); 

		END IF;	
		
		-----------------------------------------------------------------------------------------------------------------
		V_GEE := '0';  
   		V_GEH := '0';  
	END LOOP;
    
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
