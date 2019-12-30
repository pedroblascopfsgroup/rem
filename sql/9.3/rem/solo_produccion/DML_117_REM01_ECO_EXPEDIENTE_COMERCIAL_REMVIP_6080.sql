--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20191226
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6080
--## PRODUCTO=NO
--##
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_EXIST_USU NUMBER(16); -- Vble. para validar la existencia de una usuario.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(50 CHAR) := 'REMVIP-6080';


BEGIN	        
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL 
		  SET DD_EEC_ID = ( SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''03'' ), 
		      ECO_FECHA_ANULACION = NULL,
		      ECO_PETICIONARIO_ANULACION = NULL,
		      DD_MAN_ID = NULL,
		      ECO_FECHA_CONT_PROPIETARIO = NULL, 	
		      USUARIOMODIFICAR = '''||V_USR||''', 
		      FECHAMODIFICAR = SYSDATE 
		      WHERE ECO_NUM_EXPEDIENTE = ''160428''

		  ';
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] Se actualizan '||SQL%ROWCOUNT||' registros de ECO_EXPEDIENTE_COMERCIAL '); 	

	
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_SQL);
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
