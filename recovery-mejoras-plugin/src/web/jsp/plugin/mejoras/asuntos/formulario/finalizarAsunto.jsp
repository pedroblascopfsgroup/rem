<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:page>
	var idAsunto = new Ext.form.Hidden({name:'idAsunto', value :'${idAsunto}'}) ;
	
	var dictCausasFinalizar = <app:dict value="${causaDecisionFinalizar}" />
	
	//store generico de combo diccionario
	var optionsCausasStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictCausasFinalizar
	});
	
	var motivoFinalizacion = new Ext.form.ComboBox({
				store:optionsCausasStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,id:'motivoFinalizacion'
				,name:'motivoFinalizacion'
				,mode: 'local'
				,editable:false
				,triggerAction: 'all'
				,labelWidth:80
				,labelStyle:'font-weight:bolder;width:50'
				,fieldLabel : '<s:message code="plugin.mejoras.asunto.finalizarAsunto.causa" text="**Causa" />'				
	});
	
	<%--motivoFinalizacion.on('select',function(){
		alert(motivoFinalizacion.getValue());
	}); --%>
	var labelStyle='font-weight:bolder;width:150';
	var labelStyle2='font-weight:bolder;width:50';
	
	var titulodescripcion = new Ext.form.Label({
   	text:'<s:message code="plugin.mejoras.asunto.finalizarAsunto.observaciones" text="**Observaciones" />'
	,style:'font-weight:bolder; font-size:11'
	}); 
	
	//Text Area
	var descripcion = new Ext.form.TextArea({
		width:600
		,hideLabel: true
		,height:150
		,maxLength:3500
		,name : 'observaciones'
		,allowBlank : false
		<app:test id="campoParaComunicacion" addComa="true"/>
	});

	//date chooser 
	var fecha = new Ext.ux.form.XDateField({
		fieldLabel:'<s:message code="generartarea.fecha" text="**Fecha" />'		
		,labelWidth:80
		,name : 'fechaFinalizacion'
		,labelStyle:labelStyle2
		,disabled :false
        ,value:''
		<app:test id="campoFechaRespuesta" addComa="true"/>
	});
	
	var cumplidoData = <app:dict value="${ddSiNo}" />
	//No ocultar para los tipo ACUERDO, lo negamos porque comprueba si el asunto es acuerdo.
	var ocultarCumplidoYNegarBlanco = ${!esAsuntoAcuerdo}
	
	var cumplidoStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : cumplidoData
	});
	
	var cumplidoSelect = new Ext.form.ComboBox({
				store:cumplidoStore
				,hiddenName:'cumplidoSelect'
				,displayField:'descripcion'
				,valueField:'codigo'
				,id:'cumplidoSelect'
				,name:'cumplidoSelect'
				,mode: 'local'
				,editable:false
				,triggerAction: 'all'
				,labelWidth:20
				,labelStyle:labelStyle2
				,fieldLabel : '<s:message code="plugin.mejoras.asunto.acuerdo.finalizarAsunto.cumplido" text="**Cumplido" />'
				,allowBlank : ocultarCumplidoYNegarBlanco
				,hidden : ocultarCumplidoYNegarBlanco	
			});
			

	var contenedor=new Ext.Panel({
		border:false
		,width:650
		,height: 500
		,layout : 'table'
		,layoutConfig:{columns:2}
		,defaults :  {xtype : 'fieldset', autoHeight : true, border : false }
		,items : [				
					 { items : fecha,colspan:2}
					,{ items : motivoFinalizacion,colspan:2}
					,{ items : cumplidoSelect,colspan:2}									
					,{ items : titulodescripcion,colspan:2}
					,{ items : descripcion,colspan:2}
					
					,idAsunto				
			]
	});
	app.crearABMWindow(page,contenedor);
	
</fwk:page>	