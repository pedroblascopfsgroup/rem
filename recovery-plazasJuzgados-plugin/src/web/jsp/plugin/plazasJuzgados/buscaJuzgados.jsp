<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	Ext.util.CSS.createStyleSheet(".icon_juzgados { background-image: url('../img/plugin/plazasJuzgados/bank.png');}");

 	<pfsforms:textfield name="filtroPlaza" 
 		labelKey="plugin.plazasJuzgados.busqueda.plaza" 
 		label="**Plaza" 
 		value=""/>
 		
 	<pfsforms:textfield name="filtroJuzgado" 
 		labelKey="plugin.plazasJuzgados.busqueda.juzgado" 
 		label="**Juzgado" 
 		value=""/>
 		
 	<pfs:defineRecordType name="JuzgadosRT">
 		<pfs:defineTextColumn name="id"/>
 		<pfs:defineTextColumn name="codigo"/>
 		<pfs:defineTextColumn name="descripcion"/>
 		<pfs:defineTextColumn name="plaza"/>
 		<pfs:defineTextColumn name="esUltimo"/>
 	</pfs:defineRecordType>
 	
 	<pfs:defineColumnModel name="juzgadosCM">
 		<pfs:defineHeader dataIndex="plaza" 
 			caption="**Plaza" captionKey="plugin.plazasJuzgados.busqueda.plaza" sortable="true" 
 			firstHeader="true"/>
 		<pfs:defineHeader dataIndex="descripcion" 
 			caption="**Juzgado" captionKey="plugin.plazasJuzgados.busqueda.juzgado" sortable="true"  />
 	</pfs:defineColumnModel>
	
	<%-- 
	<pfs:buttonremove name="btEliminar"  
		flow="plugin.plazasJuzgados.borraJuzgado"
		novalueMsg="**Debe seleccionar un valor de la tabla" 
		novalueMsgKey="plugin.plazasJuzgados.busqueda.noValor"
		paramId="idJuzgado"  
		datagrid="gridJuzgados" 
		/>
	<pfs:button caption="**Borrar" name="btEliminar" captioneKey="pfs.tags.buttonremove.borrar">
	--%>
	
	var btEliminar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,handler : function(){
			if (gridJuzgados.getSelectionModel().getCount()>0){
				var ultimo=gridJuzgados.getSelectionModel().getSelected().get('esUltimo');
				if(ultimo=='true'){
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="plugin.plazasJuzgados.busqueda.preguntaUltimo" text="**¿Está seguro de borrar? Se borrará la plaza" />', function(btn){
    				if (btn == 'yes'){
    					var parms = {};
    					parms.idJuzgado = gridJuzgados.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'plugin.plazasJuzgados.borraJuzgado'
							,params: parms
							,success : function(){ 
								gridJuzgados.store.webflow(parms); 
							}
						});
    				}
				});
				}else{
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					var parms = {};
    					parms.idJuzgado = gridJuzgados.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'plugin.plazasJuzgados.borraJuzgado'
							,params: parms
							,success : function(){ 
								gridJuzgados.store.webflow(parms); 
							}
						});
    				}
				});}
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="plugin.plazasJuzgados.busqueda.noValor" text="**No valor" />');
			}
		}
	});
	
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	
	<pfs:defineParameters name="getParametros" paramId=""
		filtroPlaza="filtroPlaza" filtroJuzgado="filtroJuzgado"/>
		
	<pfs:searchPage searchPanelTitle="**Búsqueda de plazas y juzgados" 
		searchPanelTitleKey="plugin.plazasJuzgados.busqueda.titulo" 
		gridPanelTitle="**Juzgados"
		gridPanelTitleKey="plugin.plazasJuzgados.busqueda.gridTitulo"  
		columnModel="juzgadosCM"
		recordType="JuzgadosRT" 
		dataFlow="plugin.plazasJuzgados.buscaJuzgadosData"
		parameters="getParametros"
		resultRootVar="juzgados"   
		createTitle="**Nuevo juzgado" 
		createTitleKey="plugin.plazasJuzgados.busqueda.altaJuzgado"
		createFlow="plugin.plazasJuzgados.altaJuzgado"  
		updateFlow="plugin.plazasJuzgados.consultaPlaza" 
		newTabOnUpdate="true"
		updateTitleData="descripcion"
		resultTotalVar="total" 
		columns="2"
		buttonDelete="btEliminar"
		gridName="gridJuzgados"
		iconCls="icon_juzgados"
		 >
		<pfs:items items="filtroPlaza"/>
		<pfs:items items="filtroJuzgado"/>
	</pfs:searchPage>	
	
	
	btnNuevo.hide();
	<sec:authorize ifAllGranted="ROLE_ADDJUZGADO">
		btnNuevo.show();
	</sec:authorize>
	
	filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());
	
	
</fwk:page>