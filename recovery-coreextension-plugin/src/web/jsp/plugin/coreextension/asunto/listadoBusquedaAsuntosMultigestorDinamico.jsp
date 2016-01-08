<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

	var limit=25;
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
	
	var tabs = <app:includeArray files="${tabs}" />;
	
	//Buscamos la solapa que queremos abrir
    var nombreTab = '${nombreTab}';
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
            maskPanel=new Ext.LoadMask(panel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
        }
        maskPanel.show();
        panel.getTopToolbar().disable();
        
    };
    var unmaskAll=function(){
        if(maskPanel!=null)
            maskPanel.hide();
        panel.getTopToolbar().enable();
        
    };
    
    var btnReset = new Ext.Button({
        text:'<s:message code="app.botones.limpiar" text="**limpiar" />'
        ,iconCls:'icon_limpiar'
        ,handler: function() {
            for (var tab=0; tab < asuntoTabPanel.items.length; tab++) {
                asuntoTabPanel.items.get(tab).fireEvent('limpiar');
            }
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
                //var flow='plugin/coreextension/asunto/core.exportAsuntos';
                var flow = '/pfs/extasunto/exportarExcelAsuntos';
             
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
        	var pars = panelFiltros.getForm().getFieldValues(true);
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
			
                panelFiltros.collapse(true);
                botonesTabla.show();
				
				asuntosStore.webflow(parametros); 
				parametrosTab = new Array();          
				panelFiltros.getTopToolbar().setDisabled(true);  
				
                
            } else {
            	if(!error){
                	Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="expedientes.listado.criterios"/>');
                }
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
    
    var panelFiltros =  new Ext.FormPanel({
          title: '<s:message code="asuntos.busqueda.filtros" text="**Filtro de Asuntos" />'
          ,defaults : {xtype:'panel' ,cellCls : 'vtop'}
          ,tbar : [btnBuscar,btnReset,btnExportarXLS,buttonsL, '->',buttonsR]
          ,bodyStyle:'cellspacing:10px;'
          ,items:asuntoTabPanel
          ,titleCollapse:true
          ,collapsible:true
          ,border:true
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
		,{name:'tipoAsunto'}	
		,{name:'saldoTotalPorContratosSQL'}
		,{name:'importeEstimado'}		
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
	
	<%-- //asuntosStore.webflow({id:'1', idSesion:'1'});--%>
	
	var rendererApellidosNombre = function(value, p, r)
    {    	
    	var apellidosNombreStr = "";
    	
    	if(value != null && value != undefined && value != "")
    	{
    	    var separa = value.split("-");
    	    var apellido1Str = separa[0]; 
    	    var apellido2Str = separa[1]; 
    	    var nombreStr    = separa[2]; 
    	    
    	    if(apellido1Str.length > 0)
    	    {
    	       apellidosNombreStr = apellidosNombreStr + apellido1Str;
    	    }
    	    if(apellido2Str.length > 0)
    	    {
    	       apellidosNombreStr = apellidosNombreStr + " " + apellido2Str;
    	    }
    	    
    	    if(apellidosNombreStr.length > 0)
    	    {
    	       apellidosNombreStr = apellidosNombreStr + ", ";
    	    }
    	    
    	    if(nombreStr.length > 0)
    	    {
    	       apellidosNombreStr = apellidosNombreStr + nombreStr;
    	    }
    	    
    	}    	    	
    	
    	return apellidosNombreStr;    		
    } 

	var asuntosCm = new Ext.grid.ColumnModel([
	{
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
		header: '<s:message code="asuntos.listado.tipo.asunto" text="**Tipo Asunto"/>',
		dataIndex: 'tipoAsunto', sortable: true	
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
	]);
	
	var botonesTabla = fwk.ux.getPaging(asuntosStore);
	botonesTabla.hide();
	
	var gridAsuntos=app.crearGrid(asuntosStore,asuntosCm,{
		title: '<s:message code="asuntos.grid.titulo" text="**asuntos" />'	
		//,style:'padding:10px'
		,cls:'cursor_pointer'
		,iconCls : 'icon_asuntos'
		,height:175
		//,autoWidth : true
		,bbar : [ botonesTabla  ]
		<app:test id="listaAsuntos" addComa="true"/>
	});
	
	gridAsuntos.on('rowdblclick', function(grid, rowIndex, e) {
    	var rec = grid.getStore().getAt(rowIndex);
    	var nombre_asunto=rec.get('nombre');
    	var id=rec.get('id');
    	app.abreAsunto(id, nombre_asunto);
    });
    
    asuntosStore.on('load',function(){
           panelFiltros.getTopToolbar().setDisabled(false);
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
	page.add(mainPanel);

</fwk:page>