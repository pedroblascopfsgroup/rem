Ext.define('HreRem.view.gastos.VImporteGastoLbkGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'vImporteGastoLbkGrid',
	reference	: 'vImporteGastoLbkGridRef',
	overflowX: 'scroll',
	requires: ['HreRem.model.VImporteGastoLbkGrid'],
	bind: { 
		store: '{storeVImporteGastoLbkGrid}'
	},
	
    initComponent: function () {
     	var me = this;
     	
     	me.features = [{
            id: 'summary',
            ftype: 'summary',
            hideGroupedHeader: true,
            enableGroupingMenu: false,
            dock: 'bottom'
		}];
     	
     	me.setTitle(HreRem.i18n('title.importe.gasto.liberbank')),
     	
		me.columns = [
			 
			  				{
				            	text	 : HreRem.i18n('header.gasto.contabilidad.entidad'),
				                flex	 : 2,
				                dataIndex: 'idElemento'
				            },
				            {
				            	text	 : HreRem.i18n('header.gasto.contabilidad.tipo.entidad'),
				                flex	 : 1,
				                dataIndex: 'tipoElemento'
				            },
				            {
								text 	 : HreRem.i18n('header.gasto.contabilidad.importe'),
								flex 	 : 2,
								dataIndex: 'importeGasto',

					        	renderer: function(value, cell, record) {
					        		if(!Ext.isEmpty(value) && value != '0.0'){
					        			return Utils.rendererCurrency(value);
					        		}
					        		else{
					        			return '0.00'+' \u20AC';
					        		}
					        	},
					        	
								summaryType: 'sum',
					            summaryRenderer: function(value, summaryData, dataIndex) {
					            	var suma = 0;
					            	var dataStore = this.up('vImporteGastoLbkGrid').store.getData().items;
					            	for(var i = 0; i < dataStore.length; i++){
					            		if(!Ext.isEmpty(dataStore[i].data)  && !Ext.isEmpty(dataStore[i].data.importeGasto)){
					            			suma += parseFloat(dataStore[i].data.importeGasto);
					            		}
					            	}
					            	suma = Ext.util.Format.number(suma, '0.00');
					            	var msg = HreRem.i18n("header.gasto.contabilidad.importe.total") + ": " + suma + " \u20AC";		
					            	return msg;
					            }
							}
				 
		    ];
			
			me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'vImporteGastoLbkGridPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            overflowX: 'scroll',
		            bind: {
		            	store: '{storeVImporteGastoLbkGrid}'
		            }
		        }
		    ];

		    me.callParent();
    },
    
 
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load(grid.loadCallbackFunction);
  		});
    }
    
});
