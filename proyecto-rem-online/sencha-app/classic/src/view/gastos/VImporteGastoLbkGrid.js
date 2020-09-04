Ext.define('HreRem.view.gastos.VImporteGastoLbkGrid', {
    extend		: 'HreRem.view.common.GridBase',
    xtype		: 'VImporteGastoLbkGrid',
	reference	: 'VImporteGastoLbkGridRef',
	overflowX: 'scroll',
	requires: ['HreRem.model.VImporteGastoLbkGrid'],
	bind: { 
		store: '{storeVImporteGastoLbkGrid}'
	},
	
    initComponent: function () {


     	var me = this;
     	
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
					            text: HreRem.i18n('header.gasto.contabilidad.importe'),
					            dataIndex: 'importeGasto',
								flex	: 3
					            
					        }
				 
		    ];
			
			me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'VImporteGastoLbkGridPaginationToolbar',
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
