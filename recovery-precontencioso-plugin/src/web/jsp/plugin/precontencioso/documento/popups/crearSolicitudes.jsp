<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>


<fwk:page>	

	var config = {width: 250, labelStyle:"width:150px;font-weight:bolder"};
	var modoConsulta = false;
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
						page.fireEvent(app.event.CANCEL);  	
					}
	});
	
	var btnGuardar= new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler:function(){
				if (validateForm) {		    
			    	var p = getParametros();
			    	Ext.Ajax.request({
							url : page.resolveUrl('documentopco/saveCrearSolicitudes'), 
							params : p ,
							method: 'POST',
							success: function ( result, request ) {
								page.fireEvent(app.event.DONE);
							}
					});
				}
	     }
	});
	

	var validateForm = function(){		              
		return true;
	};

	var getParametros = function() {
		
	 	var parametros = {};
	 	
	 	parametros.id = ${dtoDoc.id};
	 	parametros.actor = comboUsuario.getValue();
	 	if(fechaSolicitud.getValue()!=null && fechaSolicitud.getValue()!= '') parametros.fechaSolicitud = fechaSolicitud.getValue().format('d/m/Y');
	 	if(fechaResultado.getValue()!=null && fechaResultado.getValue()!= '') parametros.fechaResultado = fechaResultado.getValue().format('d/m/Y');
	 	if(fechaEnvio.getValue()!=null && fechaEnvio.getValue()!= '') parametros.fechaEnvio = fechaEnvio.getValue().format('d/m/Y');
	 	if(fecharecepcion.getValue()!=null && fecharecepcion.getValue()!= '') parametros.fecharecepcion = fecharecepcion.getValue().format('d/m/Y');
	 	parametros.resultado = comboResultado.getValue();
	 	parametros.tipogestor = comboTipoGestor.getValue();
	 	
	 	
	 	return parametros;
	 }	
	 
	 <%-- Combo Tipo Gestor --%>

	var tipoGestorRecord = Ext.data.Record.create([
		{name: 'id'},
		{name: 'codigo'},
		{name: 'descripcion'}
	]);

	var tipoGestorStore = page.getStore({
		flow: 'documentopco/getTiposGestorActores',
		reader: new Ext.data.JsonReader({
			root: 'listadoGestores'
		}, tipoGestorRecord)
	});

	var comboTipoGestor = new Ext.form.ComboBox({
		store: tipoGestorStore,
		displayField: 'descripcion',
		valueField: 'id',
		mode: 'remote',
		forceSelection: true,
		emptyText: 'Seleccionar',
		triggerAction: 'all',
		disabled: false,
		fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbTipoGestor" text="**Tipo gestor" />'
	});
	
	<%-- Combo Tipo Despacho --%>

	var tipoDespachoRecord = Ext.data.Record.create([
		{name: 'id'},
		{name: 'cod'},
		{name: 'descripcion'}
	]);

	var tipoDespachoStore = page.getStore({
		flow: 'coreextension/getListTipoDespachoData',
		reader: new Ext.data.JsonReader({
			root: 'listadoDespachos'
		}, tipoDespachoRecord)
	});

	var comboTipoDespacho = new Ext.form.ComboBox({
		store: tipoDespachoStore,
		displayField: 'descripcion',
		valueField:'cod',
		mode: 'remote',
		disabled: true,
		forceSelection: true,
		emptyText: 'Seleccionar',
		triggerAction: 'all',
		fieldLabel: '<s:message code="plugin.ugas.asuntos.cmbTipoDespacho" text="**Tipo despacho" />'
	});
	
	<%-- Combo Usuario --%>

	var usuarioRecord = Ext.data.Record.create([
		{name: 'id'},
		{name: 'username'}
	]);

	var usuarioStore = page.getStore({
		flow: 'coreextension/getListUsuariosPaginatedData',
		reader: new Ext.data.JsonReader({
			root: 'listadoUsuarios'
		}, usuarioRecord)
	});

	var comboUsuario = new Ext.form.ComboBox({
		store: usuarioStore,
		allowBlank: true,
		blankElementText: '---',
		emptyText: '---',
		disabled: true,
		displayField: 'username',
		valueField: 'id',
		fieldLabel: '<s:message code="precontencioso.grid.documento.crearSolicitudes.actor" text="**Actor" />',
		loadingText: 'Buscando...',
		labelStyle: 'width:100px',
		width: 250,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'local'
	});

	comboUsuario.on('afterrender', function(combo) {
		combo.mode = 'remote';
	});
	
	
		<%-- Events --%>

	comboTipoGestor.on('afterrender', function(combo) {
		tipoGestorStore.webflow();
	});

<!-- 	tipoGestorStore.on('load', function(combo) { -->
<!-- 		// Se filtra por tipo de gestor apoderado. -->
<!-- 		var numRecord = tipoGestorStore.findExact('descripcion', 'Apoderado', 0); -->
<!-- 		var value = tipoGestorStore.getAt(numRecord).data[comboTipoGestor.valueField]; -->
<!-- 		var rawValue = tipoGestorStore.getAt(numRecord).data[comboTipoGestor.displayField]; -->

<!-- 		comboTipoGestor.setValue(value); -->
<!-- 		comboTipoGestor.setRawValue(rawValue); -->
<!-- 		comboTipoGestor.selectedIndex = numRecord; -->

<!-- 		comboTipoDespacho.reset(); -->
<!-- 		comboUsuario.reset(); -->
<!-- 		comboTipoDespacho.setDisabled(false); -->
<!-- 		comboUsuario.setDisabled(true); -->

<!-- 		tipoDespachoStore.webflow({'idTipoGestor': comboTipoGestor.getValue()}); -->
<!-- 	}); -->
	
	comboTipoGestor.on('select', function() {
		
		comboTipoDespacho.reset();
		comboUsuario.reset();
		comboTipoDespacho.setDisabled(false);
		comboUsuario.setDisabled(true);

		tipoDespachoStore.webflow({'idTipoGestor': comboTipoGestor.getValue()});
	});

	comboTipoDespacho.on('select', function() {
		usuarioStore.webflow({'idTipoDespacho': comboTipoDespacho.getValue()});

		comboUsuario.reset();
		comboUsuario.setDisabled(false);
	});
	   
	
	var fechaSolicitud = new Ext.ux.form.XDateField({
		name : 'fechaEscritura'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.crearSolicitudes.fechaSolicitud" text="**Fecha solicitud" />'
<%-- 		,value : '<fwk:date value="${fechaEscritura}" />' --%>
		,style:'margin:0px'
	});
	
	var fechaResultado = new Ext.ux.form.XDateField({
		name : 'fechaResultado'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.crearSolicitudes.fechaResultado" text="**Fecha resultado" />'
<%-- 		,value : '<fwk:date value="${fechaEscritura}" />' --%>
		,style:'margin:0px'
	});
	
	var fechaEnvio = new Ext.ux.form.XDateField({
		name : 'fechaEnvio'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.crearSolicitudes.fechaEnvio" text="**Fecha envio" />'
<%-- 		,value : '<fwk:date value="${fechaEscritura}" />' --%>
		,style:'margin:0px'
	});
	
	var fecharecepcion = new Ext.ux.form.XDateField({
		name : 'fecharecepcion'
		,fieldLabel : '<s:message code="precontencioso.grid.documento.crearSolicitudes.fechaRecpecion" text="**Fecha recepción" />'
<%-- 		,value : '<fwk:date value="${fechaEscritura}" />' --%>
		,style:'margin:0px'
	});
	
	<pfsforms:ddCombo name="comboResultado"
		labelKey="precontencioso.grid.documento.crearSolicitudes.resultado" 
 		label="**Resultado" value="" dd="${DDResultado}" 
		propertyCodigo="codigo" propertyDescripcion="descripcion" />


	var panelEdicion = new Ext.form.FieldSet({
		title:'<s:message code="precontencioso.grid.documento.incluirDocumento.infoDocumentos" text="**Información Documentos" />'
		,layout:'table'
		,layoutConfig:{columns:2}
		,border:true
   	    ,width: 400
		,defaults : {xtype : 'fieldset', border:false , cellCls : 'vtop', bodyStyle : 'padding-left:0px'}
		,items:[{items: [ comboTipoGestor, comboTipoDespacho, comboUsuario, fechaSolicitud, fechaResultado, fechaEnvio, fecharecepcion, comboResultado]}
		]
	});	

	var panel=new Ext.Panel({
		border:false
		,bodyStyle : 'padding:5px'
		,height: 380
<!-- 		,autoHeight:true -->
		,autoWidth:true
		,autoScroll:true
		,defaults:{xtype:'fieldset',cellCls : 'vtop'}
		,items:panelEdicion
		,bbar:[btnGuardar, btnCancelar]
	});	
	

	page.add(panel);
	
</fwk:page>