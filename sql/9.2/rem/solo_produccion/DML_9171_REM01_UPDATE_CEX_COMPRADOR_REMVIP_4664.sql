--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20192806
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4664
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
    V_TABLA VARCHAR2(25 CHAR):= 'CEX_COMPRADOR_EXPEDIENTE';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-4664';

    
 BEGIN


 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET CEX_NOMBRE_RTE = ''CARLOS JAVIER'',
	CEX_APELLIDOS_RTE = ''RIAL RODRIGUEZ'',
	DD_TDI_ID_RTE = 1,
	CEX_DOCUMENTO_RTE = ''35551440H'',
	DD_LOC_ID_RTE = 5307,
	DD_PRV_ID_RTE = 38,
	DD_PAI_ID = 28,
	DD_PAI_ID_RTE = 28,
	CEX_ID_PERSONA_HAYA = 1313169, 
	USUARIOMODIFICAR = ''REMVIP-4664'', 
        FECHAMODIFICAR = SYSDATE
	WHERE COM_ID = 158236 	
	AND ECO_ID = 170414';

  EXECUTE IMMEDIATE V_SQL;


  DBMS_OUTPUT.PUT_LINE('[INFO] Se han cambiado en total '||V_COUNT_INSERT||' registros en la tabla '||V_TABLA);
  
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
