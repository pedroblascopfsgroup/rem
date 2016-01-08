<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	var labelStyle='font-weight:bolder;width:150px'

	var ctac = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.cajamar.bienes.ctac" text="**Cuenta asociada al pr&oacute;stamo" />'
		<app:test id="ctac" addComa="true" />
		, allowNegative:false
		, allowDecimals:false
		, value:''
		, name:'cuenta'
		, labelStyle:labelStyle
		, maxValue:999999999999999999
		, autoCreate : {tag: "input", type: "text",maxLength:"18", autocomplete: "off"}
		, allowBlank: false
	});

	var contacto = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.cajamar.bienes.contacto" text="**Persona de contacto" />'
		, name:'persona'
		, labelStyle:labelStyle
		, allowBlank: false
		, maxLength: 30
		, grow: true
		, growMin: 133
		, growMax: 500		
	});

	var nroTfno = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.cajamar.bienes.telefono" text="**Tel&oacute;fono" />'
		<app:test id="nroTelefono" addComa="true" />
		,allowNegative:false
		,allowDecimals:false
		,value:''
		,name:'telefono'
		,labelStyle:labelStyle
		,maxValue:99999999999999
		,autoCreate : {tag: "input", type: "text",maxLength:"14", autocomplete: "off"}
		, allowBlank: false
	});

	var tituloobservaciones = new Ext.form.Label({
   		text:'<s:message code="plugin.cajamar.bienes.observaciones" text="**Observaciones" />'
	,style:labelStyle
	}); 
	var observaciones = new Ext.form.TextArea({
		fieldLabel:'<s:message code="plugin.cajamar.bienes.observaciones" text="**Observaciones" />'
		<app:test id="observaciones" addComa="true" />
		,name: 'observaciones'
		,width:645
		,height: 150
		,maxLength: 500
		,labelStyle:labelStyle
	});

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		<app:test id="btnGuardar" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function(){
			if(!ctac.validate()) {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.cajamar.bienes.ctac.error"/>');
			}
			else if(!contacto.validate()) {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.cajamar.bienes.contacto.error"/>');
			}
			else if(!nroTfno.validate()) {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.cajamar.bienes.telefono.error"/>');
			}
			else if (!observaciones.validate()) {
				Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.cajamar.bienes.observaciones.error"/>');
			}				
			else {
				Ext.Ajax.request({
					url : page.resolveUrl('serviciosonlinecajamar/solicitarTasacion'), 
					params : {idBien: ${idBien}
						, cuenta: ctac.getValue()
						, persona: contacto.getValue()
						, telefono: nroTfno.getValue()
						, observaciones: observaciones.getValue()
					},
					method: 'POST',
					success: function ( result, request ) {
					
						var r = Ext.util.JSON.decode(result.responseText)
						if(r.solicitudRealizada) {
							page.fireEvent(app.event.DONE);
						}
						else {
							Ext.Msg.show({
								title:'Operaci&oacute;n no disponible',
								msg: '<s:message code="plugin.cajamarbienes.tasacion.ko"/>',
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.INFO
							});
						}	
					}
				});
			}
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
		,width:500
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
					{ items : [ctac
								, contacto
								, nroTfno
								, tituloobservaciones
								, {items:observaciones,border:false,style:'margin-top:5px'} 
						], style : 'margin-right:10px' }
					
				]
			}
		]
		,bbar : [
			btnGuardar,btnCancelar
		]
	});

	page.add(panelEdicion);

</fwk:page>
