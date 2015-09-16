<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	var cerrarDecision = function(yesNo) {
		if(yesNo=='yes') {
		    var mask=new Ext.LoadMask(panel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
			mask.show();
			page.webflow({
	     		flow: 'politica/cerrarDecisionPolitica'
				,params: {idExpediente:getIdExpediente()}
	     		,success: function(){
	     		    mask.hide();
	           		Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="cerrarDecisionPolitica.cerrado" text="**Se ha cerrado la decisión correctamente." />');
					entidad.refrescar();
	           	}
	           	,error: function(){
	           		mask.hide();
	           	}
		    });
		}
	};

	var cerrarHandler = function() {
		if(tieneComiteSeguimiento() || tieneComiteMixto()) {
			Ext.Msg.confirm(fwk.constant.confirmar,
			                '<s:message code="cerrarDecisionPolitica.quiereCerrar" text="**Esta seguro de que desea cerrar la decisin de poltica?" />',
			                cerrarDecision);
		} else {
			cerrarDecision('no');
		}
	};

	var btnCerrar = new Ext.Button({
       	text: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.btnCerrar" text="**Cerrar decisin de poltica" />'
      	,iconCls : 'icon_comite_cerrar'  
      	,border:false
		,handler:cerrarHandler
		,disabled:false
	});
	
	
	   
    var Personas = Ext.data.Record.create([    
		{name : "idPersona"}
		,{name : "cliente"}
		,{name : "tipoPolitica"}
		,{name : "numObjetivos"}
		,{name : "estado"}
    ]);
    
	var marcadoObligatorioStore = page.getStore({                                                                                                                                 
		eventName:'listado'
		,flow : 'expedientes/listadoPersonasMarcadoObligatorio'    
		,storeId : 'PoliticaMarcadoObligatorioStore'		
		,reader : new Ext.data.JsonReader(
			{root:'personas'}
			, Personas
		)                                                                                                  
	});     

	var marcadoOpcionalStore = page.getStore({                                                                                                                                 
		eventName:'listado'
		,flow : 'expedientes/listadoPersonasMarcadoOpcional' 
		,storeId : 'PoliticaMarcadoOpcionalStore'			
		,reader : new Ext.data.JsonReader(
			{root:'personas'}
			, Personas
		)                                                                                                  
	}); 
	
	var limit = 20;
	var labelStyle = 'width:150px;font-weight:bolder';
	
	var marcadoObigatorioCm = new Ext.grid.ColumnModel([
		 //Cliente
		 {header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.nombre" text="**Nombre" />',dataIndex:'cliente'}
		 //Tipo de Poltica
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.tipoPolitica" text="**Tipo de Poltica" />',dataIndex:'tipoPolitica'}
		 //N de Objetivos
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.nroObjetivos" text="**N de Objetivos" />',dataIndex:'numObjetivos'}
		 //Estado
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.estado" text="**Estado" />',dataIndex:'estado'}
        ]
    );
	
	var marcadoOpcionalCm = new Ext.grid.ColumnModel([
		 //Cliente
		 {header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.nombre" text="**Nombre" />',dataIndex:'cliente'}
		 //Tipo de Poltica
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.tipoPolitica" text="**Tipo de Poltica" />',dataIndex:'tipoPolitica'}
		 //N de Objetivos
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.nroObjetivos" text="**N de Objetivos" />',dataIndex:'numObjetivos'}
		 //Estado
		 ,{header: '<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.estado" text="**Estado" />',dataIndex:'estado'}
        ]
    );

	 var obligatorioGrid = app.crearGrid(marcadoObligatorioStore,marcadoObigatorioCm,{
            title:'<s:message code="expediente.consulta.marcadoPolitica.gridObligatorio.titulo" text="**Listado de Clientes con Marcado Obligatorio"/>'
            ,style : 'margin-bottom:10px;padding-right:10px'
            ,cls:'cursor_pointer'
            ,iconCls : 'icon_cliente'
	        ,height : 150
        });

	obligatorioGrid.on('rowdblclick',function(grid, rowIndex, e){
		var rec=marcadoObligatorioStore.getAt(rowIndex);
		if(!rec) return;
		var nombre_cliente=rec.get('cliente');
    	app.abreCliente(rec.get('idPersona'), nombre_cliente);
	})

	 var opcionalGrid=app.crearGrid(marcadoOpcionalStore,marcadoOpcionalCm,{
            title:'<s:message code="expediente.consulta.marcadoPolitica.gridOpcional.titulo" text="**Listado de Clientes con Marcado Opcional"/>'
            ,style : 'margin-bottom:10px;padding-right:10px'
            ,cls:'cursor_pointer'
            ,iconCls : 'icon_cliente'
	        ,height : 150
        });


	opcionalGrid.on('rowdblclick',function(grid, rowIndex, e){
		var rec=marcadoOpcionalStore.getAt(rowIndex);
		if(!rec) return;
		var nombre_cliente=rec.get('cliente');
    	app.abreCliente(rec.get('idPersona'), nombre_cliente);
	})


	var panel = new Ext.Panel({
        title:'<s:message code="expedientes.consulta.tabMarcadoPoliticas.titulo" text="**Marcado de Polticas"/>'
        ,bodyStyle:'padding:10px'
		,layout:'table'
	    ,layoutConfig: {
	        columns: 1
	    }		
		,items : [
			{items:[obligatorioGrid],border:false,style:'padding:5px;padding-top:1px;padding-bottom:1px;margin-left:5px'}
			,{items:[opcionalGrid],border:false,style:'padding:5px;padding-top:1px;padding-bottom:1px;margin-left:5px'}
			,{	buttons:[btnCerrar]
				,buttonAlign:'right'
				,style:'padding-right:5px;'
				,border:false
			}
		]
        ,autoHeight:true
        ,nombreTab : 'tabMarcadoPolitica'
    });
	
	function getIdExpediente () {return entidad.get("data").id;}	
	function estaCongelado () {return entidad.get("data").decision.estaCongelado;}
	function tieneComiteMixto () {return entidad.get("data").toolbar.tieneComiteMixto;}
	function tieneComiteSeguimiento () {return entidad.get("data").toolbar.tieneComiteSeguimiento;}
	
	// ${expediente.comite.comiteMixto || expediente.comite.comiteSeguimiento}
	
	panel.getValue = function(){}
	
	panel.setValue = function(){
		
		entidad.cacheOrLoad(data, marcadoObligatorioStore, {idExpediente:getIdExpediente()});
		entidad.cacheOrLoad(data, marcadoOpcionalStore, {idExpediente:getIdExpediente()});
		
		var esVisible = [
			[btnCerrar, estaCongelado]
		];
		entidad.setVisible(esVisible);
		
		var codigoEstadoDecidido = '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO" />';
		// Si está decidido el expediente deshabilitamos el botón 
		if ( entidad.get("data").toolbar.estadoExpediente == codigoEstadoDecidido ){
			btnCerrar.setDisabled(true);
		}
		else{
			btnCerrar.setDisabled(false);
		}
		
		
	}
	
	panel.setVisibleTab = function(data){
		return data.toolbar.puedeMostrarSolapaMarcadoPoliticas;
	}
	
	entidad.cacheStore(marcadoObligatorioStore);
	entidad.cacheStore(marcadoOpcionalStore);
	
	return panel;
	
})
