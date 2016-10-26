Ext.define('HreRem.view.activos.detalle.AnyadirEntidadActivo', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirentidadactivo',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 1.3,    
        
    parent: null,
    		
    modoEdicion: null,
    
    /**
     * Cuando un proveedor crea un gasto, no debe poder seleccionar otros proveedores.
     * En caso de recibir un nif de emisor, se deshabilita la búsqueda y se asigna el nif recibido.
     * @type 
     */
    nifEmisor: null,
    idActivo: null,
    idActivoIntegrado: null,
    
    controller: 'activodetalle',
    viewModel: {
        type: 'activodetalle'
    },
    
    requires: ['HreRem.model.ActivoIntegrado'],
    
    listeners: { 
    	
    	boxready: 'cargarDatosActivoIntegrado'
	},
    
	initComponent: function() {
    	var me = this;
    	me.setTitle(HreRem.i18n('title.integracion.entidad.activo'));
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Guardar', handler: 'onClickBotonGuardarEntidad'},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarEntidad'}];
    	
    	me.items = [
    	
			    	{
			    		xtype: 'formBase',
			    		collapsed: false,
						scrollable	: 'y',	  				
						recordName: "activoIntegrado",						
						recordClass: "HreRem.model.ActivoIntegrado",
					    items : [
							{
									
									xtype:'fieldset',
									title: HreRem.i18n('title.entidad.activo.datos'),
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
									cls:'',	    				
							        items: [
							        
							        	{
					            	    	name:		'idActivo',
											bind:		'{activoIntegrado.idActivo}',
											hidden: true
					            	    },
							        
							        	{
											xtype: 'textfieldbase',
											fieldLabel:  HreRem.i18n('fieldlabel.entidad.activo.buscador.proveedor'),
											name: 'buscadorCodigoEmisorField',
											bind: {
												value: '{activoIntegrado.codigoProveedorRem}'
											},
											readOnly: $AU.userIsRol(CONST.PERFILES['PROVEEDOR']),
											triggers: {
													
												buscarEmisor: {
													cls: Ext.baseCSSPrefix + 'form-search-trigger',
												    handler: 'buscarProveedor'
												}
												        
											},
											cls: 'searchfield-input sf-con-borde',
											emptyText:  HreRem.i18n('txt.buscar.emisor'),
											enableKeyEvents: true,
										    listeners: {
												specialKey: function(field, e) {
											    	if (e.getKey() === e.ENTER) {
											        	field.lookupController().buscarProveedor(field);											        			
											        }
											    }
											}
							            },
							            { 
											xtype: 'numberfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.entidad.activo.cuota.participacion'),
											bind: {
												value: '{activoIntegrado.participacion}'
											},
											decimalPrecision: 4,
											maxLength:8
											
										},
							        	{
				    						fieldLabel:  HreRem.i18n('fieldlabel.entidad.activo.subtipo.entidad'),
				    					    bind: {
				    				        	value: '{activoIntegrado.subtipoProveedorDescripcion}'
				    				        },
				    				        name: 'subtipoProveedorField',
				    				        readOnly: true
										},
							            
							            {
											xtype: 'datefieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.entidad.activo.fecha.inclusion'),
											bind:		'{activoIntegrado.fechaInclusion}',
											formatter: 'date("d/m/Y")'
										},
										{
				    						fieldLabel:  HreRem.i18n('fieldlabel.entidad.activo.nombre'),
				    					    bind: {
				    				        	value: '{activoIntegrado.nombreProveedor}'
				    				        },
				    				        name: 'nombreProveedor',
				    				        readOnly: true
										},
										{
											xtype: 'datefieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.entidad.activo.fecha.exclusion'),
											bind:		'{activoIntegrado.fechaExclusion}'
										},
										
										{
				    						fieldLabel:  HreRem.i18n('fieldlabel.entidad.activo.nif'),
				    					    bind: {
				    				        	value: '{activoIntegrado.nifProveedor}'
				    				        },
				    				        name: 'nifProveedor',
				    				        readOnly: true
										},
										{
											xtype: 'textareafieldbase',
				    						fieldLabel:  HreRem.i18n('fieldlabel.entidad.activo.observaciones'),
				    					    bind: {
				    				        	value: '{activoIntegrado.observaciones}'
				    				        },
				    				        colspan: 2
										},
										{
									
												xtype:'fieldsettable',
												title: HreRem.i18n('title.entidad.activo.condiciones.retencion.pago'),
												defaultType: 'textfieldbase',
												colspan: 2,
												flex: 1,
												collapsed: false,
												scrollable	: 'y',
												cls:'',	    				
										        items: [
										        
													{
														xtype:'checkboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.entidad.activo.retener.pagos.entidad'),
														bind:		'{activoIntegrado.retenerPagos}',
														reference: 'retenerPagosRef',
														listeners: {
															change: 'onRetenerPagosChange'
														}
													},
													{ 
														xtype: 'comboboxfieldbase',
											            fieldLabel:  HreRem.i18n('fieldlabel.entidad.activo.motivo.retencion.pago'),
													    bind: {
												        	store: '{comboRetencionPago}',
												           	value: '{activoIntegrado.motivoRetencionPago}',
												           	disabled: '{!activoIntegrado.retenerPagos}'
												        },
												        name: 'motivoRetencion'
												        
													 },
													 {
														xtype: 'datefieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.entidad.activo.fecha.inicio.retencion'),
														bind:{		
															value: '{activoIntegrado.fechaRetencionPago}',
															disabled: '{!activoIntegrado.retenerPagos}'
														},
														name: 'fechaInicioRetencion'
														
													}
										            	  
										        ]
						    			}
							            	  
							        ]
			    			}
			    			
			    		]
			
			    	}
			  ];
			  
			  me.callParent();
	}
});