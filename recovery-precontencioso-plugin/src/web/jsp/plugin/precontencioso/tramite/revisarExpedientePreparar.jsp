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
		if(items[i].nombre == "proc_iniciar"){
			items[i] = new Ext.form.ComboBox({
								name:items[i].name
								,hiddenName:items[i].name
								,disabled:items[i].disabled
								,value:items[i].value
								,data:items[i].values
								,allowBlank : true
								,store:dsProcedimientos
								,displayField:'descripcion'
								,valueField:'codigo'
								,mode: 'local'
								,emptyText:'----'
								,triggerAction: 'all'
								,fieldLabel : '<s:message code="plugin.precontencioso.asignar.gestor.procedimiento.propuesto" text="**Procedimiento propuesto" />'
						});
		}

	var agenciaExternaSi = '<fwk:const value="es.capgemini.pfs.procesosJudiciales.model.DDSiNo.SI" />';
	
	var agenciaExt = items[2];
	var procedimientoProp = items[3];
	
	agenciaExt.on('select', function() {
		procedimientoProp.setValue('');
		if(agenciaExt.getValue() == agenciaExternaSi) {
			procedimientoProp.allowBlank = true;
		}else{
			procedimientoProp.allowBlank = false;
		}
	});
	
	
}


var gestionJUDICIALIZAR = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.model.DDTipoGestionRevisarExpJudicial.JUDICIALIZAR" />';

var gestion = items[2];
var proc_iniciar = items[3];

gestion.on('select', function() {
	if(gestion.getValue() == gestionJUDICIALIZAR) {
		proc_iniciar.allowBlank = false;
	}else{
		proc_iniciar.allowBlank = true;
	}
});



<%@ include file="/WEB-INF/jsp/plugin/precontencioso/panelEdicion.jsp" %>

page.add(panelEdicion);

</fwk:page>
