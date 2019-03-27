--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190322
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3691
--## PRODUCTO=NO
--##
--## Finalidad:	Insertar clientes de ofertas creadas en la tabla clientes GDPR
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

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET DD_EOF_ID = 4, USUARIOMODIFICAR = ''GDPR-2.7'', FECHAMODIFICAR = SYSDATE
				WHERE OFR_ID IN (
				    SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
				    LEFT JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID
				    WHERE DD_EOF_ID = 1
				    AND ECO_ID IS NULL
				)';
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CGD_CLIENTE_GDPR T1
				USING (
				    SELECT DISTINCT CLC.CLC_ID, CLC.DD_TDI_ID, CLC.CLC_DOCUMENTO
				    FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
				    LEFT JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID
				    JOIN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC ON CLC.CLC_ID = OFR.CLC_ID
				    LEFT JOIN '||V_ESQUEMA||'.CGD_CLIENTE_GDPR CGD ON CGD.CLC_ID = CLC.CLC_ID
				    WHERE CLC.DD_TDI_ID IS NOT NULL AND CLC.CLC_DOCUMENTO IS NOT NULL
				    AND OFR.DD_EOF_ID <> 2
				    AND ECO.ECO_ID IS NULL AND CGD.CLC_ID IS NULL
				) T2
				ON (T1.CLC_ID = T2.CLC_ID)
				WHEN NOT MATCHED THEN INSERT VALUES (
				    '||V_ESQUEMA||'.S_CGD_CLIENTE_GDPR.NEXTVAL,
				    T2.CLC_ID,
				    T2.DD_TDI_ID,
				    T2.CLC_DOCUMENTO,
				    NULL,
				    NULL,
				    NULL,
				    NULL,
				    0,
				    ''GDPR-2.7'',
				    SYSDATE,
				    NULL,
				    NULL,
				    NULL,
				    NULL,
				    0
				)';
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