--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180802
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1490
--## PRODUCTO=NO
--##
--## Finalidad: poner importe de trabajo 9000104090 a 0
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
    V_USUARIO VARCHAR2(65 CHAR) := 'REMVIP-1490';
    V_TBJ_NUM NUMBER(16) := 9000104090;
    V_TBJ_ID NUMBER(16,0);--Vble. auxiliar para guardar el tbj_id
    
BEGIN	

EXECUTE IMMEDIATE '(SELECT TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = '||V_TBJ_NUM||')' INTO V_TBJ_ID;

V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_TCT_TRABAJO_CFGTARIFA SET 
	  TCT_MEDICION = 0 
	  , USUARIOMODIFICAR  = '''||V_USUARIO||'''
          , FECHAMODIFICAR    = SYSDATE 
	  WHERE TBJ_ID = '||V_TBJ_ID||' 
	  AND BORRADO = 0
	  ';


	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' MEDICIONES DE TRABAJO ACTUALIZADAS');

V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO SET
	  TBJ_IMPORTE_TOTAL = 0 
	  , USUARIOMODIFICAR  = '''||V_USUARIO||'''
          , FECHAMODIFICAR    = SYSDATE 
	  WHERE TBJ_ID = '||V_TBJ_ID||' 
	  ';


	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' IMPORTE TOTAL TRABAJO ACTUALIZADOS');


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
