--/*
--##########################################
--## AUTOR=REMUS OVIDIU VIOREL
--## FECHA_CREACION=20180627
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1171
--## PRODUCTO=NO
--##
--## Finalidad: REPOSICIONAR TRAMITE Y ACTUALIZAR ESTADO ACTIVO, OFERTA Y EXPEDIENTE
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
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1171';
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);--Mensaje del procedimiento 


BEGIN	

	#ESQUEMA#.REPOSICIONAMIENTO_TRAMITE('REMVIP-1171','85870','T013_PosicionamientoYFirma','85870','11',PL_OUTPUT);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

	V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET 
 				    FECHAMODIFICAR = SYSDATE 
				  , USUARIOMODIFICAR = '''||V_USUARIO||''' 
	 			  , DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''01'') 
				   WHERE OFR_NUM_OFERTA = ''90005562''
	 			  ';
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla  OFR_OFERTAS');

	V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET 
 				    FECHAMODIFICAR = SYSDATE 
				  , USUARIOMODIFICAR = '''||V_USUARIO||''' 
	 			  , ECO_FECHA_VENTA = NULL  
				   WHERE ECO_NUM_EXPEDIENTE = ''85870''
	 			  ';
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla  ECO_EXPEDIENTE_COMERCIAL');

	V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET 
 				    FECHAMODIFICAR = SYSDATE 
				  , USUARIOMODIFICAR = '''||V_USUARIO||''' 
	 			  , DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''02'') 
				   WHERE ACT_NUM_ACTIVO = ''5934506''
	 			  ';
        EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla  ACT_ACTIVO');


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
