--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180726
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1418
--## PRODUCTO=NO
--##
--## Finalidad: ANULAR MOTIVO
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
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-1418';    
    
BEGIN	

V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET 
				 DD_MAN_ID   = NULL
				, USUARIOMODIFICAR  = '''||V_USUARIO||'''
				, FECHAMODIFICAR    = SYSDATE 
				WHERE ECO_NUM_EXPEDIENTE = 110308
				';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' MOTIVO ANULACION ACTUALIZADO');


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
