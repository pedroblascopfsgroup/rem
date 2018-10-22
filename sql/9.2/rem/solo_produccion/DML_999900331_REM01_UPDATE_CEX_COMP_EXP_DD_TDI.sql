--/*
--##########################################
--## AUTOR=Ivan Castelló 
--## FECHA_CREACION=20180921
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1974
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
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1944';

    
 BEGIN


 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' CEX
            USING (select COM_ID, ECO_ID from '||V_ESQUEMA||'.'||V_TABLA||' where DD_TDI_ID_RTE is not null and CEX_DOCUMENTO_RTE IS NULL) ORIGEN
            ON (CEX.COM_ID = ORIGEN.COM_ID AND CEX.ECO_ID = ORIGEN.ECO_ID)
            WHEN MATCHED THEN
            UPDATE SET CEX.DD_TDI_ID_RTE = null';

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
