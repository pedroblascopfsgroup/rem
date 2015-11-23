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
	var clienteRecord = Ext.data.Record.create([
        {name:'id'}
        ,{name:'nombre', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name:'apellido1', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name:'apellido2', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name:'gestion', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name:'segmento', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name:'saldoVencido',type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'riesgoTotal',type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'riesgoDirecto',type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'contratos', sortType:Ext.data.SortTypes.asInt}
        ,{name:'diasVencido', sortType:Ext.data.SortTypes.asInt}
        ,{name:'situacion', type:'string', sortType:Ext.data.SortTypes.asText}
        ,{name:'situacionFinanciera', type:'string', sortType:Ext.data.SortTypes.asText}
        
    ]);
    
	<%-- 
	
	var myData = [
    ['1','TODOPADEL S.A.','','','','PROMOTOR (Unnim)','343.561,56','5.513.367','3.788.490,20','9','344','Normal','NORMAL'],
    ['2','ACADEMIA INTERNACIONAL','','','','EMPRESA (Unnim)','9.346.50','0','3.685','3','2577','Normal','NORMAL'],
    ['3','FABRICAS REVENAQUEA S.A.','','','','EMPRESA (Unnim)','854.454,4','4.545.367','5.548.490,20','9','1355','Normal','NORMAL'],
    ['4','INDUOVO S.L','','','','EMPRESA (Unnim)','356.561,56','4.557.367','6.222,0','11','1110','Normal','NORMAL'],
    ['5','GARCIA CADENA S.A.','','','','EMPRESA (Unnim)','343.561,56','5.513.367','3.788.490,20','19','1462','Normal','NORMAL']
];
	var clienteStore = new Ext.data.ArrayStore({
		id:'clienteStore'
		,storeId : 'clienteStore'
		,fields:[
        {name:'id'}
          ,{name:'nombre'}
        ,{name:'apellido1'}
        ,{name:'apellido2'}
        ,{name:'gestion'}
        ,{name:'segmento'}
        ,{name:'saldoVencido'}
        ,{name:'riesgoTotal'}
        ,{name:'riesgoDirecto'}
        ,{name:'contratos'}
        ,{name:'diasVencido'}
        ,{name:'situacion'}
        ,{name:'situacionFinanciera'}
        
    ]
	});
	--%>
	  var clienteStore = page.getStore({
		id:'clienteStore'
		,eventName:'listado'
		,limit:25
		,remoteSort : true
		,storeId : 'clienteStore'
		,flow : 'plugin.panelControl.clientesData'
		,reader : new Ext.data.JsonReader({root:'cliente',totalProperty : 'total'}, clienteRecord)
	});
	 
	var clienteCm = new Ext.grid.ColumnModel([
			{dataIndex: 'id', hidden:true, fixed:true },
            {header: '<s:message code="plugin.panelControl.clientes.nombre" text="**Nombre" />',   	dataIndex: 'nombre'},
            {header: '<s:message code="plugin.panelControl.clientes.apellido1" text="**Primer apellido" />',   	dataIndex: 'apellido1'},
            {header: '<s:message code="plugin.panelControl.clientes.apellido2" text="**Segundo apellido" />',   	dataIndex: 'apellido2'},
            {header: '<s:message code="plugin.panelControl.clientes.gestion" text="**Gestión" />',  	dataIndex: 'gestion'},
            {header: '<s:message code="plugin.panelControl.clientes.segmento" text="**Segmento" />',   			dataIndex: 'segmento'},
            {header: '<s:message code="plugin.panelControl.clientes.saldoVencido" text="**Saldo vencido" />',   			dataIndex: 'saldoVencido',renderer:millonSeparator,align:'right'},
            {header: '<s:message code="plugin.panelControl.clientes.riesgoTotal" text="**Riesgo total" />',   		dataIndex: 'riesgoTotal',renderer:millonSeparator,align:'right'},
            {header: '<s:message code="plugin.panelControl.clientes.riesgoDirecto" text="**Riesgo directo" />',   		dataIndex: 'riesgoDirecto',renderer:millonSeparator,align:'right'},
            {header: '<s:message code="plugin.panelControl.clientes.contratos" text="**Contratos" />',   		dataIndex: 'contratos',renderer:thousandSeparator,align:'right'},
            {header: '<s:message code="plugin.panelControl.clientes.diasVencido" text="**Dias vencido" />',   			dataIndex: 'diasVencido',renderer:thousandSeparator,align:'right'},
            {header: '<s:message code="plugin.panelControl.clientes.situacion" text="**Situación" />',   		dataIndex: 'situacion'},
            {header: '<s:message code="plugin.panelControl.clientes.situacionFinanciera" text="**Situación financiera" />',   		dataIndex: 'situacionFinanciera'}
            
	]); 
	 var pagingBar=fwk.ux.getPaging(clienteStore);
	 var clienteGrid=app.crearGrid(clienteStore,clienteCm,{
        title:'<s:message code="plugin.panelControl.clientes.titulo" text="**Listado clientes" />'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:500
        ,id:'gridClientes'
        ,bbar : [  pagingBar ]
        
    });
	
	
	
	var panelCliente = new Ext.Panel({
		id:'panelCliente',
        labelWidth: 50,
    	autoWidth:true,
    	autoHeight:true,
    	//height:900,
    	border:false,
        bodyStyle: 'padding:5px;',
        layout: 'column',
        items: [{
        			border:false,
    				items: [clienteGrid]
   				}
   			   ]
    });
    
    
    
    
	page.add(panelCliente);
	
	Ext.onReady(function(){
		  clienteStore.webflow({nivel:${nivel}, idNivel:${idNivel}, cod:'${cod}'});
	});
	
</fwk:page>



