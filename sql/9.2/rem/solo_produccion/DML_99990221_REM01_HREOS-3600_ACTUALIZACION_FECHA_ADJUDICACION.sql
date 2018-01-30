/*
--##########################################
--## AUTOR=Dean Ibañez Viño
--## FECHA_CREACION=20180129
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HRNIVDOS-5827
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
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_REG NUMBER;
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


BEGIN
    
	DBMS_OUTPUT.PUT_LINE('[INICIO] ...');
    
    V_SQL := 'merge into '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL ajd
    using
    (select act.act_id, tmp.fecha_adjudicacion
    from '||V_ESQUEMA||'.TMP_ACT_FEC_ADJ tmp
    inner join '||V_ESQUEMA||'.act_activo act on (tmp.num_act = act.ACT_NUM_ACTIVO )) mrg
    on (ajd.act_id = mrg.act_id)
    when matched then update
    set ajd.AJD_FECHA_ADJUDICACION = TO_DATE(mrg.fecha_adjudicacion,''YYYYMMDD'')';
    
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO DEL '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL: '|| sql%rowcount ||' registros');
    
    -------------------------------------------------------------------------------------------------------------------
    
    /*V_SQL := 'merge into '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL ajd
    using
    (select act.act_id, tmp.fecha_adjudicacion_firme
    from '||V_ESQUEMA||'.TMP_ACT_FEC_ADJ tmp
    inner join '||V_ESQUEMA||'.act_activo act on (tmp.num_act = act.ACT_NUM_ACTIVO )) mrg
    on (ajd.act_id = mrg.act_id)
    when matched then update
    set ajd.ADN_FECHA_TITULO = TO_DATE(mrg.fecha_adjudicacion_firme,''YYYYMMDD'')'; 
    
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO DEL '||V_ESQUEMA||'.ACT_ADNADJNOJUDICIAL: '|| sql%rowcount ||' registros');
*/

    DBMS_OUTPUT.PUT_LINE('[FIN] ...');
    
    --ROLLBACK;
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