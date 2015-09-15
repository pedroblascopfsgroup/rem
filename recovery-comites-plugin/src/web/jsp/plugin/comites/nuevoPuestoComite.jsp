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
	
	<pfsforms:ddCombo name="perfil" labelKey="plugin.comites.tabPuestos.perfil" 
		label="**Perfil" value="${puesto.perfil.id}" dd="${perfiles}" width="250"/>	
 
	<pfsforms:check labelKey="plugin.comites.tabPuestos.esRestrictivo" label="**Restrictivo" 
		name="esRestrictivo" value="${puesto.esRestrictivo}" />
	
	<pfsforms:check labelKey="plugin.comites.tabPuestos.esSupervisor" label="**Supervisor" 
		name="esSupervisor" value="${puesto.esSupervisor}"/>
	
	<pfsforms:ddCombo name="comboJerarquia" 
		labelKey="plugin.comites.busqueda.control.comboJerarquia" label="**Jerarquia"
		value="${puesto.zona.nivel.id}" dd="${niveles}" width="250"/>
	
				
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
		,width:250
		,value:'${puesto.zona.id}'
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
	
    optionsZonasStore.on('load', function(){  
            filtroCentro.setValue(${puesto.zona.id});
       });

	
	comboJerarquia.on('select',limpiarYRecargar);
 
 	if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
		optionsZonasStore.webflow({id:comboJerarquia.getValue()});
		filtroCentro.setDisabled(false);
	}
 	
	<pfs:hidden name="comite" value="${comite.id}"/>
		
	<pfs:defineParameters name="getParametros" paramId="${puesto.id}" 
		comite="comite"
		perfil="perfil"
		esRestrictivo="esRestrictivo"
		esSupervisor="esSupervisor"
		zona="filtroCentro"/>

	<pfs:editForm saveOrUpdateFlow="plugin/comites/plugin.comites.guardaPuestoComite"
		leftColumFields="perfil,comboJerarquia,filtroCentro"
		rightColumFields="esSupervisor,esRestrictivo"
		parameters="getParametros" />

</fwk:page>	