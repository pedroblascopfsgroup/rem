Ext.define('HreRem.view.activos.detalle.DatosGeneralesActivo', {
    extend: 'Ext.panel.Panel',
    xtype: 'datosgeneralesactivo',
    requires: ['HreRem.view.activos.detalle.DatosGeneralesActivoTabPanel'],
    cls	: 'panel-base shadow-panel',
    layout 	: 'fit',		
    reference: 'datosGeneralesActivo',
    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.ficha'));      
        
        me.items= [

			{				
			    xtype		: 'datosgeneralesactivotabpanel'
			}

    	];   	


    	me.callParent();
    	
    },
        
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;		
		me.down('tabpanel').getActiveTab().funcionRecargar();

    }
    
});