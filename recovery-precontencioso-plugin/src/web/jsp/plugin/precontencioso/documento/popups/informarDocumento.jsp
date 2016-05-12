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
 		label="**Estado Documento" value="" dd="${estadosDocumento}" 
		propertyCodigo="codigo" propertyDescripcion="descripcion" />

	comboEstadosDocumento.setValue('${solicitud.estado}');

	<pfsforms:ddCombo name="adjuntado"
		labelKey="precontencioso.grid.documento.informarDocumento.adjuntado"
		label="**Adjuntado" value="${solicitud.adjuntado}" dd="${ddSiNo}" width="50"  propertyCodigo="codigo"/>	
		
	<pfsforms:ddCombo name="ejecutivo" 
		labelKey="precontencioso.grid.documento.informarDocumento.ejecutivo"
		label="**Ejecutivo" value="" dd="${ddSiNoNoAplica}" width="100"  propertyCodigo="codigo"/>	
		
	ejecutivo.setValue('${solicitud.ejecutivo}');
		
	var fechaResultado = new Ext.ux.form.XDateField({
		name : 'fechaResultado'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.informarDocumento.fechaResultado" text="**Fecha resultado" />'
		,value : '${solicitud.fechaResultado}'
		,style:'margin:0px'
	});
	
	<pfsforms:ddCombo name="comboRespuestasSolicitud"
		labelKey="precontencioso.grid.documento.informarDocumento.respuestaSolicitud" 
 		label="**Respuesta Solicitud" value="" dd="${respuestasSolicitud}" 
		propertyCodigo="codigo" propertyDescripcion="descripcion" />

	comboRespuestasSolicitud.setValue('${solicitud.respuesta}');

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
            ,value : '<s:message text="${solicitud.comentario}" javaScriptEscape="true" />'
    });
	
		
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	var validateForm = function(){	
		if((fechaResultado.getValue() != "" || fechaEnvio.getValue() != "" || fechaRecepcion.getValue() != "") && comboRespuestasSolicitud.getValue() == "") {
			Ext.Msg.alert('Error', '<s:message code="precontencioso.grid.documento.informarDocumento.resultadoObligatorio3" text="**Es obligatorio el campo Resultado, si se informa la Fecha Resultado o la Fecha Envío o la Fecha Recepción." />');
			comboRespuestasSolicitud.focus();
			return false;
		}
	
		if ('${solicitud.actor}' == '<fwk:const value="es.pfsgroup.plugin.precontencioso.documento.model.DDTipoActorPCO.GESTORIA" />') {
			if (fechaResultado.getValue() == "" || comboRespuestasSolicitud.getValue() == "") {
				Ext.Msg.alert('Error', '<s:message code="precontencioso.grid.documento.informarDocumento.resultadoObligatorio" text="**Son obligatorios los campos Fecha Resultado y Resultado." />');
				fechaResultado.focus();
				return false;
			}
			if ("OK" == comboRespuestasSolicitud.getValue()) {
				comboEstadosDocumento.setValue("EN");
			} else {
				comboEstadosDocumento.setValue("PS");
			}
		} else {
			if(!${existeSolDisponible}){
				if (fechaRecepcion.getValue() != "" && "01"==adjuntado.getValue()) {
					comboEstadosDocumento.setValue("DI");
				}else if (fechaEnvio.getValue()) {
					comboEstadosDocumento.setValue("EN");
				}else if (fechaResultado.getValue() != "" && "OK" != comboRespuestasSolicitud.getValue()) {
					comboEstadosDocumento.setValue("PS");
				}else if (fechaResultado.getValue() != "" && "OK" == comboRespuestasSolicitud.getValue()) {
					comboEstadosDocumento.setValue("SO");
				} 
			}else{
				comboEstadosDocumento.setValue("DI");
			}
		}
		return true;
		
	}
	
	var getParametros = function() {
	
	 	var parametros = {};
	 	parametros.idSolicitud = '${solicitud.idSolicitud}';
	 	parametros.actor = '${solicitud.actor}';
	 	parametros.idDoc = '${solicitud.idDoc}';
		
		parametros.estado = comboEstadosDocumento.getValue();	 	
 		parametros.adjuntado = adjuntado.getValue();
 		parametros.ejecutivo = ejecutivo.getValue();
 		if (fechaResultado.getValue() != "") {
		 	parametros.fechaResultado = fechaResultado.getValue().format('d/m/Y');
		} else {
		 	parametros.fechaResultado = "";
		}
	 	parametros.resultado = comboRespuestasSolicitud.getValue();
 		if (fechaEnvio.getValue() != "") {
		 	parametros.fechaEnvio = fechaEnvio.getValue().format('d/m/Y');
		} else {
		 	parametros.fechaEnvio = "";
		}
 		if (fechaRecepcion.getValue() != "") {
		 	parametros.fechaRecepcion = fechaRecepcion.getValue().format('d/m/Y');
		} else {
		 	parametros.fechaRecepcion = "";
		}
	 	parametros.comentario = comentario.getValue();
	 	
	 	<%--añadimos los arrays para el informar masivo --%>
		parametros.arrayIdDocs='${arrayIdDocs}';
		parametros.arrayIdSolicitudes='${arrayIdSolicitudes}';
		<%---------------------------------------------- --%>
	 	return parametros;
	 }	
	
	
	var btnGuardar= new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if (validateForm()) {           
				var p = getParametros();
				Ext.Ajax.request({
					url : page.resolveUrl('documentopco/saveInformarSolicitud')
					,params : p
					,method: 'POST'
					,success: function ( result, request ) {
						page.fireEvent(app.event.DONE);
					}
				});
			}
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
		,items:[{items: [ comboEstadosDocumento, adjuntado, ejecutivo, fechaResultado, comboRespuestasSolicitud, fechaEnvio, fechaRecepcion, comentario ]}]
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
	
	function estadoInicial() {
		comboEstadosDocumento.setDisabled(true);
		if ('${solicitud.actor}' == '<fwk:const value="es.pfsgroup.plugin.precontencioso.documento.model.DDTipoActorPCO.GESTORIA" />') {
			adjuntado.setDisabled(true);
			ejecutivo.setDisabled(true);
			fechaEnvio.setDisabled(true);
			fechaRecepcion.setDisabled(true);
		}
		else if (data.esGestoria) {
			adjuntado.setDisabled(true);
			ejecutivo.setDisabled(true);
			fechaRecepcion.setDisabled(true);
			comentario.setDisabled(true);
		}
	}
	estadoInicial();
	
</fwk:page>