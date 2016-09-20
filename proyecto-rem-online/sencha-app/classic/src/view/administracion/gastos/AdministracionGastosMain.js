Ext.define('HreRem.view.administracion.gastos.AdministracionGastosMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'administraciongastosmain',
    requires	: [''],
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
        
        me.setTitle(HreRem.i18n('title.administracion.gastos'));
        
        me.items = [
		        
        
        ];
        
        me.callParent(); 

        
    }


});

