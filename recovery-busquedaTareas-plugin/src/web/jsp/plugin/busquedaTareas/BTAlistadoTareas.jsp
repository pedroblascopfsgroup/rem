<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	
	
	var esAlerta="${alerta}";
	var enEspera="${espera}";
	var limit = 25;
	var isBusqueda='${isBusqueda}';
	var noGrouping='${noGrouping}';

	var paramsBusquedaInicial={
		start:0
		,limit:limit
		,perfilUsuario:perfilUsuario
		,enEspera:enEspera
		,esAlerta:esAlerta
		,busqueda:isBusqueda
		,tipoTarea:'${codigoTipoTarea}'
		,tipoSubTarea:'${codigoTipoSubTarea}'
		,ugGestion:'${ugGestion}'
		,nivelEnTarea:'${nivelEnTarea}'
		,estadoTarea:'${estadoTarea}'
		,fechaVencimientoDesde:'${fechaVencDesde}'
		,fechaVencDesdeOperador:'${fechaVencDesdeOp}'
		,fechaVencimientoHasta:'${fechaVencHasta}'
		,fechaVencimientoHastaOperador:'${fechaVencHastaOp}'
		,fechaInicioDesde:'${fechaInicioDesde}'
		,fechaInicioDesdeOperador:'${fechaInicioDesdeOp}'
		,fechaInicioHasta:'${fechaInicioHasta}'
		,fechaInicioHastaOperador:'${fechaInicioHastaOp}'
		,traerGestionVencidos:'${traerGestionVencidos}'
	};
	
	<%-- FILTROS DE ZONA --%>
	
	<pfs:dblselect name="filtroPerfil"
			labelKey="plugin.config.usuarios.busqueda.control.filtroPerfil" label="**Perfil"
			dd="${perfiles}" width="160" height="100" />
			
	<pfs:ddCombo name="comboJerarquia" 
		labelKey="plugin.busquedaTareas.filtroComboJerarquia" label="**Jerarquía"
		blankElement="true" blankElementText="Todos" value="${nivelEnTarea}" dd="${niveles}" />
	
	var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsZonasStore = page.getStore({
	       flow: 'btabusquedatareas/busquedaTareas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	});
	
	<pfs:dblselect name="filtroCentro"
			labelKey="plugin.busquedaTareas.filtroComboCentro" label="**Centro"
			dd="${zonas}" width="160" height="70" store="optionsZonasStore" />
			
	recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
		}
		filtroCentro.reset(); 
	};
	
	//recargarComboZonas();
	
	var limpiarYRecargar = function(){
		recargarComboZonas();
	}
	
	comboJerarquia.on('select',limpiarYRecargar);
		
	<pfs:textfield name="nombreUsuario"
			labelKey="plugin.busquedaTareas.filtroUsuario" label="**Nombre Usuario"
			value="" searchOnEnter="true"/>
	
	var tabJerarquia=false;	
	var filtrosDeZonaTabBuscaTareas = new Ext.Panel({
		title:'<s:message code="plugin.busquedaTareas.tituloPestanaFiltros3" text="**Filtros de zona" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [filtroPerfil] 
				},{
					layout:'form'
					,items: [comboJerarquia, filtroCentro]
				}]
	});
	filtrosDeZonaTabBuscaTareas.on('activate',function(){
		tabJerarquia=true;
	});
	
	<%-- FILTROS DE CAMPO --%>
	
<%-- <pfs:ddCombo name="comboUgRelacionada" labelKey="plugin.busquedaTareas.filtroUnidad" 
		 label="**Unidad de gestión" value="${ugGestion}" dd="${ugs}" blankElement="true" blankElementText="Todas" width="175"/>
--%>
	var comboUgRelacionada=new Ext.form.ComboBox({
		store:[['','Todas'],['1','Cliente'],['2','Expediente'],['3','Asunto'],['4','Tarea'],['5','Procedimiento'],['6','Contrato']]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.cabeceraUnidadGestion" text="**Unidad de gestión" />'
		,width:175
		,resizable: true
		,value:'${ugGestion}'
	});
				 	 
	var comboTipotarea=new Ext.form.ComboBox({
		store:[['','Todas'],['3','Notificación'],['1','Tarea']]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroClasificacion" text="**Clasificación" />'
		,width:175
		,resizable: true
		,value:'${codigoTipoTarea}'
	});

	var comboEstadoTarea=new Ext.form.ComboBox({
		// no cambiar valores - lógica de negocio	
		store:[['','Todos'],['1','Pendientes'],['2','Terminadas'],['3','Terminadas y vencidas']]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroEstado" text="**Estado" />'
		,width:175
		,resizable: true
		,value:'${estadoTarea}'
	});

	var comboAmbitoConsulta=new Ext.form.ComboBox({
		// no cambiar valores - lógica de negocio	
		store:[['1','Grupo'],['2','Individual'],['3','De usuario']]
		,allowBlank: false
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroAmbitoTareas" text="**Ámbito de tareas" />'
		,width:175
		,resizable: true
		,value:'1'
		,listeners:{
			afterRender:function(){
				aplicarVisibilidadFiltros();
			}
		}
	});

	var comboGestorSupervisorUsuario=new Ext.form.ComboBox({
		// no cambiar valores - lógica de negocio	
		store:[['','Todos'],['1','Gestor'],['2','Supervisor']]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroGestorSupervisorUsuario" text="**Tipo responsable" />'
		,width:175
		,resizable: true
	});
		
	aplicarVisibilidadFiltros = function(){
		if (comboAmbitoConsulta.getValue() == "1") {
			comboGestorSupervisorUsuario.reset();
			usernameUsuario.reset();
			filtrosDeZonaTabBuscaTareas.setDisabled(false);
			filtrosDeUsuarioTabBuscaTareas.setDisabled(true);
			//filtroGestores.reset();
			if(tabFiltrosUsuario){
				optionsGestoresStore.webflow({id:0});
				comboDespachos.reset();
			}
		}
		if (comboAmbitoConsulta.getValue() == "2") {
			comboGestorSupervisorUsuario.reset();
			usernameUsuario.reset();
			comboGestorSupervisorUsuario.reset();
			usernameUsuario.reset();
			if(tabJerarquia){
				filtroPerfil.reset();
				optionsZonasStore.webflow({id:0});
				comboJerarquia.reset();
				filtroCentro.reset();
			}
			filtrosDeZonaTabBuscaTareas.setDisabled(true);
			filtrosDeUsuarioTabBuscaTareas.setDisabled(false);
		}
		if (comboAmbitoConsulta.getValue() == "3") {
			filtrosDeZonaTabBuscaTareas.setDisabled(true);
			filtrosDeUsuarioTabBuscaTareas.setDisabled(true);
			usernameUsuario.setDisabled(false);
			comboGestorSupervisorUsuario.setDisabled(false);
			if(tabFiltrosUsuario){
				filtroGestores.reset();
				optionsGestoresStore.webflow({id:0});
				comboDespachos.reset();
			}
			if (tabJerarquia){
				filtroPerfil.reset();
				optionsZonasStore.webflow({id:0});
				comboJerarquia.reset();
				filtroCentro.reset();
			}
		} else {
			usernameUsuario.setDisabled(true);
			comboGestorSupervisorUsuario.setDisabled(true);
		}
	};
	
	comboAmbitoConsulta.on('select', aplicarVisibilidadFiltros);
	
	// combo dependiente del tipo de tarea -------------
	
	var tipoSubtarea = Ext.data.Record.create([
		 {name:'codigoSubtarea'}
		,{name:'descripcion'}
	]);

	var tipoSubtareaStore = page.getStore({
		 flow:'plugin/busquedaTareas/BTAlistadoSubTiposTarea'
		,reader: new Ext.data.JsonReader({
			idProperty: 'id',
    		root: 'subTiposTarea',
    		totalProperty: 'results',
			fields : [
				 {name: 'codigoSubtarea'}
				,{name:'descripcion'}
			]})
	});

	var comboTipoSubtarea=new Ext.form.ComboBox({
		store: tipoSubtareaStore
		,disabled: true
		,displayField: 'descripcion'
		,valueField: 'codigoSubtarea'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroTipo" text="**Tipo" />'
		,width:175
		,value:'${codigoTipoSubTarea}'
	});
	
	var recargarComboTipoSubtarea = function(){
		comboTipoSubtarea.store.removeAll();
		comboTipoSubtarea.clearValue();
		if (comboTipotarea.getValue()!=null && comboTipotarea.getValue()!=''){
			comboTipoSubtarea.store.webflow({id:comboTipotarea.getValue()});
		}
	}
	
	comboTipotarea.on('select', function(){
		comboTipoSubtarea.setDisabled(false);	
		recargarComboTipoSubtarea();
	});
	
	<pfs:textfield name="descTarea"
		labelKey="plugin.busquedaTareas.filtroDescripcion" label="**Descripcion Tarea"
		value="" searchOnEnter="true"/>

	<pfs:textfield name="nombreTarea"
		labelKey="plugin.busquedaTareas.filtroNbTarea" label="**Nombre Tarea"
		value="" searchOnEnter="true"/>
	
	<pfs:textfield name="usernameUsuario"
		labelKey="plugin.busquedaTareas.filtroUserUsuario" label="**Usuario"
		value="" searchOnEnter="true" />
		
	var tabCamposTareas =false;	
	var filtrosDeCampoTabBuscaTareas = new Ext.Panel({
		title:'<s:message code="plugin.busquedaTareas.tituloPestanaFiltros1" text="**Datos basicos" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:3}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
				layout:'form'
				,items: [comboAmbitoConsulta, comboEstadoTarea, comboUgRelacionada]
			},{
				layout:'form'
				,items: [nombreTarea, descTarea, usernameUsuario]
			},{
				layout:'form'
				,items: [comboTipotarea, comboTipoSubtarea, comboGestorSupervisorUsuario]
			}]
	});
	
	filtrosDeCampoTabBuscaTareas.on('activate',function(){
		tabCamposTareas=true;
	});
	
	<%-- FILTROS DE TAREA USUARIO --%>
	
<%--<pfs:textfield name="nombreUsuario"
		labelKey="plugin.busquedaTareas.filtroNbUsuario" label="**Nombre"
		value="" searchOnEnter="true"/>
	
	<pfs:textfield name="apellidoUsuario"
		labelKey="plugin.busquedaTareas.filtroApUsuario" label="**1er Apellido"
		value="" searchOnEnter="true"/>
--%>		

	<pfs:ddCombo name="comboDespachos" 
		labelKey="plugin.busquedaTareas.filtroDespachos" label="**Despachos"
		blankElement="true" blankElementText="Todos" value="" dd="${despachos}" />
	
	var gestoresRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsGestoresStore = page.getStore({
	       flow: 'asuntos/buscarGestores'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'gestores'
	    }, gestoresRecord)
	});
	
	<pfs:dblselect name="filtroGestores"
			labelKey="plugin.busquedaTareas.filtroGestores" label="**Gestor"
			dd="${gestores}" width="160" height="70" store="optionsGestoresStore" />
			
	recargarComboGestores = function(){
		if (comboDespachos.getValue()!=null && comboDespachos.getValue()!=''){
			optionsGestoresStore.webflow({id:comboDespachos.getValue()});
		}else{
			optionsGestoresStore.webflow({id:0});
		}
	};
	
	recargarComboGestores();
	
	var limpiarYRecargarGestores = function(){
		recargarComboGestores();
	}
	
	comboDespachos.on('select',limpiarYRecargarGestores);
	
	
	var tabFiltrosUsuario = false;			
	var filtrosDeUsuarioTabBuscaTareas = new Ext.Panel({
		title:'<s:message code="plugin.busquedaTareas.tituloPestanaFiltros4" text="**Filtros de usuario" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:1}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
				layout:'form'
				,items: [comboDespachos, filtroGestores]
			}]
	});
	filtrosDeUsuarioTabBuscaTareas.on('activate',function(){
		tabFiltrosUsuario=true;
	});
	<%-- FILTROS DE FECHA --%>
	 
	// Filtros fecha vencimiento -------------
	 
	var comboFechaDesdeOp=new Ext.form.ComboBox({
		store:[">=",">","=","<>"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorDesde" text="**Desde" />'
		,width:40
		,value:'${fechaVencDesdeOp}'
	})
	
	comboFechaDesdeOp.on('select',function(){
		var val = comboFechaDesdeOp.getValue();
		if(val == "=" || val == "<>"){
			comboFechaHastaOp.disable();
			fechaVencHasta.disable();
			fechaVencHasta.reset();
			comboFechaHastaOp.reset();
		}else{
			comboFechaHastaOp.enable();
			fechaVencHasta.enable();
		}	
	});
		
	var fechaVencDesde = new Ext.ux.form.XDateField({
		width:100
		,height:20
		,name:'fechaVencDesde'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaVencimiento" text="**F. Vencimiento" />'
		,value:'${fechaVencDesde}'
	});
	
	var comboFechaHastaOp=new Ext.form.ComboBox({
		store:["<=","<"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorHasta" text="**Venc hasta" />'
		,width:40
		,value:'${fechaVencHastaOp}'
	})
	
	var fechaVencHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaVencHasta'
		,height:20
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaVencimiento" text="**F. Vencimiento" />'
		,value:'${fechaVencHasta}'
	});

	// Filtros fecha incio -------------

	var comboFechaInicioDesdeOp=new Ext.form.ComboBox({
		store:[">=",">","=","<>"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorDesde" text="**Desde" />'
		,width:40
		,value:'${fechaInicioDesdeOp}'
	})
	
	comboFechaInicioDesdeOp.on('select',function(){
		var val = comboFechaInicioDesdeOp.getValue();
		if(val == "=" || val == "<>"){
			comboFechaInicioHastaOp.disable();
			fechaInicioHasta.disable();
			fechaInicioHasta.reset();
			comboFechaInicioHastaOp.reset();
		}else{
			comboFechaInicioHastaOp.enable();
			fechaInicioHasta.enable();
		}	
	});
		
	var fechaInicioDesde = new Ext.ux.form.XDateField({
		width:100
		,height:20
		,name:'fechaInicioDesde'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaInicio" text="**F. Inicio" />'
		,value:'${fechaInicioDesde}'
	});
	
	var comboFechaInicioHastaOp=new Ext.form.ComboBox({
		store:["<=","<"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorHasta" text="**Inicio hasta" />'
		,width:40
		,value:'${fechaInicioHastaOp}'
	})
	
	var fechaInicioHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaInicioHasta'
		,height:20
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaInicio" text="**F. Inicio" />'
		,value:'${fechaInicioHasta}'
	});

	// Filtros fecha Fin -------------

	var comboFechaFinDesdeOp=new Ext.form.ComboBox({
		store:[">=",">","=","<>"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorDesde" text="**Desde" />'
		,width:40
		,value:'${fechaFinDesdeOp}'
	})
	
	comboFechaFinDesdeOp.on('select',function(){
		var val = comboFechaFinDesdeOp.getValue();
		if(val == "=" || val == "<>"){
			comboFechaFinHastaOp.disable();
			fechaFinHasta.disable();
			fechaFinHasta.reset();
			comboFechaFinHastaOp.reset();
		}else{
			comboFechaFinHastaOp.enable();
			fechaFinHasta.enable();
		}	
	});
		
	var fechaFinDesde = new Ext.ux.form.XDateField({
		width:100
		,height:20
		,name:'fechaFinDesde'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaFin" text="**F. fin" />'
		,value:'${fechaFinDesde}'
	});
	
	var comboFechaFinHastaOp=new Ext.form.ComboBox({
		store:["<=","<"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorHasta" text="**Fin hasta" />'
		,width:40
		,value:'${fechaFinHastaOp}'
	})
	
	var fechaFinHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaFinHasta'
		,height:20
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaFin" text="**F. fin" />'
		,value:'${fechaFinHasta}'
	});
	
	var tabFechas=false;	
	var filtrosDeFechaTabBuscaTareas = new Ext.Panel({
		title:'<s:message code="plugin.busquedaTareas.tituloPestanaFiltros2" text="**Filtros de fecha" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:4}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboFechaDesdeOp, comboFechaInicioDesdeOp, comboFechaFinDesdeOp]
				},{
					layout:'form'
					,items: [fechaVencDesde, fechaInicioDesde, fechaFinDesde]
				},{
					layout:'form'
					,items: [comboFechaHastaOp, comboFechaInicioHastaOp, comboFechaFinHastaOp]
				},{
					layout:'form'
					,items: [fechaVencHasta, fechaInicioHasta, fechaFinHasta]
				}]
	});
	filtrosDeFechaTabBuscaTareas.on('activate',function(){
		tabFechas=true;
	});
	
	// VALIDACIONES FILTROS -------------------------------------------
	
	var validaFechas=function(){
		var valid=true;
		if (tabFechas){
			if(fechaVencDesde.getValue()!='' && fechaVencHasta.getValue()!=''){
				valid = (fechaVencDesde.getValue()< fechaVencHasta.getValue())
			}

			if(fechaVencDesde.getValue()!='' && comboFechaDesdeOp.getValue()==''){
				valid = valid && false;
			}
			if(fechaVencHasta.getValue()!='' && comboFechaHastaOp.getValue()==''){
				valid = valid && false;
			}
			if(fechaInicioDesde.getValue()!='' && comboFechaInicioDesdeOp.getValue()==''){
				valid = valid && false;
			}
			if(fechaInicioHasta.getValue()!='' && comboFechaInicioHastaOp.getValue()==''){
				valid = valid && false;
			}
			if(fechaFinDesde.getValue()!='' && comboFechaFinDesdeOp.getValue()==''){
				valid = valid && false;
			}
			if(fechaFinHasta.getValue()!='' && comboFechaFinHastaOp.getValue()==''){
				valid = valid && false;
			}
								
			if(comboFechaDesdeOp.getValue()=='>=' || comboFechaDesdeOp.getValue()=='>'){
				if (fechaVencHasta.getValue()!='' && comboFechaHastaOp.getValue()!='') 
					if(fechaVencDesde.getValue()=='')
						valid = valid && false;
					else
						valid = valid && true;
			}
			if(fechaInicioDesde.getValue()!='' && fechaInicioHasta.getValue()!=''){
				valid = (fechaInicioDesde.getValue()< fechaInicioHasta.getValue())
			}
			if(comboFechaInicioDesdeOp.getValue()=='>=' || comboFechaInicioDesdeOp.getValue()=='>'){
				if (fechaInicioHasta.getValue()!='' && comboFechaInicioHastaOp.getValue()!='') 
					if(fechaInicioDesde.getValue()=='')
						valid = valid && false;
					else
						valid = valid && true;
			}
			if(fechaFinDesde.getValue()!='' && fechaFinHasta.getValue()!=''){
				valid = (fechaFinDesde.getValue()< fechaFinHasta.getValue())
			}
			if(comboFechaFinDesdeOp.getValue()=='>=' || comboFechaFinDesdeOp.getValue()=='>'){
				if (fechaFinHasta.getValue()!='' && comboFechaFinHastaOp.getValue()!='') 
					if(fechaFinDesde.getValue()=='')
						valid = valid && false;
					else
						valid = valid && true;
			}
		}
		return valid;
	}
	
	// -----------------------------------------------------

	var filtroTabPanel=new Ext.TabPanel({
		items:[filtrosDeCampoTabBuscaTareas, filtrosDeFechaTabBuscaTareas, filtrosDeZonaTabBuscaTareas, filtrosDeUsuarioTabBuscaTareas]
		,id:'idTabFiltrosTareas'
		,layoutOnTabChange:true 
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false	
		,activeItem:0
	});
		
	var getParametrosBusqueda=function(){
		var p = {};
			p.perfilUsuario=perfilUsuario;
			p.enEspera=enEspera;
			p.esAlerta=esAlerta;
			p.limit=limit;
			p.busqueda=true;
			p.star=0;
				// Filtros
			if(tabFiltrosUsuario){
				p.despacho=comboDespachos.getValue();
				p.gestores=filtroGestores.getValue();
			}
				//p.nombreUsuario=nombreUsuario.getValue();
				//p.apellidoUsuario=apellidoUsuario.getValue();
			if(tabJerarquia){
				p.perfilesAbuscar=filtroPerfil.getValue();
				p.zonasAbuscar=filtroCentro.getValue();
			}
			if(tabCamposTareas){
				p.codigoTipoTarea=comboTipotarea.getValue();
				p.codigoTipoSubTarea=comboTipoSubtarea.getValue();
				p.nombreTarea=nombreTarea.getValue();
				p.descripcionTarea=descTarea.getValue();
				p.gestorSupervisorUsuario=comboGestorSupervisorUsuario.getValue();
				p.nombreUsuario=nombreUsuario.getValue();
				p.ugGestion=comboUgRelacionada.getValue();
				p.nivelEnTarea=comboJerarquia.getValue();
				p.usernameUsuario=usernameUsuario.getValue();
				p.ambitoTarea=comboAmbitoConsulta.getValue();
				p.estadoTarea=comboEstadoTarea.getValue();
			}
			if(tabFechas){	
				p.fechaVencimientoDesde=app.format.dateRenderer(fechaVencDesde.getValue());
				p.fechaVencDesdeOperador=comboFechaDesdeOp.getValue();
				p.fechaVencimientoHasta=app.format.dateRenderer(fechaVencHasta.getValue());
				p.fechaVencimientoHastaOperador=comboFechaHastaOp.getValue();
				p.fechaInicioDesde=app.format.dateRenderer(fechaInicioDesde.getValue());
				p.fechaInicioDesdeOperador=comboFechaInicioDesdeOp.getValue();
				p.fechaInicioHasta=app.format.dateRenderer(fechaInicioHasta.getValue());
				p.fechaInicioHastaOperador=comboFechaInicioHastaOp.getValue();
				p.fechaFinDesde=app.format.dateRenderer(fechaFinDesde.getValue());
				p.fechaFinDesdeOperador=comboFechaFinDesdeOp.getValue();
				p.fechaFinHasta=app.format.dateRenderer(fechaFinHasta.getValue());
				p.fechaFinHastaOperador=comboFechaFinHastaOp.getValue();
			}
		return p;
	}
	
	var buscarFunc=function(){
		if(validaFechas()){
			isBusqueda=true;
			flitrosPlegables.collapse(true);
			tareasStore.webflow(getParametrosBusqueda());
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.busquedaTareas.filtroIncoherenteFecha" text="** La fecha desde debe ser menor a la fecha Hasta"/>')
		}
	}
	
	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
   
	resetFiltros = function(){
		
		if(tabCamposTareas){
			comboEstadoTarea.reset();
			descTarea.reset();
			comboTipotarea.reset();
			nombreTarea.reset();
			comboTipoSubtarea.reset();
			comboUgRelacionada.reset();
			usernameUsuario.reset();
			comboGestorSupervisorUsuario.reset();
		}
		if(tabFechas){
			comboFechaDesdeOp.reset();
			comboFechaInicioDesdeOp.reset();
			comboFechaFinDesdeOp.reset();
			fechaVencDesde.reset();
			fechaInicioDesde.reset();
			fechaFinDesde.reset();
			comboFechaHastaOp.reset();
			comboFechaInicioHastaOp.reset();
			comboFechaFinHastaOp.reset();
			fechaVencHasta.reset();
			fechaInicioHasta.reset();
			fechaFinHasta.reset();
		}
		if(tabJerarquia){
			filtroPerfil.reset();
			optionsZonasStore.webflow({id:0});
			comboJerarquia.reset();
			filtroCentro.reset();
		}
		if(tabFiltrosUsuario){		
			filtroGestores.reset();
			optionsGestoresStore.webflow({id:0});
			comboDespachos.reset();
			
		}
		aplicarVisibilidadFiltros();
	};
		
	var btnClean=new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			resetFiltros();
			tareasGrid.collapse(true);
		}
	});
	
	var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**exportar a xls" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
				if(validaFechas()){
					var flow='plugin/busquedaTareas/BTAlistadoTareasExcelData';
	                   var params ;
					if(isBusqueda)
						params = getParametrosBusqueda();
					else
						params = paramsBusquedaInicial;
	                   params.REPORT_NAME='listado_tareas.xls';
	                   app.openBrowserWindow(flow,params);
				}else{
					Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.busquedaTareas.filtroIncoherenteFecha" text="** La fecha desde debe ser menor a la fecha Hasta"/>')
				}
           }
        }
    );
	

	
	// -- End Filtros ---------------------------------------------------

	var tarea = Ext.data.Record.create([
		{name:'subtipo'}
		,{name:'fechaInicio',type:'date', dateFormat:'d/m/Y'}
		,{name:'fechaFin',type:'date', dateFormat:'d/m/Y'}
		,{name:'id'}
		,{name:'descripcion'}
		,{name:'codentidad'}
		,{name:'plazo'}
		,{name:'entidadInformacion'}
		,{name:'entidadInformacion_id'}
		,{name:'gestor'}
		,{name:'tipoTarea'}
		,{name:'tipoTareaDescripcion'}
		,{name:'subTipoTarea'}
		,{name:'idEntidad'}		
		,{name:'codigoSubtipoTarea'}
		,{name:'codigoEntidadInformacion'}
		,{name:'codigoSituacion'}
		,{name:'fcreacionEntidad'}
		,{name:'fechaVenc',type:'date', dateFormat:'d/m/Y'}
		,{name:'fechaRealizacion',type:'date', dateFormat:'d/m/Y'}
		,{name:'idTareaAsociada'}
		,{name:'descripcionTareaAsociada'}
		,{name:'tipoSolicitud'}
		,{name:'emisor'}
		,{name:'supervisor'}
		,{name:'diasVencido'}
		,{name:'descripcionExpediente'}
		,{name:'descripcionTarea'}
		,{name:'gestorId'}
		,{name:'supervisorId'}
		,{name:'idEntidadPersona'}
		,{name:'volumenRiesgo'}
		,{name:'volumenRiesgoVencido'}
		,{name:'group'}
		,{name:'itinerario'}
		,{name:'descripcionEntidadInformacion'}
		,{name:'zona'}
	]);
	
	var tareasStore = page.getGroupingStore({
		eventName : 'listado'
		,limit: limit
		,flow:'btabusquedatareas/busquedaTareas'
		,sortInfo:{field: 'fechaVenc', direction: "ASC"}
		,groupField:'group'
		,remoteSort : false
		,baseParams:paramsBusquedaInicial
		,groupOnSort:'true'
		,reader: new Ext.data.JsonReader({
	    	root : 'tareas'
	    	,totalProperty : 'total'
	    }, tarea)
	});
	
	tareasStore.addListener('load', agrupa);
	tareasStore.setDefaultSort('fechaVenc', 'ASC');
	function agrupa(store, meta) {
		if (!('${noGrouping}'=='true')) {
			store.groupBy('group', true);
		}		
		tareasStore.removeListener('load', agrupa);
    };
	
	var perfilUsuario;

	var alertasRenderer = function(value){
		var idx = parseInt(value);
		var iconos = [0,'alerta.gif', 'notificacion.gif'];
		return "<img src='/${appProperties.appName}/css/" +iconos[idx] + "' />";
	};

	var groupRenderer=function(val){
		if(val==0)
			return '<s:message code="main.arbol_tareas.groups.vencidas" text="**Vencidas / Incumplidas " />';
		if(val==1)
			return '<s:message code="main.arbol_tareas.groups.hoy" text="**Hoy" />';
		if(val==2)
			return '<s:message code="main.arbol_tareas.groups.estasemana" text="**Esta Semana" />';
		if(val==3)
			return '<s:message code="main.arbol_tareas.groups.estemes" text="**Este Mes" />';
		if(val==4)
			return '<s:message code="main.arbol_tareas.groups.proximosmeses" text="**Proximos meses" /> ';
		if(val==5)
			return '<s:message code="main.arbol_tareas.groups.mesesanteriores" text="**meses Anteriores" /> ';
	}
	var tareasNewCm=new Ext.grid.ColumnModel([
		{	/*Columna 0*/ header: '<s:message code="plugin.busquedaTareas.cabeceraUnidadGestion" text="**Unidad Gestión"/>', sortable: false, dataIndex: 'descripcionEntidadInformacion'}
		,{	/*Columna 1*/ header: '<s:message code="plugin.busquedaTareas.cabeceraUnidadGestionId" text="**Unidad Gestión Id"/>', sortable: true, dataIndex: 'entidadInformacion_id', hidden:true}
		,{	/*Columna 1*/ header: '<s:message code="plugin.busquedaTareas.cabeceraTarea" text="**Tarea"/>', sortable: true, dataIndex: 'descripcionTarea', width:150}
		,{	/*Columna 2*/ header: '<s:message code="plugin.busquedaTareas.cabeceraDescripcion" text="**Descripcion"/>', sortable: false, dataIndex: 'descripcion', width:150}
		,{	/*Columna 3*/ header: '<s:message code="plugin.busquedaTareas.cabeceraFechaInicio" text="**Fecha inicio"/>', sortable: true, dataIndex: 'fechaInicio', renderer:app.format.dateRenderer, width:70}
		,{	/*Columna 4*/ header: '<s:message code="plugin.busquedaTareas.cabeceraFechaVencimiento" text="**Fecha Vto."/>', sortable: true, dataIndex: 'fechaVenc', renderer:app.format.dateRenderer, width:70}
		,{	/*Columna 3*/ header: '<s:message code="plugin.busquedaTareas.cabeceraFechaFin" text="**Fecha fin"/>', sortable: true, dataIndex: 'fechaFin', renderer:app.format.dateRenderer, width:70}
		,{  /*Columna 5*/ header: '<s:message code="plugin.busquedaTareas.cabeceraDiasVencida" text="**Dias Vencida"/>', sortable: false, dataIndex: 'diasVencido', width:70}
		,{  /*Columna 6*/ header: '<s:message code="plugin.busquedaTareas.cabeceraGestor" text="**Gestor"/>', sortable: false, dataIndex: 'gestor', width:70}
		,{  /*Columna 7*/ header: '<s:message code="plugin.busquedaTareas.cabeceraSupervisor" text="**Supervisor"/>', sortable: false, dataIndex: 'supervisor', width:70}
		,{  /*Columna 8*/ header: '<s:message code="plugin.busquedaTareas.cabeceraEmisor" text="**Emisor"/>', sortable: true, dataIndex: 'emisor', width:70, hidden:true}
		,{  /*Columna 9*/ header: '<s:message code="plugin.busquedaTareas.cabeceraClasificacion" text="**Clasificación"/>', sortable: false, dataIndex: 'tipoTareaDescripcion'}
		,{  /*Columna 10*/ header: '<s:message code="plugin.busquedaTareas.cabeceraTipo" text="**Tipo"/>', sortable: false, dataIndex: 'subTipoTarea'}
		,{	/*Columna 11*/ header: '<s:message code="plugin.busquedaTareas.cabeceraItinerario" text="**Itinerario"/>', sortable: false, dataIndex: 'itinerario', hidden:true}
		,{	/*Columna 12*/ header: '<s:message code="plugin.busquedaTareas.cabeceraTipoSolicitud" text="**Tipo solicitud"/>',sortable: false, dataIndex: 'tipoSolicitud', width:75, hidden:true}
		,{  /*Columna 13*/ header: '<s:message code="plugin.busquedaTareas.cabeceraId" text="**Id"/>', sortable: true,dataIndex: 'id', hidden:true}
		,{  /*Columna 14*/ header: '<s:message code="plugin.busquedaTareas.total" text="**Total"/>',	sortable: false, dataIndex: 'volumenRiesgo', renderer:app.format.moneyRendererNull, align:'right', hidden:true}
		,{  /*Columna 15*/ header: '<s:message code="plugin.busquedaTareas.cabeceraVRV" text="**VRV"/>', sortable: false, dataIndex: 'volumenRiesgoVencido', renderer:app.format.moneyRendererNull,align:'right', hidden:true}
		,{  /*Columna 16*/ header: '<s:message code="plugin.busquedaTareas.cabeceraVencimiento" text="**vencimiento"/>', sortable: false, dataIndex: 'group',renderer:groupRenderer, hidden:true}
		,{  /*Columna 17*/ header: '<s:message code="plugin.busquedaTareas.cabeceraZona" text="**Zonificación"/>', sortable: false, dataIndex: 'zona', width:70}
	]);
	
	var pagingBar=fwk.ux.getPaging(tareasStore);

	var tareasGrid = app.crearGrid(tareasStore,tareasNewCm, {
		title : '<s:message code="plugin.busquedaTareas.tituloResltado" text="**Tareas" arguments="0"/>'
		,style:'padding-bottom:10px; padding-right:20px;'
		,cls:'cursor_pointer'
		,iconCls:'icon_pendientes_tab'
		,collapsible : true
		,collapsed: true		
		,titleCollapse : true
		,resizable:true
		,dontResizeHeight:true						
		,bbar : [pagingBar]
		,autoHeight:true
		,view: new Ext.grid.GroupingView({
	            forceFit:true
	            ,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
	        })
	});
	
	tareasStore.on('load', function(){
		tareasGrid.setTitle('<s:message code="plugin.busquedaTareas.tituloResltado" text="**Tareas" arguments="'+tareasStore.getTotalCount()+'"/>');
		flitrosPlegables.collapse(true);
	});
	
	tareasGrid.on('rowdblclick', function(grid, rowIndex, e) {
		//agregar funcionalidad....
    	var rec = grid.getStore().getAt(rowIndex);
		
		var codigoSubtipoTarea = rec.get('codigoSubtipoTarea');
		if(codigoSubtipoTarea==app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR && permisosVisibilidadGestorSupervisor(rec.get('gestorId')) == true){
			codigoSubtipoTarea = app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_SUPERVISOR;
		}
		if(codigoSubtipoTarea==app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR && permisosVisibilidadGestorSupervisor(rec.get('supervisorId')) == true){
			codigoSubtipoTarea = app.subtipoTarea.CODIGO_NOTIFICACION_COMUNICACION_RESPONDIDA_DE_GESTOR;
		}
		
		
		switch (codigoSubtipoTarea){
			case app.subtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE:
			case app.subtipoTarea.CODIGO_REVISAR_EXPEDIENE:
			case app.subtipoTarea.CODIGO_DECISION_COMITE:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_CE:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_RE:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_DC:
				app.abreExpediente(rec.get('idEntidad'), rec.get('descripcionExpediente'));
			break;
			case app.subtipoTarea.CODIGO_TAREA_PEDIDO_EXPEDIENTE_MANUAL:
            case app.subtipoTarea.CODIGO_TAREA_VERIFICAR_TELECOBRO:
				app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
			break;
			case app.subtipoTarea.CODIGO_GESTION_VENCIDOS:
				app.openTab("<s:message code="tareas.gv" text="**Gesti&oacute;n de Vencidos"/>", "clientes/listadoClientes", {gv:true},{id:'GV',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO:
				app.openTab("<s:message code="tareas.gsis" text="**Gesti&oacute;n de Seguimiento Sistem&aacute;tico"/>", "clientes/listadoClientes", {gsis:true},{id:'GSIN',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO:
				app.openTab("<s:message code="tareas.gsin" text="**Gesti&oacute;n de Seguimiento Sintom&aacute;tico"/>", "clientes/listadoClientes", {gsin:true},{id:'GSIS',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_GESTOR:
			case app.subtipoTarea.CODIGO_TAREA_COMUNICACION_DE_SUPERVISOR:
				 var w = app.openWindow({
						flow : 'tareas/generarNotificacion'
						,title : '<s:message code="tareas.notificacion" text="Notificacion" />'
						,width:650 
						,params : {
								idEntidad: rec.get('idEntidad')
								,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
								,descripcion: rec.get('descripcionTarea')
								,fecha: rec.get('fcreacionEntidad')
								,situacion: rec.get('codigoSituacion')
								,idTareaAsociada: rec.get('id')
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
					w.on(app.event.OPEN_ENTITY, function(){
						w.close();
						if (rec.get('codigoEntidadInformacion') == '1'){
							app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '2'){
							app.abreExpediente(rec.get('idEntidad'), rec.get('descripcion'));
						}		
						if (rec.get('codigoEntidadInformacion') == '3'){
							app.abreAsunto(rec.get('idEntidad'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '5'){
							app.abreProcedimiento(rec.get('idEntidad'), rec.get('descripcion'));
						}				
					});
			break;
            case app.subtipoTarea.CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO:
                var w = app.openWindow({
                        flow : 'clientes/decisionTelecobro'
                        ,title : '<s:message code="clientes.menu.aceptarRechazarExclusion" text="**Aceptar/Rechazar Exclusion Recobro" />'
                        ,width:400 
                        ,params : {
                                idEntidad: rec.get('idEntidad')
                                ,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
                                ,descripcion: rec.get('descripcionTarea')
                                ,fecha: rec.get('fcreacionEntidad')
                                ,situacion: rec.get('codigoSituacion')
                                ,descripcionTareaAsociada: rec.get('descripcionTareaAsociada')
                                ,idTareaAsociada: rec.get('idTareaAsociada')
                                ,idTarea:rec.get('id')
                                ,enEspera:'${espera}'
                        }
                    });
                    w.on(app.event.DONE, function(){w.close();});
                    w.on(app.event.CANCEL, function(){ w.close(); });
                    w.on(app.event.OPEN_ENTITY, function(){
                        w.close();
                        app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));             
                    });
            break; 
            case app.subtipoTarea.CODIGO_TAREA_RESPUESTA_SOLICITUD_EXCLUSION_TELECOBRO:    
                var w = app.openWindow({
                        flow : 'clientes/consultaDecisionTelecobro'
                        ,title : '<s:message code="tareas.notificacion" text="**Notificacion" />'
                        ,width:400 
                        ,params : {
                                idEntidad: rec.get('idEntidad')
                                ,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
                                ,descripcion: rec.get('descripcionTarea')
                                ,fecha: rec.get('fcreacionEntidad')
                                ,situacion: rec.get('codigoSituacion')
                                ,descripcionTareaAsociada: rec.get('descripcionTareaAsociada')
                                ,idTareaAsociada: rec.get('idTareaAsociada')
                                ,idTarea:rec.get('id')
                        }
                    });
                    w.on(app.event.DONE, function(){
						w.close();
						//Recargamos el flow
                    	tareasStore.webflow(paramsBusquedaInicial);
                    });
                    w.on(app.event.CANCEL, function(){ w.close(); });
                    w.on(app.event.OPEN_ENTITY, function(){
                        w.close();
                        app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));             
                    });
            break;  
            case app.subtipoTarea.CODIGO_SOLICITUD_CANCELACION_EXPEDIENTE_DE_SUPERVISOR:
				var w = app.openWindow({
					flow : 'expedientes/decisionSolicitudCancelacionConTarea'
					,eventName: 'tarea'
					,title : '<s:message code="expedientes.consulta.solicitarcancelacion" text="**Solicitar cancelacion" />'
					,params : {idExpediente:rec.get('idEntidad'), idTarea:rec.get('id'), espera:'${espera}'}
				});
			
				w.on(app.event.DONE, function(){
								w.close();
								tareasStore.webflow(paramsBusquedaInicial);
							 }	 
				);
				w.on(app.event.CANCEL, function(){ w.close(); });
			break;
			case app.subtipoTarea.CODIGO_ACEPTAR_ASUNTO_GESTOR:
			case app.subtipoTarea.CODIGO_ACEPTAR_ASUNTO_SUPERVISOR:
			case app.subtipoTarea.CODIGO_ASUNTO_PROPUESTO:
				app.abreAsuntoTab(rec.get('idEntidad'), rec.get('descripcion'),'aceptacionAsunto');
			break;
			case app.subtipoTarea.CODIGO_ACUERDO_PROPUESTO:
			case app.subtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO:
				app.abreAsuntoTab(rec.get('idEntidad'), rec.get('descripcion'),'acuerdos');
			break;
			case app.subtipoTarea.CODIGO_RECOPILAR_DOCUMENTACION_PROCEDIMIENTO:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'docRequerida');
			break;
			case app.subtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_GESTOR:
			case app.subtipoTarea.CODIGO_PROCEDIMIENTO_EXTERNO_SUPERVISOR:
			case app.subtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'tareas');
			break;
			case app.subtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_GESTOR:
			case app.subtipoTarea.CODIGO_ACTUALIZAR_ESTADO_RECURSO_SUPERVISOR: 
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'recursos');
			break;
			case app.subtipoTarea.CODIGO_TOMA_DECISION_BPM:
			case app.subtipoTarea.CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO:
			//case app.subtipoTarea.CODIGO_ACEPTACION_DECISION_PROCEDIMIENTO:
				app.abreProcedimientoTab(rec.get('idEntidad'), rec.get('descripcion'), 'decision');
			break;
			case app.subtipoTarea.CODIGO_TAREA_PROPUESTA_BORRADO_OBJETIVO:
                var idObjetivo = rec.get('idEntidad');
                var w = app.openWindow({
                    flow: 'politica/aceptarTareaObjetivo'
                    ,width: 900
                    ,title: '<s:message code="aceptar.tarea.objetivo" text="**Aceptar tarea" />'
                    ,params: {idObjetivo:idObjetivo
					          ,aceptarBorrar:'borrar'
					          ,checkBoxTexto:'<s:message code="objetivo.aceptarPropuestaBorrado"
                                                         text="**Permito el borrado del objetivo" />'}
                });
                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(paramsBusquedaInicial);});
                w.on(app.event.CANCEL, function(){ w.close(); });
            break;
            case app.subtipoTarea.CODIGO_TAREA_PROPUESTA_OBJETIVO:
                var idObjetivo = rec.get('idEntidad');
                var w = app.openWindow({
                    flow: 'politica/aceptarTareaObjetivo'
                    ,width: 900
                    ,title: '<s:message code="aceptar.tarea.objetivo" text="**Aceptar tarea" />'
                    ,params: {idObjetivo:idObjetivo
					          ,aceptarBorrar:'aceptar'
					          ,checkBoxTexto:'<s:message code="objetivo.aceptarPropuesta"
                                                         text="**Permito la propuesta del objetivo" />'}
                });
                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(paramsBusquedaInicial);});
                w.on(app.event.CANCEL, function(){ w.close(); });
            break;
            case app.subtipoTarea.CODIGO_TAREA_PROPUESTA_CUMPLIMIENTO_OBJETIVO:
                var idObjetivo = rec.get('idEntidad');
                var w = app.openWindow({
                    flow: 'politica/aceptarPropuestaCumplimiento'
                    ,width: 900
                    ,title: '<s:message code="objetivos.propuestaCumplimiento.titulo" text="**Propuesta Cumplimiento" />'
                    ,params: {idObjetivo:idObjetivo}
                });
            
                w.on(app.event.DONE, function(){w.close();tareasStore.webflow(paramsBusquedaInicial);});
                w.on(app.event.CANCEL, function(){ w.close(); });
            break;
            // Por default abre una notificacion standard
			default:
				var w = app.openWindow({
						flow : 'tareas/consultaNotificacion'
						,title : '<s:message code="tareas.notificacion" text="**Notificacion" />'
						,width:400 
						,params : {
								idEntidad: rec.get('idEntidad')
								,codigoTipoEntidad: rec.get('codigoEntidadInformacion')
								,descripcion: rec.get('descripcionTarea')
								,fecha: rec.get('fcreacionEntidad')
								,situacion: rec.get('codigoSituacion')
								,descripcionTareaAsociada: rec.get('descripcionTareaAsociada')
								,idTareaAsociada: rec.get('idTareaAsociada')
								,idTarea:rec.get('id')
                                ,tipoTarea:rec.get('tipoTarea')
						}
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
					w.on(app.event.DONE, function(){ 
                            w.close();
                            tareasStore.webflow(paramsBusquedaInicial); 
							//Recargamos el arbol de tareas
							app.recargaTree();
                    });
					w.on(app.event.OPEN_ENTITY, function(){
						w.close();
						if (rec.get('codigoEntidadInformacion') == '1'){
							app.abreCliente(rec.get('idEntidadPersona'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '2'){
							app.abreExpediente(rec.get('idEntidad'), rec.get('descripcion'));
						}	
						if (rec.get('codigoEntidadInformacion') == '3'){
							app.abreAsunto(rec.get('idEntidad'), rec.get('descripcion'));
						}
						if (rec.get('codigoEntidadInformacion') == '5'){
							app.abreProcedimiento(rec.get('idEntidad'), rec.get('descripcion'));
						}			
                        if (rec.get('codigoEntidadInformacion') == '7'){
                            app.abreClienteTab(rec.get('idEntidadPersona'), rec.get('descripcion'),'politicaPanel');
                        }	
					});
			break;           
		}
				
	});
	
	tareasGrid.getView().getRowClass = function(record, index){
		return (record.data.codigoSubtipoTarea == app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO
			|| record.data.codigoSubtipoTarea == app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO 
			|| record.data.codigoSubtipoTarea == app.subtipoTarea.CODIGO_GESTION_VENCIDOS) ? "marked_row" : ""; 
	};
	
	var flitrosPlegables = new Ext.Panel({
		items:[filtroTabPanel]
		,title : '<s:message code="plugin.busquedaTareas.tituloFiltros" text="**Filtro de bienes" />'
		,titleCollapse : true
		,style:'padding-bottom:10px; padding-right:10px;'
		,collapsible:true
		,tbar : [btnBuscar, btnClean, btnExportarXls,buttonsL,'->',buttonsR]
		,listeners:{	
			beforeExpand:function(){
				tareasGrid.setHeight(0);
			}
			,beforeCollapse:function(){
				tareasGrid.setHeight(435);
				tareasGrid.expand(true);
			}
		}
	});
	
	var mainPanel = new Ext.Panel({
		items : [
			 flitrosPlegables
			,tareasGrid
    	]
	    ,bodyStyle:'padding:15px'
	    ,autoHeight : true
	    ,border: false
	    
    });
    
	page.add(mainPanel);

</fwk:page>