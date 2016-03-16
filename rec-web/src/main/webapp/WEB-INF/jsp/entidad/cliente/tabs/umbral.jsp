<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(page,entidad){

/*	var panel=new Ext.Panel({
		title:'<s:message code="clientes.umbral.tituloTab" text="**Umbral Expediente"/>'
		,layout:'table'
		,border : false
	    ,layoutConfig: {
	        columns: 1
	    }
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'umbralPanel'
	});
*/	
	var panel=new Ext.Panel({
		title : '<s:message code="clientes.umbral.tituloTab" text="**Umbral Expediente"/>'
		,layout:'table'
		,border : false
		,layoutConfig: { columns: 1 }
		,autoScroll:true
		,bodyStyle:'padding:5px;margin:5px'
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'umbralPanel'
	});
	
	
	var labelStyle='font-weight:bolder;';
	
	var importeUmbralField = new Ext.form.Label({
		fieldLabel:'<s:message code="plugin.mejoras.clientes.umbral.importe" text="**Importe" />'
		,text: ''
		,name:'persona.importeUmbral'
		,labelStyle:labelStyle
		,readOnly:true
	});
	
	var fechaUmbralField = new Ext.form.TextField({
		fieldLabel:'<s:message code="clientes.umbral.fecha" text="**Fecha" />'
		,value:''
		,name:'persona.fechaUmbral'
		,labelStyle:labelStyle
		,readOnly:true
	});
	var tituloobservaciones = new Ext.form.Label({
		text:'<s:message code="clientes.umbral.observaciones" text="**Observaciones" />'
		,style:'font-weight:bolder; font-size:11'
	}); 
	
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="clientes.umbral.observaciones" text="**Observaciones" />'
		,value:''
		,name:'persona.comentarioUmbral'
		,hideLabel: true
		,width:580
		,height: 200
		,maxLength: 1024
		,labelStyle:labelStyle
		,readOnly:true
	});

	var btnModificar = new Ext.Button({
		text: '<s:message code="app.editar" text="**Editar" />'
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler:function(){
		var w = app.openWindow({
				flow : 'clientes/umbral'
				,width:650
				,title : '<s:message code="clientes.umbra.editar" text="**Editar Umbral" />'
				,params : {idPersona:panel.getPersonaId()}
			});
			w.on(app.event.DONE, function(){
				w.close();
				entidad.refrescar();
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});

	var formU = new Ext.form.FormPanel({
		border:true
		,autoHeight:true
		,title:'<s:message code="clientes.umbral" text="**Umbral" />'
		,items:[{
				layout : 'table'
				,layoutConfig:{columns:2}
				,border : false
				
				,defaults : {xtype: 'fieldset', autoHeight: true, border: false ,cellCls: 'vtop', bodyStyle: 'padding:5px'}
				,items:[
						{ items : importeUmbralField }
						,{ items : fechaUmbralField }
						,{items:tituloobservaciones,colspan:2}
						,{items:observaciones,colspan:2}
					
				  ]
			}
		  ]
	});
	
	var panelUmbralDatos = new Ext.form.FieldSet({
		border:true
		,height:250
		,width:650
		,defaults : {border:false }
		,monitorResize: true
		,items:[    
			{items:formU}
		]
	});
	
	panel.add({
		layout : 'table'
		,border : false
		,defaults : {xtype: 'fieldset', autoHeight: true, border: false ,cellCls: 'vtop', bodyStyle: 'padding-top:10px'}
		,items:[panelUmbralDatos]
	},{
		layout : 'table'
		,border : false
		,defaults : {xtype: 'fieldset', autoHeight: true, border: false ,cellCls: 'vtop'}				
	<sec:authorize ifAllGranted="EDITAR_UMBRAL">
		,items:[ { items:[ btnModificar ] } ]
	</sec:authorize>
	});

	panel.getPersonaId = function(){
      return entidad.get("data").id;
	}

	panel.getValue = function(){}
	
	panel.setValue = function(){
	  var data=entidad.get("data");
	  importeUmbralField.setText(app.format.moneyRenderer(data.umbral.importeUmbral));
      fechaUmbralField.setValue(data.umbral.fechaUmbral);
      observaciones.setValue(data.umbral.comentarioUmbral);
	}
	
	return panel;
})
