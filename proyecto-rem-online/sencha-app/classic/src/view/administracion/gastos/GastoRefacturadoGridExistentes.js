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
		var noSePuedenAnyadirEliminar = me.lookupController().getViewModel().getData().detalleeconomico.data.noAnyadirEliminarGastosRefacturados;
		if (detalleEconomico.gastoRefacturableB) {
			me.fireEvent("errorToast", HreRem.i18n("msg.refacturar.refacturable.ko"));
		} else if (gasto.destinatario != CONST.TIPOS_DESTINATARIO_GASTO['PROPIETARIO']) {
			me.fireEvent("errorToast", HreRem.i18n("msg.refacturar.destinatario.ko"));
		} else if (gasto.nifEmisor != CONST.PVE_DOCUMENTONIF['HAYA']) {
			me.fireEvent("errorToast", HreRem.i18n("msg.refacturar.emisor.ko"));
		} else if(noSePuedenAnyadirEliminar == undefined || noSePuedenAnyadirEliminar){
			me.fireEvent("errorToast", HreRem.i18n("msg.refacturar.refacturable.ko.estado.invalido"));
		}else{
			Ext.create('HreRem.view.gastos.AnyadirNuevoGastoRefacturado',{idGasto: gasto.id, grid:this, nifPropietario: gasto.nifPropietario}).show();  
		}
    },
    
    onDeleteClick: function(btn){
    	var me = this;
    	var idGasto = me.lookupController().getViewModel().getData().gasto.id;
    	var url = $AC.getRemoteUrl('gastosproveedor/eliminarGastoRefacturado');
    	var noSePuedenAnyadirEliminar = me.lookupController().getViewModel().getData().detalleeconomico.data.noAnyadirEliminarGastosRefacturados;
    	
		var numerosGasto = '';
		for(var i = 0; i < me.getSelection().length; i++){
			numerosGasto = numerosGasto + me.getSelection()[i].id + '/';
    	}
		if(noSePuedenAnyadirEliminar == undefined || noSePuedenAnyadirEliminar){
			me.fireEvent("errorToast", HreRem.i18n("msg.refacturar.refacturable.ko.estado.invalido"));
		}else if(numerosGasto == ''){
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
			    	me.getStore().reload();
			    	var datosGeneralesGastos = me.up("gastodetalle").down("[reference=datosgeneralesgastoref]");
			    	me.lookupController().cargarTabData(datosGeneralesGastos);
			    	
		    	},
		    	failure: function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    	},
		    	callback: function(options, success, response){
		    		var datosGeneralesGastos = me.getView().grid.up("gastodetalle").down("[reference=datosgeneralesgastoref]");
		    		var datosDetalleEconomico = me.getView().grid.up("gastodetalle").down("[reference=detalleeconomicogastoref]");
		    		datosGeneralesGastos.funcionRecargar();
		    		datosDetalleEconomico.funcionRecargar();
				}		     
		  });		
    	}
    }
    
    
});
