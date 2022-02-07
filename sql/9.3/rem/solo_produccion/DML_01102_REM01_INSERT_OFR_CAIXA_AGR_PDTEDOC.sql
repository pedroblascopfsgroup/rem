--/*
--##########################################
--## AUTOR=Jesus
--## FECHA_CREACION=20211214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10915
--## PRODUCTO=NO
--##
--## Finalidad: Script añade ofertas Caixa
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-10914'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO]');


	V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.OFR_OFERTAS_CAIXA (OFR_CAIXA_ID,OFR_ID,USUARIOCREAR,FECHACREAR)
SELECT '||V_ESQUEMA||'.S_OFR_OFERTAS_CAIXA.NEXTVAL, OFR_ID, USUARIOCREAR, FECHACREAR FROM(
	(select DISTINCT  ofr.ofr_id AS OFR_ID, ''REMVIP-10914'' as USUARIOCREAR, SYSDATE AS FECHACREAR from '||V_ESQUEMA||'.ofr_ofertas ofr
    	JOIN '||V_ESQUEMA||'.act_ofr aof on aof.ofr_id = ofr.ofr_id
    	JOIN '||V_ESQUEMA||'.act_activo act on aof.act_id = act.act_id
        LEFT JOIN '||V_ESQUEMA||'.ofr_ofertas_caixa ofc on ofr.ofr_id = ofc.ofr_id
        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=ACT.DD_CRA_ID AND CRA.BORRADO = 0
        JOIN '||V_ESQUEMA||'.dd_eof_estados_oferta EOF ON EOF.DD_EOF_ID=OFR.DD_EOF_ID AND EOF.BORRADO = 0
    	where ofc.ofr_caixa_id is null and ofr.agr_id is not null and CRA.DD_CRA_CODIGO = ''03'' and EOF.DD_EOF_CODIGO = ''08''))';
    EXECUTE IMMEDIATE V_MSQL;
	COMMIT;

            DBMS_OUTPUT.PUT_LINE('[FIN] INSERTADAS OFERTAS '||SQL%ROWCOUNT||' ');

EXCEPTION
		WHEN OTHERS THEN
			ERR_NUM := SQLCODE;
			ERR_MSG := SQLERRM;

			DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
			DBMS_OUTPUT.put_line('-----------------------------------------------------------');
			DBMS_OUTPUT.put_line(err_msg);

			ROLLBACK;
			RAISE;

END;
/

EXIT