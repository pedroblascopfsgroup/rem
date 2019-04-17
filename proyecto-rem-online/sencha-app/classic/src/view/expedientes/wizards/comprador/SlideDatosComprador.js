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
		'HreRem.view.expedientes.wizards.comprador.SlideDatosCompradorModel'
	],

	listeners: {
		activate: 'onActivate'
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
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.provincia'),
						reference: 'provinciaCombo',
						name: 'provinciaCodigo',
						padding: '5px',
						allowBlank: false,
						chainedStore: 'comboMunicipio',
						chainedReference: 'municipioCombo',
						bind: {
							store: '{comboProvincia}'
						},
						displayField: 'descripcion',
						valueField: 'codigo',
						listeners: {
							change: 'onChangeComboProvincia'
						}
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.telefono1'),
						name: 'telefono1',
						reference: 'telefono1',
						padding: '5px'
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						reference: 'municipioCombo',
						name: 'municipioCodigo',
						allowBlank: false,
						padding: '5px',
						bind: {
							store: '{comboMunicipio}',
							disabled: '{!comprador.provinciaCodigo}'
						}
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.telefono2'),
						name: 'telefono2',
						reference: 'telefono2',
						padding: '5px'
					},
					{
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
						name: 'codigoPostal',
						reference: 'codigoPostal',
						padding: '5px'
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.email'),
						name: 'email',
						reference: 'email',
						padding: '5px',
						vtype: 'email'
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.pais'),
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
								bind: {
									store: '{comboClienteUrsus}',
									hidden: '{!comprador.esCarteraBankia}'
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
								allowBlank: true
							},
							{
								xtype: 'button',
								handler: 'onClickVerDetalleClienteUrsus',
								bind: {
									hidden: '{!comprador.esCarteraBankia}'
								},
								reference: 'btnVerDatosClienteUrsus',
								disabled: true,
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
							hidden: '{!comprador.mostrarUrsus}'
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
							hidden: '{!comprador.mostrarUrsusBh}'
						},
						editable: true
					}
				]
			},
			{
				xtype: 'fieldsettable',
				collapsible: false,
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.nexos'),
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
						fieldLabel: HreRem.i18n('fieldlabel.estado.civil'),
						name: 'codEstadoCivil',
						reference: 'estadoCivil',
						padding: '5px',
						bind: {
							store: '{comboEstadoCivil}'
						},
						listeners: {
							change: 'comprobarObligatoriedadCamposNexos'
						},
						allowBlank: true
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.regimen.economico'),
						name: 'codigoRegimenMatrimonial',
						reference: 'regimenMatrimonial',
						padding: '5px',
						bind: {
							store: '{comboRegimenesMatrimoniales}'
						},
						listeners: {
							change: 'comprobarObligatoriedadCamposNexos'
						},
						allowBlank: true
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
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
		            		change: 'comprobarObligatoriedadCamposNexos'										         
		            	}
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.relacion.hre'),
						reference: 'relacionHre',
						name: 'relacionHre',
						padding: '5px'
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.antiguo.deudor'),
						reference: 'antiguoDeudor',
						name: 'antiguoDeudor',
						padding: '5px',
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
					}
				]
			},
			{
				xtype: 'fieldsettable',
				collapsible: false,
				defaultType: 'textfieldbase',
				title: HreRem.i18n('title.datos.representante'),
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
		            		change: 'comprobarObligatoriedadCamposNexos'										         
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
						fieldLabel: HreRem.i18n('fieldlabel.direccion'),
						name: 'direccionRte',
						reference: 'direccionRte',
						padding: '5px'
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.provincia'),
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
						fieldLabel: HreRem.i18n('fieldlabel.telefono1'),
						reference: 'telefono1Rte',
						name: 'telefono1Rte',
						padding: '5px'
					},
					{
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.municipio'),
						reference: 'municipioComboRte',
						name: 'municipioRteCodigo',
						padding: '5px',
						bind: {
							store: '{comboMunicipioRte}',
							disabled: '{!comprador.provinciaRteCodigo}'
						}
					},
					{
						fieldLabel: HreRem.i18n('fieldlabel.telefono2'),
						reference: 'telefono2Rte',
						name: 'telefono2Rte',
						padding: '5px'
					},
					{
						xtype: 'numberfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.codigo.postal'),
						reference: 'codigoPostalRte',
						name: 'codigoPostalRte',
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
						xtype: 'comboboxfieldbase',
						fieldLabel: HreRem.i18n('fieldlabel.pais'),
						reference: 'paisRte',
						name: 'codigoPaisRte',
						padding: '5px',
						bind: {
							store: '{comboPaises}'
						},
						listeners: {
							change: 'comprobarObligatoriedadRte'
						}
					}
				]
			}
		];

		me.callParent();
	}

});