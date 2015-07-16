<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>


<fwk:page>	

	<pfsforms:ddCombo name="comboEstadosDocumento"
		labelKey="precontencioso.grid.documento.informarDocumento.estadoDocumento" 
 		label="**Estado Documento" value="${solicitud.estado}" dd="${estadosDocumento}" 
		propertyCodigo="codigo" propertyDescripcion="descripcion" />

	<pfsforms:ddCombo name="adjuntado"
		labelKey="precontencioso.grid.documento.informarDocumento.estadoDocumento"
		label="**Adjuntado" value="${solicitud.adjuntado}" dd="${ddSiNo}" width="50"  propertyCodigo="codigo"/>	
		
	var fechaResultado = new Ext.ux.form.XDateField({
		name : 'fechaResultado'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.informarDocumento.fechaResultado" text="**Fecha resultado" />'
		,value : '${solicitud.fechaResultado}'
		,style:'margin:0px'
	});
	
	<pfsforms:ddCombo name="comboRespuestasSolicitud"
		labelKey="precontencioso.grid.documento.informarDocumento.respuestaSolicitud" 
 		label="**Respuesta Solicitud" value="${solicitud.respuesta}" dd="${respuestasSolicitud}" 
		propertyCodigo="codigo" propertyDescripcion="descripcion" />


	var fechaEnvio = new Ext.ux.form.XDateField({
		name : 'fechaEnvio'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.informarDocumento.fechaEnvio" text="**Fecha envío" />'
		,value : '${solicitud.fechaEnvio}'
		,style:'margin:0px'
	});
	
	var fechaRecepcion = new Ext.ux.form.XDateField({
		name : 'fechaRecepcion'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.informarDocumento.fechaRecepcion" text="**Fecha recepción" />'
		,value : '${solicitud.fechaRecepcion}'
		,style:'margin:0px'
	});
	
    var comentario = new Ext.form.TextArea({
			name : 'comentario'
            ,fieldLabel: '<s:message code="precontencioso.grid.documento.informarDocumento.comentario" text="**Comentario" />'
            ,height : 60
            ,width : 450
            ,value : '${solicitud.comentario}'
    });
	
		
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
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	var panelEdicion = new Ext.form.FieldSet({
		title:'<s:message code="precontencioso.grid.documento.informarDocumento.informarSolicitud" text="**Datos de la solicitud" />'
		,layout:'table'
		,layoutConfig:{columns:1}
		,border:true
		,autoHeight : true
   	    ,autoWidth : true
		,defaults : {xtype : 'fieldset', border:false , cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
		,items:[{items: [ comboEstadosDocumento, adjuntado, fechaResultado, comboRespuestasSolicitud, fechaEnvio, fechaRecepcion, comentario ]}]
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