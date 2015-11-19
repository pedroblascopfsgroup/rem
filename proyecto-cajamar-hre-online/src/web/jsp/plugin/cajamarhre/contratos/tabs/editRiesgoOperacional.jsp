<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>

<fwk:page>

	var riesgoOperacional = <app:dict value="${riesgoOperacional}" blankElement="true" blankElementValue=""/>;

	var optionsRiesgoOperacionalStore = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion']
		,root: 'diccionario'
		,data: riesgoOperacional
	});

	var comboRiesgoOperacional = new Ext.form.ComboBox({
		store: optionsRiesgoOperacionalStore
		,displayField: 'descripcion'
		,valueField: 'codigo'
		,mode: 'local'
		,style: 'margin:0px'
		,width:170
		,triggerAction:'all'
		,editable: false
		,fieldLabel:'<s:message code="contrato.consulta.tabOtrosDatos.riesgoOperacional" text="**Riesgo Operacional"/>'
	});
	
	var validarForm = function(){
		if(comboRiesgoOperacional.getValue == ''){
			return false;
		}else{
			return true;
		}
	
	};
	
	var btnGuardar = new Ext.Button({
		text: '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls: 'icon_ok'
		,handler: function(){
			if(validarForm()){

				page.webflow({
					flow: ''
					,params: parms
					,success: function(){
						page.fireEvent(app.event.DONE);
					}			
				});
			}else{
				Ext.Msg.alert('<s:message code="errores.todosLosDatosObligatorios" text="**Error" />');
			}
		}
	});
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){ page.fireEvent(app.event.CANCEL); }
	});

	var panelEdicion = new Ext.Panel({
		autoHeight: true
		,bodyStyle: 'padding:5px;cellspacing:20px;'
		,border: false
		,items: [comboRiesgoOperacional]
		,bbar:[btnGuardar, btnCancelar]
	});
	
	page.add(panelEdicion);

</fwk:page>