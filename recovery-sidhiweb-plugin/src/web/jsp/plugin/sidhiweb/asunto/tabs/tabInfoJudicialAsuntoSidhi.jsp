<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="metaform" tagdir="/WEB-INF/tags/pfs/metaform" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


(function(){
	
	<pfs:defineRecordType name="infoJudicial">
		<pfs:defineTextColumn name="idAccion"/>
		<pfs:defineTextColumn name="idExpedienteExterno"/> 
		<pfs:defineTextColumn name="tipoProcedimientoJudicial"/>
		<pfs:defineTextColumn name="usernameProcurador"/>
		<pfs:defineTextColumn name="codigo"/>
		<pfs:defineTextColumn name="plaza"/>
		<pfs:defineTextColumn name="juzgado"/>
		<pfs:defineTextColumn name="numeroAutos"/>
		<pfs:defineTextColumn name="fechaAccion"/>
		<pfs:defineTextColumn name="estadoProcesal"/>
		<pfs:defineTextColumn name="subEstadoProcesal"/>
		<pfs:defineTextColumn name="tipoValor"/>
		<pfs:defineTextColumn name="valor"/>
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="infoJudicialCm">
		<%-- <pfs:defineHeader dataIndex="idExpedienteExterno" captionKey="plugin.sidhi.tabInfoJudicial.idExpediente" 
			caption="**Id expediente externo"  firstHeader="true" sortable="false"/> --%>
		<pfs:defineHeader dataIndex="idAccion" captionKey="plugin.sidhi.tabInfoJudicial.idAccion" 
			caption="**Id acción" sortable="false" width="50" firstHeader="true"/>		
		<pfs:defineHeader dataIndex="codigo" captionKey="plugin.sidhi.tabInfoJudicial.codigo" 
			caption="**Código" sortable="false" width="50" />	 
		<pfs:defineHeader dataIndex="estadoProcesal" captionKey="plugin.sidhi.tabInfoJudicial.estadoProcesal" 
			caption="**Estado procesal" sortable="false"  />
		<pfs:defineHeader dataIndex="plaza" captionKey="plugin.sidhi.tabInfoJudicial.plaza" 
			caption="**plaza" sortable="false" hidden="true"/>
		<pfs:defineHeader dataIndex="juzgado" captionKey="plugin.sidhi.tabInfoJudicial.juzgado" 
			caption="**juzgado" sortable="false" hidden="true"/>
		<pfs:defineHeader dataIndex="numeroAutos" captionKey="plugin.sidhi.tabInfoJudicial.numeroAutos" 
			caption="**numero autos" sortable="false" hidden="true"/>
		<pfs:defineHeader dataIndex="fechaAccion" captionKey="plugin.sidhi.tabInfoJudicial.fechaAccion" 
			caption="**fecha accion" sortable="true" />
		<pfs:defineHeader dataIndex="usernameProcurador" captionKey="plugin.sidhi.tabInfoJudicial.procurador" 
			caption="**procurador" sortable="false" hidden="true"/>
		<pfs:defineHeader dataIndex="subEstadoProcesal" captionKey="plugin.sidhi.tabInfoJudicial.subEstadoProcesal" 
			caption="**SubEstado procesal" sortable="false"  hidden="true"/>
		<pfs:defineHeader dataIndex="tipoValor" captionKey="plugin.sidhi.tabInfoJudicial.tipoValor" 
			caption="** Tipo Valor" sortable="false"  />	
		<pfs:defineHeader dataIndex="valor" captionKey="plugin.sidhi.tabInfoJudicial.valor" 
			caption="**Valor" sortable="false" width="200"/>
	</pfs:defineColumnModel>
	
	
	<pfs:defineParameters name="param" paramId="${asunto.id}" />
	
	
	<pfs:remoteStore name="infoJudicalStore" 
		resultRootVar="acciones" 
		recordType="infoJudicial" 
		dataFlow="sidhiinfojudicial/getInfoJudicialAsunto"
		parameters="param"
		resultTotalVar="total"
		autoload="true"/>
	
	var pagina=fwk.ux.getPaging(infoJudicalStore);
	
	<pfs:grid  name="infoJudicialGrid" 
		dataStore="infoJudicalStore" 
		columnModel="infoJudicialCm" 
		title="**Informacion Judicial" 
		collapsible="false" 
		titleKey="plugin.sidhi.tabInfoJudicial.grid.titulo"
		bbar ="pagina"/>
	
	var panel = new Ext.Panel({
		title:'<s:message code="plugin.sidhi.tabInfoJudicial.titulo" text="**Informacion Judicial"/>'
		,autoHeight:true
		,bodyStyle:'padding: 5px'
		,items:[
				infoJudicialGrid
			]
		,nombreTab : 'informacionJudicial'
	});
	return panel;

})()