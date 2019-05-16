--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3988
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
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3988';
    PL_OUTPUT VARCHAR2(32000 CHAR);
    
    
 BEGIN

    		V_SQL := 'UPDATE REM01.ACT_PAC_PERIMETRO_ACTIVO PAC SET PAC_CHECK_FORMALIZAR = 1, 
                                                PAC.PAC_CHECK_COMERCIALIZAR = 1, 
                                                FECHAMODIFICAR = SYSDATE, 
                                                USUARIOMODIFICAR = ''REMVIP-3988'' 
                                                WHERE ACT_ID IN (SELECT ACT_ID FROM REM01.ACT_ACTIVO WHERE ACT_NUM_ACTIVO IN (5957145,
																5963423,
																5942761,
																5946315,
																6129900
																))';	  
	
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

