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

	<pfsforms:ddCombo name="ddTipoReglasElevacion"
		labelKey="plugin.itinerarios.reglasElevacion.regla"
		label="**Reglas de elevación" value="" dd="${ddTipoReglasElevacion}" 
		obligatory="true" />
	
		
	<!--<pfsforms:ddCombo name="ambitoExpediente"
		labelKey="plugin.itinerarios.alta.ambitoExpediente"
		label="**Ámbito del expediente" value="${itinerario.ambitoExpediente.id}" dd="${ddAmbitoExpediente}" 
		width="490"/>-->
		
	var ambito = Ext.data.Record.create([
		{name:'id'}
		,{name:'codigo'}
		,{name:'descripcion'}
		,{name:'descripcionLarga'}
	]);
	
	var ambitoStore = page.getStore({
		flow: 'plugin/itinerarios/plugin.itinerarios.listaAmbitosByRegla'
		,reader: new Ext.data.JsonReader({
			root: 'diccionario'}
		,ambito)
	});
	
	var ambitoExpediente = new Ext.form.ComboBox({
			store:ambitoStore
			,allowBlank:false
			,displayField:'descripcionLarga'
			,valueField:'id'
			,mode: 'remote'
			,triggerAction: 'all'
			,resizable: true
			,width: 500
			,forceSelection: true
			,disabled: true
			,editable: false
			,fieldLabel: '<s:message code="plugin.itinerarios.alta.ambitoExpediente" text="**Ámbito del Expediente" />'
		});
		
	ddTipoReglasElevacion.on('select',function(combo, record, index){
	
		var value = combo.getValue();
		
		if( value!=null && value!=""){
			ambitoStore.webflow({id:combo.getValue()});
			ambitoExpediente.setDisabled(false);
		}
		else{
			ambitoExpediente.setDisabled(true);
		}
		
		ambitoExpediente.clearValue();
		
	});
	
	<pfs:hidden name="estado" value="${estado.id}"/>
	<pfs:defineParameters name="parametros" paramId="" 
		estado="estado"
		ddTipoReglasElevacion="ddTipoReglasElevacion"
		ambitoExpediente="ambitoExpediente"
		/>
		
	<pfs:editForm saveOrUpdateFlow="plugin/itinerarios/plugin.itinerarios.guardaReglasElevacionEstado"
		leftColumFields="ddTipoReglasElevacion,ambitoExpediente"
		rightColumFields=""
		parameters="parametros" />

</fwk:page>