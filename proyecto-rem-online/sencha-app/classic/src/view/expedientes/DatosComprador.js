Ext.define('HreRem.view.expedientes.DatosComprador', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'datoscompradorwindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /1.6,    
    height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50,
	reference: 'datoscompradorwindowref',
	y:Ext.Element.getViewportHeight()*(10/150),
    controller: 'expedientedetalle',
    viewModel: {
        type: 'expedientedetalle'
    },
    cls: '',//panel-base shadow-panel
    collapsed: false,
    modal	: true,

    
    idComprador: null,
    expediente: null,
    modoEdicion: true, // Inicializado para evitar errores.
    deshabilitarCamposDoc: false,
    
    
    requires: ['HreRem.model.FichaComprador'],
    
	listeners: {
		//boxready: 'cargarDatosComprador',
		show: function() {
			var me = this;
			this.lookupController().cargarDatosComprador(this);
		}
	},

    initComponent: function() {
    	try{
	    	var me = this;
	    	var modoEdicion = false;

		  	var tipoExpedienteAlquiler = CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"];
			var title = HreRem.i18n("title.windows.datos.comprador");
			var labelTitlePorcentaje = HreRem.i18n('fieldlabel.porcion.compra');
			var btnCrear = HreRem.i18n('btn.crear');

			var tipoExpedienteCodigo = me.expediente.data.tipoExpedienteCodigo;
			if(tipoExpedienteCodigo === tipoExpedienteAlquiler){
				title = HreRem.i18n("title.windows.datos.inquilino");
				labelTitlePorcentaje = HreRem.i18n('fieldlabel.porcion.alquiler');
				btnCrear = HreRem.i18n('btn.crear.Inquilino');
			};

			me.setTitle(title);

	    	me.buttonAlign = 'right';

	    	if(!Ext.isEmpty(me.idComprador)){
				me.buttons = [ { itemId: 'btnModificar', text: HreRem.i18n('btn.modificar'), handler: 'onClickBotonModificarCompradorSinWizard', bind:{disabled: !me.esEditable()}, listeners: {click: 'comprobarFormatoModificar'}},
	    					   { itemId: 'btnCancelar', text: HreRem.i18n('btn.cancelBtnText'), handler: 'onClickBotonCerrarComprador'}];
				modoEdicion = true;

	    	} else {
	    		me.buttons = [ { itemId: 'btnCrear', text: btnCrear, handler: 'onClickBotonCrearComprador'},
	    					   { itemId: 'btnCancelar', text: HreRem.i18n('btn.cancelBtnText'), handler: 'onClickBotonCerrarComprador'}];
	    	}

	    	me.items = [
	    				{
		    				xtype: 'formBase',
		    				collapsed: false,
		   			 		scrollable	: 'y',
//		   			 		recordName: "comprador",
//							recordClass: "HreRem.model.FichaComprador",
		    				cls:'',
		    				listeners: {
			    				boxready: function(window){
			    					var me = this;

									Ext.Array.each(window.query('field[isReadOnlyEdit]'),
										function (field, index)
											{
												field.fireEvent('edit');
												if(index == 0) field.focus();
												field.setReadOnly(!me.up('datoscompradorwindow').modoEdicion)
											}
									);
			    				}
		    				},
		    				defaults: {
		    					addUxReadOnlyEditFieldPlugin: false
		    				},

	    					items: [
	    								{
		    								xtype:'fieldsettable',
		    								collapsible: false,
		    								hidden: me.esEditable(),
		    								margin: '10 10 10 10',
		    								items :
		    									[
		    										{
		    										xtype: 'label',
		    										text: HreRem.i18n('fieldlabel.no.modificar.compradores'),
		    										margin: '10 0 10 0',
		    										style: 'font-weight: bold'
		    										}
		    									]
	    							    },
	    								{

											xtype:'fieldsettable',
											collapsible: false,
											defaultType: 'textfieldbase',
											margin: '10 10 10 10',
											layout: {
										        type: 'table',
										        columns: 2,
										        tdAttrs: {width: '55%'}
											},
											items :
												[
	//											{
	//												xtype: 'checkboxfieldbase',
	//							                	fieldLabel:  HreRem.i18n('fieldlabel.comprador.principal'),
	//							                	readOnly: false,
	//							                	bind:		'{comprador.titularContratacion}'
	//											},
													{
														xtype: 'comboboxfieldbase',
											        	fieldLabel: HreRem.i18n('fieldlabel.tipo.persona'),
														reference: 'tipoPersona',
														name: 'codTipoPersona',
														margin: '10 0 10 0',
											        	bind: {
										            		store: '{comboTipoPersona}'/*,
										            		value: '{comprador.codTipoPersona}'*/
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
														margin: '10 0 10 0',
											        	bind: {
										            		store: '{comboSiNoRem}'/*,
										            		value: '{comprador.titularReserva}'*/
										            	}
							                		},
													{
							                			xtype:'numberfieldbase',
											        	fieldLabel:  labelTitlePorcentaje,
											        	reference: 'porcionCompra',
											        	name: 'porcentajeCompra',
											        	//bind: '{comprador.porcentajeCompra}',
											        	maxValue: 100,
											        	minValue:0,
										            	allowBlank: false
											        },
											        {
							                			xtype: 'comboboxfieldbase',
											        	fieldLabel: HreRem.i18n('fieldlabel.titular.contratacion'),
														reference: 'titularContratacion',
														name: 'titularContratacion',
											        	bind: {
										            		store: '{comboSiNoRem}',
										            		//value: '{comprador.titularContratacion}',
										            		hidden: '{!comprador.titularContratacion}'
										            	},
										            	disabled: true
							                		},
							                		{
							                			xtype: 'comboboxfieldbase',
											        	fieldLabel: HreRem.i18n('fieldlabel.grado.propiedad'),
														reference: 'gradoPropiedad',
														name: 'codigoGradoPropiedad',
											        	bind: {
										            		store: '{comboTipoGradoPropiedad}'/*,
										            		value: '{comprador.codigoGradoPropiedad}'*/
										            	}
							                		}
												]
							           },
							           {
											xtype:'fieldsettable',
											collapsible: false,
											defaultType: 'textfieldbase',
											margin: '10 10 10 10',
											layout: {
										        type: 'table',
										        columns: 2,
										        tdAttrs: {width: '55%'}
											},
											title: HreRem.i18n('fieldlabel.datos.identificacion'),
											items :
												[
													{
														xtype: 'comboboxfieldbase',
											        	fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
														reference: 'tipoDocumento',
														name: 'codTipoDocumento',
											        	bind: {
										            		store: '{comboTipoDocumento}',
//										            		value: '{comprador.codTipoDocumento}',
										            		disabled: me.deshabilitarCamposDoc
										            	},
										            	allowBlank: false
											        },
											        {
											        	fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
														reference: 'numeroDocumento',
														name: 'numDocumento',
											        	bind: {
										            		//value: '{comprador.numDocumento}',
										            		disabled: me.deshabilitarCamposDoc
										            	},
										            	listeners: {
										            		change: 'onNumeroDocumentoChange'
										            	},
										            	allowBlank: false
							                		},
													{
											        	fieldLabel:  HreRem.i18n('header.nombre.razon.social'),
											        	reference: 'nombreRazonSocial',
											        	name: 'nombreRazonSocial',
//											        	bind: {
//										            		value: '{comprador.nombreRazonSocial}'
//										            	},
										            	allowBlank: false
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.apellidos'),
											        	reference: 'apellidos',
											        	name: 'apellidos',
//											        	bind: {
//										            		value: '{comprador.apellidos}'
//										            	},
										            	allowBlank: false
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
											        	reference: 'direccion',
											        	name: 'direccion',
											        	bind: {
										            		//value: '{comprador.direccion}',
										            		allowBlank: '{esObligatorio}'
										            	}
											        },
	//										        {
	//													xtype: 'comboboxfieldbase',
	//										        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
	//													reference: 'provincia',
	//										        	bind: {
	//									            		store: '{comboProvincia}',
	//									            		value: '{comprador.provinciaCodigo}'
	//									            	}
	//										        },
											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.provincia'),
														reference: 'provinciaCombo',
														name: 'provinciaCodigo',
														chainedStore: 'comboMunicipio',
														chainedReference: 'municipioCombo',
										            	bind: {
										            		store: '{comboProvincia}'/*,
										            		value: '{comprador.provinciaCodigo}'*/
										            	},
							    						listeners: {
															select: 'onChangeComboProvincia'
							    						}
													},
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.telefono1'),
											        	reference: 'telefono1',
											        	name: 'telefono1'
//											        	bind: {
//										            		value: '{comprador.telefono1}'
//										            	}
											        },

											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.municipio'),
														reference: 'municipioCombo',
														name: 'municipioCodigo',
										            	bind: {
										            		store: '{comboMunicipio}',
										            		//value: '{comprador.municipioCodigo}',
										            		disabled: '{!comprador.provinciaCodigo}'
										            	}
													},
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
											        	reference: 'telefono2',
											        	name: 'telefono2'
//											        	bind: {
//										            		value: '{comprador.telefono2}'
//										            	}
											        },
											        {
											        	xtype:'numberfieldbase',
											        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
											        	reference: 'codigoPostal',
											        	name: 'codigoPostal'
//											        	bind: {
//										            		value: '{comprador.codigoPostal}'
//										            	}
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
											        	reference: 'email',
											        	name: 'email'
//											        	bind: {
//										            		value: '{comprador.email}'
//										            	}
											        },
											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.pais'),
														reference: 'pais',
														name: 'codigoPais',
										            	bind: {
										            		store: '{comboPaises}',
//										            		value: '{comprador.codigoPais}',
										            		allowBlank: '{esObligatorio}'
										            	},
										            	listeners: {
															change: 'comprobarObligatoriedadRte'
														}
													},
											        {
											        	xtype      : 'container',
								                        layout: 'box',
								                        items: [
								                        	{
																xtype: 'comboboxfieldbase',
																width: 360,
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
												            	allowBlank:true
													        },
								                            {
								                                xtype: 'button',
	//												            cls: 'searchfield-input sf-con-borde',
													            handler: 'mostrarDetallesClienteUrsus',
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
												        fieldLabel:  HreRem.i18n('header.numero.ursus'),
												        reference: 'numeroClienteUrsusRef',
												        name: 'numeroClienteUrsus',
												        bind: {
											            	//value: '{comprador.numeroClienteUrsus}',
											            	hidden: '{!comprador.mostrarUrsus}'
											            },
											            editable: true
								                    },

								                    {
						                            	xtype: 'textfieldbase',
												        fieldLabel:  HreRem.i18n('header.numero.ursus.bh'),
												        reference: 'numeroClienteUrsusBhRef',
												        name: 'numeroClienteUrsusBh',
												        bind: {
											            	//value: '{comprador.numeroClienteUrsusBh}',
											            	hidden: '{!comprador.mostrarUrsusBh}'
											            },
											            editable: true
						                            }
												]
							           },
							           {
											xtype:'fieldsettable',
											collapsible: false,
											defaultType: 'textfieldbase',
											margin: '10 10 10 10',
											layout: {
										        type: 'table',
										        columns: 2,
										        tdAttrs: {width: '55%'}
											},
											title: HreRem.i18n('title.nexos'),
											items :
												[
													{
														xtype: 'comboboxfieldbase',
											        	fieldLabel: HreRem.i18n('fieldlabel.estado.civil'),
														reference: 'estadoCivil',
														name: 'codEstadoCivil',
											        	bind: {
										            		store: '{comboEstadoCivil}'/*,
										            		value: '{comprador.codEstadoCivil}'*/
										            	},
										            	listeners: {
															change: 'comprobarObligatoriedadCamposNexos'
							    						},
										            	allowBlank:true
											        },
											        {
											        	xtype: 'comboboxfieldbase',
											        	fieldLabel: HreRem.i18n('fieldlabel.regimen.economico'),
														reference: 'regimenMatrimonial',
														name: 'codigoRegimenMatrimonial',
														bind: {
										            		store: '{comboRegimenesMatrimoniales}'/*,
										            		value: '{comprador.codigoRegimenMatrimonial}'*/
										            	},
										            	listeners: {
										            		change: 'comprobarObligatoriedadCamposNexos'										         
										            	},
										            	allowBlank:true
							                		},
							                		{
							                			xtype: 'comboboxfieldbase',
							                			fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
							                			reference: 'tipoDocConyuge',
							                			name: 'codTipoDocumentoConyuge',
							                			bind: {
							                				store: '{comboTipoDocumento}'/*,
							                				value: '{comprador.codTipoDocumentoConyuge}'*/
							                			}
							                		},
													{
											        	fieldLabel:  HreRem.i18n('fieldlabel.num.reg.conyuge'),
											        	reference: 'numRegConyuge',
											        	name: 'documentoConyuge'
//											        	bind: {
//										            		value: '{comprador.documentoConyuge}'
//										            	}
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.relacion.hre'),
											        	reference: 'relacionHre',
											        	name: 'relacionHre'
//											        	bind: {
//										            		value: '{comprador.relacionHre}'
//										            	}
											        },
											        {
											        	xtype: 'comboboxfieldbase',
											        	fieldLabel:  HreRem.i18n('fieldlabel.antiguo.deudor'),
											        	reference: 'antiguoDeudor',
											        	name: 'antiguoDeudor',
											        	bind: {
											        		store: '{comboSiNoRem}'/*,
											        		value: '{comprador.antiguoDeudor}'*/
										            	}
											        },
											        {
											        	xtype: 'comboboxfieldbase',
											        	fieldLabel:  HreRem.i18n('fieldlabel.relacion.ant.deudor'),
											        	reference: 'relacionAntDeudor',
											        	name: 'relacionAntDeudor',
											        	bind: {
											        		store: '{comboSiNoRem}'/*,
											        		value: '{comprador.relacionAntDeudor}'*/
										            	}
											        }
												]
							           },
							           {
											xtype:'fieldsettable',
											collapsible: false,
											defaultType: 'textfieldbase',
											margin: '10 10 10 10',
											layout: {
										        type: 'table',
										        columns: 2,
										        tdAttrs: {width: '55%'}
											},
											title: HreRem.i18n('title.datos.representante'),
											items :
												[
													{
														xtype: 'comboboxfieldbase',
											        	fieldLabel: HreRem.i18n('fieldlabel.tipoDocumento'),
														reference: 'tipoDocumentoRte',
														name: 'codTipoDocumentoRte',
											        	bind: {
										            		store: '{comboTipoDocumento}'/*,
										            		value: '{comprador.codTipoDocumentoRte}'*/
										            	},
										            	listeners : {
										            		change: function(combo, value) {
										            			var me = this;
										            			if(value) {
										            				me.up('formBase').down('[reference=numeroDocumentoRte]').allowBlank = false;
										            			} else {
										            				me.up('formBase').down('[reference=numeroDocumentoRte]').allowBlank = true;
										            				me.up('formBase').down('[reference=numeroDocumentoRte]').setValue("");
										            			}
										            		}
										            	}
											        },
											        {
											        	fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
														reference: 'numeroDocumentoRte',
														name: 'numDocumentoRte',
//														bind: {
//										            		value: '{comprador.numDocumentoRte}'
//										            	},
										            	listeners : {
										            		change: function(combo, value) {
										            			var me = this;
										            			if(value) {
										            				me.up('formBase').down('[reference=tipoDocumentoRte]').allowBlank = false;
										            			} else {
										            				me.up('formBase').down('[reference=tipoDocumentoRte]').allowBlank = true;
										            				me.up('formBase').down('[reference=tipoDocumentoRte]').setValue("");
										            			}
										            		}
										            	}
							                		},
													{
											        	fieldLabel:  HreRem.i18n('header.nombre.razon.social'),
											        	reference: 'nombreRazonSocialRte',
											        	name: 'nombreRazonSocialRte'
//											        	bind: {
//										            		value: '{comprador.nombreRazonSocialRte}'
//										            	}
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.apellidos'),
											        	reference: 'apellidosRte',
											        	name: 'apellidosRte'
//											        	bind: {
//										            		value: '{comprador.apellidosRte}'
//										            	}
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
											        	reference: 'direccionRte',
											        	name: 'direccionRte'
//											        	bind: {
//										            		value: '{comprador.direccionRte}'
//										            	}
											        },
											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.provincia'),
														reference: 'provinciaComboRte',
														name: 'provinciaRteCodigo',
														chainedStore: 'comboMunicipioRte',
														chainedReference: 'municipioComboRte',
										            	bind: {
										            		store: '{comboProvincia}'/*,
										            		value: '{comprador.provinciaRteCodigo}'*/
										            	},
							    						listeners: {
															select: 'onChangeComboProvincia'
							    						}
													},
	//										        {
	//													xtype: 'comboboxfieldbase',
	//										        	fieldLabel: HreRem.i18n('fieldlabel.provincia'),
	//													reference: 'provinciaRte',
	//										        	bind: {
	//									            		store: '{comboProvincia}',
	//									            		value: '{comprador.provinciaRteCondigo}'
	//									            	}
	//										        },
	//
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.telefono1'),
											        	reference: 'telefono1Rte',
											        	name: 'telefono1Rte'
//											        	bind: {
//										            		value: '{comprador.telefono1Rte}'
//										            	}
											        },
	//										        {
	//													xtype: 'comboboxfieldbase',
	//										        	fieldLabel: HreRem.i18n('fieldlabel.municipio'),
	//													reference: 'municipioRte',
	//										        	bind: {
	//									            		store: '{comboMunicipio}',
	//									            		value: '{comprador.municipioRteCodigo}'
	//									            	}
	//										        },
											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.municipio'),
														reference: 'municipioComboRte',
														name: 'municipioRteCodigo',
										            	bind: {
										            		store: '{comboMunicipioRte}',
										            		//value: '{comprador.municipioRteCodigo}',
										            		disabled: '{!comprador.provinciaRteCodigo}'
										            	}
													},
	//
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
											        	reference: 'telefono2Rte',
											        	name: 'telefono2Rte'
//											        	bind: {
//										            		value: '{comprador.telefono2Rte}'
//										            	}
											        },
											        {
											        	xtype:'numberfieldbase',
											        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
											        	reference: 'codigoPostalRte',
											        	name: 'codigoPostalRte'
//											        	bind: {
//										            		value: '{comprador.codigoPostalRte}'
//										            	}
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
											        	reference: 'emailRte',
											        	name: 'emailRte'
//											        	bind: {
//										            		value: '{comprador.emailRte}'
//										            	}
											        },
											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.pais'),
														reference: 'paisRte',
														name: 'codigoPaisRte',
										            	bind: {
										            		store: '{comboPaises}'/*,
										            		value: '{comprador.codigoPaisRte}'*/
										            	},
										            	listeners : {
										            		change: 'comprobarObligatoriedadRte'
										            	}
													}
												]
							           }
	        				]
	    			}
	    	]


    	}catch(err) {
			Ext.global.console.log(err);
		}
		me.callParent();
    },
    
     resetWindow: function() {
    	var me = this,    	
    	form = me.down('formBase');
		form.setBindRecord(comprador);
    },
    
    esEditable: function(){
    	var me = this;
    	
    	if($AU.userIsRol("HAYASUPER")){
    		return true;
    	}
    	
    	if($AU.userHasFunction(['MODIFICAR_TAB_COMPRADORES_EXPEDIENTES'])){
    		if(!$AU.userHasFunction(['MODIFICAR_TAB_COMPRADORES_EXPEDIENTES_RESERVA']) && me.checkCoe()){
    			return false;
    		}
    		return true;
    	}
    	
    	return false;
    },
    
    checkCoe: function(){
    	var me = this;
    	
    	var estadoExpediente = me.expediente.data.codigoEstado;
    	var solicitaReserva = me.expediente.data.solicitaReserva;
    	if((solicitaReserva == 0 || solicitaReserva == null) && (estadoExpediente == CONST.ESTADOS_EXPEDIENTE['RESERVADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['APROBADO']
    	|| estadoExpediente == CONST.ESTADOS_EXPEDIENTE['FIRMADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['VENDIDO'])){
    		return true;
    	}
    	if(solicitaReserva == 1 && (estadoExpediente == CONST.ESTADOS_EXPEDIENTE['RESERVADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['FIRMADO'] 
    	|| estadoExpediente == CONST.ESTADOS_EXPEDIENTE['ANULADO'] || estadoExpediente == CONST.ESTADOS_EXPEDIENTE['VENDIDO'])){
    		return true;
    	}
    	return false;
    }
});