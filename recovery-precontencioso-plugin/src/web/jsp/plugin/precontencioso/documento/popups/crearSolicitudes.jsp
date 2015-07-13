<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>


<fwk:page>	

	var config = {width: 250, labelStyle:"width:150px;font-weight:bolder"};
	var modoConsulta = false;
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	var btnGuardar= new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler:function(){
				if (validateForm) {		    
			    	var p = getParametros();
			    	Ext.Ajax.request({
							url : page.resolveUrl('documentopco/saveCrearSolicitudes'), 
							params : p ,
							method: 'POST',
							success: function ( result, request ) {
								page.fireEvent(app.event.DONE);
							}
					});
				}
	     }
	});
	

	var validateForm = true;

	var getParametros = function() {
		
	 	var parametros = {};
	 	
	 	parametros.id = ${dtoDoc.id};
	 	parametros.fechaSolicitud = fechaSolicitud.getValue().format('d/m/Y');
	 	parametros.actor = actor.getValue();
	 	
	 	return parametros;
	 }	
	
	var actor = new Ext.form.TextField({
		name : 'actor'
		,value : '<s:message text="${actor}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.crearSolicitudes.actor" text="**Actor" />'
	});    
	
	
	<pfsforms:datefield labelKey="asd" label="**Fecha de Solicitud" name="fechaSolicitud" obligatory="true"/>
		
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight:true
		, border : false
				,layout : 'column'
				,height: 255
				,defaults:{xtype:'fieldset',cellCls : 'vtop',width:860, height:200}
				,items:[{
					title:'<s:message code="precontencioso.grid.documento.crearSolicitudes" text="**Creación Solicitudes" />'
					,layout:'table'
					,layoutConfig:{
						columns:2							
					}
					,defaults:{layout : 'form',border:false,height:175}
					,items:
						{
						items:[{
							border:false
							,style:'font-size:11px; margin:4px; top:5px'
							, bodyStyle:'padding:5px'
							,items:[fechaSolicitud, actor]
								}]
						, width: 280
						}
				}]
	});

	var panel=new Ext.Panel({
		border:false
		,bodyStyle : 'padding:5px'
		,autoHeight:true
		,autoScroll:true
		,width:840
		,height:600
		,defaults:{xtype:'fieldset',cellCls : 'vtop',width:840,autoHeight:true}
		,items:panelEdicion
		,bbar:[btnGuardar, btnCancelar]
	});	
	

	page.add(panel);
	
</fwk:page>