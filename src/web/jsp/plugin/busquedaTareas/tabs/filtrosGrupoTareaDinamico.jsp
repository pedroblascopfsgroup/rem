<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

(function(){

	<pfs:dblselect name="filtroPerfil"
			labelKey="plugin.config.usuarios.busqueda.control.filtroPerfil" label="**Perfil"
			dd="${perfiles}" width="160" height="100" />
			
	<pfs:ddCombo name="comboJerarquia" 
		labelKey="plugin.busquedaTareas.filtroComboJerarquia" label="**Jerarquía"
		blankElement="true" blankElementText="Todos" value="${nivelEnTarea}" dd="${niveles}" />

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
		,listeners:{
			getParametros: function(anadirParametros, hayError) {
		        if (validarEmptyForm()){
    	                anadirParametros(getParametros());
    	        }
			}
			,limpiar: function() {
    		   app.resetCampos([      
    		           	filtroPerfil, comboJerarquia, filtroCentro
	           ]); 
    		}
    	}
	});
	
	filtrosDeZonaTabBuscaTareas.on('activate',function(){
		tabJerarquia=true;
	}); 

	//Listado de tipos de gestor, viene del flow
	var dictGestorSupervisorUsuario = <app:dict value="${tiposGestor}" blankElement="true" blankElementValue="" blankElementText="---"/>;
	
	//store para los tipos de testor
	var optionsGestorSupervisorUsuario = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictGestorSupervisorUsuario
	});
	
	//Campo Combo Tipos de Gestor
	var comboGestorSupervisorUsuario = new Ext.form.ComboBox({
				store:optionsGestorSupervisorUsuario
				,displayField:'descripcion'
				,valueField:'codigo'
				,mode: 'local'
				,editable: false
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="plugin.busquedaTareas.filtroGestorSupervisorUsuario" text="**Tipo responsable" />'
				<app:test id="comboGestorSupervisorUsuario" addComa="true"/>
	});

	var validarEmptyForm = function(){
		
		try{
			if(filtroPerfil.getValue() != '' && filtroPerfil.getValue() )
				return true;	
			if(comboJerarquia.getValue() != '' && comboJerarquia.getValue() )
				return true;	
			if(filtroCentro.getValue() != '' && filtroCentro.getValue() )
				return true;	
			
		}catch(err){
			<%--console.debug(err); --%>
		};		
		return false;			
	}
	
	var getParametros = function() {
		
		return {perfilesAbuscar: filtroPerfil.getValue()
			,nivelEnTarea: comboJerarquia.getValue()
			,zonasAbuscar: filtroCentro.getValue()
			
		};
	};

    return filtrosDeZonaTabBuscaTareas;
    
})()