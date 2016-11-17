Ext.define('HreRem.view.configuracion.mediadores.EvaluacionMediadoresDetail', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'evaluacionmediadoresdetail',
    reference	: 'evaluacionMediadoresDetail',
    scrollable: 'y',
    requires: ['HreRem.view.configuracion.mediadores.detalle.CarteraMediadorStats',
               'HreRem.view.configuracion.mediadores.detalle.OfertasVivasList'],
    
    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n("title.evaluacion.mediadores.detail"));  
        
        me.items= [
			{	
				xtype: 'carteramediadorstats'
			},
			{	
				xtype: 'ofertasvivaslist'
			}
        ];
        
        me.callParent(); 

        
    }


});

