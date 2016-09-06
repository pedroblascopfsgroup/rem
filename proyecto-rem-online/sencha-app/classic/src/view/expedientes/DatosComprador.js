Ext.define('HreRem.view.expedientes.DatosComprador', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'datoscompradorwindow',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() /1.8,    
    height	: Ext.Element.getViewportHeight() > 700 ? 700 : Ext.Element.getViewportHeight() - 50,
	reference: 'datoscompradorwindowref',
    controller: 'expedientedetalle',
    viewModel: {
        type: 'expedientedetalle'
    },
    
    idComprador: null,
    
    recordName: "comprador",
	
	recordClass: "HreRem.model.FichaComprador",
    
    requires: ['HreRem.model.FichaComprador'],
    
	listeners: {
	
		boxready: function(window) {
			
			var me = this;
			
			Ext.Array.each(window.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 								
						field.fireEvent('edit');
						if(index == 0) field.focus();
					}
			);
		}
	},
	
    initComponent: function() {
    	
    	var me = this;

    	me.setTitle(HreRem.i18n("title.windows.datos.comprador"));
    	
    	me.buttonAlign = 'right';    	
    	
    	me.buttons = [ { itemId: 'btnModificar', text: HreRem.i18n('btn.modificar'), handler: 'onClickBotonModificarComprador'},{ itemId: 'btnCancelar', text: HreRem.i18n('btn.cancelBtnText'), handler: 'hideWindow', scope: this}];

    	me.items = [
    				{
	    				xtype: 'formBase', 
	    				collapsed: false,
	   			 		scrollable	: 'y',
	    				cls:'',	    				
					    
					    
    					items: [
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
													margin: '10 0 10 0',
										        	bind: {
									            		store: '{comboTipoPersona}',
									            		value: '{comprador.codTipoPersona}'
									            	}
									            	
										        },
										        {
										        	xtype: 'comboboxfieldbase',
										        	fieldLabel: HreRem.i18n('fieldlabel.titular.reserva'),
													reference: 'titularReserva',
													margin: '10 0 10 0',
										        	bind: {
									            		store: '{comboSiNoRem}',
									            		value: '{comprador.titularReserva}'
									            	}
						                		},
												{ 
						                			xtype:'numberfieldbase',
										        	fieldLabel:  HreRem.i18n('fieldlabel.porcion.compra'),
										        	reference: 'porcionCompra',
										        	bind: '{comprador.porcentajeCompra }',
									            	allowBlank: false
										        },
										        {
						                			xtype: 'comboboxfieldbase',
										        	fieldLabel: HreRem.i18n('fieldlabel.titular.contratacion'),
													reference: 'titularContratacion',
										        	bind: {
									            		store: '{comboSiNoRem}',
									            		value: '{comprador.titularContratacion}'
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
										        	bind: {
									            		store: '{comboTipoDocumento}'
									            	}
									            	
										        },
										        {
										        	fieldLabel: HreRem.i18n('fieldlabel.numero.documento'),
													reference: 'numeroDocumento',
										        	bind: {
									            		value: '{numeroDocumento}'
									            	},
									            	allowBlank: false
						                		},
												{ 
										        	fieldLabel:  HreRem.i18n('header.nombre.razon.social'),
										        	reference: 'nombreRazonSocial',
										        	bind: {
									            		value: '{nombreRazonSocial}'
									            	},
									            	allowBlank: false
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
										        	reference: 'direccion',
										        	bind: {
									            		value: '{direccion}'
									            	}
													
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.municipio'),
										        	reference: 'municipio',
										        	bind: {
									            		value: '{municipio}'
									            	}
													
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.telefono1'),
										        	reference: 'telefono1',
										        	bind: {
									            		value: '{telefono1}'
									            	}
													
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.provincia'),
										        	reference: 'provincia',
										        	bind: {
									            		value: '{provincia}'
									            	}
													
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
										        	reference: 'telefono2',
										        	bind: {
									            		value: '{telefono2}'
									            	}
													
										        },
										        { 
										        	xtype:'numberfieldbase',
										        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
										        	reference: 'codigoPostal',
										        	bind: {
									            		value: '{codigoPostal}'
									            	}
													
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
										        	reference: 'email',
										        	bind: {
									            		value: '{email}'
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
										title: HreRem.i18n('title.nexos'),
										items :
											[
												{ 
													xtype: 'comboboxfieldbase',
										        	fieldLabel: HreRem.i18n('fieldlabel.estado.civil'),
													reference: 'estadoCivil',
										        	bind: {
									            		store: '{comboEstadoCivil}'
									            	}
									            	
									            	
										        },
										        {
										        	xtype: 'comboboxfieldbase',
										        	fieldLabel: HreRem.i18n('fieldlabel.regimen.economico'),
													reference: 'regimenEconomico',
										        	bind: {
									            		store: '{regimenEconomico}'
									            	}
									            	
						                		},
												{ 
										        	fieldLabel:  HreRem.i18n('fieldlabel.num.reg.conyuge'),
										        	reference: 'numRegConyuge',
										        	bind: {
									            		value: '{numRegConyuge}'
									            	}
													
										        },
										        {
											   		xtype: 'displayfield'
											   		// como separador				   		
										        },
										        { 
										        	xtype: 'comboboxfieldbase',
										        	fieldLabel:  HreRem.i18n('fieldlabel.antiguo.deudor'),
										        	reference: 'antiguoDeudor',
										        	bind: {
										        		store: '{comboSiNoRem}'
									            	}
													
										        },
										        { 
										        	xtype: 'comboboxfieldbase',
										        	fieldLabel:  HreRem.i18n('fieldlabel.relacion.ant.deudor'),
										        	reference: 'relacionAntDeudor',
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
										        	bind: {
									            		store: '{comboTipoDocumento}'
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
										        	bind: {
									            		value: '{numeroDocumentoRte}'
									            	},
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
										        	bind: {
									            		value: '{nombreRazonSocialRte}'
									            	}
													
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
										        	reference: 'direccionRte',
										        	bind: {
									            		value: '{direccionRte}'
									            	}
													
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.municipio'),
										        	reference: 'municipioRte',
										        	bind: {
									            		value: '{municipioRte}'
									            	}
													
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.telefono1'),
										        	reference: 'telefono1Rte',
										        	bind: {
									            		value: '{telefono1Rte}'
									            	}
													
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.provincia'),
										        	reference: 'provinciaRte',
										        	bind: {
									            		value: '{provinciaRte}'
									            	}
													
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.telefono2'),
										        	reference: 'telefono2Rte',
										        	bind: {
									            		value: '{telefono2Rte}'
									            	}
													
										        },
										        { 
										        	xtype:'numberfieldbase',
										        	fieldLabel:  HreRem.i18n('fieldlabel.codigo.postal'),
										        	reference: 'codigoPostalRte',
										        	bind: {
									            		value: '{codigoPostalRte}'
									            	}
													
										        },
										        { 
										        	fieldLabel:  HreRem.i18n('fieldlabel.email'),
										        	reference: 'emailRte',
										        	bind: {
									            		value: '{emailRte}'
									            	}
													
										        }

											]
						           }
        				]
    			}
    	]
    	
    	me.callParent();    	
    
    }

});