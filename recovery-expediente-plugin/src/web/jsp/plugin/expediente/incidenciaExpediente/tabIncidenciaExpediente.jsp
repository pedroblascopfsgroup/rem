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
	
	var incidenciasRecord = Ext.data.Record.create([
		 {name:'idIncidencia'}
		,{name:'fechaCrear'}
        ,{name:'persona'}
        ,{name:'contrato'}
        ,{name:'usuario'}
        ,{name:'tipoIncidencia'}
        ,{name:'situacionIncidencia'}
        ,{name:'observaciones'}
        ,{name:'idSituacionIncidencia'}
    ]);
    
    var incidenciasStore = page.getStore({
		id:'incidenciasStore'
		,remoteSort:true
		,event:'listado'
		,storeId : 'incidenciasStore'
		,limit: limit
		,baseParams:paramsBusquedaInicial
		,flow : 'incidenciaexpediente/getListadoIncidenciaExpediente'
		,reader : new Ext.data.JsonReader({root:'incidencias',totalProperty : 'total'}, incidenciasRecord)
	});
	
	
	var dictSituacionIncidencia = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsSituacionIncidencia = page.getStore({
	       flow: 'incidenciaexpediente/getListadoSituacionIncidencia'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listado'
	    }, dictSituacionIncidencia)	       
	});	
	
	optionsSituacionIncidencia.webflow();
	
    var rendererComboSituacion = function(value) {
    	var index = optionsSituacionIncidencia.findExact('id', value);
        if (index == undefined) return '';
        
        var record = optionsSituacionIncidencia.getAt(index);
        if (!record) return '';
        
        return record.get('descripcion');
    };
    
    var combo = new Ext.form.ComboBox({name:'comboSituacionIncidencia',store:optionsSituacionIncidencia,displayField:'descripcion',valueField:'id',mode: 'remote',triggerAction: 'all'});
	
	
	var coloredRender = function (value, meta, record) {
		var situacion = record.get('idSituacionIncidencia');
		if (situacion){
			//no style
		}
		else {
			return '<span style="color: #4169E1; font-weight: bold;">'+value+'</span>';
		}
		return value;
	};	
	
	var personasCm = new Ext.grid.ColumnModel([
			{header: '<s:message code="plugin.expediente.incidencias.tab.fecha" text="**Fecha" />',dataIndex: 'fechaCrear',sortable:true, renderer: coloredRender}
			,{header: '<s:message code="plugin.expediente.incidencias.tab.persona" text="**Persona" />',dataIndex: 'persona',sortable:true, renderer: coloredRender}
	        ,{header: '<s:message code="plugin.expediente.incidencias.tab.contrato" text="**Contrato" />',dataIndex: 'contrato',sortable:true, renderer: coloredRender}
			,{header: '<s:message code="plugin.expediente.incidencias.tab.usuario" text="**Usuario" />',dataIndex: 'usuario',sortable:true, renderer: coloredRender}
            ,{header: '<s:message code="plugin.expediente.incidencias.tab.tipo" text="**Tipo intervención" />',dataIndex: 'tipoIncidencia',sortable:true, renderer: coloredRender}
            ,{header: '<s:message code="plugin.expediente.incidencias.tab.observaciones" text="**Observaciones" />',dataIndex: 'observaciones',sortable:true, renderer: coloredRender}
  			,{header: '<s:message code="plugin.expediente.incidencias.tab.situacion" text="**Situacion" />', width: 200, dataIndex: 'idSituacionIncidencia',sortable:true, renderer: coloredRender
                     ,editor:new Ext.form.ComboBox({name:'combo',store:optionsSituacionIncidencia,displayField:'descripcion',valueField:'id',mode: 'remote',triggerAction: 'all'
                     <sec:authorize ifNotGranted="CAMBIAR-ESTADO-INCIDENCIA">
                     ,disabled:true
                     </sec:authorize>
                     })
                     ,renderer:rendererComboSituacion}
  	 ]);

	
			
		
	
	var btnAgregar = new Ext.Button({
		text:'<s:message code="plugin.expediente.incidencias.tab.nuevaIncidencia" text="**Nueva incidencia" />'
		,iconCls:'icon_mas'
		,handler:function(){
				nuevaIncidencia();
			
		}
	});
	
	var btnBorrar = new Ext.Button({
		text:'<s:message code="app.borrar" text="**Borrar" />'
		,iconCls:'icon_menos'
		,disabled:true
		,handler:function(){
			Ext.Msg.show({
				   title:'Confirmación',
				   msg: '<s:message code="plugin.expediente.incidencias.nuevaIncidencia.confirmarBorrado" text="**Confirmar borrado" />',
				   buttons: Ext.Msg.YESNO,
				   animEl: 'elId',
				   width:450,
				   fn: deleteIncidencia,
				   icon: Ext.MessageBox.QUESTION
				});
		}
	});
	var deleteIncidencia = function(opt){
	
	   if(opt == 'no'){
	      //page.fireEvent(app.event.CANCEL);
	   }
	   if(opt == 'yes'){
			page.webflow({
	      			flow:'incidenciaexpediente/borrarIncidencia'
	      			,params:{
	      				   id:idIncidencia
	      				}
	      			,success: function(){
            		   recargar();
            		}	
	      		});
	      }
	}
	
	//Funcion encargada de abrir el popup para editar los datos de las personas.
	var nuevaIncidencia=function(){
			win = app.openWindow(
				{
					flow:'incidenciaexpediente/abrirNuevaVentanaIncidenciaExpediente',
					title : '<s:message code="plugin.expediente.incidencias.tab.nuevaIncidencia" text="**Nueva incidencia" />',
					params: {id: idExpediente},
					closable: true,
					height:300,
					width: 600
				}
			);
			win.on(app.event.CANCEL,
					function(){
						win.close();
					}
			);
			win.on(app.event.DONE,
					function(){
						win.close();
						recargar();
					}
			);
	};
	
	var recargar = function(){
		incidenciasStore.webflow({
			 start:0
			,limit:limit
			,idExpediente:idExpediente
		});
	}
	
	var pagingBar=fwk.ux.getPaging(incidenciasStore);
	
	var incidenciasGrid=app.crearEditorGrid(incidenciasStore,personasCm,{
        title:'<s:message code="plugin.expediente.incidencias.tab.tituloGrid" text="**Listado de incidencias" />'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:350
        ,bbar : [  pagingBar
        	<sec:authorize ifAllGranted="ALTA-INCIDENCIAS-EXPEDIENTE">
				,btnAgregar
			</sec:authorize>
			<sec:authorize ifAllGranted="BORRAR-INCIDENCIAS-EXPEDIENTE">
			 ,btnBorrar
			</sec:authorize>
		 ]
    });
    
   
    incidenciasGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) { 
    	 
    	var recStore=incidenciasStore.getAt(rowIndex);
    	
    	if (recStore.get('idIncidencia')!=null && recStore.get('idIncidencia')!="") { 
    		idIncidencia = recStore.get('idIncidencia');
    	}
    	
    	<%-- Puede borrar sus propias incidencias --%>
    	btnBorrar.setDisabled(true);
    	if(app.usuarioLogado.apellidoNombre == recStore.get('usuario')){
    		btnBorrar.setDisabled(false);
    	}
    	
    	<%-- El supervisor puede borrar todas las incidencias --%>
    	<%-- TODO --%>
    	
    	
	}); 

	 
	
  	incidenciasGrid.on('cellclick', function(grid, rowIndex, columnIndex, e){ 
	    var cm = grid.getColumnModel();
        if (cm) {
            var columnName = cm.getColumnAt(columnIndex).dataIndex;
            
            if (columnName == 'idSituacionIncidencia') {
                var rec = grid.getStore().getAt(rowIndex);
                if(rec.get('idSituacionIncidencia')!=null && rec.get('idSituacionIncidencia')!=''){
                    var value = parseInt(rec.get('idSituacionIncidencia'));
                    enviaUpdate(rec, 'idSituacionIncidencia', value);
                }
            }
        }
        
    });
  
    
 
    var enviaUpdate = function(record, field, value) {
        if (field == 'idSituacionIncidencia')
            record.set('idSituacionIncidencia', value);
        else 
            record.set('idSituacionIncidencia', 1);
        
        var params = {
                id:record.get('idIncidencia')
                ,situacion:record.get('idSituacionPrevista')
        };
           
        params[field]=value;
           
        Ext.Ajax.request({
            url: page.resolveUrl('incidenciaexpediente/updateIncidencia')
			,method: 'POST'
			,params:params
            ,success: function(response, opt) {}
            ,failure: function(response, opt) {}
        });
     
    };
 
    
  
    incidenciasGrid.on('afteredit', function(e){
        enviaUpdate(e.record, e.field, e.value);
    });
	  
	  
	  
	var proveedor = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionsProveedorStore = page.getStore({
	       flow: 'incidenciaexpediente/getListadoProveedores'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listado'
	    }, proveedor)	       
	});	
	var comboProveedores = new Ext.form.ComboBox({
				store:optionsProveedorStore
				,displayField:'descripcion'
				,valueField:'id'
				,forceSelection:true 				
				,mode: 'remote'
				,autoWidth:true
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,fieldLabel:'<s:message code="plugin.expediente.incidencias.tab.busqueda.filtros.proveedor" text="**Proveedor" />'
				,name: 'comboProveedores'
				<app:test id="comboProveedoresAA" addComa="true"/>
	});
	
	var tipoIntervencion = Ext.data.Record.create([
		 {name:'id'}
		,{name:'descripcion'}
	]);
	
	var optionstipoIntervencionStore = page.getStore({
	       flow: 'incidenciaexpediente/getListadoTiposIncidencia'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listado'
	    }, tipoIntervencion)	       
	});	
	
	var combotipoIntervencion = new Ext.form.ComboBox({
				store:optionstipoIntervencionStore
				,displayField:'descripcion'
				,valueField:'id'
				,forceSelection:true 				
				,mode: 'remote'
				,autoWidth:true
				,resizable: true			
				,emptyText:'---'
				,triggerAction: 'all'
				,editable: false
				,fieldLabel:'<s:message code="plugin.expediente.incidencias.tab.busqueda.filtros.tipo" text="**Tipo" />'
				,name: 'combotipoIntervencion'
				<app:test id="combotipoIntervencionAA" addComa="true"/>
	});
	

	
	var fechaDesde = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaVencHasta'
		,height:20
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
		,fieldLabel:'<s:message code="plugin.expediente.incidencias.tab.busqueda.filtros.fechaDesde" text="**Desde" />'
	});
	
	var fechaHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaVencHasta'
		,height:20
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
		,fieldLabel:'<s:message code="plugin.expediente.incidencias.tab.busqueda.filtros.fechaHasta" text="**Hasta" />'
	});

	var getParametrosBusqueda=function(){
		return {
			 start:0
			,limit:limit
			,idProveedor:comboProveedores.getValue()
			,idTipoIncidencia:combotipoIntervencion.getValue()
			,fechaDesde:app.format.dateRenderer(fechaDesde.getValue())
			,fechaHasta:app.format.dateRenderer(fechaHasta.getValue())
			,idExpediente:idExpediente
		}
	}
	
	var validarForm=function(){
		return true;
	}
	var buscarFunc=function(){

		if(validarForm()){
			isBusqueda=true;
			panelFiltros.collapse(true);
			incidenciasStore.webflow(getParametrosBusqueda());
			
			panelFiltros.getTopToolbar().setDisabled(true);	
			
		}else{
			Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','Introduzca parámetros de búsqueda');
		}
	}
	
	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
	
	var btnClean=new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			app.resetCampos([comboProveedores, combotipoIntervencion, fechaDesde, fechaHasta]);
			//incidenciasStore.webflow(paramsBusquedaInicial);
			//panelFiltros.collapse(true);
		}
	});	
	
	var panelFiltros = new Ext.Panel({
		title : '<s:message code="plugin.expediente.incidencias.tab.busquedaIncidencias" text="**Búsqueda de incidencias"/>'
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
		,layoutConfig : {columns:2}
		,bodyStyle:'cellspacing:10px;padding-right:10px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;'}
		,items:[{
				layout:'form'
				,defaults:{xtype:'fieldset',border:false}
				,width:'320px'
				,items:[comboProveedores, combotipoIntervencion]
			},{
				layout:'form' 
				,width:'320px'
				,defaults:{xtype:'fieldset',border:false}
				,items:[fechaDesde, fechaHasta]
			}
		]              
		,tbar:[btnBuscar,btnClean]
	});
	
	var panel = new Ext.Panel({
        title : '<s:message code="plugin.expediente.incidencias.titulo" text="**Incidencias" />',
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
   					items:[incidenciasGrid]
   				}]
    });
    
	panel.getValue = function(){
	}
	
	incidenciasStore.on('load',function(){
           panelFiltros.getTopToolbar().setDisabled(false);
    });
	
	var data;
	
	panel.setValue = function(){	
		data = entidad.get("data");
		idExpediente = data.id;
		panelFiltros.collapse(true);
		recargar();
	}

	panel.setVisibleTab = function(data){
		if (data.toolbar.tipoExpediente!='SEG' && data.toolbar.tipoExpediente!='RECU')
			return true;
		else
			return false;
	}
	
  
	return panel;
})

