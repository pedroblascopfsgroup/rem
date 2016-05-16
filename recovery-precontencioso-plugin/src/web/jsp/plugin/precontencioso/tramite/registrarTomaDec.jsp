<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

array = [];
array['uno']=1;
array['dos']=2;
array['tres']=3;
var tipo_wf='${tipoWf}';
var bottomBar = [];

<%@ include file="/WEB-INF/jsp/plugin/precontencioso/elementos.jsp" %>
<%@ include file="/WEB-INF/jsp/plugin/precontencioso/items.jsp" %>
<%@ include file="/WEB-INF/jsp/plugin/precontencioso/botonExportar.jsp" %>

//mostramos el bot�n guardar cuando la tarea no est� terminada y cuando no hay errores de validacion
<c:if test="${form.tareaExterna.tareaPadre.fechaFin==null && form.errorValidacion==null && !readOnly}">
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if(tipoProblema.getValue() == cambioProcedimiento) {
				if(procedimientoPropuesto.getValue() == procedimientoIniciar.getValue()) {
					Ext.Msg.alert('sTATUS', 'Si tipo de problema es Cambio de procedimiento, no pueden coincidir procedimiento propuesto por la entidad y procedimiento a iniciar.');
					return;
				}
			}
			
			procedimientoIniciar.setDisabled(false);
			
			//page.fireEvent(app.event.DONE);
			page.submit({
				eventName : 'ok'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE); }
				,error : function(response,config){
					var a;
				}
			});
		}
	});
	
	//Si tiene m�s items que el propio label de descripci�n se crea el bot�n guardar
	if (items.length > 1)
	{
		bottomBar.push(btnGuardar);
	}
</c:if>


<%@ include file="/WEB-INF/jsp/plugin/precontencioso/botonCancelar.jsp" %>

<c:if test="${form.tareaExterna.tareaProcedimiento.descripcion=='Dictar Instrucciones'}">
	bottomBar.push(btnExportarPDF);
</c:if>

var cambioProcedimiento = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDTipoProblemaDocPco.TIPO_PROBLEMA_CAMBIO_PROCEDIMIENTO" />';
var resultadoDocCompletaNO = '<fwk:const value="es.capgemini.pfs.procesosJudiciales.model.DDSiNo.NO" />';

var fechaRecep = items[1];
var docCompleta = items[2];
var fechaEnvio = items[3];
var tipoProblema = items[4];
var procedimientoPropuesto = items[5];
var procedimientoIniciar = items[6];

procedimientoPropuesto.readOnly = true;

var dsProcedimientos = new Ext.data.Store({
			autoLoad:true,
			proxy: new Ext.data.HttpProxy({
				url: page.resolveUrl('expedientejudicial/getTiposProcedimientoAsignacionDeGestores')
			}),
			reader: new Ext.data.JsonReader({
				root: 'listadoProcedimientos'
				,totalProperty: 'total'
			}, [
				{name: 'codigo', mapping: 'codigo'},
				{name: 'descripcion', mapping: 'descripcion'}
			])
		});
	
items[6] = new Ext.form.ComboBox({
							name:procedimientoIniciar.name
							,hiddenName:procedimientoIniciar.name
							,disabled:procedimientoIniciar.disabled
							,value:procedimientoIniciar.value
							,allowBlank : true
							,store:dsProcedimientos
							,displayField:'descripcion'
							,valueField:'codigo'
							,mode: 'local'
							,emptyText:''
							,triggerAction: 'all'
							,fieldLabel : '<s:message code="plugin.precontencioso.asignar.gestor.procedimiento.iniciar" text="**Procedimiento a iniciar" />'
					});
					
procedimientoIniciar = items[6];					

docCompleta.on('select', function() {
	if(docCompleta.getValue() == resultadoDocCompletaNO) {
		fechaRecep.allowBlank = false;
		docCompleta.allowBlank = false;
		fechaEnvio.allowBlank = false;
		fechaEnvio.setDisabled(false);
		tipoProblema.allowBlank = false;
		tipoProblema.setDisabled(false);
		procedimientoPropuesto.allowBlank = false;
		
		if(procedimientoPropuesto.getValue() != '') { 
			procedimientoIniciar.allowBlank = true;
			procedimientoIniciar.readOnly = true;
			procedimientoIniciar.setValue(procedimientoPropuesto.getValue());
		}
	}else{
		fechaRecep.allowBlank = false;
		docCompleta.allowBlank = false;
		fechaEnvio.allowBlank = true;
		fechaEnvio.setDisabled(true);
		fechaEnvio.setValue('');
		tipoProblema.allowBlank = true;
		tipoProblema.setDisabled(true);
		tipoProblema.setValue('');
		procedimientoPropuesto.allowBlank = false;
		procedimientoIniciar.allowBlank = false;
		if(tipoProblema.getValue() == cambioProcedimiento) {
			procedimientoIniciar.setDisabled(false);
		} else {
			if(procedimientoPropuesto.getValue() != '') {
				procedimientoIniciar.readOnly = true;
				procedimientoIniciar.setValue(procedimientoPropuesto.getValue());
			}
		}
	}
});

tipoProblema.on('select', function() {
	procedimientoIniciar.allowBlank = false;
	if(tipoProblema.getValue() == cambioProcedimiento) {
		procedimientoIniciar.setDisabled(false);
	}else{
		if(procedimientoPropuesto.getValue() != '') {
			procedimientoIniciar.setDisabled(true);
			procedimientoIniciar.setValue(procedimientoPropuesto.getValue());
		}
	}
});

<%@ include file="/WEB-INF/jsp/plugin/precontencioso/panelEdicion.jsp" %>

page.add(panelEdicion);

</fwk:page>