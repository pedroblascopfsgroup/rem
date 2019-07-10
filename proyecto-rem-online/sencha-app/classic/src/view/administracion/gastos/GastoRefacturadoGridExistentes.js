Ext.define('HreRem.view.administracion.gastos.GastoRefacturadoGridExistentes', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'gastoRefacturadoGridExistentes',
	topBar		: true,
	editOnSelect: false,
	disabledDeleteBtn: false,
	removeButton: true,
	targetGrid	: 'gastoRefacturadoGridExistentes',
	idPrincipal : 'numeroDeGastoRefacturable',
	bind:{
		store:'{storeGastosRefacturablesExistentes}'
	},
	
    initComponent: function () {
 
     	var me = this;
     	
     	
		me.columns = [
		        {
		            dataIndex: 'numeroGastoHaya',
		            reference: 'numeroDeGastoRefacturable',
		            name:'numeroDeGastoRefacturableExistente',
		            text: HreRem.i18n('fieldlabel.gastos.a.refacturar'),
		            flex: 0.7
		           
		        }
		    ];
		    
		 me.selModel = {
		          selType: 'checkboxmodel',
		          mode: 'SINGLE'
		      	}; 
		 
	    me.dockedItems = [
	        {
	            xtype: 'pagingtoolbar',
	            dock: 'bottom',
	            itemId: 'activosPaginationToolbar',
	            inputItemWidth: 60,
	            displayInfo: true,
	            bind: {
	                store: '{storeGastosRefacturablesExistentes}'
	            }
	        }
	    ];


		    me.callParent();
    },
    
	onAddClick: function(btn){
		var me = this;
		var idGasto = me.lookupController().getViewModel().getData().gasto.id;
		
		Ext.create('HreRem.view.gastos.AnyadirNuevoGastoRefacturado',{idGasto: idGasto, grid:this}).show();    

    },
    
    onDeleteClick: function(btn){
    	var me = this;
    	var numGastoRefacturado = me.getSelectionModel().getSelection()[0].getData().numeroGastoHaya;
    	var idGasto = me.lookupController().getViewModel().getData().gasto.id;
    	var url = $AC.getRemoteUrl('gastosproveedor/eliminarGastoRefacturado');
    	
    	if( numGastoRefacturado== undefined || numGastoRefacturado == ""){
    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
    	}else{
    		Ext.Ajax.request({	
		 		url: url,
		   		params: {
		   					idGasto:idGasto,
		   					numGastoRefacturado : numGastoRefacturado
		   				},
		    	success: function(response, opts) {
			    	data = Ext.decode(response.responseText);   
			    	var checkGastosRefacturados = me.getView().up("[reference=detalleeconomicogastoref]").down("[name=checkboxActivoRefacturableExistente]");

			    	me.getStore().reload();
			    	
			    	if(data.noTieneGastosRefacturados == true || data.noTieneGastosRefacturados == "true" ){
			    		checkGastosRefacturados.setValue(true);
			    		checkGastosRefacturados.readOnly=true;
			    	}
		    	},
		    	failure: function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    	},
		    	callback: function(options, success, response){
				}		     
		  });		
    	}
    }
    
    
});
