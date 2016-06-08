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
	<pfs:textfield name="filtroNombre"
			labelKey="plugin.recobroConfig.recobroagencia.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
			
	<pfsforms:ddCombo name="filtroEsquema"
		labelKey="plugin.recobroConfig.recobroagencia.esquema"
		label="**Esquema" value="" dd="${listaEsquemas}" propertyCodigo="id" propertyDescripcion="nombre"/>	
			
	<pfs:defineRecordType name="Agencia">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="nif" />
			<pfs:defineTextColumn name="denominacionFiscal" />
			<pfs:defineTextColumn name="contactoNombreApellido" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="agenciasCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.recobroagencia.columna.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.recobroagencia.columna.nombre" caption="**Nombre"
			sortable="true" />
		<pfs:defineHeader dataIndex="nif"
			captionKey="plugin.recobroConfig.recobroagencia.columna.nif" caption="**Nif"
			sortable="true" />
		<pfs:defineHeader dataIndex="denominacionFiscal"
			captionKey="plugin.recobroConfig.recobroagencia.columna.denominacionFiscal" caption="**Denominación fiscal"
			sortable="true" />
		<pfs:defineHeader dataIndex="contactoNombreApellido"
			captionKey="plugin.recobroConfig.recobroagencia.columna.contactoNombre" caption="**Nombre de contacto"
			sortable="false" />					
	</pfs:defineColumnModel>
	
	<pfs:defineParameters name="getParametros" paramId="" 
		nombre="filtroNombre" idEsquema="filtroEsquema" />
	
	<pfs:buttonremove name="btBorrar" 
		novalueMsg="**Debe seleccionar un valor de la tabla" 
		flow="recobroagencia/borrarAgencia" 
		paramId="id"  
		datagrid="agenciasGrid" 
		novalueMsgKey="plugin.recobroConfig.recobroagencia.borrar.noValor"
		parameters="getParametros"/>
		
	var btnNuevoRecargar = app.crearBotonAgregar({
		flow : 'recobroagencia/crearAgencia'
		,title : '<s:message code="plugin.recobroConfig.recobroagencia.alta.windowTitle" text="**Nueva agencia" />'
		,text : '<s:message code="plugin.recobroConfig.recobroagencia.alta.windowTitle" text="**Nueva agencia" />'
		,params : {}
		,success : function(){ 
								agenciasGrid.store.webflow(getParametros());
								filtroForm.collapse(true);
							}
		,width: 700
		//,closable:true
		,iconCls:'icon_agencias'
	});	
	
	var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a Excel" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
        			btnExportarXls.setDisabled(true)
					var params=getParametros();
					var flow='agencia/exportAgencia';
	        		//var flow='recobroagencia/buscarAgencia';
	        		params.tiempoSuccess=<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.XLS_WAIT_TIME" />;
					params.succesFunction=function(){btnExportarXls.setDisabled(false)}
	        		app.openBrowserWindow(flow,params);	
                }
             }
        );
		
	<pfs:searchPage searchPanelTitle="**Configuración de Agencias de Recobro"  searchPanelTitleKey="plugin.recobroConfig.recobroagencia.searchpanel.title" 
			columnModel="agenciasCM" columns="2"
			gridPanelTitleKey="plugin.recobroConfig.recobroagencia.grid.title" gridPanelTitle="**Agencias" 
			createTitleKey="plugin.recobroConfig.recobroagencia.alta.windowTitle" createTitle="**Nueva agencia" 
			createFlow="recobroagencia/crearAgencia" 
			updateFlow="recobroagencia/actualizarAgencia" 
			updateTitleData="nombre"
			dataFlow="recobroagencia/buscarAgencia"
			resultRootVar="agencias" resultTotalVar="total"
			recordType="Agencia" 
			parameters="getParametros" 
			newTabOnUpdate="false"
			iconCls="icon_agencias"
			emptySearch="true"
			gridName="agenciasGrid"
			buttonDelete="btBorrar ">
			<pfs:items
			items="filtroNombre"
			/>
			<pfs:items
			items="filtroEsquema" 
			/>
	</pfs:searchPage>	
	
	filtroForm.getTopToolbar().add(btnExportarXls);
	
	btBorrar.hide();
	btnNuevo.hide();
	btnNuevoRecargar.hide();
	filtroForm.getTopToolbar().add(btnNuevoRecargar);
	
	<sec:authorize ifAllGranted="ROLE_CONF_AGENCIAS">
		btnNuevoRecargar.show();
		btBorrar.show();
	</sec:authorize>
	
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight()); 
	
</fwk:page>	