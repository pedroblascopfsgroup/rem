Ext.define('HreRem.view.trabajosMainMenu.albaranes.AlbaranesList', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'albaraneslist',
    scrollable: 'y',
	layout: {
		type: 'table',
		columns: 1
	},
    initComponent: function () {
    	
    	var me = this;
    	me.setTitle(HreRem.i18n('title.albaran.albaran'));
	    me.items= [
	    
	   		 {
    			xtype: 'panel',
    			title: HreRem.i18n('title.albaran.albaran'),
    			layout: {
    				columns: 1
    			},
    			cls: 'panel-busqueda-directa',
    			collapsible: false,
	    		
		        items: [
		        
		        	{
						xtype : 'albaranGrid',
						reference : 'albaranGrid'
					},
					{
			            xtype: 'button',
			            text : 'Validar Albaran',
			            reference: 'botonValidarAlbaran',
			            disabled: true,
			            handler: 'validaAlbaranes'
			        },
					{
						xtype: 'detalleAlbaranGrid',
						reference: 'detalleAlbaranGrid'
					},
					{
			            xtype: 'button',
			            text : 'Validar Prefactura',
			            disabled: true,
			            reference: 'botonValidarPrefactura',
			            handler: 'validaPrefacturas'
			        },
					{
						xtype: 'detallePrefacturaGrid',
						reference: 'detallePrefacturaGrid'
					},
					{ 
						fieldLabel: HreRem.i18n('fieldlabel.albaran.totalAlbaran'),
						xtype: 'numberfieldbase',
						readOnly: true
					},
					{ 
						fieldLabel: HreRem.i18n('fieldlabel.albaran.totalPrefactura'),
						xtype: 'numberfieldbase',
						readOnly: true
					},
					{
			            xtype: 'button',
			            text : 'Validar Trabajo',
			            disabled: true,
			            reference: 'botonValidarTrabajo'
			        }
		        ]
	   		 }
	   	]
	    me.callParent();
    }
    
});