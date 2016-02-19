<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){


	var listadoDecisionSancion = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var decionSancionStore = page.getStore({
	       flow: 'mejexpediente/getListDecisionSancion'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'decisionSancion'
	    }, listadoDecisionSancion)	      
	});
    
    decionSancionStore.webflow();
    
	var decionSancion = new Ext.form.ComboBox({
		name:'decionSancion'
        ,store: decionSancionStore
        ,mode:'local'
        ,triggerAction:'all'
        ,editable: false
        ,fieldLabel: '<s:message code="expedientes.consulta.tabsancion.decision" text="**Decisión" />'
        ,displayField:'descripcion'
        ,valueField: 'id'
        ,labelStyle:'font-weight:bolder'
        ,height : 35
        ,width : 200
        ,readOnly : true
    });



	labelObs = new Ext.form.Label({
	   	text:'<s:message code="expedientes.consulta.tabsancion.observaciones" text="**Observaciones:"/>'
		,style:'font-weight:bolder;font-family:tahoma,arial,helvetica,sans-serif;font-size:11px;'
	});

	var observaciones = new Ext.form.TextArea({
		name: 'observaciones'
		,value: ''
		,width: 1000
		,height: 125
		,style:'margin-top:5px'
		,hideLabel: true
		,readOnly : true
	});
	
	btnModificar = new Ext.Button({
			text: '<s:message code="expedientes.consulta.tabsancion.btnModificar" text="**Modificar" />'
			,border:false
			,iconCls : 'icon_edit'
			,cls: 'x-btn-text-icon'
			,handler:function(){
				observaciones.setReadOnly( false );
				decionSancion.setReadOnly( false );
				btnCancelar.setVisible(true);
				btnGuardar.setVisible(true);
				btnModificar.setVisible(false);
	   	    }
	});
	
	btnCancelar = new Ext.Button({
			text: '<s:message code="expedientes.consulta.tabsancion.btnCancelar" text="**Cancelar" />'
			,border:false
			,iconCls : 'icon_cancel'
			,cls: 'x-btn-text-icon'
			,hidden : true 
			,style:'margin-left:10px'
			,handler:function(){
				observaciones.setReadOnly(true);
				decionSancion.setReadOnly(true);
				btnCancelar.setVisible(false);
				btnGuardar.setVisible(false);
				btnModificar.setVisible(true);
	   	    }
	});
	
	
	btnGuardar = new Ext.Button({
			text: '<s:message code="expedientes.consulta.tabsancion.btnGuardar" text="**Guardar" />'
			,border:false
			,iconCls : 'icon_ok'
			,cls: 'x-btn-text-icon'
			,hidden : true 
			,handler:function(){
				observaciones.setReadOnly(true);
				decionSancion.setReadOnly(true);
				btnCancelar.setVisible(false);
				btnGuardar.setVisible(false);
				btnModificar.setVisible(true);
	   	    }
	});
	
	var formSancion = new Ext.form.FormPanel({
		border:false
		,autoHeight:true
		,items:[decionSancion,labelObs,observaciones]
	});
	
	var botonera = new Ext.form.FieldSet({
		border:false
		,defaults : {border:false }
		,layout:'table'
		,layoutConfig:{columns:3}
		,items:[btnModificar,btnGuardar,btnCancelar]
	});
	
	var panelSancionar = new Ext.form.FieldSet({
		border:true
		,style:'padding:5px;padding-top: 25px;'
		,defaults : {border:false }
		,monitorResize: true
		,items:[formSancion,botonera]
	});

	var panel = new Ext.Panel({
			autoHeight:true
			,autoWidth:true
			,layout:'auto'
			,title:'<s:message code="expedientes.consulta.tabsancion.titulo" text="**Sancionar"/>'
			,layoutConfig:{columns:1}
			,style:'margin-right:20px;margin-left:10px'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[panelSancionar]}
			]
			,nombreTab : 'tabSancionar'
	});
	

	
	panel.getValue = function(){};
	panel.setValue = function(){};
	
	<%--   
		panel.getCodExpediente = function(){
		return entidad.get("data").cabecera.codExpediente;
	}
	
	panel.setVisibleTab = function(data){
		return entidad.get("data").toolbar.tipoExpediente != 'REC';
   	}
	 --%>
	 
	return panel;
})
