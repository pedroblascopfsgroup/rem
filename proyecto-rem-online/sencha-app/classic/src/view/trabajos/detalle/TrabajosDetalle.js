Ext.define('HreRem.view.trabajos.detalle.TrabajosDetalle', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'trabajosdetalle',
	iconCls		: 'ico-pestana-trabajos',
	iconAlign	: 'left',
	flex: 1,
    width: '100%',
    height: '100%',
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    requires : ['HreRem.view.trabajos.detalle.TrabajoDetalleController', 'HreRem.view.trabajos.detalle.TrabajoDetalleModel', 'HreRem.ux.button.BotonFavorito',
    			'HreRem.view.trabajos.detalle.TrabajosDetalleCabecera', 'HreRem.view.trabajos.detalle.TrabajosDetalleTabPanel'],

    controller: 'trabajodetalle',
    viewModel: {
        type: 'trabajodetalle'
    },
   
    items: [
    		{xtype: 'container',
			 cls: 'container-mask-background',
			 flex: 1
    		}
    ],

    /**
     * Función de utilidad que añade el contenido del componente y por si es necesario configurar algo de la vista y que no es posible
     * a través del viewModel 
     */
    configCmp: function(data) {
    	
    	var me = this;
    	if(me.down('[cls=container-mask-background]')) {
    		me.removeAll();
	    	me.add({xtype: 'trabajosdetallecabecera'});
	    	me.add({xtype: 'trabajosdetalletabpanel', flex: 1});
    	}
    	me.down("trabajosdetallecabecera").configCmp(data);
    	//me.down('botonfavorito').setOpenId(data.get("id"));
    	
    }
    
});