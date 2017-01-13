Ext.define('HreRem.view.activos.detalle.FotosActivoTabPanel', {
	extend		: 'Ext.tab.Panel',
    xtype		: 'fotosactivotabpanel',
    flex 		: 3,
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    reference	: 'tabpanelfotosactivo',
    layout		: 'fit',
    requires	: ['HreRem.view.activos.detalle.FotosWebActivo', 'HreRem.view.activos.detalle.FotosTecnicasActivo'],
    listeners	: {
    	boxready: function (tabPanel) {   		
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}
    	}
    },
    tabBar: {
		items: [
        		{
        			xtype: 'tbfill'
        		},
        		{
					xtype: 'buttontab',
        			itemId: 'botoneditar',
        		    handler	: 'onClickBotonEditar',
        		    iconCls: 'edit-button-color',
        		    bind: {hidden: '{editing}'}
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botonguardar',
        		    handler	: 'onClickBotonGuardarInfoFoto', 
        		    iconCls: 'save-button-color',
        		    hidden: true,
        		    bind: {hidden: '{!editing}'}
        		},
        		{
        			xtype: 'buttontab',
        			itemId: 'botoncancelar',
        		    handler	: 'onClickBotonCancelar', 
        		    iconCls: 'cancel-button-color',
        		    hidden: true,
        		    bind: {hidden: '{!editing}'}
        		}
        ]
    },

    initComponent: function () {
        var me = this;

        me.items = [];
    	$AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'fotoswebactivo'})}, ['TAB_FOTOS_ACTIVO_WEB']);
        $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'fotostecnicasactivo'})}, ['TAB_FOTOS_ACTIVO_TECNICAS']);

        me.callParent();
    }
});