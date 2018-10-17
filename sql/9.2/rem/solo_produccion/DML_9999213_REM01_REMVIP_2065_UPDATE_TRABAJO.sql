--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2065
--## PRODUCTO=NO
--##
--## Finalidad: ACTUALIZAR TRABAJO A URGENTE Y MODIFICAR FECHA EJECUCION TRABAJO
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_TBJ_TRABAJO';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2065';
    
 BEGIN
 
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
    				  TBJ_URGENTE = 1 
				, TBJ_FECHA_EJECUTADO = TO_DATE(''20/08/18'',''DD/MM/YY'') 
    				, USUARIOMODIFICAR  = '''||V_USUARIO||''' 
    				, FECHAMODIFICAR  = SYSDATE 
    				WHERE TBJ_NUM_TRABAJO = 9000114282 
    				';
    				
      EXECUTE IMMEDIATE V_SQL;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado el trabajo');
      
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
