<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>


<pfslayout:tabpage titleKey="plugin.config.usuarios.consulta.perfiles.title" title="**Centros/Perfiles" items="gridPerfiles">
	
	<pfs:defineRecordType name="Perfiles">
		<pfs:defineTextColumn name="zonid"/>
		<pfs:defineTextColumn name="pefid"/>
		<pfs:defineTextColumn name="usuid"/>
		<pfs:defineTextColumn name="centro"/>
		<pfs:defineTextColumn name="perfil"/>
	</pfs:defineRecordType>
	
	<pfs:defineParameters name="usuarioPerfilParams" paramId="${usuario.id}"/>	
	
	<pfs:remoteStore name="perfilesDS"
			dataFlow="plugin/config/usuarios/ADMlistadoCentrosPerfiles"
			resultRootVar="perfiles" 
			recordType="Perfiles" 
			autoload="true"
			parameters="usuarioPerfilParams"
			/>
	
	<pfs:defineColumnModel name="perfilesCM">
		<pfs:defineHeader captionKey="plugin.config.usuarios.consulta.perfiles.control.grid.zona" sortable="false" dataIndex="centro" caption="**Centro" firstHeader="true"/>
		<pfs:defineHeader captionKey="plugin.config.usuarios.consulta.perfiles.control.grid.perfil" sortable="false" dataIndex="perfil" caption="**Perfil"/>
	</pfs:defineColumnModel>
			
	<pfs:buttonnew name="btAdd" 
		createTitleKey="plugin.config.usuarios.asociarperfil.windowTitle" 
		createTitle="**Añadir" flow="plugin/config/usuarios/ADMasociaPerfilUsuario" 
		parameters="usuarioPerfilParams" windowWidth="550" onSuccess="function(){perfilesDS.webflow(usuarioPerfilParams())}"/>
		
	var btElimina= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,handler : function(){
			if (gridPerfiles.getSelectionModel().getCount()>0){
				app.promptPw('<s:message code="plugin.config.confirmacion.password" text="**Introduzca su password para confirmar el cambio" />', 
						'Password ', function(btn, rta){
					if (btn== 'ok'){
    					var parms = usuarioPerfilParams();
    					parms.zpuid = gridPerfiles.getSelectionModel().getSelected().get('id');
    					parms.password = rta;
    					page.webflow({
							flow: 'plugin/config/usuarios/ADMborrarCentroUsuarioSeguro'
							,params: parms
							,success : function(){ 
								gridPerfiles.store.webflow(parms); 
							}
						});						
					}
				});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="plugin.config.usuarios.consulta.perfiles.message.novalue" text="**Debe seleccionar un centro de la lista" />');
			}
		}
	});	
	
	<pfs:grid name="gridPerfiles" dataStore="perfilesDS"  columnModel="perfilesCM" titleKey="plugin.config.usuarios.consulta.perfiles.control.grid.title" title="**Perfiles Asociados" collapsible="false" bbar="btAdd,btElimina" />
	
	
</pfslayout:tabpage>