Ext.define('HreRem.view.configuracion.ConfiguracionMain', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'configuracionmain',
    reference	: 'configuracionMain',
    layout: 'fit',
    
    requires	: ['HreRem.view.configuracion.ConfiguracionController','HreRem.view.configuracion.ConfiguracionModel',
    'HreRem.view.configuracion.administracion.ConfiguracionAdministracionMain'],
    
    controller: 'configuracion',
    viewModel: {
        type: 'configuracion'
    },

    initComponent: function () {
        
        var me = this;
        
        me.items = [
		    {	
				xtype: 'configuracionadministracionmain', reference: 'configuracionAdministracionMain'
			}
        ];
        
        me.callParent(); 

        
    }

});