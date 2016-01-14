<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	var limit=500;
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	
	var tabs = <app:includeArray files="${tabs}" />;
	
	//Buscamos la solapa que queremos abrir
    var nombreTab = '<s:message code="plugin.cambiosMasivosAsuntos.cambiogestores.selectivo.title" text="**Cambio selectivo de gestores" />';
    var nrotab = 0;
        
    //tab activo por nombre
    if (nombreTab != null){
        for(var i=0;i< tabs.length;i++){
            if (tabs[i].initialConfig && nombreTab==tabs[i].initialConfig.nombreTab){
                nrotab = i;
                break;
            }
        }
    }
    
    
    var maskPanel;
    var maskAll=function(){
        if(maskPanel==null){
            maskPanel=new Ext.LoadMask(mainPanel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
        }
        maskPanel.show();
        mainPanel.getTopToolbar().disable();
        
    };
    var unmaskAll=function(){
        if(maskPanel!=null)
            maskPanel.hide();
        mainPanel.getTopToolbar().enable();
        
    };
    
    var btnReset = new Ext.Button({
        text:'<s:message code="app.botones.limpiar" text="**limpiar" />'
        ,iconCls:'icon_limpiar'
        ,handler: function() {
            for (var tab=0; tab < asuntoTabPanel.items.length; tab++) {
                asuntoTabPanel.items.get(tab).fireEvent('limpiar');
            }
            asuntosStore.removeAll();
            botonesTabla.hide();
            columMemoryPlugin.idArray = [];
        }
    });
    
    var validarEmptyForm = function() {
        return true;
    };
    var j=0;
    var parametrosTab = new Array();
    var parametrosTabFinal = new Array();
    
    var btnExportarXLS=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.xls" text="**Exportar a Excel" />'
        ,iconCls:'icon_exportar_csv'
        ,handler: function() {
            var parametros = new Array();
            var hayParametros = false;
            var anadirParametros = function(newParametros) {
                for (var i in newParametros) {
                    hayParametros = true;
					
                    parametros[i] = newParametros[i];
                    if(i == 'params'){
                    	
                    	parametrosTab[j] = newParametros[i];
                    	j++;
                    }
                }
                
                
            };
            
            var error=false;
            
            var hayError = function() {
                error = true;
            };
            
            for (var tab=0;tab < asuntoTabPanel.items.length && error==false;tab++) {
            	 asuntoTabPanel.items.get(tab).fireEvent('getParametros', anadirParametros, hayError);
            }
            
            if (hayParametros) {
			
				var y = 0;
				var paramAux;
				for(var i in parametrosTab){
						paramAux = paramAux+'_param_'+parametrosTab[i];	
				}
				parametros['params'] = paramAux;
				
				//var flow='asuntos/exportAsuntos';
                var flow='plugin/coreextension/asunto/core.exportAsuntos';
             
                var params=parametros;
               
                parametros.tipoSalida='<fwk:const value="es.capgemini.pfs.asunto.dto.DtoBusquedaAsunto.SALIDA_XLS" />';
                
                
                
                app.openBrowserWindow(flow,parametros);
                    
                
				parametrosTab = new Array();            
                
            } else {
                Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
            }
        }
    });
    
    var btnBuscar=app.crearBotonBuscar({
        handler : function() {
            var parametros = new Array();
            var hayParametros = false;
            var anadirParametros = function(newParametros) {
                for (var i in newParametros) {
                    hayParametros = true;
                    parametros[i] = newParametros[i];
                    if(i == 'params'){
                    	parametrosTab[j] = newParametros[i];
                    	j++;
                    }
                }
            };
            var error=false;
            var hayError = function() {
                error = true;
            };
			try {
        		for (var tab=0;tab < asuntoTabPanel.items.length && error==false;tab++) {
        	 		asuntoTabPanel.items.get(tab).fireEvent('getParametros', anadirParametros, hayError);
        		}
    		}catch(e){
        		fwk.log(e);
    		}
            if (hayParametros) {
				var y = 0;
				var paramAux;
				for(var i in parametrosTab){
						paramAux = paramAux+'_param_'+parametrosTab[i];	
				}
				parametros['params'] = paramAux;
                panelFiltros.collapse(true);
                botonesTabla.show();
                asuntosStore.removeAll();
				asuntosStore.webflow(parametros); 
				parametrosTab = new Array();            
                
            } else {
                Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
            }
        }
    });
    
    var asuntoTabPanel=new Ext.TabPanel({
        items:tabs
        ,layoutOnTabChange:true 
        ,activeItem:nrotab
        ,autoScroll:true
        ,autoHeight:true
        ,autoWidth : true
        ,border : false
            
    });
    
    var panelFiltros =  new Ext.Panel({
          title: '<s:message code="asuntos.busqueda.filtros" text="**Filtro de Asuntos" />'
          ,defaults : {xtype:'panel' ,cellCls : 'vtop'}
          ,tbar : [btnBuscar,btnReset,btnExportarXLS,buttonsL, '->',buttonsR]
          ,bodyStyle:'cellspacing:10px;'
          ,items:asuntoTabPanel
          ,titleCollapse:true
          ,collapsible:true
          ,border:true
          ,loadMask:true
          ,listeners: {
              beforeExpand:function(){
                  gridAsuntos.setHeight(175);
              }
              ,beforeCollapse:function(){
                  gridAsuntos.setHeight(435);
              }
          }
      });
    
	var Asunto = Ext.data.Record.create([
		{name:'id'}
		,{name:'nombre'}
		,{name:'fechaCrear'}		
		,{name:'gestorNombreApellidosSQL'}		
		,{name:'despachoSQL'}		
		,{name:'supervisorNombreApellidosSQL'}
		,{name:'estadoAsunto'}		
		,{name:'saldoTotalPorContratosSQL'}
		,{name:'importeEstimado'}	
		,{name:'revisado'}	
	]);
	
	var asuntosStore = page.getStore({
		eventName : 'listado'
		,limit:limit
		,flow:'core.listadoAsuntosDinamicoData'
		,reader: new Ext.data.JsonReader({
			root: 'asuntos'
			,totalProperty : 'total'
		}, Asunto)
		,remoteSort : true
	});
	
	var rendererApellidosNombre = function(value, p, r)
    {    	
    	var apellidosNombreStr = "";
    	
    	if(value != null && value != undefined && value != "")
    	{
    	    var separa = value.split("-");
    	    var apellido1Str = separa[0]; 
    	    var apellido2Str = separa[1]; 
    	    var nombreStr    = separa[2]; 
    	    
    	    if(apellido1Str != null && apellido1Str.length > 0)
    	    {
    	       apellidosNombreStr = apellidosNombreStr + apellido1Str;
    	    }
    	    if( apellido2Str != null && apellido2Str.length > 0)
    	    {
    	       apellidosNombreStr = apellidosNombreStr + " " + apellido2Str;
    	    }
    	    
    	    if(apellidosNombreStr!= null && apellidosNombreStr.length > 0)
    	    {
    	       apellidosNombreStr = apellidosNombreStr + ", ";
    	    }
    	    
    	    if(nombreStr!= null && nombreStr.length > 0)
    	    {
    	       apellidosNombreStr = apellidosNombreStr + nombreStr;
    	    }
    	    
    	}    	    	
    	
    	return apellidosNombreStr;    		
    } 

<%--
	var checlCambioGestor_edit = new Ext.grid.CheckColumn({ 
		header: '<s:message code="asuntos.listado.check.cambioGestor" text="**Cambiar gestor" />'
		,dataIndex: 'revisada'
		,width: 50
		,sortable: true   
	});
--%>
	
   var rendererChechkbox = function(value, metaData, record, rowIndex, colIndex, store){ 
        if(parseInt(value) == 1){ 
            metaData.css='icon_checkbox_on';
        }
        else{
            metaData.css='icon_checkbox_off';
        }
    };   
 
 
 	var myCboxSelModel = new Ext.grid.CheckboxSelectionModel({
 		handleMouseDown : function(g, rowIndex, e){
  		 	var view = this.grid.getView();
    		var isSelected = this.isSelected(rowIndex);
    		if(isSelected) {
      			this.deselectRow(rowIndex);
    		} 
    		else if(!isSelected || this.getCount() > 1) {
      			this.selectRow(rowIndex, true);
      			view.focusRow(rowIndex);
    		}
  		},
  		singleSelect: false
	});
	
	var columnArray = [
	myCboxSelModel
	,{
		header: '<s:message code="asuntos.listado.codigo" text="**Codigo"/>',
		dataIndex: 'id', sortable: true
	}, {
		header: '<s:message code="asuntos.listado.nombreasunto" text="**Nombre"/>',
		dataIndex: 'nombre', sortable: true
	}, {
		header: '<s:message code="asuntos.listado.fcreacion" text="**Fecha Creacion"/>',
		dataIndex: 'fechaCrear', sortable: true
	}, {
		header: '<s:message code="asuntos.listado.estado" text="**Estado"/>',
		dataIndex: 'estadoAsunto', sortable: true	
    }, {
		header: '<s:message code="asuntos.listado.gestor" text="**Gestor"/>',
		dataIndex: 'gestorNombreApellidosSQL', sortable: true, renderer: rendererApellidosNombre			
    }, {
		header: '<s:message code="asuntos.listado.despacho" text="**Despacho"/>', 
		dataIndex: 'despachoSQL', sortable: true			
	}, {
		header: '<s:message code="asuntos.listado.supervisor" text="**Supervisor"/>',
		dataIndex: 'supervisorNombreApellidosSQL', sortable: true, renderer: rendererApellidosNombre	
	}, {
		header: '<s:message code="asuntos.listado.saldototal" text="**Saldo Total"/>'
		,dataIndex: 'saldoTotalPorContratosSQL'	
		,renderer: app.format.moneyRenderer	
		,align:'right'
		, sortable: true
	}
	, {
		header: 'Importe estimado'
		,dataIndex: 'importeEstimado'	
		,renderer: app.format.moneyRenderer	
		,align:'right'
		, sortable: true
	} 
	<%--,{header: '<s:message code="asuntos.listado.check.cambioGestor" text="**Cambiar gestor" />', width: 50,  dataIndex: 'revisado',sortable:true,renderer:rendererChechkbox} --%>
	];
 
	var asuntosCm = new Ext.grid.ColumnModel(columnArray);
	
	var botonesTabla = fwk.ux.getPaging(asuntosStore);
	botonesTabla.hide();
	
	
	Ext.namespace('Ext.ux.plugins');

	Ext.ux.plugins.CheckBoxMemory = Ext.extend(Object,{
   		constructor: function(config){
	      	if (!config)
				config = {};

      		this.prefix = 'id_';
      		this.items = {};
      		this.idArray = new Array();
      		this.idProperty = config.idProperty || 'id';
   		},

   		init: function(grid){
			this.store = grid.getStore();
      		this.sm = grid.getSelectionModel();
      		this.sm.on('rowselect', this.onSelect, this);
      		this.sm.on('rowdeselect', this.onDeselect, this);
      		this.store.on('load', this.restoreState, this);
   		},

   		onSelect: function(sm, idx, rec){
      		this.items[this.getId(rec)] = true;
      		if (this.idArray.indexOf(rec.get(this.idProperty)) < 0){
      			this.idArray.push(rec.get(this.idProperty));
      		}
   		},

   		onDeselect: function(sm, idx, rec){
      		delete this.items[this.getId(rec)];
      		var i = this.idArray.indexOf(rec.get(this.idProperty));
      		if (i >= 0){
      			delete this.idArray.splice(i,1);
      		}
   		},

   		restoreState: function(){
      		var i = 0;
      		var sel = [];
      		this.store.each(function(rec){
         		var id = this.getId(rec);
         		if (this.items[id] === true)
            		sel.push(i);
		
         		++i;
      		}, this);
      		if (sel.length > 0)
         		this.sm.selectRows(sel);
   		},

	   getId: function(rec){
      		return this.prefix + rec.get(this.idProperty);
   		},
   	   getIds: function(){
   	   		return this.idArray;
   	   }	
	});
	
	var columMemoryPlugin = new Ext.ux.plugins.CheckBoxMemory();
	
	var btnModificaGestores = new Ext.Button({
		text : '<s:message code="plugin.cambiosMasivosAsunto.asunto.btnCambioGestoresListadoAsuntos" text="**Cambiar gestores" />'
		,iconCls : 'icon_edit'
		,cls: 'x-btn-text-icon'
		,handler : function() {
			var parametros = {
				listaAsuntos : getSelectedItems(),
				idDespacho: asuntoTabPanel.items.get(0).items.get(1).items.get(0).getValue() // comboDespacho
			};
			var w= app.openWindow({
				flow: 'cambiosgestores/abreVentanaBuscadorAsuntos'
				,closable: true
				,width : 470
				,title : '<s:message code="plugin.cambiosMasivosAsunto.asunto.tituloCambioGestorPorAsunto" text="**Cambio de gestores" />'
				,params: parametros
			});
			w.on(app.event.DONE, function(){
				w.close();
				page.fireEvent(app.event.DONE);
			});
			w.on(app.event.CANCEL, function(){w.close();});
		}
   	});
   	
   	botonesTabla.add(btnModificaGestores);
   	
	var gridAsuntos = new Ext.grid.GridPanel({
		title:'<s:message code="asuntos.grid.titulo" text="**asuntos" />'
		,columns: columnArray
		,store: asuntosStore
		,height: 170
		,loadMask: true
        ,sm: myCboxSelModel
        ,viewConfig: {forceFit: true}
        ,clicksToEdit: 1
        ,viewConfig: {forceFit:true}
        ,plugins: [columMemoryPlugin]
       	,bbar : [ botonesTabla ]
	});

	gridAsuntos.on('rowdblclick', function(grid, rowIndex, e) {
    		var rec = grid.getStore().getAt(rowIndex);
    		var nombre_asunto=rec.get('nombre');
    		var id=rec.get('id');
    		app.abreAsunto(id, nombre_asunto);
    	});
	
	var mainPanel = new Ext.Panel({
		items : [
			panelFiltros
			,{
				defaults : {xtype:'panel' ,cellCls : 'vtop'}
				,border:false
				,bodyStyle:'cellspacing:10px;padding-top:15px;'
    			,items:[gridAsuntos]
			}
    	]
	    ,bodyStyle:'margin:10px'
	    ,autoHeight : true
	    ,autoWidth : true
	    ,border: false
    });
    
    var getSelectedItems = function(){
    	return columMemoryPlugin.getIds();
    }
    
	page.add(mainPanel);

</fwk:page>

