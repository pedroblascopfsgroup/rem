<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfshandler" tagdir="/WEB-INF/tags/pfs/handler"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<fwk:page>


	<pfs:defineRecordType name="DespachoExterno">
		<pfs:defineTextColumn name="despacho" />
		<pfs:defineTextColumn name="tipoVia" />
		<pfs:defineTextColumn name="domicilio" />
		<pfs:defineTextColumn name="domicilioPlaza" />
		<pfs:defineTextColumn name="codigoPostal" />
		<pfs:defineTextColumn name="telefono1" />
		<pfs:defineTextColumn name="telefono2" />
	</pfs:defineRecordType>

	<pfs:remoteStore name="storeDespachosExternos"
		dataFlow="plugin/config/despachoExterno/ADMlistadoDespachosExternosData"
		resultRootVar="despachosExternos" recordType="DespachoExterno" autoload="true" />
		

	<pfs:defineColumnModel name="columnasDespachoExterno">
		<pfs:defineHeader dataIndex="despacho"
			captionKey="pfsadmin.listadodespachosexternos.despacho" caption="**Despacho"
			sortable="true" firstHeader="true" />
		<pfs:defineHeader dataIndex="tipoVia"
			captionKey="pfsadmin.listadodespachosexternos.tipoVia" caption="**Tipo de via"
			sortable="true" />
		<pfs:defineHeader dataIndex="domicilio"
			captionKey="pfsadmin.listadodespachosexternos.domicilio" caption="**Domicilio"
			sortable="true" />
		<pfs:defineHeader dataIndex="domicilioPlaza"
			captionKey="pfsadmin.listadodespachosexternos.domicilioPlaza" caption="**Número"
			sortable="true" />
		<pfs:defineHeader dataIndex="codigoPostal"
			captionKey="pfsadmin.listadodespachosexternos.codigoPostal" caption="**Codigo Postal"
			sortable="true" />	
		<pfs:defineHeader dataIndex="personaContacto"
			captionKey="pfsadmin.listadodespachosexternos.personaContacto" caption="**Persona de Contacto"
			sortable="true" />
		<pfs:defineHeader dataIndex="telefono1"
			captionKey="pfsadmin.listadodespachosexternos.telefono1" caption="**Telefono 1"
			sortable="true" />
		<pfs:defineHeader dataIndex="telefono2"
			captionKey="pfsadmin.listadodespachosexternos.telefono2"
			caption="**Telefono 2" sortable="true" />
	</pfs:defineColumnModel>

	<pfs:buttonnew name="btNuevo" flow="plugin/config/despachoExterno/ADMaltaDespachoExterno"
		createTitleKey="pfsadmin.altadespachoexterno" createTitle="**Nuevo despacho" onSuccess="function(){storeDespachosExternos.webflow()}" />
		
	<pfs:buttonremove name="btBorrar" 
		flow="plugin/config/despachoExterno/ADMborrarDespachoExterno" 
		paramId="idDespachoExterno" 
		datagrid="listadoGrid" 
		novalueMsg="**Debe seleccionar un despacho dela lista"  
		novalueMsgKey="pfsadmin.borrardespachoexterno.novalor"
		/>

	<pfshandler:editgridrow name="dblclickhandler" flow="plugin/config/despachoExterno/ADMconsultarDespachoExterno" titleField="despacho" tabId="despachoexterno" paramId="idDespachoExterno" />

	<pfs:grid name="listadoGrid" dataStore="storeDespachosExternos"
		columnModel="columnasDespachoExterno" title="**Listado de despachos externos"
		titleKey="pfsadmin.listadodespachosexternos" collapsible="false" 
		bbar="btNuevo,btBorrar" rowdblclick="dblclickhandler"
		iconCls="icon_despacho" />
		

var panel = new Ext.Panel({
	    items : [
	    	listadoGrid
	    ]
	    ,bodyStyle: 'padding: 10px'
	    ,border:false
	    ,autoHeight : true
	    ,border: false  
});
page.add(panel);	
</fwk:page>