--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181015
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2223
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar USU_ID duplicado por correctos en la tabla ACT_PVC_PROVEEDOR_CONTACTO
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
    V_TABLA VARCHAR2(30 CHAR):= 'ACT_PVC_PROVEEDOR_CONTACTO';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2223';
    
 BEGIN
 
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
    				  USU_ID = 74724
    				, USUARIOMODIFICAR 		 = '''||V_USUARIO||'''
    				, FECHAMODIFICAR 		 = SYSDATE
    				WHERE PVE_ID = 21899 
            			AND PVC_ID = 96874 
    				';
    				
         EXECUTE IMMEDIATE V_SQL;
      
	 DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado usu_id');

	 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
    				  USU_ID = 74725
    				, USUARIOMODIFICAR 		 = '''||V_USUARIO||'''
    				, FECHAMODIFICAR 		 = SYSDATE
    				WHERE PVE_ID = 21899 
            			AND PVC_ID = 96833
    				';
    				
         EXECUTE IMMEDIATE V_SQL;
      
	 DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado usu_id');

	 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
    				  USU_ID = 74722
    				, USUARIOMODIFICAR 		 = '''||V_USUARIO||'''
    				, FECHAMODIFICAR 		 = SYSDATE
    				WHERE PVE_ID = 21899 
            			AND PVC_ID = 96834
    				';
    				
         EXECUTE IMMEDIATE V_SQL;
      
	 DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado usu_id');

	 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
    				  USU_ID = 74723
    				, USUARIOMODIFICAR 		 = '''||V_USUARIO||'''
    				, FECHAMODIFICAR 		 = SYSDATE
    				WHERE PVE_ID = 21899 
           		        AND PVC_ID = 96873
    				';
    				
         EXECUTE IMMEDIATE V_SQL;
      
	 DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado usu_id');
      
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
