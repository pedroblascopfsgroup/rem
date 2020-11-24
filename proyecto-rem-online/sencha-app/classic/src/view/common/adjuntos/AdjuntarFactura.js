Ext.define('HreRem.view.common.adjuntos.AdjuntarFactura', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'adjuntarfacturawindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /3,
	reference: 'adjuntarFacturaWindowRef',
  
    parent: null,

    initComponent: function() {
    	
    	var me = this;
    	
    	var comboTipoFactura = new Ext.data.Store({
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'tipoDocGastoAsociado', entidad: me.entidad}
			}
    	});
    	
    	me.setTitle('Adjuntar Factura');

    	me.buttonAlign = 'left';
		
    	me.buttons = [ { formBind: true, itemId: 'btnGuardar', text: 'Adjuntar', handler: 'onClickBotonAdjuntarDocumento', scope: this},{ itemId: 'btnCancelar', text: 'Cancelar', handler: 'closeWindow', scope: this}];

    	me.items = [
    				{
	    				xtype: 'formBase',
	    				url: $AC.getRemoteUrl("activo/uploadFacturaGastoAsociado"),
	    				reference: 'adjuntarFacturaFormRef',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 		},
	    				cls:'formbase_no_shadow',
	    				items: [
	    						{

 									xtype: 'filefield',
							        fieldLabel:   HreRem.i18n('fieldlabel.archivo'),
							        name: 'fileUpload',
							        anchor: '100%',
							        width: '100%',
							        allowBlank: false,
							        msgTarget: 'side',
							        buttonConfig: {
							        	iconCls: 'ico-search-white',
							        	text: ''
							        },
							        align: 'right',
							        listeners: {
				                        change: function(fld, value) {
				                        	
				                        	var lastIndex = null,
				                        	fileName = null;
				                        	if(!Ext.isEmpty(value)) {
					                        	lastIndex = value.lastIndexOf('\\');
										        if (lastIndex == -1) return;
										        fileName = value.substring(lastIndex + 1);
					                            fld.setRawValue(fileName);
				                        	}
				                        }
				                    } 
					    		},
					    		{
									xtype: 'combobox',
						        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
						        	name: 'tipo',
						        	msgTarget: 'side',
					            	store: comboTipoFactura,
					            	displayField	: 'descripcion',
								    valueField		: 'codigo',
									allowBlank: false,
									width: '100%',
									filtradoEspecial: true
						        },
						        {
				                	xtype: 'textarea',
				                	fieldLabel: HreRem.i18n('fieldlabel.descripcion'),
				                	name: 'descripcion',
				                	maxLength: 256,
				                	msgTarget: 'side',
				                	width: '100%'
			            		}
    					]
    				}
    	];

    	me.callParent();
    }
});
