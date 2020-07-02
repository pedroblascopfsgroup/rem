--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20200617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7545
--## PRODUCTO=NO
--##
--## Finalidad: crear tramite y cambiar comite
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    PL_OUTPUT VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    --V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

   
 BEGIN
	 
	#ESQUEMA#.REPOSICIONAMIENTO_TRAMITE('REMVIP-7545','212409, 212722','T013_DefinicionOferta',null,null,PL_OUTPUT);
    DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);
    
    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO = ''22''), 
						DD_COS_ID_PROPUESTO = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO = ''22''), 
						USUARIOMODIFICAR = ''REMVIP-7545'', FECHAMODIFICAR = SYSDATE WHERE ECO_NUM_EXPEDIENTE =  212409';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO = ''34''), 
						DD_COS_ID_PROPUESTO = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO = ''34''), 
						USUARIOMODIFICAR = ''REMVIP-7545'', FECHAMODIFICAR = SYSDATE WHERE ECO_NUM_EXPEDIENTE =  212722';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO = ''35''), 
						DD_COS_ID_PROPUESTO = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO = ''35''), 
						USUARIOMODIFICAR = ''REMVIP-7545'', FECHAMODIFICAR = SYSDATE WHERE ECO_NUM_EXPEDIENTE =  210068';
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