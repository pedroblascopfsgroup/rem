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

var labelWidth=30;
var checkBoxWidthCol1=180;
var checkBoxWidthCol23=240;
var limit = 25;

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
  
 var nivel = new Ext.form.Checkbox({
	name:'nivel'
	,checked: true
	,labelSeparator: ''
	,hideLabel:true
	,width: checkBoxWidthCol1
	,boxLabel: '<s:message code="plugin.panelControl.letrados.nivel" text="**N.: Nivel" />'
	,handler:function(){
           ocultarMostrarColumnas(cNivel,nivel.getValue());
       }
 });
 var  totalExpedientes = new Ext.form.Checkbox({
 	name:'totalExpedientes'
	,checked: true
	,hideLabel:true
	,labelSeparator: ''
	,width: checkBoxWidthCol23
	,boxLabel: '<s:message code="plugin.panelControl.letrados.totalExpedientes" text="**T.E.: Total Expedientes" />'
	,handler:function(){
         ocultarMostrarColumnas(cTotalExpedientes,totalExpedientes.getValue());
       }
 });
 var  importe = new Ext.form.Checkbox({
  	name:'importe'
	,checked: true
	,hideLabel:true
	,labelSeparator: ''
	,width: checkBoxWidthCol23
	,boxLabel: '<s:message code="plugin.panelControl.letrados.importe" text="**I.: Importe total" />'
	,handler:function(){
           ocultarMostrarColumnas(cImporte,importe.getValue());
       }
 });
 var tareasVencidas = new Ext.form.Checkbox({
   	name:'tareasVencidas'
	,checked: true
	,hideLabel:true
	,labelSeparator: ''
	,width: checkBoxWidthCol1
	,boxLabel: '<s:message code="plugin.panelControl.letrados.tareasPendientesVencidas" text="**T.V.: Tareas vencidas" />'
	,handler:function(){
           ocultarMostrarColumnas(cTareasVencidas,tareasVencidas.getValue());
       }
 });
 var tareasPendientesHoy = new Ext.form.Checkbox({
    name:'tareasPendientesHoy'
	,checked: true
	,hideLabel:true
	,labelSeparator: ''
	,width: checkBoxWidthCol23
	,boxLabel: '<s:message code="plugin.panelControl.letrados.tareasPendientesHoy" text="**T.P.H.: Tareas pendientes hoy" />'
	,handler:function(){
           ocultarMostrarColumnas(cTareasPendientesHoy,tareasPendientesHoy.getValue());
       }
 });

 var tareasPendientesSemana = new Ext.form.Checkbox({
     name:'tareasPendientesSemana'
	 ,checked: true
	 ,hideLabel:true
	 ,labelSeparator: ''
	 ,width: checkBoxWidthCol23
	 ,boxLabel: '<s:message code="plugin.panelControl.letrados.tareasPendientesSemana" text="**T.P.S.: Tareas pendientes semana" />'
	 ,handler:function(){
           ocultarMostrarColumnas(cTareasPendientesSemana,tareasPendientesSemana.getValue());
     }
 });
 var  tareasPendientesMes = new Ext.form.Checkbox({
      name:'tareasPendientesMes'
	 ,checked: true
	 ,hideLabel:true
	 ,labelSeparator: ''
	 ,width: checkBoxWidthCol1
	 ,boxLabel: '<s:message code="plugin.panelControl.letrados.tareasPendientesMes" text="**T.P.M.: Tareas pendientes mes" />'
	 ,handler:function(){
           ocultarMostrarColumnas(cTareasPendientesMes,tareasPendientesMes.getValue());
     }
 });
 var  tareasPendientesMasMes = new Ext.form.Checkbox({
       name:'tareasPendientesMasMes'
	  ,checked: true
	  ,hideLabel:true
	  ,labelSeparator: ''
	  ,width: checkBoxWidthCol23
	  ,boxLabel: '<s:message code="plugin.panelControl.letrados.tareasPendientesMasMes" text="**T.P.M.M.: Tareas pendientes más de un mes" />'
	  ,handler:function(){
           ocultarMostrarColumnas(cTareasPendientesMasMes,tareasPendientesMasMes.getValue());
     }
 });
 var  tareasPendientesMasAño = new Ext.form.Checkbox({
        name:'tareasPendientesMasAño'
	   ,checked: true
	   ,hideLabel:true
	   ,labelSeparator: ''
	   ,width: checkBoxWidthCol23
	   ,boxLabel: '<s:message code="plugin.panelControl.letrados.tareasPendientesMasAnyo" text="**T.P.M.A.: Tareas pendientes más de un año" />'
	   ,handler:function(){
           ocultarMostrarColumnas(cTareasPendientesMasAño,tareasPendientesMasAño.getValue());
     }
 });
 var  tareasFinalizadasAyer = new Ext.form.Checkbox({
         name:'tareasFinalizadasAyer'
	     ,checked: false
	     ,hideLabel:true
	     ,labelSeparator: ''
	     ,width: checkBoxWidthCol1
	     ,boxLabel: '<s:message code="plugin.panelControl.letrados.tareasFinalizadasAyer" text="**T.F.H.: Tareas finalizadas ayer" />'
	     ,handler:function(){
            ocultarMostrarColumnas(cTareasFinalizadasAyer,tareasFinalizadasAyer.getValue());
         }
 });
 var  tareasFinalizadasSemana = new Ext.form.Checkbox({
          name:'tareasFinalizadasSemana'
	     ,checked: false
	     ,hideLabel:true
	     ,labelSeparator: ''
	     ,width: checkBoxWidthCol23
	     ,boxLabel: '<s:message code="plugin.panelControl.letrados.tareasFinalizadasSemana" text="**T.F.S.: Tareas finalizadas semana" />'
	     ,handler:function(){
            ocultarMostrarColumnas(cTareasFinalizadasSemana,tareasFinalizadasSemana.getValue());
         }
 });
  var  tareasFinalizadasMes = new Ext.form.Checkbox({
         name:'tareasFinalizadasMes'
	     ,checked: false
	     ,hideLabel:true
	     ,labelSeparator: ''
	     ,width: checkBoxWidthCol23
	     ,boxLabel: '<s:message code="plugin.panelControl.letrados.tareasFinalizadasMes" text="**T.F.M.: Tareas finalizadas mes" />'
	     ,handler:function(){
            ocultarMostrarColumnas(cTareasFinalizadasMes,tareasFinalizadasMes.getValue());
         }
 });
  var  tareasFinalizadasAnyo = new Ext.form.Checkbox({
         name:'tareasFinalizadasAnyo'
	     ,checked: false
	     ,hideLabel:true
	     ,labelSeparator: ''
	     ,width: checkBoxWidthCol1
	     ,boxLabel: '<s:message code="plugin.panelControl.letrados.tareasFinalizadasAnyo" text="**T.F.A.: Tareas finalizadas año" />'
	     ,handler:function(){
            ocultarMostrarColumnas(cTareasFinalizadasAnyo,tareasFinalizadasAnyo.getValue());
         }
 });
  var  tareasFinalizadas = new Ext.form.Checkbox({
         name:'tareasFinalizadas'
	     ,checked: false
	     ,labelSeparator: ''
	     ,hideLabel:true
	     ,width: checkBoxWidthCol23
	     ,boxLabel: '<s:message code="plugin.panelControl.letrados.tareasFinalizadas" text="**T.T.F.: Tareas finalizadas" />'
	     ,handler:function(){
            ocultarMostrarColumnas(cTareasFinalizadas,tareasFinalizadas.getValue());
         }
 });
 
 var ocultarMostrarColumnas = function(id,valor){
      if (valor){
              panelControlGrid.getColumnModel().setHidden(id,false);
          }else{
              panelControlGrid.getColumnModel().setHidden(id,true);
          }
  };

 var leyenda = new Ext.form.FieldSet({
	autoHeight:'true'
	,style:'padding:0px'
	,border:true
	,layout : 'table'
	,width:900
	,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',style:'padding:10px'}
	,items : [{
	     columnWidth:.25,items:[nivel,tareasVencidas,tareasPendientesMes,tareasFinalizadasAyer,tareasFinalizadasAnyo]
	    },{
	     columnWidth:.37,items:[totalExpedientes,tareasPendientesHoy,tareasPendientesMasMes,tareasFinalizadasSemana,tareasFinalizadas]
	    },{
	    columnWidth:.37,items:[importe,tareasPendientesSemana,tareasPendientesMasAño,tareasFinalizadasMes]}]
 }); 
 
 var panelLeyenda = new Ext.Panel({
        autoWidth: true,
        title : '<s:message code="plugin.panelControl.letrados.pestana.columna" text="**Columnas" />',
  		border:false,
  		width:900,
        layout: 'column',
        defaults : {xtype : 'fieldset', autoHeight : true, border : false,style:'padding:0px'},
  		items : [leyenda]
 });
 
 var ditcNiveles = <app:dict value="${niveles}" />;
 
 var storeNiveles = new Ext.data.JsonStore({
        fields: ['codigo', 'descripcion']
        ,data : ditcNiveles
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
	
 var ditcTipoProcedimientos = <app:dict value="${tipoProcedimientos}" />;
 
 var storeTipoProcedimiento = new Ext.data.JsonStore({
        fields: ['codigo', 'descripcion']
        ,data : ditcTipoProcedimientos
        ,root: 'diccionario'
 });
 
 var comboTipoProcedimiento = new Ext.form.ComboBox({
    store:storeTipoProcedimiento
    ,displayField:'descripcion'
    ,valueField:'codigo'
    ,mode: 'local'
    ,editable: false 
    ,width:250
    ,labelStyle:'width:70px'
    ,resizable: true   
    ,triggerAction: 'all'
    ,emptyText:'---'
    ,fieldLabel : '<s:message code="plugin.panelControl.letrados.busqueda.tipoProcedimiento" text="**Procedimiento"/>'
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
		,fieldLabel: '<s:message code="plugin.panelControl.letrados.letrados.campanya" text="**Campaña/Plan de acción" />'
		,width:260
		,value:''
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
			width:380,items:[comboNiveles,comboTipoProcedimiento,importeFiltro.panel]
			},{
			width:460,items:[comboLetradoGestor,comboTipoTarea,comboCampanyas]
		}]
	});

 // GRID PANEL DE CONTROL
 var panelControlRecord = Ext.data.Record.create([
         {name:'nivel'}
        ,{name:'userName'}
        ,{name:'idNivel'}
        ,{name:'cod'}
        ,{name:'totalExpedientes',type: 'int'}
        ,{name:'importe',type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'tareasVencidas',type: 'int'}
        ,{name:'tareasPendientesHoy',type: 'int'}
        ,{name:'tareasPendientesSemana',type: 'int'}
        ,{name:'tareasPendientesMes',type: 'int'}
        ,{name:'tareasPendientesMasMes',type: 'int'}
 		,{name:'tareasPendientesMasAnyo',type: 'int'}
 	    ,{name:'tareasFinalizadasAyer',type: 'int'}
 	    ,{name:'tareasFinalizadasSemana',type: 'int'}
 	    ,{name:'tareasFinalizadasMes',type: 'int'}
 	    ,{name:'tareasFinalizadasAnyo',type: 'int'}
 	    ,{name:'tareasFinalizadas',type: 'int'}
  		,{name:'fechaRefresco'}
    ]);

 var panelControlStore = page.getStore({
	  id:'panelControlStore'
	  ,event:'listado'
	  ,storeId : 'panelControlStore'
	  ,flow : 'plugin.panelControl.letrados.datosPorNivel'
	  ,reader : new Ext.data.JsonReader({root:'panelControl'}, panelControlRecord)
 });
 
 var panelControlCm = new Ext.grid.ColumnModel([
		   {dataIndex: 'idNivel', hidden:true, fixed:true,editable:false },
		   {header: 'cod',   dataIndex: 'cod',hidden:true,sortable:true,editable:false},
		   {header: 'userName',   dataIndex: 'userName',hidden:true,sortable:true,editable:false},
           {header: 'N. ', dataIndex: 'nivel',sortable:true,editable:false,width:150},
           {header: 'T.E. ',   dataIndex: 'totalExpedientes',sortable:true,editable:false,renderer:thousandSeparator,align:'right'},
           {header: 'I. ',   dataIndex: 'importe',sortable:true,editable:false,tooltip:'1',renderer:millonSeparator,align:'right'},
           {header: 'T.V. ',   dataIndex: 'tareasVencidas',sortable:true,editable:false,tooltip:'1',renderer:thousandSeparator,align:'right'},
           {header: 'T.P.H. ',   dataIndex: 'tareasPendientesHoy',sortable:true,editable:false,tooltip:'1',renderer:thousandSeparator,align:'right'},
           {header: 'T.P.S. ',   dataIndex: 'tareasPendientesSemana',sortable:true,editable:false,tooltip:'1',renderer:thousandSeparator,align:'right'},
           {header: 'T.P.M. ',   dataIndex: 'tareasPendientesMes',sortable:true,editable:false,tooltip:'1',renderer:thousandSeparator,align:'right'},
           {header: 'T.P.M.M. ',   dataIndex: 'tareasPendientesMasMes',sortable:true,editable:false,tooltip:'1',renderer:thousandSeparator,align:'right'},
           {header: 'T.P.M.A. ',   dataIndex: 'tareasPendientesMasAnyo',sortable:true,editable:false,tooltip:'1',renderer:thousandSeparator,align:'right'},
           {header: 'T.F.Ay. ',   dataIndex: 'tareasFinalizadasAyer',hidden:true,sortable:true,editable:false,tooltip:'1',renderer:thousandSeparator,align:'right'},
           {header: 'T.F.S. ',   dataIndex: 'tareasFinalizadasSemana',hidden:true,sortable:true,editable:false,tooltip:'1',renderer:thousandSeparator,align:'right'},
           {header: 'T.F.M. ',   dataIndex: 'tareasFinalizadasMes',hidden:true,sortable:true,editable:false,tooltip:'1',renderer:thousandSeparator,align:'right'},
           {header: 'T.F.A. ',   dataIndex: 'tareasFinalizadasAnyo',hidden:true,sortable:true,editable:false,tooltip:'1',renderer:thousandSeparator,align:'right'},
           {header: 'T.F.M.A ',   dataIndex: 'tareasFinalizadas',hidden:true,sortable:true,editable:false,tooltip:'1',renderer:thousandSeparator,align:'right'}
 ]); 

  var panelControlGrid= app.crearGrid(panelControlStore,panelControlCm,{
        title:'<s:message code="plugin.panelControl.letrados.titulo" text="**Panel de control de letrados" />'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:400
    });
 
 panelControlGrid.on('cellclick', function(grid, rowIndex,columnIndex, e) {
  	 var recStore=panelControlStore.getAt(rowIndex);
     var idColumnHeader = panelControlCm.getColumnHeader(columnIndex);
     var respuesta;
     switch(idColumnHeader){
      case 'N. ':
       var nivelActual = comboNiveles.getValue();
       var nuevoNivel = nivelActual;
       if(nivelActual == '301')
        nuevoNivel = '302'
       else if(nivelActual == '302')
        nuevoNivel = '303'
       else if(nivelActual == '303')
        nuevoNivel = '304'
       else if(nivelActual == '304')
        nuevoNivel = '305' 
       if(nuevoNivel != nivelActual)
        app.openTab('<s:message code="plugin.panelControl.letrados.titulo" text="**Panel de control de letrados" />' + ': ' + recStore.get('nivel'),'plugin/panelcontrol/letrados/plugin.panelControl.letrados',{nivel:nuevoNivel,idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), detalle:'1',tipoProcedimiento:comboTipoProcedimiento.getValue(),tipoTarea:comboTipoTarea.getValue(),campanya:comboCampanyas.getValue(),letradoGestor:comboLetradoGestor.getValue(),minImporteFiltro:importeFiltro.min.getValue(),maxImporteFiltro:importeFiltro.max.getValue(),statusColumns:getStatusColumns()},{id:recStore.get('idNivel') + recStore.get('nivel')}); 
       break;
      case 'T.E. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.expediente" text="**Expedientes" />'  + ' : ' + recStore.get('nivel')
       ,'plugin.panelControl.letrados.asuntos'
       ,{nivel:comboNiveles.getValue()
       		,idNivel:recStore.get('idNivel')
       		,cod:recStore.get('cod')
       		,nombre:recStore.get('nivel')
       		, detalle:'2'
       		,userName:recStore.get('userName')
       		,totalTareas:recStore.get('totalExpedientes')
       		,tipoProcedimiento:comboTipoProcedimiento.getValue()
       		,tipoTarea:comboTipoTarea.getValue()
       		,campanya:comboCampanyas.getValue()
       		,letradoGestor:comboLetradoGestor.getValue()
       		,minImporteFiltro:importeFiltro.min.getValue()
       		,maxImporteFiltro:importeFiltro.max.getValue()}
       ,{id:recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod')});
       break;
      case 'T.V. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.tareasPendientesVencidas" text="**Tareas vencidas" />' + ': ' + recStore.get('nivel')
       ,'plugin/panelcontrol/letrados/plugin.panelControl.letrados.tareas'
       ,{nivel:comboNiveles.getValue()
       		,idNivel:recStore.get('idNivel')
       		,cod:recStore.get('cod')
       		, nombre:recStore.get('nivel')
       		,detalle:'3'
       		,userName:recStore.get('userName')
       		,totalTareas:recStore.get('tareasVencidas')
       		,tipoProcedimiento:comboTipoProcedimiento.getValue()
       		,tipoTarea:comboTipoTarea.getValue()
       		,campanya:comboCampanyas.getValue()
       		,letradoGestor:comboLetradoGestor.getValue()
       		,minImporteFiltro:importeFiltro.min.getValue()
       		,maxImporteFiltro:importeFiltro.max.getValue()}
      ,{id:idColumnHeader + recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod') + '3'});
       break;
      case 'T.P.H. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.tareasPendientesHoy" text="**Tareas pendientes hoy" />' + ': ' + recStore.get('nivel'),'plugin.panelControl.letrados.tareas',{nivel:comboNiveles.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), nombre:recStore.get('nivel'),detalle:'4',userName:recStore.get('userName'),totalTareas:recStore.get('tareasPendientesHoy'),tipoProcedimiento:comboTipoProcedimiento.getValue(),tipoTarea:comboTipoTarea.getValue(),campanya:comboCampanyas.getValue(),letradoGestor:comboLetradoGestor.getValue(),minImporteFiltro:importeFiltro.min.getValue(),maxImporteFiltro:importeFiltro.max.getValue()},{id:idColumnHeader + recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod') + '4'});
       break;
      case 'T.P.S. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.tareasPendientesSemana" text="**Tareas pendientes semana" />' + ': ' + recStore.get('nivel'),'plugin.panelControl.letrados.tareas',{nivel:comboNiveles.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), nombre:recStore.get('nivel'),detalle:'5',userName:recStore.get('userName'),totalTareas:recStore.get('tareasPendientesSemana'),tipoProcedimiento:comboTipoProcedimiento.getValue(),tipoTarea:comboTipoTarea.getValue(),campanya:comboCampanyas.getValue(),letradoGestor:comboLetradoGestor.getValue(),minImporteFiltro:importeFiltro.min.getValue(),maxImporteFiltro:importeFiltro.max.getValue()},{id:idColumnHeader + recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod')  + '5'});
       break;  
     case 'T.P.M. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.tareasPendientesMes" text="**Tareas pendientes mes" />' + ': ' + recStore.get('nivel'),'plugin.panelControl.letrados.tareas',{nivel:comboNiveles.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), nombre:recStore.get('nivel'),detalle:'6',userName:recStore.get('userName'),totalTareas:recStore.get('tareasPendientesMes'),tipoProcedimiento:comboTipoProcedimiento.getValue(),tipoTarea:comboTipoTarea.getValue(),campanya:comboCampanyas.getValue(),letradoGestor:comboLetradoGestor.getValue(),minImporteFiltro:importeFiltro.min.getValue(),maxImporteFiltro:importeFiltro.max.getValue()},{id:idColumnHeader + recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod') + '6'});
       break;
      case 'T.P.M.M. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.tareasPendientesMasMes" text="**Tareas pendientes más de un mes" />' + ': ' + recStore.get('nivel'),'plugin.panelControl.letrados.tareas',{nivel:comboNiveles.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), nombre:recStore.get('nivel'),detalle:'7',userName:recStore.get('userName'),totalTareas:recStore.get('tareasPendientesMasMes'),tipoProcedimiento:comboTipoProcedimiento.getValue(),tipoTarea:comboTipoTarea.getValue(),campanya:comboCampanyas.getValue(),letradoGestor:comboLetradoGestor.getValue(),minImporteFiltro:importeFiltro.min.getValue(),maxImporteFiltro:importeFiltro.max.getValue()},{id:idColumnHeader + recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod') + '7'});
       break;
      case 'T.P.M.A. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.tareasPendientesMasAnyo" text="**Tareas pendientes más de un año" />' + ': ' + recStore.get('nivel'),'plugin.panelControl.letrados.tareas',{nivel:comboNiveles.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), nombre:recStore.get('nivel'),detalle:'8',userName:recStore.get('userName'),totalTareas:recStore.get('tareasPendientesMasAnyo'),tipoProcedimiento:comboTipoProcedimiento.getValue(),tipoTarea:comboTipoTarea.getValue(),campanya:comboCampanyas.getValue(),letradoGestor:comboLetradoGestor.getValue(),minImporteFiltro:importeFiltro.min.getValue(),maxImporteFiltro:importeFiltro.max.getValue()},{id:idColumnHeader + recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod') + '8'});
       break;   
      case 'T.F.Ay. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.tareasFinalizadasAyer" text="**Tareas finalizadas ayer" />' + ': ' + recStore.get('nivel'),'plugin.panelControl.letrados.tareas',{nivel:comboNiveles.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), nombre:recStore.get('nivel'),detalle:'9',userName:recStore.get('userName'),totalTareas:recStore.get('tareasFinalizadasAyer'),tipoProcedimiento:comboTipoProcedimiento.getValue(),tipoTarea:comboTipoTarea.getValue(),campanya:comboCampanyas.getValue(),letradoGestor:comboLetradoGestor.getValue(),minImporteFiltro:importeFiltro.min.getValue(),maxImporteFiltro:importeFiltro.max.getValue()},{id:idColumnHeader + recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod') + '9'});
       break;   
      case 'T.F.S. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.tareasFinalizadasSemana" text="**Tareas finalizadas semana" />' + ': ' + recStore.get('nivel'),'plugin.panelControl.letrados.tareas',{nivel:comboNiveles.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), nombre:recStore.get('nivel'),detalle:'10',userName:recStore.get('userName'),totalTareas:recStore.get('tareasFinalizadasSemana'),tipoProcedimiento:comboTipoProcedimiento.getValue(),tipoTarea:comboTipoTarea.getValue(),campanya:comboCampanyas.getValue(),letradoGestor:comboLetradoGestor.getValue(),minImporteFiltro:importeFiltro.min.getValue(),maxImporteFiltro:importeFiltro.max.getValue()},{id:idColumnHeader + recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod') + '10'});
       break; 
     case 'T.F.M. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.tareasFinalizadasMes" text="**Tareas finalizadas mes" />' + ': ' + recStore.get('nivel'),'plugin.panelControl.letrados.tareas',{nivel:comboNiveles.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), nombre:recStore.get('nivel'),detalle:'11',userName:recStore.get('userName'),totalTareas:recStore.get('tareasFinalizadasMes'),tipoProcedimiento:comboTipoProcedimiento.getValue(),tipoTarea:comboTipoTarea.getValue(),campanya:comboCampanyas.getValue(),letradoGestor:comboLetradoGestor.getValue(),minImporteFiltro:importeFiltro.min.getValue(),maxImporteFiltro:importeFiltro.max.getValue()},{id:idColumnHeader + recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod') + '11'});
       break; 
     case 'T.F.A. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.tareasFinalizadasAnyo" text="**Tareas finalizadas año" />' + ': ' + recStore.get('nivel'),'plugin.panelControl.letrados.tareas',{nivel:comboNiveles.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), nombre:recStore.get('nivel'),detalle:'12',userName:recStore.get('userName'),totalTareas:recStore.get('tareasFinalizadasAnyo'),tipoProcedimiento:comboTipoProcedimiento.getValue(),tipoTarea:comboTipoTarea.getValue(),campanya:comboCampanyas.getValue(),letradoGestor:comboLetradoGestor.getValue(),minImporteFiltro:importeFiltro.min.getValue(),maxImporteFiltro:importeFiltro.max.getValue()},{id:idColumnHeader + recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod') + '12'});
       break; 
     case 'T.T.F. ':
       app.openTab('<s:message code="plugin.panelControl.letrados.tareasFinalizadas" text="**Tareas finalizadas" />' + ': ' + recStore.get('nivel'),'plugin.panelControl.letrados.tareas',{nivel:comboNiveles.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), nombre:recStore.get('nivel'),detalle:'13',userName:recStore.get('userName'),totalTareas:recStore.get('tareasFinalizadas'),tipoProcedimiento:comboTipoProcedimiento.getValue(),tipoTarea:comboTipoTarea.getValue(),campanya:comboCampanyas.getValue(),letradoGestor:comboLetradoGestor.getValue(),minImporteFiltro:importeFiltro.min.getValue(),maxImporteFiltro:importeFiltro.max.getValue()},{id:idColumnHeader + recStore.get('idNivel') + recStore.get('nivel') + recStore.get('cod') + '13'});
       break; 
      default:
     }
 });

	var getParametros = function() {
		return {
			nivel:comboNiveles.getValue()
			,idNivel:${idNivel}
			,cod:'${cod}'
			,tipoProcedimiento:comboTipoProcedimiento.getValue()
			,tipoTarea:comboTipoTarea.getValue()
			,letradoGestor:comboLetradoGestor.getValue()
			,campanya:comboCampanyas.getValue()
			,minImporteFiltro:importeFiltro.min.getValue()
			,maxImporteFiltro:importeFiltro.max.getValue()
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
				flitrosPlegables.collapse(true);
				panelControlStore.webflow(getParametros());
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
		panelControlStore.webflow({nivel:'0', idNivel:'0',cod:'0',tipoProcedimiento:'',tipoTarea:'',letradoGestor:'',campanya:'',minImporteFiltro:'',maxImporteFiltro:''});
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
			        params='nivel='+ comboNiveles.getValue() + '&idNivel=' + '${idNivel}' + '&cod=' + '${cod}' + '&tipoProcedimiento=' + comboTipoProcedimiento.getValue() + '&tipoTarea=' + comboTipoTarea.getValue() + '&letradoGestor=' + comboLetradoGestor.getValue() + '&campanya=' + comboCampanyas.getValue() + '&minImporteFiltro=' + importeFiltro.min.getValue() + '&maxImporteFiltro=' + importeFiltro.max.getValue();
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
 
 var mainPanel = new Ext.Panel({
     autoWidth:true,
     autoHeight:true,
     border:false,
      bodyStyle: 'padding:5px;border:0',
      layout: 'form',
      items: [{
	      border:false,
	      items: [flitrosPlegables]
	     },{
	      border:false,
	      items:[panelControlGrid]
	     }]
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
  }
  
	var loadFiltros = function() {
		comboNiveles.setValue(${nivel}); 
		comboTipoProcedimiento.setValue('${tipoProcedimiento}');
		if ('${tipoProcedimiento}'!='')
			recargarIdTareaProcedimiento();
		comboTipoTarea.setValue('${tipoTarea}');
		comboLetradoGestor.setValue('${letradoGestor}');
		comboCampanyas.setValue('${campanya}');
		importeFiltro.min.setValue('${minImporteFiltro}')
		importeFiltro.max.setValue('${maxImporteFiltro}')
	};

	var getStatusColumns = function() {
		var statusColumns = '';

		statusColumns += nivel.checked?'1':'0';
		statusColumns += totalExpedientes.checked?'1':'0';
		statusColumns += importe.checked?'1':'0';
		statusColumns += tareasVencidas.checked?'1':'0';
		statusColumns += tareasPendientesHoy.checked?'1':'0';
		statusColumns += tareasPendientesSemana.checked?'1':'0';
		statusColumns += tareasPendientesMes.checked?'1':'0';
		statusColumns += tareasPendientesMasMes.checked?'1':'0';
		statusColumns += tareasPendientesMasAño.checked?'1':'0';
		statusColumns += tareasFinalizadasAyer.checked?'1':'0';
		statusColumns += tareasFinalizadasSemana.checked?'1':'0';
		statusColumns += tareasFinalizadasMes.checked?'1':'0';
		statusColumns += tareasFinalizadasAnyo.checked?'1':'0';
		statusColumns += tareasFinalizadas.checked?'1':'0';
		
		return statusColumns;
	};
	
	var loadColumnas = function() {
			nivel.checked='${statusColumns}'.charAt(0)=="1"?true:false;
			ocultarMostrarColumnas(cNivel,'${statusColumns}'.charAt(0)=="1"?true:false);
			
			totalExpedientes.checked='${statusColumns}'.charAt(1)=="1"?true:false;
			ocultarMostrarColumnas(cTotalExpedientes,'${statusColumns}'.charAt(1)=="1"?true:false);
		
			importe.checked='${statusColumns}'.charAt(2)=="1"?true:false;
			ocultarMostrarColumnas(cImporte,'${statusColumns}'.charAt(2)=="1"?true:false);
			
			tareasVencidas.checked='${statusColumns}'.charAt(3)=="1"?true:false;
			ocultarMostrarColumnas(cTareasVencidas,'${statusColumns}'.charAt(3)=="1"?true:false);
			
			tareasPendientesHoy.checked='${statusColumns}'.charAt(4)=="1"?true:false;
			ocultarMostrarColumnas(cTareasPendientesHoy,'${statusColumns}'.charAt(4)=="1"?true:false);
			
			tareasPendientesSemana.checked='${statusColumns}'.charAt(5)=="1"?true:false;
			ocultarMostrarColumnas(cTareasPendientesSemana,'${statusColumns}'.charAt(5)=="1"?true:false);
			
			tareasPendientesMes.checked='${statusColumns}'.charAt(6)=="1"?true:false;
			ocultarMostrarColumnas(cTareasPendientesMes,'${statusColumns}'.charAt(6)=="1"?true:false);
			
			tareasPendientesMasMes.checked='${statusColumns}'.charAt(7)=="1"?true:false;
			ocultarMostrarColumnas(cTareasPendientesMasMes,'${statusColumns}'.charAt(7)=="1"?true:false);
			
			tareasPendientesMasAño.checked='${statusColumns}'.charAt(8)=="1"?true:false;
			ocultarMostrarColumnas(cTareasPendientesMasAño,'${statusColumns}'.charAt(8)=="1"?true:false);
			
			tareasFinalizadasAyer.checked='${statusColumns}'.charAt(9)=="1"?true:false;
			ocultarMostrarColumnas(cTareasFinalizadasAyer,'${statusColumns}'.charAt(9)=="1"?true:false);
			
			tareasFinalizadasSemana.checked='${statusColumns}'.charAt(10)=="1"?true:false;
			ocultarMostrarColumnas(cTareasFinalizadasSemana,'${statusColumns}'.charAt(10)=="1"?true:false);
			
			tareasFinalizadasMes.checked='${statusColumns}'.charAt(11)=="1"?true:false;
			ocultarMostrarColumnas(cTareasFinalizadasMes,'${statusColumns}'.charAt(11)=="1"?true:false);
			
			tareasFinalizadasAnyo.checked='${statusColumns}'.charAt(12)=="1"?true:false;
			ocultarMostrarColumnas(cTareasFinalizadasAnyo,'${statusColumns}'.charAt(12)=="1"?true:false);
			
			tareasFinalizadas.checked='${statusColumns}'.charAt(13)=="1"?true:false;
			ocultarMostrarColumnas(cTareasFinalizadas,'${statusColumns}'.charAt(13)=="1"?true:false);
	};


	Ext.onReady(function(){
		obtenerFechaRefresco();
		storeCampanya.webflow();
		storeLetradoGestor.webflow();
		if (${nivel}==0){
			comboNiveles.setValue('---'); 
		}else{
			loadFiltros();
			loadColumnas();
		}
	
		buscarFunc();
	});

</fwk:page>
