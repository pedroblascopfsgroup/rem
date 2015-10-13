<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>


<fwk:page>

	var labelStyle='font-weight:bolder;width:150px'

	var tipoActuacionAcuerdo = app.creaCombo({
		data: <app:dict value="${tiposAA}" />
		<app:test id="editTipoActuacionAcuerdo" addComa="true" />
		,name: 'actuaciones.ddTipoActuacionAcuerdo'
		,allowBlank: false
		,fieldLabel: '<s:message code="acuerdos.actuacionesRealizadas.tipoact" text="**Tipo Actuación Acuerdo" />'
		,value: '${actuacion.ddTipoActuacionAcuerdo.codigo}'
		,labelStyle:labelStyle
	});

	var tipoResultadoAcuerdo = app.creaCombo({
		data: <app:dict value="${tiposResultados}" />
		<app:test id="editTipoResultadoAcuerdo" addComa="true" />
		,name: 'actuaciones.ddResultadoAcuerdoActuacion'
		,allowBlank: false
		,fieldLabel: '<s:message code="acuerdos.actuacionesRealizadas.tipores" text="**Tipo Resultado Acuerdo" />'
		,value: '${actuacion.ddResultadoAcuerdoActuacion.codigo}'
		,labelStyle:labelStyle
	});

	var tipoAAA = app.creaCombo({
		data: <app:dict value="${tiposAAA}" />
		<app:test id="editTipoAAA" addComa="true" />
		,name: 'actuaciones.tipoAyudaActuacion'
		,allowBlank: false
		,fieldLabel: '<s:message code="acuerdos.actuacionesRealizadas.tipoaaa" text="**Tipo Actitud Actuación" />'
		,value: '${actuacion.tipoAyudaActuacion.codigo}'
		,labelStyle:labelStyle
	});

	var fechaActuacion = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="acuerdos.actuacionesRealizadas.fechaact" text="**Fecha Actuación" />'
		<app:test id="editFechaActuacion" addComa="true" />
		,name:'actuaciones.fechaActuacion'
        ,maxValue : new Date()
		,allowBlank: false
		,style:'margin:0px'
		,value:'<fwk:date value="${actuacion.fechaActuacion}" />'
		,labelStyle:labelStyle
	});

	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="acuerdos.actuacionesRealizadas.observaciones" text="**Observaciones" />'
		<app:test id="editObservacionesField" addComa="true" />
		,name: 'actuaciones.observaciones'
		,value:'<s:message javaScriptEscape="true" text="${actuacion.observaciones}" />'
		,width: 200 
		, maxLength: 250
		,allowBlank: false
		,labelStyle:labelStyle
	});
	var tituloobservaciones = new Ext.form.Label({
   	text:'<s:message code="acuerdos.actuacionesRealizadas.observaciones" text="**Observaciones" />'
	,style:labelStyle
	}); 
	var observaciones = new Ext.form.TextArea({
		width:530
		,height:220
		,maxLength:250
		,name: 'actuaciones.observaciones'
		,value:'<s:message javaScriptEscape="true" text="${actuacion.observaciones}" />'
		,allowBlank: false
		,labelStyle:labelStyle
		<app:test id="editObservacionesTitulos" addComa="true"/>	
	});

	var idExpedienteH = new Ext.form.Hidden({name:'idExpediente', value :'${expediente.id}'});
	var idActuacionH = new Ext.form.Hidden({name:'actuaciones.id', value :'${actuacion.id}'});

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE) }
			});
		}
	});

	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		//,width:500
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				//,layout : 'column'
				//,viewConfig : { columns : 2 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false}
				,items : [
					{ items : [ 
							fechaActuacion
							,tipoActuacionAcuerdo
							,tipoResultadoAcuerdo
							,tipoAAA
							,tituloobservaciones
							,{items:observaciones,border:false,style:'margin-top:5px'}
							,idExpedienteH
							,idActuacionH 
					]
                      ,style : 'margin-right:10px' }
					
				]
			}
		]
		,bbar : [
			btnGuardar,btnCancelar
		]
	});

	page.add(panelEdicion);

</fwk:page>
