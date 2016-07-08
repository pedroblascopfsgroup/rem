Ext.define('HreRem.view.agrupaciones.detalle.FotosAgrupacion', {
    extend: 'Ext.panel.Panel',
    xtype: 'fotosagrupacion',  
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    flex: 1,
    layout: 
    	{
			type : 'vbox',
			align : 'stretch'
		},
		
    reference: 'fotosagrupacion',
    requires: ['HreRem.view.agrupaciones.detalle.FotosWebAgrupacion'],
    
    defaults: {
        xtype: 'container',
        sytle: 'padding-left: 15px !important',
        defaultType: 'displayfield'
    },

    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.fotos'));      
        
        var items= [

			{				
			    xtype		: 'tabpanel',
			    flex 		: 3,
				cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
			    reference	: 'tabpanelfotosactivo',

			    layout: 'fit',
			    items: [
			    		
			    		{
			    			xtype: 'fotoswebagrupacion'
			    		}

			     ]				
			}

    	];   	
		me.addPlugin({ptype: 'lazyitems', items: items });

    	me.callParent();
    	
    },
    
     /**
     * Función de utilidad por si es necesario configurar algo de la vista y que no es posible
     * a través del viewModel 
     */
    configCmp: function(data) {
    	    	
    	var me = this;    	

    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabFotos(me);
		Ext.Array.each(me.query('grid'), function(grid) {
  			grid.getStore().load();
  		});
    } 
    
});