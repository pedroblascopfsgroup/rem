Ext.define('HreRem.view.agrupaciones.detalle.AnyadirNuevaOfertaDetalle', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'anyadirnuevaofertadetalle',
    reference	: 'anyadirNuevaOfertaDetalle',
    collapsed: false,
	scrollable	: 'y',	  				
	recordName: "oferta",
	bodyStyle	: 'padding:20px',
	recordClass: "HreRem.model.OfertaComercial",
	//requires: ['HreRem.model.OfertaComercialActivo'],
	
	listeners: {    
		boxready: function(window) {
			var me = this;
			
			Ext.Array.each(me.down('fieldset').query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 								
						field.fireEvent('edit');
						if(index == 0) field.focus();
					}
			);
		},
		
		show: function() {
			var me = this;
			me.resetWindow();			
		}
	},

    
	initComponent: function() {
    	
    	var me = this;
    	    	
    	me.buttons = [ {
    		itemId: 'btnGuardar',
    		text: 'Crear',
    		handler: 'onClickCrearOferta' 
    	},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarWizard'}];

    	me.items = [
					{
						
								xtype:'fieldset',
								cls	: 'panel-base shadow-panel',
								title: HreRem.i18n('title.nueva.oferta'),
								layout: {
							        type: 'table',
							        // The total column count must be specified here
							        columns: 2,
							        trAttrs: {height: '45px', width: '50%'},
							        tdAttrs: {width: '50%'},
							        tableAttrs: {
							            style: {
							                width: '100%',
							                margin: '10px 0 0 150px'
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
										bind:		'{oferta.enail}',
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
	    					        	name: 'comboTipoOferta',
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
	    	    								var checkTanteo = form.down('field[name=dederechotanteo]');
	    	    								checkTanteo.reset();
	    	    								checkTanteo.setDisabled(CONST.TIPOS_OFERTA['ALQUILER'] == value)
	    	    								
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
	    					        	name:   'comboTipoDocumento',
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
	    					        	name: 'comboTipoPersona',
	    					        	flex:	1,
	    					        	allowBlank: true,
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
	    	    								var estadoCivil = form.down('field[name=comboEstadoCivil]');
	    	    								var regimen = form.down('field[name=comboRegimenMatrimonial]');
	    	    								if(value=="1"){
	    	    									estadoCivil.setDisabled(false);
	    	    								}else{
	    	    									estadoCivil.setDisabled(true);
	    	    									regimen.setDisabled(true);
	    	    									
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
	    					        	name: 'comboEstadoCivil',
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
	    	    								var regimen = form.down('field[name=comboRegimenMatrimonial]');
	    	    								if(value=="02"){
	    	    									regimen.setDisabled(false);
	    	    								}else{
	    	    									regimen.setDisabled(true);
	    	    									regimen.reset();
	    	    								}
	    	    								
	    	    							}
	    	    						}
									},
									{
										xtype: 'comboboxfieldbase',
	    					        	fieldLabel:  HreRem.i18n('header.regimen.matrimonial'),
	    					        	itemId: 'comboRegimenMatrimonial',
	    					        	name: 'comboRegimenMatrimonial',
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
				            	    	xtype: 		'checkboxfieldbase',
				            	    	fieldLabel:	HreRem.i18n('fieldlabel.dederechotanteo'),
				            	    	name:		'dederechotanteo',
				            	    	allowBlank:	false,
				            	    	bind:		'{oferta.deDerechoTanteo}',
							        	inputValue: true
				            	    },
				            	    {
										xtype: 		'checkboxfieldbase',
				            	    	fieldLabel:	HreRem.i18n('fieldlabel.intencionfinanciar'),
				            	    	name:		'intencionfinanciar',
				            	    	allowBlank:	false,
				            	    	bind:		'{oferta.intencionFinanciar}',
							        	inputValue: true,
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
										fieldLabel: HreRem.i18n('fieldlabel.prescriptor'),
										name: 'nombrePrescriptor',
										//disabled: true,
										readOnly: true,
										allowBlank: false
									},
									{
										xtype: 		'checkboxfieldbase',
				            	    	fieldLabel:	HreRem.i18n('fieldlabel.intencionfinanciar'),
				            	    	name:		'intencionFinanciar',
				            	    	allowBlank:	false,
				            	    	bind:		'{oferta.intencionFinanciar}',
							        	inputValue: true
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
										fieldLabel: HreRem.i18n('fieldlabel.sucursalreserva'),
										name: 'nombreSucursal',
										//disabled: true,
										readOnly: true,
										allowBlank: true,
							        	colspan: 2
									}
								]
				}
    	];
    	
    	me.callParent();
    },
    
    resetWindow: function() {
    	var me = this;	
		me.setBindRecord(me.oferta);
    }
    
});