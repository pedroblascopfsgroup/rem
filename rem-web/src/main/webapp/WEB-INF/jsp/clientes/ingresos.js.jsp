<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

	var tipo = app.creaCombo({
		data : <app:dict value="${tiposIngreso}" />
		<app:test id="tipoIngresoCombo" addComa="true" />
		,name : 'ingreso.tipoIngreso'
		,allowBlank : false
		,fieldLabel : '<s:message code="ingresosCliente.tipo" text="**Tipo" />'
		,value : '${ingreso.tipoIngreso.codigo}'
	});

	var periodicidad = app.creaInteger(
        'ingreso.periodicidad'
        ,'<s:message code="ingresosCliente.semanas" text="**Semanas:" />'
		,'${ingreso.periodicidad}'
        ,{autoCreate : {tag: "input", type: "text",maxLength:"4", autocomplete: "off"}, maxLength:4}
     );

	var checkMensual = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="ingresosCliente.mensual" text="**Mensual"/>'
		<app:test id="checkMensual" addComa="true" />
		,name:'checkMensual'
		,handler : function() {
				if(this.getValue()==true) {
					checkAnual.setValue(false);
					periodicidad.setValue('4');
					periodicidad.disable();
				} else {
					periodicidad.enable();
				}
		 }
	});
	
	var checkAnual = new Ext.form.Checkbox({
		fieldLabel:'<s:message code="ingresosCliente.anual" text="**Anual"/>'
		,name:'checkAnual'
		,handler : function() {
				if(this.getValue()==true) {
					checkMensual.setValue(false);
					periodicidad.setValue('52');
					periodicidad.disable();
				} else {
					periodicidad.enable();
				}
		 }
	});
	
	var bruto = app.creaNumber('ingreso.ingNetoBruto','<s:message code="ingresosCliente.bruto" text="**Bruto" />','${ingreso.ingNetoBruto}',{
		maxValue:99999999.99
		,maxLength:10
		,autoCreate : {tag: "input", type: "text",maxLength:"10", autocomplete: "off"}
	});

	var validarForm = function(){
		if (tipo.getValue() == null || tipo.getValue()==''){
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="ingreso.form.tipoNulo"/>');	
			return false;
		} else if (periodicidad==null || (periodicidad.getValue()==='')){
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="ingreso.form.periodicidadNulo"/>');
			return false;
		} else if (bruto==null || (bruto.getValue()==='')){
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="ingreso.form.brutoNulo"/>');
			return false;
		}		
		return true;
	}
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		<app:test id="btnGuardarIngreso" addComa="true" />
		,iconCls : 'icon_ok'
		,handler : function(){
			if (validarForm()){		
				periodicidad.enable();
				page.submit({
					eventName : 'update'
					,formPanel : panelEdicion
					,success : function(){ page.fireEvent(app.event.DONE) }
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


	if(periodicidad.getValue()==4) {
		checkMensual.checked=true;
		periodicidad.disable();
	} else if(periodicidad.getValue()==52) {
		checkAnual.checked=true;
		periodicidad.disable();
	}


	labelMensual = new Ext.form.Label({
	   	text:'<s:message code="ingresosCliente.mensual" text="**Mensual" />'
		,style:'font-size:11; padding:15px'
	});
	labelAnual = new Ext.form.Label({
	   	text:'<s:message code="ingresosCliente.anual" text="**Anual" />'
		,style:'font-size:11; padding:15px'
	});
	labelPeriodicidad = new Ext.form.Label({
	   	text:'<s:message code="ingresosCliente.semanas" text="**Semanas" />'
		,style:'font-size:11; padding:15px'
	});

	var checksPanel = {
		xtype:'fieldset'
		,autoHeight:'true'
		,border:false
		,layout : 'table'
		,style:'padding:0px'
		,layoutConfig:{ columns:4 }
        ,items: [labelMensual, checkMensual, labelAnual, checkAnual]
     };

	var periodicidadPanel = {
		xtype:'fieldset'
		,autoHeight:'true'
		,border:false
		,style:'padding:0px'
		,layout : 'table'
		,layoutConfig:{ columns:2 }
        ,items: [labelPeriodicidad, periodicidad]
     };

	var periodicidadPanel = new Ext.form.FieldSet({
		title:'<s:message code="ingresosCliente.periodicidad" text="**Periodicidad"/>'
		,xtype:'fieldset'
		,border:true
		,style:'padding:0px'
		,autoHeight:true
		//,height:110
		,defaults : {border:false }
		,items:[
			{items:checksPanel}
			,{items:periodicidadPanel}
		]
	});

	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,autoWidth:true
		,bodyStyle:'padding:5px;'
		,border : false
		,items : [
			{
				autoHeight:true
				,border:false
				,labelWidth:50
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
				,items:[{
						layout:'form'
						,width:350
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[tipo, periodicidadPanel, bruto]
					}
				]
			}
		]
		,bbar : [
			btnGuardar,btnCancelar
		]
	});

	page.add(panelEdicion);
	
</fwk:page>
