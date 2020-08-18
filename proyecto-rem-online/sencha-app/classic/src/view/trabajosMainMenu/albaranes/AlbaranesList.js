Ext.define('HreRem.view.trabajosMainMenu.albaranes.AlbaranesList', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'albaraneslist',
    scrollable: 'y',

    initComponent: function () {
    	
    	var me = this;

	    me.items= [
		        {
		        	xtype: 'panel',
		        	title: 'Lista de albaranes',
		        	layout: 'fit',
		        	bodyPadding: 20,
		        	items: [
		        		{
							xtype : 'albaranGrid',
							reference : 'albaranGrid'
						},
						{
							xtype: 'panel',
							layout: 'hbox',
							align: 'right',
							items: [{
					            xtype: 'button',
					            text : 'Validar Albaran',
					            margin: '0 0 10 0',
					            reference: 'botonValidarAlbaran',
					            disabled: true,
					            handler: 'validaAlbaranes'
					        }]
						}
						
		        	]
		        },
		        {
		        	xtype: 'panel',
		        	title: 'Detalle Albaran',
		        	bodyPadding: 20,
		        	items: [
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
				        }
		        	]
		        },
		        {
		        	xtype: 'panel',
		        	title: 'Detalle Prefactura',
		        	bodyPadding: 20,
		        	items: [
		        		{
							xtype: 'detallePrefacturaGrid',
							reference: 'detallePrefacturaGrid'
						},
						{
							xtype: 'container',
							layout: {
								type : 'table',
								columns: 3
							},
							items: [
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.albaran.totalAlbaran'),
									xtype: 'textfield',
//									queryMode : 'remote',
									reference: 'totalAlbaran',
									readOnly: true
								},
								{ 
									fieldLabel: HreRem.i18n('fieldlabel.albaran.totalPrefactura'),
									xtype: 'textfield',
									reference: 'totalPrefactura',
									readOnly: true
								},
								{
						            xtype: 'button',
						            text : 'Validar Prefactura',
						            disabled: true,
						            tdAttrs: { style: 'padding: 5px 15px 5px 15px;', align: 'right' },
						            reference: 'botonValidarTrabajo'
						        }
							]
						}
						
		        	]
		        }
	   	]
	    me.callParent();
    }
    
});