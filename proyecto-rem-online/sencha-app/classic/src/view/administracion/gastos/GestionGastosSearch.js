Ext.define('HreRem.view.administracion.gastos.GestionGastosSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'gestiongastossearch',
    collapsible: true,
    collapsed: false, 
    layout: 'column',
	defaults: {
        xtype: 'fieldsettable',
        columnWidth: 1,
        cls: 'fieldsetCabecera',
        collapsed: true
    },
	    		

	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.filtro'));
    	me.removeCls('shadow-panel');
  		
    	me.buttonAlign = 'left';
    	me.buttons = [{ text: 'Buscar', handler: 'onClickGastosSearch' },{ text: 'Limpiar', handler: 'onCleanFiltersClick'}];
    	
	    me.items= [
	    
				    {

			    		title: HreRem.i18n('title.filtro.por.situacion.gasto'),
			    		defaultType: 'textfieldbase',
			    		defaults: {							        
							addUxReadOnlyEditFieldPlugin: false
						},
			    		items: [
			    		
			    			 { 
								xtype: 'comboboxfieldbase',
								name: 'estadoAutorizacionHayaCodigo',
				              	fieldLabel : 'Estado Autorización Haya',
								bind: {
									store: '{comboEstadoAutorizacionHaya}'
								}
							},
							{ 
								xtype: 'comboboxfieldbase',
								name: 'estadoAutorizacionPropietarioCodigo',
				              	fieldLabel : 'Estado Autorización Propietario',
								bind: {
									store: '{comboEstadoAutorizacionPropietario}'
								}
							},
							{
								xtype: 'comboboxfieldbase',
								name: 'estadoGastoCodigo',
				              	fieldLabel : 'Estado',
								bind: {
									store: '{estadosGasto}'
								}						
							}
				        				
						]
				    },
				    {
			    		title: HreRem.i18n('title.filtro.por.gasto'),
			    		defaultType: 'textfieldbase',
			    		defaults: {							        
							addUxReadOnlyEditFieldPlugin: false						    
						},
			    		items: [			    		
	    					{ 
						    	fieldLabel: HreRem.i18n('fieldlabel.numero.gasto'),
						        name: 'numGastoHaya'								            	
						    },
						    { 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.tipo'),
					        	reference: 'filtroComboTipoGasto',
					        	name: 'tipoGastoCodigo',
					        	bind: {
				            		store: '{comboTipoGasto}'
				            	},
								publishes: 'value'
			    						
							},
							{ 
						    	fieldLabel: HreRem.i18n('fieldlabel.importe.desde'),
						        name: 'importeDesde'								            	
						    },
						    { 
						    	fieldLabel: HreRem.i18n('fieldlabel.numero.gasto.gestoria'),
						        name: 'numGastoGestoria'								            	
						    },
						    { 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
					        	name: 'subtipoGastoCodigo',
					        	bind: {
				            		store: '{comboSubtipoGasto}',
				                    disabled: '{!filtroComboTipoGasto.value}',
				                    filters: {
				                        property: 'tipoGastoCodigo',
				                        value: '{filtroComboTipoGasto.value}'
				                    }
				            	}
					        },
    						{ 
						    	fieldLabel: HreRem.i18n('fieldlabel.importe.hasta'),
						        name: 'importeHasta'								            	
						    },
						    {
						    	fieldLabel: HreRem.i18n('fieldlabel.referencia.emisor'),
						        name: 'referenciaEmisor'						    	
						    },
						    { 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.necesita.autorizacion.propietario'),
					        	name: 'necesitaAutorizacionPropietario',
					        	bind: {
				            		store: '{comboSiNoRem}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
    						},
							{ 
			                	xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.tope.pago.desde'),
						 		name: 'fechaTopePagoDesde',
				            	formatter: 'date("d/m/Y")',
	            	        	listeners : {
					            	change: function (a, b) {
					            		//Eliminar la fechaHasta e instaurar
					            		//como minValue a su campo el valor de fechaDesde
					            		var me = this,
					            		fechaHasta = me.up('form').down('[name=fechaTopePagoHasta]');
					            		fechaHasta.reset();
					            		fechaHasta.setMinValue(me.getValue());
					                }
				            	}				            	
							},
							{ 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.destinatario'),
					        	name: 'destinatario',
					        	bind: {
				            		store: '{comboDestinatarios}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
    						},
    						{ 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.cubre.seguro'),
					        	name: 'cubreSeguro',
					        	bind: {
				            		store: '{comboSiNoRem}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
    						},
							{ 
			                	xtype:'datefieldbase',
						 		fieldLabel: HreRem.i18n('fieldlabel.fecha.tope.pago.hasta'),
						 		name: 'fechaTopePagoHasta',
						 		formatter: 'date("d/m/Y")'					 		
							},
							{ 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.periodicidad'),
					        	name: 'periodicidad',
					        	bind: {
				            		store: '{comboPeriodicidad}'
				            	},
				            	displayField: 'descripcion',
								valueField: 'codigo'
    						},
    						{ 
						    	fieldLabel: HreRem.i18n('fieldlabel.num.provision'),
						        name: 'numProvision'								            	
    						}
			    		]
				    },
				    {
						
			    		title: HreRem.i18n('title.filtro.por.proveedor'),
			    		defaultType: 'textfieldbase',
			    		defaults: {							        
							addUxReadOnlyEditFieldPlugin: false
						},
						hidden: $AU.userIsRol(CONST.PERFILES['PROVEEDOR']),
			    		items: [
			    		
			    			{ 
						    	fieldLabel: HreRem.i18n('fieldlabel.nif.proveedor'),
						        name: 'nifProveedor'
						    },			    		
					    	{ 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.tipo'),
					        	reference: 'filtroComboTipoProveedor',
					        	name: 'codigoTipoProveedor',
					        	bind: {
				            		store: '{comboTipoProveedor}'
				            	},
								publishes: 'value'
			    						
							},
    						{ 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
					        	name: 'codigoSubtipoProveedor',
					        	bind: {
				            		store: '{comboSubtipoProveedor}',
				                    disabled: '{!filtroComboTipoProveedor.value}',
				                    filters: {
				                        property: 'tipoEntidadCodigo',
				                        value: '{filtroComboTipoProveedor.value}'
				                    }
				            	}
					        },
						    { 
						    	fieldLabel: HreRem.i18n('fieldlabel.nombre.proveedor'),
						        name: 'nombreProveedor'								            	
						    }
				        				
						]
				    },
				    {
						
			    		title: HreRem.i18n('title.filtro.por.activo.agrupacion'),
			    		defaultType: 'textfieldbase',
			    		defaults: {							        
							addUxReadOnlyEditFieldPlugin: false
						},
			    		items: [
			    		
			    			{ 
						    	fieldLabel: HreRem.i18n('fieldlabel.numero.activo'),
						        name: 'numActivo'								            	
						    },    		
			    						    		
					    	{ 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.cartera'),
					        	reference: 'filtroEntidadPropietaria',
					        	name: 'entidadPropietariaCodigo',
					        	bind: {
				            		store: '{comboEntidadPropietaria}'
				            	},
				            	publish: 'value'
			    						
							},
							
							{ 
					        	xtype: 'comboboxfieldbase',
					        	fieldLabel: HreRem.i18n('fieldlabel.subcartera'),
					        	name: 'subentidadPropietariaCodigo',
					        	bind: {
				            		store: '{comboSubentidadPropietaria}',
				            		disabled: '{!filtroEntidadPropietaria.value}',
				                    filters: {
				                        property: 'carteraCodigo',
				                        value: '{filtroComboTipoGasto.value}'
				                    }
				            	}
			    						
							}
				        				
						]
				    }
	    ];
	   	
	    me.callParent();
	}
});