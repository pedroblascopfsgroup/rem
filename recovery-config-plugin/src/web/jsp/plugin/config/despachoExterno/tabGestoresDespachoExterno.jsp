<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="pfshandler" tagdir="/WEB-INF/tags/pfs/handler" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<pfslayout:tabpage titleKey="plugin.config.despachoExterno.consultadespacho.gestoresdespacho.title" title="**Gestores" items="panel2,gridGestores" >
		
	<pfs:defineRecordType name="Gestor">
		<pfs:defineTextColumn name="idusuario"/>
		<pfs:defineTextColumn name="username"/>
		<pfs:defineTextColumn name="nombre"/>
		<pfs:defineTextColumn name="apellido1"/>
		<pfs:defineTextColumn name="apellido2"/>
		<pfs:defineTextColumn name="email"/>
		<pfs:defineTextColumn name="telefono"/>
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="gestoresCM">
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.username" sortable="false" dataIndex="username" caption="**Username" firstHeader="true"/>
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.nombre" sortable="false" dataIndex="nombre" caption="**Nombre"/>
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.apellido1" sortable="false" dataIndex="apellido1" caption="**Apellido1"/>
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.apellido2" sortable="false" dataIndex="apellido2" caption="**Apellido2"/>
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.email" sortable="false" dataIndex="email" caption="**Email"/>
		<pfs:defineHeader captionKey="plugin.config.despachoExterno.gestorsuperviosor.field.telefono" sortable="false" dataIndex="telefono" caption="**Telefono"/>
	</pfs:defineColumnModel>
	
	<pfs:defineParameters name="gestoresDespParams" paramId="${despacho.id}"/>
	
	<pfs:remoteStore name="gestoresDS" 
			dataFlow="plugin/config/despachoExterno/ADMlistadoGestoresDespachosData"
			resultRootVar="gestoresDespacho" 
			recordType="Gestor" 
			autoload="true"
			parameters="gestoresDespParams" />
	
	var recargar = function (){
		app.openTab('${despacho.despacho}'
					,'plugin/config/despachoExterno/ADMconsultarDespachoExterno'
					,{id:${despacho.id}}
					,{id:'DespachoExterno${despacho.id}'}
				)
	};
			
	<pfs:button name="btCambia" caption="**Cambiar por defecto"  captioneKey="plugin.config.despachoExterno.consultadespacho.gestoresdespacho.action.cambiardefecto" >
		if (gridGestores.getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="plugin.config.despachoExterno.consultadespacho.gestoresdespacho.action.cambiardefecto" text="**Cambiar gestor por defecto" />'
							, '<s:message code="plugin.config.despachoExterno.consultadespacho.gestoresdespacho.message.cambiardefecto" text="**¿Está seguro de cambiar el gestor por defecto?" />', function(btn){
    				if (btn == 'yes'){
    					var parms = gestoresDespParams();
    					parms.idGestorDespacho = gridGestores.getSelectionModel().getSelected().get('id');
  
    					Ext.Ajax.request({
							url : page.resolveUrl('plugin/config/despachoExterno/ADMcambiaGestorDefecto'), 
							params : parms,
							method: 'POST',
							success: function ( result, request ) {
								var result = Ext.util.JSON.decode(result.responseText);
								gesDef.setValue(result.gestorDespacho.nombrecompleto);
							}
    					});
    					
    				}
				});
			}else{
				Ext.Msg.alert('<s:message code="plugin.config.despachoExterno.consultadespacho.gestoresdespacho.action.cambiardefecto" text="**Cambiar gestor por defecto" />'
							,'<s:message code="plugin.config.despachoExterno.consultadespacho.gestoresdespacho.message.novalue" text="**Debe seleccionar un gesor de la lista." />');
			}
	</pfs:button>
	
	<pfs:buttonremove name="btElimina" 
			flow="plugin/config/despachoExterno/ADMborrarGestorDespacho" 
			novalueMsgKey="plugin.config.despachoExterno.consultadespacho.gestoresdespacho.message.novalue" 
			novalueMsg="** Debe seleccionar un gestor de la lista"  
			paramId="idGestorDespacho"  
			datagrid="gridGestores" 
			parameters="gestoresDespParams"/>
			
	var opengestor = function (grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		app.openTab(rec.get('username')
				,'plugin/config/usuarios/ADMconsultarUsuario'
				,{id:rec.get('idusuario')}
				,{id:'Usuario'+rec.get('idusuario'), iconCls:'icon_usuario'});
	};
	
	<%-- PRODUCTO-1272 Nuevo boton para agregar gestores --%>		
	 var btnAgregar = new Ext.Button({
		text : '<s:message code="plugin.config.despachoExterno.consultadespacho.gestoresdespacho.btnAgregarGestor.text" text="**Agregar Gestor" />'
		,iconCls : 'icon_mas'
		,cls: 'x-btn-text-icon'
		,handler:function(){
			nuevoGestor(${despacho.id});
		}
	});
	
	//Funcion encargada de abrir el popup para añadir un nuevo gestor.
	var nuevoGestor = function(idDespacho){
		
		win = app.openWindow({			
			flow:'plugin/config/despachoExterno/ADMagregarNuevoGestor', 
			title : '<s:message code="plugin.coreextension.multigestor.nuevoGestor.titulo" text="**Nuevo gestor" />',
			params: {idDespacho:idDespacho},
			width: 750
		});
		
		win.on(app.event.CANCEL, function(){
			win.close();
		});
		
		win.on(app.event.DONE, function(){
			win.close();
			recargar();
		});
	};
	
	<%--<pfshandler:editgridrow flow="plugin/config/usuarios/ADMconsultarUsuario" 
			titleField="username" tabId="Usuario" paramId="idusuario" name="opengestor"/>--%>
	
	<pfs:grid name="gridGestores"
			dataStore="gestoresDS"  
			columnModel="gestoresCM" 
			title="**Gestores Asignados" 
			collapsible="false" 
			titleKey="plugin.config.despachoExterno.consultadespacho.gestoresdespacho.control.grid"
			bbar="btCambia, btnAgregar" iconCls="icon_usuario" rowdblclick="opengestor"/>
	
	<pfsforms:textfield labelKey="plugin.config.despachoExterno.consultadespacho.gestoresdespacho.control.desdef" label="**Gestor por defecto" name="gesDef" value="${gestorDefecto.usuario.nombre!=null?gestorDefecto.usuario.apellidoNombre:gestorDefecto.usuario.username}" readOnly="true" labelWidth="150" />
	
	<pfs:panel name="panel2" columns="1" collapsible="false" hideBorder="true" >
		<pfs:items items="gesDef"/>
	</pfs:panel>
	
</pfslayout:tabpage>