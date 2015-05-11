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
	<pfs:hidden name="ESTADO_BLOQUEADO" value="${ESTADO_BLOQUEADO}"/>
	<pfs:hidden name="ESTADO_DISPONIBLE" value="${ESTADO_DISPONIBLE}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>
	
	<pfs:textfield name="filtroNombre"
			labelKey="plugin.recobroConfig.modeloFacturacion.abm.nombre" label="**Nombre"
			value="" searchOnEnter="true" />
			
	filtroNombre.id='filtroNombreABMFacturacion';		
			
	<pfsforms:ddCombo name="filtroCorrector"
		labelKey="plugin.recobroConfig.moduloFacturacion.abm.tipoCorrector"
		label="**Tipo Corrector" value="" dd="${ddTiposCorrector}" propertyCodigo="codigo" propertyDescripcion="descripcion"/>	
	
	filtroCorrector.id='filtroCorrectorABMFacturacion';		
	
	 var checkEsqVigente = new Ext.form.Checkbox({
         fieldLabel: '<s:message code="plugin.recobroConfig.moduloFacturacion.abm.esqVigente" text="**En Esq. Vigente"/>'
         ,inputValue: '1'
     });
     
     checkEsqVigente.id='checkEsqVigenteABMFacturacion';		
    								
	<pfsforms:ddCombo name="filtroEstado"
		labelKey="plugin.recobroConfig.moduloFacturacion.abm.estadoPeticion"
		label="**Estado petición" value="" dd="${ddEstados}" propertyCodigo="codigo" propertyDescripcion="descripcion"/>	
    
    filtroEstado.id = 'filtroEstadoABMFacturacion';
    								
	<pfs:defineRecordType name="Facturacion">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="enEsquemaVigente" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="tipoCorrector" />
			<pfs:defineTextColumn name="numeroTramos" />
			<pfs:defineTextColumn name="estado" />
			<pfs:defineTextColumn name="codigoEstado" />
			<pfs:defineTextColumn name="propietario" />
			<pfs:defineTextColumn name="idPropietario" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="facturacionCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.modelosFacturacion.columna.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="enEsquemaVigente"
			captionKey="plugin.recobroConfig.moduloFacturacion.abm.esqVigente" caption="**En Esq. Vigente"
			sortable="false" />
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.modelosFacturacion.columna.nombre" caption="**Nombre"
			sortable="true" />
		<pfs:defineHeader dataIndex="tipoCorrector"
			captionKey="plugin.recobroConfig.moduloFacturacion.abm.tipoCorrector" caption="**Tipo Corrector"
			sortable="false" />	
		<pfs:defineHeader dataIndex="numeroTramos"
			captionKey="plugin.recobroConfig.modelosFacturacion.columna.numTramos" caption="**Nº Tramos"
			sortable="false" />
		<pfs:defineHeader dataIndex="estado"
			captionKey="plugin.recobroConfig.politicaAcuerdos.columna.estado" caption="**Estado"
			sortable="true" />
		<pfs:defineHeader dataIndex="propietario"
			captionKey="plugin.recobroConfig.politicaAcuerdos.columna.propietario" caption="**Propietario"
			sortable="true" />	
	</pfs:defineColumnModel>
	
	<pfs:defineParameters name="getParametros" paramId="" 
		nombre="filtroNombre" tipoDeCorrector="filtroCorrector" esquemaVigente="checkEsqVigente" estado="filtroEstado"/>
	
	<pfs:remoteStore name="dataStore" 
		resultRootVar="modelosFacturacion" 
		resultTotalVar="total" 
		recordType="Facturacion" 
		dataFlow="recobromodelofacturacion/buscaModelosFacturacion" />

	var btBorrar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />'
		,iconCls : 'icon_menos'
		,id:'btBorrarABMFacturacion'
		,disabled: true
		,handler : function(){
			if (modeloFacturacionGrid.getSelectionModel().getCount()>0){
				Ext.Msg.confirm('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />', '<s:message code="pfs.tags.buttonremove.pregunta" text="**¿Está seguro de borrar?" />', function(btn){
    				if (btn == 'yes'){
    					var parms = getParametros();
    					parms.id = modeloFacturacionGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobromodelofacturacion/borrarModeloFacturacion'
							,params: parms
							,success : function(){ 
								modeloFacturacionGrid.store.webflow(parms);
								subCarterasGrid.store.webflow({idModFact:modeloFacturacionGrid.getSelectionModel().getSelected().get('id')}); 
							}
						});
    				}
				});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.borrar" text="**Borrar" />','<s:message code="${novalueMsgKey}" text="${novalueMsg}" />');
			}
		}
	});	
	
	var btCopiar= new Ext.Button({
		text : '<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />'
		,iconCls : 'icon_copy'
		,id: 'btCopiarABMFacturacion'
		,disabled : true
		,handler : function(){
			if (modeloFacturacionGrid.getSelectionModel().getCount()>0){
    					var parms = getParametros();
    					parms.idModFact= modeloFacturacionGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobromodelofacturacion/copiarModeloFacturacion'
							,params: parms
							,success : function(){ 
								modeloFacturacionGrid.store.webflow(parms);
								subCarterasGrid.store.webflow({idModFact:modeloFacturacionGrid.getSelectionModel().getSelected().get('id')}); 
							}
						});
			}else{
				Ext.Msg.alert('<s:message code="pfs.tags.buttonremove.copiar" text="**Copiar" />','<s:message code="plugin.recobroConfig.modeloRanking.noSeleccionado" text="**Debe seleccionar el modelo de ranking que desea copiar" />');
			}
		}
	});	
	
	var btLiberar= new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.modeloRanking.liberar" text="**Liberar" />'
		,iconCls : 'icon_play'
		,disabled : true
		,id: 'btLiberarABMFacturacion'
		,handler : function(){
			if (modeloFacturacionGrid.getSelectionModel().getCount()>0){
				// comprobar estado != en definicion 
    					var parms = getParametros();
    					parms.idModFact = modeloFacturacionGrid.getSelectionModel().getSelected().get('id');
    					page.webflow({
							flow: 'recobromodelofacturacion/liberarModeloFacturacion'
							,params: parms
							,success : function(){ 
								modeloFacturacionGrid.store.webflow(parms);
								subCarterasGrid.store.webflow({idModFact:modeloFacturacionGrid.getSelectionModel().getSelected().get('id')}); 
							}
						});
			}else{
				Ext.Msg.alert('<s:message code="plugin.recobroConfig.modeloRanking.liberar" text="**Liberar" />','<s:message code="plugin.recobroConfig.modeloRanking.liberar.error" text="**Debe seleccionar el modelo de ranking que desea liberar" />');
			}
		}
	});	
	

	var validarAntesDeBuscar = function(){
		buscarFunc();
	};

	var limit=25;
	var DEFAULT_WIDTH=700;

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
	
	var btnNuevoRecargar = app.crearBotonAgregar({
		flow : 'recobromodelofacturacion/addModelosFacturacion'
		,title : '<s:message code="plugin.recobroConfig.modeloFacturacion.alta.windowTitle" text="**Nuevo modelo de facturación" />'
		,text : '<s:message code="plugin.recobroConfig.modeloFacturacion.alta.windowTitle" text="**Nuevo modelo de facturación" />'
		,params : {}
		,width: 700
		//,closable:true
		,iconCls:'icon_agencia'
	});	
		
	var filtroForm = new Ext.Panel({
		title : '<s:message code="plugin.recobroConfig.modelosFacturacion.tabName" text="**Configuración de Modelos de Facturación" />'
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
				,items:[ filtroNombre, filtroCorrector ]
			}
			,{
				layout:'form'
				,items:[ filtroEstado, checkEsqVigente ]
			}
		]
		,tbar : [btnBuscar, btnReset, btnNuevoRecargar]
		,listeners:{	
			beforeExpand:function(){
				modeloFacturacionGrid.collapse(true);
				modeloFacturacionGrid.setHeight(200);
				subCarterasGrid.collapse(true);
				subCarterasGrid.setHeight(200);				
			}
			,beforeCollapse:function(){
				modeloFacturacionGrid.expand(true);
				modeloFacturacionGrid.setHeight(200);
				subCarterasGrid.collapse(true);
				subCarterasGrid.setHeight(200);			
			}
		}
		
	});	
	
	var pagingBar=fwk.ux.getPaging(dataStore);
	var cfg={
		title : '<s:message code="plugin.recobroConfig.modeloFacturacion.gridModelosFacturacion.title" text="**Modelos de facturacion" />'
		,collapsible : true
		,collapsed: true
		,titleCollapse : true
		,stripeRows:true
		,bbar : [pagingBar, btBorrar,btCopiar]
		,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,iconCls:'icon_facturacion'
	};
	var modeloFacturacionGrid=app.crearGrid(dataStore,facturacionCM,cfg);
	
	<%-- grid de carteras de un esquema --%>
	 
	<pfs:defineRecordType name="SubCarteras">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="esquema" />
			<pfs:defineTextColumn name="versionEsquema" />
			<pfs:defineTextColumn name="cartera" />
			<pfs:defineTextColumn name="tipoReparto" />
			<pfs:defineTextColumn name="fechaAltaModeloFacturacion" />
			<pfs:defineTextColumn name="fechaBaja" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="subCarteraCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.modelosFacturacion.columnaCartera.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="esquema"
			captionKey="plugin.recobroConfig.modelosFacturacion.columnaCartera.esquema" caption="**Esquema"
			sortable="true" />
		<pfs:defineHeader dataIndex="versionEsquema"
			captionKey="plugin.recobroConfig.modelosFacturacion.columnaCartera.versionEsquema" caption="**Version esquema"
			sortable="true" />
		<pfs:defineHeader dataIndex="cartera"
			captionKey="plugin.recobroConfig.modelosFacturacion.columnaCartera.cartera" caption="**Cartera"
			sortable="true" />	
		<pfs:defineHeader dataIndex="tipoReparto"
			captionKey="plugin.recobroConfig.modelosFacturacion.columnaCartera.subCartera" caption="**SubCartera"
			sortable="true" />
		<pfs:defineHeader dataIndex="fechaAltaModeloFacturacion"
			captionKey="plugin.recobroConfig.modelosFacturacion.columnaCartera.fechaAlta" caption="**Fecha Alta"
			sortable="true" />		
		<pfs:defineHeader dataIndex="fechaBaja"
			captionKey="plugin.recobroConfig.modelosFacturacion.columnaCartera.fechaBaja" caption="**Fecha Baja"
			sortable="true" />												
	</pfs:defineColumnModel>
	
	<pfs:remoteStore name="subCarteraStore" 
		resultRootVar="subCarteras" 
		recordType="SubCarteras" 
		dataFlow="recobromodelofacturacion/buscaSubCarterasModeloFacturacion" />
		
	
	var cfgSubCarteras={
		title : '<s:message code="plugin.recobroConfig.modelosFacturacion.gridSubCartera.title" text="**SubCarteras que tienen este modelo de Facturacion" />'
		,collapsible : true
		,collapsed: true
		,titleCollapse : true
		,stripeRows:true
		,height:200
		,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,iconCls:'icon_cartera'
	};
	var subCarterasGrid=app.crearGrid(subCarteraStore,subCarteraCM,cfgSubCarteras);
	
	<%--Ahora hacemos los métodos para visualizar el grid de carteras --%>
	var createTitle = function(row){
		return row.get('nombre');
	};
	 
	 
	modeloFacturacionGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
    	app.openTab(createTitle(rec)
							,'recobromodelofacturacion/openLauncher'
							,{idModFact:rec.get('id')}
							,{id:'modeloFacturacion'+rec.get('id') ,iconCls : 'icon_facturacion'});
    });
    
    
    modeloFacturacionGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e) {
    	var rec = modeloFacturacionGrid.getStore().getAt(rowIndex);
    	var idModFact = rec.get('id');
    	subCarteraStore.webflow({idModFact:idModFact});
    	subCarterasGrid.expand(true);
    	var codigoEstado = modeloFacturacionGrid.getSelectionModel().getSelected().get('codigoEstado');
    	var idPropietario = modeloFacturacionGrid.getSelectionModel().getSelected().get('idPropietario');
    	if (codigoEstado == ESTADO_BLOQUEADO.getValue()){
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
    <%--
    subCarterasGrid.on('rowdblclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
    	app.openTab(createTitle(rec)
    		,"recobrocartera/verCartera"
    		,{id:rec.get('id')}
    		,{id:'Cartera'+rec.get('id')
    		,iconCls:'icon_cartera'
    	});
    });
     --%>
     
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
    			,items:[modeloFacturacionGrid]
			},{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[subCarterasGrid]
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