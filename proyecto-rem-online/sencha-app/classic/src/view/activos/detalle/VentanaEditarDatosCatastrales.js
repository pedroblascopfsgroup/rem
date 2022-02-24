Ext.define('HreRem.view.activos.detalle.VentanaEditarDatosCatastrales', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'ventanaEditarDatosCatastrales',
    layout	: 'fit',
    width	: 355,
	reference: 'ventanaEditarDatosCatastrales',
	
    parent: null,

    record: null,
    
    controller: null,
    
    modificar: null,
    
    data: null,
    
    initComponent: function() {
    	var me = this;
    	
    	me.buttons = [ 
    		{ 
    			itemId: 'btnCancelar', 
    			text: 'Cancelar', 
    			handler: 'closeWindow', 
    			scope: this
    		},
    		{ 
    			itemId: 'btnGuardar', 
    			text: 'Guardar', 
    			reference: 'guardarRefCatastralRef',
    			handler: 'onClickGuardarReferencia'
    		}
    	];

    	me.items = [
			{
				xtype: 'formBase',
				reference: 'modificarValoresRefCatastral',
				collapsed: false,
		 		layout: {
		 			type: 'vbox'
		 		},
				cls:'formbase_no_shadow',
				items: [
					{
    					xtype:'fieldsettable',		    					
    					defaultType: 'textfieldbase',
    					collapsible: false, 
						collapsed: false,
						layout: {
					        type: 'table',
					        columns: 1,
					        tdAttrs: {width: '100%'},
					        tableAttrs: {
					            style: {
					                width: '100%'
								}
					        }
						},			    
    					items: [
    						{
			                	xtype: 'displayfieldbase',
			                	fieldLabel: HreRem.i18n('fieldlabel.referencia.catastral'),
			                	readOnly: true,
			                	colspan: 3,
			                	value:refCatastral,
			                    margin: '10 0 0 0'
			                },
			                {
								xtype: 'numberfield',
								fieldLabel: HreRem.i18n('fieldlabel.valor.catastral.construccion'),
			                	value:valorCatastralConst
							},
							{
								xtype: 'numberfield',
								fieldLabel: HreRem.i18n('fieldlabel.valor.catastral.suelo'),
								value:valorCatastralSuelo
							},
							{
			                	xtype: 'datefield',
			                	fieldLabel: HreRem.i18n('fieldlabel.fecha.revision.valor.catastral'),
			                	formatter: 'date("d/m/Y")',
			                	value:fechaRevValorCatastral
			                }
			    		]
					}
				]
			}
    	];

    	me.callParent();
    }
});

