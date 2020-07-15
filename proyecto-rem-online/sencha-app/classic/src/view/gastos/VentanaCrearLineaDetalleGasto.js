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
    	
    	if(!Ext.isEmpty(me.idLineaDetalleGasto)){
    		me.setTitle(HreRem.i18n("fieldlabel.gasto.modificar.linea.detalle"));
    	}else{
    		me.setTitle(HreRem.i18n("fieldlabel.gasto.crear.linea.detalle"));
    	}

    	
    	var comboTipoDocumentoComunicacion = new Ext.data.Store({
			model: 'HreRem.model.ComboBase',
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'gencat/getTiposDocumentoNotificacion',
				extraParams:{
					idNotificacion: idGasto
				}
			}
    	});

    	me.buttons = [ 
    		{ 
    			formBind: true, 
    			itemId: 'btnGuardar', 
    			text: 'Guardar', 
    			handler: 'onClickGuardarLineaDetalleGasto'
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
	    				url: $AC.getRemoteUrl("gencat/crearNotificacionComunicacion"),
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
						    				bind: {
						    					store: '{comboNotificacionGencat}'
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
											height: 300,
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
								    				renderer: function(value) {
										        		return Ext.util.Format.currency(value);
										        	}
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.baseNoSujeta'),
								    				reference: 'baseNoSujeta',
								    				name: 'baseNoSujeta',
								    				allowBlank: true,		    			
								    				 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.recargo'),
								    				reference: 'recargo',
								    				name: 'recargo',
								    				allowBlank: true,		    			
								    				 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.tipoRecargo'),
								    				reference: 'tipoRecargo',
								    				name: 'tipoRecargo',
								    				allowBlank: true,		    			
								    				colspan: 3,
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.interes'),
								    				reference: 'interes',
								    				name: 'interes',
								    				allowBlank: true,		    			
								    				 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.costas'),
								    				reference: 'costas',
								    				name: 'costas',
								    				allowBlank: true,		    			
								    				 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.otros'),
								    				reference: 'otros',
								    				name: 'otros',
								    				allowBlank: true,		    			
								    				  
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.provSupl'),
								    				reference: 'provSupl',
								    				name: 'provSupl',
								    				allowBlank: true,		    			
								    				  
								    				bind: {
								    					store: '{comboNotificacionGencat}'
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
											height: 300,
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
								    				allowBlank: true,		    			
								    				 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
					    						{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.operacionExenta'),
								    				reference: 'operacionExenta',
								    				name: 'operacionExenta',
								    				allowBlank: true,		    			
								    				colspan: 3,
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.renunciaExenta'),
								    				reference: 'renunciaExenta',
								    				name: 'renunciaExenta',
								    				allowBlank: true,		    			
								    				colspan: 3, 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.tipoImpositivo'),
								    				reference: 'tipoImpositivo',
								    				name: 'tipoImpositivo',
								    				allowBlank: true,		    			
								    				colspan: 3, 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.cuota'),
								    				reference: 'cuota',
								    				name: 'cuota',
								    				allowBlank: true,		    			
								    				 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
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
											height: 300,
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
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccBase'),
								    				reference: 'ccBase',
								    				name: 'ccBase',
								    				allowBlank: false,		    			
								    				 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppBase'),
								    				reference: 'ppBase',
								    				name: 'ppBase',
								    				allowBlank: false,		    			
								    				 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccEsp'),
								    				reference: 'ccEsp',
								    				name: 'ccEsp',
								    				allowBlank: true,		    			
								    				  
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppEsp'),
								    				reference: 'ppEsp',
								    				name: 'ppEsp',
								    				allowBlank: true,		    			
								    				  
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccTasas'),
								    				reference: 'ccTasas',
								    				name: 'ccTasas',
								    				allowBlank: true,		    			
								    				 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppTasas'),
								    				reference: 'ppTasas',
								    				name: 'ppTasas',
								    				allowBlank: true,		    			
								    				  
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccRecargo'),
								    				reference: 'ccRecargo',
								    				name: 'ccRecargo',
								    				allowBlank: true,		    			
								    				 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppRecargo'),
								    				reference: 'ppRecargo',
								    				name: 'ppRecargo',
								    				allowBlank: true,		    			
								    				  
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ccInteres'),
								    				reference: 'ccInteres',
								    				name: 'ccInteres',
								    				allowBlank: true,		    			
								    				 
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			},
								    			{
								    				xtype: "combobox",
								    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.ppInteres'),
								    				reference: 'ppInteres',
								    				name: 'ppInteres',
								    				allowBlank: true,		    			
								    				  
								    				bind: {
								    					store: '{comboNotificacionGencat}'
								    				}
								    				
								    			}
					    					]
						    			},
						    			// Fila inferior
						    			{
						    				xtype: "combobox",
						    				fieldLabel: HreRem.i18n('fieldlabel.gasto.linea.detalle.importeTotal'),
						    				reference: 'importeTotal',
						    				name: 'importeTotal',
						    				allowBlank: true,
						    				colspan: 3,
						    				margin: '0 0 10 0',
						    				readOnly: true,
						    				bind: {
						    					store: '{comboNotificacionGencat}'
						    				}
						    				
						    			}
						    			
						    		]
	    					}
	    				]
    				}
    	];

    	me.callParent();
    	
    	if(!Ext.isEmpty(me.record)){
    		var comboMotivoNotificacion = me.down('[reference="crearNotificacionFormRef"]').getForm().findField('motivoNotificacion'),
    			store = me.lookupController().getViewModel().get('comboNotificacionGencat'),
    			record = store.findRecord('descripcion', me.record.motivoNotificacion);
    		
				comboMotivoNotificacion.setValue(record.get('codigo'));
    	}
    }
});