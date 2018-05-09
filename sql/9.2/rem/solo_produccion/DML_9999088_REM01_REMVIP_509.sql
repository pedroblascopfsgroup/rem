--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180416
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-509
--## PRODUCTO=NO
--##
--## Finalidad: Modficar motivo de rechazo gasto F31
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    PL_OUTPUT VARCHAR2(32000 CHAR);
    
 BEGIN

	UPDATE REM01.DD_MRG_MOTIVO_RECHAZO_GASTO
	SET
	  QUERY_ITER = 'WHERE AUX.FECHA_ANTICIPO IS NOT NULL AND AUX.PAGADO_POR NOT IN (''01'',''03'')',
	  USUARIOMODIFICAR = 'REMVIP-509',
	  FECHAMODIFICAR = SYSDATE
	WHERE DD_MRG_CODIGO = 'F31';

    DBMS_OUTPUT.PUT_LINE('Registros actualizados correctamente');
  
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
