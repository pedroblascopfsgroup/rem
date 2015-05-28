<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	Ext.util.CSS.createStyleSheet(".icon_comite { background-image: url('../img/plugin/comites/user-business.png');}");
	
	<pfsforms:textfield name="filtroNombre"
			labelKey="plugin.comites.busqueda.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
			
	<pfsforms:textfield name="filtroAtribucionMin"
			labelKey="plugin.comites.busqueda.atribucionMin" label="**Atribución mínima"
			value="" searchOnEnter="true" />
			
	<pfsforms:textfield name="filtroAtribucionMax"
			labelKey="plugin.comites.busqueda.atribucionMax"
			label="**Atribución máxima" value="" searchOnEnter="true" />
		
	<pfsforms:ddCombo name="filtroItinerario"
		labelKey="plugin.comites.busqueda.itinerario"
		label="**Usuario Externo" value="" dd="${itinerarios}" 
		propertyCodigo="id" propertyDescripcion="nombre" />	
			
			
	<pfs:dblselect name="filtroPerfil"
			labelKey="plugin.comites.busqueda.perfiles" label="**Perfiles"
			dd="${perfiles}" width="160" height="100"/>
			
	<pfs:ddCombo name="comboJerarquia" 
		labelKey="plugin.comites.busqueda.control.comboJerarquia" label="**Jerarquia"
		value="" dd="${niveles}" />
	
				
	 var zonasRecord = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
    
    var optionsZonasStore = page.getStore({
	       flow: 'plugin/comites/plugin.comites.buscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, zonasRecord)
	       
	});
	
	<pfs:dblselect name="filtroCentro"
			labelKey="plugin.comites.busqueda.control.filtroCentro" label="**Centro"
			dd="${zonas}" width="160" height="120" store="optionsZonasStore"/>
	
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
	}
	
	comboJerarquia.on('select',limpiarYRecargar);
 
	
	<pfs:defineRecordType name="ComitesRT">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="atribucionMinima" />
			<pfs:defineTextColumn name="atribucionMaxima" />
			<pfs:defineTextColumn name="prioridad" />
			<pfs:defineTextColumn name="miembros" />
			<pfs:defineTextColumn name="miembrosRestrict" />
	</pfs:defineRecordType>
			
	<pfs:defineColumnModel name="comitesCM">
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.comites.busqueda.nombre" caption="**Nombre"
			sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="atribucionMinima"
			captionKey="plugin.comites.busqueda.atribucionMin" caption="**Atribución mínima"
			sortable="true" />
		<pfs:defineHeader dataIndex="atribucionMaxima"
			captionKey="plugin.comites.busqueda.atribucionMax" caption="**Atribución máxima"
			sortable="true" />
		<pfs:defineHeader dataIndex="prioridad"
			captionKey="plugin.comites.busqueda.prioridad" caption="**Prioridad"
			sortable="true" />
		<pfs:defineHeader dataIndex="miembros"
			captionKey="plugin.comites.busqueda.miembros" caption="**Número de miembros"
			sortable="true" />
		<pfs:defineHeader dataIndex="miembrosRestrict"
			captionKey="plugin.comites.busqueda.miembrosRestrictivos"
			caption="**Número de miembros restrictivos" sortable="true" />
		<%--<pfs:defineHeader dataIndex="entidad"
			captionKey="plugin.config.usuarios.field.entidad" caption="**Entidad"
			sortable="true" />--%>
	</pfs:defineColumnModel>
	
	
	<pfs:defineParameters name="getParametros" paramId="" 
		nombre="filtroNombre" atribucionMinima="filtroAtribucionMin" 
		atribucionMaxima="filtroAtribucionMax" itinerario="filtroItinerario" 
		perfiles="filtroPerfil" centros="filtroCentro" />
	
	<pfs:buttonremove name="btBorrar" 
		novalueMsg="**Debe seleccionar un valor de la tabla" 
		flow="plugin/comites/plugin.comites.borraComite" 
		paramId="id"  
		datagrid="comitesGrid" 
		novalueMsgKey="plugin.comites.busqueda.borrar.noValor"
		parameters="getParametros"/>
	
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
			
	<pfs:searchPage searchPanelTitle="**Búsqueda de Comités"  searchPanelTitleKey="plugin.comites.busqueda.panel.title" 
			columnModel="comitesCM" columns="2"
			gridPanelTitleKey="plugin.comites.busqueda.grid.title" gridPanelTitle="**Comités" 
			createTitleKey="plugin.comités.alta.windowTitle" createTitle="**Nuevo comité" 
			createFlow="plugin.comites.altaComite" 
			updateFlow="plugin.comites.consultarComite" 
			updateTitleData="nombre"
			dataFlow="plugin.comites.buscaComitesData"
			resultRootVar="comites" resultTotalVar="total"
			recordType="ComitesRT" 
			parameters="getParametros" 
			newTabOnUpdate="true"
			emptySearch="true"
			gridName="comitesGrid"
			buttonDelete="btBorrar "
			iconCls="icon_comite" >
			<pfs:items
			items="filtroNombre,filtroAtribucionMin,filtroAtribucionMax,filtroPerfil"
			/>
			<pfs:items
			items="filtroItinerario,comboJerarquia,filtroCentro" 
			/>
			
	</pfs:searchPage>
	btnNuevo.hide();
	<sec:authorize ifAllGranted="ROLE_ADDCOMITE">
		btnNuevo.show();
	</sec:authorize>
	btBorrar.hide();
	<sec:authorize ifAllGranted="ROLE_BORRACOMITE">
		btBorrar.show();
	</sec:authorize>

	filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());
	
</fwk:page>


