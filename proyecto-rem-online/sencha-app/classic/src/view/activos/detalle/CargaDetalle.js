Ext.define('HreRem.view.activos.detalle.CargaDetalle', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'cargadetalle',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 1.5,
        
    parent: null,
    		
    modoEdicion: true,
    
    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
        
    requires: ['HreRem.model.ActivoCargas'],
    
    listeners: {

		boxready: function(window) {
			var me = this;
			me.initWindow();
		}
		
	},
	
	initWindow: function() {
    	var me = this,
		  isUnidadAlquilable = false;
		if (me.getViewModel().get('cargaTab.unidadAlquilable') != undefined && me.getViewModel().get('cargaTab.unidadAlquilable') != null)
			isUnidadAlquilable = me.getViewModel().get('cargaTab.unidadAlquilable');
    	if(me.modoEdicion) {
			Ext.Array.each(me.down('form').query('field[isReadOnlyEdit]'),
				function (field, index) { 								
					if  (isUnidadAlquilable){
						field.setReadOnly(true);
					}else{
						field.fireEvent('edit');
						if(index == 0) field.focus();	
					}
				}
			);
    	}
		
    	me.getViewModel().set('carga', me.carga);
    	
    },
    
	initComponent: function() {  
		
    	var me = this;
    	
    	me.buttons = [ { itemId: 'btnGuardar', text: HreRem.i18n('btn.saveBtnText'), handler: 'onClickBotonGuardarCarga', disabled: !me.modoEdicion},  { itemId: 'btnCancelar', text: HreRem.i18n('btn.cancelBtnText'), handler: 'onClickBotonCancelarCarga'}];
    	if (me.getViewModel().get('cargaTab.unidadAlquilable') != undefined && me.getViewModel().get('cargaTab.unidadAlquilable') != null && me.getViewModel().get('cargaTab.unidadAlquilable'))
    	me.buttons[0].hidden = true;
    	me.setTitle(HreRem.i18n('title.detalle.carga'));
    	
    	me.items = [
    	
    				{
			    		xtype: 'formBase',
			    		reference: 'formDetalleCarga',
			    		cls: 'detalle-carga-form',		    		
			    		collapsed: false,	  				
						recordName: "carga",						
						recordClass: "HreRem.model.ActivoCargas",
					    items : [    	
    	
				    				{    
										xtype:'fieldset',
										cls: 'x-fieldset-detalle-carga',
										padding: 10,
										layout: {
									    type: 'table',
									        // The total column count must be specified here
									        columns: 2,
									        trAttrs: {height: '45px', width: '100%'},
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
										items :
												[
													{
											        	readOnly: true,
												 		fieldLabel: HreRem.i18n('header.origen.dato'),
										               	reference: 'origenDato',
												      	bind: '{carga.origenDatoDescripcion}',											         	
											         	allowBlank: false
													},
									               	{
											        	xtype: 'comboboxfieldbase',
											        	fieldLabel: HreRem.i18n('fieldlabel.con.cargas.propias'),
										               	reference: 'cargasPropias',
												      	bind: {
												      		store: '{comboSiNoRem}',
											           		value: '{carga.cargasPropias}'
											         	}
									               	},
													{ 
														xtype: 'comboboxfieldbase',
											        	editable: false,
												 		fieldLabel: HreRem.i18n('fieldlabel.tipo'),
										               	reference: 'tipoCarga',
						        						chainedStore: 'comboSubtipoCarga',
														chainedReference: 'subtipoCargaCombo',
												      	bind: {
											           		store: '{comboTiposCarga}',
											           		value: '{carga.tipoCargaCodigo}'
											         	},
											         	listeners: {
										                	select: 'onChangeChainedCombo'
										            	},
											         	allowBlank: false
									               	},
												   	{ 
														xtype: 'comboboxfieldbase',
										               	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
										               	reference: 'subtipoCargaCombo',
												      	bind: {
											           		store: '{comboSubtiposCarga}',
											           		value: '{carga.subtipoCargaCodigo}'
											         	},
											         	allowBlank: false
												   	},
													{ 
														fieldLabel: HreRem.i18n('fieldlabel.descripcion.carga'),
									                	bind:		'{carga.descripcionCarga}'
									                },
									                { 
												 		fieldLabel: HreRem.i18n('fieldlabel.titular.carga'),
										            	bind:		'{carga.titular}'
													}
										]
				    			},
				    			{    
										xtype:'fieldset',
										padding: 10,
										cls: 'x-fieldset-detalle-carga',
										layout: {
									    type: 'table',
									        // The total column count must be specified here
									        columns: 2,
									        trAttrs: {height: '45px', width: '100%'},
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
										items :
												[
													
													{ 
									                	xtype:'currencyfieldbase',
												 		fieldLabel: HreRem.i18n('fieldlabel.importe.real'),			 		
										            	bind:		'{carga.importeEconomico}'
													},
													{ 
											        	xtype: 'comboboxfieldbase',
											        	reference: 'comboestadocargaref',
											        	name: 'comboestadocargaref',
											        	editable: false,
														fieldLabel: HreRem.i18n('header.estado.carga'),
											        	bind: {
										            		store: '{comboEstadoCarga}',
										            		value: '{carga.estadoCodigo}'
										            	},
										            	listeners: {
										            		select: 'onChangeEstadoCargaCombo'
										            	},
					    								publishes: 'value',
					    								chainedStore: 'storeComboImpideVenta',
														chainedReference: 'comboImpideVenta'
											        },	
											        									            											
													{ 
														xtype:'currencyfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.importe.registral'),
									                	bind:		'{carga.importeRegistral}'
									                },
													{ 
											        	xtype: 'comboboxfieldbase',
											        	reference: 'combosubestadocargaref',
											        	name: 'combosubestadocargaref',
											        	editable: false,
														fieldLabel: HreRem.i18n('header.subestado.carga'),
											        	bind: {
										            		store: '{comboSubEstadoCarga}',
										            		value: '{carga.subestadoCodigo}'
										            	}
										            },
													{
										            	readOnly: true
													},												
									                {
											        	xtype: 'comboboxfieldbase',
											        	reference: 'comboImpideVenta',
											        	name: 'comboImpideVenta',
											        	editable: false,
											        	allowBlank: false,
														fieldLabel: HreRem.i18n('header.impide.venta'),
											        	bind: {
															store: '{storeComboImpideVenta}',
										            		value: '{carga.codigoImpideVenta}'
										            	}
											        }
										]
				    			},
				    			{    
										xtype:'fieldset',
										padding: 10,
										cls: 'x-fieldset-detalle-carga',
										layout: {
									    type: 'table',
									        // The total column count must be specified here
									        columns: 2,
									        trAttrs: {height: '45px', width: '100%'},
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
										items :
												[
													{
														xtype:'datefieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.fecha.inscripcion.carga.registro'),
										            	bind:		'{carga.fechaInscripcion}'
										            	
													},
									                {
									                	maskRe: /^\d*$/, 
												 		fieldLabel: HreRem.i18n('fieldlabel.orden.registral'),
										            	bind:		'{carga.ordenCarga}'
													},


													{
														xtype:'datefieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.fecha.cancelacion.economica.carga'),
										            	bind:		'{carga.fechaCancelacionEconomica}',
										            	reference: 'fechaCancelacionEconomica'
										            	
													},
													{
														xtype:'datefieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.fecha.presentacion.cancelacion'),
										            	bind:		'{carga.fechaPresentacion}'
										            	
													},
													{
														xtype:'datefieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.fecha.cancelacion.registral'),
										            	bind:		'{carga.fechaCancelacionRegistral}',
										            	reference: 'fechaCancelacionRegistral'
										            	
													},
													{ 
														xtype: 'textareafieldbase',
											        	fieldLabel:  HreRem.i18n('fieldlabel.observaciones'),						        	
											        	bind: '{carga.observaciones}',
														maxLength: 200,
											        	rowspan: 2,
											        	height: 80
											        }
							
											]
						                 
						       },
						   	{    
									xtype:'fieldset',
									padding: 10,
									cls: 'x-fieldset-detalle-carga',
									layout: {
								    type: 'table',
								        // The total column count must be specified here
								        columns: 2,
								        trAttrs: {height: '45px', width: '100%'},
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
									items :
											[
												{
													xtype:'datefieldbase',
													fieldLabel: HreRem.i18n('header.fecha.solicitud.carta.pago'),
									            	bind: '{carga.fechaSolicitudCarta}',
											 		maxValue : null 
									            	
												},
												{
													xtype:'datefieldbase',
													fieldLabel: HreRem.i18n('header.fecha.recepcion.carta.pago'),
									            	bind: '{carga.fechaRecepcionCarta}',
											 		maxValue : null 
									            	
												},
												{
													xtype:'datefieldbase',
													fieldLabel: HreRem.i18n('header.fecha.presentacion.carta.pago'),
									            	bind:'{carga.fechaPresentacionRpCarta}',
											 		maxValue : null 
									            	
												}
								       
						
										]
					                 
					       }
					]
    			}
    	
    	]
    	
		me.callParent();
	}
});