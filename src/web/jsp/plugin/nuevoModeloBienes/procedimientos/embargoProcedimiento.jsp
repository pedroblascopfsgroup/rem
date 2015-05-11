<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	var labelStyle='font-weight:bolder;width:110';
	var labelStyle2='font-weight:bolder;width:100';
	var style='margin:0px';
	var id=new Ext.form.Hidden({name:'id', value :'${id}'});
	
	var fechaSolicitud = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.procedimiento.marcadoBien.certificacionCargas" text="**Certificación de cargas" />'
		,name:'fechaSolicitud'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${fechaSolicitud}" />'
	});
	
	var fechaDecreto = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.marcadoBien.fechaDecreto" text="**fechaDecreto" />'
		,name:'fechaDecreto'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${fechaDecreto}" />'
	});
	
	var fechaDenegacion = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="plugin.nuevoModeloBienes.procedimiento.marcadoBien.fechaDenegacion" text="**fechaDenegacion" />'
		,name:'fechaDenegacion'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${fechaDenegacion}" />'
	});
	
	var fechaRegistro = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.marcadoBien.fechaRegistro" text="**fechaRegistro" />'
		,name:'fechaRegistro'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${fechaRegistro}" />'
	});
	
	var fechaAdjudicacion = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.marcadoBien.fecha" text="**fechaAdjudicacion" />'
		,name:'fechaAdjudicacion'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${fechaAdjudicacion}" />'
	});
	var fechaAval = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.marcadoBien.fecha" text="**fechaAval" />'
		,name:'fechaAval'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${fechaAval}" />'
	});
	var fechaTasacion = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.marcadoBien.fecha" text="**fechaTasacion" />'
		,name:'fechaTasacion'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${fechaTasacion}" />'
	});
	
	var importeAval  = app.creaNumber('importeAval',
		'<s:message code="procedimiento.marcadoBien.importe" text="**Importe Pago" />',
		'${importeAval}',
		{	
			labelStyle:labelStyle
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,autoCreate : {tag: "input", type: "text",maxLength:"13", autocomplete: "off"}
		}
	);
	
	var importeValor  = app.creaNumber('importeValor',
		'<s:message code="procedimiento.marcadoBien.importeValor" text="**Importe Pago" />',
		'${importeValor}',
		{	
			labelStyle:labelStyle2
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,autoCreate : {tag: "input", type: "text",maxLength:"13", autocomplete: "off"}
		}
	);
	
	var importeTasacion  = app.creaNumber('importeTasacion',
		'<s:message code="procedimiento.marcadoBien.importe" text="**Importe Pago" />',
		'${importeTasacion}',
		{	
			labelStyle:labelStyle
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,autoCreate : {tag: "input", type: "text",maxLength:"13", autocomplete: "off"}
		}
	);
	
	var importeAdjudicacion  = app.creaNumber('importeAdjudicacion',
		'<s:message code="procedimiento.marcadoBien.importe" text="**Importe Pago" />',
		'${importeAdjudicacion}',
		{	
			labelStyle:labelStyle
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,autoCreate : {tag: "input", type: "text",maxLength:"13", autocomplete: "off"}
		}
	);
	
	var letra = new Ext.form.TextField({
		labelStyle:labelStyle2
		,style:style
		,name:'letra'
		,fieldLabel:'<s:message code="procedimiento.marcadoBien.letra" text="**Letra" />'
		,value:'${letra}'
	});
	
	var getParametros = function() {
	 	var p = {};
	 	
	 	if (fechaAdjudicacion.getValue()){
	 		p.fechaAdjudicacion = fechaAdjudicacion.getValue().format('d/m/Y');
	 	}
	 	if (fechaDecreto.getValue()){
	 		p.fechaDecreto = fechaDecreto.getValue().format('d/m/Y');
	 	}
	 	if (fechaDenegacion.getValue()){
	 		p.fechaDenegacion = fechaDenegacion.getValue().format('d/m/Y');
	 	}
	 	if (fechaRegistro.getValue()){
	 		p.fechaRegistro = fechaRegistro.getValue().format('d/m/Y');
	 	}
	 	if (fechaSolicitud.getValue()){
	 		p.fechaSolicitud = fechaSolicitud.getValue().format('d/m/Y');
	 	}
	 	if (fechaAval.getValue()){
	 		p.fechaAval = fechaAval.getValue().format('d/m/Y');
	 	}
	 	if (fechaTasacion.getValue()){
	 		p.fechaTasacion = fechaTasacion.getValue().format('d/m/Y');
	 	}
	 		 	
	 	p.importeValor = importeValor.getValue();
	 	p.importeAval = importeAval.getValue();
	 	p.importeTasacion = importeTasacion.getValue();
	 	p.importeAdjudicacion = importeAdjudicacion.getValue();
	 	p.letra = letra.getValue();
	 	p.idEmbargo = '${id}';
	 	p.idBien = '${idBien}';
	 	p.idProcedimiento = '${idProcedimiento}';
	 	
	 	return p;
	}
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			var p = getParametros();
			Ext.Ajax.request({
				url : page.resolveUrl('editbien/saveEmbargo') 
				,params: p
				,method: 'POST'
				,success: function(){ page.fireEvent(app.event.DONE) }
			});
		}
	});
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.fireEvent(app.event.CANCEL);
		}
	});
	var fsAval = new Ext.form.FieldSet({
		autoHeight:'true'
		,width:300
		,title:'<s:message code="procedimiento.marcadoBien.aval" text="**Aval" />'
		,items:[importeAval,fechaAval]
	});
	var fsTasacion = new Ext.form.FieldSet({
		autoHeight:'true'
		,width:300
		,title:'<s:message code="procedimiento.marcadoBien.tasacion" text="**Tasacion" />'
		,items:[importeTasacion,fechaTasacion]
	});
	
	var fsAdjudicacion = new Ext.form.FieldSet({
		autoHeight:'true'
		,width:300
		,title:'<s:message code="procedimiento.marcadoBien.adjudicacion" text="**Adjudicacion" />'
		,items:[importeAdjudicacion,fechaAdjudicacion]
	});

	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
			{ xtype : 'errorList', id:'errL' }
			,{ 
				border : false
				,layout : 'table'
				,viewConfig : { columns : 2 }
				,defaults :  {layout:'form', autoHeight : true, border : false }
				,items : [
					{ items : [fsAval,fsTasacion,fsAdjudicacion], style : 'margin-right:20px' }
					,{ items : [fechaSolicitud,fechaDecreto,fechaRegistro,fechaDenegacion,importeValor,letra,{html:'&nbsp;',border:false,height:120}]}
				]
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});
	page.add(panelEdicion);
</fwk:page>
