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
	var labelStyle='width:100';
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	var handlerGuardar = function() {
		var p = getParametros();
		var mask=new Ext.LoadMask(panel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Guardando..."/>'});
		mask.show();
    	Ext.Ajax.request({
				url : page.resolveUrl('documentopco/editarDocumento'), 
				params : p ,
				method: 'POST',
				success: function ( result, request ) {
					page.fireEvent(app.event.DONE);
					mask.hide();
				}
		});
	}
	
	var btnGuardar= new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler:function(){
				if (validateForm()) {
			    	handlerGuardar();
				}
	     }
	});
	

	var validateForm = function(){	
		if(protocolo.getValue() == '') {
			Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="precontencioso.grid.documento.editarDocumento.sinProtocolo" text="**No se ha informado el campo PROTOCOLO ¿Desea continuar?" />', function(btn){
				if (btn == 'yes'){
					handlerGuardar();
				}
			});	
		}
		else{
			Ext.Ajax.request({
				url : page.resolveUrl('documentopco/validacionDuplicadoDocumentoEditado'), 
				params : getParametros() ,
				method: 'POST',
				success: function ( result, request ) {
					var resultado = Ext.decode(result.responseText);
					if(resultado.documento_duplicado){
						Ext.Msg.confirm('<s:message code="app.confirmar" text="**Confirmar" />', '<s:message code="precontencioso.grid.documento.incluirDocumento.documentoDuplicado" text="**Ya existe un documento del mismo tipo, siendo el mismo protocolo y notario en la unidad de gestión seleccionada." />', function(btn){
							if (btn == 'yes'){
			   					handlerGuardar();
			   				}
						});
					}
					else {
						handlerGuardar();
					}
				}
			});
		}
	}	

	var getParametros = function() {
		
	 	var parametros = {};
	 	
	 	parametros.id = ${dtoDoc.id};
	 	parametros.protocolo = protocolo.getValue();
	 	parametros.notario = notario.getValue();
 		if (fechaEscritura.getValue()=='')
	 		parametros.fechaEscritura = '';
	 	else
	 		parametros.fechaEscritura = fechaEscritura.getValue().format('d/m/Y');	 	
	 	parametros.asiento = asiento.getValue();
	 	parametros.finca = finca.getValue();
	 	parametros.tomo = tomo.getValue();
	 	parametros.libro = libro.getValue();
	 	parametros.folio = folio.getValue();
	 	parametros.numFinca = numFinca.getValue();
	 	parametros.numRegistro = numRegistro.getValue();
	 	parametros.plaza = plaza.getValue();
	 	parametros.idufir = idufir.getValue();
	 	parametros.provinciaNotario = comboProvinciaNotario.getValue();
	 	
	 	return parametros;
	 }	
	
	var protocolo = new Ext.form.TextField({
		name : 'protocolo'
		,value : '<s:message text="${dtoDoc.protocolo}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.protocolo" text="**Protocolo" />'
	});    
	
	var notario = new Ext.form.TextField({
		name : 'notario'
		,value : '<s:message text="${dtoDoc.notario}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.notario" text="**Notario" />'
	});  
	
	var fechaEscritura = new Ext.ux.form.XDateField({
		name : 'fechaEscritura'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.fechaEscritura" text="**Fecha escritura" />'
		,value : '<s:message text="${dtoDoc.fechaEscritura}" />'
		,style:'margin:0px'
	});
	
	var asiento = new Ext.form.TextField({
		name : 'asiento'
		,value : '<s:message text="${dtoDoc.asiento}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.asiento" text="**Asiento" />'
	});  
	
	var finca = new Ext.form.TextField({
		name : 'finca'
		,value : '<s:message text="${dtoDoc.finca}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.finca" text="**Finca" />'
	});  
	
	var tomo = new Ext.form.TextField({
		name : 'tomo'
		,value : '<s:message text="${dtoDoc.tomo}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.tomo" text="**Tomo" />'
	});  
	
	var libro = new Ext.form.TextField({
		name : 'libro'
		,value : '<s:message text="${dtoDoc.libro}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.libro" text="**Libro" />'
	}); 
	
	var folio = new Ext.form.TextField({
		name : 'folio'
		,value : '<s:message text="${dtoDoc.folio}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.folio" text="**Folio" />'
	});  
	
	var numFinca = new Ext.form.TextField({
		name : 'documento.numFinca'
		,value : '<s:message text="${dtoDoc.numFinca}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.numFinca" text="**Número Finca" />'
	});  
	
	var numRegistro = new Ext.form.TextField({
		name : 'numRegistro'
		,value : '<s:message text="${dtoDoc.numRegistro}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.numRegistro" text="**Número Registro" />'
	});  
	
	var plaza = new Ext.form.TextField({
		name : 'plaza'
		,value : '<s:message text="${dtoDoc.plaza}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.plaza" text="**Plaza" />'
	});  	
	
	var idufir = new Ext.form.TextField({
		name : 'idufir'
		,value : '<s:message text="${dtoDoc.idufir}" javaScriptEscape="true" />'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.editarDocumento.idufir" text="**IDUFIR" />'
	});  
	
	<pfsforms:ddCombo name="comboProvinciaNotario"
		labelKey="precontencioso.grid.documento.incluirDocumento.localidadNotario" 
 		label="**Localidad Notario" value="${dtoDoc.provinciaNotario}" dd="${listaProvincias}" 
		propertyCodigo="codigo" propertyDescripcion="descripcion" />
	comboProvinciaNotario.labelStyle=labelStyle;	


	var panelEdicion = new Ext.form.FieldSet({
		title:'<s:message code="precontencioso.grid.documento.editarDocumento.infoDocumentos" text="**Información Documentos" />'
		,layout:'table'
		,layoutConfig:{columns:2}
		,border:true
		,autoHeight : true
   	    ,autoWidth : true
		,defaults : {xtype : 'fieldset', border:false , cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
		,items:[{items: [ notario, asiento, finca, numFinca, numRegistro, plaza]}
				,{items: [ comboProvinciaNotario, protocolo, fechaEscritura, tomo, libro, folio, idufir]}
		]
	});	
	
	var panel=new Ext.Panel({
		border:false
		,bodyStyle : 'padding:5px'
		,autoHeight:true
		,autoScroll:true
		,width:600
		,height:620
		,defaults:{xtype:'fieldset',cellCls : 'vtop',width:600,autoHeight:true}
		,items:panelEdicion
		,bbar:[btnGuardar, btnCancelar]
	});	
	

	page.add(panel);
	
</fwk:page>