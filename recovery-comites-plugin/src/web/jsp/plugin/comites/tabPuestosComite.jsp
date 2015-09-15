<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfslayout" tagdir="/WEB-INF/tags/pfs/layout" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<pfslayout:tabpage titleKey="plugin.comites.tabPuestos.titulo" title="**Puestos de comité" 
	items="gridPuestos" >

	<pfs:defineParameters name="parametros" paramId="${comite.id}" />
	
	<pfs:defineRecordType name="PuestosRT">
		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="idComite"/>
		<pfs:defineTextColumn name="perfil"/>
		<pfs:defineTextColumn name="zona"/>
		<pfs:defineTextColumn name="esRestrictivo"/>
		<pfs:defineTextColumn name="esSupervisor"/>
	</pfs:defineRecordType>
	
	<pfs:remoteStore name="puestosDS" 
		resultRootVar="puestos" 
		recordType="PuestosRT" 
		dataFlow="plugin.comites.listadoPuestosComiteData"
		parameters="parametros"
		autoload="true"/>
	
	
	<pfs:defineColumnModel name="puestosCM">
		<pfs:defineHeader caption="**Perfil" captionKey="plugin.comites.tabPuestos.perfil" 
			sortable="false" dataIndex="perfil" firstHeader="true"/>
		<pfs:defineHeader caption="**Zona" captionKey="plugin.comites.tabPuestos.zona" 
			sortable="false" dataIndex="zona" />
		<pfs:defineHeader caption="**Restrictivo" captionKey="plugin.comites.tabPuestos.restrictivo" 
			sortable="false" dataIndex="esRestrictivo" />
		<pfs:defineHeader caption="**Supervisor" captionKey="plugin.comites.tabPuestos.supervisor" 
			sortable="false" dataIndex="esSupervisor" />
	</pfs:defineColumnModel>

		
	<pfs:button caption="**Borrar Puesto" name="btBorrar" captioneKey="pfs.tags.buttonremove.borrar" iconCls="icon_menos" >
		if (gridPuestos.getSelectionModel().getCount()>0){
    		var idPuesto = gridPuestos.getSelectionModel().getSelected().get('id');
    		var paramet = {
				idPuesto : idPuesto
			};
			
			Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					page.webflow({
							flow: 'plugin.comites.borrarPuestoComite'
							,params: paramet
							,success : function(){ 
								puestosDS.webflow(parametros()); 
							}
						});
    				}
				});
		}else{
				Ext.Msg.alert('<s:message code="plugin.comites.tabPuestos.borrar" text="**Borrar Puesto" />','<s:message code="plugin.comite.tabPuesto.editar.novalor" text="**Debe seleccionar un valor de la lista" />');
		}
		
	</pfs:button>
	
	<pfs:buttonadd name="btAdd"
		flow="plugin.comites.nuevoPuestoComite"  
		windowTitleKey="plugin.comites.tabPuestos.nuevo" 
		parameters="parametros" 
		windowTitle="**Añadir Puesto" 
		store_ref="puestosDS"/>
	
	<pfs:button caption="**Editar Puesto" name="btEditar" captioneKey="plugin.comites.tabPuestos.editar" iconCls="icon_edit" >
		if (gridPuestos.getSelectionModel().getCount()>0){
    		var idPuesto = gridPuestos.getSelectionModel().getSelected().get('id');
    		var paramet = {
				idPuesto : idPuesto
			};
    		var w= app.openWindow({
                   flow: 'plugin.comites.editarPuestoComite'
                   ,closable: true
                   ,width : 700
                   ,title : '<s:message code="plugin.comites.tabPuestos.modificar" text="**Modificar" />'
                   ,params: paramet
             });
           	 w.on(app.event.DONE, function(){
					w.close();
					puestosDS.webflow(parametros());
					//recargar() ;
								
				});
			 w.on(app.event.CANCEL, function(){
					w.close(); 
				});
			
		}else{
				Ext.Msg.alert('<s:message code="plugin.comites.tabPuestos.editar" text="**Editar Puesto" />','<s:message code="plugin.comite.tabPuesto.editar.novalor" text="**Debe seleccionar un valor de la lista" />');
		}
		
	</pfs:button>
	
	Ext.util.CSS.createStyleSheet(".icon_comite { background-image: url('../img/plugin/comites/user-business.png');}");
	
	
	
	<pfs:grid name="gridPuestos"
		dataStore="puestosDS" 
		columnModel="puestosCM" 
		title="**Puestos de comité" 
		collapsible="false" 
		titleKey="plugin.comites.tabPuestos.titulo"
		bbar="btAdd,btEditar,btBorrar"
		iconCls="icon_comite"/>
		
	btBorrar.hide();
	btAdd.hide();
	btEditar.hide();
	
	<sec:authorize ifAllGranted="ROLE_COMITE_BORRAPUESTO">
		btBorrar.show();
	</sec:authorize>
	
	<sec:authorize ifAllGranted="ROLE_COMITE_ALTAPUESTO">
		btAdd.show();
	</sec:authorize>
	
	<sec:authorize ifAllGranted="ROLE_COMITE_EDITPUESTO">
		btEditar.show();
	</sec:authorize>
	
	
</pfslayout:tabpage>