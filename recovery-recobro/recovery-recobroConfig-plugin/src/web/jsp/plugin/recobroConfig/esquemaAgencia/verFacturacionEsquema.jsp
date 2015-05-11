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
	
	<%-- grid de carteras de un esquema --%>
	 
	<pfs:defineRecordType name="Cartera">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="tipoCartera" />
			<pfs:defineTextColumn name="prioridad" />
			<pfs:defineTextColumn name="tipoGestion" />
			<pfs:defineTextColumn name="generacionExpediente" />
			<pfs:defineTextColumn name="idCarteraEsquema" />
			<pfs:defineTextColumn name="codigoTipoCartera" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="carteraCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="idCarteraEsquema"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.idCarteraEsquema" caption="**Id CarteraEsquema"
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
	
	<pfs:remoteStore name="carteraStore" 
		resultRootVar="carteras" 
		recordType="Cartera" 
		dataFlow="recobroesquema/buscaCarterasEsquema" />
		
	
	var carterasGrid = new Ext.grid.GridPanel({
        store: carteraStore
        ,cm: carteraCM
        ,title: '<s:message code="plugin.recobroConfig.esquemaAgencia.gridCartera.title" text="**Carteras que conforman el esquema seleccionado"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
    });	

	var ultimaVersionDelEsquema=${ultimaVersionDelEsquema};
	var idEsquema='${idEsquema}';
	carteraStore.webflow({idEsquema:idEsquema});
	
	<%-- grid de carteras de un esquema --%>
	 
	<pfs:defineRecordType name="SubCartera">
			<pfs:defineTextColumn name="id" />
			<pfs:defineTextColumn name="nombre" />
			<pfs:defineTextColumn name="particion" />
			<pfs:defineTextColumn name="tipoReparto" />
			<pfs:defineTextColumn name="modeloFacturacion" />
			<pfs:defineTextColumn name="itinerarioMetasVolantes" />
			<pfs:defineTextColumn name="politicaAcuerdos" />
			<pfs:defineTextColumn name="modelosDeRanking" />
			<pfs:defineTextColumn name="idCarteraEsquema" />
	</pfs:defineRecordType>
	
	<pfs:defineColumnModel name="subCarteraCM">
		<pfs:defineHeader dataIndex="id"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.id" caption="**Id"
			sortable="true" firstHeader="true" hidden="true"/>
		<pfs:defineHeader dataIndex="idCarteraEsquema"
			captionKey="plugin.recobroConfig.esquemaAgencia.columnaCartera.idCarteraEsquema" caption="**Id Cartera esquema"
			sortable="true" hidden="true"/>	
		<pfs:defineHeader dataIndex="nombre"
			captionKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.nombre" caption="**Nombre"
			sortable="true" />
		<pfs:defineHeader dataIndex="tipoReparto"
			captionKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.tipoReparto" caption="**Tipo reparto"
			sortable="true" />
		<pfs:defineHeader dataIndex="particion"
			captionKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.particion" caption="**Partición"
			sortable="true" />
		<pfs:defineHeader dataIndex="modeloFacturacion"
			captionKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.modeloFacturacion" caption="**Modelo facturación"
			sortable="true" />
		<pfs:defineHeader dataIndex="itinerarioMetasVolantes"
			captionKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.itinerarioMetasVolantes" caption="**Metas volantes"
			sortable="true" />													
		<pfs:defineHeader dataIndex="politicaAcuerdos"
			captionKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.politicaAcuerdos" caption="**Política de acuerdos"
			sortable="true" />
		<pfs:defineHeader dataIndex="modelosDeRanking"
			captionKey="plugin.recobroConfig.esquemaAgencia.listadoSubcareras.modelosDeRanking" caption="**Modelos de ranking"
			sortable="true" />
	</pfs:defineColumnModel>
	
	<pfs:remoteStore name="subCarteraStore" 
		resultRootVar="subCarteras" 
		recordType="SubCartera" 
		dataFlow="recobroesquema/buscaSubCarterasCarteraEsquema" />
		
	<pfs:defineRecordType name="ultimoEsquemaRecord">
		<pfs:defineTextColumn name="id" />
		<pfs:defineTextColumn name="nombre" />
		<pfs:defineTextColumn name="nombreVersion" />
	</pfs:defineRecordType>
	
	<pfs:remoteStore name="ultimoEsquemaStore" 
		resultRootVar="esquema" 
		recordType="ultimoEsquemaRecord" 
		dataFlow="recobroesquema/getUltimaVersionEsquema" />
		
	
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
		    		,{idEsquema: idUltimoEsquema, botonPulsado: '4'}
		    		,{id:'Esquema'+idUltimoEsquema
		    		,iconCls:'icon_esquema'
		    	});
		    } else {
				var TabPanel = Ext.getCmp('contenido');
				TabPanel.getItem('Esquema'+idEsquema).setTitle(records[0].get('nombreVersion'));
			}
    	}
		
	});
		
	var cambiaFacturacion = function() {
		if (subCarterasGrid.getSelectionModel().getCount()>0){
   			var rec = subCarterasGrid.getSelectionModel().getSelected();
	    	var w= app.openWindow({
				flow: 'recobroesquema/cambiarModeloGestion'
				,width : 700
				,title : '<s:message code="plugin.recobroConfig.esquemaAgencia.listadoSubcarteras.tituloEditarModelos" text="**Editar modelos" />'
				,params: {idSubCartera:rec.get('id')}
			});
			w.on(app.event.DONE, function (){
				w.close();
				subCarterasGrid.store.webflow({idCarteraEsquema:rec.get('idCarteraEsquema')}); 
				cargaUltimoEsquema();
				
			});
			w.on(app.event.CANCEL, function(){
				 w.close(); 
			});
		}else{
			Ext.Msg.alert('<s:message code="plugin.recobroConfig.esquemaAgencia.listadoSubcarteras.tituloEditarModelos" text="**Editar modelos" />','<s:message code="plugin.recobroConfig.repartoSubCarteras.debeSeleccionarSubCartera" text="**Debe seleccionar una subcartera del listado" />');
		}
	};
	
	
	var btnCambiarFacturacion = new Ext.Button({
		text : '<s:message code="plugin.recobroConfig.esquemaAgencia.listadoSubcarteras.tituloEditarModelos" text="**Editar modelos" />'
		<app:test id="btnCambiarFacturacion" addComa="true" />
		,iconCls : 'icon_edit'
		,disabled : true
		,handler :  function(){
			cambiaFacturacion();
		}
	});	
	
	
	var subCarterasGrid = new Ext.grid.GridPanel({
        store: subCarteraStore
        ,cm: subCarteraCM
        ,title: '<s:message code="plugin.recobroConfig.esquemaAgencia.gridSubCartera.title" text="**Subcarteras de la cartera seleccionada"/>'
        ,stripeRows: true
        ,height: 200
        ,resizable:true
		,dontResizeHeight:true
		,cls:'cursor_pointer'
		,style:'padding: 10px;'
		,viewConfig : {  forceFit : true}
		,monitorResize: true
		,bbar:[btnCambiarFacturacion]
    });	
	
  	ultimaVersionDelEsquema=${ultimaVersionDelEsquema};
  	
    carterasGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, e){
    	var rec = carterasGrid.getStore().getAt(rowIndex);
    	var idCarteraEsquema = rec.get('idCarteraEsquema');
    	subCarteraStore.webflow({idCarteraEsquema:idCarteraEsquema});
    	if (ultimaVersionDelEsquema && '${esquema.propietario.id}' == usuarioLogado.getValue()){
    		subCarterasGrid.on('rowdblclick', function(grid, rowIndex, e) {
				cambiaFacturacion();
   			});
   			if (rec.get('codigoTipoCartera')=='FIL') {
   				btnCambiarFacturacion.setDisabled(true);
   			} else {
    			btnCambiarFacturacion.setDisabled(false);
    		}
    	} else {
    		btnCambiarFacturacion.setDisabled(true);
    	}
    });
    
    var mainPanel = new Ext.Panel({
		items : [
			{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'padding:5px;cellspacing:10px'
    			,items:[carterasGrid]
			}
			,{
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

    
    
	page.add(mainPanel);			
	
</fwk:page>	