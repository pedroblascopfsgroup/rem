Ext.define('HreRem.view.administracion.gastos.AdministracionConfiguracionMain', {
	extend		: 'Ext.tab.Panel',
    xtype		: 'administracionconfiguracionmain',
//    requires	: [''],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    
//        controller: 'comercialvisitas',
//    viewModel: {
//        type: 'administracion'
//    },

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.administracion.configuracion'));
        
        me.items = [
		        
        
        ];
        
        me.callParent(); 

        
    }


});

