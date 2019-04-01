--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3535
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


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLA VARCHAR2(25 CHAR):= 'ECO_EXPEDIENTE_COMERCIAL';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3535';
    PL_OUTPUT VARCHAR2(32000 CHAR);
    
    
 BEGIN

    		V_SQL := 'UPDATE REM01.OFR_OFERTAS OFR SET OFR_VENTA_DIRECTA = 1, 
                                                FECHAMODIFICAR = SYSDATE, 
                                                USUARIOMODIFICAR = ''REMVIP-3535'' 
                                                WHERE OFR_NUM_OFERTA IN (90140162,
									90140177,
									90140157,
									90140173,
									90140179,
									90140411,
									90140178,
									90140152,
									90140225,
									90142856,
									90142876,
									90142915,
									90140158,
									90140159,
									90142929,
									90140164,
									90140160,
									90140154,
									90140161,
									90140155,
									90140156,
									90140175
									)';	  
	
  EXECUTE IMMEDIATE V_SQL;
  DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' registros ACTUALIZADOS');

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

