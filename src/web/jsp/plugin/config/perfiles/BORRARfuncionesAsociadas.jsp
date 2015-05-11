<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page> 


<pfs:defineRecordType name="Funcion">
	<pfs:defineTextColumn name="descripcionLarga"/>
	<pfs:defineTextColumn name="descripcion"/>
</pfs:defineRecordType>

<pfs:remoteStore name="storeFunciones"
				dataFlow="plugin/config/perfiles/ADMlistadoFuncionesPerfilData"
 				resultRootVar="funciones"
 				recordType="Funcion" 
 				autoload="true"/>

<pfs:defineColumnModel name="columnasFuncion">
	<pfs:defineHeader dataIndex="descripcionLarga" captionKey="pfsadmin.listadofunciones.descripcionLarga" caption="**DescripcionLarga" sortable="true" firstHeader="true"/>
	<pfs:defineHeader dataIndex="descripcion" captionKey="pfsadmin.listadoufunciones.descripcion" caption="**Descripcion" sortable="true"/>
</pfs:defineColumnModel>

<pfs:grid name="listadoGrid" 
	dataStore="storeFunciones" 
	columnModel="columnasFuncion" 
	title="**Listado de funciones" 
	titleKey="pfsadmin.listadofunciones"
	collapsible="false"
	autoexpand="true" />

var panel = new Ext.Panel({
	    items : [
	    	listadoGrid
	    ]
	    //,bodyStyle: 'padding: 10px'
	    ,border:false
	    ,autoHeight : true
	    ,border: false  
});
page.add(panel);	
</fwk:page>