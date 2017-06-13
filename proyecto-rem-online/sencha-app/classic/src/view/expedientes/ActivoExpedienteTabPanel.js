Ext.define('HreRem.view.expedientes.ActivoExpedienteTabPanel', {
	extend		: 'Ext.tab.Panel',
	cls: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    xtype		: 'activoExpedienteTabPanel',
    requires	: ['HreRem.view.expedientes.ActivoExpedienteCondiciones','HreRem.view.expedientes.ActivoExpedienteJuridico','HreRem.view.expedientes.ActivoExpedienteTanteo'],
    flex		: 1,
    controller	: 'expedientedetalle',
    viewModel	: {
        type: 'expedientedetalle'
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
        		    handler	: 'onClickBotonGuardarActivoExpediente', 
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
        me.items.push({xtype: 'activoexpedientecondiciones', reference: 'activoexpedientecondiciones'});
        me.items.push({xtype: 'activoexpedientejuridico', reference: 'activoexpedientejuridico'});
        me.items.push({xtype: 'activoexpedientetanteo', reference: 'activoexpedientetanteo'});
        
        me.callParent(); 
       
    }
});