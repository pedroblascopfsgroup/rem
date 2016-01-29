<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfshandler" tagdir="/WEB-INF/tags/pfs/handler"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<fwk:page> 

<pfs:defineRecordType name="Historico">
	<pfs:defineTextColumn name="usuario"/>
	<pfs:defineTextColumn name="accion"/>
	<pfs:defineTextColumn name="fecha"/>
	<pfs:defineTextColumn name="valorAnterior"/>
	<pfs:defineTextColumn name="valorNuevo"/>
</pfs:defineRecordType>

<pfs:defineParameters name="diccionarioParams" paramId="${diccionario.id}"/>

<pfs:remoteStore name="storeHistorico"
				dataFlow="plugin/diccionarios/diccionariosDatos/DIChistoricoDiccionariosData"
 				resultRootVar="historico"
 				recordType="Historico" 
 				parameters="diccionarioParams"
 				autoload="true"/>

<pfs:defineColumnModel name="columnasHistorico">
	<pfs:defineHeader dataIndex="usuario" captionKey="plugin.diccionarios.messages.columnaUsuario" caption="**Usuario" sortable="true" firstHeader="true"/>
	<pfs:defineHeader dataIndex="accion" captionKey="plugin.diccionarios.messages.columnaAccion" caption="**Acción" sortable="true" width="30"/>
	<pfs:defineHeader dataIndex="fecha" captionKey="plugin.diccionarios.messages.columnaFecha" caption="**Fecha" sortable="true" width="30"/>
	<pfs:defineHeader dataIndex="valorAnterior" captionKey="plugin.diccionarios.messages.columnaAnterior" caption="**Valor Anterior" sortable="true" width="60"/>
	<pfs:defineHeader dataIndex="valorNuevo" captionKey="plugin.diccionarios.messages.columnaNuevo" caption="**Valor Nuevo" sortable="true" width="60"/>
</pfs:defineColumnModel>

<pfs:grid name="historicoGrid" 
	dataStore="storeHistorico" 
	columnModel="columnasHistorico" 
	title="**Historico de actuaciones" 
	titleKey="plugin.diccionarios.messages.tituloGridHistorico"
	collapsible="false"
	autoexpand="true"
	width="1135"
	 />
	


var panel = new Ext.Panel({
	    items : [
	    	historicoGrid
	    ]
	    //,bodyStyle: 'padding: 10px'
	    ,border:false
	    ,width:800
	    ,autoHeight : true
	    ,border: false  
});
page.add(panel);	
</fwk:page>