Ext.define('HreRem.view.expedientes.ExpedienteDetalleMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'expedientedetallemain',
	iconCls		: 'fa fa-folder-open',
	iconAlign	: 'left',
	controller: 'expedientedetalle',
    viewModel: {
        type: 'expedientedetalle'
    },
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    requires : ['HreRem.view.expedientes.ExpedienteDetalleController', 'HreRem.view.expedientes.ExpedienteDetalleModel', 
			'HreRem.view.expedientes.CabeceraExpediente', 'HreRem.view.expedientes.ExpedienteDetalle'],

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
    		me.add({xtype: 'cabeceraexpediente'});
    		me.add({xtype: 'expedientedetalle', flex: 1});
    	}
    	
    }

});