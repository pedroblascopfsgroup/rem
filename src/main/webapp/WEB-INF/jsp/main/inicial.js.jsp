<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
function renderPercent(value,p,r){
			var value = ((r.data['saldoVencido']*100 / r.data['saldoTotal']));
			if (isNaN(value)) return "";
         return String.format("{0}%",value.toFixed(2));
}
var data = {
		 actual : [
		    {situacion:'Menos de 15	',nroClientes:'3',nroContratos:'4',saldoVencido:'1280',saldoTotal:'5000'}, 
			{situacion:'Entre 15 y 30' ,nroClientes:'4',nroContratos:'4',saldoVencido:'3575',saldoTotal:'4050'}, 
			{situacion:'Entre 30 y 60' ,nroClientes:'5',nroContratos:'4',saldoVencido:'1343',saldoTotal:'10500'}, 
			{situacion:'Mas de 60    ' ,nroClientes:'3',nroContratos:'4',saldoVencido:'30',saldoTotal:'100'}, 
			{situacion:'Expediente   ' ,nroClientes:'10',nroContratos:'4',saldoVencido:'30',saldoTotal:'100'}
            ]
         ,diaAnterior : [
 		    {nroClientes:'5',nroContratos:'14',saldoVencido:'2280',saldoTotal:'6000'}, 
			{nroClientes:'2',nroContratos:'1',saldoVencido:'1575',saldoTotal:'4050'}, 
			{nroClientes:'1',nroContratos:'2',saldoVencido:'2343',saldoTotal:'10500'}, 
			{nroClientes:'4',nroContratos:'2',saldoVencido:'30',saldoTotal:'100'}, 
			{nroClientes:'10',nroContratos:'3',saldoVencido:'60',saldoTotal:'100'}
            ] 
};

var datosInterna ={
		actual :[                 
		     {situacion:'Revision'	,nroClientes:'12',nroContratos:'20',saldoVencido:'30',saldoTotal:'100'},     
		     {situacion:'Comite'   ,nroClientes:'5',nroContratos:'6',saldoVencido:'654',saldoTotal:'2500'}         
	         ]
	    ,diaAnterior : [
			{nroClientes:'12',nroContratos:'20',saldoVencido:'30',saldoTotal:'100'},     
			{nroClientes:'5',nroContratos:'6',saldoVencido:'654',saldoTotal:'2500'}
	         ]
};

                               
var datosExterna = {
	actual : [                 
		{situacion:'Amistosa'	,nroClientes:'3',nroContratos:'4',saldoVencido:'30',saldoTotal:'100'},     
		{situacion:'Soc. Cobro' ,nroClientes:'3',nroContratos:'4',saldoVencido:'30',saldoTotal:'100'},    
		{situacion:'Judicial'   ,nroClientes:'3',nroContratos:'4',saldoVencido:'30',saldoTotal:'100'}       
	]
	,diaAnterior : [
        {nroClientes:'3',nroContratos:'4',saldoVencido:'30',saldoTotal:'100'},     
        {nroClientes:'3',nroContratos:'4',saldoVencido:'30',saldoTotal:'100'},    
        {nroClientes:'3',nroContratos:'4',saldoVencido:'30',saldoTotal:'100'}       
    ]
};

var datosNormal ={
		actual : [
		       {situacion:'Venc. Sin Gestion'	,nroClientes:'3',nroContratos:'4',saldoVencido:'30',saldoTotal:'100'},
		       {situacion:'No Vencidos'        ,nroClientes:'3',nroContratos:'4',saldoVencido:'30',saldoTotal:'100'}
		 ]
		 ,diaAnterior : [
                 {nroClientes:'3',nroContratos:'4',saldoVencido:'30',saldoTotal:'100'},
	             {nroClientes:'3',nroContratos:'4',saldoVencido:'30',saldoTotal:'100' }
	      ]
};

var reader = new Ext.data.ArrayReader({}, [
  {name: 'situacion'},
 		{name: 'nroClientes'},
       {name: 'nroContratos'},
       {name: 'saldoVencido', type: 'float'},
       {name: 'saldoTotal', type: 'float'},
       {name: 'porcentaje'}
    ]);


function createStore(data){
	return new Ext.data.JsonStore({
		fields : [
				 'situacion'
	 		 	,'nroClientes'
	        	,'nroContratos'
	       		,'saldoVencido'
	        	,'saldoTotal'
	        	,'porcentaje'
	        ]
		,data : data
	})
}
function createGrid(title,store,headers){
	return new Ext.grid.GridPanel({
		title:title	
		//,frame:true
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,hideHeaders:headers
		,cm : new Ext.grid.ColumnModel([
		       {header: "Situacion", width: 120, sortable: true, dataIndex: 'situacion'},
		       {header: "Nro. Clientes", width: 120, sortable: true, dataIndex: 'nroClientes'},
	           {header: "Nro. Contratos", width: 120, sortable: true, dataIndex: 'nroContratos'},
	           {header: "Saldo Vencido", width: 120, sortable: true, dataIndex: 'saldoVencido'},
	           {header: "Saldo Total", width: 120, sortable: true, dataIndex: 'saldoTotal'},
	           {header: "% sobre Total", width: 120, sortable: true, renderer:renderPercent,dataIndex: 'saldoTotal'}
		 ])
	     ,store: store
	     //,viewConfig : {autoFill: true}
	     ,autoHeight : true
	     ,monitorResize: true
	     ,doLayout: function() {
			var parentSize = Ext.get(this.getEl().dom.parentNode).getSize(true); 
	     	this.setWidth(parentSize.width);
	     	Ext.grid.GridPanel.prototype.doLayout.call(this);
	     }
	});
};


var gridGestionPrimaria = createGrid('Gestion Primaria',createStore(data.actual),false);
var gridGestionInterna = createGrid('Gestion Interna',createStore(datosInterna.actual),true);
var gridGestionExterna = createGrid('Gestion Externa',createStore(datosExterna.actual),true);
var gridGestionNormal = createGrid('Gestion Normal',createStore(datosNormal.actual),true);

var comboEstados = new Ext.form.ComboBox({
    store: [
            ['actual',  '<s:message code="inicial.comparativa.sinComparacion" text="**No comparar" />' ]
            ,['diaAnterior', '<s:message code="inicial.comparativa.diaAnterior" text="**diaAnterior" />' ]
            ]
    ,displayField:'descripcion'
    ,mode: 'local'
    ,triggerAction: 'all'
    ,emptyText:'----'
    ,valueField: 'codigo'
    ,editable : false
    ,value : 'actual'
});


/**
 * compara los datos de data[actual] con los de data[comparacion]
 */
var datosComparados = function(grid, data, comparacion){
	var store = grid.getStore();
	for(var i=1;i< store.fields.length-1;i++){
		for(var j=0;j< store.data.length;j++){
			var value = data.actual[j][store.fields.get(i).name];
			try{
				if (comparacion){
					value = parseInt(value);
					var compValue = parseInt(data[comparacion][j][store.fields.get(i).name]);
					var diff = (value!=compValue)?  "(&nbsp;" + ((value-compValue)>0? "+":"")+(value-compValue) + "&nbsp;)" : "";
					value= value+ "&nbsp;&nbsp; <span style='color:#866'>"+compValue + "&nbsp;"+diff+"</span>";
				}
			}catch(e){}
			store.data.get(j).set(store.fields.get(i).name, value);
		}
	}
};


comboEstados.on('select', function(combo){
	
	var value = combo.getValue();
	var grids = [gridGestionPrimaria, gridGestionInterna, gridGestionExterna, gridGestionNormal];
	var datos = [data, datosInterna, datosExterna, datosNormal ];
	
	for(var i=0;i < grids.length;i++){
		if (value=='actual'){
			datosComparados(grids[i], datos[i]);
		}else{
			datosComparados(grids[i], datos[i], value);
		}
		grids[i].getStore().commitChanges();
		//grids[i].getView().refresh();
	}
	
	for(var i=0, n=data.length;i< n;i++){
		data.get(i).data.nroClientes = data.get(i).data.nroClientes.replace(/,.*$/,"")  + ", <span style='color:red'>"+(parseInt(data.get(i).data.nroClientes)+1)+"</span>"; 
	}

})


var panel = new Ext.Panel({
	items : [
	         comboEstados
			,gridGestionPrimaria
			,gridGestionInterna 
			,gridGestionExterna 
			,gridGestionNormal
	]
	,autoHeight : true
	,bodyStyle : 'padding:20px'
});
page.add(panel);



</fwk:page>