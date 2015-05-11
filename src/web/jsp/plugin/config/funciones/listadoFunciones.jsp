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
				dataFlow="plugin/config/funciones/ADMlistadoFuncionesData"
 				resultRootVar="funciones"
 				recordType="Funcion" 
 				autoload="true"/>

<pfs:defineColumnModel name="columnasFuncion">
	<pfs:defineHeader dataIndex="descripcionLarga" captionKey="plugin.config.funciones.field.descripcionLarga" caption="**DescripcionLarga" sortable="true" firstHeader="true"/>
	<pfs:defineHeader dataIndex="descripcion" captionKey="plugin.config.funciones.field.descripcion" caption="**Descripcion" sortable="true"/>
</pfs:defineColumnModel>

var pagingBar=fwk.ux.getPaging(storeFunciones);
var buttonsR = <app:includeArray files="${buttonsRight}" />;
var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	

<pfs:grid name="listadoGrid" 
	dataStore="storeFunciones" 
	columnModel="columnasFuncion" 
	title="**Listado de funciones" 
	titleKey="plugin.config.funciones.listado.control.grid.title"
	collapsible="false"
	autoexpand="true"
	bbar="pagingBar" iconCls="icon_funcion"/>



var panel = new Ext.Panel({
	    items : [
	    	listadoGrid
	    ]
	    //,bodyStyle: 'padding: 10px'
	    ,tbar:[buttonsL,'->',buttonsR]
	    ,border:false
	    ,autoHeight : true
	    ,border: false  
});
page.add(panel);	
</fwk:page>