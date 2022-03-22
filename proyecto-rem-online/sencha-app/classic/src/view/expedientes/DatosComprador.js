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
													{
														xtype: 'comboboxfieldbase',
											        	fieldLabel: HreRem.i18n('fieldlabel.tipo.persona'),
														reference: 'tipoPersona',
														name: 'codTipoPersona',
														margin: '10 0 10 0',
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
														margin: '10 0 10 0',
											        	bind: {
										            		store: '{comboSiNoRem}'
										            	}
							                		},
													{
							                			xtype:'numberfieldbase',
											        	fieldLabel:  labelTitlePorcentaje,
											        	reference: 'porcionCompra',
											        	name: 'porcentajeCompra',
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
										            		store: '{comboTipoGradoPropiedad}'
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
										            		disabled: me.deshabilitarCamposDoc
										            	},
										            	allowBlank: false
											        },
											        {
											        	fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
														reference: 'numeroDocumento',
														name: 'numDocumento',
											        	bind: {
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
										            	allowBlank: false
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.apellidos'),
											        	reference: 'apellidos',
											        	name: 'apellidos',
										            	allowBlank: false
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
											        	reference: 'direccion',
											        	name: 'direccion',
											        	bind: {
										            		allowBlank: '{esObligatorio}'
										            	}
											        },
											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.provincia'),
														reference: 'provinciaCombo',
														name: 'provinciaCodigo',
														chainedStore: 'comboMunicipio',
														chainedReference: 'municipioCombo',
										            	bind: {
										            		store: '{comboProvincia}'
										            	},
							    						listeners: {
															change: 'onChangeComboProvincia'
							    						}
													},
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.telefono1'),
											        	reference: 'telefono1',
											        	name: 'telefono1'
											        },

											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.municipio'),
														reference: 'municipioCombo',
														name: 'municipioCodigo',														
														disabled: true,
										            	bind: {
										            		store: '{comboMunicipio}'
										            	}
													},
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
											        	reference: 'telefono2',
											        	name: 'telefono2'
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
											        	reference: 'codigoPostal',
											        	name: 'codigoPostal',
											        	vtype: 'codigoPostal',
														maskRe: /^\d*$/, 
									                	maxLength: 5
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
											        	reference: 'email',
											        	name: 'email'
											        },
											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.pais'),
														reference: 'pais',
														name: 'codigoPais',
														
										            	bind: {
										            		store: '{comboPaises}',
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
										            		store: '{comboEstadoCivil}'
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
										            		store: '{comboRegimenesMatrimoniales}'
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
							                			editable:true,
							                			allowBlank:true,
							                			bind: {
							                				store: '{comboTipoDocumento}'
							                			},
										            	listeners: {
										            		change: 'comprobarObligatoriedadCamposNexos'										         
										            	}
							                		},
													{
											        	fieldLabel:  HreRem.i18n('fieldlabel.num.reg.conyuge'),
											        	reference: 'numRegConyuge',
											        	name: 'documentoConyuge',
										            	listeners: {
										            		change: 'comprobarObligatoriedadCamposNexos'										         
										            	}
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.relacion.hre'),
											        	reference: 'relacionHre',
											        	name: 'relacionHre'
											        },
											        {
											        	xtype: 'comboboxfieldbase',
											        	fieldLabel:  HreRem.i18n('fieldlabel.antiguo.deudor'),
											        	reference: 'antiguoDeudor',
											        	name: 'antiguoDeudor',
											        	
											        	bind: {
											        		store: '{comboSiNoRem}'
										            	}
											        },
											        {
											        	xtype: 'comboboxfieldbase',
											        	fieldLabel:  HreRem.i18n('fieldlabel.relacion.ant.deudor'),
											        	reference: 'relacionAntDeudor',
											        	name: 'relacionAntDeudor',
											        	
											        	bind: {
											        		store: '{comboSiNoRem}'
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
										            		store: '{comboTipoDocumento}'
										            	},
										            	listeners : {
										            		change: 'comprobarObligatoriedadCamposNexos'										            		
										            	}
											        },
											        {
											        	fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
														reference: 'numeroDocumentoRte',
														name: 'numDocumentoRte',
										            	listeners : {
										            		change: 'comprobarObligatoriedadCamposNexos'
										            	}
							                		},
													{
											        	fieldLabel:  HreRem.i18n('header.nombre.razon.social'),
											        	reference: 'nombreRazonSocialRte',
											        	name: 'nombreRazonSocialRte'
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.apellidos'),
											        	reference: 'apellidosRte',
											        	name: 'apellidosRte'
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
											        	reference: 'direccionRte',
											        	name: 'direccionRte'
											        },
											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.provincia'),
														reference: 'provinciaComboRte',
														name: 'provinciaRteCodigo',
														chainedStore: 'comboMunicipioRte',
														chainedReference: 'municipioComboRte',
										            	bind: {
										            		store: '{comboProvincia}'
										            	},
							    						listeners: {
															change: 'onChangeComboProvincia'
							    						}
													},
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.telefono1'),
											        	reference: 'telefono1Rte',
											        	name: 'telefono1Rte'
											        },
											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.municipio'),
														reference: 'municipioComboRte',
														name: 'municipioRteCodigo',
														disabled: true,
														
										            	bind: {
										            		store: '{comboMunicipioRte}'
										            	}
													},
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
											        	reference: 'telefono2Rte',
											        	name: 'telefono2Rte'
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
											        	reference: 'codigoPostalRte',
											        	name: 'codigoPostalRte',
											        	vtype: 'codigoPostal',
														maskRe: /^\d*$/, 
									                	maxLength: 5
											        },
											        {
											        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
											        	reference: 'emailRte',
											        	name: 'emailRte'
											        },
											        {
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.pais'),
														reference: 'paisRte',
														name: 'codigoPaisRte',
														
										            	bind: {
										            		store: '{comboPaises}'
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
    	var me = this;
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