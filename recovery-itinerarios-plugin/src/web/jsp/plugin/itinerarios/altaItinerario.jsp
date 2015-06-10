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

	<pfs:textfield name="nombre" labelKey="plugin.itinerarios.alta.nombre"
		label="**Nombre" value="${itinerario.nombre}" obligatory="true" />
	
	<pfsforms:ddCombo name="dDtipoItinerario"
		labelKey="plugin.itinerarios.alta.tipoItinerario"
		label="**Tipo de itinerario" value="${itinerario.dDtipoItinerario.id}" dd="${ddTipoItinerario}" 
		obligatory="true" 
		 /> 
	
	
	 <%--	
	<pfsforms:ddCombo name="ambitoExpediente"
		labelKey="plugin.itinerarios.alta.ambitoExpediente"
		label="**Ámbito del expediente" 
		value="${itinerario.ambitoExpediente.id}" 
		dd="${ddAmbitoExpediente}" 
		width="490"
		/>
	
	--%>
		
	var ambitoExpedienteRecord = Ext.data.Record.create([
		{name:'codigo'}
		,{name:'descripcion'}
	]);
	
	
	var ambitoExpedienteStore = page.getStore({
		flow:'plugin.itinerarios.buscarAmbitosExpedientes'
		,reader: new Ext.data.JsonReader({
			idProperty: 'id'
			,root:'ambitoExpedienteIti'
		},ambitoExpedienteRecord)
	});
	
	var ambitoExpediente =new Ext.form.ComboBox({
		store: ambitoExpedienteStore
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'codigo'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.itinerarios.alta.ambitoExpediente" text="**Ámbito del expediente" />'
		,width:490
		,value:'${itinerario.ambitoExpediente.descripcion}'
	});
	
	
	var recargarAmbitoExpediente = function(){
		ambitoExpediente.store.removeAll();
		ambitoExpediente.clearValue();
		if (dDtipoItinerario.getValue()!=null && dDtipoItinerario.getValue()!=''){
			ambitoExpedienteStore.webflow({id:dDtipoItinerario.getValue()});
		}
		
	}
	
	dDtipoItinerario.on('select', function(){
		recargarAmbitoExpediente();
		ambitoExpediente.setDisabled(false);
	});
	
	if (dDtipoItinerario.getValue()!=null && dDtipoItinerario.getValue()!=''){
		ambitoExpedienteStore.webflow({id:dDtipoItinerario.getValue()});
		ambitoExpediente.setDisabled(false);
	}
	
	
	
	<pfs:defineParameters name="parametros" paramId="${itinerario.id}" 
		nombre="nombre"
		dDtipoItinerario="dDtipoItinerario"
		ambitoExpediente="ambitoExpediente"
		/>
		
	<pfs:editForm saveOrUpdateFlow="plugin/itinerarios/plugin.itinerarios.guardaItinerario"
		leftColumFields="nombre,dDtipoItinerario,ambitoExpediente"
		rightColumFields=""
		parameters="parametros" />

</fwk:page>