Ext.define('HreRem.view.administracion.gastos.AdministracionGastosMain', {
	extend		: 'Ext.tab.Panel',
	cls: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    xtype		: 'administraciongastosmain',
    requires	: ['HreRem.view.administracion.gastos.GestionGastos', 'HreRem.view.administracion.gastos.GestionProvisiones',
    				'HreRem.view.administracion.AdministracionModel','HreRem.view.administracion.AdministracionController'],
    flex		: 1,
    controller	: 'administracion',
    viewModel	: {
        type: 'administracion'
    },

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.administracion.gastos'));

        me.items = [];
        $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'gestiongastos', reference: 'gestiongastosref'})}, ['TAB_GESTION_GASTOS_ADMINISTRACION']);
        $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'gestionprovisiones', reference: 'gestionprovisionesref', disabled: $AU.userIsRol(CONST.PERFILES['PROVEEDOR'])})}, ['TAB_GESTION_PROVISIONES_ADMINISTRACION']);

        me.callParent(); 
    }
});