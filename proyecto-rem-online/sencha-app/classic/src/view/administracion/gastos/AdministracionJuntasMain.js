Ext.define('HreRem.view.administracion.gastos.AdministracionJuntasMain', {
	extend		: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    xtype		: 'administracionjuntasmain',
    requires	: ['HreRem.view.administracion.gastos.GestionJuntas','HreRem.view.administracion.AdministracionModel','HreRem.view.administracion.AdministracionController'],
    flex		: 1,
    controller	: 'administracion',
    viewModel	: {
        type: 'administracion'
    },

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.administracion.juntas'));

        me.items = [];
        me.items.push({xtype: 'gestionjuntas', reference: 'gestionjuntasref'});        

        me.callParent(); 
    }
});