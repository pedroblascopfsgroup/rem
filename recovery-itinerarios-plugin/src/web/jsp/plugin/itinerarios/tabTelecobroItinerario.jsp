<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<pfslayout:tabpage titleKey="plugin.itinerarios.telecobro.titulo" title="**Datos Telecobro" 
	items="panel" >
	
	 
	Ext.util.CSS.createStyleSheet(".icon_telecobro { background-image: url('../img/plugin/itinerarios/telephone.png');}");
	Ext.util.CSS.createStyleSheet("button.icon_asociaTelecobro { background-image: url('../img/plugin/itinerarios/coins-add.png');}");
	
	<pfsforms:check labelKey="plugin.itinerarios.estados.telecobro" label="**Telecobro" 
		name="telecobro" value="${siNo}" readOnly="true"/>
	telecobro.setDisabled(true);
			
	<pfsforms:textfield labelKey="plugin.itinerarios.telecobro.proveedor" label="**Proveedor" 
		name="proveedor" value="${telecobro.proveedor.nombre}" readOnly="true" />
		 
	<pfsforms:textfield labelKey="plugin.itinerarios.telecobro.plazoInicial" label="**Plazo inicial" 
		name="plazoInicial" value="${telecobro.plazoInicial / 86400000}" readOnly="true"/>
		
	<pfsforms:textfield labelKey="plugin.itinerarios.telecobro.plazoFinal" label="**Plazo Final" 
		name="plazoFinal" value="${telecobro.plazoFinal / 86400000}" readOnly="true"/>
		
	<pfsforms:textfield labelKey="plugin.itinerarios.telecobro.diasAntelacion" label="**Días de Antelacion" 
		name="diasAntelacion" value="${telecobro.diasAntelacion / 86400000}" readOnly="true"/>
	
	<pfsforms:textfield labelKey="plugin.itinerarios.telecobro.plazoRespuesta" label="**Plazo de respuesta" 
		name="plazoRespuesta" value="${telecobro.plazoRespuesta / 86400000}" readOnly="true"/>
		
	 <pfsforms:check labelKey="plugin.itinerarios.telecobro.automatico" label="**Automático" 
	 	name="automatico" value="${telecobro.automatico}" readOnly="true"/> 
	automatico.setDisabled(true);
	  
	<pfs:defineParameters name="modTelecobroParams" paramId="${itinerario.id}" />
	
	if (telecobro.checked == true){
			proveedor.setDisabled(false);
			plazoInicial.setDisabled(false);
			plazoFinal.setDisabled(false);
			diasAntelacion.setDisabled(false);
			plazoRespuesta.setDisabled(false);
			automatico.setDisabled(false);
		}else{
			proveedor.setDisabled(true);
			plazoInicial.setDisabled(true);
			plazoFinal.setDisabled(true);
			diasAntelacion.setDisabled(true);
			plazoRespuesta.setDisabled(true);
			automatico.setDisabled(true);
		}
	
	var recargar = function (){
		app.openTab('${itinerario.nombre}'
					,'plugin.itinerarios.consultaItinerario'
					,{id:${itinerario.id}}
					,{id:'ItinerarioRT${itinerario.id}'}
				)
	};
	
	
	 <%--
	<pfs:buttonnew name=""  createTitle="**Nuevo Telecobro" 
		createTitleKey="plugin.itinerarios.telecobro.nuevo" 
		flow="plugin.itinerarios.nuevoEstadoTelecobro" 
		/>
	--%>
	
	<pfs:buttonedit flow="plugin.itinerarios.nuevoEstadoTelecobro" 
		name="btEditarTelecobro" windowTitleKey="plugin.itinerarios.telecobro.editar" 
		parameters="modTelecobroParams" windowTitle="**Editar Telecobro"
		on_success="recargar"/>

	
	
	
	<pfs:panel titleKey="plugin.itinerarios.telecobro.datos" name="panel" columns="2" 
		collapsible="" title="**Telecobro" bbar="btEditarTelecobro"  >
		<pfs:items items="telecobro,proveedor,plazoInicial,plazoFinal"/>
		<pfs:items items="diasAntelacion,plazoRespuesta,automatico"/>	
	</pfs:panel>
	
	panel.iconCls='icon_telecobro';
	
</pfslayout:tabpage>