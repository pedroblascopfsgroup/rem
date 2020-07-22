Ext.define('HreRem.view.gastos.VentanaCrearLineaDetalleGasto', {
	extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'ventanaCrearLineaDetalleGasto',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 1.7,
	reference: 'ventanaCrearLineaDetalleGasto',
    
    idGasto: null,

    idLineaDetalleGasto: null,
    
    parent: null,

    record: null,
    
    initComponent: function() {
    	var me = this;
    	var idGasto = null;
    	var	idLineaDetalleGasto = null;
    	var deshabilitarRecargo = true;
    	var estadoParaGuardar = me.lookupController().getView().getViewModel().getData().gasto.getData().estadoModificarLineasDetalleGasto;
    	
	    var subtipoGasto= null,		baseSujeta= null,		baseNoSujeta= null,		recargo= null,
    	tipoRecargo= null,			interes= null,			costas= null,			otros= null,
    	provSupl= null,				tipoImpuesto= null,		operacionExentaImp= null,	esRenunciaExenta= null,
    	esTipoImpositivo= null,		cuota= null,			importeTotal= 0,		ccBase= null,
    	ppBase= null,				ccEsp= null,			ppEsp= null,			ccTasas= null,
    	ppTasas= null,				ccRecargo= null,		ppRecargo= null,		ccInteres = null,
    	ppInteres = null;
    	
	   
    	if(!Ext.isEmpty(me.idLineaDetalleGasto)){
    		me.setTitle(HreRem.i18n("fieldlabel.gasto.modificar.linea.detalle"));
    		if(!Ext.isEmpty(me.record)){
    			var data = me.record;
 
        		subtipoGasto= data.subtipoGasto;		baseSujeta= data.baseSujeta;					baseNoSujeta= data.baseNoSujeta;
            	recargo= data.recargo;					tipoRecargo= data.tipoRecargo;					interes= data.interes;
            	costas= data.costas;					otros= data.otros;								provSupl= data.provSupl;
            	tipoImpuesto= data.tipoImpuesto;		operacionExentaImp= data.operacionExentaImp;	esRenunciaExenta= data.esRenunciaExenta;
            	esTipoImpositivo= data.esTipoImpositivo;	cuota= data.cuota;							importeTotal= data.importeTotal;
            	ccBase= data.ccBase;					ppBase= data.ppBase;							ccEsp= data.ccEsp;
            	ppEsp= data.ppEsp;						ccTasas= data.ccTasas;							ppTasas= data.ppTasas;
            	ccRecargo= data.ccRecargo;				ppRecargo= data.ppRecargo;						ccInteres = data.ccInteres;
            	ppInteres = data.ppInteres;

            	if(recargo == null || recargo == undefined || parseFloat(recargo) == 0){
            		tipoRecargo = null;
            	}else{
            		deshabilitarRecargo = false;
            	}
            		
        	}
    	}else{
    		me.setTitle(HreRem.i18n("fieldlabel.gasto.crear.linea.detalle"));
    	}
    	
    	me.buttons = [ 
    		{ 
    			formBind: true, 
    			itemId: 'btnGuardar', 
    			text: 'Guardar', 
    			handler: 'onClickGuardarLineaDetalleGasto',
    			disabled: !estadoParaGuardar
    		},
    		{ 
    			itemId: 'btnCancelar', 
    			text: 'Cancelar', 
    			handler: 'closeWindow', 
    			scope: this
    		}
    	];

    	me.items = [
    				{
	    				xtype: 'formBase',
	    				url: $AC.getRemoteUrl("gastosproveedor/saveGastoLineaDetalle"),
	    				reference: 'crearLineaDetalleGastoForm',
	    				collapsed: false,
	   			 		scrollable	: 'y',
	   			 		layout: {
	   			 			type: 'vbox'
	   			 		},
	    				cls:'formbase_no_shadow',
	    				items: [
	    					{
		    					xtype:'fieldsettable',		    					
					        	colspan: 3,
		    					defaultType: 'textfieldbase',
		    					collapsible: false,
								collapsed: false,
								width: '100%',				    
		    					items: [
		    							//Fila superior
						    			{
						    				xtype: "combobox",
						    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.subtipoGasto'),
						    				reference: 'subtipoGasto',
						    				name: 'subtipoGasto',
						    				colspan: 3,
						    				margin: '10 0 10 0',
						    				allowBlank: false,
						    				displayField: 'descripcion',
											valueField: 'codigo',
						    				bind: {
						    					store: '{comboSubtiposGasto}'
						    				}
						    				
						    				
						    			},
						    			//Columna 1
						    			{
						    				title: HreRem.i18n('fieldlabel.gasto.importes.linea.detalle'),
						    				xtype:'fieldset',		    					
					    					defaultType: 'textfieldbase',
						    				cls:'formbase_no_shadow',
						    				border: true,
						    				collapsible: false,
											collapsed: false,
											height: 330,
											layout: {
										        type: 'table',
												trAttrs: {height: '30px', width: '90%'},
												columns: 1,
												tableAttrs: {
										            style: { width: '90%' }
										        }
											},
					    					items: [
					    						{
					    							xtype:'numberfield', 
									        		hideTrigger: true,
									        		keyNavEnable: false,
									        		mouseWheelEnable: false,
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.baseSujeta'),
								    				reference: 'baseSujeta',
								    				name: 'baseSujeta',
								    				allowBlank: true,
								    				value: baseSujeta,
								    				renderer: function(value) {
										        		return Ext.util.Format.currency(value);
										        	},
										        	listeners: {
				    									change: 'onChangeValorImporteTotal'
				    								}	
								    			},
								    			{
								    				xtype:'numberfield', 
									        		hideTrigger: true,
									        		keyNavEnable: false,
									        		mouseWheelEnable: false,
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.baseNoSujeta'),
								    				reference: 'baseNoSujeta',
								    				value: baseNoSujeta,
								    				name: 'baseNoSujeta',
								    				allowBlank: true,	    			
								    				renderer: function(value) {
										        		return Ext.util.Format.currency(value);
										        	},
										        	listeners: {
				    									change: 'onChangeValorImporteTotal'
				    								}
								    				
								    				
								    			},
								    			{
								    				xtype:'numberfield', 
									        		hideTrigger: true,
									        		keyNavEnable: false,
									        		mouseWheelEnable: false,
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.recargo'),
								    				reference: 'recargo',
								    				value: recargo,
								    				name: 'recargo',
								    				allowBlank: true,		    			
								    				renderer: function(value) {
										        		return Ext.util.Format.currency(value);
										        	},
										        	listeners: {
				    									change: 'onChangeHabilitarTipoRecargo'
				    								}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.tipoRecargo'),
								    				reference: 'tipoRecargo',
								    				name: 'tipoRecargo',
								    				disabled: deshabilitarRecargo,
								    				value: tipoRecargo,
								    				allowBlank: true,		    			
								    				colspan: 3,
								    				displayField: 'descripcion',
													valueField: 'codigo',
								    				bind: {
								    					store: '{comboTipoRecargo}'
								    				}
								    				
								    			},
								    			{
								    				xtype:'numberfield', 
									        		hideTrigger: true,
									        		keyNavEnable: false,
									        		mouseWheelEnable: false,
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.interes'),
								    				reference: 'interes',
								    				value: interes,
								    				name: 'interes',
								    				allowBlank: true,		    			
								    				renderer: function(value) {
										        		return Ext.util.Format.currency(value);
										        	},
										        	listeners: {
				    									change: 'onChangeValorImporteTotal'
				    								}
								    				
								    			},
								    			{
								    				xtype:'numberfield', 
									        		hideTrigger: true,
									        		keyNavEnable: false,
									        		mouseWheelEnable: false,
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.costas'),
								    				reference: 'costas',
								    				value: costas,
								    				name: 'costas',
								    				allowBlank: true,		    			
								    				renderer: function(value) {
										        		return Ext.util.Format.currency(value);
										        	},
										        	listeners: {
				    									change: 'onChangeValorImporteTotal'
				    								}
								    				
								    			},
								    			{
								    				xtype:'numberfield', 
									        		hideTrigger: true,
									        		keyNavEnable: false,
									        		mouseWheelEnable: false,
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.otros'),
								    				reference: 'otros',
								    				value: otros,
								    				name: 'otros',
								    				allowBlank: true,		    			
								    				renderer: function(value) {
										        		return Ext.util.Format.currency(value);
										        	},
										        	listeners: {
				    									change: 'onChangeValorImporteTotal'
				    								}
								    				
								    			},
								    			{
								    				xtype:'numberfield', 
									        		hideTrigger: true,
									        		keyNavEnable: false,
									        		mouseWheelEnable: false,
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.provSupl'),
								    				reference: 'provSupl',
								    				value: provSupl,
								    				name: 'provSupl',
								    				allowBlank: true,		    			
								    				renderer: function(value) {
										        		return Ext.util.Format.currency(value);
										        	},
										        	listeners: {
				    									change: 'onChangeValorImporteTotal'
				    								}
								    				
								    			}
					    					]
						    			},
						    			//Columna 2
						    			{
						    				title: HreRem.i18n('fieldlabel.gasto.impInd.linea.detalle'),
						    				xtype:'fieldset',		    					
					    					defaultType: 'textfieldbase',
					    					border: true,
						    				collapsible: false,
											collapsed: false,
											height: 330,
											layout: {
										        type: 'table',
												trAttrs: {height: '30px', width: '90%'},
												columns: 1,
												tableAttrs: {
										            style: { width: '90%' }
										        }
											},				    
					    					items: [
					    						{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.tipoImpuesto'),
								    				reference: 'tipoImpuesto',
								    				name: 'tipoImpuesto',
								    				value: tipoImpuesto,
								    				allowBlank: true,		    			
								    				displayField: 'descripcion',
													valueField: 'codigo',
								    				bind: {
								    					store: '{comboTipoImpuesto}'
								    				}
								    				
								    			},
								    			{
								    				xtype:'numberfield', 
									        		hideTrigger: true,
									        		keyNavEnable: false,
									        		mouseWheelEnable: false,
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.operacionExentaImp'),
								    				reference: 'operacionExentaImp',
								    				name: 'operacionExentaImp',
								    				value: operacionExentaImp,
								    				allowBlank: true,		    			
								    				colspan: 3
								    				
								    			},			    						
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.esRenunciaExenta'),
								    				reference: 'esRenunciaExenta',
								    				name: 'esRenunciaExenta',
								    				value: esRenunciaExenta,
								    				allowBlank: true,		    			
								    				colspan: 3,
								    				displayField: 'descripcion',
													valueField: 'codigo',
								    				bind: {
								    					store: '{comboSiNoGastoBoolean}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.esTipoImpositivo'),
								    				reference: 'esTipoImpositivo',
								    				name: 'esTipoImpositivo',
								    				value: esTipoImpositivo,
								    				allowBlank: true,		    			
								    				colspan: 3,
								    				displayField: 'descripcion',
													valueField: 'codigo',
								    				bind: {
								    					store: '{comboSiNoGastoBoolean}'
								    				}
								    				
								    			},
								    			{
								    				xtype:'numberfield', 
									        		hideTrigger: true,
									        		keyNavEnable: false,
									        		mouseWheelEnable: false,
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.cuota'),
								    				reference: 'cuota',
								    				name: 'cuota',
								    				value: cuota,
								    				allowBlank: true,
								    				renderer: function(value) {
										        		return Ext.util.Format.currency(value);
										        	}
								    				
								    			}
					    					]
						    			},
						    			//Columna 3
						    			{
						    				title: HreRem.i18n('fieldlabel.gasto.ccPp.linea.detalle'),
						    				xtype:'fieldset',		    					
					    					defaultType: 'textfieldbase',
					    					border: true,
						    				collapsible: false,
											collapsed: false,
											height: 330,
											layout: {
										        type: 'table',
												trAttrs: {height: '30px', width: '90%'},
												columns: 1,
												tableAttrs: {
										            style: { width: '90%' }
										        }
											},				    
					    					items: [
					    						{
								    				xtype: "textfield",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccBase'),
								    				reference: 'ccBase',
								    				name: 'ccBase',
								    				value: ccBase,
								    				allowBlank: false
								    				
								    			},
								    			{
								    				xtype: "textfield",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppBase'),
								    				reference: 'ppBase',
								    				name: 'ppBase',
								    				value: ppBase,
								    				allowBlank: false	    			
								    				
								    				
								    			},
								    			{
								    				xtype: "textfield",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccEsp'),
								    				reference: 'ccEsp',
								    				name: 'ccEsp',
								    				value: ccEsp,
								    				allowBlank: true
								    			},
								    			{
								    				xtype: "textfield",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppEsp'),
								    				reference: 'ppEsp',
								    				name: 'ppEsp',
								    				value: ppEsp,
								    				allowBlank: true
								    				
								    			},
								    			{
								    				xtype: "textfield",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccTasas'),
								    				reference: 'ccTasas',
								    				name: 'ccTasas',
								    				value: ccTasas,
								    				allowBlank: true
								    				
								    			},
								    			{
								    				xtype: "textfield",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppTasas'),
								    				reference: 'ppTasas',
								    				name: 'ppTasas',
								    				value: ppTasas,
								    				allowBlank: true
								    				
								    			},
								    			{
								    				xtype: "textfield",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccRecargo'),
								    				reference: 'ccRecargo',
								    				name: 'ccRecargo',
								    				value: ccRecargo,
								    				allowBlank: true
								    				
								    			},
								    			{
								    				xtype: "textfield",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppRecargo'),
								    				reference: 'ppRecargo',
								    				name: 'ppRecargo',
								    				value: ppRecargo,
								    				allowBlank: true
								    				
								    			},
								    			{
								    				xtype: "textfield",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccInteres'),
								    				reference: 'ccInteres',
								    				name: 'ccInteres',
								    				value: ccInteres,
								    				allowBlank: true
								    				
								    			},
								    			{
								    				xtype: "textfield",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppInteres'),
								    				reference: 'ppInteres',
								    				name: 'ppInteres',
								    				value: ppInteres,
								    				allowBlank: true
								    				
								    			}
					    					]
						    			},
						    			// Fila inferior
						    			{
						    				xtype:'numberfield', 
							        		hideTrigger: true,
							        		keyNavEnable: false,
							        		mouseWheelEnable: false,
						    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.importeTotal'),
						    				reference: 'importeTotal',
						    				name: 'importeTotal',
						    				value: importeTotal,
						    				colspan: 3,
						    				margin: '0 0 10 0',
						    				readOnly: true,
						    				renderer: function(value) {
								        		return Ext.util.Format.currency(value);
								        	}
						    				
						    			}
						    			
						    		]
	    					}
	    				]
    				}
    	];

    	me.callParent();
    	
    	if(!Ext.isEmpty(me.record)){
    		var comboSubtipoGasto = me.down('[reference="crearLineaDetalleGastoForm"]').getForm().findField('subtipoGasto');
    		comboSubtipoGasto.getStore().load();
    		comboSubtipoGasto.setValue(subtipoGasto);
    		
    		var comboTipoRecargo = me.down('[reference="crearLineaDetalleGastoForm"]').getForm().findField('tipoRecargo');
    		comboTipoRecargo.getStore().load();
    		comboTipoRecargo.setValue(tipoRecargo);
    		
    		var comboTipoImpuesto = me.down('[reference="crearLineaDetalleGastoForm"]').getForm().findField('tipoImpuesto');
    		comboTipoImpuesto.getStore().load();
    		comboTipoImpuesto.setValue(tipoImpuesto);
    		
    		var comboSiNoGastoBoolean = me.down('[reference="crearLineaDetalleGastoForm"]').getForm().findField('esRenunciaExenta');
    		comboSiNoGastoBoolean.getStore().load();
    		comboSiNoGastoBoolean.setValue(esRenunciaExenta);

    		comboSiNoGastoBoolean = me.down('[reference="crearLineaDetalleGastoForm"]').getForm().findField('esTipoImpositivo');
    		comboSiNoGastoBoolean.getStore().load();
    		comboSiNoGastoBoolean.setValue(esTipoImpositivo);
    		
    		
    	}
    	
    }
});