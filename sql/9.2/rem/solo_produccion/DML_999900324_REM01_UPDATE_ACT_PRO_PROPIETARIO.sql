--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20180917
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1894
--## PRODUCTO=NO
--##
--## Finalidad: Update propietario
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
   
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error;
	V_SQL VARCHAR2(20000 CHAR);

BEGIN

V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO SET
	PRO_NOMBRE = ''PROMONTORIA JAIPUR, S.L'',
	USUARIOMODIFICAR = ''REMVIP-1894'',
	FECHAMODIFICAR = SYSDATE
	WHERE PRO_NOMBRE = ''CIF PROMONTORIA JAIPUR''';

EXECUTE IMMEDIATE V_SQL;

COMMIT;

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
