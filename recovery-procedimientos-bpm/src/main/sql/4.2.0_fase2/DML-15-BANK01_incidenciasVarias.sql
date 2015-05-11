--/*
--##########################################
--## Author: Gonzalo E.
--## Finalidad: DML
--##            
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
    --Insertando valores en TFI_TAREAS_FORM_ITEMS
    TYPE T_TIPO_TFI IS TABLE OF VARCHAR2(5000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TIPO_TFI;
    V_TIPO_TFI T_ARRAY_TFI := T_ARRAY_TFI(
       T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAEntidad','2','combo','comboEntidadAdjudicataria','Entidad Adjudicataria','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false','dameEntidadAdjudicatariaBien()','DDEntidadAdjudicataria','0','DD'),
       T_TIPO_TFI('P413_notificacionDecretoAdjudicacionAEntidad','3','combo','fondo','Fondo',null,null,'dameEntidadAdjudicatariaFondoBien()','DDTipoFondo','0','DD')
    ); 
    V_TMP_TIPO_TFI T_TIPO_TFI;
    VAR_TXT_1 VARCHAR(1000 CHAR);
    
BEGIN


	DBMS_OUTPUT.PUT_LINE('[INICIO] RESOLUCION INCIDENCIAS');
	
	DBMS_OUTPUT.PUT_LINE('[INCIDENCIA: 16E-INC-18]');
	execute immediate 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla debería confirmar si el bien se encuentra ocupado o no, si dispone de la documentación de detección de ocupantes, en caso afirmativo, deberá indicar si existe o no inquilino y en tal caso la fecha del contrato de arrendamiento y el nombre del arrendatario. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Los campos Fecha vista y Fecha fin para alegaciones deberá de consignarlos en caso de ya disponer de dicha información.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla en caso de no disponer de la documentación de detección se lanzará la tarea "Solicitud de requerimiento documentación a ocupantes", en caso contrario se lanzará la tarea "Registrar Informe de Situación".</p></div>'' WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO=''P419_TrasladoDocuDeteccionOcupantes'') AND TFI_NOMBRE=''titulo''';

	DBMS_OUTPUT.PUT_LINE('[INCIDENCIA: 24N-INC-119]');
	execute immediate 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deberá de revisar las cargas anteriores y posteriores registradas en el bien vinculado al procedimiento. En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligará a asociarlo a través de la pestaña bienes del procedimiento. Para cada carga deberá indicar si es de tipo Registral, si es de tipo Económico y en caso de no existir cargas indicarlo expresamente en el campo destinado a tal efecto. En cualquier cado deberá indicar en la ficha de cargas del bien la fecha en que haya realizado la revisión de las mismas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá indicar la fecha en que se le haya entregado el avalúo de cargas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla y dependiendo de como hayan quedado las cargas del bien adjudicado se podrán iniciar las siguientes tareas:</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">- En caso de haber alguna carga registral y no económica se lanzará la tarea "Registrar presentación de inscripción".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">- En caso de haber alguna carga económica se lanzará la tarea "Tramitar propuesta de cancelación de cargas".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">- En caso de haber quedado el bien en situación "Sin cargas" se lanzará una tarea de tipo decisión por la cual deberá de proponer a la entidad la próxima actuación a realizar.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p></div>'' WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO=''P415_RevisarEstadoCargas'') AND TFI_NOMBRE=''titulo''';
	
	DBMS_OUTPUT.PUT_LINE('[24N-INC-117]');
	execute immediate 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá de adjuntar el acta de subasta al procedimiento correspondiente a través de la pestaña Adjuntos.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo fecha consignar la fecha en que da por terminada el acta de subasta y proceda a subirla a la plataforma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será, en caso de haber uno o más bienes adjudicados a un tercero "Solicitar mandamiento de pago" y en caso de habérselo adjudicado la entidad uno o más bienes "Contabilizar activo y cierre de deudas".</p></div>'' WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO=''P401_RegistrarActaSubasta'') AND TFI_NOMBRE=''titulo''';
	
	DBMS_OUTPUT.PUT_LINE('[16E-INC-2]');
	VAR_TXT_1 := 'comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">El bien debe estar asociado al tr&aacute;mite, as&oacute;cielo desde la pesta&ntilde;a de Bienes del procedimiento para poder finalizar esta tarea.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P413_SolicitudDecretoAdjudicacion''';
	VAR_TXT_1 := 'isBienesConFechaDecreto() && !isBienesConFechaRegistro() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</div>'''' : null';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P60_RegistrarAnotacion''';
	VAR_TXT_1 := '!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</div>'''' : (tieneBienes() && !isBienesConFechaSolicitud() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</div>'''' : null)';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P17_InterposicionDemandaMasBienes''';
	VAR_TXT_1 := '!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</div>'''' : (tieneBienes() && !isBienesConFechaSolicitud() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</div>'''' : null)';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P15_InterposicionDemandaMasBienes''';
	VAR_TXT_1 := '!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</div>'''' : (tieneBienes() && !isBienesConFechaSolicitud() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</div>'''' : null)';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P16_InterposicionDemanda''';
	VAR_TXT_1 := '!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</div>'''' : (tieneBienes() && !isBienesConFechaSolicitud() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pesta&ntilde;a Bienes dentro de la ficha de la propia actuaci&oacute;n.</div>'''' : null)';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P16_InterposicionDemanda''';
	
	VAR_TXT_1 := 'comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoPSSB() ? (comprobarExisteDocumentoFSSF() ? (comprobarExisteDocumentoFSSB() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Ficha suelo SAREB</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Front-sheet SAREB</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Plantilla subasta SAREB</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P409_PrepararPropuestaSubasta''';
	VAR_TXT_1 := 'comprobarInformacionCompletaInstrucciones() ? (comprobarExisteDocumentoPRI()? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento propuesta de instrucciones</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">La informaci&oacute;n de las instrucciones de los lotes no est&aacute; completa.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P401_PrepararPropuestaSubasta''';
	
	VAR_TXT_1 := 'comprobarExisteDocumentoDJP() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento diligencia judicial de la posesi&oacute;n</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P416_RegistrarPosesionYLanzamiento''';
	VAR_TXT_1 := 'valores[''''P416_RegistrarPosesionYLanzamiento''''][''''comboOcupado''''] == ''''02'''' && (valores[''''P416_RegistrarPosesionYLanzamiento''''][''''fecha''''] == null || valores[''''P416_RegistrarPosesionYLanzamiento''''][''''comboFuerzaPublica''''] == null || valores[''''P416_RegistrarPosesionYLanzamiento''''][''''comboLanzamiento''''] == null) ? ''''Los campos <b>Fecha realizaci&oacute;n de la posesi&oacute;n</b>, <b>Necesario Fuerza P&uacute;blica</b> y <b>Lanzamiento Necesario</b> son obligatorios.'''' : (valores[''''P416_RegistrarPosesionYLanzamiento''''][''''comboLanzamiento'''']  == ''''01'''' && valores[''''P416_RegistrarPosesionYLanzamiento''''][''''fechaSolLanza''''] == null) ? ''''El campo <b>Fecha solicitud de lanzamiento</b> es obligatorio.'''' : null';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P416_RegistrarPosesionYLanzamiento''';
	VAR_TXT_1 := 'comprobarAdjuntoDocumentoLiquidacionImpuestos() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar la copia escaneada del Documento de Liquidaci&oacute;n de Impuestos.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P413_RegistrarPresentacionEnHacienda''';
	VAR_TXT_1 := 'comprobarGestoriaAsignadaPrc() ? comprobarAdjuntoDecretoFirmeAdjudicacion() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar el Decreto Firme de Adjudicaci&oacute;n.</div>'''' : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe asignar la Gestor&iacute;a encargada de tramitar la adjudicaci&oacute;n.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P413_ConfirmarTestimonio''';
	VAR_TXT_1 := 'comprobarExisteDocumentoISP() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento informe de situaci&oacute;n de la posesi&oacute;n.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P419_RegistrarInformeSituacion''';
	VAR_TXT_1 := 'comprobarExisteDocumentoPCC() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento propuesta de cancelaci&oacute;n de las cargas.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P415_PropuestaCancelacionCargas''';
	VAR_TXT_1 := 'comprobarEstadoCargasCancelacion() ? (comprobarExisteDocumentoEDCINR() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento escritura o documento cancelaci&oacute;n inscrito y nota registral.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">El estado de todas las cargas registrales debe ser estado cancelada.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P415_RegInsCancelacionCargasReg''';
	VAR_TXT_1 := '!todosNotificados() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe notificar todos los demandados o excluirlos.</div>'''' : null';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P400_GestionarNotificaciones''';
	VAR_TXT_1 := '!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</div>'''' : (comprobarExisteDocumentoDSCC() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento demanda sellada + certificaci&oacute;n de cargas (cuando se obtenga).</div>'''')';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P01_DemandaCertificacionCargas''';

	VAR_TXT_1 := '!asuntoConProcurador() ? ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</div>'''' : null';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P01_DemandaCertificacionCargas''';


	VAR_TXT_1 := 'comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe tener un bien asociado al procedimiento.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P416_RegistrarSolicitudPosesion''';
	VAR_TXT_1 := 'comprobarExisteDocumentoDJL() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento diligencia judicial del lanzamiento.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P416_RegistrarLanzamientoEfectuado''';
	VAR_TXT_1 := 'comprobarBienAsociadoPrc() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe seleccionar un BIEN para poder realizar el tramite de gesti&oacute;n de llaves.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P417_RegistrarCambioCerradura''';
	VAR_TXT_1 := 'comprobarGestoriaAsignadaAlSaneamientoDeCargasDeBienes() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe asignar la Gestor&iacute;a encargada del saneamiento de cargas del bien.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P413_RegistrarInscripcionDelTitulo''';
	VAR_TXT_1 := 'comprobarExisteDocumentoDUEDIL() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento DUE-DILIGENCE.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P409_RegistrarResultadoDUE''';
	VAR_TXT_1 := 'comprobarExisteDocumentoACS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Acta de subasta.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P409_RegistrarActaSubasta''';
	VAR_TXT_1 := 'comprobarImporteEntidadAdjudicacionBienes() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe rellenar en cada bien el importe adjudicaci&oacute;n y la entidad.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P409_CelebracionSubasta''';
	VAR_TXT_1 := 'valores[''''P409_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? (valores[''''P409_CelebracionSubasta''''][''''comboSuspension''''] == null ? ''''El campo suspensi&oacute;n es obligatorio'''' : (valores[''''P409_CelebracionSubasta''''][''''comboMotivo''''] == null ? ''''Campo motivo es obligatorio'''' : null )) : (valores[''''P409_CelebracionSubasta''''][''''comboCesion''''] == null ? ''''Campo cesi&oacute;n es obligatorio'''' : (valores[''''P409_CelebracionSubasta''''][''''comboCesion''''] == ''''01'''' ? (valores[''''P409_CelebracionSubasta''''][''''comboComite''''] == null ? ''''Campo comit&eacute; es obligatorio'''' : null) : null ))';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P409_CelebracionSubasta''';
	
	VAR_TXT_1 := 'comprobarExisteDocumentoINS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe adjuntar el informe de subasta al procedimiento.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P409_AdjuntarInformeSubasta''';
	VAR_TXT_1 := 'comprobarExisteDocumentoESRAS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P409_SenyalamientoSubasta''';
	VAR_TXT_1 := 'comprobarMinimoBienLote() ? (comprobarBienInformado() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no, la situaci&oacute;n posesoria y el tipo de subasta.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Al menos un bien debe estar asignado a un lote.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P409_SolicitudSubasta''';
	VAR_TXT_1 := 'comprobarBienAsociadoPrc() ? (comprobarTipoCargaBienInscrito() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Para cada una de las cargas, debe especificar el tipo y estado.</div>''''): ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe tener un bien asociado al procedimiento.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P415_RevisarEstadoCargas''';
	VAR_TXT_1 := 'comprobarEstadoCargasPropuesta() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Todas las cargas deben ser informadas en estado cancelada o rechazada.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P415_RegInsCancelacionCargasEconomicas''';
	VAR_TXT_1 := 'comprobarExisteDocumentoACS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Acta de subasta.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P401_RegistrarActaSubasta''';
	VAR_TXT_1 := 'comprobarImporteEntidadAdjudicacionBienes() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Debe rellenar en cada bien el importe adjudicaci&oacute;n y la entidad.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P401_CelebracionSubasta''';
	VAR_TXT_1 := 'valores[''''P401_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? (valores[''''P401_CelebracionSubasta''''][''''comboSuspension''''] == null ? ''''El campo suspensi&oacute;n es obligatorio'''' : (valores[''''P401_CelebracionSubasta''''][''''comboMotivo''''] == null ? ''''Campo motivo es obligatorio'''' : null )) : (valores[''''P401_CelebracionSubasta''''][''''comboCesion''''] == null ? ''''Campo cesi&oacute;n es obligatorio'''' : (valores[''''P401_CelebracionSubasta''''][''''comboCesion''''] == ''''01'''' ? (valores[''''P401_CelebracionSubasta''''][''''comboComite''''] == null ? ''''Campo comit&eacute; es obligatorio'''' : null) : null ))';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P401_CelebracionSubasta''';

	VAR_TXT_1 := 'comprobarExisteDocumentoINS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento informe de subasta al procedimiento.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P401_AdjuntarInformeSubasta''';
	VAR_TXT_1 := 'comprobarTipoSubastaInformado() ? (comprobarExisteDocumentoESRAS() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento Edicto de subasta y resoluci&oacute;n acordando se&ntilde;alamiento.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado el tipo de subasta.</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P401_SenyalamientoSubasta''';
	VAR_TXT_1 := 'comprobarMinimoBienLote() ? (comprobarBienInformado() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Los bienes con lote deben tener informado las cargas anteriores y posteriores, si es vivienda habitual o no, la situaci&oacute;n posesoria y el tipo de subasta.</div>'''') : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Al menos un bien debe estar asignado a un lote</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P401_SolicitudSubasta''';
	VAR_TXT_1 := 'comprobarExisteDocumentoRCT() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento respuesta a la consulta de tributaci&oacute;n</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P411_RegistrarResolucionConsulta''';

	VAR_TXT_1 := 'comprobarExisteDocumentoRCT() ? null : ''''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;">Es necesario adjuntar el documento respuesta a la consulta de tributaci&oacute;n</div>''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P411_RegistrarResolucionConsulta''';
	
	VAR_TXT_1 := '((valores[''''P03_ConfirmarOposicion''''][''''comboResultado''''] == DDSiNo.SI) && ((valores[''''P03_ConfirmarOposicion''''][''''fechaOposicion''''] == null) || (valores[''''P03_ConfirmarOposicion''''][''''fechaAudiencia''''] == null)))?''''Debe introducir la fecha de oposici&oacute;n y fecha de audiencia.'''':null';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P03_ConfirmarOposicion''';

	VAR_TXT_1 := 'existenInstruccionesEnTarea() ? null : ''''Debe indicar las instrucciones para la empresa de preparaci&oacute;n del expediente.''''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P402_DictarInstrucciones''';
	VAR_TXT_1 := 'valores[''''P416_RegistrarPosesionYLanzamiento''''][''''comboOcupado''''] == ''''02'''' && (valores[''''P416_RegistrarPosesionYLanzamiento''''][''''fecha''''] == null || valores[''''P416_RegistrarPosesionYLanzamiento''''][''''comboFuerzaPublica''''] == null || valores[''''P416_RegistrarPosesionYLanzamiento''''][''''comboLanzamiento''''] == null) ? ''''Los campos <b>Fecha realizaci&oacute;n de la posesi&oacute;n</b>, <b>Necesario Fuerza P&uacute;blica</b> y <b>Lanzamiento Necesario</b> son obligatorios.'''' : (valores[''''P416_RegistrarPosesionYLanzamiento''''][''''comboLanzamiento'''']  == ''''01'''' && valores[''''P416_RegistrarPosesionYLanzamiento''''][''''fechaSolLanza''''] == null) ? ''''El campo <b>Fecha solicitud de lanzamiento</b> es obligatorio.'''' : null';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P416_RegistrarPosesionYLanzamiento''';
	VAR_TXT_1 := 'valores[''''P409_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? (valores[''''P409_CelebracionSubasta''''][''''comboSuspension''''] == null ? ''''El campo suspensi&oacute;n es obligatorio'''' : (valores[''''P409_CelebracionSubasta''''][''''comboMotivo''''] == null ? ''''Campo motivo es obligatorio'''' : null )) : (valores[''''P409_CelebracionSubasta''''][''''comboCesion''''] == null ? ''''Campo cesi&oacute;n es obligatorio'''' : (valores[''''P409_CelebracionSubasta''''][''''comboCesion''''] == ''''01'''' ? (valores[''''P409_CelebracionSubasta''''][''''comboComite''''] == null ? ''''Campo comit&eacute; es obligatorio'''' : null) : null ))';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P409_CelebracionSubasta''';
	VAR_TXT_1 := 'valores[''''P401_CelebracionSubasta''''][''''comboCelebrada''''] == ''''02'''' ? (valores[''''P401_CelebracionSubasta''''][''''comboSuspension''''] == null ? ''''El campo suspensi&oacute;n es obligatorio'''' : (valores[''''P401_CelebracionSubasta''''][''''comboMotivo''''] == null ? ''''Campo motivo es obligatorio'''' : null )) : (valores[''''P401_CelebracionSubasta''''][''''comboCesion''''] == null ? ''''Campo cesi&oacute;n es obligatorio'''' : (valores[''''P401_CelebracionSubasta''''][''''comboCesion''''] == ''''01'''' ? (valores[''''P401_CelebracionSubasta''''][''''comboComite''''] == null ? ''''Campo comit&eacute; es obligatorio'''' : null) : null ))';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM='''||VAR_TXT_1||''' WHERE TAP_CODIGO=''P401_CelebracionSubasta''';
	
	DBMS_OUTPUT.PUT_LINE('[INCIDENCIA: 24N-INC-89]');
	execute immediate 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN=4 WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO=''P413_notificacionDecretoAdjudicacionAEntidad'') AND TFI_NOMBRE=''comboSubsanacion''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN=5 WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO=''P413_notificacionDecretoAdjudicacionAEntidad'') AND TFI_NOMBRE=''observaciones''';
	execute immediate 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW=''plugin/procedimientos/tramiteDeAdjudicacion/notificacionDecretoAdjudicacionAEntidad'' WHERE TAP_CODIGO=''P413_notificacionDecretoAdjudicacionAEntidad''';
	
	DBMS_OUTPUT.PUT_LINE('[FIN] RESOLUCION INCIDENCIAS');
	DBMS_OUTPUT.PUT_LINE('[NUEVOS CAMPOS EN TAREAS ...]');

    -- LOOP Insertando valores en TFI_TAREAS_FORM_ITEMS
    VAR_TABLENAME := 'TFI_TAREAS_FORM_ITEMS';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar Campos de tareas');
    FOR I IN V_TIPO_TFI.FIRST .. V_TIPO_TFI.LAST
      LOOP
        V_TMP_TIPO_TFI := V_TIPO_TFI(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TFI(1))||''') and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2));
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TFI_TAREAS_FORM_ITEMS... Ya existe el item '''|| TRIM(V_TMP_TIPO_TFI(1)) ||''' and TFI_ORDEN = '||TRIM(V_TMP_TIPO_TFI(2))||' ');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || 
                    '(TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,BORRADO)' ||
                    'SELECT ' ||
                    'S_TFI_TAREAS_FORM_ITEMS.NEXTVAL, ' ||
                    '(SELECT TAP_ID FROM ' || V_ESQUEMA || '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''' || TRIM(V_TMP_TIPO_TFI(1)) || '''), ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(2)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(3)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(4)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(5)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(6)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(7)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(8)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(9)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_TFI(10)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_TFI(11)),'''','''''') || ''',sysdate,0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: ''' || V_TMP_TIPO_TFI(1) ||''','''||TRIM(V_TMP_TIPO_TFI(4))||'''');
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
      END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Campos');
        
COMMIT;

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

