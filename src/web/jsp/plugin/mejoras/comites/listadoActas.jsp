<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>   

	var limit = 25;
	var isBusqueda='true';

	// FILTROS -------------

	// fecha inicio
	var comboFechaIniDesdeOp=new Ext.form.ComboBox({
		store:[">=",">","=","<>"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.mejoras.buscarActas.filtroFechaOperadorDesde" text="**Desde" />'
		,width:40
		,value:'${comboFechaIniDesdeOp}'
	})
		
	var fechaIniDesde = new Ext.ux.form.XDateField({
		width:100
		,height:20
		,name:'fechaIniDesde'
		,fieldLabel:'<s:message code="plugin.mejoras.buscarActas.filtroFechaInicio" text="**F. Inicio" />'
		,value:'${fechaIniDesde}'
	});
	
	var comboFechaIniHastaOp=new Ext.form.ComboBox({
		store:["<=","<"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.mejoras.buscarActas.filtroFechaOperadorHasta" text="**Inicio hasta" />'
		,width:40
		,value:'${comboFechaIniHastaOp}'
	})
	
	var fechaIniHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaIniHasta'
		,height:20
		,fieldLabel:'<s:message code="plugin.mejoras.buscarActas.filtroFechaInicio" text="**F. Inicio" />'
		,value:'${fechaIniHasta}'
	});

	// fecha fin
	
	var comboFechaFinDesdeOp=new Ext.form.ComboBox({
		store:[">=",">","=","<>"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.mejoras.buscarActas.filtroFechaOperadorDesde" text="**Desde" />'
		,width:40
		,value:'${comboFechaFinDesdeOp}'
	})
		
	var fechaFinDesde = new Ext.ux.form.XDateField({
		width:100
		,height:20
		,name:'fechaFinDesde'
		,fieldLabel:'<s:message code="plugin.mejoras.buscarActas.filtroFechaFin" text="**F. Fin" />'
		,value:'${fechaFinDesde}'
	});
	
	var comboFechaFinHastaOp=new Ext.form.ComboBox({
		store:["<=","<"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.mejoras.buscarActas.filtroFechaOperadorHasta" text="**Fin hasta" />'
		,width:40
		,value:'${comboFechaFinHastaOp}'
	})
	
	var fechaFinHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaIniHasta'
		,height:20
		,fieldLabel:'<s:message code="plugin.mejoras.buscarActas.filtroFechaFin" text="**F. Fin" />'
		,value:'${fechaFinHasta}'
	});

	var comiteStore = page.getStore({
		 flow:'plugin/mejoras/comites/plugin.mejoras.comites.listadoComitesDataCombo'
		,reader: new Ext.data.JsonReader({
			idProperty: 'id',
    		root: 'listadoComites',
    		totalProperty: 'results',
			fields : [
				 {name:'id'}
				,{name:'nombre'}
			]})
	});
	
	var comboComite=new Ext.form.ComboBox({
		store: comiteStore
		,displayField: 'nombre'
		,valueField: 'id'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.mejoras.buscarActas.filtroComite" text="**Comité" />'
		,width:175
		,value:'${idComite}'
	});
	comboComite.store.webflow();
	
	var getParametrosBusqueda=function(){
		return {
				limit:limit
				,busqueda:true
				,start:0
				// Filtros
				,idComite:comboComite.getValue()
				,fechaInicioDesde:app.format.dateRenderer(fechaIniDesde.getValue())
				,fechaInicioDesdeOperador:comboFechaIniDesdeOp.getValue()
				,fechaInicioHasta:app.format.dateRenderer(fechaIniHasta.getValue())
				,fechaInicioHastaOperador:comboFechaIniHastaOp.getValue()
				,fechaFinDesde:app.format.dateRenderer(fechaFinDesde.getValue())
				,fechaFinDesdeOperador:comboFechaFinDesdeOp.getValue()
				,fechaFinHasta:app.format.dateRenderer(fechaFinHasta.getValue())
				,fechaFinHastaOperador:comboFechaFinHastaOp.getValue()
			}
	}

	// VALIDACIONES FILTROS -------------------------------------------
	
	var validaFechas=function(){
		var valid=true;
		if(fechaIniDesde.getValue()!='' && fechaIniHasta.getValue()!=''){
			valid = (fechaIniDesde.getValue()< fechaIniHasta.getValue())
		}
		if(fechaIniDesde.getValue()!='' && comboFechaIniDesdeOp.getValue()==''){
			valid = valid && false;
		}
		if(fechaIniHasta.getValue()!='' && comboFechaIniHastaOp.getValue()==''){
			valid = valid && false;
		}
		if(comboFechaIniDesdeOp.getValue()=='>=' || comboFechaIniDesdeOp.getValue()=='>'){
			if (fechaIniHasta.getValue()!='' && comboFechaIniHastaOp.getValue()!='') 
				if(fechaIniDesde.getValue()=='')
					valid = valid && false;
				else
					valid = valid && true;
		}

		if(fechaFinDesde.getValue()!='' && fechaFinHasta.getValue()!=''){
			valid = (fechaFinDesde.getValue()< fechaFinHasta.getValue())
		}
		if(fechaFinDesde.getValue()!='' && comboFechaFinDesdeOp.getValue()==''){
			valid = valid && false;
		}
		if(fechaFinHasta.getValue()!='' && comboFechaFinHastaOp.getValue()==''){
			valid = valid && false;
		}
		if(comboFechaFinDesdeOp.getValue()=='>=' || comboFechaFinDesdeOp.getValue()=='>'){
			if (fechaFinHasta.getValue()!='' && comboFechaFinHastaOp.getValue()!='') 
				if(fechaFinDesde.getValue()=='')
					valid = valid && false;
				else
					valid = valid && true;
		}

		return valid;
	}
	
	// -----------------------------------------------------
			
   var buscarFunc=function(){
		if(validaFechas()){
				comitesStore.webflow(getParametrosBusqueda());
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="plugin.mejoras.buscarActas.errorEnFiltrosFecha" text="** La fecha desde debe ser menor a la fecha Hasta"/>')
		}
	}
	
	
	var btnExportarXls=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**exportar a xls" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() { }
    });

	//var campoOculto = new Ext.form.TextField({
 	//	border: false
 		//,hidden: true
	//});
	
	
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	
   	var panelFiltros=new Ext.form.FormPanel({
		title:'<s:message code="tareas.listado.busqueda" text="**Busqueda de Tareas"/>'
		,collapsible:true
		,collapsed:true
		,autoWidth:true
		,style:'padding-right:10px;padding-bottom: 10px'
		,bodyStyle:'padding:5px;cellspacing:20px;'
		,autoHeight:true
		,defaults : {xtype:'panel', border : false ,autoHeight:true}
		,items:[{
				autoHeight:true
				,bodyStyle:'padding: 10px'
				,layout:'table'
				,layoutConfig:{columns:5}
				,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form'}
				,items:[ {
							items: [comboFechaIniDesdeOp, comboFechaFinDesdeOp]
						 },{
						 	items: [fechaIniDesde, fechaFinDesde]
						 },{
						 	items: [comboFechaIniHastaOp, comboFechaFinHastaOp]
						 },{
						 	items: [fechaIniHasta, fechaFinHasta]
						 },{
						 	items: [comboComite]
						 }] 
					}
				]
		<%--,tbar:[btnBuscar,btnClean,'->',btnAyuda] --%>
		,tbar : [buttonsL,'->', buttonsR]
	})
	// btnExportarXls
   	var Comite = Ext.data.Record.create([
         {name:'sesionId'}
         ,{name : 'nombre'}
         ,{name : 'estado'}
         ,{name : 'atrmin', type: 'float', sortType:Ext.data.SortTypes.asFloat}
         ,{name : 'atrmax', type: 'float', sortType:Ext.data.SortTypes.asFloat}
         ,{name : 'prioridad'}
         ,{name : 'zona'}
         ,{name : 'fechaini'} 
         ,{name : 'fechafin'}    
         ,{name : 'expedientes'}
    ]);

	var paramsBusquedaInicial={
		start:0
		,limit:25
		,isBusqueda:'true'
	};	
   
   	var comitesStore = page.getStore({
      flow: 'plugin/mejoras/comites/plugin.mejoras.comites.listadoActasData'
      ,limit: limit
      ,reader: new Ext.data.JsonReader({
        	 root : 'comitesJSON'
       		,totalProperty : 'total'
      } , Comite)
     ,remoteSort : false
     });
     

	var gridComitesCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="actas.listado.nombre" text="**Nombre"/>', dataIndex : 'nombre', sortable:true  }
		,{header : '<s:message code="actas.listado.estado" text="**Estado"/>', dataIndex : 'estado', sortable:true }
		,{header : '<s:message code="actas.listado.atrmin" text="**Atribucion Minima"/>', dataIndex : 'atrmin', renderer: app.format.moneyRenderer, sortable:true}
		,{header : '<s:message code="actas.listado.fechaini" text="**Fecha inicio"/>', dataIndex : 'fechaini', sortable:true }
		,{header : '<s:message code="actas.listado.fechafin" text="**Fecha fin"/>', dataIndex : 'fechafin' , sortable:true}
		,{header : '<s:message code="actas.listado.atrmax" text="**Atribucion Maxima"/>', dataIndex : 'atrmax', renderer: app.format.moneyRenderer, sortable:true }
		,{header : '<s:message code="actas.listado.prioridad" text="**Prioridad"/>', dataIndex : 'prioridad',hidden:true , sortable:true}
		,{header : '<s:message code="actas.listado.zona" text="**Zona"/>', dataIndex : 'zona', sortable:true}
		,{header : '<s:message code="actas.listado.puntosTratados" text="**Puntos Tratados"/>', dataIndex : 'expedientes', sortable:true }
	]);

	var pagingBar=fwk.ux.getPaging(comitesStore);

	var gridComitesGrid = app.crearGrid(comitesStore,gridComitesCm,{
		title:'<s:message code="actas.listado.grid" text="**default" />'
		,style:'padding-right:10px'
		,cls:'cursor_pointer'
		,height:400
		,bbar : [pagingBar]
        <app:test id="actasGrid" addComa="true" />
	});
	

	gridComitesGrid.on('rowdblclick', function(grid, rowIndex, e){
	   var rec = grid.getStore().getAt(rowIndex);
      app.openTab( "<s:message code="actas.consulta.sesion" text="**Consulta sesion del comite" />" 
                   ,'comites/actaComite'
                   ,{idSesion : rec.get('sesionId')}
				   ,{id:'acta'+rec.get('sesionId') , iconCls:'icon_comite'});
	});

	var panel = new Ext.Panel({
		    items : [
		    		panelFiltros,
					gridComitesGrid
		    	]
		    ,bodyStyle:'padding:10px'
		    ,autoHeight : true
		    ,border: false
			,tbar:new Ext.Toolbar()
	    });
	    
  
    panel.on(app.event.DONE, function(){comitesStore.webflow();});
	//añadimos al padre y hacemos el layout
	page.add(panel);
	panel.getTopToolbar().add(panelFiltros.getTopToolbar().getItems());
	
	Ext.onReady(function(){
	   comitesStore.webflow();
    });
    
</fwk:page>