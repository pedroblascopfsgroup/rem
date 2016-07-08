<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>
	var labelStyle='font-weight:bolder;'
	var tipo =new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="bienesCliente.tipo" text="**Tipo" />'
		,value : '${bien.tipoBien.descripcion}'
		,name : 'bien.tipoBien'
		,labelStyle:labelStyle
	});

		
	var poblacion = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="bienesCliente.poblacion" text="**Poblacion" />'
		,value : '${bien.poblacion}'
		,name : 'bien.poblacion'
		,labelStyle:labelStyle
	});
	var refCatastral = app.crearTextArea( 
		'<s:message code="bienesCliente.refcatastral" text="**Ref. catastral" />' 
		, '<s:message text="${bien.referenciaCatastral}" javaScriptEscape="true" />'
		,true
		,labelStyle
		,'bien.referenciaCatastral'
		
	);
	
	var datosRegistrales = app.crearTextArea(
		'<s:message code="bienesCliente.datosRegistrales" text="**Datos registrales" />' 
		, '<s:message text="${bien.datosRegistrales}" javaScriptEscape="true" />'
		,true
		,labelStyle
		,'bien.datosRegistrales'
	);
	
	var part = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="bienesCliente.participacion" text="**Participacion" />'
		,value :  '${bien.participacion}'
		,name : 'bien.participacion'
		,labelStyle:labelStyle
	});
	
	var valor = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="bienesCliente.valorActual" text="**Valor actual" />'
		,value :  '${bien.valorActual}'
		,name : 'bien.valorActual'
		,labelStyle:labelStyle
	});
	
	var cargas = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="bienesCliente.cargas" text="**Cargas" />'
		,value :  '${bien.importeCargas}'
		,name : 'bien.importeCargas'
		,labelStyle:labelStyle
	});
	var fechaV = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="bienesCliente.fechaverificacion" text="**Fecha Verificacion" />'
		,value : '<fwk:date value="${bien.fechaVerificacion}" />'
		,name : 'bien.fechaVerificacion'
		,labelStyle:labelStyle
	});
	
	var superficie = new Ext.ux.form.StaticTextField({
		fieldLabel : '<s:message code="bienesCliente.superficie" text="**Superfice en m2" />'
		,value :  '${bien.superficie}'
		,name : 'bien.superficie'
		,labelStyle:labelStyle
	});	
	
	var descripcion= app.crearTextArea(
		'<s:message code="bienesCliente.descripcion" text="**descripcion" />'
		,'<s:message text="${bien.descripcionBien}" javaScriptEscape="true" />'
		,true
		,labelStyle
		,'bien.descripcionBien'
		, {
			maxLength:250 <app:test id="descripcionBien" addComa="true" />
			
		}
	);

	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function() {
			 page.fireEvent(app.event.DONE);
		}
	});

	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,border : false
		,items : [
			 { xtype : 'errorList', id:'errL' }
			,{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:20px;'
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[tipo, part,valor, cargas , descripcion,{html:'&nbsp;',border:false},{html:'&nbsp;',border:false} ]
						,columnWidth:.5
					},{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,columnWidth:.5
						,items:[ refCatastral, superficie ,poblacion, datosRegistrales,fechaV]
					}
				]
			}
		]
		,bbar : [
			btnGuardar
		]
	});


	page.add(panelEdicion);
	
</fwk:page>
