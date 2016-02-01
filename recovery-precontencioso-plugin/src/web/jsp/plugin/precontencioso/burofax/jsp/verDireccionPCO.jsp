<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	<%-- var panelWidth=800;
	var labelStyle='width:100px';--%>
	var idCliente = "${idCliente}";
	var idProcedimiento = "${idProcedimiento}";
	var idDireccion = "${idDireccion}";
	//var idContrato = "${idContrato}";	
	var valorProvincia = "${valorProvincia}";
	var valorProvinciaTexto = "${valorProvinciaTexto}";
	var valorCodigoPostal = "${valorCodigoPostal}";
	var valorLocalidad = "${valorLocalidad}";
	var valorLocalidadTexto = "${valorLocalidadTexto}";
	var valorMunicipio = "${valorMunicipio}";
	var valorTipoVia = "${valorTipoVia}";
	var valorDomicilio = "${valorDomicilio}";
	var valorNumero = "${valorNumero}";
	var valorPortal = "${valorPortal}";
	var valorPiso = "${valorPiso}";
	var valorEscalera = "${valorEscalera}";
	var valorPuerta = "${valorPuerta}";

	
	var myStore = new Ext.data.ArrayStore({
    fields: [ 'domicilio', 'numeroDomicilio', 'portal', 'piso', 'escalera', 'puerta', 'codPostal', 'localidad', 'provincia', 'municipio'],
    idIndex: 0 // id for each record will be the first element
	});
	var myData = [
    [valorDomicilio, valorNumero, valorPortal, valorPiso, valorEscalera, valorPuerta, valorCodigoPostal, valorLocalidadTexto, valorProvinciaTexto, valorMunicipio]
    ];
	myStore.loadData(myData);
	var gridDireccion = new Ext.grid.GridPanel({
		title: '<s:message code="plugin.precontencioso.grid.burofax.ver.direccion" text="**Dirección" />'
		,store: myStore
		,columns: [
			{header: 'Domicilio', width: 180, sortable: true, dataIndex: 'domicilio'},
			{header: 'Nº Domicilio', width: 100, sortable: true, dataIndex: 'numeroDomicilio'},
			{header: 'Portal', width: 60, sortable: true, dataIndex: 'portal'},
			{header: 'Piso', width: 60, sortable: true, dataIndex: 'piso'},
			{header: 'Escalera', width: 60, sortable: true, dataIndex: 'escalera'},
			{header: 'Puerta', width: 60, sortable: true, dataIndex: 'puerta'},
			{header: 'Cod. Postal', width: 60, sortable: true, dataIndex: 'codPostal'},
			{header: 'Localidad', width: 100, sortable: true, dataIndex: 'localidad'},
			{header: 'Provincia  ', width: 100, sortable: true, dataIndex: 'provincia'},
			{header: 'Municipio', width: 100, sortable: true, dataIndex: 'municipio'}
		]
		,height: 140
		,width: 920
	});

	page.add(gridDireccion);

	
</fwk:page>