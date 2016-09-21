Ext.define('HreRem.view.administracion.gastos.AdministracionGastosMain', {
	extend		: 'Ext.tab.Panel',
	cls: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    xtype		: 'administraciongastosmain',
    requires	: ['HreRem.view.administracion.gastos.GestionGastos', 'HreRem.view.administracion.gastos.GestionSolicitudesProvisionesFondosBankia','HreRem.view.administracion.AdministracionModel',
    				'HreRem.view.administracion.AdministracionController'],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },
    
        controller: 'administracion',
    viewModel: {
        type: 'administracion'
    },

    initComponent: function () {
        
        var me = this;
        
        me.setTitle(HreRem.i18n('title.administracion.gastos'));
        
        me.items = [
		        {	
        			xtype: 'gestiongastos',
        			reference: 'gestiongastosref'        				
        		},
        		{	
        			xtype: 'gestionsolicitudesprovisionesfondosbankia',
        			reference: 'gestionsolicitudesprovisionesfondosbankiaref'        				
        		}
        
        ];
        
        me.callParent(); 

        
    }


});

