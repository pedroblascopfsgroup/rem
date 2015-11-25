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

	var labelStyle='font-weight:bolder;width:140px';

	var ddriesgoOperacional = <app:dict value="${ddriesgoOperacional}" blankElement="true" blankElementValue=""/>;

	var optionsRiesgoOperacionalStore = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion']
		,root: 'diccionario'
		,data: ddriesgoOperacional
	});

	var comboRiesgoOperacional = new Ext.form.ComboBox({
		name:'riesgo'
		,store: optionsRiesgoOperacionalStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode:'local'
		,style:'margin:0px'
		,triggerAction:'all'
		,width:170
		,listWidth: '500'
		,editable: false
		<c:if test="${riesgoOperacional !=null}" >
			,value:${riesgoOperacional.codigo}
		</c:if>
		,fieldLabel: '<s:message code="contrato.consulta.tabOtrosDatos.riesgoOperacional" text="**Riesgo Operacional" />'
		,labelStyle:labelStyle
	});
	
	
	
	var validarForm = function(){
		if(comboRiesgoOperacional.getValue == ''){
			return false;
		}else{
			return true;
		}
	
	};
	
	var getParametros  = function(){
		var param = new Object();
		param.codRiesgoOperacional = comboRiesgoOperacional.getValue();
		
		return param.codRiesgoOperacional;
		
	};
	
	var btnGuardar = new Ext.Button({
		text: '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls: 'icon_ok'
		,handler: function(){
			if(validarForm()){

				page.webflow({
					flow: 'riesgooperacional/actualizarRiesgoOperacional'
					,params : {idContrato:${cntId}, codRiesgoOperacional: getParametros()}
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
	
	var datos = new Ext.form.FieldSet({
		height:60
		,width:365
		,style:'padding:0px'
  	   	,border:true
		,layout : 'table'
		,border : true
		,layoutConfig:{
			columns:1
		}
		,title:'<s:message code="contrato.consulta.tabOtrosDatos.datos" text="**Datos"/>'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:350}
	    ,items : [{items:[comboRiesgoOperacional]}]
	});

	var panelEdicion = new Ext.form.FormPanel({
		height: 125
		,autoWidth: true
		,bodyStyle: 'padding:5px;cellspacing:20px;'
		,border: true
		,y: 50
		,items: [datos]
		,bbar:[btnGuardar, btnCancelar]
	});
	
	page.add(panelEdicion);

</fwk:page>