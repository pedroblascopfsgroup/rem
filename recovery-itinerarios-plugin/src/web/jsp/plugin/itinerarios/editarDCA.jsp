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

	<pfsforms:check labelKey="plugin.itinerarios.estados.automatico" label="**Automático" 
		name="automatico" value="${dcaSiNo}"  />

	<pfsforms:ddCombo name="gestor"
		labelKey="plugin.itinerarios.dca.gestor"
		label="**Gestor" value="${dca.gestor.id}" dd="${gestores}" 
		obligatory="true" propertyCodigo="id" propertyDescripcion="usuario"/>
	
	<pfsforms:ddCombo name="supervisor"
		labelKey="plugin.itinerarios.dca.supervisor"
		label="**Supervisor" value="${dca.supervisor.id}" dd="${supervisores}" 
		obligatory="true" propertyCodigo="id" propertyDescripcion="usuario" />
		
	<pfsforms:ddCombo name="comite"
		labelKey="plugin.itinerarios.dca.comite"
		label="**Comité" value="${dca.comite.id}" dd="${comites}" 
		obligatory="true" propertyCodigo="id" propertyDescripcion="nombre"/>
		
	<pfsforms:ddCombo name="tipoActuacion"
		labelKey="plugin.itinerarios.dca.tipoActuacion"
		label="**Tipo de Actuación" value="${dca.tipoActuacion.id}" dd="${tiposActuacion}" 
		   />
		
	<pfsforms:ddCombo name="tipoReclamacion"
		labelKey="plugin.itinerarios.dca.tipoReclamacion"
		label="**Tipo de Reclamación" value="${dca.tipoReclamacion.id}" dd="${tiposReclamacion}" 
		/>
		
	<pfsforms:ddCombo name="tipoProcedimiento"
		labelKey="plugin.itinerarios.dca.tipoProcedimiento"
		label="**Tipo de Procedimiento" value="${dca.tipoProcedimiento.id}" dd="${tiposProcedimiento}" 
		 />

	<pfsforms:numberfield name="porcentajeRecuperacion" labelKey="plugin.itinerarios.dca.porcentajeRecuperacion"
		label="**Plazo Inicial" value="${dca.porcentajeRecuperacion}" allowDecimals="false" allowNegative="false"
		/>
		
	<pfsforms:numberfield name="plazoRecuperacion" labelKey="plugin.itinerarios.dca.plazoRecuperacion"
		label="**Plazo de Recuperación" value="${dca.plazoRecuperacion}" allowNegative="false" allowDecimals="true" />
	
	<%-- 
	plazoRecuperacion.setValue(Math.round(${dca.plazoRecuperacion / 86400000 }));
		--%>
	
	<pfsforms:check labelKey="plugin.itinerarios.dca.aceptacionAutomatico" 
		label="**Automático" name="aceptacionAutomatico" value="${dca.aceptacionAutomatico}"/>
	
	gestor.setDisabled(true);
	supervisor.setDisabled(true);
	comite.setDisabled(true);
	tipoActuacion.setDisabled(true);
	tipoReclamacion.setDisabled(true);
	tipoProcedimiento.setDisabled(true);
	porcentajeRecuperacion.setDisabled(true);
	plazoRecuperacion.setDisabled(true);
	aceptacionAutomatico.setDisabled(true);
	
	if (automatico.checked == true){
			gestor.setDisabled(false);
			supervisor.setDisabled(false);
			comite.setDisabled(false);
			tipoActuacion.setDisabled(false);
			tipoReclamacion.setDisabled(false);
			tipoProcedimiento.setDisabled(false);
			porcentajeRecuperacion.setDisabled(false);
			plazoRecuperacion.setDisabled(false);
			aceptacionAutomatico.setDisabled(false);
		}else{
			gestor.setDisabled(true);
			supervisor.setDisabled(true);
			comite.setDisabled(true);
			tipoActuacion.setDisabled(true);
			tipoReclamacion.setDisabled(true);
			tipoProcedimiento.setDisabled(true);
			porcentajeRecuperacion.setDisabled(true);
			plazoRecuperacion.setDisabled(true);
			aceptacionAutomatico.setDisabled(true);
		}
	
			
	automatico.on('check',function(){
		if (automatico.getValue() == true){
			gestor.setDisabled(false);
			supervisor.setDisabled(false);
			comite.setDisabled(false);
			tipoActuacion.setDisabled(false);
			tipoReclamacion.setDisabled(false);
			tipoProcedimiento.setDisabled(false);
			porcentajeRecuperacion.setDisabled(false);
			plazoRecuperacion.setDisabled(false);
			aceptacionAutomatico.setDisabled(false);
		}else{
			gestor.setDisabled(true);
			supervisor.setDisabled(true);
			comite.setDisabled(true);
			tipoActuacion.setDisabled(true);
			tipoReclamacion.setDisabled(true);
			tipoProcedimiento.setDisabled(true);
			porcentajeRecuperacion.setDisabled(true);
			plazoRecuperacion.setDisabled(true);
			aceptacionAutomatico.setDisabled(true);
		}
	});	
	
	<pfs:hidden name="estado" value="${estado.id}"/>
	
	<pfs:defineParameters name="parametros" paramId="${dca.id}"
		automatico ="automatico"
		estado ="estado" 
		gestor="gestor"
		supervisor="supervisor"
		comite="comite"
		tipoActuacion="tipoActuacion"
		tipoReclamacion="tipoReclamacion"
		tipoProcedimiento="tipoProcedimiento"
		porcentajeRecuperacion="porcentajeRecuperacion"
		plazoRecuperacion="plazoRecuperacion"
		aceptacionAutomatico="aceptacionAutomatico"
		/>
	
	var mensaje ={
			html:'**El plazo de recuperación se muestra en meses'
			,border: false
			,style:'font-weight:bolder;font-size:0.6em;color:#00008B'
	};
			
	<pfs:editForm saveOrUpdateFlow="plugin/itinerarios/plugin.itinerarios.guardaDCA"
		leftColumFields="automatico,gestor,supervisor,comite,tipoActuacion,tipoReclamacion,mensaje"
		rightColumFields="tipoProcedimiento,porcentajeRecuperacion,plazoRecuperacion,aceptacionAutomatico"
		parameters="parametros" 
		/>

</fwk:page>