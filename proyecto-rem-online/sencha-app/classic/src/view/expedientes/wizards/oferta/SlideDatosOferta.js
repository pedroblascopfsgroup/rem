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
	isBankia: false,

	initComponent: function() {
		var me = this;
		var datosCartera = ('[reference="activosdetalle"]');
		var isBk = false;
		var activosDetalle = me.up('[reference="activosdetalle"]');
		
		if(Ext.isEmpty(activosDetalle)){
			isBk = this.up("agrupacionesdetalle").lookupController().getViewModel().get("esAgrupacionCaixa");
		}else{
			isBk = me.up('[reference="activosdetalle"]').lookupController().getViewModel().get('activo').get('isCarteraBankia');
		}
		me.isBankia = isBk;


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
	    							boxready: function(combo){
	    								var me = this;
	    								me.lookupController().getComboTipoOferta(combo);
    								},
	    							change: function(combo, value) {
	    								var me = this;	    
	    								var form = combo.up('form');
	    								var lockClaseOferta = form.down('field[name=claseOferta]');
	    								var checkNumOferPrin = form.down('field[name=numOferPrincipal]');
	    								var checkBuscadorOferta = form.down('field[name=buscadorNumOferPrincipal]');
	    								var viewModelSlide = this.up("slidedatosoferta").viewModel;
	    								var tipologivaVenta = form.down('field[name=tipologivaVentaCod]');
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
	    								
	    								if (viewModelSlide.data.esBankia && CONST.TIPOS_OFERTA['VENTA'] == value) {
	    									tipologivaVenta.setDisabled(false);
	    								}else{
	    									tipologivaVenta.setDisabled(true);
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
	    								var apellidos = form.down('field[name=apellidosCliente]');
	    								var nombre = form.down('field[name=nombreCliente]');
	    								var razonSocial = form.down('field[name=razonSocialCliente]');
	    								var tipoDocumentoRepresentante = form.down('field[name=codTipoDocumentoRte]');
	    								var numeroDocumentoRepresentante = form.down('field[name=numDocumentoRte]');
	    								var nombreRazonSocialRepresentante = form.down('field[name=nombreRazonSocialRte]');
	    								var apellidosRepresentante = form.down('field[name=apellidosRte]');
	    								var paisNacimientoRepresentante = form.down('field[name=paisNacimientoRepresentanteCodigo]');
	    								var provinciaNacimientoRepresentante = form.down('field[name=provinciaNacimientoRepresentanteCodigo]');
	    								var municipioNacimientoRepresentante = form.down('field[name=localidadNacimientoRepresentanteCodigo]');
	    								var fechaNacimientaRepresentante = form.down('field[name=fechaNacimientoRepresentante]');
	    								var paisRepresentante = form.down('field[name=codigoPaisRte]');
	    								var provinciaRepresentante = form.down('field[name=provinciaRteCodigo]');
	    								var municipioRepresentante = form.down('field[name=municipioRteCodigo]');
	    								var importe = form.down('field[name=importeOferta]');
	    								var tipoOferta = form.down('field[name=tipoOferta]');
	    								var nacionalidadCodigo = form.down('field[name=nacionalidadCodigo]');
	    								var nacionalidadRprCodigo = form.down('field[name=nacionalidadRprCodigo]');
	    								var fieldSetTableRepresentante = form.down('[reference=datosRepresentante]');
	    								if(value=="1"){
	    									estadoCivil.setDisabled(false);
	    									apellidos.setDisabled(false);
	    									nombre.setDisabled(false);
	    									razonSocial.setDisabled(true);
	    									estadoCivil.allowBlank = false;
	    									tipoDocumentoRepresentante.allowBlank = true;
	    									numeroDocumentoRepresentante.allowBlank = true;
	    									nombreRazonSocialRepresentante.allowBlank = true;
	    									apellidosRepresentante.allowBlank = true;
	    									paisNacimientoRepresentante.allowBlank = true;
	    									paisNacimientoRepresentante.setValue(null);
	    									provinciaNacimientoRepresentante.allowBlank = true;
	    									municipioNacimientoRepresentante.allowBlank = true;
	    									fechaNacimientaRepresentante.allowBlank = true;
	    									paisRepresentante.allowBlank = true;
	    									paisRepresentante.setValue(null);
	    									provinciaRepresentante.allowBlank = true;
	    									municipioRepresentante.allowBlank = true;
	    									
	    									if(isBk){
	    										nacionalidadCodigo.allowBlank = false;
	    										nacionalidadRprCodigo.allowBlank = true;
	    									}
	    									
	    									fieldSetTableRepresentante.setHidden(true);
	    									razonSocial.reset();
	    								}else{
	    									apellidos.setDisabled(true);
	    									nombre.setDisabled(true);
	    									razonSocial.setDisabled(false);
	    									estadoCivil.setDisabled(true);
	    									regimen.setDisabled(true);
	    									estadoCivil.allowBlank = true;
	    									tipoDocumentoRepresentante.allowBlank = false;
	    									numeroDocumentoRepresentante.allowBlank = false;
	    									nombreRazonSocialRepresentante.allowBlank = false;
	    									apellidosRepresentante.allowBlank = false;
	    									paisRepresentante.allowBlank = false;
	    									paisRepresentante.setValue("28");
	    									provinciaRepresentante.allowBlank = false;
	    									municipioRepresentante.allowBlank = false;
                                            fieldSetTableRepresentante.setHidden(false);
	    									if(isBk){
	    										paisNacimientoRepresentante.allowBlank = false;
		    									paisNacimientoRepresentante.setValue("28");
		    									provinciaNacimientoRepresentante.allowBlank = false;
		    									municipioNacimientoRepresentante.allowBlank = false;
		    									fechaNacimientaRepresentante.allowBlank = false;
		    									nacionalidadCodigo.allowBlank = true;
		    									nacionalidadRprCodigo.allowBlank = false;
	    									}
	    									
	    									apellidos.reset();
	    									nombre.reset();
	    									estadoCivil.reset();
	    									regimen.reset();
	    								}
	    								
	    								if(!Ext.isEmpty(importe)) importe.validate();
	    								if(!Ext.isEmpty(tipoOferta)) tipoOferta.validate();
	    								if(!Ext.isEmpty(estadoCivil)) estadoCivil.validate();
	    								if(!Ext.isEmpty(regimen)) regimen.validate();
	    								if(!Ext.isEmpty(apellidos)) apellidos.validate();
	    								if(!Ext.isEmpty(nombre)) nombre.validate();
	    								if(!Ext.isEmpty(razonSocial)) razonSocial.validate();
	    								if(!Ext.isEmpty(tipoDocumentoRepresentante)) tipoDocumentoRepresentante.validate();
	    								if(!Ext.isEmpty(numeroDocumentoRepresentante)) numeroDocumentoRepresentante.validate();
	    								if(!Ext.isEmpty(nombreRazonSocialRepresentante)) nombreRazonSocialRepresentante.validate();
	    								if(!Ext.isEmpty(apellidosRepresentante)) apellidosRepresentante.validate();
	    								if(!Ext.isEmpty(paisNacimientoRepresentante)) paisNacimientoRepresentante.validate();
	    								if(!Ext.isEmpty(provinciaNacimientoRepresentante)) provinciaNacimientoRepresentante.validate();
	    								if(!Ext.isEmpty(municipioNacimientoRepresentante)) municipioNacimientoRepresentante.validate();
	    								if(!Ext.isEmpty(fechaNacimientaRepresentante)) fechaNacimientaRepresentante.validate();
	    								if(!Ext.isEmpty(paisRepresentante)) paisRepresentante.validate();
	    								if(!Ext.isEmpty(provinciaRepresentante)) provinciaRepresentante.validate();
	    								if(!Ext.isEmpty(municipioRepresentante)) municipioRepresentante.validate();
	    								if(!Ext.isEmpty(nacionalidadCodigo)) nacionalidadCodigo.validate();
	    								if(!Ext.isEmpty(nacionalidadRprCodigo)) nacionalidadRprCodigo.validate()
	    								
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

			    				xtype : 'comboboxfieldbase',
								fieldLabel : HreRem.i18n('fieldlabel.oferta.subasta'),
								reference: 'subastaRef',
								name: 'checkSubasta',
								bind : {
									store : '{comboSiNoBoolean}',
									value : '{oferta.checkSubasta}',
									hidden: !isBk
								},
								colspan:2
			    			},
					        {
								xtype: 'comboboxfieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.vinculo.caixa'),
					        	itemId: 'vinculoCaixa',
					        	name: 'vinculoCaixa',
					        	flex:	1,
					        	span: 1,
					        	bind: {
				            		store: '{comboVinculoCaixa}',
				            		value: '{oferta.vinculoCaixaCodigo}',
				            		hidden: !isBk,
				            		allowBlank: isBk
				            	},
				            	displayField: 'descripcion',
	    						valueField: 'codigo',
	    						listeners: {
	    							change: function(combo, value) {
	    								var me = this;	   
	    								var form = combo.up('form');
	    								var sociedadEmpleado = form.down('field[name=sociedadEmpleadoCaixa]');
	    								var oficinaEmpleado = form.down('field[name=oficinaEmpleadoCaixa]');
		    							if(isBk){	
		    								if (value == "10") {
		    									sociedadEmpleado.setDisabled(false);
		    									sociedadEmpleado.allowBlank = false;
		    									oficinaEmpleado.setDisabled(false);
		    									oficinaEmpleado.allowBlank = false;
		    									
		    								}else{
		    									sociedadEmpleado.setDisabled(true);
		    									sociedadEmpleado.allowBlank = true;
		    									sociedadEmpleado.setValue(null);
		    									oficinaEmpleado.setDisabled(true);
		    									oficinaEmpleado.allowBlank = true;
		    									oficinaEmpleado.setValue(null);
		    									
		    									sociedadEmpleado.reset();
		    									oficinaEmpleado.reset();
		    								}
		    								
		    								if(!Ext.isEmpty(sociedadEmpleado)) sociedadEmpleado.validate();
		    								if(!Ext.isEmpty(oficinaEmpleado)) oficinaEmpleado.validate();
		    							}
	    							}
	    						}
							},
							{
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.sociedad.empleado.caixa'),
								reference: 'sociedadEmpleadoCaixa',
								name: 'sociedadEmpleadoCaixa',
								allowBlank: true,
								disabled: true,
								bind: {
				            		value: '{oferta.sociedadEmpleadoCaixa}',
				            		hidden: !isBk
				            	},
					        	colspan: 2
							},
							{
								xtype: 'textfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.oficina.empleado.caixa'),
								reference: 'oficinaEmpleadoCaixa',
								name: 'oficinaEmpleadoCaixa',
								allowBlank: true,
								disabled: true,
								bind: {
				            		value: '{oferta.oficinaEmpleadoCaixa}',
				            		hidden: !isBk
				            	}
							},
							{
								xtype: 'comboboxfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.antiguo.deudor'),
								reference: 'antiguoDeudor',
								name: 'antiguoDeudor',									
								bind: {
									store: '{comboSiNoBoolean}',
									value: '{oferta.antiguoDeudor}',
									allowBlank: !isBk,
									hidden: !isBk
								},								
					        	colspan: 2
							},
							{
								xtype: 'comboboxfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.tipologia.venta'),
								name: 		'tipologivaVentaCod',
								reference: 		'tipologivaVentaCodRef',
								disabled: true,
								bind: {
									store: '{comboTipologiaVentaBcOfr}',
									value: '{oferta.tipologivaVentaCod}',
									allowBlank: !isBk,
									hidden: !isBk
								},
								displayField: 'descripcion',
								valueField: 'codigo'
							},
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.nacionalidad.pais'),
								name: 'nacionalidadCodigo',
								reference: 'nacionalidadCodigo',
								allowBlank: !isBk,
								hidden: !isBk,
								bind: {
									store: '{comboPaises}',
									value: '{oferta.nacionalidadCodigo}'
								},
								displayField: 'descripcion',
								valueField: 'codigo'
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
							},
							{ 
					        	xtype:'datefieldbase',
					        	fieldLabel:  HreRem.i18n('fieldlabel.fecha.nacimiento.constitucion'),
					        	name: 'fechaNacimientoConstitucion',
					        	reference: 'fechaNacimientoConstitucion',
					        	allowBlank: !isBk,
								hidden: !isBk,
								bind: {
									value: '{oferta.fechaNacimientoConstitucion}'
								}
					        },
					        {
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.pais.nacimiento'),
								name: 'paisNacimientoCompradorCodigo',
								reference: 'paisNacimientoCompradorCodigoRef',
								allowBlank: !isBk,
								hidden: !isBk,
								bind: {
									store: '{comboPaises}',
									value: '{oferta.paisNacimientoCompradorCodigo}'
								},
								displayField: 'descripcion',
								valueField: 'codigo'
							},
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.provincia.nacimiento'),
								reference: 'provinciaNacimientoCompradorComboRef',
								name: 'provinciaNacimiento',
								allowBlank: !isBk,
								chainedStore: 'comboMunicipioNacimientoOfr',
								chainedReference: 'localidadNacimientoCompradorCodigoRef',
								hidden: !isBk,
								bind: {
									store: '{comboProvincia}',
									value: '{oferta.provinciaNacimiento}'
								}, 
								displayField: 'descripcion',
								valueField: 'codigo',
								listeners: {
									select: 'onChangeComboProvincia'
								}
							},
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.municipio.nacimiento'),
								reference: 'localidadNacimientoCompradorCodigoRef',
								name: 'localidadNacimientoCompradorCodigo',
								allowBlank: !isBk,
								hidden: !isBk,
								bind: {
									store: '{comboMunicipioNacimientoOfr}',
									disabled: '{!oferta.provinciaNacimiento}',
									value: '{oferta.localidadNacimientoCompradorCodigo}'
								},
								displayField: 'descripcion',
								valueField: 'codigo'
								
							},
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.pais'),
								name: 'codigoPais',
								reference: 'pais',
								allowBlank: false,
								bind: {
									store: '{comboPaises}',
									value: '{oferta.codigoPais}'
								},
								displayField: 'descripcion',
								valueField: 'codigo'
							},
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.provincia'),
								reference: 'provinciaCombo',
								name: 'provinciaCodigo',
								allowBlank: false,
								chainedStore: 'comboMunicipioOfr',
								chainedReference: 'municipioCombo',
								bind: {
									store: '{comboProvincia}',
									value: '{oferta.provinciaCodigo}'
								}, 
								displayField: 'descripcion',
								valueField: 'codigo',
								listeners: {
									select: 'onChangeComboProvincia'
								}
							},
							{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.municipio'),
								reference: 'municipioCombo',
								name: 'municipioCodigo',
								allowBlank: false,
								bind: {
									store: '{comboMunicipioOfr}',
									disabled: '{!oferta.provinciaCodigo}',
									value: '{oferta.municipioCodigo}'
								},
								displayField: 'descripcion',
								valueField: 'codigo'
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.direccion'),
								name: 'direccionTodos',
								reference: 'direccionTodos',
								allowBlank: false
							},
			                {
								fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
								bind:{
									value: '{oferta.codigoPostalNacimiento}'
								},
								name: 'codigoPostalNacimiento',
								vtype: 'codigoPostal',
								maskRe: /^\d*$/, 
			                	maxLength: 5,
			                	allowBlank: !isBk
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.email'),
								reference: 'emailNacimiento',
								bind:{
									value: '{oferta.emailNacimiento}'
								},
								name: 'emailNacimiento',
								vtype: 'email',
								allowBlank: !isBk
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.telefono1'),
								reference: 'telefonoNacimiento1',
								bind:{
									value: '{oferta.telefonoNacimiento1}'
								},
								name: 'telefonoNacimiento1',
								allowBlank: !isBk
							},
							{
								fieldLabel: HreRem.i18n('fieldlabel.telefono2'),
								reference: 'telefonoNacimiento2',
								bind:{
									value: '{oferta.telefonoNacimiento2}'
								},
								name: 'telefonoNacimiento2'
							},
							{
								xtype: 'comboboxfieldbase',
								fieldLabel:  HreRem.i18n('fieldlabel.prp'),
								name: 		'prp',								
								allowBlank: !isBk,
								hidden: !isBk,
								bind: {
									store: '{comboSiNoBoolean}',
									value: '{oferta.prp}'
								},								
					        	colspan: 1
							}
							
						]
				},
				{
					xtype: 'fieldsettable',
					collapsible: false,
					defaultType: 'textfieldbase',
					title: HreRem.i18n('title.datos.representante'),
					reference: 'datosRepresentante',
					bind:{
                        hidden: 'esPersonaJuridica'
					},
					disabled: false,
					layout: {
						type: 'table',
						columns: 2,
						tdAttrs: {
							width: '50%'
						}
					},
					defaults: {
						addUxReadOnlyEditFieldPlugin: false
					},
					items: [{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
							name: 'codTipoDocumentoRte',
							reference: 'tipoDocumentoRte',
							padding: '5px',
							bind: {
								store: '{comboTipoDocumento}'
							}
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
							reference: 'numeroDocumentoRte',
							name: 'numDocumentoRte',
							padding: '5px'
						},
						{
							fieldLabel: HreRem.i18n('header.nombre.razon.social'),
							reference: 'nombreRazonSocialRte',
							name: 'nombreRazonSocialRte',
							padding: '5px'
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.apellidos'),
							reference: 'apellidosRte',
							name: 'apellidosRte',
							padding: '5px'
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.nacionalidad.pais'),
							name: 'nacionalidadRprCodigo',
							reference: 'nacionalidadRprCodigo',
							padding: '5px',
							allowBlank: !isBk,
							hidden: !isBk,
							bind: {
								store: '{comboPaises}',
								value: '{oferta.nacionalidadRprCodigo}'
							},
							displayField: 'descripcion',
							valueField: 'codigo'
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.pais.nacimiento'),
							reference: 'paisNacimientoRepresentanteCodigo',
							name: 'paisNacimientoRepresentanteCodigo',
							padding: '5px',
							hidden: !isBk,
							bind: {
								store: '{comboPaises}'
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.provincia.nacimiento'),
							reference: 'provinciaNacimientoRepresentanteCodigo',
							name: 'provinciaNacimientoRepresentanteCodigo',
							padding: '5px',
							chainedStore: 'comboMunicipioNacimientoRrp',
							chainedReference: 'localidadNacimientoRepresentanteCodigo',
							hidden: !isBk,
							bind: {
								store: '{comboProvincia}',
								value: '{oferta.provinciaNacimientoRepresentanteCodigo}'
							},
							displayField: 'descripcion',
							valueField: 'codigo',
							listeners: {
								select: 'onChangeComboProvincia'
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.municipio.nacimiento'),
							reference: 'localidadNacimientoRepresentanteCodigo',
							name: 'localidadNacimientoRepresentanteCodigo',
							padding: '5px',
							hidden: !isBk,
							bind: {
								store: '{comboMunicipioNacimientoRrp}',
								disabled: '{!oferta.provinciaNacimientoRepresentanteCodigo}',
								value: '{oferta.localidadNacimientoRepresentanteCodigo}'
							}
						},
						{ 
				        	xtype:'datefieldbase',
				        	fieldLabel:  HreRem.i18n('fieldlabel.fecha.nacimiento.constitucion'),
				        	name: 'fechaNacimientoRepresentante',
				        	reference: 'fechaNacimientoRepresentante',
				        	padding: '5px',
				        	hidden: !isBk
				        },
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.pais.residencia'),
							reference: 'paisRte',
							name: 'codigoPaisRte',
							padding: '5px',
							bind: {
								store: '{comboPaises}'
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.provincia.residencia'),
							reference: 'provinciaComboRte',
							name: 'provinciaRteCodigo',
							chainedStore: 'comboMunicipioRpr',
							chainedReference: 'municipioComboRte',
							padding: '5px',
							bind: {
								store: '{comboProvincia}',
								value: '{oferta.provinciaRteCodigo}'
							},
							listeners: {
								select: 'onChangeComboProvincia'
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.municipio.residencia'),
							reference: 'municipioComboRte',
							name: 'municipioRteCodigo',
							padding: '5px',
							bind: {
								store: '{comboMunicipioRpr}',
								disabled: '{!oferta.provinciaRteCodigo}',
								value: '{oferta.municipioRteCodigo}'
							}
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
							reference: 'codigoPostalRte',
							name: 'codigoPostalRte',
							padding: '5px',
							vtype: 'codigoPostal',
							maskRe: /^\d*$/, 
		                	maxLength: 5
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.direccion'),
							name: 'direccionRte',
							reference: 'direccionRte',
							padding: '5px'
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.email'),
							reference: 'emailRte',
							name: 'emailRte',
							padding: '5px',
							vtype: 'email'
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.telefono1'),
							reference: 'telefono1Rte',
							name: 'telefono1Rte',
							padding: '5px'
						},
						{
							fieldLabel: HreRem.i18n('fieldlabel.telefono2'),
							reference: 'telefono2Rte',
							name: 'telefono2Rte',
							padding: '5px'
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.prp'),
							reference: 'representantePrp',
							name: 'representantePrp',
							padding: '5px',
							hidden: !isBk,
							bind: {
								store: '{comboSiNoBoolean}'
							}
						}
					]
				}
		];
		
		me.callParent();
	}

});