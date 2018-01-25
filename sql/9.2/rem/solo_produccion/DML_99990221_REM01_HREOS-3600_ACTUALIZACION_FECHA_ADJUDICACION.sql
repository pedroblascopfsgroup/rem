/*
--##########################################
--## AUTOR=Dean Ibañez Viño
--## FECHA_CREACION=20180125
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
    (select num_act, fecha_adjudicacion
    from PFSREM.TMP_ACT_FEC_ADJ tmp
    inner join '||V_ESQUEMA||'.act_activo act
    on tmp.num_act = act.ACT_NUM_ACTIVO ) tmp
    on (ajd.act_id = tmp.num_act)
    when matched then update
    set ajd.AJD_FECHA_ADJUDICACION = tmp.fecha_adjudicacion';
    
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO DEL '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL: '|| sql%rowcount ||' registros');
    
    -------------------------------------------------------------------------------------------------------------------
    
    V_SQL := 'merge into '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL ajd
    using
    (select num_act, fecha_adjudicacion_firme
    from PFSREM.TMP_ACT_FEC_ADJ tmp
    inner join '||V_ESQUEMA||'.act_activo act
    on tmp.num_act = act.ACT_NUM_ACTIVO ) tmp
    on (ajd.act_id = tmp.num_act)
    when matched then update
    set ajd.ADN_FECHA_TITULO = tmp.fecha_adjudicacion_firme'; 
    
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADO DEL '||V_ESQUEMA||'.ACT_ADNADJNOJUDICIAL: '|| sql%rowcount ||' registros');

    

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