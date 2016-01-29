<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>

	<pfsforms:textfield name="nombre"
			labelKey="plugin.comites.busqueda.nombre" label="**Nombre"
			value="${comite.nombre}" obligatory="true" width="150"/>
	
	
	<pfs:currencyfield name="atribucionMinima"
			labelKey="plugin.comites.busqueda.atribucionMin" label="**Nombre"
			value="${comite.atribucionMinima}" obligatory="true" width="150"/>
			
	<pfs:currencyfield name="atribucionMaxima"
			labelKey="plugin.comites.busqueda.atribucionMax" label="**Atribución máxima"
		  	value="${comite.atribucionMaxima}" obligatory="true" width="150" />	

	
	<pfs:currencyfield name="prioridad"
			labelKey="plugin.comites.busqueda.prioridad" label="**Prioridad"
			value="${comite.prioridad}" obligatory="true" width="150"/>	
	
	<pfs:currencyfield name="miembros"
			labelKey="plugin.comites.busqueda.miembros" label="**Número de miembros"
			value="${comite.miembros}" obligatory="true" width="150"/>	
	
	<pfs:currencyfield name="miembrosRestrict"
			labelKey="plugin.comites.busqueda.miembrosRestrictivos" label="**Número de miembros restrictivos"
			value="${comite.miembrosRestrict}" obligatory="true" width="150"/>	
	
	
	<pfsforms:ddCombo name="comboJerarquia" 
		labelKey="plugin.comites.busqueda.control.comboJerarquia" label="**Jerarquia"
		value="${comite.zona.nivel.id}" dd="${niveles}" width="150"/>
	
				
	 var zonasRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
    
    var optionsZonasStore = page.getStore({
	       flow: 'plugin/comites/plugin.comites.buscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});
	var filtroCentro =new Ext.form.ComboBox({
		store: optionsZonasStore
		,allowBlank: true
		,blankElementText: '--'
		,disabled: true
		,displayField: 'descripcion'
		,valueField: 'id'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.comites.busqueda.control.filtroCentro" text="**Centro" />'
		,width:150
		,value:'${comite.zona.id}'
	});
	
    optionsZonasStore.on('load', function(){  
            filtroCentro.setValue(${comite.zona.id});
       });
	
	
	<c:if test="${appProperties.runInSelenium==false}">
		// Si estamos corriendo tests selenium esta función debe ser global para que
		// pueda ser llamada desde el JUnit 
		var
	</c:if> recargarComboZonas = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsZonasStore.webflow({id:0});
		}
	};
	
    recargarComboZonas();
    
    var limpiarYRecargar = function(){
		//app.resetCampos([comboZonas]);
		recargarComboZonas();
		filtroCentro.setDisabled(false);
	}
	
	
	
	comboJerarquia.on('select',limpiarYRecargar);
 
	if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
		optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		filtroCentro.setDisabled(false);
	}	
		
	<pfs:defineParameters name="getParametros" paramId="${comite.id}" 
		nombre="nombre" 
		atribucionMinima="atribucionMinima"
		atribucionMaxima="atribucionMaxima"
		prioridad="prioridad"
		miembros="miembros" miembrosRestrict="miembrosRestrict"
		zona="filtroCentro" />

	<pfs:editForm saveOrUpdateFlow="plugin/comites/plugin.comites.guardaComite"
		leftColumFields="nombre,prioridad,atribucionMinima,atribucionMaxima"
		rightColumFields="miembros,miembrosRestrict,comboJerarquia,filtroCentro"
		parameters="getParametros" />

</fwk:page>	