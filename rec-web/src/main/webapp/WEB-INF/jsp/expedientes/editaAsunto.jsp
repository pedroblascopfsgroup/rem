<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<fwk:page>


	var tipo = new Ext.form.ComboBox({
	    store: [
	            ['valor1',  '**tipo asunto 1' ]
	            ,['valor2', '**tipo asunto 2' ]
	            ]
	    ,displayField:'descripcion'
	    ,mode: 'local'
	    ,triggerAction: 'all'
	    ,emptyText:'----'
	    ,valueField: 'codigo'
	    ,editable : false
		,fieldLabel : '<s:message code="asuntos.tipo" text="**Tipo" />'
	    //,value : 'actual'
	});


	var gestor = new Ext.form.NumberField({
		name : 'gestor'
		,fieldLabel : '<s:message code="asuntos.gestor" text="**Gestor" />'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
	});

	
	var causas = new Ext.form.TextArea({
		fieldLabel : '<s:message code="asuntos.causas" text="**Causas y propuestas" />'
		,height : 60
		,width : 300
	});

	
	var btnAceptar = new Ext.Button({
		text : '<s:message code="app.aceptar" text="**Aceptar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
		}
	});

	var panel = app.creaFieldSet([gestor, causas]);

	var panelPrincipal = new Ext.Panel({
		bodyStyle : 'padding:5px'
		,autoHeight : true
		,items : [panel, app.creaPanelH(btnAceptar)]
	});


	page.add(panelPrincipal);

</fwk:page>