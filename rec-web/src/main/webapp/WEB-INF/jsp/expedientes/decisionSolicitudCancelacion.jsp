<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>

	var labelStyle='font-weight:bolder;width:130';
	var estiloTitulo = 'vertical-align:center';
	var situacion = '${expediente.estadoItinerario.descripcion}';
	var fechaCrear = '<fwk:date value="${expediente.auditoria.fechaCrear}" />';
	var idEntidad = '${expediente.id}';
	var idTareaOriginal = 'idTareaOriginal';
	var descripcion = '<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />';
	
	//Tipo de entidad (Cliente | Expediente | Asunto )
	var strTipoEntidad="";
	var descripcionEntidad="";
	strTipoEntidad="Expediente";
	//Nombre y Apellidos del 1er titular del Contrato de pase del expediente
	descripcionEntidad=descripcion;
	
	
	//textfield que va a contener el codigo de la entidad
	var txtEntidad = app.creaLabel('<s:message code="expedientes.solicitudCancelacion.codigo" text="**Codigo" />',idEntidad);

	//textfield que va a contener la descripcion de la entidad
	var txtDescripcionEntidad = app.creaLabel('<s:message code="expedientes.solicitudCancelacion.descripcion" text="**Descripcion" />', descripcionEntidad);

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="expedientes.solicitudCancelacion.situacion" text="**Situacion" />'	,situacion);
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaCreacion = app.creaLabel('<s:message code="expedientes.solicitudCancelacion.fcreacion" text="**fecha Creacion" />', fechaCrear);
		
	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="expedientes.solicitudCancelacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,items:[txtEntidad,txtDescripcionEntidad,txtSituacion,txtFechaCreacion]
		,autoHeight:true
		,autoWidth:true
	});
	
	
	var descrTareaOriginal = new Ext.form.TextArea({
		width:250
		,fieldLabel:'<s:message code="expedientes.solicitudCancelacion.detalle" text="**detalle" />'
		,labelStyle:"font-weight:bolder"
		,readOnly:true
		,disabled:true
		,value: '<s:message text="${solicitud.detalle}" javaScriptEscape="true" />'
	});
	var panelDatosSolicitud = new Ext.form.FieldSet({
		title:'<s:message code="expedientes.solicitudCancelacion" text="**Solicitud de Cancelacion" />'
		,items:[descrTareaOriginal]
		,autoHeight:true
		,autoWidth:true
	});
	
	<c:if test="${!espera}">	
	var decision = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="expedientes.solicitudCancelacion.acepta" text="**Acepta Cancelacion" />'
		,labelStyle:labelStyle
		,autoHeight:true
		,width:100
		,name:'aceptada'
	});
	</c:if>

	var items = { 
		border : false
		,layout : 'column'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false,width:450 }
		,items : [
			{ items : [
				panelDatosEntidad
				,panelDatosSolicitud
				<c:if test="${!espera}">	
				,decision
				</c:if>
				] 
			}
		]
	};

	<c:if test="${!espera}">	
		var btnCancelar= new Ext.Button({
			text : '<s:message code="app.cancelar" text="**Cancelar" />'
			,iconCls : 'icon_cancel'
			,handler : function(){
				 	page.fireEvent(app.event.CANCEL);  	
			
				}
		});
	</c:if>

	var btnAceptar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			<c:if test="${!espera}">	
				page.webflow({
					flow:'expedientes/enviarDecisionSolicitudCancelacion'
					,eventName : 'update'
					,params: {decision:decision.getValue(), idExpediente:${expediente.id} ,idSolicitud:${solicitud.id}}
					,success : function(){ page.fireEvent(app.event.DONE) }
				});
			</c:if>
			<c:if test="${espera}">	
				page.fireEvent(app.event.CANCEL);  	
			</c:if>
			
		}
	});

	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle : 'padding:5px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'anchor'
				//,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
				,items : items
			}
		]
		,bbar : [
				btnAceptar
				<c:if test="${!espera}">	
				,	 btnCancelar
				</c:if>
		]
	});	
	
	page.add(panelEdicion);
	
	
</fwk:page>
