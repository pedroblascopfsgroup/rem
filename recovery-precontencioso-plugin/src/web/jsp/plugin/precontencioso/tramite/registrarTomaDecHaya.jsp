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
	muestraBotonGuardar = 0;
</c:if>

if (muestraBotonGuardar==1){
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			//page.fireEvent(app.event.DONE);
			page.submit({
				eventName : 'ok'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE); }
				,error : function(response,config){}
			});
		}
	});
	
	//Si tiene m�s items que el propio label de descripci�n se crea el bot�n guardar
	if (items.length > 1)	{
		bottomBar.push(btnGuardar);
	}
}

<%@ include file="/WEB-INF/jsp/plugin/precontencioso/botonCancelar.jsp" %>

<c:if test="${form.tareaExterna.tareaProcedimiento.descripcion=='Dictar Instrucciones'}">
	bottomBar.push(btnExportarPDF);
</c:if>

<%-- Filtrado elementos combo --%>
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

for(i=0;i < items.length; i++){
	if(items[i].nombre == "proc_a_iniciar"){
		items[i] = new Ext.form.ComboBox({
				name:items[i].name
				,hiddenName:items[i].name
				,disabled:items[i].disabled
				,value:items[i].value
				,data:items[i].values
				,allowBlank : false
				,store: dsProcedimientos
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,emptyText:'----'
				,triggerAction: 'all'
				,fieldLabel : items[i].fieldLabel
		});
	}
}
<%-- Fin filtrado elementos combo --%>


var cambioProcedimiento = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDTipoProblemaDocPco.TIPO_PROBLEMA_CAMBIO_PROCEDIMIENTO" />';
var resultadoDocCompletaNO = '<fwk:const value="es.capgemini.pfs.procesosJudiciales.model.DDSiNo.NO" />';

var fechaRecep = items[1];
var docCompleta = items[2];
var fechaEnvio = items[3];
var tipoProblema = items[4];
var procedimientoPropuesto = items[5];
var procedimientoIniciar = items[6];
var rehacerDoc = items[7];

procedimientoPropuesto.setDisabled(true);
rehacerDoc.hide();

docCompleta.on('select', function() {
	if(docCompleta.getValue() == resultadoDocCompletaNO) {
		fechaRecep.allowBlank = false;
		docCompleta.allowBlank = false;
		fechaEnvio.allowBlank = false;
		fechaEnvio.setDisabled(false);
		tipoProblema.allowBlank = false;
		tipoProblema.setDisabled(false);
		procedimientoPropuesto.allowBlank = false;
		procedimientoIniciar.allowBlank = true;
		procedimientoIniciar.setDisabled(true);
		procedimientoIniciar.setValue('');
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
		procedimientoIniciar.setDisabled(false);
	}
});

tipoProblema.on('select', function() {
	if(tipoProblema.getValue() == cambioProcedimiento) {
		procedimientoIniciar.allowBlank = false;
		procedimientoIniciar.setDisabled(false);
	}else{
		procedimientoIniciar.allowBlank = true;
		procedimientoIniciar.setDisabled(true);
		procedimientoIniciar.setValue('');
	}
});

<%@ include file="/WEB-INF/jsp/plugin/precontencioso/panelEdicion.jsp" %>

page.add(panelEdicion);

</fwk:page>