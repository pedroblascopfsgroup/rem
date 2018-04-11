--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180302
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-178
--## PRODUCTO=NO
--##
--## Finalidad: FALTA FECHA INGRESO CHEQUE 5952369
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
    V_TABLA VARCHAR2(25 CHAR):= 'ECO_EXPEDIENTE_COMERCIAL';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-178';
    
    ACT_NUM_ACTIVO NUMBER(16):= 5952369;
    
 BEGIN
 
    	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
    				  ECO_FECHA_CONT_PROPIETARIO =  TO_DATE(''02022018'',''DDMMYYYY'')
    				, USUARIOMODIFICAR 		 = '''||V_USUARIO||'''
    				, FECHAMODIFICAR 		 = SYSDATE
    				WHERE ECO_NUM_EXPEDIENTE = (SELECT ECO.ECO_NUM_EXPEDIENTE FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
						JOIN '||V_ESQUEMA||'.ACT_OFR AO 				  ON AO.OFR_ID 	   = OFR.OFR_ID
						JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT 			  ON ACT.ACT_ID    = AO.ACT_ID AND ACT.ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'
						JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID    = AO.OFR_ID
						JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.DD_EEC_CODIGO = ''08'')
    				';
    				
      EXECUTE IMMEDIATE V_SQL;
      
	  DBMS_OUTPUT.PUT_LINE('[INFO] Se ha puesto la fecha de ingreso cheque del activo '||ACT_NUM_ACTIVO);
      
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
