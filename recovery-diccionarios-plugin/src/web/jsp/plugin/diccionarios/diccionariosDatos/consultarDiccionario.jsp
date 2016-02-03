<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfshandler" tagdir="/WEB-INF/tags/pfs/handler"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>

	<pfs:defineParameters name="diccionarioParams" paramId="${diccionario.id}"/>
	
	<pfs:defineRecordType name="ValoresDiccionario">
		<pfs:defineTextColumn name="idDiccionarioEditable"/>
		<pfs:defineTextColumn name="idLineaEnDiccionario"/>
		<pfs:defineTextColumn name="codigo"/>
		<pfs:defineTextColumn name="descripcion"/>
		<pfs:defineTextColumn name="descripcionLarga"/>
	</pfs:defineRecordType>
	
	<pfs:remoteStore name="storeValoresDiccionario"
					dataFlow="plugin/diccionarios/diccionariosDatos/DIClistadoValoresDiccionarioData"
	 				resultRootVar="valoresDiccionario"
	 				recordType="ValoresDiccionario" 
	 				parameters="diccionarioParams"
	 				autoload="true"/>
	
	<pfs:defineColumnModel name="columnasValoresDiccionario">
		<pfs:defineHeader dataIndex="codigo" captionKey="plugin.diccionarios.messages.columnaCodigo" caption="**Codigo" sortable="true" firstHeader="true"/>
		<pfs:defineHeader dataIndex="descripcion" captionKey="plugin.diccionarios.messages.columnaDescripcion" caption="**Descripcion" sortable="true" />
		<pfs:defineHeader dataIndex="descripcionLarga" captionKey="plugin.diccionarios.messages.columnaDescripLarga" caption="**Descripcion Larga" sortable="true" />
	</pfs:defineColumnModel>
	
	var recargar = function (){
		app.openTab('${diccionario.nombreTabla}'
					,'plugin/diccionarios/diccionariosDatos/DICconsultarDiccionarioDatos'
					,{id:${diccionario.id}}
					,{id:'diccionario${diccionario.id}'}
				)}
		
	<pfs:button name="btEliminar" caption="**Eliminar"  captioneKey="app.borrar" iconCls="icon_menos">
		if (gridDiccionario.getSelectionModel().getCount()>0){
				
				var idLineaEnDiccionario = gridDiccionario.getSelectionModel().getSelected().get('idLineaEnDiccionario');	
				var idDiccionarioEditable = gridDiccionario.getSelectionModel().getSelected().get('idDiccionarioEditable');	
				
				var parametros = {
							idLineaEnDiccionario : idLineaEnDiccionario
							,idDiccionarioEditable : idDiccionarioEditable
					};
					
					Ext.Msg.confirm('<s:message code="app.borrar" text="**Eliminar" />', '<s:message code="plugin.diccionarios.messages.seguroBorrarEntradaDic" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					page.webflow({
							flow: 'plugin/diccionarios/diccionariosDatos/DICeliminarValorDiccionario'
							,params: parametros
							,success : recargar() 
						});
    				}
				});
				
			}else{
				Ext.Msg.alert('<s:message code="app.borrar" text="**Eliminar" />','<s:message code="plugin.diccionarios.messages.seleccionarParaBorrar" text="**Debe seleccionar un valor de la tabla" />');
			}
	</pfs:button>
		
	<pfs:button name="btModificar" caption="**Modificar valor"  captioneKey="app.editar" iconCls="icon_edit">
		if (gridDiccionario.getSelectionModel().getCount()>0){
				
				var idLineaEnDiccionario = gridDiccionario.getSelectionModel().getSelected().get('idLineaEnDiccionario');	
				var idDiccionarioEditable = gridDiccionario.getSelectionModel().getSelected().get('idDiccionarioEditable');	
					
					var parametros = {
							idLineaEnDiccionario : idLineaEnDiccionario
							,idDiccionarioEditable : idDiccionarioEditable
					};
					var w= app.openWindow({
								flow: 'plugin/diccionarios/diccionariosDatos/DICmodificarValorDiccionario'
								,closable: true
								,width : 700
								,title : '<s:message code="plugin.diccionarios.messages.modificarEntrada" text="**Modificar valor" />'
								,params: parametros
					});
					w.on(app.event.DONE, function(){
								w.close();
								recargar() ;
								
					});
					w.on(app.event.CANCEL, function(){
								 w.close(); 
					});
				
			}else{
				Ext.Msg.alert('<s:message code="app.editar" text="**Modificar valor" />','<s:message code="plugin.diccionarios.messages.seleccionarParaEditar" text="**Debe seleccionar un valor de la tabla" />');
			}
	</pfs:button>
	
	<%-- 
	gridDiccionario.on('rowdblclick', function(g, i, e){
    		var idDiccionarioEditable = ${diccionario.id};
					
				var parametros = {
							idDiccionarioEditable : idDiccionarioEditable
				};
				var w= app.openWindow({
							flow: 'pfsadmin/diccionariosDatos/ADMconsultarHistoricoDiccionario'
							,closable: true
							,width : 1050
							,title : '<s:message code="pfsadmin.consultarDiccionario.modificar" text="**Consultar Histórico" />'
							,params: parametros
				});
				w.on(app.event.DONE, function(){
							w.close();
								
				});
				w.on(app.event.CANCEL, function(){
							w.close(); 
				});	
   		 };
	)
	--%>
		
	<pfs:buttonadd  name="btAdd" 
		flow="plugin/diccionarios/diccionariosDatos/DICinsertarValorDiccionario"
		windowTitleKey="plugin.diccionarios.messages.agregarEntrada" 
		parameters="diccionarioParams" 
		windowTitle="**Insertar valor" 
		store_ref="storeValoresDiccionario"/>
		
	<pfs:button name="btHistorico" captioneKey="plugin.diccionarios.messages.botonHistorico" caption="**Consultar Histórico">
		var idDiccionarioEditable = ${diccionario.id};
					
				var parametros = {
							idDiccionarioEditable : idDiccionarioEditable
				};
				var w= app.openWindow({
							flow: 'plugin/diccionarios/diccionariosDatos/DICconsultarHistoricoDiccionario'
							,closable: true
							,width : 1050
							,title : '<s:message code="plugin.diccionarios.messages.tituloHistorico" text="**Consultar Histórico" />'
							,params: parametros
				});
				w.on(app.event.DONE, function(){
							w.close();
								
				});
				w.on(app.event.CANCEL, function(){
							w.close(); 
				});			
	</pfs:button>

	<c:if test="${diccionario.editable == false }">
		<pfs:grid name="gridDiccionario" 
		dataStore="storeValoresDiccionario" 
		columnModel="columnasValoresDiccionario" 
		title="**Valores del diccionario" 
		titleKey="plugin.diccionarios.messages.tituloGrid"
		collapsible="false"
		autoexpand="true" 
		bbar="btHistorico"
		/>
	</c:if>
	
	<c:if test="${diccionario.insertable == false}&& ${diccionario.editable == true }">
		<pfs:grid name="gridDiccionario" 
		dataStore="storeValoresDiccionario" 
		columnModel="columnasValoresDiccionario" 
		title="**Valores del diccionario" 
		titleKey="plugin.diccionarios.messages.tituloGrid"
		collapsible="false"
		autoexpand="true" 
		bbar="btHistorico,btModificar"
		/>
	</c:if>
	
	<c:if test="${diccionario.insertable == true}">
		<pfs:grid name="gridDiccionario" 
		dataStore="storeValoresDiccionario" 
		columnModel="columnasValoresDiccionario" 
		title="**Valores del diccionario" 
		titleKey="plugin.diccionarios.messages.tituloGrid"
		collapsible="false"
		autoexpand="true" 
		bbar="btHistorico,btModificar,btAdd,btEliminar"
		/>
	</c:if>
	
	 var compuesto = new Ext.Panel({
	    items : [
	    	gridDiccionario
	    	]
	    ,autoHeight : true
		,autoWidth:true
	    ,border: false
    });
	page.add(compuesto);
</fwk:page>