--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180807
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1494
--## PRODUCTO=SI
--##
--## Finalidad: cambiar fechas vigencia agrupacion
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR):= 'REMVIP-1494';
    V_NUM_AGR NUMBER(16,0):= 1000000402;
        
BEGIN

      V_SQL := 'UPDATE '||V_ESQUEMA||'.ACT_AGR_AGRUPACION SET 
		  AGR_INI_VIGENCIA = TO_DATE(''09/07/2018'',''DD/MM/YYYY'') 
		, AGR_FIN_VIGENCIA = TO_DATE(''30/12/2018'',''DD/MM/YYYY'') 
		, USUARIOMODIFICAR = '''||V_USUARIO||''' 
		, FECHAMODIFICAR = SYSDATE 
		WHERE AGR_NUM_AGRUP_REM = '||V_NUM_AGR||'';

      EXECUTE IMMEDIATE V_SQL;
		
      DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registros en ACT_AGR_AGRUPACION');

    COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
