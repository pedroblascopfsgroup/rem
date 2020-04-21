--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200414
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6958
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6958'; -- USUARIOCREAR/USUARIOMODIFICAR.
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS
				SET OFR_ORIGEN = ''REM''
				    ,USUARIOMODIFICAR = ''REMVIP-6958''
				    ,FECHAMODIFICAR = SYSDATE
				WHERE  OFR_ID IN (
				    SELECT DISTINCT OFR.OFR_ID
				    FROM '||V_ESQUEMA||'.ACT_OFR AO
				    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID
				    JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AO.OFR_ID
				    JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
				    JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = OFR.AGR_ID
				    JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
				    WHERE DD_CRA_ID = 42 AND ACT.DD_SCR_ID IN (444,443)
				    AND (OFR.OFR_ORIGEN IS NULL OR OFR_WEBCOM_ID IS NULL)
				    AND DD_EOF_ID <> 2 AND ECO.DD_EEC_ID <> 2
				    AND (TAG.DD_TAG_CODIGO = ''02'' OR TAG.DD_TAG_CODIGO = ''14'')
				)';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('	[INFO] SE HAN ACTUALIZADO '||SQL%ROWCOUNT||' OFERTAS');
	
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
EXIT;