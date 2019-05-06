Ext.define('HreRem.view.activos.detalle.GencatComercialActivo', {
    extend: 'Ext.panel.Panel',
    xtype: 'gencatcomercialactivo',
    
    requires	: [
    	'HreRem.view.activos.detalle.GencatComercialActivoModel',
    	'HreRem.view.activos.detalle.GencatComercialActivoController',
    	'HreRem.view.activos.detalle.GencatComercialActivoForm',
    	'HreRem.view.activos.detalle.HistoricoComunicacionesActivoList'
    ],
    scrollable	: 'y',
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },
    viewModel : {
		type : 'gencatcomercialactivo'
	},
	controller: 'gencatcomercialactivo',

    initComponent: function () {
    	
        var me = this;
        
        me.setTitle(HreRem.i18n("title.gencat"));
        
        var items = [ 
        	{	
				xtype: 'gencatcomercialactivoform',
				reference: 'gencatcomercialactivoformref'
			},
        	{
				
				xtype:'fieldsettable',
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.historico.comunicaciones'),
				collapsible: true,
				layout		: {
			        type: 'vbox',
			        align: 'stretch'
			    },
				items: [
					{	
	    				xtype: 'historicocomunicacionesactivolist',
	    				reference: 'historicocomunicacionesactivolistref',
	    				width: '100%'
	    			}
		    	]
            }
        ];

        
        me.addPlugin({ptype: 'lazyitems', items: items });
        
        me.callParent();
    },
	
	funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me.down('[reference=gencatcomercialactivoformref]'));
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().loadPage(1);
  		});
    }
    
});