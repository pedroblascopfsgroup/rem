--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190322
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3778
--## PRODUCTO=NO
--##
--## Finalidad:	Actualizar los ID_PERSONA_HAYA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL T1
				USING (
				    WITH TMP_CLC AS (
				        SELECT CLC_DOCUMENTO FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL WHERE CLC_ID_PERSONA_HAYA IS NULL
				    )
				    SELECT DISTINCT CLC.CLC_DOCUMENTO, CLC.CLC_ID_PERSONA_HAYA FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC
				    JOIN TMP_CLC TMP ON TMP.CLC_DOCUMENTO = CLC.CLC_DOCUMENTO
				    WHERE CLC.CLC_ID_PERSONA_HAYA IS NOT NULL
				    AND CLC_ID_PERSONA_HAYA <> -1
				) T2
				ON (T1.CLC_DOCUMENTO = T2.CLC_DOCUMENTO)
				WHEN MATCHED THEN UPDATE SET
				    T1.CLC_ID_PERSONA_HAYA = T2.CLC_ID_PERSONA_HAYA,
				    T1.USUARIOMODIFICAR = ''REMVIP-3778'',
				    T1.FECHAMODIFICAR = SYSDATE
				WHERE CLC_ID_PERSONA_HAYA IS NULL';
	EXECUTE IMMEDIATE V_MSQL;
	
    DBMS_OUTPUT.PUT_LINE('	[INFO]	'||SQL%ROWCOUNT||' filas actualizadas');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');   

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