<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	var labelStyle='font-weight:bolder;width:300px';

	var txtNumIntervalos = new Ext.form.NumberField({
		name: 'parametrizacion.valor'
		,value: '${parametrizacion.valor}'
		,allowNegative: false
		,allowDecimals: false
		,autoCreate: {tag: 'input', type: 'text', maxLength:'3', autocomplete: 'off'}
		,fieldLabel: '<s:message code="metricas.indicadores.numIntervalos" text="**Núm. de intervalos para generar el indicador" />'
		,maxValue: 100
		,minValue: 1
		,width: 50
		,maxText: '<s:message code="metricas.indicadores.numIntervalos.error" text="**El intervalo no debe ser mayor a 100" arguments="100" />'
		,labelStyle: labelStyle
	});

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

	var btnCancelar = new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls:'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});

	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
		
			 { xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'column'
				//,viewConfig : { columns : 2 }
				,defaults :  {xtype : 'fieldset', autoHeight : true, border : false,width:520 }
				,items : [
					{ items : [ txtNumIntervalos ], style : 'margin-right:10px' }
				]
			}
		]
		,bbar : [ btnGuardar,btnCancelar ]
	});

	page.add(panelEdicion);

</fwk:page>
