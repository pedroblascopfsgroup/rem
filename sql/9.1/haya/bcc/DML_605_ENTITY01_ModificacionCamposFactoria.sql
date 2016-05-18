/*
--##########################################
--## AUTOR=Oscar Dorado
--## FECHA_CREACION=20160518
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-766
--## PRODUCTO=NO
--##
--## Finalidad: Modificacion de los campos de factoria procuradores
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	
	
	    
    DBMS_OUTPUT.PUT_LINE('Id 387 se le cambia la resolución de "Decreto adjudicación" a "Notificación decreto adjudicación al contrario" - R_TR_ADJ_DEC_ADJ_CON');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_descripcion = ''Notificación decreto adjudicación al contrario'', dd_tr_descripcion_larga = ''Notificación decreto adjudicación al contrario'', usuariomodificar = ''PRODUCTO-1047'', fechamodificar=sysdate where dd_tr_codigo = ''R_TR_ADJ_DEC_ADJ_CON''';
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('Id 346 se le cambia la resolución de "Diligencia de precinto" a "Documento realización efectiva precinto (Precinto)" - R_DLG_FCH_PRE');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_descripcion = ''Documento realización efectiva precinto (Precinto)'', dd_tr_descripcion_larga = ''Documento realización efectiva precinto (Precinto)'', usuariomodificar = ''PRODUCTO-1153'', fechamodificar=sysdate where dd_tr_codigo = ''R_DLG_FCH_PRE''';
    EXECUTE IMMEDIATE V_MSQL;
    
    --PRODUCTO-1445
    
    DBMS_OUTPUT.PUT_LINE('Borrado - ita_inputs_tareas');
    V_MSQL := 'delete '||V_ESQUEMA||'.ita_inputs_tareas where bpm_ipt_id in (select bpm_ipt_id from '||V_ESQUEMA||'.bpm_ipt_input where bpm_dd_tin_id = (select bpm_dd_tin_id from '||V_ESQUEMA||'.BPM_DD_TIN_TIPO_INPUT WHERE BPM_dd_tin_codigo = ''I_PR_HIP_DEM_SELLADA''))';
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('Borrado - bpm_dip_datos_input');
    V_MSQL := 'delete '||V_ESQUEMA||'.bpm_dip_datos_input WHERE BPM_IPT_ID in (select bpm_ipt_id from '||V_ESQUEMA||'.bpm_ipt_input where bpm_dd_tin_id = (select bpm_dd_tin_id from '||V_ESQUEMA||'.BPM_DD_TIN_TIPO_INPUT WHERE BPM_dd_tin_codigo = ''I_PR_HIP_DEM_SELLADA''))';
    EXECUTE IMMEDIATE V_MSQL;    
  
    DBMS_OUTPUT.PUT_LINE('Borrado - bpm_ipt_input');
    V_MSQL := 'delete '||V_ESQUEMA||'.bpm_ipt_input where bpm_dd_tin_id in (select bpm_dd_tin_id from '||V_ESQUEMA||'.BPM_DD_TIN_TIPO_INPUT WHERE BPM_dd_tin_codigo = ''I_PR_HIP_DEM_SELLADA'')';
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('Borrado - TRE_TAREA_RESOLUCION');
    V_MSQL := 'delete FROM '||V_ESQUEMA||'.TRE_TAREA_RESOLUCION  WHERE DD_TR_ID = (SELECT DD_TR_ID FROM '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION where dD_tr_codigo  =''R_PR_HIP_DEM_SELLADA'')';
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('De 440 a 460 - R_PR_HIP_DEM_SELLADA');
    V_MSQL := 'delete from '||V_ESQUEMA||'.res_resoluciones_masivo mas where res_tre_id = (select dd_tr_id from '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION res where dd_tr_codigo = ''R_PR_HIP_DEM_SELLADA'')';
    EXECUTE IMMEDIATE V_MSQL;
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_id = ''460'', usuariomodificar = ''PRODUCTO-1445'', fechamodificar=sysdate where dd_tr_codigo = ''R_PR_HIP_DEM_SELLADA''';
    EXECUTE IMMEDIATE V_MSQL;
    
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
