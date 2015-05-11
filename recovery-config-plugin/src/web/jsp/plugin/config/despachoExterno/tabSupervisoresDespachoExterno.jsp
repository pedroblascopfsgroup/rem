<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<pfslayout:tabpage titleKey="plugin.config.despachoExterno.consultadespacho.supervisoresdespacho.title" title="**Supervisores" items="gridSupervisores" >
	
	<pfs:defineRecordType name="Supervisor">
		<pfs:defineTextColumn name="idusuario"/>
		<pfs:defineTextColumn name="username"/>
		<pfs:defineTextColumn name="nombre"/>
		<pfs:defineTextColumn name="apellido1"/>
		<pfs:defineTextColumn name="apellido2"/>
		<pfs:defineTextColumn name="email"/>
		<pfs:defineTextColumn name="telefono"/>
	</pfs:defineRecordType>
	
	<pfs:defineParameters name="supervisoresParams" paramId="${despacho.id}"/>	
	
	<pfs:remoteStore name="supervisoresDS"
			dataFlow="plugin/config/despachoExterno/ADMlistadoSupervisoresDespachosData"
			resultRootVar="supervisoresDespacho" 
			recordType="Supervisor" 
			autoload="true"
			parameters="supervisoresParams"
			/>
	
	<pfs:defineColumnModel name="supervisoresCM">
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.username" sortable="false" dataIndex="username" caption="**Username" firstHeader="true"/>
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.nombre" sortable="false" dataIndex="nombre" caption="**Nombre"/>
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.apellido1" sortable="false" dataIndex="apellido1" caption="**Apellido1"/>
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.apellido2" sortable="false" dataIndex="apellido2" caption="**Apellido2"/>
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.email" sortable="false" dataIndex="email" caption="**Email"/>
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.telefono" sortable="false" dataIndex="telefono" caption="**Telefono"/>
	</pfs:defineColumnModel>
	
	var recargar = function (){
		app.openTab('${despacho.despacho}'
					,'plugin/config/despachoExterno/ADMconsultarDespachoExterno'
					,{id:${despacho.id}}
					,{id:'DespachoExterno${despacho.id}'}
				)
	};
	
	<pfs:buttonremove name="btElimina" 
			flow="plugin/config/despachoExterno/ADMborrarSupervisorDespacho" 
			novalueMsgKey="plugin.config.despachoExterno.consultadespacho.supervisoresdespacho.message.novalue" 
			novalueMsg="** Debe seleccionar un supervisor de la lista"  
			paramId="idSupervisorDespacho"  
			datagrid="gridSupervisores"
			parameters="supervisoresParams" />
			
	
	<pfs:buttonnew name="btAdd" 
		flow="plugin/config/despachoExterno/ADMaltaSupervisorDespacho"
		createTitleKey="plugin.config.despachoExterno.addsupervisordespacho.windowName" 
		createTitle="**Añadir supervisor" 
		parameters="supervisoresParams"
		onSuccess="recargar"
		 />
		
	var opensupervisor = function (grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		app.openTab(rec.get('username')
				,'plugin/config/usuarios/ADMconsultarUsuario'
				,{id:rec.get('idusuario')}
				,{id:'Usuario'+rec.get('idusuario'), iconCls:'icon_usuario'});
	};
	
	<pfs:grid name="gridSupervisores" dataStore="supervisoresDS"  
		columnModel="supervisoresCM" titleKey="plugin.config.despachoExterno.consultadespacho.supervisoresdespacho.control.grid.title" title="**Supervisores" 
		collapsible="false" bbar="btElimina,btAdd" iconCls="icon_usuario" rowdblclick="opensupervisor"/>
	
</pfslayout:tabpage>