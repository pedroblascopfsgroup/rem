--/*
--##########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180724
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1409
--## PRODUCTO=NO
--##
--## Finalidad: ANULACION DE LAS OFERTAS 90044527 Y 90044355
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
   
    V_SQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1409';
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    V_NUM_EXPEDIENTE1 NUMBER;
    V_NUM_EXPEDIENTE2 NUMBER;


BEGIN	


	 #ESQUEMA#.ANULACION_OFERTA_CAMBIO_SCM('REMVIP-1409','90044527',NULL);

	 #ESQUEMA#.ANULACION_OFERTA_CAMBIO_SCM('REMVIP-1409','90044355',NULL);
	 
	 
	 V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO SET ECO.USUARIOMODIFICAR = '''||V_USUARIO||''', ECO.FECHAMODIFICAR = SYSDATE, ECO.ECO_FECHA_VENTA = NULL, ECO.ECO_FECHA_CONT_PROPIETARIO = NULL
				WHERE ECO.OFR_ID IN (
					SELECT OFR.OFR_ID
					FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
					WHERE OFR.OFR_NUM_OFERTA IN (90044527, 90044355)
				)';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||SQL%ROWCOUNT||' registros.');

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
