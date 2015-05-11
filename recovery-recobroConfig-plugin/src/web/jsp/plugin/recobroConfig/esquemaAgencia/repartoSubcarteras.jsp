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
	
	var idEsquema='${idEsquema}';
	
	<pfs:hidden name="txtIdEsquema" value="${idEsquema}"/>
	<pfs:hidden name="ESTADO_DEFINICION" value="${ESTADO_DEFINICION}"/>
	<pfs:hidden name="ESTADO_LIBERADO" value="${ESTADO_LIBERADO}"/>
	<pfs:hidden name="ESTADO_SIMULADO" value="${ESTADO_SIMULADO}"/>
	<pfs:hidden name="ESTADO_PENDIENTESIMULAR" value="${ESTADO_PENDIENTESIMULAR}"/>
	<pfs:hidden name="ESTADO_EXTINCION" value="${ESTADO_EXTINCION}"/>
	<pfs:hidden name="ESTADO_DESACTIVADO" value="${ESTADO_DESACTIVADO}"/>
	<pfs:hidden name="SIN_GESTION" value="${SIN_GESTION}"/>
	<pfs:hidden name="usuarioLogado" value="${usuarioLogado.id}"/>
	
	<pfs:defineParameters name="params" paramId="" idEsquema="txtIdEsquema"/>

	<pfs:defineRecordType name="ultimoEsquemaRecord">
		<pfs:defineTextColumn name="id" />
		<pfs:defineTextColumn name="nombre" />
		<pfs:defineTextColumn name="nombreVersion" />
	</pfs:defineRecordType>
	
	<pfs:remoteStore name="ultimoEsquemaStore" 
		resultRootVar="esquema" 
		recordType="ultimoEsquemaRecord" 
		dataFlow="recobroesquema/getUltimaVersionEsquema" />
		
	var cambiaNombreTab = function(id, nombreVersion) {
		var TabPanel = Ext.getCmp('contenido');
		TabPanel.getItem(id).setTitle(nombreVersion);
	};
	
	var cargaUltimoEsquema = function() {
		ultimoEsquemaStore.webflow({idEsquema: idEsquema});
	};

	ultimoEsquemaStore.on('load', function(store, records, options){
		if (records.length > 0 ) {
			var idUltimoEsquema = records[0].get('id');
			if (idUltimoEsquema != idEsquema) {
				app.closeTab({id:'Esquema'+idEsquema});
				
				app.openTab(records[0].get('nombreVersion')
		    		,"recobroesquema/abrirRecobroEsquema"
		    		,{idEsquema: idUltimoEsquema, botonPulsado: '3'}		    		
		    		,{id:'Esquema'+idUltimoEsquema
		    		,iconCls:'icon_esquema'}
		    	);
		    } else {
		    	cambiaNombreTab('Esquema'+idEsquema,records[0].get('nombreVersion'));
		    	recargarGrids();
		    }
    	} else {
    		recargarGrids();
    	}		
	});
	
	var rowEsquema = 0;	
	
    var recargarGrids = function(){
    	var paramRecargar = {idEsquema: idEsquema};
        carterasEsquemaDS.webflow(paramRecargar);
        refrescaGridSubCarteras(rowEsquema);
    }
    
    <pfs:defineRecordType name="carterasEsquema">
			<pfs:defineTextColumn name="idCarteraEsquema" />
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="tipoCartera" />
			<pfs:defineTextColumn name="codigoTipoCartera" />
			<pfs:defineTextColumn name="prioridad" />
			<pfs:defineTextColumn name="tipoGestion" />
			<pfs:defineTextColumn name="tipoGestionCodigo" />
			<pfs:defineTextColumn name="generacionExpediente" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="carterasEsquemaCM">
		<pfs:defineHeader dataIndex="idCarteraEsquema"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.idCarteraEsquema" caption="**IdCarteraEsquema"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.id" caption="**Id"
			sortable="true" hidden="true"/>
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
    
    <pfs:remoteStore name="carterasEsquemaDS" resultRootVar="carteras" recordType="carterasEsquema" parameters="params" dataFlow="recobroesquema/buscaCarterasEsquema" autoload="true"/>
    
     var btnRepEstatico = new Ext.Button({
        text:'<s:message code="plugin.recobroConfig.repartoSubCarteras.btnRepEstatico" text="**Reparto Estático" />'
        ,iconCls:'icon_distStatic'
        ,disabled:true		
        ,hidden:true	
    });    
    
    var abreRepEstatico = function() {
    	if (gridCarterasEsquema.getSelectionModel().getCount()>0){
			var idCarteraEsquema = gridCarterasEsquema.getSelectionModel().getSelected().get('idCarteraEsquema');
			var nomCartera = gridCarterasEsquema.getSelectionModel().getSelected().get('nombre');
			if (idCarteraEsquema != ''){
    			var allowClose= false;
				var w = app.openWindow({
					flow: 'recobroesquema/abrirFrmRepartoAgencias'
					,closable: true
					,width : 700
					,title :  '<s:message code="plugin.recobroConfig.repartoSubCarteras.win.Estatico.title" text="**Nuevo reparto estático: {0}" arguments="'+nomCartera+'"/>'
					,params: {idCarteraEsquema:idCarteraEsquema,
					codTipoReparto:'${REP_ESTATICO}',
					idSubCartera:null}
				});
				w.on(app.event.DONE, function(){
					cargaUltimoEsquema();
					w.close();
				});
				w.on(app.event.CANCEL, function(){
					 w.close(); 
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.debeSeleccionarCartera" text="**Debe seleccionar una cartera" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.debeSeleccionarCartera" text="**Debe seleccionar una cartera" />');
		}
    };
    
    btnRepEstatico.on('click',abreRepEstatico);
    
    var btnRepDinamico = new Ext.Button({
        text:'<s:message code="plugin.recobroConfig.repartoSubcarteras.btnRepDinamico" text="**Reparto Dinámico" />'
        ,iconCls:'icon_distDinamic'
        ,disabled:true	
        ,hidden:true	
    });    
    
     btnRepDinamico.on('click',function() {
    	if (gridCarterasEsquema.getSelectionModel().getCount()>0){
			var idCarteraEsquema = gridCarterasEsquema.getSelectionModel().getSelected().get('idCarteraEsquema');
			var nomCartera = gridCarterasEsquema.getSelectionModel().getSelected().get('nombre');
			if (idCarteraEsquema != ''){
    			var allowClose= false;
				var w = app.openWindow({
					flow: 'recobroesquema/abrirFrmRepartoAgencias'
					,closable: true
					,width : 700
					,title :  '<s:message code="plugin.recobroConfig.repartoSubCarteras.win.dinamico.title" text="**Nuevo reparto dinámico: {0}" arguments="'+nomCartera+'"/>'
					,params: {idCarteraEsquema:idCarteraEsquema,
						codTipoReparto:'${REP_DINAMICO}',
						idSubCartera:null}
				});
				w.on(app.event.DONE, function(){
					cargaUltimoEsquema();
					w.close();
				});
				w.on(app.event.CANCEL, function(){
					 w.close(); 
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.debeSeleccionarCartera" text="**Debe seleccionar una cartera" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.debeSeleccionarCartera" text="**Debe seleccionar una cartera" />');
		}
    });
    
    var pagingCarterasEsquemaBar=fwk.ux.getPaging(carterasEsquemaDS);

	var gridCarterasEsquema = new Ext.grid.GridPanel({
        store: carterasEsquemaDS
        ,cm: carterasEsquemaCM
        ,title: '<s:message code="plugin.recobroConfig.repartoSubCarteras.gridCarterasEsquema.title" text="**Carteras en Esquema"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[pagingCarterasEsquemaBar,btnRepEstatico,btnRepDinamico]
    });		 
    
    var refrescaGridSubCarteras = function(rowIndex){
		var rec = gridCarterasEsquema.getStore().getAt(rowIndex);
    	var idCarteraEsquema = rec.get('idCarteraEsquema');
    	subCarterasDS.webflow({idCarteraEsquema:idCarteraEsquema});
	}
	
    
    <pfs:defineRecordType name="subCarteras">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="idCarteraEsquema" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="particion" />
			<pfs:defineTextColumn name="tipoReparto" />
			<pfs:defineTextColumn name="modeloFacturacion" />	
	</pfs:defineRecordType>

	<pfs:remoteStore name="subCarterasDS" resultRootVar="subCarteras" recordType="subCarteras" dataFlow="recobroesquema/buscaSubCarterasCarteraEsquema" autoload="false"/>
	        
	<pfs:defineColumnModel name="subCarterasCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.repartoSubCarteras.columnaSubCartera.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="idCarteaEsquema"
			captionKey="plugin.recobroConfig.repartoSubCarteras.columnaSubCartera.idCarteraEsquema" caption="**id Cartera Esquema"
			sortable="true" hidden="true"/>
		<pfs:defineHeader dataIndex="tipoReparto"
			captionKey="plugin.recobroConfig.repartoSubCarteras.columnaSubCartera.tipoReparto" caption="**Tipo"
			sortable="true" />
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.repartoSubCarteras.columnaSubCartera.nombre" caption="**Nombre"
			sortable="true" />
		<pfs:defineHeader dataIndex="particion"
			captionKey="plugin.recobroConfig.repartoSubCarteras.columnaSubCartera.particion" caption="**% partición"
			sortable="true" />
		<pfs:defineHeader dataIndex="modeloFacturacion"
			captionKey="plugin.recobroConfig.repartoSubCarteras.columnaSubCartera.modeloFacturacion" caption="**Modelo Facturación"
			sortable="true" hidden="true"/>		
	</pfs:defineColumnModel>
	
    
    var btnVer = new Ext.Button({
        text:'<s:message code="plugin.recobroConfig.repartoSubcarteras.btnVer" text="**Ver Reparto" />'
        ,iconCls:'icon_objetivos_pendientes'
        ,disabled:false	
        ,hidden:false	
    });
    
    var abreReparto = function() {
    	if (gridSubCarteras.getSelectionModel().getCount()>0){
			var idSubCartera = gridSubCarteras.getSelectionModel().getSelected().get('id');
			var nomCartera = gridSubCarteras.getSelectionModel().getSelected().get('nombre');
			if (id != ''){
    			var allowClose= false;
				var w = app.openWindow({
					flow: 'recobroesquema/abrirFrmRepartoAgenciasVisualizar'
					,closable: true
					,width : 700
					,title :  '<s:message code="plugin.recobroConfig.repartoSubCarteras.win.ver.title" text="**Ver {0}" arguments="'+nomCartera+'"/>'
					,params: {idCarteraEsquema:null,idSubCartera:idSubCartera,codTipoReparto:null,disable:true}
				});
				w.on(app.event.DONE, function(){
					cargaUltimoEsquema();
					w.close();
				});
				w.on(app.event.CANCEL, function(){
					 w.close(); 
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.debeSeleccionarSubCartera" text="**Debe seleccionar una subCartera" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.debeSeleccionarSubCartera" text="**Debe seleccionar una subCartera" />');
		}
    };
    
    btnVer.on('click',abreReparto);
    
    
    var btnModificar = new Ext.Button({
        text:'<s:message code="plugin.recobroConfig.repartoSubcarteras.btnModificar" text="**Modificar Reparto" />'
        ,iconCls:'icon_edit'
        ,disabled:true		
        ,hidden:true	
    });    
    
    var abreModificarReparto = function() {
    	if (gridSubCarteras.getSelectionModel().getCount()>0){
			var idSubCartera = gridSubCarteras.getSelectionModel().getSelected().get('id');
			var nomCartera = gridSubCarteras.getSelectionModel().getSelected().get('nombre');
			if (id != ''){
    			var allowClose= false;
				var w = app.openWindow({
					flow: 'recobroesquema/abrirFrmRepartoAgencias'
					,closable: true
					,width : 700
					,title :  '<s:message code="plugin.recobroConfig.repartoSubCarteras.win.modificar.title" text="**Modificar {0}" arguments="'+nomCartera+'"/>'
					,params: {idCarteraEsquema:null,idSubCartera:idSubCartera,codTipoReparto:null}
				});
				w.on(app.event.DONE, function(){
					cargaUltimoEsquema();
					w.close();
				});
				w.on(app.event.CANCEL, function(){
					 w.close(); 
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.debeSeleccionarSubCartera" text="**Debe seleccionar una subCartera" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.debeSeleccionarSubCartera" text="**Debe seleccionar una subCartera" />');
		}
    };
    
    btnModificar.on('click',abreModificarReparto);
    
    var btnBorrar = new Ext.Button({
        text:'<s:message code="plugin.recobroConfig.repartoSubcarteras.btnBorrar" text="**Borrar Reparto" />'
        ,iconCls:'icon_cancel'
        ,disabled:true		
        ,hidden:true	
    });    
    
    btnBorrar.on('click',function() {
    	if (gridSubCarteras.getSelectionModel().getCount()>0){
	    	var idSubCartera = gridSubCarteras.getSelectionModel().getSelected().get('id');
			var nombreSubCartera = gridSubCarteras.getSelectionModel().getSelected().get('nombre');
			if (idSubCartera != ''){
				Ext.Msg.confirm('<s:message code="app.borrar" text="**Borrar" />', '<s:message code="plugin.recobroConfig.repartoSubCarteras.borrar.pregunta" text="**¿Está seguro de borrar el reparto {0}?" arguments="'+nombreSubCartera+'" />', function(btn){				
    				if (btn == "yes") {
	    				Ext.Ajax.request({
							url: app.resolveFlow('recobroesquema/borrarRepartoSubCartera')
							,params: {idSubCartera:idSubCartera}
							,method: 'POST'
							,success : function(){
								cargaUltimoEsquema();
								}
							,failure: function(){
									Ext.Msg.alert('<s:message code="app.borrar" text="**Borrar" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.borrar.error" text="**Ha ocurrido un error y no se ha podido borrar el reparto" />');
								}
							})
					}
				});
	 		}else{
				Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.debeSeleccionarSubCartera" text="**Debe seleccionar una SubCartera" />');
			}
		}else{
			Ext.Msg.alert('<s:message code="app.aviso" text="**Aviso" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.debeSeleccionarSubCartera" text="**Debe seleccionar una SubCartera" />');
		}
    });
    
    <sec:authorize ifAllGranted="ROLE_CONF_REPARTOSUBCARTERAS">
    	btnRepDinamico.show();
		btnRepEstatico.show();
		btnModificar.show();
		btnBorrar.show();
	</sec:authorize>	
	
    var pagingCarterasBar=fwk.ux.getPaging(subCarterasDS);

	var gridSubCarteras = new Ext.grid.GridPanel({
        store: subCarterasDS
        ,cm: subCarterasCM
        ,title: '<s:message code="plugin.recobroConfig.repartoSubCarteras.gridSubCarteras.title" text="**SubCarteras y modelos de reparto"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[pagingCarterasBar,btnVer,btnModificar,btnBorrar]
    });	
    
    var panel = new Ext.Panel({    
	    autoHeight : true
	    ,autoWidth : true
	    ,border: false	    
	    ,items: [    
		     gridCarterasEsquema,gridSubCarteras]
	});
	
	ultimaVersionDelEsquema=${ultimaVersionDelEsquema};
	gridCarterasEsquema.getSelectionModel().on('rowselect', function(sm, rowIndex, e){
    	var rec = gridCarterasEsquema.getStore().getAt(rowIndex);
    	var tipoCartera = rec.get('codigoTipoCartera');
    	var tipoGestion = rec.get('tipoGestionCodigo');
    	if(tipoCartera=='FIL' || tipoGestion==SIN_GESTION.getValue() ){
    		btnRepDinamico.setDisabled(true);
    		btnRepEstatico.setDisabled(true);
    		btnModificar.setDisabled(true);
 			btnBorrar.setDisabled(true);
    	} else {
    		if (ultimaVersionDelEsquema && '${esquema.propietario.id}' == usuarioLogado.getValue()) {
   			btnRepEstatico.setDisabled(false);
 			btnRepDinamico.setDisabled(false);
 			btnModificar.setDisabled(false);
 			btnBorrar.setDisabled(false);
 			gridSubCarteras.on('rowdblclick',abreModificarReparto);
    		} else {
    			btnRepEstatico.setDisabled(true);
 				btnRepDinamico.setDisabled(true);
 				btnModificar.setDisabled(true);
 				btnBorrar.setDisabled(true);
    		}
    	}
    	refrescaGridSubCarteras(rowIndex);
    	rowEsquema=rowIndex;
    });
    
	
	
    
	page.add(panel);
			
	
</fwk:page>	