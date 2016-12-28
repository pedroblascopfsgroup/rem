Ext.define('HreRem.view.gastos.GastoDetalleMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'gastodetallemain',
    cls			: 'gasto-detalle',
	iconCls		: 'ico-pestana-gasto',
	iconAlign	: 'left',
	controller: 'gastodetalle',
    viewModel: {
        type: 'gastodetalle'
    },
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    requires : ['HreRem.view.gastos.GastoDetalleModel','HreRem.view.gastos.CabeceraGasto','HreRem.view.gastos.GastoDetalle','HreRem.view.gastos.GastoDetalleController'],
    // NOTA: Añadiendo los items en la función configCmp, y llamando a esta en el callback de la petición de datos del activo, conseguimos que la pestaña se añada casi de inmediato al tabpanel,
	// renderizando el resto de contenido una vez hecha la petición. Se ha añadido un simple container, que posteriormente se quitará, para que la mascará de carga de la pestaña se muestre correctamante
			
	items: [	
			{xtype: 'container',
			 cls: 'container-mask-background',
			 flex: 1
			}
    ],
    
    configCmp: function(data) {
    	
    	var me = this;

    	if(me.down('[cls=container-mask-background]')) {
    		me.removeAll();
    		me.add({xtype: 'cabeceragasto'});
    		me.add({xtype: 'gastodetalle', flex: 1});
    	}
    }

});




