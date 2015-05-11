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
	
	<pfs:hidden name="ESTADO_DEFINICION" value="${ESTADO_DEFINICION}"/>
	<pfs:hidden name="ESTADO_BLOQUEADO" value="${ESTADO_BLOQUEADO}"/>
	<pfs:hidden name="ESTADO_DISPONIBLE" value="${ESTADO_DISPONIBLE}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>
	
	<pfs:textfield name="filtroNombre"
			labelKey="plugin.recobroConfig.itinerario.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
			
	filtroNombre.id='filtroNombreRecobroListaItinerarios';		
			
	<pfsforms:ddCombo name="filtroEsquema"
		labelKey="plugin.recobroConfig.recobroagencia.esquema"
		label="**Esquema" value="" dd="${listaEsquemas}" propertyCodigo="id" propertyDescripcion="nombre"/>	

	filtroEsquema.id='filtroEsquemaRecobroListaItinerarios';	
		
	<pfsforms:ddCombo name="filtroEstado"
		labelKey="plugin.recobroConfig.cartera.listado.estado"
		label="**Estado" value="" dd="${ddEstado}" propertyCodigo="id" propertyDescripcion="descripcion"/>	
		
			
	filtroEstado.id='filtroEstadoRecobroListaItinerarios';			
			
	<pfs:defineRecordType name="recobroItinerario">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="fechaAlta" />
			<pfs:defineTextColumn name="plazoMaxGestion" />
			<pfs:defineTextColumn name="plazoSinGestion" />
			<pfs:defineTextColumn name="estado" />
			<pfs:defineTextColumn name="codigoEstado" />
			<pfs:defineTextColumn name="propietario" />
			<pfs:defineTextColumn name="idPropietario" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="itinerariosCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.itinerario.columna.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.itinerario.columna.nombre" caption="**Nombre"
			sortable="true" />
		<pfs:defineHeader dataIndex="fechaAlta"
			captionKey="plugin.recobroConfig.itinerario.columna.fechaAlta" caption="**Fecha creación"
			sortable="true" />
		<pfs:defineHeader dataIndex="plazoMaxGestion"
			captionKey="plugin.recobroConfig.itinerario.columna.plazoMaxGestion" caption="**Plazo máximo gestión"
			sortable="true" />
		<pfs:defineHeader dataIndex="plazoSinGestion"
			captionKey="plugin.recobroConfig.itinerario.columna.plazoGestionSin" caption="**Plazo sin gestión"
			sortable="true" />
		<pfs:defineHeader dataIndex="estado"
			captionKey="plugin.recobroConfig.politicaAcuerdos.columna.estado" caption="**Estado"
			sortable="true" />
		<pfs:defineHeader dataIndex="propietario"
			captionKey="plugin.recobroConfig.politicaAcuerdos.columna.propietario" caption="**Propietario"
			sortable="true" />					
	</pfs:defineColumnModel>
	
	<pfs:defineParameters name="getParametros" paramId="" 
		nombre="filtroNombre" idEsquema="filtroEsquema" idEstado="filtroEstado"/>
	
	<pfs:buttonremove name="btBorrar" 
		novalueMsg="**Debe seleccionar un valor de la tabla" 
		flow="recobroitinerario/eliminaItinerarioRecobro" 
		paramId="id"  
		datagrid="itinerariosGrid" 
		novalueMsgKey="plugin.recobroConfig.recobroagencia.borrar.noValor"
		parameters="getParametros"/>
		
	var btCopiar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />'
		,iconCls : 'icon_copy'
		,id: 'btCopiarOpenRecobroListaItinerarios'
		,disabled : true
		,handler : function(){
			if (itinerariosGrid.getSelectionModel().getCount()>0){
    					var parms = getParametros();
    					parms.id = itinerariosGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobroitinerario/copiarItinerarioMetasVolantes'
							,params: parms
							,success : function(){ 
								itinerariosGrid.store.webflow(parms);
							}
						});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />','<s:message code="plugin.recobroConfig.itineraio.noSeleccionado" text="**Debe seleccionar el itinerario que desea copiar" />');
			}
		}
	});	
		
	<pfs:searchPage searchPanelTitle="**Búsqueda de Itinerarios de Metas Volantes"  searchPanelTitleKey="plugin.recobroConfig.itinerario.titulo" 
			columnModel="itinerariosCM" columns="5"
			gridPanelTitleKey="plugin.recobroConfig.itinerario.grid.title" gridPanelTitle="**Itinerarios de Metas Volantes" 
			createTitleKey="plugin.recobroConfig.itinerario.alta.windowTitle" createTitle="**Nuevo Itinerario" 
			createFlow="recobroitinerario/altaItinerarioRecobro" 
			updateFlow="recobroitinerario/openItinerarioRecobro" 
			updateTitleData="nombre"
			dataFlow="recobroitinerario/buscaItinerariosRecobro"
			resultRootVar="itinerarios" resultTotalVar="total"
			recordType="recobroItinerario" 
			parameters="getParametros" 
			newTabOnUpdate="true"
			emptySearch="true"
			gridName="itinerariosGrid"
			buttonDelete="btBorrar, btCopiar"
			iconCls="icon_metas"
			>
			<pfs:items
			items="filtroNombre,filtroEsquema "
			/>
			<pfs:items
			items="filtroEstado" 
			/>	
	</pfs:searchPage>
	
	itinerariosGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e){
    	var rec = itinerariosGrid.getStore().getAt(rowIndex);
    	var idItinerario = rec.get('id');
    	var codigoEstado = itinerariosGrid.getSelectionModel().getSelected().get('codigoEstado');
    	var idPropietario = itinerariosGrid.getSelectionModel().getSelected().get('idPropietario');
    	if (codigoEstado == ESTADO_BLOQUEADO.getValue()){
    		btBorrar.setDisabled(true);
    		btCopiar.setDisabled(false);
    	} else {
    		if (idPropietario != usuarioLogado.getValue()){
    			btBorrar.setDisabled(true);
    		} else {
    			btBorrar.setDisabled(false);
    		}
    		if (codigoEstado == ESTADO_DEFINICION.getValue()){
    			btCopiar.setDisabled(true);
    		} else {
    			btCopiar.setDisabled(false);
    		}
    	}
    });	
	
	btBorrar.hide();
	btnNuevo.hide();
	
	<sec:authorize ifAllGranted="ROLE_CONF_METAS">
		btnNuevo.show();
		btBorrar.show();
	</sec:authorize>
	
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight()); 
	
</fwk:page>	