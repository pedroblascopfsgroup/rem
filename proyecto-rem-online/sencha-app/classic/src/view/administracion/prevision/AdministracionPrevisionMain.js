Ext.define('HreRem.view.administracion.gastos.AdministracionPrevisionMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'administracionprevisionmain',
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
        
        me.setTitle(HreRem.i18n('title.administracion.prevision'));
        
        me.items = [
		        
        
        ];
        
        me.callParent(); 

        
    }


});

