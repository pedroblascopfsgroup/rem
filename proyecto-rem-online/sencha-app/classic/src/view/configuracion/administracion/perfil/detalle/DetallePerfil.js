Ext.define('HreRem.view.configuracion.administracion.perfiles.detalle.DetallePerfil', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'detalleperfil',
    iconCls		: 'x-fa fa-user',
	iconAlign	: 'left',
    scrollable: 'y',
    viewModel	: {
        type: 'perfildetalle'
    },
    recordClass: "HreRem.model.PerfilDetalleModel",
    requires: ['HreRem.model.PerfilDetalleModel',
    	'HreRem.view.configuracion.administracion.perfiles.detalle.DatosPerfil', 
    	'HreRem.view.configuracion.administracion.perfiles.detalle.FuncionesPerfil'
    	],
    	
    items: [	
    	{	
			xtype: 'datosperfil'
		},
		{	
			xtype: 'funcionesperfil'
		}
    	],
    	
	configCmp: function(data) {
		
		var me = this;
		
		if(me.down('[cls=container-mask-background]')) {
			me.removeAll();
//			me.items= [
//    			
//    		];

		}
	}
});