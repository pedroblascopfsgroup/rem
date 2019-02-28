Ext.define('HreRem.view.activos.detalle.ActivosDetalleMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'activosdetallemain',
	iconCls		: 'ico-pestana-activos',
	iconAlign	: 'left',
	controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    requires : ['HreRem.view.activos.detalle.ActivoDetalleController', 'HreRem.view.activos.detalle.ActivoDetalleModel', 
			'HreRem.view.activos.detalle.CabeceraActivo', 'HreRem.view.activos.detalle.ActivosDetalle', 'HreRem.view.agrupaciones.detalle.AgrupacionesDetalle'],

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
    		me.add({xtype: 'cabeceraactivo'});
    		me.add({xtype: 'activosdetalle', flex: 1});
    	}
    	
    	me.down("cabeceraactivo").refreshData(data);
    	
    }

});