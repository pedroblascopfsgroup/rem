<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<pfslayout:tabpage titleKey="plugin.itinerarios.dca.titulo" title="**Decisión Automática Comité" 
	items="panel" >
	
	 
	Ext.util.CSS.createStyleSheet(".icon_dca { background-image: url('../img/plugin/itinerarios/maza-juez.png');}");
	
	<pfsforms:check labelKey="plugin.itinerarios.estados.automatico" label="**Automático" 
		name="automatico" value="${dcaSiNo}" readOnly="true"/>
	automatico.setDisabled(true);
		
	<pfsforms:textfield labelKey="plugin.itinerarios.dca.gestor" label="**Gestor" 
		name="gestor" value="${dca.gestor.usuario.apellidoNombre}" readOnly="true"/>
	
	<pfsforms:textfield labelKey="plugin.itinerarios.dca.gestorDespacho" label="**Despacho" 
		name="gestorDespacho" value="${dca.gestor.despachoExterno.despacho}" readOnly="true"/>
		
	<pfsforms:textfield labelKey="plugin.itinerarios.dca.supervisor" label="**Supervisor" 
		name="supervisor" value="${dca.supervisor.usuario.apellidoNombre}" readOnly="true"/>
		
	<pfsforms:textfield labelKey="plugin.itinerarios.dca.comite" label="**Comité" 
		name="comite" value="${dca.comite.nombre}" readOnly="true"/>
		
	<pfsforms:textfield labelKey="plugin.itinerarios.dca.tipoActuacion" label="**Tipo de Actuación" 
		name="tipoActuacion" value="${dca.tipoActuacion.descripcion}" readOnly="true"/>
	
	<pfsforms:textfield labelKey="plugin.itinerarios.dca.tipoReclamacion" label="**Tipo de Reclamacion" 
		name="tipoReclamacion" value="${dca.tipoReclamacion.descripcion}" readOnly="true"/>
		
	<pfsforms:textfield labelKey="plugin.itinerarios.dca.tipoProcedimiento" label="**Tipo de Procedimiento" 
		name="tipoProcedimiento" value="${dca.tipoProcedimiento.descripcion}" readOnly="true"/>
		
	<pfsforms:textfield labelKey="plugin.itinerarios.dca.porcentajeRecuperacion" label="**Porcentaje de Recuperación" 
		name="porcentajeRecuperacion" value="${dca.porcentajeRecuperacion}" readOnly="true"/>
		
	<pfsforms:textfield labelKey="plugin.itinerarios.dca.plazoRecuperacion" label="**Plazo de Recuperación" 
		name="plazoRecuperacion" value="${dca.plazoRecuperacion }" readOnly="true" />
			
		
	 <pfsforms:check labelKey="plugin.itinerarios.dca.aceptacionAutomatico" label="**Aceptación Automático" 
	 	name="aceptacionAutomatico" value="${dca.aceptacionAutomatico}" readOnly="true"/> 
	aceptacionAutomatico.setDisabled(true);
	
	if (automatico.checked == true){
			gestor.setDisabled(false);
			gestorDespacho.setDisabled(false);
			supervisor.setDisabled(false);
			comite.setDisabled(false);
			tipoActuacion.setDisabled(false);
			tipoReclamacion.setDisabled(false);
			tipoProcedimiento.setDisabled(false);
			porcentajeRecuperacion.setDisabled(false);
			plazoRecuperacion.setDisabled(false);
			
		}else{
			gestor.setDisabled(true);
			gestorDespacho.setDisabled(true);
			supervisor.setDisabled(true);
			comite.setDisabled(true);
			tipoActuacion.setDisabled(true);
			tipoReclamacion.setDisabled(true);
			tipoProcedimiento.setDisabled(true);
			porcentajeRecuperacion.setDisabled(true);
			plazoRecuperacion.setDisabled(true);
			
		}
	


	<pfs:defineParameters name="modDCAParams" paramId="${itinerario.id}" />
	
	 
	var recargar = function (){
		app.openTab('${itinerario.nombre}'
					,'plugin.itinerarios.consultaItinerario'
					,{id:${itinerario.id}}
					,{id:'ItinerarioRT${itinerario.id}'}
				)
	};
	
		 <%-- 
	<pfs:buttonnew createTitleKey="plugin.itinerarios.dca.nuevoDca" 
		flow="plugin.itinerarios.nuevoDca" 
		name="btnAddDCA" 
		createTitle="**Nueva Decisión de Comité Automático"
		/>
	
	
	--%>
	<pfs:buttonedit name="btModificar" 
			flow="plugin/itinerarios/plugin.itinerarios.modificaDCA"  
			windowTitleKey="plugin.itinerarios.dca.modificar" 
			parameters="modDCAParams" 
			windowTitle="**Modificar Decision Comité Automático"
			on_success="recargar"
			 />
	
	<pfs:panel titleKey="plugin.itinerarios.dca.panel" name="panel" columns="2" collapsible="" 
		title="**Decisión de Comité Automática" bbar="btModificar"  >
		<pfs:items items="automatico,gestor,supervisor,gestorDespacho,comite,tipoActuacion"/>
		<pfs:items items="tipoReclamacion,tipoProcedimiento,porcentajeRecuperacion,plazoRecuperacion,aceptacionAutomatico"/>
		
	</pfs:panel>
	
	panel.iconCls='icon_dca';
	
</pfslayout:tabpage>