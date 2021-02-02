--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210111
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8524
--## PRODUCTO=NO
--##
--## Finalidad: Modificar valor OFR_DOC_RESP_PRESCRIPTOR
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(25);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8524'; -- USUARIO CREAR/MODIFICAR

BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO CAMPO OFR_DOC_RESP_PRESCRIPTOR DE OFERTAS DE CARGA MASIVA');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.OFR_OFERTAS T1 
                USING (
                    SELECT OFR_NUM_OFERTA, OFR_DOC_RESP_PRESCRIPTOR 
                    FROM '||V_ESQUEMA||'.AUX_REMVIP_8524) T2
                ON (T1.OFR_NUM_OFERTA = T2.OFR_NUM_OFERTA)
                WHEN MATCHED THEN UPDATE SET
                T1.OFR_DOC_RESP_PRESCRIPTOR = T2.OFR_DOC_RESP_PRESCRIPTOR,
                USUARIOMODIFICAR = '''||V_USUARIO||''',
                FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: OFERTAS ACTUALIZADAS: ' ||sql%rowcount || '');

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