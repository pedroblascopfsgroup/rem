Ext.define('HreRem.view.publicacion.PublicacionMain', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'publicacionmain',
    reference	: 'publicacionMain',
    layout		: 'fit',
    requires	: ['HreRem.view.publicacion.PublicacionController', 'HreRem.view.publicacion.activos.ActivosPublicacionMain',
            	   'HreRem.view.publicacion.configuracion.ConfiguracionPublicacionMain', 'HreRem.view.publicacion.PublicacionModel',
            	   'HreRem.model.BusquedaActivosPublicacion', 'HreRem.view.publicacion.activos.ActivosPublicacionList'],
    controller: 'publicaciones',
    viewModel: {
        type: 'publicaciones'
    },
    
    initComponent: function () {
        
        var me = this;
        
        me.items = [
		    {
				xtype: 'activospublicacionmain', reference: 'activosPublicacionMain'
			},
			{
				xtype: 'configuracionpublicacionmain', reference	: 'configuracionPublicacionMain'
			}
        ];

        me.callParent(); 
    }
});