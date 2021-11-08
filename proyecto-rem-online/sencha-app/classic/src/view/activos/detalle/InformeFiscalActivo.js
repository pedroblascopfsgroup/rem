Ext.define('HreRem.view.activos.detalle.InformeFiscalActivo', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'informefiscalactivo',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: false,
    reference: 'informefiscalactivo',
    scrollable	: 'y',
    refreshAfterSave : true,
    viewModel: {
        type: 'activodetalle'
    },
    listeners: {
        boxready:'cargarTabData'
    },
	recordName: "informefiscal",
	
	recordClass: "HreRem.model.ActivoInformeFiscal",
    
    requires: ['HreRem.model.ActivoInformeFiscal'],
    
    initComponent: function () {

        var me = this;
        me.setTitle(HreRem.i18n('title.informe.fiscal'));

        var items= [
			{
			xtype:'fieldsettable',
	        title: HreRem.i18n('title.tributacion.adquisicion'),
			items: [
				{    
				xtype:'container',
				layout:'hbox',
				colspan: 3,
				defaultType: 'container',
				items :
					[{ // Columna 1
							defaultType: 'textfieldbase',
							flex: 1,
							items:[
								{
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.impuesto.adquisicion'),
                                    bind: {
                                        store: '{comboImpuestoAdquisicion}',
                                        value: '{informefiscal.codigoTipoImpuestoCompra}'
                                    }
	
				                },
				                {
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.deducible'),
                                    bind: {
                                        store: '{comboSiNoDict}',
                                        value: '{informefiscal.deducible}'
                                    }
				                },
						        {
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel:  HreRem.i18n('fieldlabel.itp.bonificado'),
                                    bind: {
                                        store: '{comboSiNoDict}',
                                        value: '{informefiscal.bonificado}'
                                    }
				                }
							]
						},
						{	// Columna 2
							defaultType: 'textfieldbase',
							flex: 1,
							items:[
								{
						        	xtype: 'comboboxfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.tipo.impositivo.iva'),
                                    bind: {
                                        store: '{comboTipoImpositivoIva}',
                                        value: '{informefiscal.codigoTipoImpositivoIVA}'
                                    }
						        },
								{
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.tipo.impositivo.itp'),
						        	bind: {
					            		store: '{comboTipoImpositivoItp}',
					            		value: '{informefiscal.codigoTipoImpositivoITP}'
					            	}
					            },
						        {
						        	xtype: 'textfieldbase',
						        	fieldLabel: HreRem.i18n('fieldlabel.codigo.tp.compra'),
						        	bind: '{informefiscal.codigoTpIvaCompra}'
						        }
						    ]
						},
						{ // Columna 3 
							defaultType: 'textfieldbase',
							flex: 1,
							items:[
							    {
                                    xtype: 'numberfieldbase',
                                    symbol: HreRem.i18n("symbol.porcentaje"),
                                    fieldLabel: HreRem.i18n('fieldlabel.porcentaje.impuesto'),
                                    bind: '{informefiscal.porcentajeImpuestoCompra}',
                                    validator: function(v) {
                                        if(!Ext.isEmpty(this.getValue()) && (this.getValue() < 0 || this.getValue() >  100 )){
                                            return false;
                                        }
                                        return true;
                                    }
                                },
								{
				                	xtype: 'comboboxfieldbase',
				                	fieldLabel: HreRem.i18n('fieldlabel.renuncia.exencion.iva'),
                                    bind: {
                                        store: '{comboSiNoDict}',
                                        value: '{informefiscal.renunciaExencionCompra}'
                                    }
				                }
				            ]
						}
					]}
				]
            }
     ];
	me.addPlugin({ptype: 'lazyitems', items: items });
    me.callParent();

    },
    afterLoad: function(){
    	var me = this;
    },
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
    }
});