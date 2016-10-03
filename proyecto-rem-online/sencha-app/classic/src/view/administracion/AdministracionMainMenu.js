Ext.define('HreRem.view.administracion.AdministracionMainMenu', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'administracionmainmenu',
    reference	: 'administracionMainMenu',
    layout: 'fit',
    
    requires	: ['HreRem.view.administracion.gastos.AdministracionGastosMain','HreRem.view.administracion.gastos.AdministracionPrevisionMain',
    'HreRem.view.administracion.gastos.AdministracionConfiguracionMain'],
    

    initComponent: function () {
        
        var me = this;
        
        me.items = [
		    {	
				xtype: 'administraciongastosmain', reference: 'administracionGastosMain'
			}/*,
			{	
				xtype: 'administracionprevisionmain', reference: 'administracionPrevisionMain'
			},
			{	
				xtype: 'administracionconfiguracionmain', reference: 'administracionConfiguracionMain', disabled: true
			}*/
        ];
        
        me.callParent(); 

        
    }

});

