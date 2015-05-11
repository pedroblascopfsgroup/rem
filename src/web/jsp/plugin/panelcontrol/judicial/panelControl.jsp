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
	var  leyenda1 = new Ext.ux.form.StaticTextField({
          fieldLabel: 'N. ',
          labelStyle:'font-weight:bolder;width:50px;padding-left:40px',
          value:'<s:message code="plugin.panelControl.nivel" text="**Nivel" />'
	});
	var  leyenda2 = new Ext.ux.form.StaticTextField({
          fieldLabel: 'C. ',
          labelStyle:'font-weight:bolder;width:50px;padding-left:40px',
          value:'<s:message code="plugin.panelControl.clientes" text="**Clientes" />'
	});
	var  leyenda3 = new Ext.ux.form.StaticTextField({
          fieldLabel: 'C.T. ',
          labelStyle:'font-weight:bolder;width:50px;padding-left:40px',
          value:'<s:message code="plugin.panelControl.contratosTotales" text="**Contrato totales" />'
	});
	var  leyenda4 = new Ext.ux.form.StaticTextField({
          fieldLabel: 'C.I. ',
          labelStyle:'font-weight:bolder;width:50px;padding-left:40px',
          value:'<s:message code="plugin.panelControl.contratosIrregulares" text="**Contratos irregulares" />'
	});
	var  leyenda5 = new Ext.ux.form.StaticTextField({
          fieldLabel: 'S.V. ',
          labelStyle:'font-weight:bolder;width:50px;padding-left:40px',
          value:'<s:message code="plugin.panelControl.saldoVencido" text="**Saldo vencido" />'
	});
	var  leyenda6 = new Ext.ux.form.StaticTextField({
          fieldLabel: 'S.N.V. ',
          labelStyle:'font-weight:bolder;width:50px;padding-left:40px',
          value:'<s:message code="plugin.panelControl.saldoNoVencido" text="**Saldo no vencido" />'
	});
	var  leyenda7 = new Ext.ux.form.StaticTextField({
          fieldLabel: 'S.N.V.D ',
          labelStyle:'font-weight:bolder;width:50px;padding-left:40px',
          value:'<s:message code="plugin.panelControl.saldoNoVencidoDanyado" text="**Saldo no vencido dañado" />'
	});
	var  leyenda8 = new Ext.ux.form.StaticTextField({
          fieldLabel: 'T.P.V. ',
          labelStyle:'font-weight:bolder;width:50px;padding-left:40px',
          value:'<s:message code="plugin.panelControl.tareasPendientesVencidas" text="**Tareas pendientes vencidas" />'
	});
	var  leyenda9 = new Ext.ux.form.StaticTextField({
          fieldLabel: 'T.P.H. ',
          labelStyle:'font-weight:bolder;width:50px;padding-left:40px',
          value:'<s:message code="plugin.panelControl.tareasPendientesHoy" text="**Tareas pendientes hoy" />'
	});
	var  leyenda10 = new Ext.ux.form.StaticTextField({
          fieldLabel: 'T.P.S. ',
          labelStyle:'font-weight:bolder;width:50px;padding-left:40px',
          value:'<s:message code="plugin.panelControl.tareasPendientesSemana" text="**Tareas pendientes semana" />'
	});
	var  leyenda11 = new Ext.ux.form.StaticTextField({
          fieldLabel: 'T.P.M. ',
          labelStyle:'font-weight:bolder;width:50px;padding-left:40px',
          value:'<s:message code="plugin.panelControl.tareasPendientesMes" text="**Tareas pendientes mes" />'
	});
	
	var leyenda = new Ext.Panel({
		id:'leyenda'
		,autoHeight:true
 		,border:false
		,layout : 'column'
		,defaults : {xtype : 'fieldset', autoHeight : true, border : false,style:'padding:0px'}
		,items : [{
		     items:[leyenda1,leyenda2]
		    },{
		     items:[leyenda3,leyenda4]
		    },{
		     items:[leyenda5,leyenda6]
		    },{
		     items:[leyenda7,leyenda8]
		    },{
		     items:[leyenda9,leyenda10]
		    },{
		     items:[leyenda11]
		    }
		     ]
	});	
	
	var ditcNiveles = <app:dict value="${niveles}" />;
	
	
	var storeNiveles = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,data : ditcNiveles
	       ,root: 'diccionario'
	});
	
	
	var comboNiveles = new Ext.form.ComboBox({
		  name: 'comboNiveles',
		  fieldLabel: '<s:message code="plugin.panelControl.jerarquia" text="**Jerarquía" />',
		  title: '<s:message code="plugin.panelControl.jerarquia" text="**Jerarquía" />',
		  mode: 'local',
		  store: storeNiveles,
		  displayField:'descripcion',
		  valueField:'codigo',
		  triggerAction: 'all',
		  labelStyle:'width:100px',
		  width: 180
	});	
	
	var comboNivelesHidden = new Ext.form.Hidden({
		 name: 'comboNivelesHidden',
		 value:${nivel}
	
	});
	
	//comboNiveles.setValue(${nivel}); 
	comboNivelesHidden.setValue(${nivel}); 
	comboNiveles.on('select',function(combo,record,index){
		comboNivelesHidden.setValue(combo.getValue()); 
		if(combo.getValue() == '4'){
			panelControlStore.webflow({nivel:combo.getValue(), idNivel:'0', subConsulta:'false'});
		}
		else{
			Ext.Msg.alert('<s:message code="plugin.panelControl.aviso" text="**Aviso" />', '<s:message code="plugin.panelControl.mensajeNoImpl" text="**" />');
		}
	});
	
	var panelCombo = new Ext.FormPanel({
	    bodyStyle:'padding:5px',
        autoWidth: true,
		border:false,
        layout: 'column',
		items:[{
				border:false,
				items: [comboNiveles]  
            }
        ]
	});
	
	// GRID INTERVINIENTES
	var panelControlRecord = Ext.data.Record.create([
        {name:'nivel'}
        ,{name:'idNivel'}
         ,{name:'cod',type:'string'}
         ,{name:'ofiCodigo',type:'string'}
        ,{name:'clientes',type: 'int'}
        ,{name:'contratosTotal',type: 'int'}
        ,{name:'contratosIrregulares',type: 'int'}
        ,{name:'saldoVencido',type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'saldoNoVencido',type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'saldoNoVencidoDanyado',type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'tareasPendientesVencidas',type: 'int'}
        ,{name:'tareasPendientesHoy',type: 'int'}
        ,{name:'tareasPendientesSemana',type: 'int'}
        ,{name:'tareasPendientesMes',type: 'int'}
        
    ]);
    
    var panelControlStore = page.getStore({
		id:'panelControlStore'
		,event:'listado'
		,storeId : 'panelControlStore'
		,flow : 'plugin.panelControl.datosPorNivel'
		,reader : new Ext.data.JsonReader({root:'panelControl'}, panelControlRecord)
	});
	 
						
	 
	var panelControlCm = new Ext.grid.ColumnModel([
			{dataIndex: 'idNivel', hidden:true, fixed:true,editable:false },
			{header: 'Cod',   	dataIndex: 'cod',						hidden:true,sortable:false,editable:false},
			{header: 'Código',   	dataIndex: 'ofiCodigo',						hidden:false,sortable:false,editable:false},
            {header: 'N.',   	dataIndex: 'nivel',						sortable:false,editable:false,tooltip:'<s:message code="plugin.panelControl.nivel" text="**Nivel" />',width:150},											
            {header: 'C.',   	dataIndex: 'clientes',					sortable:false,editable:false,tooltip:'<s:message code="plugin.panelControl.clientes" text="**Clientes" />',									renderer:thousandSeparator,			align:'right'},
            {header: 'C.T.',   	dataIndex: 'contratosTotal',			sortable:false,editable:false,tooltip:'<s:message code="plugin.panelControl.contratosTotales" text="**Contratos totales" />',					renderer:thousandSeparator,			align:'right'},
            {header: 'C.I.', 	dataIndex: 'contratosIrregulares',		sortable:false,editable:false,tooltip:'<s:message code="plugin.panelControl.contratosIrregulares" text="**Contratos irregulares" />',			renderer:thousandSeparator,			align:'right'},
            {header: 'S.V.',   	dataIndex: 'saldoVencido',				sortable:false,editable:false,tooltip:'<s:message code="plugin.panelControl.saldoVencido" text="**Saldo vencido" />',							renderer:millonSeparator,			align:'right'},
            {header: 'S.N.V.',  dataIndex: 'saldoNoVencido',			sortable:false,editable:false,tooltip:'<s:message code="plugin.panelControl.saldoNoVencido" text="**Saldo no vencido" />',						renderer:millonSeparator,			align:'right'},
            {header: 'S.N.V.D.',dataIndex: 'saldoNoVencidoDanyado',		sortable:false,editable:false,tooltip:'<s:message code="plugin.panelControl.saldoNoVencidoDanyado" text="**Saldo no vencido dañado" />',		renderer:millonSeparator,			align:'right'},
            {header: 'T.P.V.',	dataIndex: 'tareasPendientesVencidas',	sortable:false,editable:false,tooltip:'<s:message code="plugin.panelControl.tareasPendientesVencidas" text="**Tareas pendientes vencidas" />',	renderer:thousandSeparator,			align:'right'},
            {header: 'T.P.H.',dataIndex: 'tareasPendientesHoy',		sortable:false,editable:false,tooltip:'<s:message code="plugin.panelControl.tareasPendientesHoy" text="**Tareas pendientes hoy" />',			renderer:thousandSeparator,			align:'right'},
            {header: 'T.P.S.',dataIndex: 'tareasPendientesSemana',	sortable:false,editable:false,tooltip:'<s:message code="plugin.panelControl.tareasPendientesSemana" text="**Tareas pendientes semana" />',		renderer:thousandSeparator,			align:'right'},
            {header: 'T.P.M.',dataIndex: 'tareasPendientesMes',		sortable:false,editable:false,tooltip:'<s:message code="plugin.panelControl.tareasPendientesMes" text="**Tareas pendientes mes" />',			renderer:thousandSeparator,			align:'right'}
            
	]); 
	
	 var penelControlGrid=app.crearGrid(panelControlStore,panelControlCm,{
        title:'<s:message code="plugin.panelControl.titulo" text="**Panel de control" />'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:400
    });
	
	
	

	penelControlGrid.on('cellclick', function(grid, rowIndex,columnIndex, e) {
		var recStore=panelControlStore.getAt(rowIndex);
	    var idColumnHeader = panelControlCm.getColumnHeader(columnIndex);
	    switch(idColumnHeader){
	    	case 'N.':
	    		var nivelActual = comboNiveles.getValue();
	    		var nuevoNivel = nivelActual;
	    		if(nivelActual == '1')
	    			nuevoNivel = '3'
	    		else if(nivelActual == '3')
	    			nuevoNivel = '4'
	    		else if(nivelActual == '4')
	    			nuevoNivel = '5'
	    		//else if(nivelActual == '5')
	    		//	nuevoNivel = '2'
	    		
	    		if(nuevoNivel != nivelActual){
	    			
	    			app.openTab('<s:message code="plugin.panelControl.titulo" text="**Panel de control" />','plugin/panelcontrol/plugin.panelControl',{nivel:nuevoNivel,idNivel:recStore.get('idNivel'), cod:recStore.get('cod'),subConsulta:'true'},{});
	    		
	    		}	
	    					
	    		break;
	    	case 'C.':
	    		app.openTab('<s:message code="plugin.panelControl.clientes" text="**Clientes" />','plugin.panelControl.clientes',{nivel:comboNivelesHidden.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), detalle:'2'},{});
	    		break;
	    	case 'C.T.':
	    		app.openTab('<s:message code="plugin.panelControl.contratosTotales" text="**Contratos totales" />','plugin.panelControl.contratos',{nivel:comboNivelesHidden.getValue(),idNivel:recStore.get('idNivel'), detalle:'3'},{});
	    		break;
	    	case 'C.I.':
	    		app.openTab('<s:message code="plugin.panelControl.contratosIrregulares" text="**Contratos irregulares" />','plugin.panelControl.contratos',{nivel:comboNivelesHidden.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'),detalle:'4'},{});
	    		break;	
	    	case 'T.P.V.':
	    		app.openTab('<s:message code="plugin.panelControl.tareasPendientesVencidas" text="**Tareas pendientes vencidas" />','plugin.panelControl.tareasPendientes',{nivel:comboNivelesHidden.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), detalle:'8'},{});
	    		break;
	    	case 'T.P.H.':
	    		app.openTab('<s:message code="plugin.panelControl.tareasPendientesHoy" text="**Tareas pendientes hoy" />','plugin.panelControl.tareasPendientes',{nivel:comboNivelesHidden.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), detalle:'9'},{});
	    		break;
	    	case 'T.P.S.':
	    		app.openTab('<s:message code="plugin.panelControl.tareasPendientesSemana" text="**Tareas pendientes semana" />','plugin.panelControl.tareasPendientes',{nivel:comboNivelesHidden.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), detalle:'10'},{});
	    		break;
	    	case 'T.P.M.':
	    		app.openTab('<s:message code="plugin.panelControl.tareasPendientesMes" text="**Tareas pendientes mes" />','plugin.panelControl.tareasPendientes',{nivel:comboNivelesHidden.getValue(),idNivel:recStore.get('idNivel'),cod:recStore.get('cod'), detalle:'11'},{});
	    		break;
	    					
	    	default:
	    
	    }
	    
	});
	var mainPanel = new Ext.Panel({
        labelWidth: 50,
    	autoWidth:true,
    	autoHeight:true,
    	border:false,
        bodyStyle: 'padding:5px;border:0',
        layout: 'form',
        items: [{
        			layout:'form',
        			bodyStyle:'padding: 5px',
   					border:false,
    				items: [panelCombo]
   				},
   				{
   					bodyStyle:'padding: 5px',
   					border:false,
   					items:[leyenda]
   				},
   				{
   					bodyStyle:'padding: 5px',
   					border:false,
   					items:[penelControlGrid]
   				}
   				]
    });
    
    
    
	page.add(mainPanel);
	
	Ext.onReady(function(){
		 if(${nivel} != '0'){
		 	
			panelControlStore.webflow({nivel:${nivel}, idNivel:${idNivel},cod:'${cod}',subConsulta:'true'});
		 }
	});
	
</fwk:page>



