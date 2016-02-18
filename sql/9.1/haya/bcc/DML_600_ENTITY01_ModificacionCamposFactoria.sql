/*
--##########################################
--## AUTOR=Oscar Dorado
--## FECHA_CREACION=20160216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-766
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Trámite de envío de demanda
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
	
	DBMS_OUTPUT.PUT_LINE('De 306 a 433 - R_ATO_REQ_PGS');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_id = ''433'', usuariomodificar = ''PRODUCTO-766'', fechamodificar=sysdate where dd_tr_codigo = ''R_ATO_REQ_PGS''';
    
    DBMS_OUTPUT.PUT_LINE('De 292 a 434 - R_SOL_NOT_EMB');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_id = ''434'', usuariomodificar = ''PRODUCTO-784'', fechamodificar=sysdate where dd_tr_codigo = ''R_SOL_NOT_EMB''';

    DBMS_OUTPUT.PUT_LINE('De 293 a 435 - R_RSP_EMP_EMB');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_id = ''435'', usuariomodificar = ''PRODUCTO-784'', fechamodificar=sysdate where dd_tr_codigo = ''R_RSP_EMP_EMB''';
    
    DBMS_OUTPUT.PUT_LINE('De 294 a 436 - R_ACU_ENT_CNT');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_id = ''436'', usuariomodificar = ''PRODUCTO-784'', fechamodificar=sysdate where dd_tr_codigo = ''R_ACU_ENT_CNT''';
    
	DBMS_OUTPUT.PUT_LINE('De 231 a 437 - R_AUT_APRO_COST');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_id = ''437'', usuariomodificar = ''PRODUCTO-786'', fechamodificar=sysdate where dd_tr_codigo = ''R_AUT_APRO_COST''';
    
    DBMS_OUTPUT.PUT_LINE('Id 227 se le cambia la resolución de "Solicitud costas letrado" a "Solicitud tasación costas" - R_TR_SOL_TAS_COST');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_descripcion = ''Solicitud tasación costas'', dd_tr_descripcion_larga = ''Solicitud tasación costas'', usuariomodificar = ''PRODUCTO-786'', fechamodificar=sysdate where dd_tr_codigo = ''R_TR_SOL_TAS_COST''';
    
    DBMS_OUTPUT.PUT_LINE('Id 410 se le cambia la "Recepción de Gestoria" de "(Adjudicación)" a "(Inscripción de título)" - R_IDT_REG_ENT_TIT');
    V_MSQL := 'update '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION set dd_tr_descripcion = ''Recibí de gestoría (Inscripción de título)'', dd_tr_descripcion_larga = ''Recibí de gestoría (Inscripción de título)'', usuariomodificar = ''PRODUCTO-785'', fechamodificar=sysdate where dd_tr_codigo = ''R_IDT_REG_ENT_TIT''';
    
    --PRODUCTO-766
    DBMS_OUTPUT.PUT_LINE('Borrado - BPM_IDT_INPUT_DATOS');
    V_MSQL := 'delete '||V_ESQUEMA||'.BPM_IDT_INPUT_DATOS WHERE BPM_TPI_ID IN (SELECT BPM_TPI_ID FROM '||V_ESQUEMA||'.BPM_TPI_TIPO_PROC_INPUT where  DD_TPO_ID = (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''H016''))';
    
    DBMS_OUTPUT.PUT_LINE('Borrado - BPM_TPI_TIPO_PROC_INPUT');
    V_MSQL := 'delete '||V_ESQUEMA||'.BPM_TPI_TIPO_PROC_INPUT where  DD_TPO_ID = (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''H016'')';
    
    DBMS_OUTPUT.PUT_LINE('Borrado - BPM_DD_TIN_TIPO_INPUT');
    V_MSQL := 'delete '||V_ESQUEMA||'.BPM_DD_TIN_TIPO_INPUT WHERE BPM_dd_tin_codigo = ''I_DEM_SEL_PCM''';
    
    DBMS_OUTPUT.PUT_LINE('Borrado - DD_TR_TIPOS_RESOLUCION');
    V_MSQL := 'delete '||V_ESQUEMA||'.DD_TR_TIPOS_RESOLUCION where dD_tr_codigo  =''R_DEM_SEL_PCM''';
    

    
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');

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
