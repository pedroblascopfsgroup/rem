<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<fwk:page>


	var procedimientos = {procedimientos :[	
		{campo1: 'dato1-1', campo2 : 'dato 1-2'}
		,{campo1: 'dato2-1', campo2 : 'dato 2-2'}
	]};

	var procedimientosStore = new Ext.data.JsonStore({
		data : procedimientos
		,root : 'procedimientos'
		,fields : ['campo1', 'campo2']
	});

	var procedimientosCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="clavegrid.campo1" text="**campo1"/>', dataIndex : 'campo1' }
		,{header : '<s:message code="clavegrid.campo2" text="**campo2"/>', dataIndex : 'campo2' }
	]);

	var procedimientosGrid = new Ext.grid.GridPanel({
		title : '<s:message code="procedimientos.grid.titulo" text="**Procedimientos" />'
		,store : procedimientosStore
		,cm : procedimientosCm
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,width : 700
		,height : 200
	});

	var tipo = new Ext.form.ComboBox({
	    store: [
	            ['valor1',  '**tipo procedimiento 1' ]
	            ,['valor2', '**tipo procedimiento 2' ]
	            ]
	    ,displayField:'descripcion'
	    ,mode: 'local'
	    ,triggerAction: 'all'
	    ,emptyText:'----'
	    ,valueField: 'codigo'
	    ,editable : false
		,fieldLabel : '<s:message code="procedimientos.tipo" text="**Tipo" />'
	    //,value : 'actual'
	});


	var recuperabilidad = new Ext.form.NumberField({
		name : 'recuperabilidad'
		,fieldLabel : '<s:message code="procedimientos.recuperabilidad" text="**Recuperabilidad" />'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
	});

	var plazo = new Ext.form.NumberField({
		name : 'plazo'
		,fieldLabel : '<s:message code="procedimientos.plazo" text="**Plazo (meses)" />'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
	});


	var causas = new Ext.form.TextArea({
		fieldLabel : '<s:message code="procedimientos.causas" text="**Causas y propuestas" />'
		,height : 60
		,width : 300
	});

	
	var btnAceptar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
		}
	});
	var btnBorrar = new Ext.Button({
		text : '<s:message code="procedimientos.boton.borrar" text="**Borrar este procedimiento" />'
		,iconCls : 'icon_menos'
		,handler : function(){
		}
	});

	var panel = app.creaFieldSet([tipo, recuperabilidad, plazo, causas]);

	var panelPrincipal = new Ext.Panel({
		bodyStyle : 'padding:5px'
		,autoHeight : true
		,items : [procedimientosGrid, panel, app.creaPanelH(btnAceptar, btnBorrar)]
	});


	page.add(panelPrincipal);

</fwk:page>