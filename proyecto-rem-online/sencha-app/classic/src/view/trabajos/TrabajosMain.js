Ext.define('HreRem.view.trabajos.TrabajosMain', {
    extend: 'Ext.container.Container',
    xtype: 'trabajosmain',
    layout : {
					type : 'vbox',
					align : 'stretch'
	},
    
        
    requires: [
        'HreRem.view.trabajos.TrabajosController',
        'HreRem.view.trabajos.TrabajosModel',
        'HreRem.view.trabajos.TrabajosSearch',
        'HreRem.view.trabajos.TrabajosList',
        'HreRem.view.trabajos.detalle.TrabajosDetalle'
    ],
    

    controller: 'trabajos',
    viewModel: {
        type: 'trabajos'
    },  



	items : [{
				xtype : 'trabajossearch',
				reference : 'trabajossearch'
			},
			{
				xtype : 'trabajoslist',
				reference : 'trabajoslist',
				flex: 1
			}
	],
	
	initComponent: function() {
		
		var me = this;
		
		me.on('activate', me.refresh, me);
		me.callParent();
	},
	
	refresh: function() {
		
		var me = this;
		
		if(me.refreshOnActivate)  {
			me.down('trabajoslist').getStore().load();
			me.refreshOnActivate = false;
		}
	
	}

				

});

