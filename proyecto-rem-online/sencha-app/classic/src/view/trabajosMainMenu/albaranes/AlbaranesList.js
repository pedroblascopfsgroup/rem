Ext.define('HreRem.view.trabajosMainMenu.albaranes.AlbaranesList', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'albaraneslist',
    scrollable: 'y',
    
    requires: ['HreRem.model.AlbaranGridModel','HreRem.model.DetalleAlbaranGridModel','HreRem.model.DetallePrefacturaGridModel'],
    
    initComponent: function () {
    	
    	var me = this;

	    me.items= [
		        {
		        	xtype: 'panel',
		        	title: HreRem.i18n('title.albaran.listaAlbaran'),
		        	bodyPadding: 20,
		        	items: [
		        		{
							xtype : 'albaranGrid',
							reference : 'albaranGrid'
						},
						{
				            xtype: 'button',
				            text : HreRem.i18n('fieldlabel.albaran.validar'),
				            reference: 'botonValidarAlbaran',
				            disabled: true,
				            handler: 'validaAlbaranes'
						}
						
		        	]
		        },
		        {
		        	xtype: 'panel',
		        	title: HreRem.i18n('fieldlabel.albaran.detalleAlbaran'),
		        	bodyPadding: 20,
		        	items: [
		        		{
							xtype: 'detalleAlbaranGrid',
							reference: 'detalleAlbaranGrid'
						},
						{
				            xtype: 'button',
				            text : HreRem.i18n('fieldlabel.albaran.validarPrefactura'),
				            disabled: true,
				            reference: 'botonValidarPrefactura',
				            handler: 'validaPrefacturas'
				        }
		        	]
		        },
		        {
		        	xtype: 'panel',
		        	title: HreRem.i18n('title.albaran.detallePrefactura'),
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
						            text : HreRem.i18n('fieldlabel.albaran.validarPrefactura'),
						            disabled: true,
						            tdAttrs: { style: 'padding: 5px 15px 5px 15px;', align: 'right' },
						            reference: 'botonValidarTrabajo',
						            handler: 'validaTrabajos'
						        }
							]
						}
						
		        	]
		        }
	   	]
	    me.callParent();
    }
    
});