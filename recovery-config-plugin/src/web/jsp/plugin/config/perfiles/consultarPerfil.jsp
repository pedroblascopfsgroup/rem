<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	
	<pfsforms:textfield labelKey="plugin.config.perfiles.field.descripcion" label="**Descripcion" name="descripcion" value="${perfil.descripcion}" readOnly="true" width="150"/>
	<pfsforms:textfield labelKey="plugin.config.perfiles.field.descripcionLarga" label="**Descripcion Larga" name="descripcionLarga" value="${perfil.descripcionLarga}" readOnly="true" labelWidth="150" width="400"/>
	
	<pfs:defineParameters name="perfilParams" paramId="${perfil.id}"/>
	
	var recargar = function (){
		app.openTab('${perfil.descripcion}'
					,'pfsadmin/usuarios/ADMconsultarPerfil'
					,{id:${perfil.id}}
					,{id:'Perfil${perfil.id}',iconCls:'icon_perfiles'}
				)
	};
	
	<pfs:buttonedit name="btModificar" 
			flow="plugin/config/perfiles/ADMmodificarPerfil" 
			parameters="perfilParams" 
			windowTitle="**Modificar perfil" 
			windowTitleKey="plugin.config.perfiles.modificar.windowTitle"
			on_success="recargar" />
	
	<pfs:panel titleKey="plugin.config.perfiles.consulta.control.datos" name="panel1" columns="2" collapsible="false" title="**Datos Perfil" bbar="btModificar" >
		<pfs:items items="descripcion"/>
		<pfs:items items="descripcionLarga"/>	
	</pfs:panel>
	
	<pfs:defineRecordType name="Funcion">
		<pfs:defineTextColumn name="descripcion"/>
		<pfs:defineTextColumn name="descripcionLarga"/>
	</pfs:defineRecordType>
	
	<pfs:remoteStore name="storeFunciones"
					dataFlow="plugin/config/funciones/ADMlistadoFuncionesPerfilData"
	 				resultRootVar="funciones"
	 				recordType="Funcion" 
	 				parameters="perfilParams"
	 				autoload="true"/>
	
	<pfs:defineColumnModel name="columnasFuncion">
		<pfs:defineHeader dataIndex="descripcion" captionKey="plugin.config.perfiles.field.descripcion" caption="**Descripcion" sortable="true" firstHeader="true"/>
		<pfs:defineHeader dataIndex="descripcionLarga" captionKey="plugin.config.perfiles.field.descripcionLarga" caption="**Descripcion Larga" sortable="true" />
	</pfs:defineColumnModel>
	
		
	<pfs:buttonremove name="btEliminar"
		flow="plugin/config/perfiles/ADMeliminarFuncionPerfilSeguro"
		novalueMsgKey="plugin.config.perfiles.consulta.message.novalue"
		novalueMsg="**Seleccione una función de la lista"  
		paramId="idFuncion"  
		datagrid="gridFunciones" 
		parameters="perfilParams"
		/>

var btEliminar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,handler : function(){
			if (gridFunciones.getSelectionModel().getCount()>0){
				app.promptPw('<s:message code="plugin.config.confirmacion.password" text="**Introduzca su password para confirmar el cambio" />', 
						'Password ', function(btn, rta){
					if (btn== 'ok'){
    					var parms = perfilParams();
    					parms.idFuncion = gridFunciones.getSelectionModel().getSelected().get('id');
    					parms.password = rta;
    					page.webflow({
							flow: 'plugin/config/perfiles/ADMeliminarFuncionPerfilSeguro'
							,params: parms
							,success : function(){ 
								gridFunciones.store.webflow(parms); 
							}
						});						
					}
				});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="plugin.config.perfiles.consulta.message.novalue" text="**Seleccione una función de la lista" />');
			}
		}
});	
	
	<pfs:buttonnew name="btAdd" 
		flow="plugin/config/perfiles/ADMinsertarFuncionPerfil"
		createTitleKey="plugin.config.perfiles.asociarfuncion.windowTitle" 
		createTitle="**Insertar función"
		parameters="perfilParams"
		windowWidth="750" onSuccess="function(){storeFunciones.webflow(perfilParams())}"/>

	<pfs:grid name="gridFunciones" 
		dataStore="storeFunciones" 
		columnModel="columnasFuncion" 
		title="**Funciones asociadas" 
		titleKey="plugin.config.perfiles.consulta.control.gridFunciones"
		collapsible="false"
		autoexpand="true" 
		bbar="btEliminar,btAdd"
		iconCls="icon_funcion"
		/>
		
	 var compuesto = new Ext.Panel({
	    items : [
	    	panel1
	    	,gridFunciones
	    	]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
	page.add(compuesto);
</fwk:page>