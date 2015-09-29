<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<fwk:page>

	<pfsforms:textfield name="nombre"
			labelKey="plugin.comites.busqueda.nombre" label="**Nombre"
			value="${comite.nombre}" readOnly="true" width="150"/>
	
	
	<pfsforms:textfield name="atribucionMinima"
			labelKey="plugin.comites.busqueda.atribucionMin" label="**Nombre"
			value="${comite.atribucionMinima}" readOnly="true" width="150"/>
			
	<pfsforms:textfield name="atribucionMaxima"
			labelKey="plugin.comites.busqueda.atribucionMax" label="**Atribución máxima"
			value="${comite.atribucionMaxima}" readOnly="true" width="150"/>	

	
	<pfsforms:textfield name="prioridad"
			labelKey="plugin.comites.busqueda.prioridad" label="**Prioridad"
			value="${comite.prioridad}" readOnly="true" width="150"/>	
	
	<pfsforms:textfield name="miembros"
			labelKey="plugin.comites.busqueda.miembros" label="**Número de miembros"
			value="${comite.miembros}" readOnly="true" width="150"/>	
	
	<pfsforms:textfield name="miembrosRestrict"
			labelKey="plugin.comites.busqueda.miembrosRestrictivos" label="**Número de miembros restrictivos"
			value="${comite.miembrosRestrict}" readOnly="true" width="150"/>	
	
	<pfsforms:textfield name="centro"
			labelKey="plugin.comites.busqueda.control.filtroCentro" label="**Centro"
			value="${comite.zona.descripcion}" readOnly="true" width="150"/>	
	
	 
	var recargar = function (){
		app.openTab('${comite.nombre}'
					,'plugin/comites/plugin.comites.consultarComite'
					,{id:${comite.id}}
					,{id:'ComitesRT${comite.id}'}
				)
	};
	<pfs:defineParameters name="parametros" paramId="${comite.id}" />
	
	<pfs:buttonedit flow="comites/plugin.comites.editarComite" name="btEditar" 
		windowTitleKey="plugin.comites.consulta.modificar" parameters="parametros" windowTitle="**Modificar"
		on_success="recargar"/>
		
	<pfs:panel name="panel1" columns="2" collapsible="true" bbar="btEditar" tbar="">
		<pfs:items items="nombre,atribucionMinima, atribucionMaxima,prioridad"  />
		<pfs:items items="miembros,miembrosRestrict,centro" />
	</pfs:panel>
	
	
	btEditar.hide();
	<sec:authorize ifAllGranted="ROLE_EDITCOMITE">
		btEditar.show();
	</sec:authorize>
	 
	<pfslayout:includetab name="tabPuestos" >
		<%@ include file="tabPuestosComite.jsp" %>
	</pfslayout:includetab>
		
		
	<pfslayout:includetab name="tabItinerarios">
		<%@ include file="tabItinerariosComite.jsp" %>
	</pfslayout:includetab>

	
	<pfslayout:tabpanel name="tabsComite" tabs="tabItinerarios,tabPuestos" />
	
	
	var compuesto = new Ext.Panel({
	    items : [
	    		{items:[panel1],border:false,style:'margin-top: 7px; margin-left:5px'}
	    		,{items:[tabsComite],border:false,style:'margin-top: 7px; margin-left:5px'}
	    	]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
	page.add(compuesto);
	

</fwk:page>