--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20180628
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1183
--## PRODUCTO=NO
--##
--## Finalidad: Insertar gestor sustituto
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

V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET
	DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''02''),
	USUARIOMODIFICAR = ''REMVIP-1190'',
	FECHAMODIFICAR = SYSDATE
	WHERE ACT_NUM_ACTIVO IN (6036855, 6081928, 6080915)';

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
