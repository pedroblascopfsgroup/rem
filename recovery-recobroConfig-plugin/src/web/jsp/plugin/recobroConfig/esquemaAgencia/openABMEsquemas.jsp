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
	<pfs:hidden name="ESTADO_DEFINICION" value="${ESTADO_DEFINICION}"/>
	<pfs:hidden name="ESTADO_LIBERADO" value="${ESTADO_LIBERADO}"/>
	<pfs:hidden name="ESTADO_SIMULADO" value="${ESTADO_SIMULADO}"/>
	<pfs:hidden name="ESTADO_PENDIENTESIMULAR" value="${ESTADO_PENDIENTESIMULAR}"/>
	<pfs:hidden name="ESTADO_EXTINCION" value="${ESTADO_EXTINCION}"/>
	<pfs:hidden name="ESTADO_DESACTIVADO" value="${ESTADO_DESACTIVADO}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>
	
	
	<pfs:textfield name="filtroNombre"
			labelKey="plugin.recobroConfig.esquemaAgencia.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
			
	filtroNombre.id='filtroNombreOpenABMEsquemas';			
			
	<pfs:textfield name="filtroDescripcion"
			labelKey="plugin.recobroConfig.esquemaAgencia.descripcion" label="**Descripcion"
			value="" searchOnEnter="true" />
			
	filtroDescripcion.id='filtroDescripcionOpenABMEsquemas';		
			
	<pfs:textfield name="filtroAutor"
			labelKey="plugin.recobroConfig.esquemaAgencia.autor" label="**Autor"
			value="" searchOnEnter="true" />
			
	filtroAutor.id='filtroAutorOpenABMEsquemas';							
			
	<pfsforms:ddCombo name="filtroEstado"
		labelKey="plugin.recobroConfig.esquemaAgencia.estado"
		label="**Estado" value="" dd="${ddEstadosEsquema}" propertyCodigo="codigo" propertyDescripcion="descripcion"/>	
	
	filtroEstado.id='filtroEstadoOpenABMEsquemas';							
			
					
	<pfs:defineRecordType name="Esquema">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="version" />
			<pfs:defineTextColumn name="estadoEsquema" />
			<pfs:defineTextColumn name="codigoEstado" />
			<pfs:defineTextColumn name="fechaAlta" />
			<pfs:defineTextColumn name="fechaLiberacion" />
			<pfs:defineTextColumn name="fechaFinTransicion" />
			<pfs:defineTextColumn name="fechaDesactivacion" />
			<pfs:defineTextColumn name="esquemaAnterior" />
			<pfs:defineTextColumn name="usuarioCrear" />
			<pfs:defineTextColumn name="idPropietario" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="esquemaCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.esquemaAgencia.columna.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.esquemaAgencia.columna.nombre" caption="**Nombre"
			sortable="true" />	
		<pfs:defineHeader dataIndex="version"
			captionKey="plugin.recobroConfig.esquemaAgencia.columna.version" caption="**Version"
			sortable="true" />
		<pfs:defineHeader dataIndex="estadoEsquema"
			captionKey="plugin.recobroConfig.esquemaAgencia.columna.estado" caption="**Estado"
			sortable="true" />	
		<pfs:defineHeader dataIndex="fechaAlta"
			captionKey="plugin.recobroConfig.esquemaAgencia.columna.fechaAlta" caption="**F. Alta"
			sortable="true" />	
		<pfs:defineHeader dataIndex="fechaLiberacion"
			captionKey="plugin.recobroConfig.esquemaAgencia.columna.fechaLiberado" caption="**F. Liberado"
			sortable="true" />	
		<pfs:defineHeader dataIndex="fechaFinTransicion"
			captionKey="plugin.recobroConfig.esquemaAgencia.columna.fechaTransicion" caption="**F. Transición"
			sortable="true" />	
		<pfs:defineHeader dataIndex="fechaDesactivacion"
			captionKey="plugin.recobroConfig.esquemaAgencia.columna.fechaDesactivacion" caption="**F. Desactivación"
			sortable="true" />
		<pfs:defineHeader dataIndex="esquemaAnterior"
			captionKey="plugin.recobroConfig.esquemaAgencia.columna.esquemaTransicion" caption="**Esquema transición"
			sortable="true" />
		<pfs:defineHeader dataIndex="usuarioCrear"
			captionKey="plugin.recobroConfig.esquemaAgencia.columna.autor" caption="**Autor"
			sortable="true" />
	</pfs:defineColumnModel>
	
	<pfs:defineParameters name="getParametros" paramId="" 
		nombre="filtroNombre" descripcion="filtroDescripcion" autor="filtroAutor" estado="filtroEstado"/>
	
	var btBorrar= new Ext.Button({
			text : 'Borrar'
			,id : 'btnBorrarOpenABMEsquemas'
			,iconCls : 'icon_menos'
			,disabled: 'true'
			,handler : function(){
				if (esquemasGrid.getSelectionModel().getCount()>0){
					var nomEsquema = esquemasGrid.getSelectionModel().getSelected().get('nombre');
					Ext.Msg.confirm('<s:message code="app.borrar" text="**Borrar" />', '<s:message code="plugin.recobroConfig.esquemaAgencia.borrar.pregunta" text="**¿Está seguro de borrar el esquema \"{0}\"?" arguments="'+nomEsquema+'" />', function(btn){
	    				if (btn == 'yes'){
	    					var parms = getParametros();
	    					
	    					parms.id = esquemasGrid.getSelectionModel().getSelected().get('id');
	    					page.webflow({
								flow: 'recobroesquema/borrarRecobroEsquema'
								,params: parms
								,success : function(){ 
									app.closeTab({id:'Esquema'+parms.id});
									esquemasGrid.store.webflow(parms); 
								}
							});
	    				}
					});
				}else{
					Ext.Msg.alert('<s:message code="app.borrar" text="**Borrar" />','<s:message code="plugin.recobroConfig.esquemaAgencia.borrar.noValor" text="**Debe seleccionar un esquema de la lista" />');
				}
			}
	});		
		
	var btnCambiarEsquema = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.esquemaAgencia.btnCambiar" text="**Cambiar esquema" />'
		,id:'btnCambiarEsquemaOpenABMEsquemas'
		,iconCls : 'icon_open_esquema'
		,handler :  function(){
			if (esquemasGrid.getSelectionModel().getCount()>0){
    			var rec = esquemasGrid.getSelectionModel().getSelected();
		    	app.openTab(createTitle(rec)
		    		,"recobroesquema/abrirRecobroEsquema"
		    		,{idEsquema:rec.get('id'), botonPulsado: ''}
		    		,{id:'Esquema'+rec.get('id')
		    		,iconCls:'icon_esquema'}
		    	);
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttoncambiar.error" text="**Cambiar esquema" />','<s:message code="plugin.recobroConfig.esquemaAgencia.borrar.noValor" text="Debe seleccionar un esquema de la lista" />');
			}
		}
	});	
	
				
	var limit=25;
	var DEFAULT_WIDTH=700;

	var createTitle = function(row){
		return row.get('nombre');
	};

	<pfs:remoteStore name="dataStore" 
		resultRootVar="esquemas" 
		resultTotalVar="total" 
		recordType="Esquema" 
		dataFlow="recobroesquema/buscaRecobroEsquema" />


	var validarAntesDeBuscar = function(){
		buscarFunc();
	};


	var buscarFunc = function(){
                var params= getParametros();
                params.start=0;
                params.limit=limit;
                dataStore.webflow(params);
				//Cerramos el panel de filtros y esto hará que se abra el listado de personas
				filtroForm.collapse(true);
	};	
	
	var btnBuscar=app.crearBotonBuscar({
		handler : validarAntesDeBuscar
	});
	
	var btnReset = app.crearBotonResetCampos(getParametros_camposFormulario);
	
		
	var filtroForm = new Ext.Panel({
		title : '<s:message code="plugin.recobroConfig.esquemaAgencia.tabName" text="**Configuración de Esquemas de Agencias" />'
		,autoHeight:true
		,autoWidth:true
		,layout:'table'
		,layoutConfig:{columns:3}
		,titleCollapse : true
		,collapsible:true
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[
			{width:'0px'}
			,{
				layout:'form'
				,items:[ filtroNombre, filtroDescripcion]
			}
			,{
				layout:'form'
				,items:[ filtroEstado, filtroAutor]
			}
		]
		,tbar : [btnBuscar, btnReset]
		,listeners:{	
			beforeExpand:function(){
				esquemasGrid.collapse(true);
				esquemasGrid.setHeight(200);
				carterasGrid.collapse(true);
				carterasGrid.setHeight(200);				
			}
			,beforeCollapse:function(){
				esquemasGrid.expand(true);
				esquemasGrid.setHeight(200);
				carterasGrid.collapse(true);
				carterasGrid.setHeight(200);
			}
		}
		
	});	
	
	var recargarBotones= function(){
		if (esquemasGrid.getSelectionModel().getCount()>0){
			var rec = esquemasGrid.getSelectionModel().getSelected();
    		var idEsquema = rec.get('id');
    		var codigoEstado = rec.get('codigoEstado');
    		var idPropietario = rec.get('idPropietario');
			if (codigoEstado == ESTADO_LIBERADO.getValue() ||codigoEstado ==ESTADO_EXTINCION.getValue()){
    			btBorrar.setDisabled(true);
    			btCopiar.setDisabled(false);
    		} else {
    			if (idPropietario != usuarioLogado.getValue()){
    				btBorrar.setDisabled(true);
    			} else {
    				btBorrar.setDisabled(false);
    			}
    			if (codigoEstado == ESTADO_DEFINICION.getValue()){
    				btCopiar.setDisabled(true);
    			} else {
    				btCopiar.setDisabled(false);
    			}
    		}	
    	} else {
    		btCopiar.setDisabled(true);
    		btBorrar.setDisabled(true);
		}
	}
	
	var btCopiar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />'
		,iconCls : 'icon_copy'
		,id: 'btCopiarOpenABMEsquema'
		,disabled : true
		,handler : function(){
			if (esquemasGrid.getSelectionModel().getCount()>0){
    					var parms = getParametros();
    					parms.idEsquema = esquemasGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobroesquema/copiarEsquema'
							,params: parms
							,success : function(){ 
								esquemasGrid.store.webflow(parms);
								carteraStore.webflow({idEsquema: esquemasGrid.getSelectionModel().getSelected().get('id')});
								recargarBotones();
						}	
					});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />','<s:message code="plugin.recobroConfig.modeloRanking.noSeleccionado" text="**Debe seleccionar el modelo de ranking que desea copiar" />');
			}
		}
	});	
	
	var pagingBar=fwk.ux.getPaging(dataStore);
	var cfg={
		title : '<s:message code="plugin.recobroConfig.esquemaAgencia.gridEsquema.title" text="**Esquemas de agencias de recobro" />'
		,collapsible : true
		,collapsed: true
		,titleCollapse : true
		,stripeRows:true
		,id:'esquemasGridOpenABMEsquemas'
		,bbar : [  pagingBar,btnCambiarEsquema,btBorrar,btCopiar ]
		,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,iconCls:'icon_esquema'
	};
	var esquemasGrid=app.crearGrid(dataStore,esquemaCM,cfg);
	
	<%-- grid de carteras de un esquema --%>
	 
	<pfs:defineRecordType name="Cartera">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="tipoCartera" />
			<pfs:defineTextColumn name="prioridad" />
			<pfs:defineTextColumn name="tipoGestion" />
			<pfs:defineTextColumn name="generacionExpediente" />
			<pfs:defineTextColumn name="idPropietario" />
			<pfs:defineTextColumn name="codigoEstado" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="carteraCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.nombre" caption="**Nombre"
			sortable="true" />	
		<pfs:defineHeader dataIndex="tipoCartera"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.tipoCartera" caption="**Tipo cartera"
			sortable="true" />	
		<pfs:defineHeader dataIndex="prioridad"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.prioridad" caption="**Prioridad"
			sortable="true" />	
		<pfs:defineHeader dataIndex="tipoGestion"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.tipoGestion" caption="**Tipo gestión"
			sortable="true" />	
		<pfs:defineHeader dataIndex="generacionExpediente"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.generacionExpediente" caption="**Generación de expediente"
			sortable="true" />						
	</pfs:defineColumnModel>
	
	<pfs:remoteStore name="carteraStore" 
		resultRootVar="carteras" 
		recordType="Cartera" 
		dataFlow="recobroesquema/buscaCarterasEsquema" />
		
	var btnVerCartera = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.esquemaAgencia.btnVerCartera" text="**Ver cartera" />'
		<app:test id="btnVerCartera" addComa="true" />
		,iconCls : 'icon_objetivos_pendientes'
		,id :'btnVerCarteraOpenABMEsquemas'
		,handler :  function(){
			if (carterasGrid.getSelectionModel().getCount()>0){
    			var rec = carterasGrid.getSelectionModel().getSelected();
		    	app.openTab(createTitle(rec)
		    		,"recobrocartera/verCartera"
		    		,{id:rec.get('id')}
		    		,{id:'Cartera'+rec.get('id')
		    		,iconCls:'icon_cartera'
		    	});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.esquemaAgencia.btnVerCartera" text="**Cambiar esquema" />','<s:message code="plugin.recobroConfig.cartera.borrar.noValor" text="Debe seleccionar un esquema de la lista" />');
			}
		}
	});		
	
	var cfgCarteras={
		title : '<s:message code="plugin.recobroConfig.esquemaAgencia.gridCartera.title" text="**Carteras que conforman el esquema seleccionado" />'
		,collapsible : true
		,collapsed: true
		,id:'carterasGridOpenABMEsquemas'
		,bbar : [  btnVerCartera ]
		,titleCollapse : true
		,stripeRows:true
		,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,iconCls:'icon_cartera'
	};
	var carterasGrid=app.crearGrid(carteraStore,carteraCM,cfgCarteras);
	
	<%--Ahora hacemos los métodos para visualizar el grid de carteras --%>
	esquemasGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
    	app.openTab(createTitle(rec)
    		,"recobroesquema/abrirRecobroEsquema"
    		,{idEsquema:rec.get('id'), botonPulsado: ''}
    		,{id:'Esquema'+rec.get('id')
    		,iconCls:'icon_esquema'
    	});
    });
    
    esquemasGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e){
    	var rec = esquemasGrid.getStore().getAt(rowIndex);
    	var idEsquema = rec.get('id');
    	carteraStore.webflow({idEsquema:idEsquema});
    	carterasGrid.expand(true);
    	var codigoEstado = esquemasGrid.getSelectionModel().getSelected().get('codigoEstado');
    	var idPropietario = esquemasGrid.getSelectionModel().getSelected().get('idPropietario');
    	if (codigoEstado == ESTADO_LIBERADO.getValue() ||codigoEstado ==ESTADO_EXTINCION.getValue()){
    		btBorrar.setDisabled(true);
    		btCopiar.setDisabled(false);
    	} else {
    		if (idPropietario != usuarioLogado.getValue()){
    			btBorrar.setDisabled(true);
    		} else {
    			btBorrar.setDisabled(false);
    		}
    		if (codigoEstado == ESTADO_DEFINICION.getValue()){
    			btCopiar.setDisabled(true);
    		} else {
    			btCopiar.setDisabled(false);
    		}
    	}
    });
    
    carterasGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
    	app.openTab(createTitle(rec)
    		,"recobrocartera/verCartera"
    		,{id:rec.get('id')}
    		,{id:'Cartera'+rec.get('id')
    		,iconCls:'icon_cartera'
    	});
    });
    
    var mainPanel = new Ext.Panel({
		items : [
			{
				layout:'form'
				,defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'margin:10px;padding:5px;cellspacing:10px;margin-bottom:0px'
				,items:[filtroForm]
			}
			,{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[esquemasGrid]
			},{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[carterasGrid]
			}
    	]
	    //,bodyStyle:'padding:10px'
	    ,autoHeight : true
	    ,border: false
    });
	
	//añadimos al padre y hacemos el layout
	page.add(mainPanel);			
	
	<%-- 
	btBorrar.hide();
	<sec:authorize ifAllGranted="ROLE_CONF_ESQUEMA">
		btBorrar.show();
	</sec:authorize>
	
	--%>
</fwk:page>	