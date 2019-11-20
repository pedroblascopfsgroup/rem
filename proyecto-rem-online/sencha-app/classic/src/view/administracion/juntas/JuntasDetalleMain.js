Ext.define('HreRem.view.administracion.juntas.JuntasDetalleMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'juntasdetallemain',
    cls			: 'junta-detalle',
    iconCls		: 'x-fa fa-user',
	iconAlign	: 'left',
	controller: 'administracion',
    viewModel: {
        type: 'administracion'
    },
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    requires 	: ['HreRem.view.configuracion.administracion.proveedores.detalle.ProveedorDetalleModel','HreRem.view.configuracion.administracion.proveedores.detalle.ProveedoresDetalleTabPanel',
    			'HreRem.view.configuracion.administracion.proveedores.detalle.ProveedorDetalleController', 'HreRem.view.administracion.juntas.JuntasDetalleTabPanel','HreRem.view.administracion.AdministracionModel','HreRem.view.administracion.AdministracionController',
    			'HreRem.view.administracion.juntas.GestionJuntas'],
    		    

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
    		
    		me.add({xtype: 'juntasdetalletabpanel', flex: 1});
    	}
    }
});