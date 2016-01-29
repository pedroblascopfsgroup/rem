<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

(function(page,entidad){


	<%-- valor seteado para pruebas --%>
	var idExpediente;
	
	var idIncidencia;
    var limit = 25;
	var isBusqueda= true;
	
	var paramsBusquedaInicial={
		 start:0
		,limit:limit
		,idExpediente:idExpediente
	};
	
	var accionesRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'idAccion'}
		,{name:'fechaGestion'}
        ,{name:'agencia'}
        ,{name:'tipoGestion'}
        ,{name:'resultadoGestionTelefonica'}
        ,{name:'resultadoMensajeria'}
    ]);
    
    var accionesStore = page.getStore({
		id:'accionesStore'
		,remoteSort:true
		,event:'listado'
		,storeId : 'accionesStore'
		,limit: limit
		,baseParams:paramsBusquedaInicial
		,flow : 'accionesextrajudiciales/getAccionesExpediente'
		,reader : new Ext.data.JsonReader({root:'accionesExjud',totalProperty : 'total'}, accionesRecord)
		,sortInfo:{field: 'fechaGestion', direction: "ASC"}
		,sortOnLoad: true
		,sortRoot: 'fechaGestion'
	});
	accionesStore.setDefaultSort('fechaGestion', 'ASC');
	
	var accionesCm = new Ext.grid.ColumnModel([
			{header: '<s:message code="plugin.recobroWeb.acciones.tab.id" text="**Código Acción" />',dataIndex: 'idAccion',sortable:true}
			,{header: '<s:message code="plugin.recobroWeb.acciones.tab.fechaGestion" text="**Fecha gestión" />',dataIndex: 'fechaGestion',sortable:true}
	        ,{header: '<s:message code="plugin.recobroWeb.acciones.tab.agencia" text="**Agencia" />',dataIndex: 'agencia',sortable:true}
			,{header: '<s:message code="plugin.recobroWeb.acciones.tab.tipoGestion" text="**Tipo gestión" />',dataIndex: 'tipoGestion',sortable:true}
            ,{header: '<s:message code="plugin.recobroWeb.acciones.tab.resultadoGestionTelefonica" text="**Resultado" />',dataIndex: 'resultadoGestionTelefonica',sortable:true}
    		,{header: '<s:message code="plugin.recobroWeb.acciones.tab.resultadoMensajeria" text="**Resultado mensajería" />',dataIndex: 'resultadoMensajeria',sortable:false}
     ]);


	var recargar = function(){
		accionesStore.webflow({
			 start:0
			,limit:limit
			,idExpediente:idExpediente
		});
		optionsCiclosStore.webflow({
			idExpediente:idExpediente
		});
	}
	
	var pagingBar=fwk.ux.getPaging(accionesStore);
	
	var accionesGrid=app.crearEditorGrid(accionesStore,accionesCm,{
        title:'<s:message code="plugin.recobroWeb.acciones.tab.tituloGrid" text="**Acciones del expediente" />'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:350
        ,bbar : [pagingBar]
    });
  
	
	accionesGrid.on('rowdblclick',function(sm, rowIndex, r){
		var recStore=accionesStore.getAt(rowIndex);
    	
    	if (recStore.get('id')!=null && recStore.get('id')!="") { 
    		id = recStore.get('id');
    	}
    	var w = app.openWindow({
 	  		flow: 'accionesextrajudiciales/abrirNuevaVentanaAccionesExpediente'
  	  		,width: 835
	  		,y:1 
	  		,closable:true
	  		,title: '<s:message code="plugin.recobroWeb.acciones.detalle.titulo" text="**Detalle acción" />'
			,params : {
				id:id
			}
		});
		w.on(app.event.DONE, function(){
            w.close();
        });
        w.on(app.event.CANCEL, function(){ w.close(); });
		
	});
	
   //FILTROS
   
   var ciclos = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsCiclosStore = page.getStore({
	       flow: 'accionesextrajudiciales/getListadoCiclosRecobroExpediente'
	       ,id: 'optionsCiclosStore'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listado'
	    }, ciclos)
	});	
	
	
	var comboCiclos = new Ext.form.ComboBox({
				store:optionsCiclosStore
				,id: 'comboCiclos'
				,displayField:'descripcion'
				,valueField:'id'
				,forceSelection:true 				
				,mode: 'remote'
				,width: 300
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,fieldLabel:'<s:message code="plugin.recobroWeb.acciones.tab.busqueda.filtros.cicloRecobro" text="**Ciclo recobro" />'
				,name: 'comboCiclos'
				<app:test id="comboCiclosAA" addComa="true"/>
	});
	
	
	var agencia = Ext.data.Record.create([
		 {name:'id'}
		,{name:'nombre'}
	]);
	
	var optionsAgenciaStore = page.getStore({
	       flow: 'accionesextrajudiciales/getListadoAgencias'
	       ,id: 'optionsAgenciaStore'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listado'
	    }, agencia)	       
	});	
	
	
	
	
	var comboAgencias = new Ext.form.ComboBox({
				store:optionsAgenciaStore
				,id: 'comboAgencias'
				,displayField:'nombre'
				,valueField:'id'
				,forceSelection:true 				
				,mode: 'remote'
				,autoWidth:true
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,fieldLabel:'<s:message code="plugin.recobroWeb.acciones.tab.busqueda.filtros.agencia" text="**Agencia" />'
				,name: 'comboAgencias'
				<app:test id="comboAgenciasAA" addComa="true"/>
	});
	
	var tipoGestion = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsTipoGestionStore = page.getStore({
	       flow: 'accionesextrajudiciales/getListadoTipoGestion'
	       ,id: 'optionsTipoGestionStore'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listado'
	    }, tipoGestion)	       
	});	
	
	var comboTipoGestion = new Ext.form.ComboBox({
				store:optionsTipoGestionStore
				,id: 'comboTipoGestion'
				,displayField:'descripcion'
				,valueField:'id'
				,forceSelection:true 				
				,mode: 'remote'
				,autoWidth:true
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,fieldLabel:'<s:message code="plugin.recobroWeb.acciones.tab.busqueda.filtros.tipo" text="**Tipo" />'
				,name: 'combotipoIntervencion'
				<app:test id="comboTipoGestionAA" addComa="true"/>
	});
	
	var tipoResultado = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsTipoResultadoStore = page.getStore({
	       flow: 'accionesextrajudiciales/getListadoTipoResultado'
	       ,id: 'optionsTipoResultadoStore'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listado'
	    }, tipoResultado)	       
	});	
	
	var comboTipoResultado = new Ext.form.ComboBox({
				store:optionsTipoResultadoStore
				,id: 'comboTipoResultado'
				,displayField:'descripcion'
				,valueField:'id'
				,forceSelection:true 				
				,mode: 'remote'
				,autoWidth:true
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,fieldLabel:'<s:message code="plugin.recobroWeb.acciones.tab.busqueda.filtros.resultado" text="**Resultado" />'
				,name: 'comboTipoResultado'
				<app:test id="comboTipoResultadoAA" addComa="true"/>
	});
	

	
	var fechaDesde = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaVencHasta'
		,height:20
		,id:'fechaDesde'
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
		,fieldLabel:'<s:message code="plugin.recobroWeb.acciones.tab.busqueda.filtros.fechaDesde" text="**Desde" />'
	});
	
	var fechaHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaHasta'
		,id:'fechaHasta'
		,height:20
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
		,fieldLabel:'<s:message code="plugin.recobroWeb.acciones.tab.busqueda.filtros.fechaHasta" text="**Hasta" />'
	});

	var getParametrosBusqueda=function(){
		return {
			 start:0
			,limit:limit
			,idExpediente:idExpediente
			,idAgencia:comboAgencias.getValue()
			,idTipo:comboTipoGestion.getValue()
			,idCicloRecobroExp:comboCiclos.getValue()
			,idResultado:comboTipoResultado.getValue()
			,fechaDesde:app.format.dateRenderer(fechaDesde.getValue())
			,fechaHasta:app.format.dateRenderer(fechaHasta.getValue())
		}
	}
	
	var validarForm=function(){
		return true;
	}
	var buscarFunc=function(){
		if(validarForm()){
			isBusqueda=true;
			panelFiltros.collapse(true);
			accionesStore.webflow(getParametrosBusqueda());
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','Introduzca parámetros de búsqueda');
		}
	}
	
    
    var btnExportar = new Ext.Button({
		   text:'<s:message code="plugin.panelControl.letrados.exportar.xls" text="**Exportar a Excel" />'
	       ,iconCls:'icon_exportar_csv'
	       ,handler : function(){
	       		
  					var url = page.resolveUrl('exportarcsvrecobro/getAccionesExpedienteCSV');
			        var params=getParametrosBusqueda();
			        var params="";
			        params='idExpediente='+ idExpediente + '&idAgencia=' + comboAgencias.getValue() + '&idTipo=' + comboTipoGestion.getValue() + '&idCicloRecobroExp=' + comboCiclos.getValue() + '&idResultado=' + comboTipoResultado.getValue() + '&fechaDesde=' + fechaDesde.getValue() +'&fechaHasta=' +fechaHasta.getValue();
			        url += '?'+ params;
			        window.open(url);  				
	       }
	});
    
	
	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
	
	var btnClean=new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			app.resetCampos([comboAgencias, comboTipoGestion, comboTipoResultado, fechaDesde, fechaHasta, comboCiclos]);
			accionesStore.webflow(paramsBusquedaInicial);
			panelFiltros.collapse(true);
		}
	});	
	
	var panelFiltros = new Ext.Panel({
		title : '<s:message code="plugin.recobroWeb.acciones.tab.busquedaAcciones" text="**Búsqueda de acciones"/>'
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
		,layoutConfig : {columns:2}
		,bodyStyle:'cellspacing:10px;padding-right:10px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;'}
		,items:[{
				layout:'form'
				,defaults:{xtype:'fieldset',border:false}
				,width:'420px'
				,items:[comboCiclos, comboAgencias, fechaDesde]
			},{
				layout:'form' 
				,width:'320px'
				,defaults:{xtype:'fieldset',border:false}
				,items:[comboTipoGestion, comboTipoResultado, fechaHasta]
			}
		]              
		,tbar:[btnBuscar,btnClean,btnExportar]
	});
	
	var panel = new Ext.Panel({
        title : '<s:message code="plugin.recobroWeb.acciones.titulo" text="**Acciones del expediente" />',
		labelWidth: 50,
    	autoWidth:true,
    	autoHeight:true,
    	border:false,
        bodyStyle: 'padding:5px;border:0',
        layout: 'form',
        items: [{
   					bodyStyle:'padding: 5px;padding-right:15px;',
   					border:false,
   					items:[panelFiltros]
   				},{
   					bodyStyle:'padding: 5px',
   					border:false,
   					items:[accionesGrid]
   				}]
    });
    
	panel.getValue = function(){
	}
	
	var data;
	
	panel.setValue = function(){	
		data = entidad.get("data");
		idExpediente = data.id;
		panelFiltros.collapse(true);
		
	
		recargar();
	}

	panel.setVisibleTab = function(data){
		return true;
	}
	
  
	return panel;
})

