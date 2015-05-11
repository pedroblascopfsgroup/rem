<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfshandler" tagdir="/WEB-INF/tags/pfs/handler"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<fwk:page> 


<pfs:defineRecordType name="Perfil">
	<pfs:defineTextColumn name="descripcionLarga"/>
	<pfs:defineTextColumn name="descripcion"/>
</pfs:defineRecordType>

<pfs:remoteStore name="storePerfiles"
				dataFlow="plugin/config/perfiles/ADMlistadoPerfilesData"
 				resultRootVar="perfiles"
 				recordType="Perfil" 
 				autoload="true"/>

<pfs:defineColumnModel name="columnasPerfil">
	<pfs:defineHeader dataIndex="descripcionLarga" captionKey="plugin.config.perfiles.field.descripcionLarga" caption="**DescripcionLarga" sortable="true" firstHeader="true"/>
	<pfs:defineHeader dataIndex="descripcion" captionKey="plugin.config.perfiles.field.descripcion" caption="**Descripcion" sortable="true"/>
</pfs:defineColumnModel>

<pfs:buttonnew name="btNuevo" flow="plugin/config/perfiles/ADMaltaPerfil" 
	createTitleKey="plugin.config.perfiles.nuevo.windowTitle"   createTitle="**Nuevo perfil" 
	onSuccess="function(){storePerfiles.webflow()}"/>
	
<pfs:buttonremove name="btBorrar" 
		flow="plugin/config/perfiles/ADMborrarPerfil" paramId="idPerfil" datagrid="listadoGrid" novalueMsg="**Debe seleccionar un perfil dela lista"  novalueMsgKey="plugin.config.perfiles.listado.message.novalue"/>
 
<pfshandler:editgridrow name="dblclickhandler" flow="plugin/config/perfiles/ADMconsultarPerfil" titleField="descripcion" tabId="perfil" paramId="idPerfil" />

<pfs:grid name="listadoGrid" 
	dataStore="storePerfiles" 
	columnModel="columnasPerfil" 
	title="**Listado de perfiles" 
	titleKey="plugin.config.perfiles.listado.control.grid.title"
	collapsible="false"
	bbar="btNuevo,btBorrar"
	autoexpand="true"
	rowdblclick="dblclickhandler"/>

var panel = new Ext.Panel({
	    items : [
	    	listadoGrid
	    ]
	    //,bodyStyle: 'padding: 10px'
	    ,border:false
	    ,height: 500
	    //,autoHeight : true
	    ,border: false  
});
page.add(panel);	
</fwk:page>