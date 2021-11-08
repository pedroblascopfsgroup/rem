Ext.define('HreRem.view.expedientes.wizards.comprador.SlideDatosComprador', {
	extend: 'Ext.form.Panel',
	xtype: 'slidedatoscomprador',
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
		'HreRem.view.expedientes.wizards.comprador.SlideDatosCompradorController',
		'HreRem.view.expedientes.wizards.comprador.SlideDatosCompradorModel',
		'HreRem.model.FichaComprador'
	],

	listeners: {
		boxReady: 'onActivate'
	},

	controller: 'slidedatoscomprador',
	viewModel: {
		type: 'slidedatoscomprador'
	},

	initComponent: function() {
		var me = this;
		me.buttons = [{
				text: HreRem.i18n('btn.cancelBtnText'),
				handler: 'onClickCancelar'
			},
			{
				text: !Ext.isEmpty(me.up('wizardBase').idComprador) ? HreRem.i18n('btn.modificar') : HreRem.i18n('btn.crear.comprador'),
				handler: 'onClickContinuar',
				disabled: !Ext.isEmpty(me.up('wizardBase').idComprador) ? !this.lookupController().permitirEdicionDatos() : false
			}
		];
		
		me.items = [
			{
				xtype: 'label',
				cls: '.texto-alerta',
				bind: {
					html: '{textoAdvertenciaProblemasUrsus}'
				},
				style: 'color: red'
	        },
			{
				xtype: 'checkboxfieldbase',
				name: 'cesionDatos',
				hidden: true
			},
			{
				xtype: 'checkboxfieldbase',
				name: 'comunicacionTerceros',
				hidden: true
			},
			{
				xtype: 'checkboxfieldbase',
				name: 'transferenciasInternacionales',
				hidden: true
			},
			{
				xtype: 'textfieldbase',
				name: 'pedirDoc',
				hidden: true
			},
			{
				xtype: 'fieldsettable',
				collapsible: false,
				hidden: this.lookupController().permitirEdicionDatos(),
				items: [{
					xtype: 'label',
					text: HreRem.i18n('fieldlabel.no.modificar.compradores'),
					margin: '10px 0 0 10px',
					style: 'font-weight: bold'
				}]
			},
			{
				xtype: 'fieldsettable',
				collapsible: false,
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.gasto.datos.generales'),
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
						fieldLabel: HreRem.i18n('fieldlabel.tipo.persona'),
						reference: 'tipoPersona',
						name: 'codTipoPersona',
						margin: '10px 0 10px 0',
						padding: '5px',
						bind: {
							store: '{comboTipoPersona}'
						},
						allowBlank: false,
						listeners: {
							change: 'comprobarObligatoriedadCamposNexos'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.titular.reserva'),
						reference: 'titularReserva',
						name: 'titularReserva',
						hidden: true,
						padding: '5px',
						bind: {
							store: '{comboSiNoRem}'
						}
					},
					{
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.porcion.compra'),
						reference: 'porcionCompra',
						name: 'porcentajeCompra',
						maxValue: 100,
						minValue: 0,
						padding: '5px',
						allowBlank: false
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.titular.contratacion'),
						reference: 'titularContratacionWizard',
						name: 'titularContratacion',
						padding: '5px',
						bind: {
							store: '{comboSiNoRem}',
							hidden: '{!comprador.titularContratacion}'
						},
						disabled: true
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.grado.propiedad'),
						reference: 'gradoPropiedad',
						name: 'codigoGradoPropiedad',
						padding: '5px',
						bind: {
							store: '{comboTipoGradoPropiedad}'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.usufructuario'),
						reference: 'usufructuarioRef',
						name: 'usufructuario',
						padding: '5px',
						bind: {
							store: '{comboSiNoRem}',
							hidden: '{!comprador.esCarteraBankia}'
						}
					},
					{ 
			        	fieldLabel:  HreRem.i18n('fieldlabel.idBC'),
			        	name: 'idBC4C',
			        	reference: 'idBC4C',
			        	padding: '5px',
			        	readOnly: true,
			        	bind: {
			        		hidden: '{!comprador.esCarteraBankia}'
			        	}
			        }
				]
			},
			{
				xtype: 'fieldsettable',
				collapsible: false,
				defaultType: 'textfieldbase',
				title: HreRem.i18n('fieldlabel.datos.identificacion'),
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
						name: 'codTipoDocumento',
						reference: 'tipoDocumento',
						margin: '10px 0 10px 0',
						padding: '5px',
						bind: {
							store: '{comboTipoDocumento}'
						},
						allowBlank: false
					},

					{
						fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
						name: 'numDocumento',
						reference: 'numeroDocumento',
						padding: '5px',
						listeners: {
							change: 'onNumeroDocumentoChange'
						},
						allowBlank: false
					},
					{
						fieldLabel: HreRem.i18n('header.nombre.razon.social'),
						name: 'nombreRazonSocial',
						reference: 'nombreRazonSocial',
						padding: '5px',
						allowBlank: false
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.apellidos'),
						name: 'apellidos',
						reference: 'apellidos',
						padding: '5px',
						allowBlank: false
					},
			        { 
			        	fieldLabel:  HreRem.i18n('fieldlabel.formaJuridica'),
			        	name: 'formaJuridica',
			        	reference: 'formaJuridica',
			        	padding: '5px',
			        	readOnly: true,
			        	bind: {
			        		hidden: '{!comprador.esCarteraBankia}'
			        	}
			        },
			        {
			        	xtype: 'displayfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.campo.vacio'),
			        	padding: '5px',
			        	readOnly: true,
			        	allowBlank:true
			        },
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.pais.nacimiento'),
						name: 'paisNacimientoCompradorCodigo',
						reference: 'paisNacimientoCompradorCodigo',
						padding: '5px',
						bind: {
							allowBlank: '{!comprador.esCarteraBankia}',
							store: '{comboPaises}',
							hidden: '{!comprador.esCarteraBankia}'
						}
					},
					{

						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.provincia.nacimiento'),
						reference: 'provinciaNacimientoCompradorCodigo',
						name: 'provinciaNacimientoCompradorCodigo',
						padding: '5px',
						chainedStore: 'comboMunicipioComprador',
						chainedReference: 'localidadNacimientoCompradorCodigo',
						bind: {
							allowBlank: '{!comprador.esCarteraBankia}',
							store: '{comboProvincia}',
							hidden: '{!comprador.esCarteraBankia}'
						},
						displayField: 'descripcion',
						valueField: 'codigo',
						listeners: {
							change: 'onChangeComboProvincia'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio.nacimiento'),
						reference: 'localidadNacimientoCompradorCodigo',
						name: 'localidadNacimientoCompradorCodigo',
						padding: '5px',
						bind: {
							store: '{comboMunicipioComprador}',
							hidden: '{!comprador.esCarteraBankia}',
							disabled: '{!comprador.provinciaNacimientoCompradorCodigo}',
							allowBlank: '{!comprador.esCarteraBankia}'
						}
					},
					{ 
			        	xtype:'datefieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.fecha.nacimiento.constitucion'),
			        	name: 'fechaNacimientoConstitucion',
			        	reference: 'fechaNacimientoConstitucion',
			        	padding: '5px',
			        	maxValue: null,
			        	bind: {
			        		hidden: '{!comprador.esCarteraBankia}',
			        		allowBlank: '{!comprador.esCarteraBankia}',
			        		hidden: '{!comprador.esCarteraBankia}'
			        	}
			        },
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.pais.residencia'),
						name: 'codigoPais',
						reference: 'pais',
						padding: '5px',
						allowBlank: false,
						bind: {
							store: '{comboPaises}',
							allowBlank: '{esObligatorio}'
						},
						listeners: {
							change: 'comprobarObligatoriedadRte'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.provincia.residencia'),
						reference: 'provinciaCombo',
						name: 'provinciaCodigo',
						padding: '5px',
						allowBlank: false,
						chainedStore: 'comboMunicipio',
						chainedReference: 'municipioCombo',
						bind: {
							store: '{comboProvincia}'//,
							//value: '{comprador.provinciaCodigo}'
						},
						displayField: 'descripcion',
						valueField: 'codigo',
						listeners: {
							change: 'onChangeComboProvincia'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio.residencia'),
						reference: 'municipioCombo',
						name: 'municipioCodigo',
						allowBlank: false,
						padding: '5px',
						bind: {
							store: '{comboMunicipio}',
							disabled: '{!comprador.provinciaCodigo}'//,
							//value: '{comprador.municipioCodigo}'
						}
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
						name: 'codigoPostal',
						reference: 'codigoPostal',
						padding: '5px',
						vtype: 'codigoPostal',
						maskRe: /^\d*$/, 
	                	maxLength: 5
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.direccion'),
						name: 'direccion',
						reference: 'direccion',
						padding: '5px',
						allowBlank: false,
						bind: {
							allowBlank: '{esObligatorio}'
						}
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.email'),
						name: 'email',
						reference: 'email',
						padding: '5px',
						vtype: 'email'
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.telefono1'),
						name: 'telefono1',
						reference: 'telefono1',
						padding: '5px'
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.telefono2'),
						name: 'telefono2',
						reference: 'telefono2',
						padding: '5px'
					},
					{
						xtype: 'container',
						layout: {
							type: 'table',
							columns: 2
						},
						padding: '5px',
						defaults: {
							addUxReadOnlyEditFieldPlugin: false
						},
						items: [{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('title.windows.datos.cliente.ursus'),
								reference: 'seleccionClienteUrsus',
								name: 'seleccionClienteUrsus',
								bind: {
									store: '{comboClienteUrsus}',
									hidden: true
								},
								listeners: {
									change: 'establecerNumClienteURSUS',
									expand: 'buscarClientesUrsus'
								},
								valueField: 'numeroClienteUrsus',
								displayField: 'nombreYApellidosTitularDeOferta',
								recargarField: false,
								queryMode: 'local',
								autoLoadOnValue: false,
								loadOnBind: false,
								allowBlank: true,
								disabled: this.lookupController().habilitarClienteUrsus()
							},
							{
								xtype: 'button',
								handler: 'onClickVerDetalleClienteUrsus',
								bind: {
									hidden: true
								},
								reference: 'btnVerDatosClienteUrsus',
								disabled: this.lookupController().habilitarLupaClientes(),
								cls: 'search-button-buscador',
								iconCls: 'app-buscador-ico ico-search'
							}
						]
					},
					{
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('header.numero.ursus'),
						reference: 'numeroClienteUrsusRef',
						name: 'numeroClienteUrsus',
						padding: '5px',
						bind: {
							hidden: true,
							readOnly: true
						},
						editable: true
					},
					{
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('header.numero.ursus.bh'),
						reference: 'numeroClienteUrsusBhRef',
						name: 'numeroClienteUrsusBh',
						padding: '5px',
						bind: {
							hidden: true,
							readOnly: true
						},
						editable: true
					}
				]
			},
			{
				xtype: 'fieldsettable',
				collapsible: false,
				defaultType: 'textfieldbase',
				reference: 'cambioTitulo',
				listeners: {
					boxready: 'onLoadCambiaTituloRemoNexos'
				},
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
						fieldLabel: HreRem.i18n('fieldlabel.vinculo.caixa'),
						reference: 'vinculoCaixaCodigo',
						name: 'vinculoCaixaCodigo',
						padding: '5px',
						bind: {
							store: '{comboVinculoCaixa}',
							hidden: '{!comprador.esCarteraBankia}'
						},
						listeners:{
							focus: function(){
								var me = this;
								if(!Ext.isEmpty(me.getStore())){
									me.getStore().insert(0, [{codigo: null , descripcion: '-', id: 0}]);
								}
							},
							change: function(combo, value) {
								var me = this;	   
								var form = combo.up('form');
								var sociedadEmpleado = form.down('field[name=sociedad]');
								var oficinaEmpleado = form.down('field[name=oficinaTrabajo]');
								
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
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.prp'),
						reference: 'compradorPrpRef',
						name: 'compradorPrp',
						padding: '5px',
						bind: {
							store: '{comboSiNoBoolean}',
							hidden: '{!comprador.esCarteraBankia}'
						}
					},
					{
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.sociedad.empleado.caixa'),
						reference: 'sociedad',
						name: 'sociedad',
						allowBlank: true,
						disabled: true,
						bind: {
							hidden: '{!comprador.esCarteraBankia}'
						},
						padding: '5px'
					},
					{
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.oficina.empleado.caixa'),
						reference: 'oficinaTrabajo',
						name: 'oficinaTrabajo',
						allowBlank: true,
						disabled: true,
						bind: {
							hidden: '{!comprador.esCarteraBankia}'
						},
						padding: '5px'
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.relacion.hre'),
						reference: 'relacionHre',
						name: 'relacionHre',
						padding: '5px'
					},
			        {
						xtype: 'displayfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.campo.vacio'),
			        	padding: '5px',
			        	readOnly: true,
			        	allowBlank:true
			        },
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.antiguo.deudor'),
						reference: 'antiguoDeudor',
						name: 'antiguoDeudor',
						padding: '5px',
						allowBlank: false,
						bind: {
							store: '{comboSiNoRem}'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.relacion.ant.deudor'),
						reference: 'relacionAntDeudor',
						name: 'relacionAntDeudor',
						padding: '5px',
						bind: {
							store: '{comboSiNoRem}'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.estado.civil'),
						name: 'codEstadoCivil',
						valueField: 'codigo',
						reference: 'estadoCivil',
						padding: '5px',
						bind: {
							store: '{comboEstadoCivilCustom}'
						},						
						autoLoadOnValue: true,
						listeners: {
							change: 'comprobarObligatoriedadCamposNexos'
						},
						allowBlank: true
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.regimen.economico'),
						name: 'codigoRegimenMatrimonial',
						valueField: 'codigo',
						reference: 'regimenMatrimonial',
						padding: '5px',
						bind: {
							store: '{comboRegimenesMatrimoniales}'
						},
						listeners: {
							change: 'comprobarObligatoriedadCamposNexos'
						},
						allowBlank: true,
						disabled: true
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.tipo.documento.conyuge'),
						reference: 'tipoDocConyuge',
						name: 'codTipoDocumentoConyuge',
						editable: true,
						allowBlank:true,
						padding: '5px',
						bind: {
							store: '{comboTipoDocumento}'
						},
						listeners: {
							change: 'comprobarObligatoriedadCamposNexos'
						}
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.num.reg.conyuge'),
						reference: 'numRegConyuge',
						name: 'documentoConyuge',
						padding: '5px',
						listeners: {
							change: 'onNumeroDocumentoChange'
						},
						allowBlank:true
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.cliente.ursus.conyuge'),
						reference: 'seleccionClienteUrsusConyuge',
						padding: '5px',
						bind: {
							store: '{comboClienteUrsusConyuge}',
							hidden: true
//							hidden: !this.lookupController().esBankia()
						},
						listeners: {
							change: 'establecerNumClienteURSUSConyuge',
							expand: 'buscarClientesUrsusConyuge'
						},
						valueField: 'numeroClienteUrsus',
						displayField: 'nombreYApellidosTitularDeOferta',
						recargarField: false,
						queryMode: 'local',
						autoLoadOnValue: false,
						loadOnBind: false,
						allowBlank:true
					},
					{
						xtype: 'textfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.numero.ursus.conyuge'),
						reference: 'numeroClienteUrsusRefConyuge',
						name: 'numeroClienteUrsusConyuge',
						padding: '5px',
						hidden: true,
//						hidden: this.lookupController().esBankiaBH()|| !this.lookupController().esBankia(),
						editable: false
					},
					{
						xtype: 'textfieldbase',
						fieldLabel:  HreRem.i18n('fieldlabel.numero.ursus.bh.conyuge'),
						reference: 'numeroClienteUrsusBhRefConyuge',
						name: 'numeroClienteUrsusBhConyuge',
						padding: '5px',
						hidden: true,
//						hidden: !this.lookupController().esBankiaBH()|| !this.lookupController().esBankia(),
						editable: false
					},
			        {
			        	xtype: 'comboboxfieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.estado.contraste'),
			        	reference: 'estadoContraste',
			        	hidden: this.lookupController().verCampoEstadoContraste(),
			        	name: 'codEstadoContraste',
			        	padding: '5px',
			        	bind: {
			        		store: '{comboEstadoContraste}'
		            	}
			        }
				]
			},
			{
				xtype: 'fieldsettable',
				collapsible: false,
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.datos.ursus'),
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
//				hidden: !this.lookupController().esBankia() || this.lookupController().esBankiaAlquiler(),
				hidden: true,
				items: [{							
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.estado.civil'),
							reference: 'estadoCivilUrsus',
							valueField: 'id',
							name: 'estadoCivilURSUS',
							padding: '5px',
							editable: false,
							readOnly:true,
							bind: {
								store: '{comboEstadoCivilURSUS}'
							}
						},
						{
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.regimen.economico'),
							reference: 'regimenMatrimonialUrsus',
							valueField: 'id',
							name: 'regimenMatrimonialUrsus',
							padding: '5px',
							editable: false,
							readOnly:true,
							bind: {
								store: '{comboRegimenesMatrimoniales}'
							}
						},
						{
							xtype: 'textfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.numero.ursus.conyuge'),
							reference: 'numeroClienteUrsusRefConyugeUrsus',
							name: 'numeroConyugeUrsus',
							padding: '5px',
							editable: false
						},
						{
							xtype: 'textfieldbase',
							fieldLabel:  HreRem.i18n('fieldlabel.nombre.conyuge'),
							name: 'nombreConyugeURSUS',
							reference: 'nombreConyugeUrsus',
							padding: '5px',
							editable: false
						}
					]
			},
			{
				xtype: 'fieldsettable',
				collapsible: false,
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.datos.representante'),
				reference: 'datosRepresentante',
				hidden: false,
				disabled: false,
				listeners: {
					boxready: 'comprobarObligatoriedadCamposNexos'
				},
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
						},
		            	listeners: {
		            		change: 'comprobarObligatoriedadCamposNexos'
		            	}
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
						reference: 'numeroDocumentoRte',
						name: 'numDocumentoRte',
						padding: '5px',
		            	listeners: {
		            		change: 'onNumeroDocumentoChange'
		            	}
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
						fieldLabel: HreRem.i18n('fieldlabel.pais.nacimiento'),
						reference: 'paisNacimientoRepresentanteCodigo',
						name: 'paisNacimientoRepresentanteCodigo',
						padding: '5px',
						bind: {
							store: '{comboPaises}',
							hidden: '{!comprador.esCarteraBankia}',
							allowBlank: '{!esObligatorioPersonaJuridica}'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.provincia.nacimiento'),
						reference: 'provinciaNacimientoRepresentanteCodigo',
						name: 'provinciaNacimientoRepresentanteCodigo',
						padding: '5px',
						chainedStore: 'comboMunicipioRepresentante',
						chainedReference: 'localidadNacimientoRepresentanteCodigo',
						bind: {
							store: '{comboProvincia}',
							hidden: '{!comprador.esCarteraBankia}',
							allowBlank: '{!esObligatorioPersonaJuridica}'
						},
						displayField: 'descripcion',
						valueField: 'codigo',
						listeners: {
							change: 'onChangeComboProvincia'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio.nacimiento'),
						reference: 'localidadNacimientoRepresentanteCodigo',
						name: 'localidadNacimientoRepresentanteCodigo',
						padding: '5px',
						bind: {
							store: '{comboMunicipioRepresentante}',
							hidden: '{!comprador.esCarteraBankia}',
							disabled: '{!comprador.provinciaNacimientoRepresentanteCodigo}',
							allowBlank: '{!esObligatorioPersonaJuridica}'
						}
					},
					{ 
			        	xtype:'datefieldbase',
			        	fieldLabel:  HreRem.i18n('fieldlabel.fecha.nacimiento.constitucion'),
			        	name: 'fechaNacimientoRepresentante',
			        	reference: 'fechaNacimientoRepresentante',
			        	padding: '5px',
			        	maxValue: null,
			        	bind: {
			        		hidden: '{!comprador.esCarteraBankia}'
			        	}
			        },
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.pais.residencia'),
						reference: 'paisRte',
						name: 'codigoPaisRte',
						padding: '5px',
						bind: {
							store: '{comboPaises}'
						},
						listeners: {
							change: 'comprobarObligatoriedadRte'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.provincia.residencia'),
						reference: 'provinciaComboRte',
						name: 'provinciaRteCodigo',
						chainedStore: 'comboMunicipioRte',
						chainedReference: 'municipioComboRte',
						padding: '5px',
						bind: {
							store: '{comboProvincia}'
						},
						listeners: {
							change: 'onChangeComboProvincia'
						}
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio.residencia'),
						reference: 'municipioComboRte',
						name: 'municipioRteCodigo',
						padding: '5px',
						bind: {
							store: '{comboMunicipioRte}',
							disabled: '{!comprador.provinciaRteCodigo}'
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
						bind: {
							store: '{comboSiNoBoolean}',
							hidden: '{!comprador.esCarteraBankia}'
						}
					}
				]
			}
		];
		me.callParent();
	}
});