Ext.define('HreRem.view.expedientes.wizards.oferta.SlideDatosOferta', {
	extend: 'Ext.form.Panel',
	xtype: 'slidedatosoferta',
	layout: {
		type: 'vbox',
		align: 'stretch'
	},
	bodyPadding: '0',
	margin: '0',
	cls: 'panel-base',
	scrollable: 'y',
	defaults: {
		addUxReadOnlyEditFieldPlugin: false,
		margin: '10px 20px'
	},
	requires: [
		'HreRem.view.expedientes.wizards.oferta.SlideDatosOfertaController',
		'HreRem.view.expedientes.wizards.oferta.SlideDatosOfertaModel'
	],

	listeners: {
		activate: 'onActivate'
	},

	controller: 'slidedatosoferta',
	viewModel: {
		type: 'slidedatosoferta'
	},

	initComponent: function() {
		var me = this;

		me.buttons = [ { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickCancelar'},
			{itemId: 'btnGuardar',
    		text: 'Crear',
    		handler: 'onClickCrearOferta'}];

		me.items = [
			{				
						xtype:'fieldset',
						cls	: 'panel-base shadow-panel',
						title: HreRem.i18n('title.nueva.oferta'),
						layout: {
					        type: 'table',
					        // The total column count must be specified here
					        columns: 2,
					        //trAttrs: {height: '45px', width: '50%'},
					        tdAttrs: {width: '50%'},
					        tableAttrs: {
					            style: {
					                width: '100%',
					                margin: '10px 0 0 10px'
								}
					        }
						},
						defaultType: 'textfieldbase',
						collapsed: false,
						scrollable	: 'y',	    				
		            	items: [
		            	    {
		            	    	name:		'cesionDatos',
								bind:		'{oferta.cesionDatosHaya}',
								hidden:		true
		            	    },
		            	    {
		            	    	name:		'comunicacionTerceros',
								bind:		'{oferta.comunicacionTerceros}',
								hidden:		true
		            	    },
		            	    {
		            	    	name:		'transferenciasInternacionales',
								bind:		'{oferta.transferenciasInternacionales}',
								hidden:		true
		            	    },
		            	    {
		            	    	name:		'pedirDoc',
								bind:		'{oferta.pedirDoc}',
								hidden:		true
		            	    },
		            	    {
		            	    	name:		'telefono',
								bind:		'{oferta.telefono}',
								hidden:		true
		            	    }
		            	    ,
		            	    {
		            	    	name:		'direccion',
								bind:		'{oferta.direccion}',
								hidden:		true
		            	    }
		            	    ,
		            	    {
		            	    	name:		'email',
								bind:		'{oferta.email}',
								hidden:		true
		            	    },
							{
								xtype:      'currencyfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.importe'),
								name:       'importeOferta',
								flex: 		1,
								allowBlank: false,
								bind:		'{oferta.importeOferta}'
							},
							{
								xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('header.oferta.tipoOferta'),
					        	itemId: 'comboTipoOferta',
					        	name: 'tipoOferta',
					        	flex:	1,
					        	allowBlank: false,
					        	bind: {
				            		store: '{comboTipoOferta}',
				            		value: '{oferta.tipoOferta}'
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo',	    						
	    						listeners: {
	    							change: function(combo, value) {
	    								var me = this;	    								
	    								var form = combo.up('form');
	    								var lockClaseOferta = form.down('field[name=claseOferta]');
	    								var checkNumOferPrin = form.down('field[name=numOferPrincipal]');
	    								var checkBuscadorOferta = form.down('field[name=buscadorNumOferPrincipal]');
	    								var viewModelSlide = this.up("slidedatosoferta").viewModel;
	    								
	    								if((viewModelSlide.data.esAgrupacionLiberbank || viewModelSlide.data.isCarteraLiberbank)
	    										&& CONST.TIPOS_OFERTA['VENTA'] == value ) {	    										
	    										    											    										
	    									lockClaseOferta.setHidden(false);
	    									checkNumOferPrin.setHidden(false);
	    									checkBuscadorOferta.setHidden(false);
	    									lockClaseOferta.setDisabled(false);
	    									checkNumOferPrin.setDisabled(false);
	    									checkBuscadorOferta.setDisabled(true);
	    								} else {
	    									lockClaseOferta.setHidden(true);
	    									checkNumOferPrin.setHidden(true);
	    									checkBuscadorOferta.setHidden(true);
	    									lockClaseOferta.setDisabled(true);
	    									checkNumOferPrin.setDisabled(true);
	    									checkBuscadorOferta.setDisabled(true);
	    								}	    									    								
	    							}
	    						},
			    				colspan: 2
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.nombre.cliente'),
		            	    	name:		'nombreCliente',
		            	    	allowBlank: false,
								bind: {
									value: '{oferta.nombreCliente}',
									disabled: '{oferta.razonSocialCliente}',
									allowBlank: '{oferta.razonSocialCliente}'
								}								
		            	    },
		            	    {
		            	    	fieldLabel: HreRem.i18n('fieldlabel.apellidos.cliente'),
		            	    	name:		'apellidosCliente',
		            	    	allowBlank: false,
								bind:		{
									value: '{oferta.apellidosCliente}',
									disabled: '{oferta.razonSocialCliente}'
								},
			    				colspan: 2
		            	    },
		            	    {
		            	    	fieldLabel: HreRem.i18n('fieldlabel.razonSocial.cliente'),
		            	    	name:		'razonSocialCliente',
		            	    	allowBlank: false,
								bind:		{
									value :'{oferta.razonSocialCliente}',
									disabled: '{oferta.nombreCliente}',
									allowBlank: '{oferta.nombreCliente}'
								}
		            	    },
		            	    {
								xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.tipoDocumento'),
					        	itemId: 'comboTipoDocumento',
					        	name:   'tipoDocumento',
					        	allowBlank: false,
					        	flex:	1,
					        	bind: {
				            		store: '{comboTipoDocumento}',
				            		value: '{oferta.tipoDocumento}'
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo',
			    				colspan: 2
							},
		            	    {
		            	    	fieldLabel: HreRem.i18n('fieldlabel.documento.cliente'),
		            	    	name:		'numDocumentoCliente',
		            	    	allowBlank: false,
								bind:		'{oferta.numDocumentoCliente}'
		            	    },
		            	    {
								xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.tipo.persona'),
					        	itemId: 'comboTipoPersona',
					        	name: 'tipoPersona',
					        	flex:	1,
					        	allowBlank: false,
					        	bind: {
				            		store: '{comboTipoPersona}',
				            		value: '{oferta.tipoPersona}'
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo',
	    						listeners: {
	    							change: function(combo, value) {
	    								var me = this;
	    								var form = combo.up('form');
	    								var estadoCivil = form.down('field[name=estadoCivil]');
	    								var regimen = form.down('field[name=regimenMatrimonial]');
	    								if(value=="1"){
	    									estadoCivil.setDisabled(false);
	    									estadoCivil.allowBlank = false;
	    								}else{
	    									estadoCivil.setDisabled(true);
	    									regimen.setDisabled(true);
	    									estadoCivil.allowBlank = true;
	    									
	    									estadoCivil.reset();
	    									regimen.reset();
	    								}
	    								
	    							}
	    						},
			    				colspan: 2
							},
							{
								xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.estado.civil'),
					        	itemId: 'comboEstadoCivil',
					        	name: 'estadoCivil',
					        	flex:	1,
					        	allowBlank: true,
					        	bind: {
				            		store: '{comboEstadoCivil}',
				            		value: '{oferta.estadoCivil}'
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo',
	    						disabled: true,
	    						listeners: {
	    							change: function(combo, value) {
	    								var me = this;
	    								var form = combo.up('form');
	    								var regimen = form.down('field[name=regimenMatrimonial]');
	    								if(value=="02"){
	    									regimen.setDisabled(false);
	    									regimen.allowBlank = false;
	    								}else{
	    									regimen.setDisabled(true);
	    									regimen.allowBlank = true;
	    									regimen.reset();
	    								}
	    								
	    							}
	    						}
							},
							{
								xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('header.regimen.matrimonial'),
					        	itemId: 'comboRegimenMatrimonial',
					        	name: 'regimenMatrimonial',
					        	flex:	1,
					        	allowBlank: true,
					        	bind: {
				            		store: '{comboRegimenMatrimonial}',
				            		value: '{oferta.regimenMatrimonial}'
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo',
	    						disabled: true,
			    				colspan: 2
							},
		            	    {
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('header.visita.detalle.proveedor.presriptor.codigo.rem'),
								name: 'buscadorPrescriptores',
								maskRe: /[0-9.]/,
								//disabled: true,
								bind: {
									value: '{oferta.codigoPrescriptor}'
								},
								allowBlank: false,
								triggers: {									
										buscarEmisor: {
								            cls: Ext.baseCSSPrefix + 'form-search-trigger',
								            handler: 'buscarPrescriptor'
								        }
								},
								cls: 'searchfield-input sf-con-borde',
								emptyText:  'Introduce el código del Prescriptor',
								enableKeyEvents: true,
						        listeners: {
						        	specialKey: function(field, e) {
						        		if (e.getKey() === e.ENTER) {
						        			field.lookupController().buscarPrescriptor(field);											        			
						        		}
						        	}
						        }
		                	},
		                	{
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.codigo.sucursalreserva'),
								name: 'buscadorSucursales',
								maskRe: /^\d{1,4}$/,
								maxLength: 4,
								//disabled: true,
								bind: {
									value: '{oferta.codigoSucursal}'
								},
								allowBlank: true,
								triggers: {
										buscarEmisor: {
								            cls: Ext.baseCSSPrefix + 'form-search-trigger',
								            handler: 'buscarSucursal'
								        }
								},
								cls: 'searchfield-input sf-con-borde',
								emptyText:  'Introduce el código de la Sucursal',
								enableKeyEvents: true,
						        listeners: {
						        	specialKey: function(field, e) {
						        		if (e.getKey() === e.ENTER) {
						        			field.lookupController().buscarSucursal(field);											        			
						        		}
						        	}
						        },

					        	colspan: 2

		                	},
		                	{
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.prescriptor'),
								name: 'nombrePrescriptor',
								//disabled: true,
								readOnly: true,
								allowBlank: false
							},
		                	{
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.sucursalreserva'),
								name: 'nombreSucursal',
								//disabled: true,
								readOnly: true,
								allowBlank: true,
					        	colspan: 2
							},
		            	    {
								xtype: 		'checkboxfieldbase',
		            	    	fieldLabel:	HreRem.i18n('fieldlabel.intencionfinanciar'),
		            	    	name:		'intencionfinanciar',
		            	    	allowBlank:	false,
		            	    	bind:		'{oferta.intencionFinanciar}',
					        	inputValue: true
					        },
							{
								xtype: 'comboboxfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.claseOferta'),
								itemId: 'comboClaseOferta',
								name: 'claseOferta',								
								flex:	1,
					        	colspan: 2,
								allowBlank: false,
								bind: {											
									store: '{comboClaseOferta}',
									value: '{oferta.claseOferta}'
								},							
								displayField: 'descripcion',
								valueField: 'codigo',
								listeners: {
	    							change: function(combo, value) {
	    								var me = this;
	    								var form = combo.up('form');
	    								var checkNumOferPrin = form.down('field[name=numOferPrincipal]');
	    								checkNumOferPrin.reset();
	    								checkNumOferPrin.setDisabled("02" != value);
	    								checkNumOferPrin.setAllowBlank("02" != value);
	    								var buscaNumOferPrin = form.down('field[name=buscadorNumOferPrincipal]');
	    								buscaNumOferPrin.reset();
    									buscaNumOferPrin.setDisabled("02" != value);
    									buscaNumOferPrin.setAllowBlank("02" != value);
	    							}
	    						}
							},
		            	    {
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.buscador.oferta'),
								name: 'buscadorNumOferPrincipal',
								maskRe: /[0-9.]/,
								bind: {									
									value: '{oferta.buscadorNumOferPrincipal}'										
								},								
								allowBlank: true,								
	    						disabled: true,	    						
								triggers: {
									
										buscarNumOferta: {
								            cls: Ext.baseCSSPrefix + 'form-search-trigger',
								            handler: 'buscarOferta'
								        }
								},
								cls: 'searchfield-input sf-con-borde',
								emptyText:  'Introduce el número de la oferta principal',
								enableKeyEvents: true,
						        listeners: {
						        	specialKey: function(field, e) {
						        		if (e.getKey() === e.ENTER) {
						        			field.lookupController().buscarOferta(field);											        			
						        		}
						        	}
						        }
		                	},
							{
								xtype: 'textfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.numOferPrincipal'),
								name: 		'numOferPrincipal',								
								readOnly: true,								
								allowBlank: true,
								bind: {
									value: '{oferta.numOferPrincipal}'
								},								
					        	colspan: 2
							}
						]
				}
		];
		
		me.callParent();
	}

});