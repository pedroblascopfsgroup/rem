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
		          mode: 'MULTI'
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
		        
		me.saveSuccessFn = function() {
			var me = this;
			me.up('detalleeconomicogasto').funcionRecargar();
			return true;
	    }
    },
    
	onAddClick: function(btn){
		var me = this;
		var gasto = me.lookupController().getViewModel().getData().gasto.data;
		var detalleEconomico = me.lookupController().getViewModel().getData().detalleeconomico.data;

		Ext.create('HreRem.view.gastos.AnyadirNuevoGastoRefacturado',{idGasto: gasto.id, grid:this, nifPropietario: gasto.nifPropietario}).show();    

    },
    
    onDeleteClick: function(btn){
    	var me = this;
    	var idGasto = me.lookupController().getViewModel().getData().gasto.id;
    	var url = $AC.getRemoteUrl('gastosproveedor/eliminarGastoRefacturado');
 
		var numerosGasto = '';
		for(var i = 0; i < me.getSelection().length; i++){
			numerosGasto = numerosGasto + me.getSelection()[i].id + '/';
    	}
    	if(numerosGasto == ''){
    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
    	}else{
    		Ext.Ajax.request({	
		 		url: url,
		   		params: {
		   					idGasto:idGasto,
		   					numerosGasto: numerosGasto
		   				},
		    	success: function(response, opts) {
			    	data = Ext.decode(response.responseText);  
			
			    	var checkGastosRefacturados = me.getView().up("[reference=detalleeconomicogastoref]").down("[name=gastoRefacturableB]");
			    	var idGasto = me.lookupController().getViewModel().getData().gasto.id;
			    	var url2 = $AC.getRemoteUrl('gastosproveedor/eliminarUltimoGastoRefacturado');
			    	me.getStore().reload();
			    	
			    	if(data.noTieneGastosRefacturados == true || data.noTieneGastosRefacturados == "true" ){
			    		checkGastosRefacturados.setValue(true);
			    		Ext.Ajax.request({	
					 		url: url2,
					   		params: {
					   					idGasto:idGasto
					   				},
					    	success: function(response, opts) {
						    	
					    	},
					    	failure: function(response) {
								me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					    	},
					    	callback: function(options, success, response){
							}		     
					  });
			    	}
			    	var datosGeneralesGastos = me.up("gastodetalle").down("[reference=datosgeneralesgastoref]");
			    	me.lookupController().cargarTabData(datosGeneralesGastos);
			    	
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
