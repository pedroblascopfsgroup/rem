<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>
	var labelStyle='font-weight:bolder;width:150';
	
	var situacion = '${expediente.estadoItinerario.descripcion}';
	var fechaVenc = '<fwk:date value="${expediente.fechaVencimiento}" />';
	var idEntidad = '${expediente.id}';
	var idTipoEntidad = 'idTipoEntidadInformacion';
	var idEntidadInformacion = new Ext.form.Hidden({name:'idEntidadInformacion', value :idEntidad}) ;
	var esSupervisor = ${esSupervisor};

	strTipoEntidad="Expediente";
	
	//Nombre y Apellidos del 1er titular del Contrato de pase del expediente
	descripcionEntidad='<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />';
	
	
	//textfield que va a contener el codigo de la entidad
	var txtEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.codigoentidad" text="**Codigo" />', idEntidad,{labelStyle:labelStyle});

	//textfield que va a contener la descripcion de la entidad
	var txtDescripcionEntidad = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.descripcionentidad" text="**Descripcion" />', descripcionEntidad,{labelStyle:labelStyle});

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.situacion" text="**Situacion" />'	,situacion,{labelStyle:labelStyle});
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaVenc = app.creaLabel('<s:message code="comunicaciones.generarnotificacion.fechavencimiento" text="**fecha Vencimiento" />', fechaVenc,{labelStyle:labelStyle});
		
	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="comunicaciones.generarnotificacion.datosentidad" text="**Datos del" />'+" "+ strTipoEntidad
		,bodyStyle:'padding:5px'
		,items:[txtEntidad,txtDescripcionEntidad,txtSituacion,txtFechaVenc]
		,autoHeight:true
	});
	
	var titulodescripcion = new Ext.form.Label({
		   	text:'<s:message code="solicitarprorroga.detalle" text="**Detalle" />'
			,style:'font-weight:bolder; font-size:11',bodyStyle:'padding:5px'
			});	
	var descripcion = new Ext.form.TextArea({
		width:560
		,hideLabel:true
		,height:150
		,maxLength:3500
		,fieldLabel:'<s:message code="solicitarprorroga.detalle" text="**Detalle" />'
		,labelStyle:"font-weight:bolder"
		,name:'detalle'
		
	});
	var arr = [panelDatosEntidad,titulodescripcion,descripcion,idEntidadInformacion];

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			 	page.fireEvent(app.event.CANCEL);  	
			}
	});
	
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			if (descripcion.validate() && descripcion.getValue()!=null && descripcion.getValue()!=''){
				page.webflow({
					flow:'expedientes/enviarSolicitudCancelacion'
					,formPanel : panelEdicion
					,params: {id:idEntidad, detalle:descripcion.getValue(), esSupervisor:esSupervisor}
					,success : function(){ page.fireEvent(app.event.DONE) }
				});
			}else{
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expediente.solicitudCancelacion.detalleNulo"/>')
			}
		}
	});
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,border : false
		,bodyStyle:'padding:5px'
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,autoHeight:true
				,xtype:'fieldset'
				,items : arr
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});	
	page.add(panelEdicion);
	
	
</fwk:page>	