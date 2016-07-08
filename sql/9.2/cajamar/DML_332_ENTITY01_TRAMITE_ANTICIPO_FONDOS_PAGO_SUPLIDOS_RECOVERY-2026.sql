/*
--##########################################
--## AUTOR=SERGIO NIETO
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.7
--## INCIDENCIA_LINK=RECOVERY-2026
--## PRODUCTO=NO
--##
--## Finalidad: BPM - Procedimiento Cambiario
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


    --Insertando valores en TAP_TAREA_PROCEDIMIENTO
    
    --FALTA CAMBIAR LA RUTA DE LAS JSP
    TYPE T_TIPO_TAP IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_TAP IS TABLE OF T_TIPO_TAP;
    V_TIPO_TAP T_ARRAY_TAP := T_ARRAY_TAP(
		T_TIPO_TAP('CJ460','CJ460_SolicitarAnticipoFondos' ,null ,null ,'!validarP460SolicitudFondos() ? ''Los campos N&uacute;mero de auto, Importe de la adjudicaci&oacute;n, Tipo de impuesto a liquidar, Tipo del impuesto de Transmisiones patrimoniales, Importe del impuesto de transmisiones Patrimoniales y Fecha fin de plazo de liquidaci&oacute;n del impuesto son obligatorios.'' : valores[''CJ460_SolicitarAnticipoFondos''][''tipoSolicitud''] == null ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario indicar el tipo de solicitud.</p></div>'' : valores[''CJ460_SolicitarAnticipoFondos''][''tipoSolicitud''] == "ANTFON" ? existeAdjuntoUG(''PRVFND'', ''PRC'') ? null : existeAdjuntoUGMensaje(''PRVFND'',''PRC'') : existeAdjuntoUG(''DOCSUP'', ''PRC'') ? null : existeAdjuntoUGMensaje(''DOCSUP'',''PRC'')' ,null ,null ,'0','Solicitar anticipo de Fondos o pago de suplidos' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ460','CJ460_VisarSolicitud' ,null ,null ,'valores[''CJ460_VisarSolicitud''][''fecha''] == null || valores[''CJ460_VisarSolicitud''][''fecha''] == '''' ? ''El campo "Fecha" es obligatorio.'' : null' ,'valores[''CJ460_VisarSolicitud''][''conforme''] == DDSiNo.NO ? ''KO'' : (valoresBPMPadre[''H005_ConfirmarTestimonio''] != null ? ''SI'' : ''NO'')' ,null ,'0','Visar solicitud' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ460','CJ460_RevisarSolicitud' ,null ,null ,null ,'valores[''CJ460_RevisarSolicitud''][''motivo'']==''SUB'' ? ''subsanar'' : (bienConCesionRemate() ? ''cesion'' : ''otro'')' ,null ,'0','Revisar solicitud' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ460','CJ460_AprobarSolicitudFondos' ,null ,null ,null ,'valores[''CJ460_AprobarSolicitudFondos''][''confirmacion'']==DDSiNo.SI ? ''sinatribuciones'' : valores[''CJ460_AprobarSolicitudFondos''][''resultado'']' ,null ,'0','Aprobar solicitud de fondos' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ460','CJ460_AprobarSolicitudInsc' ,null ,null ,null ,'valores[''CJ460_AprobarSolicitudInsc''][''resultado'']' ,null ,'0','Aprobar solicitud para inscripción' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ460','CJ460_ConfirmarSolicitud' ,null ,null ,null ,'valores[''CJ460_ConfirmarSolicitud''][''resultado''] == ''ACEPTADO'' ? ''aceptado'' : ''denegado''' ,null ,'0','Autorizar solicitud' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ460','CJ460_RealizarTransferencia' ,null ,null ,null ,null ,null ,'0','Realizar transferencia' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ460','CJ460_ConfirmarTransferencia' ,null ,null ,null ,'valores[''CJ460_SolicitarAnticipoFondos''][''tipoSolicitud'']' ,null ,'0','Confirmar transferencia realizada' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null),
		T_TIPO_TAP('CJ460','CJ460_AdjuntarFactura' ,null ,'existeAdjuntoUG(''FACJUS'', ''PRC'') ? null : existeAdjuntoUGMensaje(''FACJUS'',''PRC'')' ,null ,'valores[''CJ460_SolicitarAnticipoFondos''][''tipoSolicitud'']' ,null ,'0','Adjuntar factura a nombre de la entidad' ,'0','RECOVERY-2026','0' ,null ,null ,null,'1' ,'EXTTareaProcedimiento','3',null ,null,null ,null,null)
    );
	V_TMP_TIPO_TAP T_TIPO_TAP;

    --Insertando valores en DD_PTP_PLAZOS_TAREAS_PLAZAS
    TYPE T_TIPO_PLAZAS IS TABLE OF VARCHAR2(1000);
    TYPE T_ARRAY_PLAZAS IS TABLE OF T_TIPO_PLAZAS;
    V_TIPO_PLAZAS T_ARRAY_PLAZAS := T_ARRAY_PLAZAS(
		T_TIPO_PLAZAS(null ,null ,'CJ460_SolicitarAnticipoFondos','1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ460_VisarSolicitud','1*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ460_RevisarSolicitud','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ460_AprobarSolicitudFondos','2*24*60*60*1000L','0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ460_AprobarSolicitudInsc','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ460_ConfirmarSolicitud','3*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ460_RealizarTransferencia','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ460_ConfirmarTransferencia','2*24*60*60*1000L' ,'0','0','RECOVERY-2026'),
		T_TIPO_PLAZAS(null ,null ,'CJ460_AdjuntarFactura','10*24*60*60*1000L' ,'0','0','RECOVERY-2026')
    ); 
	V_TMP_TIPO_PLAZAS T_TIPO_PLAZAS;
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; indicar si solicita un anticipo de fondos o el pago de suplidos, la fecha en la que lo solicita , el n&uacute;mero de auto, el n&uacute;mero expediente de cajamar, el principal reclamado, el importe solicitado, y, en los casos que proceda, el importe de la adjudicaci&oacute;n, el motivo de la solicitud, el tipo de impuesto a liquidar,  el importe del impuesto a liquidar y la fecha de fin de plazo para la liquidaci&oacute;n.</p><p>En el caso de seleccionar pago de suplidos, deber&aacute; adjuntar factura de suplidos, emitida a cargo de la entidad.</p><p>En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento. Una vez rellene esta pantalla:  Se lanzar&aacute; la tarea de Visar solicitud para el Letrado.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','2','text' ,'numAuto','Número de auto' ,null ,null ,'dameNumAuto()' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','3','text' ,'numExpte','Referencia Cajamar' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','4','currency' ,'principal','Principal reclamado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()' ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','5','currency' ,'importeProv','Importe provisión solicitada' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','6','currency' ,'importeAdj','Importe de la adjudicación' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','7','combo' ,'motivo','Motivo solicitud' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDProvisionFondosMotivo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','8','combo' ,'tipoImpLiquidar','Tipo de impuesto a liquidar' ,null ,null ,null ,'DDProvisionFondosTipoImpuesto','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','9','currency' ,'tipoImpTrPatr','Tipo de impuesto de Trans. Patr.' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','10','currency' ,'impTrPatr','Imp. de impuestode Trans. Patr.' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','11','date' ,'fechaFinLiqImp','Fecha fin plazo liq. impuesto' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','12','combo' ,'tipoSolicitud','Tipo de solicitud' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDTipoSolicitud','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_SolicitarAnticipoFondos','13','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_VisarSolicitud','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; de dar su confirmaci&oacute;n a la solicitud formulada por el procurador</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_VisarSolicitud','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_VisarSolicitud','2','combo' ,'conforme','Conforme con la solicitud' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_VisarSolicitud','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_RevisarSolicitud','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En caso de tratarse de una provisi&oacute;n para la adjudicaci&oacute;n de un bien tras la subasta, a trav&eacute;s de esta pantalla deber&aacute; informar de la fecha en la que se toma una decisi&oacute;n sobre la solicitud de provisi&oacute;n de fondos y el resultado de dicha decisi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, el siguiente paso ser&aacute;:</p><p style="margin-bottom: 10px">-En caso de requerir subsanaci&oacute;n, se volver&aacute; a lanzar la tarea "Solicitud anticipo de fondos o pago de suplidos" al procurador.</p><p style="margin-bottom: 10px">En caso de cesi&oacute;n de remate, se lanzar&aacute; la tarea "Aprobar solicitud de fondos".</p><p style="margin-bottom: 10px">-En caso contrario, se lanzar&aacute; la tarea "Aprobar solicitud para inscripci&oacute;n" al gestor de contencioso gesti&oacute;n.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_RevisarSolicitud','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_RevisarSolicitud','2','combo' ,'motivo','Motivo solicitud' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDAceptarSubsanar','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_RevisarSolicitud','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AprobarSolicitudFondos','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar de la fecha en la que se toma una decisi&oacute;n sobre la solicitud de provisi&oacute;n de fondos y el resultado de dicha decisi&oacute;n.</p><p style="margin-bottom: 10px">En caso de no tener atribuciones para confirmar la provisi&oacute;n por la cuant&iacute;a solicitada, deber&aacute; indicarlo en el campo "Requiere confirmaci&oacute;n".</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, el siguiente paso ser&aacute;:</p><p style="margin-bottom: 10px">-En caso de no tener atribuciones, se lanzar&aacute; una tarea a la Entidad para autorizar la provisi&oacute;n de fondos solicitada.</p><p style="margin-bottom: 10px">-En caso de que se apruebe la solicitud con atribuciones, se lanzar&aacute; la tarea "Realizar transferencia".</p><p style="margin-bottom: 10px">-En caso de error en la solicitud, volveremos a la tarea anterior para que el gestor que la envi&oacute; para que subsane lo comentado en la aprobaci&oacute;n de la solicitud.</p><p style="margin-bottom: 10px">-En caso de rechazo, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AprobarSolicitudFondos','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AprobarSolicitudFondos','2','combo' ,'confirmacion','Requiere confirmación' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDSiNo','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AprobarSolicitudFondos','3','combo' ,'resultado','Resultado solicitud' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDProvisionFondosResultado','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AprobarSolicitudFondos','4','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AprobarSolicitudInsc','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacute;s de esta pantalla deber&aacute; informar de la fecha en la que se toma una decisi&oacute;n sobre la solicitud de provisi&oacute;n de fondos y el resultado de dicha decisi&oacute;n.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, el siguiente paso ser&aacute;:</p><p style="margin-bottom: 10px">-En caso de que se apruebe la solicitud, se lanzar&aacute; la tarea "Realizar transferencia".</p><p style="margin-bottom: 10px">-En caso de rechazo, se le abrir&aacute; una tarea en la que propondr&aacute;, seg&uacute;n su criterio, la siguiente actuaci&oacute;n al responsable de la entidad.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AprobarSolicitudInsc','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AprobarSolicitudInsc','2','combo' ,'resultado','Resultado solicitud' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDAceptadoRechazado','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AprobarSolicitudInsc','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_ConfirmarSolicitud','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta tarea, la Entidad deber&aacute; autorizar o denegar la solicitud de provisi&oacute;n de fondos realizada por el letrado.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, y si la Entidad autoriza la provisi&oacute;n, se lanzar&aacute; la tarea Realizar transferencia. En caso contrario, la Entidad deber&aacute; indicar c&oacute;mo proceder.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_ConfirmarSolicitud','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_ConfirmarSolicitud','2','combo' ,'resultado','Resultado' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,'DDAceptadoDenegado','0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_ConfirmarSolicitud','3','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_RealizarTransferencia','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por finalizada esta tarea, deber&aacute hacer una transferencia por el importe aprobado y se generar&aacute una notificaci&oacuten al procurador.</p><p style="margin-bottom: 10px">En el campo Fecha indicar la fecha en la que realiza la transferencia.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellena esta pantalla, se lanzar&aacute la tarea Confirmar transferencia realizada.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_RealizarTransferencia','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_RealizarTransferencia','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_ConfirmarTransferencia','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacutes de esta pantalla el procurador confirmar&aacute la fecha en la que ha recibido la transferencia.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_ConfirmarTransferencia','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_ConfirmarTransferencia','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AdjuntarFactura','0','label' ,'titulo','<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&eacutes de esta pantalla el procurador confirmar&aacute la fecha en la que ha recibido la transferencia.</p><p style="margin-bottom: 10px">En el campo Observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>' ,null ,null ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AdjuntarFactura','1','date' ,'fecha','Fecha' ,'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio' ,'valor != null && valor != '' ? true : false' ,null ,null,'0','RECOVERY-2026'),
		T_TIPO_TFI('CJ460_AdjuntarFactura','2','textarea' ,'observaciones','Observaciones' ,null ,null ,null ,null,'0','RECOVERY-2026')
    );
    V_TMP_TIPO_TFI T_TIPO_TFI;
    
BEGIN	
	
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
          ' TAP_DESCRIPCION=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(9)),'''','''''') || ''',' ||
          ' DD_TPO_ID_BPM=(SELECT DD_TPO_ID FROM ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = ''' || TRIM(V_TMP_TIPO_TAP(7)) || '''),' ||
          ' TAP_ALERT_VUELTA_ATRAS=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(14)),'''','''''') || ''',' ||
          ' DD_FAP_ID=(SELECT DD_FAP_ID FROM ' || V_ESQUEMA || '.DD_FAP_FASE_PROCESAL WHERE DD_FAP_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(15)) || '''),' || 
          ' TAP_AUTOPRORROGA=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(16)),'''','''''') || ''',' ||
          ' TAP_MAX_AUTOP=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(18)),'''','''''') || ''',' ||
        	' DD_STA_ID=(SELECT DD_STA_ID FROM ' || V_ESQUEMA_MASTER || '.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(20)) || '''),' || 
          ' DD_TSUP_ID=(SELECT DD_TGE_ID FROM ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO=''' || TRIM(V_TMP_TIPO_TAP(22)) || '''),' ||
          ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TAP(11)),'''','''''') || ''',' ||
          ' FECHAMODIFICAR=sysdate ' ||
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
	  V_SQL := 'UPDATE '||V_ESQUEMA||'.'||VAR_TABLENAME||' SET DD_PTP_PLAZO_SCRIPT=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(4)),'''','''''') || ''',' ||
            ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_PLAZAS(7)),'''','''''') || ''',' ||
            ' FECHAMODIFICAR=sysdate ' ||
        	  ' WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_PLAZAS(3))||''')';
          EXECUTE IMMEDIATE V_SQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Se actualiza el plazo '''|| TRIM(V_TMP_TIPO_PLAZAS(3)) ||'''');
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
        	' TFI_BUSINESS_OPERATION=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
          ' USUARIOMODIFICAR=''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',' ||
          ' FECHAMODIFICAR=sysdate ' ||
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