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

var entidad= ${entidad};
var labelWidth=30;
var checkBoxWidthCol1=180;
var checkBoxWidthCol23=240;
var limit = 25;

<%-- 
var cNivel=3;
var cTotalExpedientes=4;
var cImporte=5;
var cTareasVencidas=6;
var cTareasPendientesHoy=7;
var cTareasPendientesSemana=8;
var cTareasPendientesMes=9;	
var cTareasPendientesMasMes=10;
var cTareasPendientesMasAño=11;
var cTareasFinalizadasAyer=12;
var cTareasFinalizadasSemana=13;
var cTareasFinalizadasMes=14;
var cTareasFinalizadasAnyo=15;
var cTareasFinalizadas=16;
--%>

Ext.Ajax.timeout=10*60*1000; //Timeout de 10 minutos
 var thousandSeparator = function add_thousands_separator(input) {
        var s = input.toString(), l = s.length, o = '';
        while (l > 3) {
         var c = s.substr(l - 3, 3);
         o = '.' + c + o;
         s = s.replace(c, '');
         l -= 3;
        }
        o = s + o;
        return o;
       }
  var millonSeparator = function(num){
        if (num==null){
         num=0;
        }
        if (num=="---"){
         return "";
        }
        if (isNaN(num)) {
         return '##ERROR: CAMPO NO NUMERICO##'
        }
        num = num.toString().replace(/\$|\,/g,'');
        //sign = (num == (num = Math.abs(num)));
        num = Math.floor(num*100+0.50000000001);
        num = Math.floor(num/100).toString();
        
        if(num.length <= 6){
         for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++) {
          num = num.substring(0,num.length-(4*i+3))+ app.format.THOUSANDS_SEPARATOR 
           + num.substring(num.length-(4*i+3));
         }
        }
        else{
         var mi = num.substring(0,num.length - 6);
         var resto = num.substring(num.length - 6);
         
         
         num = mi +','+resto.substring(0,2) +' MM';
        }
         
         
        return (num+' '+ app.EURO);
       
       }; 
  

 
 var ocultarMostrarColumnas = function(id,valor){
 	  var colId = panelControlGrid.getColumnModel().getIndexById(id);
      if (valor){
      		panelControlGrid.getColumnModel().setHidden(colId,false);
      }else{
            panelControlGrid.getColumnModel().setHidden(colId,true);
      }
  };
 
  var checkBoxes = [];
	    
  var leyenda = new Ext.form.FieldSet({
	autoHeight:'true'
	,style:'padding:0px'
	,border:true
	,layout : 'table'
	,width:1200
	,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',style:'padding:10px'}
    ,items :[]
 }); 
 
 
 var panelLeyenda = new Ext.Panel({
        autoWidth: true,
        title : '<s:message code="plugin.panelControl.letrados.pestana.columna" text="**Columnas" />',
  		border:false,
  		width:1200,
        layout: 'column',
        defaults : {xtype : 'fieldset', autoHeight : true, border : false,style:'padding:0px'},
  		items : [leyenda]
 });
 

 
 
 var dictNiveles = <app:dict value="${niveles}" />;
 
 var storeNiveles = new Ext.data.JsonStore({
        fields: ['codigo', 'descripcion']
        ,data : dictNiveles
        ,root: 'diccionario'
 });
 
 var comboNiveles = new Ext.form.ComboBox({
    name: 'comboNiveles',
    fieldLabel: '<s:message code="plugin.panelControl.letrados.letrados.jerarquia" text="**Jerarquía" />',
    title: '<s:message code="plugin.panelControl.letrados.letrados.jerarquia" text="**Jerarquía" />',
    mode: 'local',
    store: storeNiveles,
    displayField:'descripcion',
    valueField:'codigo',
    emptyText:'---',
    style:'padding:0px;margin:0px;',
    triggerAction: 'all',
    labelStyle:'width:50px',
    width: 110
 }); 
 
	var idLetradoGestorRecord = Ext.data.Record.create([
	    {name:id}
		,{name:'descripcion'}
	]);

	var storeLetradoGestor = page.getStore({
		storeId : 'storeLetradoGestor'	
		,flow:'plugin.panelControl.letrados.buscarLetradoGestor'
		,reader: new Ext.data.JsonReader({root:'letrado'},idLetradoGestorRecord)
	});

	var comboLetradoGestor =new Ext.form.ComboBox({
		store:storeLetradoGestor
		,labelStyle:'width:130px'
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'descripcion'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel: '<s:message code="plugin.panelControl.letrados.letrados.letradoGestor" text="**Letrado/Gestor" />'
		,width:260
		,value:''
	});

	comboLetradoGestor.on('select', function(){
		comboNiveles.setValue(305);
		comboNiveles.setDisabled(true);
	});
 
 	comboLetradoGestor.on('blur', function(){
		if (comboLetradoGestor.getValue()=='')
			comboNiveles.setDisabled(false);
	});
	
 var dictTipoProcedimiento = <app:dict value="${tipoProcedimientos}" />;
 
 var storeTipoProcedimiento = new Ext.data.JsonStore({
        fields: ['codigo', 'descripcion']
        ,data : dictTipoProcedimiento
        ,root: 'diccionario'
 });
 
	var comboTipoProcedimiento =new Ext.form.ComboBox({
		store:storeTipoProcedimiento
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'codigo'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,width:250
    	,labelStyle:'width:70px'
	    ,fieldLabel : '<s:message code="plugin.panelControl.letrados.busqueda.tipoProcedimiento" text="**Procedimiento"/>'
		,width:260
		,value:''
	});
		
	var recargarTipoProcedimiento = function(){
		comboTipoProcedimiento.store.removeAll();
		comboTipoProcedimiento.clearValue();
		if (comboTiposActuacion.getValue()!=null && comboTiposActuacion.getValue()!=''){
			storeTipoProcedimiento.webflow({codigo:comboTiposActuacion.getValue()});
		}
	}
	
 	var dictTiposActuacion = <app:dict value="${tiposActuacion}" />;
 	
	 var storeTiposActuacion = new Ext.data.JsonStore({
	        fields: ['codigo', 'descripcion']
	        ,data : dictTiposActuacion
	        ,root: 'diccionario'
	 });
	 
	 var comboTiposActuacion = new Ext.form.ComboBox({
	    store:storeTiposActuacion
	    ,displayField:'descripcion'
	    ,valueField:'codigo'
	    ,mode: 'local'
	    ,editable: false 
	    ,width:250
	    ,labelStyle:'width:70px'
	    ,resizable: true   
	    ,triggerAction: 'all'
	    ,emptyText:'---'
	    ,fieldLabel : '<s:message code="plugin.panelControl.letrados.busqueda.tiposActuacion" text="**Tipos Actuación"/>'
	 }); 
 	
	comboTiposActuacion.on('select', function(){
		recargarTipoProcedimiento();
	});
 
  var idTareaProcedimientoRecord = Ext.data.Record.create([
     {name:'id'}
	,{name:'descripcion'}
  ]);

	var storeTipoTarea = page.getStore({
		flow:'plugin.panelControl.letrados.buscarTareasProcedimiento'
		,reader: new Ext.data.JsonReader({
			idProperty: 'id'
			,root:'idTareaProc'
		},idTareaProcedimientoRecord)
	});
		
	var comboTipoTarea =new Ext.form.ComboBox({
		store:storeTipoTarea
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,displayField: 'descripcion'
		,valueField: 'descripcion'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,labelStyle:'width:130px'
	    ,fieldLabel : '<s:message code="plugin.panelControl.letrados.busqueda.tipoTarea" text="**Tarea"/>'
		,width:260
		,value:''
	});
		
	var recargarIdTareaProcedimiento = function(){
		comboTipoTarea.store.removeAll();
		comboTipoTarea.clearValue();
		if (comboTipoProcedimiento.getValue()!=null && comboTipoProcedimiento.getValue()!=''){
			storeTipoTarea.webflow({codigo:comboTipoProcedimiento.getValue()});
		}
	}
	
	comboTipoProcedimiento.on('select', function(){
		recargarIdTareaProcedimiento();
	});

	var idCampanyaRecord = Ext.data.Record.create([
		{name:'id'}
		,{name:'descripcion'}
	]);

	var storeCampanya = page.getStore({
		storeId : 'storeCampanya'	
		,flow:'plugin.panelControl.letrados.buscarCampanyas'
		,reader: new Ext.data.JsonReader({root:'campanyas'},idCampanyaRecord)
	});

	var comboCampanyas =new Ext.form.ComboBox({
		store:storeCampanya
		,allowBlank: true
		,blankElementText: '--'
		,disabled: false
		,labelStyle:'width:130px'
		,displayField: 'descripcion'
		,valueField: 'descripcion'
		,resizable: true
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel: '<s:message code="plugin.panelControl.letrados.letrados.campanya_${entidad}" text="**Campaña/Plan de acción" />'
		,width:260
		,value:''
	});
	
 	var dictRangoImportes = <app:dict value="${rangoImportes}" />;
 	
	 var storeRangoImportes = new Ext.data.JsonStore({
	        fields: ['codigo', 'descripcion']
	        ,data : dictRangoImportes
	        ,root: 'diccionario'
	 });
	  
	 var comboRangoImportes = new Ext.form.ComboBox({
	    store:storeRangoImportes
	    ,displayField:'descripcion'
	    ,valueField:'codigo'
	    ,mode: 'local'
	    ,editable: false 
	    ,width:150
	    ,labelStyle:'width:100px'
	    ,resizable: true   
	    ,triggerAction: 'all'
	    ,emptyText:'---'
	    ,fieldLabel : '<s:message code="plugin.panelControl.letrados.importe" text="**Importe"/>'
	 }); 	

	var importeFiltro = app.creaMinMaxMoneda('<s:message code="plugin.panelControl.letrados.letrados.importe" text="**Importe" />', 'importeFiltro',{width : 125, widthPanel : 370, widthFieldSet : 370});
 
	var panelCombos=new Ext.Panel({
		autoHeight:true
		,autoWidth:true
		,layout:'table'
		,title : '<s:message code="plugin.panelControl.letrados.pestana.datosGenerales" text="**Filtros" />'
		,layoutConfig:{columns:2}
		,bodyStyle:'padding:5px;cellspacing:10px'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px'}
		,items:[{
			width:380,items:[comboNiveles,comboTipoProcedimiento,comboRangoImportes]
			},{
			width:460,items:[comboLetradoGestor,comboTipoTarea,comboCampanyas]
		}]
	});

<%-- vamos a modificarlo para que coja el panel dinámicamente --%>

var columnaRecord = Ext.data.Record.create([
        {name:'header'}
        ,{name:'align'}
        ,{name:'dataindex'}
        ,{name:'sortable'}
        ,{name:'width'}
        ,{name:'hidden'}
        ,{name:'type'}
        ,{name:'flow_click'}
        ,{name:'panelTareas'}
        ,{name:'etiqueta'}
    ]);

var columns = [];
var checks = [];

var gridColModel = new Ext.grid.ColumnModel(columns);

var index = 0;

var columnaStore =  page.getStore({
		id:'columnaStore'
		,eventName:'listado'
		,limit:25
		,remoteSort : true
		,storeId : 'columnaStore'
		,flow : 'plugin.panelControl.letrados.columnasData'
		,reader : new Ext.data.JsonReader({root:'columna'}, columnaRecord)
	});
	
var getParametros = function() {
		return {
			meta:true
			,tipo:'RES'
			,cod:'${cod}'
			,nivel:'${nivel}'
			,idNivel:'${idNivel}'
			,cod:'${cod}'
			,nombre:'${nombre}'
			,userName:'${userName}'
			,tipoProcedimiento:'${tipoProcedimiento}'
			,tipoTarea:'${tipoTarea}'
			,letradoGestor:'${letradoGestor}'
			,campanya:'${campanya}'
			,minImporteFiltro:'${minImporteFiltro}'
			,maxImporteFiltro:'${maxImporteFiltro}'
			,rangoImporte:'${rangoImporte}'
		};
	};

columnaStore.on('load', function(store, data, options){

			
			var col = 0;
			var fila = 0;
			var checks = [];

			columnaStore.each(function() {
				var rec=store.getAt(index);
				visible=(rec.get('hidden')==0)?false:true;
				 switch(rec.get('type')){
			    	case 'fecha':
			    		columns[index]={id: rec.get('dataindex'), header: rec.get('header'),dataIndex: rec.get('dataindex'),width: parseInt((rec.get('width'))),align: rec.get('align'),sortable: true,hidden: visible,renderer:app.format.dateRenderer};			
			    		break;
			    	case 'numero':
			    		columns[index]={id: rec.get('dataindex'),header: rec.get('header'),dataIndex: rec.get('dataindex'),width: parseInt((rec.get('width'))),align: rec.get('align'),sortable: true,hidden: visible,renderer:millonSeparator};
			    		break;			
			    	default:
			    		columns[index]={id: rec.get('dataindex'), header: rec.get('header'),dataIndex: rec.get('dataindex'),width: parseInt((rec.get('width'))),align: rec.get('align'),sortable: true,hidden: visible};
			    }
				if (rec.get('etiqueta') != ''){			
					checks[fila] = {xtype:'checkbox'
	    				,name:rec.get('dataindex') 
	    				,checked: !visible
		     			,labelSeparator: ''
		     			,hideLabel:true
		     			,width: checkBoxWidthCol23
		     			,boxLabel: rec.get('etiqueta')
		     			,handler:function(){
		     			 	ocultarMostrarColumnas(this.name,this.getValue());
	         			}
	    		 	};
	
				    if (fila == 4){
				    	checkBoxes[col] = {items:[checks]};
				    	col++;
				    	fila = 0;
				    	checks = [];
				    }else{
				    	fila++;
				    }
				}
			    
	        	index++;
	      }
	      );
	      
			if (fila > 0){
			   	checkBoxes[col] = {items:[checks]};
			}	      
	      gridColModel.setConfig(columns);
	      

	      //Solo se lanza el store de obtención de asuntos si existen
	      //sino da error por el JSON
	      
	      panelControlStore.webflow(getParametros());
	      leyenda.add(checkBoxes);
 		  leyenda.doLayout();
	      
	});	
	
		

	var panelControlStore = page.getStore({
	 	limit:25
		,flow : 'plugin.panelControl.letrados.datosPorNivelV2'
		,reader : new Ext.data.JsonReader()
	});    

	var cm = gridColModel; 
	
	var pagingBar=fwk.ux.getPaging(panelControlStore);
 
  var panelControlGrid= new Ext.grid.GridPanel({
        title:'<s:message code="plugin.panelControl.letrados.titulo" text="**Panel de control de letrados" />'
        ,store:panelControlStore
        ,colModel:cm
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:400
        ,anchor:'100%' 
        ,viewConfig: {forceFit: true, scrollOffset:0}
        ,autoWidth:true        
        ,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
    });
  
 panelControlGrid.on('cellclick', function(grid, rowIndex,columnIndex, e) {
  	 var recStore=panelControlStore.getAt(rowIndex);
  	 var columna=columnaStore.getAt(columnIndex);
     var idColumnHeader = cm.getColumnHeader(columnIndex);
     var respuesta;
     var nivelActual = comboNiveles.getValue();
     var nuevoNivel = nivelActual;
     var indiceColumna=columnIndex;
     
     if (indiceColumna==0){
       if(nivelActual == '301')
        nuevoNivel = '302'
       else if(nivelActual == '302')
        nuevoNivel = '303'
       else if(nivelActual == '303')
        nuevoNivel = '304'
       else if(nivelActual == '304')
        nuevoNivel = '305'
      }   
      
    if (columna.get('flow_click')!=''){  
    app.openTab(columna.get('header') + ': ' + recStore.get('nivel')
      		,columna.get('flow_click')
      		,{nivel:nuevoNivel
      				,idNivel:nivelActual
      				,cod:recStore.get('cod')
      				,nombre:recStore.get('nivel')
      				,detalle:columnIndex
      				,panelTareas:columna.get('panelTareas')
      				,userName:recStore.get('userName')
      				,totalTareas:recStore.get(columna.get('dataindex'))
      				,tipoProcedimiento:comboTipoProcedimiento.getValue()
      				,tipoTarea:comboTipoTarea.getValue()
      				,campanya:comboCampanyas.getValue()
      				,letradoGestor:comboLetradoGestor.getValue()
      				,minImporteFiltro:importeFiltro.min.getValue()
      				,maxImporteFiltro:importeFiltro.max.getValue()
      				,rangoImporte:comboRangoImportes.getValue()}
      		,{id:recStore.get('id') + recStore.get('nivel')+recStore.get('cod')+columnIndex}
      		);  
      		}
 });

	var getParametrosBusqueda = function() {
		return {
			nivel:comboNiveles.getValue()
			,tipo:'RES'
			,idNivel:${idNivel}
			,cod:'${cod}'
			,tipoProcedimiento:comboTipoProcedimiento.getValue()
			,tipoTarea:comboTipoTarea.getValue()
			,letradoGestor:comboLetradoGestor.getValue()
			,campanya:comboCampanyas.getValue()
			,minImporteFiltro:importeFiltro.min.getValue()
			,maxImporteFiltro:importeFiltro.max.getValue()
			,rangoImporte:comboRangoImportes.getValue()
			,panelTareas:'VM6M'
		};
	};

	var validaMinMax = function(){
		if (!app.validaValoresDblText(importeFiltro)){
			return false;
		}
		return true;
	}

	var buscarFunc=function(){
		if (comboNiveles.getValue()!='---' && comboNiveles.getValue()!=''){
			if (validaMinMax()){
				//flitrosPlegables.collapse(true);
				panelControlStore.webflow(getParametrosBusqueda());
			}else{
				Ext.Msg.alert('<s:message code="plugin.panelControl.letrados.buscar" text="**Buscar" />','<s:message code="plugin.panelControl.letrados.buscar.importe" text="**Importe no correcto" />');
			}
		}
	}
 
 var btnClean=new Ext.Button({
  text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
  ,iconCls:'icon_limpiar'
  ,handler:function(){
		comboTipoTarea.reset();
		comboTipoProcedimiento.reset();
		importeFiltro.min.reset();
		importeFiltro.max.reset();
		comboLetradoGestor.reset();
		comboCampanyas.reset();
		comboNiveles.setDisabled(false);
		comboRangoImportes.reset();
		panelControlStore.webflow({nivel:'0', idNivel:'0',cod:'0',tipoProcedimiento:'',tipoTarea:'',letradoGestor:'',campanya:'',minImporteFiltro:'',maxImporteFiltro:'',rangoImporte:''});
  }
 });
 
 var pestañas = [panelCombos,panelLeyenda];
 
 var btnBuscar=app.crearBotonBuscar({
  handler:function(){
   		if (comboNiveles.getValue()=='---' || comboNiveles.getValue()==''){
	    	Ext.Msg.alert('<s:message code="plugin.panelControl.letrados.buscar" text="**Buscar" />','<s:message code="plugin.panelControl.letrados.buscar.novalor" text="**Debe seleccionar al menos un valor de la lista Jerarquía" />');
	    }else{
  			buscarFunc();
  		}
  }
 });
 

	var panelFiltros=new Ext.TabPanel({
		items:pestañas
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false 
		,width:900
		,activeItem:0
	});
    
	var btnExportar = new Ext.Button({
		   text:'<s:message code="plugin.panelControl.letrados.exportar.xls" text="**Exportar a Excel" />'
	       ,iconCls:'icon_exportar_csv'
	       ,handler : function(){
	       		if (comboNiveles.getValue()=='---' || comboNiveles.getValue()==''){
	    			Ext.Msg.alert('<s:message code="plugin.panelControl.letrados.error" text="**Errores" />','<s:message code="plugin.panelControl.letrados.buscar.novalor" text="**Debe seleccionar al menos un valor de la lista Jerarquía" />');
	    		}else{
  					var url = page.resolveUrl('exportarcsv/panelCSV');
			        var params="";
			        params='nivel='+ comboNiveles.getValue() + '&idNivel=' + '${idNivel}' + '&cod=' + '${cod}' + '&tipoProcedimiento=' + comboTipoProcedimiento.getValue() + '&tipoTarea=' + comboTipoTarea.getValue() + '&letradoGestor=' + comboLetradoGestor.getValue() + '&campanya=' + comboCampanyas.getValue() + '&minImporteFiltro=' + importeFiltro.min.getValue() + '&maxImporteFiltro=' + importeFiltro.max.getValue() + '&rangoImporte=' + comboRangoImportes.getValue();
			        url += '?'+ params;
			        window.open(url);
  				}
	       }
	});
 
	var flitrosPlegables = new Ext.Panel({
	  items:[panelFiltros]
	  ,titleCollapse : true
	  ,autoWidth:true
	  ,width:900
	  ,title : '<s:message code="plugin.panelControl.letrados.busqueda.filtros.titulo" text="**Filtro de Panel de control de letrados" /> - Fecha de actualización:'
	  ,style:'padding-bottom:10px; padding-right:10px;'
	  ,collapsible:true
	  ,tbar : [btnBuscar, btnClean,btnExportar]
	 });

 var tree = new Ext.ux.tree.TreeGrid({
        title: 'Panel de Control Letrados',
        //autoWidth:true,
        width: 1000,
        height: 300,
        //renderTo: mainPanel,
        //enableDD: true,

        columns:[{
            header: 'Nivel',
            dataIndex: 'nivel',
            width: 230
        },{
            header: 'Asuntos',
            width: 150,
            dataIndex: 'totalExpedientes'
        },
        {
            header: 'Tareas Vencidas',
            width: 150,
            dataIndex: 'tareasVencidas'
        },
        {
            header: 'Tareas Pendientes',
            width: 150,
            dataIndex: 'tareasPendientesMes'
        }],

		loader: new  Ext.tree.TreeLoader()
        //dataUrl: 'treegrid-data.json'
    });
    
   
    
 var mainPanel = new Ext.FormPanel({
     autoHeight:true,
     border:false,
      bodyStyle: 'padding:5px'
		,anchor:'100%'
		,autoWidth: false 
      ,items: [flitrosPlegables, panelControlGrid]
    }); 

 page.add(mainPanel);
 

	 
 var obtenerFechaRefresco=function(){
   Ext.Ajax.request({
     url: page.resolveUrl('plugin.panelControl.letrados.fechaRefrescoData')
     ,success: function (result, request){
	      var r = Ext.util.JSON.decode(result.responseText)
	      flitrosPlegables.setTitle('<s:message code="plugin.panelControl.letrados.busqueda.filtros.titulo" text="**Filtro de Panel de control de letrados" />  -  Fecha de actualización: ' + r.fechaRefresco);
     }    
   });
  };
  
	var loadFiltros = function() {
		comboNiveles.setValue(${nivel}); 
		comboTipoProcedimiento.setValue('${tipoProcedimiento}');
		if ('${tipoProcedimiento}'!='')
			recargarIdTareaProcedimiento();
		comboTipoTarea.setValue('${tipoTarea}');
		comboLetradoGestor.setValue('${letradoGestor}');
		comboCampanyas.setValue('${campanya}');
		importeFiltro.min.setValue('${minImporteFiltro}');
		importeFiltro.max.setValue('${maxImporteFiltro}');
		comboRangoImportes.setValue('${rangoImporte}');
	};

	


	Ext.onReady(function(){
		obtenerFechaRefresco();
		storeCampanya.webflow();
		storeLetradoGestor.webflow();
		columnaStore.webflow({tipo:'RES'});
		if (${nivel}==0){
			comboNiveles.setValue('---'); 
		}else{
			loadFiltros();
			//columnaStore.webflow({tipo:'RES'});
			//loadColumnas();
		}
	
		buscarFunc();
	});

</fwk:page>
