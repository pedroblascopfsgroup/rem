<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
	
	var labelStyle='font-weight:bolder;width:150';
	var style='margin:0px';
	var id=new Ext.form.Hidden({name:'embargoProcedimiento.id', value :'${embargoProcedimiento.id}'});
	
	var fechaSolicitud = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.marcadoBien.fechaSolicitud" text="**fechaSolicitud" />'
		,name:'embargoProcedimiento.fechaSolicitud'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${embargoProcedimiento.fechaSolicitud}" />'
	});
	
	var fechaDecreto = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.marcadoBien.fechaDecreto" text="**fechaDecreto" />'
		,name:'embargoProcedimiento.fechaDecreto'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${embargoProcedimiento.fechaDecreto}" />'
	});
	
	var fechaRegistro = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.marcadoBien.fechaRegistro" text="**fechaRegistro" />'
		,name:'embargoProcedimiento.fechaRegistro'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${embargoProcedimiento.fechaRegistro}" />'
	});
	
	var fechaAdjudicacion = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.marcadoBien.fecha" text="**fechaAdjudicacion" />'
		,name:'embargoProcedimiento.fechaAdjudicacion'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${embargoProcedimiento.fechaAdjudicacion}" />'
	});
	var fechaAval = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.marcadoBien.fecha" text="**fechaAval" />'
		,name:'embargoProcedimiento.fechaAval'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${embargoProcedimiento.fechaAval}" />'
	});
	var fechaTasacion = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="procedimiento.marcadoBien.fecha" text="**fechaTasacion" />'
		,name:'embargoProcedimiento.fechaTasacion'
		,labelStyle:labelStyle
		,style:style
		,value: '<fwk:date value="${embargoProcedimiento.fechaTasacion}" />'
	});
	
	var importeAval  = app.creaNumber('embargoProcedimiento.importeAval',
		'<s:message code="procedimiento.marcadoBien.importe" text="**Importe Pago" />',
		'${embargoProcedimiento.importeAval}',
		{	
			labelStyle:labelStyle
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,autoCreate : {tag: "input", type: "text",maxLength:"13", autocomplete: "off"}
		}
	);
	
	//importeAval.setValue('${embargoProcedimiento.importeAval}');
	
	var importeValor  = app.creaNumber('embargoProcedimiento.importeValor',
		'<s:message code="procedimiento.marcadoBien.importeValor" text="**Importe Pago" />',
		'${embargoProcedimiento.importeValor}',
		{	
			labelStyle:labelStyle
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,autoCreate : {tag: "input", type: "text",maxLength:"13", autocomplete: "off"}
		}
	);
	
	//importeValor.setValue('${embargoProcedimiento.importeValor}');
	
	var importeTasacion  = app.creaNumber('embargoProcedimiento.importeTasacion',
		'<s:message code="procedimiento.marcadoBien.importe" text="**Importe Pago" />',
		'${embargoProcedimiento.importeTasacion}',
		{	
			labelStyle:labelStyle
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,autoCreate : {tag: "input", type: "text",maxLength:"13", autocomplete: "off"}
		}
	);
	
	//importeTasacion.setValue('${embargoProcedimiento.importeTasacion}');
	
	var importeAdjudicacion  = app.creaNumber('embargoProcedimiento.importeAdjudicacion',
		'<s:message code="procedimiento.marcadoBien.importe" text="**Importe Pago" />',
		'${embargoProcedimiento.importeAdjudicacion}',
		{	
			labelStyle:labelStyle
			,allowDecimals: true
			,allowNegative: false
			,maxLength:13
			,autoCreate : {tag: "input", type: "text",maxLength:"13", autocomplete: "off"}
			//,value:'${embargoProcedimiento.importeAdjudicacion}'
		}
	);
	
	//importeAdjudicacion.setValue('${embargoProcedimiento.importeAdjudicacion}');
	
	var letra = new Ext.form.TextField({
		labelStyle:labelStyle
		,style:style
		,name:'embargoProcedimiento.letra'
		,fieldLabel:'<s:message code="procedimiento.marcadoBien.letra" text="**Letra" />'
		,value:'${embargoProcedimiento.letra}'
	});
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'update'
				,formPanel : panelEdicion
				,params:{id:'${embargoProcedimiento.id }',idBien:'${idBien}',idProcedimiento:'${idProcedimiento}'}
				,success : function(){ page.fireEvent(app.event.DONE) }
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
					,{ items : [fechaSolicitud,fechaDecreto,fechaRegistro,importeValor,letra,{html:'&nbsp;',border:false,height:120}]}
				]
			}
		]
		,bbar : [
			btnGuardar, btnCancelar
		]
	});
	page.add(panelEdicion);
</fwk:page>
