<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<fwk:page>

	<pfsforms:ddCombo name="filtroTipoJuicio"
		labelKey="plugin.masivo.confImpulso.busqueda.tipoJuicio"
		label="**Tipo de procedimiento" value="" dd="${tiposJuicio}"
		propertyCodigo="id" propertyDescripcion="descripcion" 
		width="200"/>	
		
	var TipoTar = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsTareasStore = page.getStore({
	       flow: 'msvconfimpulsoautomatico/consultaTareasProcedimiento'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoTareas'
	    }, TipoTar)	       
	});		
	
	var filtroTareaProcedimiento = new Ext.form.ComboBox({
		store:optionsTareasStore
		,displayField:'descripcion'
		,valueField:'id'
		,name:'tareaProcedimiento'
		,mode: 'local'
		,editable:false
		,triggerAction: 'all'
		, width : 200
		,fieldLabel : '<s:message code="plugin.masivo.confImpulso.busqueda.tareaProcedimiento" text="**Tarea" />'
	});
	
	
	filtroTipoJuicio.on('select', function(){
		Ext.Ajax.request({
			url: page.resolveUrl('msvconfimpulsoautomatico/consultaTareasProcedimiento')
			,params: {idTipoJuicio:filtroTipoJuicio.getValue()}
			,method: 'POST'
			,success: function (result, request){
				optionsTareasStore.webflow({'idTipoJuicio': filtroTipoJuicio.getValue()}); 
			}
			,error: function(result, request){
			}
			,failure: function(result, request){
			}
		}); 
	});
		
	var filtroConProcurador = new Ext.form.ComboBox({
		store: ["SI", "NO"]
		,name:'filtroConProcurador'
		,mode: 'local'
		,editable:false
		,triggerAction: 'all'
		,width:60
		,fieldLabel : '<s:message code="plugin.masivo.confImpulso.busqueda.conProcurador" text="**Con Procurador" />'
	});
	
 	<pfsforms:ddCombo name="filtroDespacho"
		labelKey="plugin.masivo.confImpulso.busqueda.despacho"
		label="**Despacho" value="" dd="${despachos}" propertyCodigo="id"
		propertyDescripcion="despacho" />

	var filtroCartera = new Ext.form.ComboBox({
				store: ${carteras}
				,name: 'filtroCartera'
				,mode: 'local'
				,emptyText:'---'
				,triggerAction: 'all'
				,fieldLabel : '<s:message code='plugin.masivo.confImpulso.busqueda.cartera' text='**Cartera' />'
	});
		
	<pfs:defineRecordType name="impulsosRT">
 		<pfs:defineTextColumn name="id"/>
		<pfs:defineTextColumn name="tipoJuicio" />
		<pfs:defineTextColumn name="tareaProcedimiento" />
        <pfs:defineTextColumn name="conProcurador" />
		<pfs:defineTextColumn name="despacho" />
		<pfs:defineTextColumn name="cartera" />
 	</pfs:defineRecordType>

	<pfs:defineColumnModel name="impulsosCM">
		<pfs:defineHeader dataIndex="tipoJuicio" caption="**Tipo Procedimiento"
			captionKey="plugin.masivo.confImpulso.busqueda.tipoJuicio"
			sortable="true" firstHeader="true"/>
		<pfs:defineHeader dataIndex="tareaProcedimiento" caption="**Tarea"
			captionKey="plugin.masivo.confImpulso.busqueda.tareaProcedimiento"
			sortable="true" />
		<pfs:defineHeader dataIndex="conProcurador" caption="**Procurador"
			captionKey="plugin.masivo.confImpulso.busqueda.conProcurador"
			sortable="true" />
		<pfs:defineHeader dataIndex="despacho" caption="**Despacho"
			captionKey="plugin.masivo.confImpulso.busqueda.despacho"
			sortable="true" />
		<pfs:defineHeader dataIndex="cartera" caption="**Cartera"
			captionKey="plugin.masivo.confImpulso.busqueda.cartera"
			sortable="true" />
 	</pfs:defineColumnModel>
	
	var btEliminar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />' 
		,iconCls : 'icon_menos'
		,handler : function(){
			if (gridImpulsos.getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" 	text="**Borrar" />', 
					'<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', 
					function(btn){
	    				if (btn == 'yes'){
	    					var parms = {};
	    					parms.id = gridImpulsos.getSelectionModel().getSelected().get('id');
	    					parms.filtroTipoJuicio = filtroTipoJuicio.getValue();
	    					parms.filtroTareaProcedimiento = filtroTareaProcedimiento.getValue();
	    					parms.filtroConProcurador = filtroConProcurador.getValue();
	    					parms.filtroDespacho = filtroDespacho.getValue();
	    					parms.filtroCartera = filtroCartera.getValue();
							page.webflow({
								flow: 'msvconfimpulsoautomatico/borraConfImpulso'
								,params: parms
								,success : function(){ 
									parms.id = '';
									gridImpulsos.store.webflow(parms); 
								}
							});
	    				}
					});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />',
					'<s:message code="plugin.masivo.confImpulso.busqueda.noValor" text="**No valor" />');
			}
		}
	});
	
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	
	<pfs:defineParameters name="getParametros" paramId=""
		filtroTipoJuicio="filtroTipoJuicio" 
		filtroTareaProcedimiento="filtroTareaProcedimiento" 
		filtroConProcurador="filtroConProcurador" 
		filtroDespacho="filtroDespacho" 
		filtroCartera="filtroCartera" 
	/>

	<pfs:searchPage searchPanelTitle="**Búsqueda de configuraciones de Impulsos Automáticos"
		searchPanelTitleKey="plugin.masivo.confImpulso.busqueda.titulo"
		gridPanelTitle="**Configuraciones de Impulsos Automáticos"
		gridPanelTitleKey="plugin.masivo.confImpulso.busqueda.gridTitulo"
		columnModel="impulsosCM" recordType="impulsosRT"
		dataFlow="msvconfimpulsoautomatico/buscaConfImpulso" parameters="getParametros"
		resultRootVar="impulsos" createTitle="**Nuevo Impulso"
		createTitleKey="plugin.masivo.confImpulso.busqueda.altaImpulso"
		createFlow="msvconfimpulsoautomatico/altaConfImpulso"
		updateFlow="msvconfimpulsoautomatico/consultaConfImpulso" newTabOnUpdate="true"
		updateTitleData="tipoJuicio" resultTotalVar="total" columns="4"
		buttonDelete="btEliminar" gridName="gridImpulsos"
		iconCls="icon_carteras" emptySearch="true">
			<pfs:items items="filtroTipoJuicio,filtroTareaProcedimiento" />
			<pfs:items items="filtroConProcurador,filtroDespacho,filtroCartera" />
	</pfs:searchPage>
	
	btnNuevo.show();
	
	filtroForm.getTopToolbar().add(buttonsL,'->', buttonsR);
	filtroForm.getTopToolbar().setHeight(filtroForm.getTopToolbar().getHeight());
	
	
</fwk:page>