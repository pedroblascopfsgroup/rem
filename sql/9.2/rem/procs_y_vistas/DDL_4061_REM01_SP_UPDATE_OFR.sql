--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=201803
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-643
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.UPDATE_OFR
   (  OFR_NUM_OFERTA IN NUMBER
	, DD_EOF_ID IN NUMBER
	, PL_OUTPUT OUT VARCHAR2
   )
   
   AS

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar        
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   DESCRIPCION VARCHAR2(64 CHAR);

BEGIN


	V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET DD_EOF_ID = '||DD_EOF_ID||' WHERE OFR_NUM_OFERTA = '||OFR_NUM_OFERTA;

	EXECUTE IMMEDIATE V_SQL;

	EXECUTE IMMEDIATE 'SELECT DD_EOF_DESCRIPCION FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_ID = '||DD_EOF_ID INTO DESCRIPCION;

	PL_OUTPUT := '[INFO] actualizado el estado de la oferta  '||OFR_NUM_OFERTA||' a '||DESCRIPCION;

COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END UPDATE_OFR;
/
EXIT;
