/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160411
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1095
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Trámite de adjudicación tercero
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

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    VAR_TIPOACTUACION VARCHAR2(50 CHAR); -- Tipo de actuación a insertar

    --Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    TYPE T_TIPO_TPO IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TPO IS TABLE OF T_TIPO_TPO;
    V_TIPO_TPO T_ARRAY_TPO := T_ARRAY_TPO(
      T_TIPO_TPO('P457','T. de Adjudicación Terceros','T. de Adjudicación Terceros',null,'tramiteAdjudicacionTerceros','0','PRODUCTO-1095','0','AP',null,null,'1','MEJTipoProcedimiento','1','1')
    ); 
    V_TMP_TIPO_TPO T_TIPO_TPO;

    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
       T_TIPO_TAP('P457','P457_RegistrarDatosAdjudicacion',null,null,'valores[''P457_RegistrarDatosAdjudicacion''][''comboPostorConsignacion'']== ''1'' ? validarDatosAdjudicacionTerceroBien() ? comprobarSiEntidadAdjudicatariaEnBienEsEntidad() ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">La entidad adjudicataria que ha seleccionado y la mostrada en la ficha del bien no se corresponden.</div>'' : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Falta alg&uacute;n campo necesario por rellenar en la ficha del bien.</div>'' : null','valores[''P457_RegistrarDatosAdjudicacion''][''comboPostorConsignacion''] == ''1'' ? bienConCesionRemate() ? ''con'' : ''sin'' : ''terceros''',null,'0','Registrar datos adjudicación','0','PRODUCTO-1095','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'814',null,'GCONGE',null)
	,T_TIPO_TAP('P457','P457_ConfirmarConsignacion',null,null,null,'valores[''P457_ConfirmarConsignacion''][''comboPagoRealizado'']',null,'0','Confirmar Consignacion','0','PRODUCTO-1095','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'814',null,'GCONGE',null)
	,T_TIPO_TAP('P457','P457_SolicitarMandamientoPago',null,null,null,null,null,'0','Solicitar mandamiento de pago','0','PRODUCTO-1095','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'814',null,'GCONGE',null)
	,T_TIPO_TAP('P457','P457_ConfirmarRecivoEnvioMandamientoPago',null,'existeAdjuntoUG(''MP'',''PRC'') ? null : ''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">Debe adjuntar el documento de Mandamiento de Pago.</div>''',null,null,null,'0','Confirmar recepción y envío de mandamiento de pago','0','PRODUCTO-1095','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'814',null,'GCONGE',null)
	,T_TIPO_TAP('P457','P457_RecepcionMandamientoPago',null,null,null,null,null,'0','Recepción Mandamiento de Pago','0','PRODUCTO-1095','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'TGCONGE',null,'SUCONGE',null)
	,T_TIPO_TAP('P457','P457_ConfirmarContabilidad',null,null,null,null,null,'0','Confirmar Contabilidad','0','PRODUCTO-1095','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'TGCON',null,'SCON',null)
	,T_TIPO_TAP('P457','P457_ValorarLanzamientoTramiteSoliSolvPatr',null,null,null,'valores[''P457_ValorarLanzamientoTramiteSoliSolvPatr''][''comboTramiteSolicitudSolvPatrimonial'']==''01'' ? ''01'' : ''02''',null,'0','Valorar Lanzamiento Trámite de Solicitud de Solvencia Patrimonial','0','PRODUCTO-1095','0',null,null,null,'0','EXTTareaProcedimiento','0',null,'TGCONGE',null,'SUCONGE',null)
    ,T_TIPO_TAP('P457','P457_BPMTramiteCesionRemate',null,null,null,null,'H006','0','Se inicia el trámite de cesión de remate.','0','PRODUCTO-1095','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'814',null,null,null)
	,T_TIPO_TAP('P457','P457_BPMTramiteAdjudicacion',null,null,null,null,'H005','0','Se inicia el trámite de adjudicación.','0','PRODUCTO-1095','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'814',null,null,null)
	,T_TIPO_TAP('P457','P457_BPMTramiteSolicitudSolvenciaPatrimonial',null,null,null,null,'HC104','0','Se inicia el trámite de solicitud de solvencia patrimonial.','0','PRODUCTO-1095','0',null,null,null,'1','EXTTareaProcedimiento','3',null,'814',null,null,null)
    ); 
    V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
     	 T_TIPO_PLAZAS(null,null,'P457_RegistrarDatosAdjudicacion','5*24*60*60*1000L','0','0','PRODUCTO-1095')
	,T_TIPO_PLAZAS(null,null,'P457_ConfirmarConsignacion','(valores[''P457_RegistrarDatosAdjudicacion''] !=null && valores[''P457_RegistrarDatosAdjudicacion''][''fechaLimitePeriodoConsignacion''] !=null) ? damePlazo(valores[''P457_RegistrarDatosAdjudicacion''][''fechaLimitePeriodoConsignacion'']) : 5*24*60*60*1000L','0','0','PRODUCTO-1095')
	,T_TIPO_PLAZAS(null,null,'P457_SolicitarMandamientoPago','2*24*60*60*1000L','0','0','PRODUCTO-1095')
	,T_TIPO_PLAZAS(null,null,'P457_ConfirmarRecivoEnvioMandamientoPago','10*24*60*60*1000L','0','0','PRODUCTO-1095')
	,T_TIPO_PLAZAS(null,null,'P457_RecepcionMandamientoPago','3*24*60*60*1000L','0','0','PRODUCTO-1095')
	,T_TIPO_PLAZAS(null,null,'P457_ConfirmarContabilidad','5*24*60*60*1000L','0','0','PRODUCTO-1095')
	,T_TIPO_PLAZAS(null,null,'P457_ValorarLanzamientoTramiteSoliSolvPatr','5*24*60*60*1000L','0','0','PRODUCTO-1095')
	,T_TIPO_PLAZAS(null,null,'P457_BPMTramiteCesionRemate','300*24*60*60*1000L','0','0','PRODUCTO-1095')
	,T_TIPO_PLAZAS(null,null,'P457_BPMTramiteAdjudicacion','300*24*60*60*1000L','0','0','PRODUCTO-1095')
	,T_TIPO_PLAZAS(null,null,'P457_BPMTramiteSolicitudSolvenciaPatrimonial','300*24*60*60*1000L','0','0','PRODUCTO-1095')
    ); 
    V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
         T_TIPO_TFI('P457_RegistrarDatosAdjudicacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea procederá al registro de los datos de la Adjudicación, indicando la fecha límite del período de consignación indicado por el Secretario Judicial,  informar sobre la persona a la que aplica el período de consignación y la cantidad de su puja. Además, debe informarse si el postor se trata de la Entidad o de un tercero.<br><br>En caso de que sea la Entidad, deberá actualizar los campos de la pestaña "Adjudicación y Posesión" de la ficha del bien.<br><br>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.<br><br>Una vez rellene esta pantalla:<br>- En caso de que el postor sea un Tercero, se lanzará la tarea “Registrar fin del período de consignación".<br>- En caso de que el postor sea la Entidad, se lanzará el Trámite de Adjudicación o el Trámite de Cesión de Remate, según el campo "Cesión de Remate" de la ficha del bien.</p></div>',null,null,null,null,'0','PRODUCTO-1095')
        ,T_TIPO_TFI('P457_RegistrarDatosAdjudicacion','1','date','fechaLimitePeriodoConsignacion','Fecha Límite periodo de Consignación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_RegistrarDatosAdjudicacion','2','text','nombrePostor','Nombre Postor','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1095')
        ,T_TIPO_TFI('P457_RegistrarDatosAdjudicacion','3','combo','comboPostorConsignacion','Postor de Consignación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDEntidadAdjudicataria','0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_RegistrarDatosAdjudicacion','4','number','cantidadPuja','Cantidad de Puja','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_RegistrarDatosAdjudicacion','5','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1095')


	,T_TIPO_TFI('P457_ConfirmarConsignacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez finalizado el período de consignación del postor, deberá indicar si éste ha procedido al pago correspondiente.<br><br>En caso de que se haya realizado el pago, informaremos la fecha en la que se produjo el mismo.<br><br>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.<br><br>Una vez rellene esta pantalla:<br>- En caso de que no se haya realizado el pago por un tercero, volveremos a la tarea "Registrar inicio del período de consignación".<br>- En caso de que se haya realizado el pago por el tercero, se lanzará la tarea "Solicitar mandamiento de pago".</p></div>',null,null,null,null,'0','PRODUCTO-1095')
        ,T_TIPO_TFI('P457_ConfirmarConsignacion','1','date','fechaLimitePeriodoConsignacion','Fecha límite periodo de consignación',null,null,'(valores[''P457_RegistrarDatosAdjudicacion''] !=null && valores[''P457_RegistrarDatosAdjudicacion''][''fechaLimitePeriodoConsignacion''] !=null) ? valores[''P457_RegistrarDatosAdjudicacion''][''fechaLimitePeriodoConsignacion''] : 5*24*60*60*1000L',null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_ConfirmarConsignacion','2','text','nombrePostor','Nombre Postor',null,null,'(valores[''P457_RegistrarDatosAdjudicacion''] !=null && valores[''P457_RegistrarDatosAdjudicacion''][''nombrePostor''] !=null) ? valores[''P457_RegistrarDatosAdjudicacion''][''nombrePostor''] : null',null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_ConfirmarConsignacion','3','number','cantidadPuja','Cantidad de Puja',null,null,'(valores[''P457_RegistrarDatosAdjudicacion''] !=null && valores[''P457_RegistrarDatosAdjudicacion''][''cantidadPuja''] !=null) ? valores[''P457_RegistrarDatosAdjudicacion''][''cantidadPuja''] : null',null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_ConfirmarConsignacion','4','combo','comboPagoRealizado','Pago Realizado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_ConfirmarConsignacion','5','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1095')


	,T_TIPO_TFI('P457_SolicitarMandamientoPago','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que alguno de los bienes ha sido adjudicado a un tercero, en esta pantalla debemos de informar la fecha de presentación en el juzgado del escrito solicitando la entrega de las cantidades informadas.<br><br>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.<br><br>Una vez rellene esta pantalla la siguiente tarea será "Confirmar recepción mandamiento de pago".</p></div>',null,null,null,null,'0','PRODUCTO-1095')
        ,T_TIPO_TFI('P457_SolicitarMandamientoPago','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_SolicitarMandamientoPago','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1095')


	,T_TIPO_TFI('P457_ConfirmarRecivoEnvioMandamientoPago','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se ha de informar la fecha y el importe en la que nos han entregado los mandamientos de pago de la cantidad informada por un tercero en concepto de pago del bien o bienes adjudicados, así como la fecha de envío a HRE para su contabilización.<br><br>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.<br><br>La siguiente tarea será "Recepción de mandamiento de pago".</p></div>',null,null,null,null,'0','PRODUCTO-1095')
        ,T_TIPO_TFI('P457_ConfirmarRecivoEnvioMandamientoPago','1','date','fechaRecepcion','Fecha Recepción','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_ConfirmarRecivoEnvioMandamientoPago','2','date','fechaEnvio','Fecha Envío','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_ConfirmarRecivoEnvioMandamientoPago','3','number','importe','Importe',null,null,null,null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_ConfirmarRecivoEnvioMandamientoPago','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1095')


	,T_TIPO_TFI('P457_RecepcionMandamientoPago','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea deberá revisar que puede realizarse la contabilización de los importes recibidos e indicar la fecha en la que recepciona el mandamiento de pago.<br><br>En caso de que la deuda no quede totalmente cubierta y alguno de los bienes no sea vivienda habitual, se continuará con la averiguación patrimonial. En el supuesto de que el bien o los bienes estuvieran marcados como vivienda habitual, se deberá considerará fallido procesal y no se continuará con la solvencia patrimonial.<br><br>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.<br><br>Una vez finalice esta tarea se lanzará la tarea "Confirmar contabilidad".</p></div>',null,null,null,null,'0','PRODUCTO-1095')
        ,T_TIPO_TFI('P457_RecepcionMandamientoPago','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_RecepcionMandamientoPago','2','number','importe','Importe',null,null,'(valores[''P457_ConfirmarRecivoEnvioMandamientoPago''] !=null && valores[''P457_ConfirmarRecivoEnvioMandamientoPago''][''importe''] !=null) ? valores[''P457_ConfirmarRecivoEnvioMandamientoPago''][''importe''] : null',null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_RecepcionMandamientoPago','3','combo','comboCubiertaTotalmenteDeuda','Cubierta totalmente la deuda','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_RecepcionMandamientoPago','4','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1095')


	,T_TIPO_TFI('P457_ConfirmarContabilidad','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea deberá informar la fecha en la que queda contabilizado en el sistema el pago realizado por el tercero.<br><br>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1095')
        ,T_TIPO_TFI('P457_ConfirmarContabilidad','1','date','fecha','Fecha','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_ConfirmarContabilidad','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1095')


	,T_TIPO_TFI('P457_ValorarLanzamientoTramiteSoliSolvPatr','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta tarea, deberá usted indicar si se debe o no lanzar el Trámite de Solicitud de Solvencia Patrimonial.<br><br>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>',null,null,null,null,'0','PRODUCTO-1095')
    ,T_TIPO_TFI('P457_ValorarLanzamientoTramiteSoliSolvPatr','1','combo','comboTramiteSolicitudSolvPatrimonial','Trámite de solicitud de solvencia patrimonial','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','PRODUCTO-1095')
	,T_TIPO_TFI('P457_ValorarLanzamientoTramiteSoliSolvPatr','2','textarea','observaciones','Observaciones',null,null,null,null,'0','PRODUCTO-1095')
        
	
	,T_TIPO_TFI('P457_BPMTramiteCesionRemate','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se inicia el tr&aacute;mite de cesi&oacute;n de remate.</p></div>',null,null,null,null,'0','PRODUCTO-1095')
	
	
	,T_TIPO_TFI('P457_BPMTramiteAdjudicacion','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se inicia el tr&aacute;mite de adjudicaci&oacute;n.</p></div>',null,null,null,null,'0','PRODUCTO-1095')
	
	
	,T_TIPO_TFI('P457_BPMTramiteSolicitudSolvenciaPatrimonial','0','label','titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se inicia el tr&aacute;mite de solicitud de solvencia patrimonial.</p></div>',null,null,null,null,'0','PRODUCTO-1095')
	); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	
	
    -- LOOP Insertando valores en DD_TPO_TIPO_PROCEDIMIENTO
    VAR_TABLENAME := 'DD_TPO_TIPO_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TIPO DE PROCEDIMIENTO');
    FOR I IN V_TIPO_TPO.FIRST .. V_TIPO_TPO.LAST
      LOOP
        V_TMP_TIPO_TPO := V_TIPO_TPO(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TPO(1))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO... Ya existe el procedimiento '''|| TRIM(V_TMP_TIPO_TPO(1)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,' ||
                    'DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,' ||
                    'FECHACREAR,BORRADO,DD_TAC_ID,DD_TPO_SALDO_MIN,'||
                    'DD_TPO_SALDO_MAX,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) ' ||
                    'SELECT '||V_ESQUEMA ||'.S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(3)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(4)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TPO(6)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(7)),'''','''''') || ''',sysdate,' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TPO(8)),'''','''''') || ''',' ||
                    '(SELECT DD_TAC_ID FROM '|| V_ESQUEMA ||'.DD_TAC_TIPO_ACTUACION WHERE DD_TAC_CODIGO=''' || TRIM(V_TMP_TIPO_TPO(9)) || '''),' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(10)) || ''',''' || TRIM(V_TMP_TIPO_TPO(11)) || ''',''' || TRIM(V_TMP_TIPO_TPO(12)) || ''',' ||
                    '''' || TRIM(V_TMP_TIPO_TPO(13)) || ''',''' || TRIM(V_TMP_TIPO_TPO(14)) || ''',''' || TRIM(V_TMP_TIPO_TPO(15)) ||
                     ''',''' || TRIM(V_TMP_TIPO_TPO(16)) || ''' FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TPO(1) ||''','''||TRIM(V_TMP_TIPO_TPO(2))||'''');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Procedimiento');
    
    -- LOOP Insertando valores en TAP_TAREA_PROCEDIMIENTO
    VAR_TABLENAME := 'TAP_TAREA_PROCEDIMIENTO';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar TAREAS');
    FOR I IN V_TIPO_TAP.FIRST .. V_TIPO_TAP.LAST
      LOOP
        V_TMP_TIPO_TAP := V_TIPO_TAP(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||VAR_TABLENAME||' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
        IF V_NUM_TABLAS > 0 THEN				
        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET TAP_VIEW=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_VALIDACION_JBPM=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',' ||
        	' TAP_SCRIPT_DECISION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' ||
        	' DD_STA_ID=(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
            ' DD_TSUP_ID=(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' || 
            ' DD_TPO_ID_BPM=(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || TRIM(V_TMP_TIPO_TAP(7)) || ''')' || 
        	' WHERE DD_TPO_ID = (SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(1))||''') and TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAP(2))||'''';
			--DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL;	
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||VAR_TABLENAME||'... Actualizada la tarea '''|| TRIM(V_TMP_TIPO_TAP(2)) ||''', ' || TRIM(V_TMP_TIPO_TAP(3)));
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'TAP_ID,DD_TPO_ID,TAP_CODIGO,TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,DD_TPO_ID_BPM,' ||
                    'TAP_SUPERVISOR,TAP_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO,TAP_ALERT_NO_RETORNO,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,' ||
                    'TAP_AUTOPRORROGA,DTYPE,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID,TAP_EVITAR_REORG,DD_TSUP_ID,TAP_BUCLE_BPM) ' ||
                    'SELECT ' || V_ESQUEMA || '.' ||
                    'S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL, ' ||
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(1)),'''','''''')  || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(5)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(6)),'''','''''') || ''',' || 
                    '(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || REPLACE(TRIM(V_TMP_TIPO_TAP(7)),'''','''''') || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
                    'sysdate,''' || REPLACE(TRIM(V_TMP_TIPO_TAP(12)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(13)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(15)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(17)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(19)),'''','''''') || ''',' || 
                    '(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(21)),'''','''''') || ''',' ||
                    '(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TAP(23)),'''','''''') || ''' FROM DUAL';
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''||V_TMP_TIPO_TAP(2)||''','''||TRIM(V_TMP_TIPO_TAP(9))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
          END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tareas');


    -- LOOP Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    VAR_TABLENAME := 'DD_PTP_PLAZOS_TAREAS_PLAZAS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar PLAZOS');
    FOR I IN V_TIPO_PLAZAS.FIRST .. V_TIPO_PLAZAS.LAST
      LOOP
        V_TMP_TIPO_PLAZAS := V_TIPO_PLAZAS(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;    
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Ya existe el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(DD_PTP_ID,DD_JUZ_ID,DD_PLA_ID,TAP_ID,DD_PTP_PLAZO_SCRIPT,VERSION,BORRADO,USUARIOCREAR,FECHACREAR)' ||
                    'SELECT ' ||
                    ''||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL, ' ||
                    '(SELECT DD_JUZ_ID FROM ' || V_ESQUEMA || '.DD_JUZ_JUZGADOS_PLAZA WHERE DD_JUZ_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(1)) || '''), ' ||
                    '(SELECT DD_PLA_ID FROM ' || V_ESQUEMA || '.DD_PLA_PLAZAS WHERE DD_PLA_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(2)) || '''), ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_PLAZAS(3)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''', sysdate FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_PLAZAS(3) ||''','''||TRIM(V_TMP_TIPO_PLAZAS(4))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Plazos');

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
        
        	V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET TFI_TIPO=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
        	' TFI_NOMBRE=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',' ||
        	' TFI_LABEL=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
        	' TFI_ERROR_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',' ||
        	' TFI_VALIDACION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
        	' TFI_VALOR_INICIAL=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',' ||
        	' TFI_BUSINESS_OPERATION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || '''' ||
        	' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
			--DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL;	
	        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Actualizado el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_NOMBRE = '||TRIM(V_TMP_TIPO_TFI(4))||' ');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    ''||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            --DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
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
