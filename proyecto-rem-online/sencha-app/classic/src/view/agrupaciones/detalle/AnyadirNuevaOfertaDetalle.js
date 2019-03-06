Ext.define('HreRem.view.agrupaciones.detalle.AnyadirNuevaOfertaDetalle', {
    extend		: 'HreRem.view.common.FormBase',
    xtype		: 'anyadirnuevaofertadetalle',
    reference	: 'anyadirNuevaOfertaDetalle',
    collapsed: false,
	scrollable	: 'y',
	cls:'',	  				
	recordName: "oferta",						
	recordClass: "HreRem.model.OfertaComercial",

    
	initComponent: function() {
    	
    	var me = this;
    	
    	
    	me.items = [
					{
						
								xtype:'fieldset',
								cls	: 'panel-base shadow-panel',
								layout: {
							        type: 'table',
							        // The total column count must be specified here
							        columns: 2,
							        trAttrs: {height: '45px', width: '50%'},
							        tdAttrs: {width: '50%'},
							        tableAttrs: {
							            style: {
							                width: '100%'
										}
							        }
								},
								defaultType: 'textfieldbase',
								collapsed: false,
								scrollable	: 'y',
				            	items: [
				            	    {
				            	    	name:		'id',
										bind:		'{oferta.idAgrupacion}',
										hidden:		true
				            	    },
									{
										xtype:      'currencyfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.importe'),
										flex: 		1,
										allowBlank: false,
										bind:		'{oferta.importeOferta}'
									},
									{
										xtype: 'comboboxfieldbase',
	    					        	fieldLabel:  HreRem.i18n('header.oferta.tipoOferta'),
	    					        	itemId: 'comboTipoOferta',
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
										fieldLabel: HreRem.i18n('fieldlabel.codigo.sucursalreserva'),
										name: 'buscadorSucursales',
										maskRe: /^\d{1,4}$/,
										maxLength: 4,
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
										readOnly: true,
										allowBlank: true,
							        	colspan: 2
									}
				            	]
				}
    	];
    	
    	me.callParent();
    }
    
});