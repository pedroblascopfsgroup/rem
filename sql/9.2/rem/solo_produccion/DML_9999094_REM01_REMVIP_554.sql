--/*
--##########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180419
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-554
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar fecha de ingreso cheque
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

	UPDATE REM01.ECO_EXPEDIENTE_COMERCIAL ECO
	SET
	  ECO.ECO_FECHA_CONT_PROPIETARIO = NULL,
	  ECO.USUARIOMODIFICAR = 'REMVIP-554',
	  ECO.FECHAMODIFICAR = SYSDATE
	WHERE ECO.ECO_NUM_EXPEDIENTE = '89667';

    DBMS_OUTPUT.PUT_LINE('Se ha actualizado el registro correctamente');
    
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
