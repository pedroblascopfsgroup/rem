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
	var situacion = 'situacion';
	var fechaCrear = 'fechaCreacion';
	var idEntidad = 'idEntidadInformacion';
	var fechaPropuesta = 'fechaPropuesta';
	var idTareaOriginal = 'idTareaOriginal';
	var descripcion = 'descripcion';
	var motivo = 'motivo';
	
	//Tipo de entidad (Cliente | Expediente | Asunto )
	var strTipoEntidad="";
	var descripcionEntidad="";
	strTipoEntidad="Expediente";
	//Nombre y Apellidos del 1er titular del Contrato de pase del expediente
	descripcionEntidad=descripcion;
	
	
	//textfield que va a contener el codigo de la entidad
	var txtEntidad = app.creaLabel('<s:message code="" text="**Codigo" />',idEntidad);

	//textfield que va a contener la descripcion de la entidad
	var txtDescripcionEntidad = app.creaLabel('<s:message code="" text="**Descripcion" />', descripcionEntidad);

	//textfield que va a contener la situacion de la entidad
	var txtSituacion = app.creaLabel('<s:message code="" text="**Situacion" />'	,situacion);
		
	//textfield que va a contener la fecha de creacion de la entidad
	var txtFechaCreacion = app.creaLabel('<s:message code="" text="**fecha Creacion" />', fechaCrear);
		
	var panelDatosEntidad = new Ext.form.FieldSet({
		title:'<s:message code="" text="**Datos del" />'+" "+ strTipoEntidad
		,items:[txtEntidad,txtDescripcionEntidad,txtSituacion,txtFechaCreacion]
		,autoHeight:true
		,autoWidth:true
	});
	
	var motivoSolicitud=app.creaLabel('<s:message code="" text="**Motivo Cancelacion" />',motivo);
	
	var descrTareaOriginal = new Ext.form.TextArea({
		width:250
		,fieldLabel:'<s:message code="" text="**detalle" />'
		,labelStyle:"font-weight:bolder"
		,readOnly:true
		,disabled:true
		,value: '<s:message text="solicitud original" javaScriptEscape="true" />'
	});
	var panelDatosSolicitud = new Ext.form.FieldSet({
		title:'<s:message code="" text="**Solicitud de Cancelacion" />'
		,items:[motivoSolicitud,descrTareaOriginal]
		,autoHeight:true
		,autoWidth:true
	});
	var decision = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="" text="**Acepta Cancelacion" />'
		,labelStyle:labelStyle
		,autoHeight:true
		,name:'aceptada'
	});
	var items = { 
		border : false
		,layout : 'column'
		,viewConfig : { columns : 1 }
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false,width:450 }
		,items : [
			{ items : [
				panelDatosEntidad
				,panelDatosSolicitud
				,decision
				] 
			}
		]
	};

	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.submit({
				eventName : 'cancel'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.CANCEL); } 	
			});
		}
	});
	var btnAceptar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
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
				btnAceptar,	 btnCancelar
		]
	});	
	
	page.add(panelEdicion);
	
	
</fwk:page>
