--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180911
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1810
--## PRODUCTO=NO
--##
--## Finalidad: Poner a 1 PAC_INLCUIDO el activo para que este en el perimetro Haya
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_PAC_PERIMETRO_ACTIVO';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1810';
    
    ACT_NUM_ACTIVO NUMBER(16):= 109589;
    
 BEGIN
 
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET 
    				  PAC_INCLUIDO = 1 
    				, USUARIOMODIFICAR  = '''||V_USUARIO||''' 
    				, FECHAMODIFICAR  = SYSDATE 
    				WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO 
    				WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||')
    				';
    				
      EXECUTE IMMEDIATE V_SQL;
      
	  DBMS_OUTPUT.PUT_LINE('[INFO] Se ha puesto a 1 el PAC_INLCUIDO del activo '||ACT_NUM_ACTIVO);
      
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
