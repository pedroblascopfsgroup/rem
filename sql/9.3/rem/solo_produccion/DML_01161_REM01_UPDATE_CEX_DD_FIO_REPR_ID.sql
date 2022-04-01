--/*
--#########################################
--## AUTOR=Jesus Jativa
--## FECHA_CREACION=20220322
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11398
--## PRODUCTO=NO
--##
--## INSTRUCCIONES:  Incidencias Interlocutores Caixa
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-11398';



BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');

    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE FUNCION REPRESENTANTE OFERTA');

                   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.cex_comprador_expediente cex USING
                                                       (
                                                       select com.com_id , eco.eco_id , com.DD_TPE_ID tpe_id from '||V_ESQUEMA||'.cex_comprador_expediente cex
                                                       join '||V_ESQUEMA||'.com_comprador com on com.com_id = cex.com_id
                                                       join '||V_ESQUEMA||'.eco_expediente_comercial eco on cex.eco_id = eco.eco_id
                                                       join '||V_ESQUEMA||'.ofr_ofertas ofr on eco.ofr_id = ofr.ofr_id
                                                       join '||V_ESQUEMA||'.ofr_ofertas_caixa ofc on ofc.ofr_id = ofr.ofr_id
                                                       where cex.cex_documento_rte is not null
                                                       and cex.dd_fio_repr_id is null
                                                       and com.DD_TPE_ID is not null
                                                       ) AUX
                                                       ON (AUX.com_id = cex.com_id AND AUX.eco_id = cex.eco_id)
                                                       WHEN MATCHED THEN UPDATE SET
                                                       cex.dd_fio_repr_id = (
                                                       case when (AUX.tpe_id = (select dd_tpe_id from '||V_ESQUEMA||'.dd_tpe_tipo_persona where dd_tpe_codigo = ''1''))
                                                       then
                                                       (select dd_fio_id from '||V_ESQUEMA||'.dd_fio_fun_interlocutor_oferta WHERE dd_fio_codigo = ''06'')
                                                       else
                                                       (select dd_fio_id from '||V_ESQUEMA||'.dd_fio_fun_interlocutor_oferta WHERE dd_fio_codigo = ''03'')
                                                       end
                                                       ),
                                                       cex.usuariomodificar = '''||V_USUARIO||''',
                                                       cex.fechamodificar = sysdate';

          EXECUTE IMMEDIATE V_MSQL ;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] COM_COMPRADOR ACTUALIZADADO CORRECTAMENTE ');
    DBMS_OUTPUT.PUT_LINE('[FIN]: '||SQL%ROWCOUNT||' REGISTROS ACTUALIZADOS ');


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