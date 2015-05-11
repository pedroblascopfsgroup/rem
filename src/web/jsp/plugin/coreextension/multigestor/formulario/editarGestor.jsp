<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>	

	var panelWidth=640;

	var ugCodigo = new Ext.form.Hidden ({
		id:ugCodigo
		,name:ugCodigo
		,value:'${ugCodigo}'
	});
	
	var ugId = new Ext.form.Hidden ({
		id:ugId
		,name:ugId
		,value:'${ugId}'
	});

	var ditcTipoGestor = <app:dict value="${tiposGestores}" />;

	
	var storeTipo = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : ditcTipoGestor
	       ,root: 'diccionario'
	});
	
	var comboTipo = new Ext.form.ComboBox({
		  name: 'tipoGestor',
		  fieldLabel: '<s:message code="plugin.coreextension.multigestor.tipoGestor" text="**Tipo de gestor" />',
		  mode: 'local',
		  store: storeTipo,
		  displayField:'descripcion',
		  valueField:'codigo',
		  triggerAction: 'all',
		  width: 180,
		  labelStyle:'width:100px'
		  //,value:'${tipoIngreso}'
	});	
	
	var ditcUsuario = <app:dict value="${usuarios}" />;

	
	var storeUsuario = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : ditcUsuario
	       ,root: 'diccionario'
	});
	
	var comboUsuario = new Ext.form.ComboBox({
		  name: 'usuarioGestor',
		  fieldLabel: '<s:message code="plugin.coreextension.multigestor.usuario" text="**Usuario" />',
		  mode: 'local',
		  store: storeUsuario,
		  displayField:'descripcion',
		  valueField:'codigo',
		  triggerAction: 'all',
		  width: 180,
		  labelStyle:'width:100px'
		  //,value:'${tipoIngreso}'
	});	
	
	
	
	
	var btnAceptar = new Ext.Button({
	       text : '<s:message code="app.guardar" text="**Guardar" />'
			,iconCls : 'icon_ok'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	      		page.webflow({
	      			flow : 'plugin/coreextension/multigestor/saveGestor'
	      			,params:{
	      				   ugCodigo:ugCodigo.getValue()
	      				   ,ugId:ugId.getValue()
	      				   ,idTipoGestor:comboTipo.getValue()
	      				   ,idUsuario:comboUsuario.getValue()
	      				   
	      				}
	      			,success: function(){
	      			   
            		   page.fireEvent(app.event.DONE);
            		}	
	      		});
	     }
	});

	var btnCancelar = new Ext.Button({
	       text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
	       ,cls: 'x-btn-text-icon'
	       ,handler:function(){
	      		page.fireEvent(app.event.CANCEL);
	     	}
	});
	
	

 	var mainPanel = new Ext.FormPanel({
        labelWidth: 50,
        width: panelWidth,
    	autoHeight:true,
        bodyStyle: 'padding:5px;',
        items: [comboTipo,comboUsuario],
        bbar:[btnAceptar,btnCancelar]
    });
   
	page.add(mainPanel);
</fwk:page>	