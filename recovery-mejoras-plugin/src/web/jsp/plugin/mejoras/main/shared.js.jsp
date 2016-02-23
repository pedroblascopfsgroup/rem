<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

//------------------------------------------------
// Extendemos un nuevo tipo de combo que permite con
// la propiedad listAlignOffsets setearle unas dimensiones
//------------------------------------------------
ComboOffset = function(config) {
		ComboOffset.superclass.constructor.call(this, config);
};
	
Ext.extend(ComboOffset, Ext.form.ComboBox, {
	listAlignOffsets: [0, 0],
	// private
    restrictHeight : function(){
        this.innerList.dom.style.height = '';
        var inner = this.innerList.dom;
        var h = Math.max(inner.clientHeight, inner.offsetHeight, inner.scrollHeight);
        this.innerList.setHeight(h < this.maxHeight ? 'auto' : this.maxHeight);
        this.list.beginUpdate();
        this.list.setHeight(this.innerList.getHeight()+this.list.getFrameWidth('tb')+(this.resizable?this.handleHeight:0)+this.assetHeight);
        this.list.alignTo(this.el, this.listAlign, this.listAlignOffsets);
        this.list.endUpdate();
    },
    /**
     * Expands the dropdown list if it is currently hidden. Fires the 'expand' event on completion.
     */
    expand : function(){
        if(this.isExpanded() || !this.hasFocus){
            return;
        }
        this.list.alignTo(this.el, this.listAlign, this.listAlignOffsets);
        this.list.show();
        Ext.get(document).on('mousedown', this.collapseIf, this);
        this.fireEvent('expand', this);
    }

});

//------------------------------------------------



//Agrega funcionalidad al main.js.jsp

app.EURO = '\u20AC';

Ext.Ajax.timeout=10*60*1000; //Timeout de 10 minutos

app.tipoTarea={};
app.tipoTarea.TIPO_TAREA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.TipoTarea.TIPO_TAREA" />';
app.tipoTarea.TIPO_PRORROGA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.TipoTarea.TIPO_PRORROGA" />';
app.tipoTarea.TIPO_NOTIFICACION = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.TipoTarea.TIPO_NOTIFICACION" />';


app.subtipoTarea={};
app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO" />';
app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO" />';
app.subtipoTarea.CODIGO_GESTION_VENCIDOS = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_GESTION_VENCIDOS" />';
app.subtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE" />';
app.subtipoTarea.CODIGO_REVISAR_EXPEDIENE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_REVISAR_EXPEDIENE" />';
app.subtipoTarea.CODIGO_DECISION_COMITE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_DECISION_COMITE" />';
app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE" />';
app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE" />';
app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC" />';
app.subtipoTarea.CODIGO_NOTIFICACION_CONTRATO_CANCELADO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_CONTRATO_CANCELADO" />';
app.subtipoTarea.CODIGO_NOTIFICACION_SALDO_REDUCIDO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_SALDO_REDUCIDO" />';
app.subtipoTarea.CODIGO_NOTIFICACION_CLIENTE_CANCELADO  = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_CLIENTE_CANCELADO" />';
app.subtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_CERRADO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_CERRADO" />';
app.subtipoTarea.CODIGO_NOTIFICACION_CONTRATO_PAGADO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_CONTRATO_PAGADO" />';
app.subtipoTarea.CODIGO_NOTIFICACION_CE_VENCIDA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_CE_VENCIDA" />';
app.subtipoTarea.CODIGO_NOTIFICACION_RE_VENCIDA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_RE_VENCIDA" />';
app.subtipoTarea.CODIGO_NOTIFICACION_DC_VENCIDA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_DC_VENCIDA" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR" />';
app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR" />';
app.subtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR" />';
app.subtipoTarea.CODIGO_NOTIFICACION_SOLICITUD_CANCELACION_EXPEDIENTE_RECHAZADA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_SOLICITUD_CANCELACION_EXPEDIENTE_RECHAZADA" />';
app.subtipoTarea.CODIGO_TAREA_CE_COMPLETADA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_CE_COMPLETADA" />';
app.subtipoTarea.CODIGO_TAREA_RE_COMPLETADA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_RE_COMPLETADA" />';
app.subtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_CE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_CE" />';
app.subtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_RE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_RECHAZAR_SOLICITAR_PRORROGA_RE" />';
app.subtipoTarea.CODIGO_NOTIFICACION_CIERRA_SESION = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_CIERRA_SESION" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR" />';
app.subtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_DECISION_TOMADA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_EXPEDIENTE_DECISION_TOMADA" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR" />';
app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR" />';
app.subtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL" />';
app.subtipoTarea.CODIGO_TAREA_SOLICITUD_PREASUNTO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_SOLICITUD_PREASUNTO" />';
app.subtipoTarea.CODIGO_TAREA_VERIFICAR_TELECOBRO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_VERIFICAR_TELECOBRO" />';
app.subtipoTarea.CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO" />';
app.subtipoTarea.CODIGO_TAREA_RESPUESTA_SOLICITUD_EXCLUSION_TELECOBRO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_RESPUESTA_SOLICITUD_EXCLUSION_TELECOBRO" />';
app.subtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR" />';
app.subtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR" />';
app.subtipoTarea.CODIGO_ASUNTO_PROPUESTO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ASUNTO_PROPUESTO" />';
app.subtipoTarea.CODIGO_RECOPILAR_DOCUMENTACION_PROCEDIMIENTO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_RECOPILAR_DOCUMENTACION_PROCEDIMIENTO" />';
app.subtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR" />';
app.subtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR" />';
app.subtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_GESTOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_GESTOR" />';
app.subtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_SUPERVISOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_SUPERVISOR" />';
app.subtipoTarea.CODIGO_TOMA_DECISION_BPM = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TOMA_DECISION_BPM" />';
app.subtipoTarea.CODIGO_ACUERDO_PROPUESTO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ACUERDO_PROPUESTO" />';
app.subtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO" />';
app.subtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO" />';
app.subtipoTarea.CODIGO_ACUERDO_PROPUESTO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ACUERDO_PROPUESTO" />';
app.subtipoTarea.CODIGO_ACUERDO_RECHAZADO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ACUERDO_RECHAZADO" />';
app.subtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO" />';
app.subtipoTarea.CODIGO_ACUERDO_CERRADO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ACUERDO_CERRADO" />';
app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO" />';
app.subtipoTarea.CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO" />';
app.subtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO" />';
app.subtipoTarea.CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO" />';
app.subtipoTarea.CODIGO_TAREA_JUSTIFICAR_INCUMPLIMIENTO_OBJETIVO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_JUSTIFICAR_INCUMPLIMIENTO_OBJETIVO" />';
app.subtipoTarea.CODIGO_NOTIF_PROPUESTA_OBJETIVO_ACEPTADO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIF_PROPUESTA_OBJETIVO_ACEPTADO" />';
app.subtipoTarea.CODIGO_NOTIF_PROPUESTA_OBJETIVO_RECHAZADO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_NOTIF_PROPUESTA_OBJETIVO_RECHAZADO" />';
app.subtipoTarea.CODIGO_TAREA_SOLICITUD_PRORROGA_TOMADECISION = '<fwk:const value="es.capgemini.pfs.PluginCoreextensionConstantes.CODIGO_TAREA_SOLICITUD_PRORROGA_TOMADECISION" />';
app.subtipoTarea.CODIGO_TAREA_GESTOR_CONFECCION_EXPTE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_TAREA_GESTOR_CONFECCION_EXPTE" />';
app.subtipoTarea.CODIGO_TAREA_SUPERVISOR_CONFECCION_EXPTE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_TAREA_SUPERVISOR_CONFECCION_EXPTE" />';
app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR_EXPTE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR_EXPTE" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR_EXPTE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR_EXPTE" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR_EXPTE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR_EXPTE" />';
app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR_EXPTE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR_EXPTE" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR_EXPTE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_GESTOR_EXPTE" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR_EXPTE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_DE_SUPERVISOR_EXPTE" />';

app.subtipoTarea.CODIGO_NOTIFICACION_INTERCOMUNICACION = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_NOTIFICACION_INTERCOMUNICACION" />';
app.subtipoTarea.CODIGO_TAREA_COMUNICACION_INTERCOMUNICACION = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_INTERCOMUNICACION" />';

app.subtipoTarea.CODIGO_TAREA_COMUNICACION_GESTOR_CONFECCION_EXPTE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_GESTOR_CONFECCION_EXPTE" />';
app.subtipoTarea.CODIGO_TAREA_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE= '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_TAREA_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_GESTOR_CONFECCION_EXPTE= '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_GESTOR_CONFECCION_EXPTE" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_SUPERVISOR_CONFECCION_EXPTE= '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_SUPERVISOR_CONFECCION_EXPTE" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_GESTOR_CONFECCION_EXPTE= '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_GESTOR_CONFECCION_EXPTE" />';
app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE= '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_SUPERVISOR_CONFECCION_EXPTE" />';

app.subtipoTarea.CODIGO_TAREA_EXP_RECOBRO_MARCADO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_MARCADO" />';
app.subtipoTarea.CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_OK = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_OK" />';
app.subtipoTarea.CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_KO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_TAREA_EXP_RECOBRO_META_VOLANTE_KO" />';

app.subtipoTarea.CODIGO_ACEPTACION_ACUERDO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ACEPTACION_ACUERDO" />';
app.subtipoTarea.CODIGO_REVISION_ACUERDO_ACEPTADO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_REVISION_ACUERDO_ACEPTADO" />';
app.subtipoTarea.CODIGO_ACUERDO_GESTIONES_CIERRE = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_ACUERDO_GESTIONES_CIERRE" />';
app.subtipoTarea.CODIGO_CUMPLIMIENTO_ACUERDO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_CUMPLIMIENTO_ACUERDO" />';

app.subtipoTarea.CODIGO_EVENTO_PROPUESTA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea.CODIGO_EVENTO_PROPUESTA" />';

app.subtipoTarea.CODIGO_PRECONTENCIOSO_SUPERVISOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_PRECONTENCIOSO_SUPERVISOR" />';
app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTORIA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTORIA" />';
app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR" />';
app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_LETRADO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_LETRADO" />';
app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR_LIQUIDACIONES = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR_LIQUIDACIONES" />';
app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR_DOCUMENTOS = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR_DOCUMENTOS" />';
app.subtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR_ESTUDIO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea.CODIGO_PRECONTENCIOSO_TAREA_GESTOR_ESTUDIO" />';

app.categoriaSubTipoTarea={};
app.categoriaSubTipoTarea.CATEGORIA_SUBTAREA_TOMA_DECISION = '<fwk:const value ="es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext.CATEGORIA_SUBTAREA_TOMA_DECISION" />';
app.categoriaSubTipoTarea.CATEGORIA_SUBTAREA_ABRIR_TAREA_PROCEDIMIENTO = '<fwk:const value ="es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext.CATEGORIA_SUBTAREA_ABRIR_TAREA_PROCEDIMIENTO" />';
app.categoriaSubTipoTarea.CATEGORIA_SUBTAREA_ABRIR_EXP = '<fwk:const value ="es.pfsgroup.plugin.recovery.coreextension.api.CoreProjectContext.CATEGORIA_SUBTAREA_ABRIR_EXP" />';

app.tipoDestinatario={};
app.tipoDestinatario.CODIGO_DESTINATARIO_GESTOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion.CODIGO_DESTINATARIO_GESTOR" />';
app.tipoDestinatario.CODIGO_DESTINATARIO_SUPERVISOR = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion.CODIGO_DESTINATARIO_SUPERVISOR" />';
app.tipoDestinatario.CODIGO_DESTINATARIO_SUPERVISOR_EXP = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion.CODIGO_DESTINATARIO_SUPERVISOR_EXP" />';
app.tipoDestinatario.CODIGO_DESTINATARIO_OFICINA = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion.CODIGO_DESTINATARIO_OFICINA" />';
app.tipoDestinatario.CODIGO_DESTINATARIO_USUARIO = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion.CODIGO_DESTINATARIO_USUARIO" />';
app.tipoDestinatario.CODIGO_DESTINATARIO_GESTOR_CONFECCION_EXP = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion.CODIGO_DESTINATARIO_GESTOR_CONFECCION_EXP" />';
app.tipoDestinatario.CODIGO_DESTINATARIO_SUPERVISOR_CONFECCION_EXP = '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion.CODIGO_DESTINATARIO_SUPERVISOR_CONFECCION_EXP" />';

app.estExpediente={};
app.estExpediente.ESTADO_CONGELADO = '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO" />';
app.estExpediente.ESTADO_CANCELADO = '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO" />';
app.estExpediente.ESTADO_ACTIVO    = '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO" />';
app.estExpediente.ESTADO_BLOQUEADO = '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO" />';

app.estItinerario={};
app.estItinerario.ESTADO_RE = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE" />';
app.estItinerario.ESTADO_DECISION_COMITE = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_DECISION_COMIT" />';
app.estItinerario.ESTADO_FORMALIZAR_PROPUESTA = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_FORMALIZAR_PROPUESTA" />';
app.estItinerario.ESTADO_REVISAR_EXPEDIENTE = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_REVISAR_EXPEDIENTE" />';
app.estItinerario.ESTADO_ITINERARIO_EN_SANCION = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_ITINERARIO_EN_SANCION" />';

app.tipoBien={};
app.tipoBien.CODIGO_TIPOBIEN_PISO = '<fwk:const value="es.capgemini.pfs.bien.model.DDTipoBien.CODIGO_TIPOBIEN_PISO" />';
app.tipoBien.CODIGO_TIPOBIEN_FINCA = '<fwk:const value="es.capgemini.pfs.bien.model.DDTipoBien.CODIGO_TIPOBIEN_FINCA" />';
app.tipoBien.CODIGO_TIPOBIEN_COCHE = '<fwk:const value="es.capgemini.pfs.bien.model.DDTipoBien.CODIGO_TIPOBIEN_COCHE" />';
app.tipoBien.CODIGO_TIPOBIEN_MOTO = '<fwk:const value="es.capgemini.pfs.bien.model.DDTipoBien.CODIGO_TIPOBIEN_MOTO" />';

app.estadoItinerario={};
app.estadoItinerario.GESTION_VENCIDOS = '<fwk:const value="es.capgemini.pfs.itinerario.model.DDEstadoItinerario.ESTADO_GESTION_VENCIDOS" />';

/*
public static final String ACUERDO_EN_CONFORMACION = "01";
	public static final String ACUERDO_PROPUESTO = "02";
	public static final String ACUERDO_VIGENTE = "03";
	public static final String ACUERDO_RECHAZADO = "04";
	public static final String ACUERDO_CANCELADO = "05";
	public static final String ACUERDO_FINALIZADO = "06";
	*/

app.codigoAcuerdoEnConformacion = '<fwk:const value="es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo.ACUERDO_EN_CONFORMACION" />';
app.codigoAcuerdoPropuesto = '<fwk:const value="es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo.ACUERDO_PROPUESTO" />';
app.codigoAcuerdoAceptado = '<fwk:const value="es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo.ACUERDO_ACEPTADO" />';
app.codigoAcuerdoVigente = '<fwk:const value="es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo.ACUERDO_VIGENTE" />';
app.codigoAcuerdoRechazado = '<fwk:const value="es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo.ACUERDO_RECHAZADO" />';
app.codigoAcuerdoCancelado = '<fwk:const value="es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo.ACUERDO_CANCELADO" />';
app.codigoAcuerdoFinalizado = '<fwk:const value="es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo.ACUERDO_FINALIZADO" />';
app.codigoAcuerdoEnviado = '<fwk:const value="es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo.ACUERDO_ENVIADO" />';
app.codigoAcuerdoIncumplido = '<fwk:const value="es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo.ACUERDO_INCUMPLIDO" />';
app.codigoAcuerdoCumplido = '<fwk:const value="es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo.ACUERDO_CUMPLIDO" />';

app.decisionSancion={};
app.decisionSancion.CODIGO_DECISION_SANCION_APROBADA = '<fwk:const value="es.capgemini.pfs.expediente.model.Sancion.CODIGO_DECISION_SANCION_APROBADA" />';
app.decisionSancion.CODIGO_DECISION_SANCION_APROBADA_CON_CONDICIONES = '<fwk:const value="es.capgemini.pfs.expediente.model.Sancion.CODIGO_DECISION_SANCION_APROBADA_CON_CONDICIONES" />';
app.decisionSancion.CODIGO_DECISION_SANCION_RECHAZADA = '<fwk:const value="es.capgemini.pfs.expediente.model.Sancion.CODIGO_DECISION_SANCION_RECHAZADA" />';

app.tipoExpediente={};
app.tipoExpediente.TIPO_EXPEDIENTE_GESTION_DEUDA = '<fwk:const value="es.capgemini.pfs.expediente.model.DDTipoExpediente.TIPO_EXPEDIENTE_GESTION_DEUDA" />';


/**
 * Abre una pesta�a con la informaci�n del cliente
 */
app.abreCliente = function(id, nombre){
	app.abreClienteTab(id, nombre, '');
};
/**
 * Abre una pesta�a con la informaci�n del cliente, seleccionando un tab en particular
 */
app.abreClienteTab = function(id, nombre,nombreTab){
	this.openTab(nombre||'Cliente', 'clientes/consultaCliente', {id : id,nombreTab:nombreTab}, {id:'cliente'+id,iconCls:'icon_cliente'} );
	this.addFavorite(id, nombre, this.constants.FAV_TIPO_CLIENTE);

};

/**
 * Abre una pesta�a con la informaci�n del expediente
 */
app.abreExpediente = function(id, nombre){
	
	app.abreExpediente(id, nombre, '');
};

/**
 * Abre una pesta�a con la informaci�n del expediente en un tab determinado
 */
app.abreExpediente = function(id, nombre, nombreTab){
	this.openTab(nombre||'<s:message code="expedientes.consulta.titulo" text="**Expediente" />', 'expedientes/consultaExpediente', {id : id,'nombreTab':nombreTab} , {id:'exp'+id,iconCls:'icon_expedientes'});

	this.addFavorite(id, nombre, this.constants.FAV_TIPO_EXPEDIENTE);

};

/**
 * Abre una pesta�a con la informaci�n del expediente
 */
app.abreContrato = function(id, nombre){
	app.abreContratoTab(id, nombre, '');
};

/**
 * Abre una pesta�a con la informaci�n del expediente
 */
app.abreContratoTab = function(id, nombre, nombreTab){
	this.openTab(nombre||'<s:message code="contrato.consulta.titulo" text="**Contrato" />', 'contratos/consultaContrato', {id : id, nombreTab:nombreTab} , {id:'cnt'+id,iconCls:'icon_contratos'});
	this.addFavorite(id, nombre, this.constants.FAV_TIPO_CONTRATO);
};



/**
 * Abre una pesta�a con la informaci�n del cliente
 */
app.abreAsunto= function(id, nombre,tabAceptacion,acuerdos){
	acepta = tabAceptacion?true:false;
	this.openTab(nombre, 'asuntos/consultaAsunto', {id:id,aceptacion:acepta,acuerdos:(acuerdos?true:false)} , {id:'asunto'+id,iconCls:'icon_asuntos'});
	this.addFavorite(id, nombre, this.constants.FAV_TIPO_ASUNTO);

};

app.abreAsuntoTab= function(id, nombre, nombreTab){
	this.openTab(nombre, 'asuntos/consultaAsunto', {id:id, nombreTab:nombreTab,aceptacion:false,acuerdos:false} , {id:'asunto'+id,iconCls:'icon_asuntos'});
	this.addFavorite(id, nombre, this.constants.FAV_TIPO_ASUNTO);

};

app.abreProcedimiento= function(id, nombre){
	this.openTab(nombre, 'procedimientos/consultaProcedimiento', {id:id} , {id:'procedimiento'+id,iconCls:'icon_procedimiento'});
	this.addFavorite(id, nombre, this.constants.FAV_TIPO_PROCEDIMIENTO);

};

app.abreProcedimientoTab= function(id, nombre, nombreTab){
	this.openTab(nombre, 'procedimientos/consultaProcedimiento', {id:id, nombreTab:nombreTab} , {id:'procedimiento'+id,iconCls:'icon_procedimiento'});
	this.addFavorite(id, nombre, this.constants.FAV_TIPO_PROCEDIMIENTO);

};




//a�ade a favoritos un nuevo registro
app.addFavorite=function(id, nombre, tipo){
	this.clientesFav.fireEvent('addfav', {
		id : id
		,nombre : nombre
		,tipo : tipo
	});

};

app.reloadFav=function(){
	this.clientesFav.fireEvent('reloadFav');
}
/**
 * funci�n de conveniencia para crear un StaticTextField con el label en negrita
 */
app.creaLabel = function(label, value, config){
	var config = config || {};
	var cfg = {
			autoHeight: true
			,fieldLabel : label || ''
			,value : value
			,labelStyle : config.labelStyle || 'font-weight:bolder'
			//esto reduce el margen entre las labels 4px que introduce .x-form-item
			,itemCls : 'no-margin'
	};
	if(config.id) {
		cfg.id=config.id;
	}
	
	fwk.js.copyProperties(cfg, config, ['labelWidth','labelStyle', 'rawvalue']);

	var staticTextField =  new Ext.ux.form.StaticTextField(cfg);
	return staticTextField;
};


 /**
  * envuelve una lista de controles en un fieldSet
  */
app.creaFieldSet = function(items, config){
	if (!Ext.isArray(items)) items = [items];
	var cfg={
		autoHeight:true
		,labelStyle:'font-weight:bolder'
		,border : false
		,items:items
	};
	fwk.js.copyProperties(cfg, config, ['width','style', 'fieldLabel','hideBorders']);
	var ft = new Ext.form.FieldSet(cfg);
	return ft;
};

/**
 * funci�n de conveniencia para crear un textField
 */
app.creaText = function(name, label, value, config){
	var cfg = config || {};
	cfg.name = name;
	cfg.value = value;
	cfg.fieldLabel = label;
	//Ya se ha hecho una copia en la primera l�nea del m�todo, �para que copiar m�s?
	//fwk.js.copyProperties(cfg, config, ['style']);
	
	//margen para IE
	cfg.style=cfg.style?cfg.style+';margin:0px':'margin:0px';	
	return new Ext.form.TextField(cfg);
};

/**
 * funci\F3n de conveniencia para crear un textField para procedimientos
 */
app.creaProcedimientoText = function(name, label, value, config){
	var cfg = config || {};
	cfg.name = name;
	cfg.value = value;
	cfg.fieldLabel = label;
	//Ya se ha hecho una copia en la primera l\EDnea del m\E9todo, \BFpara que copiar m\E1s?
	//fwk.js.copyProperties(cfg, config, ['style']);
	
	//margen para IE
	cfg.style=cfg.style?cfg.style+';margin:0px':'margin:0px';	
	cfg.maxLength=10
	cfg.validator = function(v) {
      		return /^$|[0-9]{5}\/[0-9]{4}$/.test(v)? true : '<s:message code="genericForm.validacionProcedimiento" text="**Debe introducir 			un n�mero con formato xxxxx/xxxx" />';
    }	
	return new Ext.form.TextField(cfg);
};

app.creaNumber = function(name, label, value, config){
	var cfg = config || {};
	cfg.name = name;
	cfg.value = value;
	cfg.fieldLabel = label;
	cfg.maxValue = 9999999999999999;
	//margen para IE
	cfg.style=cfg.style?cfg.style+';margin:0px':'margin:0px';
	if (cfg.autoCreate == null)
	{
		cfg.autoCreate = {tag: "input", type: "text",maxLength:"16", autocomplete: "off"};
	}

	/*
		Ya se ha hecho una copia en la primera l�nea del m�todo, �para que copiar m�s?
		fwk.js.copyProperties(cfg, config, ['width','style','labelStyle']);
	*/
	return new Ext.form.NumberField(cfg);
};

/**
*
*/
app.creaOk = function(handler,text,config){
	return new Ext.Button({
		text : text||'<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : handler
	})
};


app.creaInteger = function(name, label, value, config){
	var cfg = config || {};
	cfg.name = name;
	cfg.value = value;
	cfg.fieldLabel = label;
	cfg.allowNegative = false;
	cfg.allowDecimals = false;
	//margen para IE
	cfg.style=cfg.style?cfg.style+';margin:0px':'margin:0px';
	fwk.js.copyProperties(cfg, config, ['width']);
	return new Ext.form.NumberField(cfg);
};

/*
 * funci�n de ayuda para crear un combo. como m�nimo necesitamos
 *
 * app.creaCombo( {name : xx, data : xxx, fieldLable : xx } );
 */
app.creaCombo = function(config){
	var cfg = app.getConfigCombo(config);
	
	return new Ext.form.ComboBox(cfg);
};


app.getConfigCombo = function(config){
	config = config || {};
	var store = config.store || new Ext.data.JsonStore({
		fields : ['codigo', 'descripcion']
		,root : 'diccionario'
		,data : config.data
	});

	var cfg = config;
	if(config.id) {
    	cfg.id = config.id;
	}
	cfg.store = store;
	cfg.displayField = 'descripcion';
	cfg.mode = 'local';
	cfg.valueField = 'codigo';
	cfg.hiddenName = config.name;
	//margen para IE
	cfg.style=cfg.style?cfg.style+';margin:0px':'margin:0px';

	// ** Modificaci�n para que el combo sea autocompletable **
	cfg.editable = true;
	cfg.forceSelection = true;
	// ** Modificaci�n para que el combo sea autocompletable **

	cfg.triggerAction = 'all';
	cfg.maxHeight = 140;
	cfg.resizable = true;
	cfg.width = config.width || 220;
	cfg.labelWidth = config.labelWidth || 100;
	cfg.listAlignOffsets = config.listAlignOffsets || [0,0];
	fwk.js.copyProperties(cfg, config, ['fieldLabel']);
	return cfg;
};


/*
 * funci�n de ayuda para crear un combo con offset para el popup
 *
 * app.creaComboOffset( {name : xx, data : xxx, fieldLable : xx } );
 */
app.creaComboOffset = function(config){
	var cfg = app.getConfigCombo(config);
	return new ComboOffset(cfg);
};


/**
* crea un control ItemSelector de ExtJS para unos datos de tipo diccionario. Es decir
*que los campos que vienen en los datos son codigo y descripcion.
*
*Se crea internamente un store al que podremos acceder mediante :
* control.fromStore
*
* parametros
* @label String etiqueta que acompa�a al control
* @data Array datos para cargar el combo
*/
app.creaDblSelect = function(data,label, config){
	config = config || {};
	var store = config.store || new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion']
		         ,root: 'diccionario'
	        	 ,data : data
	});
	var cfg = {
	    	fieldLabel: label || ''
	    	,displayField:'descripcion'
	    	,valueField: 'codigo'
	    	,imagePath:"/${appProperties.appName}/js/fwk/ext.ux/Multiselect/images/"
	    	,dataFields : ['codigo', 'descripcion']
	    	,fromStore:store
	    	,toData : []
	        ,msHeight : config.height || 60
			,labelStyle:config.labelStyle || ''
	        ,msWidth : config.width || 140
	        ,drawTopIcon:false
	        ,drawBotIcon:false
	        ,drawUpIcon:false
			,drawDownIcon:false
			,toSortField : 'codigo'
	    };
	if(config.id) {
		cfg.id = config.id;
	}


	var itemSelector = new Ext.ux.ItemSelector(cfg);
	if (config.funcionReset){
		itemSelector.funcionReset = config.funcionReset;
	}


	//modificaci�n al itemSelector porque no tiene un m�todo setValue. Si se cambia de versi�n se tendr� que revisar la validez de este m�todo
	itemSelector.setValue =  function(val) {
        if(!val) {
            return;
        }
        val = val instanceof Array ? val : val.split(',');
        var rec, i, id;
        for(i = 0; i < val.length; i++) {
            id = val[i];
            if (!this.toStore) {
	            this.toStore = new Ext.data.SimpleStore({
	                fields: this.dataFields,
	                data : this.toData
	            });
	        }
            if(this.toStore.find('codigo',id)>=0) {
                continue;
            }
            rec = this.fromStore.find('codigo',id);
            if(rec>=0) {
            	rec = this.fromStore.getAt(rec);
                this.toStore.add(rec);
                this.fromStore.remove(rec);
            }
        }
    };

	itemSelector.getStore =  function() {
		return this.toStore;
	};


	return itemSelector;
	}

/**
 * crea un panel tipo column con los elementos que le pasamos
 */
app.creaPanelH = function(items){
	if (!Ext.isArray(items)){
		var arr = [];
		for(var i=0;i < arguments.length;i++){
			arr.push(arguments[i]);
		}
		items=arr;
	}

	var p = new Ext.Panel({
		layout : 'column'
		,viewConfig : {columns : items.length}
		,border : false
		,autoHeight : true
		,defaults : {bodyStyle : 'margin-right:5px'}
		,items : items
	});

	return p;
};
/*
*
*/
app.creaPanelHz = function(config, items){
	if (!Ext.isArray(items)){
		var arr = [];
		for(var i=1;i < arguments.length;i++){
			arr.push(arguments[i]);
		}
		items=arr;
	}
	var cfg = {
		layout : 'column'
		,viewConfig : {columns : items.length}
		,border : false
		,autoHeight : true
		,defaults : {bodyStyle : 'margin-right:5px'}
		,items : items
	};
	fwk.js.copyProperties(cfg, config, ['width', 'style']);

	var p = new Ext.Panel(cfg);

	return p;
};

/*
* Crea un bot�n para a�adir un nuevo registro, necesita los siguientes par�metros
* @flow : el flow a llamar para la ventana de detalle
* @title : t�tulo de la ventana de detalle, por defecto clave app.nuevoRegistro
* @text : texto del bot�n, por defecto clave app.agregar
* @params : par�metros a pasar al flow
* @success : callback a ejecutar cuando se cierra la ventana
*/
app.crearBotonAgregar = function(config){

	fwk.js.assertProperties(config, ["flow"]);

	return new Ext.Button({
           text:  config.text || '<s:message code="app.agregar" text="**Agregar" />'
           ,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
           ,handler:function(){
			var w = app.openWindow({
				flow : config.flow
				,closable:false
				,width : config.width || 600
				,title : config.title || '<s:message code="app.nuevoRegistro" text="**Nuevo registro" />'
				,params : config.params || {}
			});
			w.on(app.event.DONE, function(){
				w.close();
				if (config.success && typeof(config.success)=="function"){
					config.success();
				}
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
           }
	});
};

/*
* Crea un bot�n para editar un registro, necesita los siguientes par�metros
* @grid : el grid del que obtendr� el id del registro a editar. S�lo editar� si hay un registro seleccionado
* @flow : el flow a llamar para la ventana de detalle
* @title : t�tulo de la ventana de detalle, por defecto clave app.editarRegistro
* @text : texto del bot�n, por defecto clave app.agregar
* @params : par�metros a pasar al flow
* @success : callback a ejecutar cuando se cierra la ventana
*/
app.crearBotonEditar = function(config){
	fwk.js.assertProperties(config, ["flow"]);
	var cfg = {
           text: config.text || '<s:message code="app.editar" text="**Editar" />'
           ,iconCls : 'icon_edit'
		   ,cls: 'x-btn-text-icon'
           ,handler:function(){
			var grid = fwk.dom.findParentPanel(this.id);
			var rec = grid.getSelectionModel().getSelected();
			if (!rec) return;
			var params = config.params || {};
			params.id = rec.get("id");
			var w = app.openWindow({
				flow : config.flow
				,width : config.width || 600
				,closable: false
				,title : config.title || '<s:message code="app.editarRegistro" text="**Editar registro" />'
				,params : params
			});
			w.on(app.event.DONE, function(){
				w.close();
				if (config.success && typeof(config.success)=="function"){
					config.success();
				}
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
           }
	};
	if(config.id) {
		cfg.id = config.id;
	}
	return new Ext.Button(cfg);
};

/*
* Crea un bot�n para borrar un registro, necesita los siguientes par�metros
* @grid : el grid del que obtendr� el id del registro a editar. S�lo editar� si hay un registro seleccionado
* @flow : el flow a llamar para el borrado
* @confirmText : texto de la pregunta para borrar, por defecto app.borrarRegistro
* @text : texto del bot�n, por defecto clave app.borrar
* @params : par�metros a pasar al flow
* @success : callback a ejecutar cuando se cierra la ventana
*/
app.crearBotonBorrar = function(config){
	fwk.js.assertProperties(config, ["flow", "page"]);

	var cfg = {
		text : config.text || '<s:message code="app.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,handler : function(){
			var grid=fwk.dom.findParentPanel(this.id);
			var rec = grid.getSelectionModel().getSelected();
			if (rec){
				Ext.Msg.confirm(fwk.constant.confirmar, config.confirmText || '<s:message code="app.borrarRegistro" text="**�Seguro que desea borrar el registro?" />', this.decide, this);
			}
		}
		,decide : function(boton){
			if (boton=='yes'){ this.borrar(); }
		}
		,borrar : function(){
			var grid = fwk.dom.findParentPanel(this.id);
			var rec = grid.getSelectionModel().getSelected();
			if (!rec) return;
			var params = config.params || {};
			params.id = rec.get("id");
			config.page.webflow({
				flow : config.flow
				,params : params || {}
				,success : function() {
					if (config.success && typeof(config.success)=="function"){
						config.success();
					}
				 }
			});
		}
	};

	if(config.id) {
		cfg.id = config.id;
	}
	return new Ext.Button(cfg);
};

app.crearBotonBuscar=function(config){
	var cfg = {
		text:'<s:message code="app.buscar" text="**Buscar" />'
		,iconCls:'icon_busquedas'
	};
	fwk.js.copyProperties(cfg, config, ['handler']);

	var p = new Ext.Button(cfg);

	return p;
}

app.resetForm = function(theForm){
	theForm.getForm().reset();
}

app.resetCampos= function(campos){
	for (var i=0; i < campos.length; i++){
		if (campos[i].reset){
				campos[i].reset();
				if (campos[i].funcionReset){
					campos[i].funcionReset();
				}
		}else{
			campos[i].setValue(null);
		}
	}
}

app.crearBotonResetCampos=function(campos){
	var cfg = {
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler : function(){
				app.resetCampos(campos);
			}
	};
	var p = new Ext.Button(cfg);
	return p;
}

/**
 * Abre una ventana con el t�tulo y contenido que se le pasa
 */
app.openWindow=function(config){
	config = config || {};

	var closable=config.closable;

	if(closable==null)
		closable=false;


	var cfg = {
			title: config.title || ''
			,layout:'fit'
			,modal:true
			,x: config.x || 50
			,y: config.y || 50
			,autoShow : true
			,autoHeight : true
			,closable:closable
			,width : config.width || 600
			,bodyBorder : false
	};

	fwk.js.copyProperties(cfg,config,['items']);
	if (config.flow){
		cfg.autoLoad = {
				url : app.resolveFlow(config.flow)
				,scripts : true
				,params : config.params || {}
		};
	}

	var win = new Ext.Window(cfg);
	win.show();
	return win;
};

app.openReport=function(config){
	config = config || {};

	var cfg = {
			title: config.title || ''
			//,layout:'fit'
			,modal:true
			,x:50
			,y:50
			,autoShow : true
			,autoHeight : false
			,closable:true
			,width : 800
			,height : 600
			,bodyBorder : false
	};

	fwk.js.copyProperties(cfg,config,['items']);
	if (config.flow){
		cfg.autoLoad = {
				url : app.resolveFlow(config.flow)
				,scripts : true
				,params : config.params || {}
		};
	}

	var win = new Ext.Window(cfg);
	win.show();
	return win;
};
app.openPDF=function(flow,tipo,params){
	var url=flow+'.htm?tipo='+tipo+'&'+params;
	window.open(url);
};

/**
abre una nueva ventana del navegador con el flow y par�metros que se le pasan
*/
app.openBrowserWindow = function(flow, params){
	var url=flow+'.htm';
	var urlData="";

	params = params || {};
	for(var x in params){
		urlData +='&'+x+'='+params[x];
	}

	urlData = urlData.slice(1);
	if (urlData.length){
		url+='?'+urlData;
	}

	window.open(url);
}


app.crearTextArea = function(label, value, isReadOnly, labelStyle, textName,config){
		var config = config || {};
		var cfg;
		if (config.id){
		  cfg = {
		  		id:config.id
				,fieldLabel:label
				,width:config.width || 220
				,height:config.height ||60
				,maxLength:config.maxLength
				,maxLengthText:  config.maxLengthText || '' 
				,readOnly:isReadOnly
				,labelStyle:labelStyle
				,value:value
				,name: textName || ''
		   };
		}else{
			cfg = {
				fieldLabel:label
				,width:config.width || 220
				,height:config.height ||60
				,maxLength:config.maxLength
				,maxLengthText:  config.maxLengthText || '' 
				,readOnly:isReadOnly
				,labelStyle:labelStyle
				,value:value
				,name: textName || ''
			};
		}
		//Ya se ha hecho una copia en la primera l�nea del m�todo, �para que copiar m�s?
		//fwk.js.copyProperties(cfg, config, ['width']);
		return new Ext.form.TextArea(cfg);
	}

app.creaBotonGuardar=function(page,panelEdicion){
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
	});
	return btnGuardar;
}
app.creaBotonCancelar=function(page,panelEdicion){
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.submit({
				eventName : 'cancel'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.CANCEL); }
			});
		}
	});
	return btnCancelar;
}
/**
 * Funcion para crear y mostrar una pagina de alta / modificacion
 * @param {Object} page el objeto page
 * @param {Object} items el contenedor de elementos
 */
app.crearABMWindow=function(page,items){
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){page.fireEvent(app.event.CANCEL);}
	});
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
		<app:test id="btnGuardarABM" addComa="true"/>
	});
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle : 'padding:5px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{
				border : false
				,layout : 'anchor'
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				,items : items
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});
	page.add(panelEdicion);
}

/**
 * Funcion para crear y mostrar una pagina de consulta
 * @param {Object} page el objeto page
 * @param {Object} items el contenedor de elementos
 */
app.crearABMWindowConsulta=function(page,items){
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){page.fireEvent(app.event.CANCEL);}
	});
	var btnAceptar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'cancel'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.CANCEL) }
			});
		}
	});
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle : 'padding:5px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{
				border : false
				,layout : 'anchor'
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				,items : items
			}
		]
		,bbar : [
			/*btnAceptar,*/
			btnCancelar
		]
	});
	page.add(panelEdicion);
}

/*
* crea un par de controles num�ricos para introducir un m�nimo y un m�ximo.
* Ojo, que devuelve un objeto con 3 objetos dentro min/max y el panel que contiene a ambos
*/
app.creaMinMax = function(label, name, config){
		config = config || {};
		var width1 = config.width1 || config.width || 45;
		var width2 = config.width2 || config.width || 45;
		var widthPanel = config.widthPanel || 250;
		var widthFieldSet = config.widthFieldSet || 200;
		var labelWidth = config.labelWidth || 108;
		var maxLength = config.maxLength || "15";
		var min = app.creaNumber("min"+name, label,'',{width:width1,maxLength:16,autoCreate:{tag: "input", type: "text", size: "4",maxLength:maxLength, autocomplete: "off"}});
		var max = app.creaNumber("max"+name, label,'',{width:width2,maxLength:16,autoCreate:{tag: "input", type: "text", size: "4",maxLength:maxLength, autocomplete: "off", style: "margin-left:4px"}});
		var cfgPanel = {
			style : "margin-top:4px;margin-bottom:2px;"
		};
		if (config.widthPanel){ cfgPanel.width = config.widthPanel; }
		
		var cfgFieldSet = {};
		if (config.widthFieldSet) { cfgFieldSet.width = config.widthFieldSet; }
		
		
		return {
			min : min
			,max : max
			,panel : app.creaPanelHz(cfgPanel,[{html:label+":", border: false, width : labelWidth, cls: 'x-form-item'}, min, {html : ' ', border:false, width : 5},  max])
		};
};



/*
* crea un par de controles num�ricos para introducir un m�nimo y un m�ximo.
* Ojo, que devuelve un objeto con 3 objetos dentro min/max y el panel que contiene a ambos
*/
app.creaMinMaxMoneda = function(label, name, config){
	config = config || {};
	var width1 = config.width1 || config.width || 45;
	var width2 = config.width2 || config.width || 45;
	var widthPanel = config.widthPanel || 250;
	var widthFieldSet = config.widthFieldSet || 200;
	var labelWidth = config.labelWidth || 108;
	var maxLength = config.maxLength || "15";

	var configSearchOnEnter = {};
	if (config.searchOnEnter) {
		configSearchOnEnter = {enableKeyEvents: true ,listeners : {	keypress : function(target,e){ if(e.getKey() == e.ENTER) { buscarFunc(); } } } };
		//configSearchOnEnter = {listeners:{specialkey: function(f,e){ if(e.getKey()==e.ENTER){ buscarFunc(); } }} };
	}
		
	
	var min = app.creaMoneda("min"+name, label,'',{width:width1,maxLength:16,autoCreate:Ext.apply({tag: "input", type: "text", size: "4",maxLength:maxLength, autocomplete: "off"},configSearchOnEnter)});
	var max = app.creaMoneda("max"+name, label,'',{width:width2,maxLength:16,autoCreate:Ext.apply({tag: "input", type: "text", size: "4",maxLength:maxLength, autocomplete: "off", style: "margin-left:4px"},configSearchOnEnter)});
	var cfgPanel = {
		style : "margin-top:4px;margin-bottom:2px;"
	};
	if (config.widthPanel){ cfgPanel.width = config.widthPanel; }
	
	var cfgFieldSet = {};
	if (config.widthFieldSet) { cfgFieldSet.width = config.widthFieldSet; }
	
	
	return {
		min : min
		,max : max
		,panel : app.creaPanelHz(cfgPanel,[{html:label+":", border: false, width : labelWidth, cls: 'x-form-item'}, min, {html : ' ', border:false, width : 5},  max])
	};
};


/*
* crea un par de controles num�ricos para introducir un m�nimo y un m�ximo.
* Ojo, que devuelve un objeto con 3 objetos dentro min/max y el panel que contiene a ambos
*/
app.creaMinMaxPorcentaje = function(label, name, config){
	config = config || {};
	var width1 = config.width1 || config.width || 45;
	var width2 = config.width2 || config.width || 45;
	var widthPanel = config.widthPanel || 250;
	var widthFieldSet = config.widthFieldSet || 200;
	var labelWidth = config.labelWidth || 108;
	var maxLength = config.maxLength || "3";

	var configSearchOnEnter = {};
	if (config.searchOnEnter) {
		configSearchOnEnter = {enableKeyEvents: true ,listeners : {	keypress : function(target,e){ if(e.getKey() == e.ENTER) { buscarFunc(); } } } };
		//configSearchOnEnter = {listeners:{specialkey: function(f,e){ if(e.getKey()==e.ENTER){ buscarFunc(); } }} };
	}
		
	
	var min = app.creaMoneda("min"+name, label,'',{width:width1,maxLength:16,autoCreate:Ext.apply({tag: "input", type: "text", size: "4",maxLength:maxLength, autocomplete: "off"},configSearchOnEnter)});
	var max = app.creaMoneda("max"+name, label,'',{width:width2,maxLength:16,autoCreate:Ext.apply({tag: "input", type: "text", size: "4",maxLength:maxLength, autocomplete: "off", style: "margin-left:4px"},configSearchOnEnter)});
	var cfgPanel = {
		style : "margin-top:4px;margin-bottom:2px;"
	};
	if (config.widthPanel){ cfgPanel.width = config.widthPanel; }
	
	var cfgFieldSet = {};
	if (config.widthFieldSet) { cfgFieldSet.width = config.widthFieldSet; }
	
	
	return {
		min : min
		,max : max
		,panel : app.creaPanelHz(cfgPanel,[{html:label+":", border: false, width : labelWidth, cls: 'x-form-item'}, min, {html : ' ', border:false, width : 5},  max])
	};
};
app.creaMinMaxMonedaConId = function(label, name, config){
	config = config || {};
	var width1 = config.width1 || config.width || 45;
	var width2 = config.width2 || config.width || 45;
	var widthPanel = config.widthPanel || 250;
	var widthFieldSet = config.widthFieldSet || 200;
	var labelWidth = config.labelWidth || 108;
	var maxLength = config.maxLength || "15";

	var configSearchOnEnter = {};
	if (config.searchOnEnter) {
		configSearchOnEnter = {enableKeyEvents: true ,listeners : {	keypress : function(target,e){ if(e.getKey() == e.ENTER) { buscarFunc(); } } } };
	}
		
	
	var min = app.creaMoneda("min"+name, label,'',{width:width1,maxLength:16,autoCreate:Ext.apply({tag: "input", type: "text", size: "4",maxLength:maxLength, autocomplete: "off", id:"idmin"+name},configSearchOnEnter)});
	var max = app.creaMoneda("max"+name, label,'',{width:width2,maxLength:16,autoCreate:Ext.apply({tag: "input", type: "text", size: "4",maxLength:maxLength, autocomplete: "off", id:"idmax"+name, style: "margin-left:4px"},configSearchOnEnter)});
	var cfgPanel = {
		style : "margin-top:4px;margin-bottom:2px;"
	};
	if (config.widthPanel){ cfgPanel.width = config.widthPanel; }
	
	var cfgFieldSet = {};
	if (config.widthFieldSet) { cfgFieldSet.width = config.widthFieldSet; }
	
	
	return {
		min : min
		,max : max
		,panel : app.creaPanelHz(cfgPanel,[{html:label+":", border: false, width : labelWidth, cls: 'x-form-item'}, min, {html : ' ', border:false, width : 5},  max])
	};
};
<%@ include file="/WEB-INF/jsp/main/moneyField.js.jsp"%>
app.creaMoneda = function(name, label, value, config){
	var cfg = config || {};		
	cfg.name = name;
	cfg.value = value;
	cfg.fieldLabel = label;
	cfg.maxValue = 9999999999999999;
	
	//margen para IE
	cfg.style=cfg.style?cfg.style+';margin:0px':'margin:0px';	
	
	if (cfg.autoCreate == null)
	{
		cfg.autoCreate = {tag: "input", type: "text",maxLength:"16", autocomplete: "off"};
	}

	/*
		Ya se ha hecho una copia en la primera l�nea del m�todo, �para que copiar m�s?
		fwk.js.copyProperties(cfg, config, ['width','style','labelStyle']);
	*/
	// Por ahora dejamos comentado el MoneyField porque la mascara es enga�osa
	//return new Ext.ux.MoneyField(cfg);
	return new Ext.form.NumberField(cfg);
};
/*
* funci�n que verifica si el usuario logueado
* tiene un perfil de gestor determinado.
*/
function permisosVisibilidadGestorSupervisor(perfilGestor){
var perfiles = app.usuarioLogado.perfiles;
	for (i =0 ; i < perfiles.length ; i++){
		//Comparar Gestor
		if(perfiles[i].id == perfilGestor){
			return true;
		}
	}
	return false;
};

app.validaValoresDblText=function(control){
	if (control.min.getValue()!=null && control.min.getValue()!=''
		&& control.max.getValue()!=null && control.max.getValue()!=''
		&& new Number(control.min.getValue())> new Number(control.max.getValue())){
		return false;
	}
	return true;
}


/**
 * Funcion para crear un boton de ayuda
 */
app.crearBotonAyuda=function(handler){
	return new Ext.Button({
		text:'<s:message code="app.ayuda" text="**Ayuda" />'
		,iconCls:'icon_ayuda'
		,handler:handler
	})
}


Ext.ToolTip.prototype.onTargetOver =
    	Ext.ToolTip.prototype.onTargetOver.createInterceptor(function(e) {
    		this.baseTarget = e.getTarget();
});

Ext.ToolTip.prototype.onMouseMove =
  	Ext.ToolTip.prototype.onMouseMove.createInterceptor(function(e) {
  		if (this.baseTarget==null) return false;

  		if (!e.within(this.baseTarget)) {
  			this.onTargetOver(e);
  			return false;
  		}
});


/**
 * funcion para crear un grid
 * <B>SOLO PARA TABLAS QUE VAYAN A OCUPAR TODO EL ANCHO DEL TABPANEL PRINCIPAL</B>
 * @param {} myStore el Store
 * @param {} columnModel el ColumnModel
 * @param {} config parametros de configuracion
 * @return {} Ext.grid.GridPanel
 */
app.crearGrid=	function(myStore,columnModel, config){
		config = config || {};

		//a�ado tooltips a las columnas (s�lo si tienen header)
		var ccfg = columnModel.config;
		for(var i=0;i < ccfg.length;i++){
			if (ccfg[i].header){
				ccfg[i].tooltip = ccfg[i].header;
			}
		}

		var cfg = {
				title: config.title || '**'
				,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
				,collapsible : config.collapsible || false
				,collapsed : config.collapsed || false
				,titleCollapse : config.titleCollapse || false
				,store: myStore
				,style : config.style
				,view:config.view || null
				,cm:columnModel
			    ,clicksToEdit:1
			    ,resizable:true
			    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
			    //,width: config.width || (columnModel.getTotalWidth()+25)
				,autoWidth:true
			    //,width:200
			    ,height: config.height || 350
				//,maxHeight:config.maxHeight || 150
			    ,autoHeight: config.autoHeight || false
			    ,bbar : config.bbar
			    ,viewConfig : {  forceFit : true}
			    ,monitorResize: true
				,doLayout: function() {
					//fwk.log('visible: '+this.isVisible());
					if(this.isVisible()){
						var margin = config.margin || 10;
						var parentSize = app.contenido.getSize(true);
						var width = (config.parentWidth || parentSize.width) - (2*margin);
						this.setWidth(width);

						if(!config.dontResizeHeight){
							this.setHeight(config.height||150);
						}
						Ext.grid.GridPanel.prototype.doLayout.call(this);
					}

				}
			};
			if(config.id) {
				cfg.id=config.id;
			}
		if (config.iconCls) cfg.iconCls=config.iconCls;
		if (config.height) cfg.height=config.height;
		if (config.plugins) cfg.plugins=config.plugins;
		if (config.cls) cfg.cls=config.cls;

		//implementa el tooltip para ver el contenido de las celdas si tienen valor
		cfg.onRender = function() {
        	Ext.grid.GridPanel.prototype.onRender.apply(this, arguments);
        	this.addEvents("beforetooltipshow");
	        this.tooltip = new Ext.ToolTip({
	        	renderTo: Ext.getBody(),
	        	target: this.view.mainBody,
	        	listeners: {
	        		beforeshow: function(qt) {
	        			var v = this.getView();
			            var rows = (this.store != null ? this.store.getCount() : 0);
			            if (rows <=0 ) return false;

			            var store = this.getStore();
			            var row = v.findRowIndex(qt.baseTarget);
			            if (row===false || row===-1) return;
			            var cell = v.findCellIndex(qt.baseTarget);
			            if (cell===false || cell===-1) return;
			            var field = this.getColumnModel().config[cell].dataIndex;

			            var rowData = this.getView().getCell(row,cell);
			            rowData = rowData.innerText? rowData.innerText : rowData.textContent;

			            if(rowData != this.lastRowData){
			            	this.fireEvent("beforetooltipshow", this, row, cell, rowData);
			            }
			            this.lastRowData = rowData;
			            if (!rowData || Ext.isEmpty(rowData.trim())) return false;
	        		},
	        		scope: this
	        	}
	        });
        };

        cfg.listeners = {
			render: function(g) {
			g.on("beforetooltipshow", function(grid, row, col, rowData) {
				grid.tooltip.body.update(rowData);
			});
			}
        };

		var myGrid = new Ext.grid.GridPanel(cfg);

			return myGrid;
	};
/**
 * funcion para crear un grid EDITABLE
 * <B>SOLO PARA TABLAS QUE VAYAN A OCUPAR TODO EL ANCHO DEL TABPANEL PRINCIPAL</B>
 * @param {} myStore el Store
 * @param {} columnModel el ColumnModel
 * @param {} config parametros de configuracion
 * @return {} Ext.grid.GridPanel
 */
app.crearEditorGrid=	function(myStore,columnModel, config){
		config = config || {};

		//a�ado tooltips a las columnas (s�lo si tienen header)
		var ccfg = columnModel.config;
		for(var i=0;i < ccfg.length;i++){
			if (ccfg[i].header){
				ccfg[i].tooltip = ccfg[i].header;
			}
		}

		var cfg = {
				title: config.title || '**'
				,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
				,collapsible : config.collapsible || false
				,collapsed : config.collapsed || false
				,titleCollapse : config.titleCollapse || false
				,store: myStore
				,style : config.style
				,view:config.view || null
				,cm:columnModel
			    ,clicksToEdit:1
			    ,resizable:true
			    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
			    //,width: config.width || (columnModel.getTotalWidth()+25)
				,autoWidth:true
			    //,width:200
			    ,height: config.height || 350
				//,maxHeight:config.maxHeight || 150
			    ,autoHeight: config.autoHeight || false
			    ,bbar : config.bbar
			    ,viewConfig : {  forceFit : true}
			    ,monitorResize: true
				,doLayout: function() {
					//fwk.log('visible: '+this.isVisible());
					if(this.isVisible()){
						var margin = config.margin || 10;
						var parentSize = app.contenido.getSize(true);
						var width = (config.parentWidth || parentSize.width) - (2*margin);
						this.setWidth(width);

						if(!config.dontResizeHeight){
							this.setHeight(config.height||150);
						}
						Ext.grid.GridPanel.prototype.doLayout.call(this);
					}

				}
			};
			if(config.id) {
				cfg.id=config.id;
			}
		if (config.iconCls) cfg.iconCls=config.iconCls;
		if (config.height) cfg.height=config.height;
		if (config.plugins) cfg.plugins=config.plugins;
		if (config.cls) cfg.cls=config.cls;
		if (config.sm) cfg.sm=config.sm;
		if (config.clicksToEdit) cfg.clicksToEdit=config.clicksToEdit;

		//implementa el tooltip para ver el contenido de las celdas
		cfg.onRender = function() {
        	Ext.grid.GridPanel.prototype.onRender.apply(this, arguments);
        	this.addEvents("beforetooltipshow");
	        this.tooltip = new Ext.ToolTip({
	        	renderTo: Ext.getBody(),
	        	target: this.view.mainBody,
	        	listeners: {
	        		beforeshow: function(qt) {
	        			var v = this.getView();
			            var rows = (this.store != null ? this.store.getCount() : 0);
			            if (rows <=0 ) return false;

			            var store = this.getStore();
			            var row = v.findRowIndex(qt.baseTarget);
			            if (row===false || row===-1) return;
			            var cell = v.findCellIndex(qt.baseTarget);
			            if (cell===false) return;
			            var field = this.getColumnModel().config[cell].dataIndex;

			            var rowData = this.getView().getCell(row,cell);
			            rowData = rowData.innerText? rowData.innerText : rowData.textContent;

			            if(rowData != this.lastRowData){
			            	this.fireEvent("beforetooltipshow", this, row, cell, rowData);
			            }
			            this.lastRowData = rowData;
			            if (!rowData || Ext.isEmpty(rowData.trim())) return false;
	        		},
	        		scope: this
	        	}
	        });
        };

        cfg.listeners = {
			render: function(g) {
			g.on("beforetooltipshow", function(grid, row, col, rowData) {
				if (grid.colModel.config[col].tooltipInstruccion!=null){
				}else {
					grid.tooltip.body.update(rowData);
				}
			});
			}
        };

		var myGrid = new Ext.grid.EditorGridPanel(cfg);

			return myGrid;
	};	
app.resolverSiNulo = function(valor){
	if (valor==null || valor===''){
		return null;
	}
	return valor;
}	
/**
 * Devuelve el primer dia de la semana de la fecha d
 * @param {Object} d
 */
app.getFirstDateOfWeek=function(d){
	var dayOfWeek=d.getDay(); //dia de la semana del 0 al 6
	var newDate=d.getDate() - dayOfWeek;
	d.setDate(newDate);
	return d;
}
/**
 * Devuelve el ultimo dia de la semana de la fecha d
 * @param {Object} d
 */
app.getLastDateOfWeek=function(d){
	var dayOfWeek=d.getDay(); //dia de la semana del 0 al 6
	var newDate=d.getDate()+ 6 - dayOfWeek;
	d.setDate(newDate);
	return d;
}
/**
 * Construye un panel con rango de fechas
 * @param {Object} cfg:
 * cfg.desdeOperadorValue (String): operador logico para la fecha desde
 * cfg.desdeLabel (String): label desde 
 * cfg.fechaDesdeValue (dd/mm/yyyy) : valor inicial para fecha desde
 * cfg.hastaOperadorValue (String): operador logico para la fecha hasta
 * cfg.hastaLabel (String): label hasta
 * cfg.fechaHastaValue (dd/mm/yyyy) : valor inicial para fecha hasta
 * cfg.title:titulo del panel 
 */

app.crearRangoFechasPanel=function(cfg){
	var _this={};
	_this.comboFechaDesdeOp=new Ext.form.ComboBox({
		store:[">=",">","=","<>"]
		,fieldLabel:cfg.desdeLabel
		,triggerAction : 'all'
		,mode:'local'
		,width:40
		,labelStyle:'width:20'
		,value: cfg.desdeOperadorValue
	})
	_this.comboFechaDesdeOp.on('select',function(){
			var val = comboFechaDesdeOp.getValue();
			if(val == "=" || val == "<>"){
				_this.comboFechaHastaOp.disable();
				fechaVencHasta.disable();
				fechaVencHasta.reset();
				_this.comboFechaHastaOp.reset();
			}else{
				_this.comboFechaHastaOp.enable();
				fechaVencHasta.enable();
			}	
		});
	_this.fechaDesde = new Ext.ux.form.XDateField({
		width:100
		,height:15
		,labelSeparator:""
		,value:cfg.fechaDesdeValue
	});
	_this.comboFechaHastaOp=new Ext.form.ComboBox({
		store:["<=","<"]
		,fieldLabel:cfg.hastaLabel
		,triggerAction : 'all'
		,mode:'local'
		,width:40
		,value:cfg.hastaOperadorValue
		
	})
	_this.fechaHasta = new Ext.ux.form.XDateField({
		width:100
		,height:15
		,labelSeparator:""
		,value:cfg.fechaHastaValue
	});
	_this.panelFechas=new Ext.form.FieldSet({
		title: cfg.title || ''
		,border:true
		,autoHeight:true		
		,items:[_this.comboFechaDesdeOp,_this.fechaDesde,_this.comboFechaHastaOp,_this.fechaHasta]
	})
	_this.validate=function(){
		var valid=true;
		if(_this.fechaDesde.getValue()!='' && _this.fechaHasta.getValue()!=''){
			valid = (_this.fechaDesde.getValue()< _this.fechaHasta.getValue())
		}
		if(_this.comboFechaDesdeOp.getValue()=='>=' || _this.comboFechaDesdeOp.getValue()=='>'){
			if (_this.fechaHasta.getValue()!='' && _this.comboFechaHastaOp.getValue()!='') 
				if(_this.fechaDesde.getValue()=='')
					valid = valid && false;
				else
					valid = valid && true;
		}
		return valid;
	}
	return _this
}
/**
 * Ventana Modal simil a un Ext.Msg.prompt
 * @param {Object} title
 * @param {Object} msg
 * @return (Object) handler: recibe parametros btn: el nombre del boton que se puls� (ok,cancelar),y text:el texto ingresado
 */
app.prompt=function(title,msg,handler){
	var texto=new Ext.form.TextArea({width:590
			,hideLabel:true
			,height:200
			,maxLength:3500
	});
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			win.close();
		}
	});
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			var text=texto.getValue();
			win.close();
			handler('ok',text);
			
		}
	});
	var panel= new Ext.Panel({
		autoHeight : true
		,border : false
		,bodyStyle:'padding:15px'
		//,style:'padding:20px'
		,items : [
			 new Ext.form.Label({text:msg,style:'font-weight:bold'})
			 ,texto
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	
	var cfg = {
			title: title
			,layout:'fit'
			,modal:true
			,x: 100
			,y: 100
			,autoShow : true
			,autoHeight : true
			,closable:false
			,width : 640
			,bodyBorder : false
			,items:panel
	};
	var win = new Ext.Window(cfg);
	win.show();	
}

/**
 * Ventana Modal simil a un app.prompt pero con tipo de input password
 * @param {Object} title
 * @param {Object} msg
 * @return (Object) handler: recibe parametros btn: el nombre del boton que se puls� (ok,cancelar),y text:el texto ingresado
 */
app.promptPw=function(title,msg,handler){
    var p = app.creaText('p','Password','',
                             {allowBlank : false, inputType:'password'});
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.botones.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			win.close();
		}
	});
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.botones.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			var text=p.getValue();
			win.close();
			handler('ok',text);
			
		}
	});
	var panel= new Ext.Panel({
		autoHeight : true
		,border : false
		,bodyStyle:'padding:15px'
		,items : [
			 new Ext.form.Label({text:msg,style:'font-weight:bold'})
			 ,p
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	
	var cfg = {
			title: title
			,layout:'fit'
			,modal:true
			,x: 100
			,y: 100
			,autoShow : true
			,autoHeight : true
			,closable:false
			,width : 240
			,bodyBorder : false
			,items:panel
	};
	var win = new Ext.Window(cfg);
	win.show();	
}

/* -------------------------------------------------------------------------------------------------------
* ESPACIO PARA AGRUPAR LOS POSIBLES OVERRIDES DEL CORE DE EXTJS PARA SOLUCIONAR POSIBLES BUGS O
* A�ADIR FUNCIONALIDADES NUEVAS.
*
* FIXME En caso de incrementarse el n�mero de overrides se puede plantear crear una clase overrides.js que los contenga
*		 
* Overrides members of the specified `target` with the given values.
*
* If the `target` is a function, it is assumed to be a constructor and the contents
* of `overrides` are applied to its `prototype` using {@link Ext#apply Ext.apply}.
* 
* If the `target` is an instance of a class created using {@link #define},
* the `overrides` are applied to only that instance. In this case, methods are
* specially processed to allow them to use {@link Ext.Base#callParent}.
* 
*      var panel = new Ext.Panel({ ... });
*      
*      Ext.override(panel, {
*          initComponent: function () {
*              // extra processing...
*              
*              this.callParent();
*          }
*      });
*
* If the `target` is none of these, the `overrides` are applied to the `target`
* using {@link Ext#apply Ext.apply}.
*
* Please refer to {@link Ext#define Ext.define} for further details.
*
* @param {Object} target The target to override.
* @param {Object} overrides The properties to add or replace on `target`. 
* @method override*
*
* -------------------------------------------------------------------------------------------------------*/


	Ext.override(Ext.grid.ColumnModel, {
			 /**
		     * Devuelve true si la columna especificada es sortable.
		     * Se sobreescribe para evitar errores en el caso de recibir un indice 
		     * fuera de rango ( en algunos casos llega a esta funcin el valor -1)
		     * @param {Number} col The column index
		     * @return {Boolean}
		     */
		    isSortable : function(col) {
		    
		    	var column = this.config[col];
		    	if (Ext.isEmpty(column)) {
		    		return false
		    	} else {
		        	return !!column.sortable;
		        }
		    }
	});


