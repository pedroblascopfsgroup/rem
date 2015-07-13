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
				if (validateForm()) {		    
			    	var p = getParametros();
			    	Ext.Ajax.request({
							url : page.resolveUrl('documentopco/updateDocumentos'), 
							params : p ,
							method: 'POST',
							success: function ( result, request ) {
								page.fireEvent(app.event.DONE);
							}
					});
				}
	     }
	});
	

	var validateForm = function(){	
	if(protocolo.getValue() == '') {
		Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="precontencioso.grid.documento.incluirDocumento.sinProtocolo" text="**No se ha informado el campo PROTOCOLO ¿Desea continuar?" />', function(btn){
			if (btn == 'yes'){
				return true;
			}
			else {
	    		return false;
	    	}
		});	
	}	              
		return true;
	}	

	var getParametros = function() {
		
	 	var parametros = {};
	 	
	 	parametros.id = ${dtoDoc.id};
	 	parametros.protocolo = protocolo.getValue();
	 	parametros.notario = notario.getValue();
	 	parametros.fechaEscritura = fechaEscritura.getValue();
	 	parametros.asiento = asiento.getValue();
	 	parametros.finca = finca.getValue();
	 	parametros.tomo = tomo.getValue();
	 	parametros.libro = libro.getValue();
	 	parametros.folio = folio.getValue();
	 	parametros.numFinca = numFinca.getValue();
	 	parametros.numRegistro = numRegistro.getValue();
	 	parametros.plaza = plaza.getValue();
	 	parametros.idufir = idufir.getValue();
	 	
	 	return parametros;
	 }	
	
	var protocolo = new Ext.form.TextField({
		name : 'protocolo'
		,value : '<s:message text="${dtoDoc.protocolo}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.protocolo" text="**Protocolo" />'
	});    
	
	var notario = new Ext.form.TextField({
		name : 'notario'
		,value : '<s:message text="${dtoDoc.notario}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.notario" text="**Notario" />'
	});  
	
	var fechaEscritura = new Ext.ux.form.XDateField({
		name : 'fechaEscritura'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.fechaEscritura" text="**Fecha escritura" />'
		,value : '<fwk:date value="${fechaEscritura}" />'
		,allowBlank : false
		,style:'margin:0px'
	});
	
	var asiento = new Ext.form.TextField({
		name : 'asiento'
		,value : '<s:message text="${dtoDoc.asiento}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.asiento" text="**Asiento" />'
	});  
	
	var finca = new Ext.form.TextField({
		name : 'finca'
		,value : '<s:message text="${dtoDoc.finca}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.finca" text="**Finca" />'
	});  
	
	var tomo = new Ext.form.TextField({
		name : 'tomo'
		,value : '<s:message text="${dtoDoc.tomo}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.tomo" text="**Tomo" />'
	});  
	
	var libro = new Ext.form.TextField({
		name : 'libro'
		,value : '<s:message text="${dtoDoc.libro}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.libro" text="**Libro" />'
	}); 
	
	var folio = new Ext.form.TextField({
		name : 'folio'
		,value : '<s:message text="${dtoDoc.folio}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.folio" text="**Folio" />'
	});  
	
	var numFinca = new Ext.form.TextField({
		name : 'documento.numFinca'
		,value : '<s:message text="${dtoDoc.numFinca}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.numFinca" text="**Número Finca" />'
	});  
	
	var numRegistro = new Ext.form.TextField({
		name : 'numRegistro'
		,value : '<s:message text="${dtoDoc.numRegistro}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.numRegistro" text="**Número Registro" />'
	});  
	
	var plaza = new Ext.form.TextField({
		name : 'plaza'
		,value : '<s:message text="${plaza}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.plaza" text="**Plaza" />'
	});  	
	
	var idufir = new Ext.form.TextField({
		name : 'idufir'
		,value : '<s:message text="${dtoDoc.idufir}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.incluirDocumento.idufir" text="**IDUFIR" />'
	});  	

		
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight:true
		, border : false
				,layout : 'column'
				,height: 255
				,defaults:{xtype:'fieldset',cellCls : 'vtop',width:860, height:200}
				,items:[{
					title:'<s:message code="precontencioso.grid.documento.incluirDocumento.infoDocumentos" text="**Información Documentos" />'
					,layout:'table'
					,layoutConfig:{
						columns:2							
					}
					,defaults:{layout : 'form',border:false,height:175}
					,items:[
						{
						items:[{
							border:false
							,style:'font-size:11px; margin:4px; top:5px'
							, bodyStyle:'padding:5px'
							,items:[notario, asiento, finca, numFinca, numRegistro, plaza]
								}]
						, width: 280
						}
						,{
							items:[protocolo, fechaEscritura, tomo, libro, folio, idufir]
							,width:280
						}
					]
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