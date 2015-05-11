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
	var contratoRecord = Ext.data.Record.create([
        {name:'codigoContrato'}
        ,{name:'diasIrregular'}
        ,{name:'estadoContrato'}
        ,{name:'estadoFinanciero'}
        ,{name:'id'}
        ,{name:'riesgo',type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'saldoVencido',type: 'float', sortType:Ext.data.SortTypes.asFloat}
        ,{name:'situacion'}
        ,{name:'tipoProducto'}
        ,{name:'titular'}
        
    ]);
    
    var contratoStore = page.getStore({
		id:'contratoStore'
		,eventName:'listado'
		,limit:25
		,remoteSort : true
		,storeId : 'contratoStore'
		,flow : 'plugin.panelControl.contratosData'
		,reader : new Ext.data.JsonReader({root:'contrato',totalProperty : 'total'}, contratoRecord)
	});
	
	
	var contratoCm = new Ext.grid.ColumnModel([
			{dataIndex: 'id', hidden:true, fixed:true },
            {header: '<s:message code="plugin.panelControl.contratos.codigo" text="**Código" />',   	dataIndex: 'codigoContrato'},
            {header: '<s:message code="plugin.panelControl.contratos.diasIrregular" text="**Días irregular" />',   	dataIndex: 'diasIrregular',align:'right',renderer:thousandSeparator},
            {header: '<s:message code="plugin.panelControl.contratos.estado" text="**Estado contrato" />',   	dataIndex: 'estadoContrato'},
            {header: '<s:message code="plugin.panelControl.contratos.estadoFinanciero" text="**Estado financiero" />',  	dataIndex: 'estadoFinanciero'},
            {header: '<s:message code="plugin.panelControl.contratos.riesgo" text="**Riesgo" />',   			dataIndex: 'riesgo',renderer:millonSeparator,align:'right'},
            {header: '<s:message code="plugin.panelControl.contratos.saldoVencido" text="**Saldo vencido" />',   		dataIndex: 'saldoVencido',renderer:millonSeparator,align:'right'},
            {header: '<s:message code="plugin.panelControl.contratos.situacion" text="**Situación" />',   		dataIndex: 'situacion'},
            {header: '<s:message code="plugin.panelControl.contratos.tipoProducto" text="**Tipo producto" />',   		dataIndex: 'tipoProducto'},
            {header: '<s:message code="plugin.panelControl.contratos.titular" text="**Titular" />',   			dataIndex: 'titular'}
            
	]); 
	var pagingBar=fwk.ux.getPaging(contratoStore);
	 var contratoGrid=app.crearGrid(contratoStore,contratoCm,{
        title:'<s:message code="plugin.panelControl.contratos.titulo" text="**Listado de contratos" />'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:500
        ,id:'gridContrato'
        ,border:false
        ,bbar : [  pagingBar ]
        
    });
	
	
	
	var panelContrato = new Ext.Panel({
		id:'panelContrato',
        labelWidth: 50,
    	autoWidth:true,
    	autoHeight:true,
    	border:false,
    	//height:900,
        bodyStyle: 'padding:5px;',
        layout: 'column',
        items: [{
        			border:false,
    				items: [contratoGrid]
   				}
   			   ]
    });
    
    
    
    
	page.add(panelContrato);
	
	Ext.onReady(function(){
		 contratoStore.webflow({nivel:${nivel}, idNivel:${idNivel}, cod:'${cod}',detalle:${detalle} });
	});
	
</fwk:page>



