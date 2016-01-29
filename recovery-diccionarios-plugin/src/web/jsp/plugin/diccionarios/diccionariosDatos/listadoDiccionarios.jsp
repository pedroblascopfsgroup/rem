<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfshandler" tagdir="/WEB-INF/tags/pfs/handler"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page> 


<pfs:defineRecordType name="Diccionario">
	<pfs:defineTextColumn name="id"/>
	<pfs:defineTextColumn name="nombre"/>
	<pfs:defineTextColumn name="descripcion"/>
	<pfs:defineTextColumn name="editable"/>
	<pfs:defineTextColumn name="insertable"/>
	<pfs:defineTextColumn name="borrable"/>
</pfs:defineRecordType>

<pfs:remoteStore name="storeDiccionarios"
				dataFlow="plugin/diccionarios/diccionariosDatos/DIClistadoDiccionariosData"
 				resultRootVar="diccionario"
 				recordType="Diccionario" 
 				autoload="true"/>

<pfs:defineColumnModel name="columnasDiccionarios">
	<pfs:defineHeader dataIndex="nombre" captionKey="plugin.diccionarios.messages.columnaNombre" caption="**Nombre" sortable="true" firstHeader="true"/>
	<pfs:defineHeader dataIndex="descripcion" captionKey="plugin.diccionarios.messages.columnaDescripcion" caption="**Descripcion" sortable="true"/>
	<pfs:defineHeader dataIndex="editable" captionKey="plugin.diccionarios.messages.columnaEditar" caption="**Editar" sortable="true" width="20"/>
	<pfs:defineHeader dataIndex="insertable" captionKey="plugin.diccionarios.messages.columnaInsertar" caption="**Insertar" sortable="true" width="20"/>
	<pfs:defineHeader dataIndex="borrable" captionKey="plugin.diccionarios.messages.columnaBorrar" caption="**Borrar" sortable="true" width="20"/>
</pfs:defineColumnModel>

<pfshandler:editgridrow name="dblclickhandler" flow="plugin/diccionarios/diccionariosDatos/DICconsultarDiccionarioDatos" titleField="nombre" tabId="diccionario" paramId="id" />

var buttonsR = <app:includeArray files="${buttonsRight}" />;
var buttonsL = <app:includeArray files="${buttonsLeft}" />;

<pfs:grid name="listadoGrid" 
	dataStore="storeDiccionarios" 
	columnModel="columnasDiccionarios" 
	title="**Listado de diccionarios de datos" 
	titleKey="plugin.diccionarios.messages.dicsTituloGrid"
	collapsible="false"
	autoexpand="true"
	rowdblclick="dblclickhandler"
	 />
	


var panel = new Ext.Panel({
	    items : [
	    	listadoGrid
	    ]
	    //,bodyStyle: 'padding: 10px'
	    ,border:false
	    ,autoHeight : true
	    ,border: false  
	    ,tbar:[buttonsL,'->',buttonsR]
});
page.add(panel);	
</fwk:page>