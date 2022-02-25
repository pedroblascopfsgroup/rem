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
    
    datos: null,
    
    initComponent: function() {
    	var me = this;
    	me.setTitle(HreRem.i18n("title.referencia.catastral.ventana.modificar"));
    	
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
    			handler: 'onClickActualizarReferencia'
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
			                	reference:'refCatastral',
			                	readOnly: true,
			                	colspan: 3,
			                	value:refCatastral,
			                    margin: '10 0 0 0'
			                },
			                {
								xtype: 'numberfield',
								reference:'valorConstruccion',
								fieldLabel: HreRem.i18n('fieldlabel.valor.catastral.construccion'),
			                	value:valorCatastralConst
							},
							{
								xtype: 'numberfield',
								reference:'valorSuelo',
								fieldLabel: HreRem.i18n('fieldlabel.valor.catastral.suelo'),
								value:valorCatastralSuelo
							},
							{
			                	xtype: 'datefield',
			                	reference:'fechaRevision',
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

