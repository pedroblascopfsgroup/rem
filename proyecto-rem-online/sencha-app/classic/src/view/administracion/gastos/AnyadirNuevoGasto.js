Ext.define('HreRem.view.administracion.gastos.AnyadirNuevoGasto', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirnuevogasto',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 3,    
        
    parent: null,
    		
    modoEdicion: null,
    
    /**
     * Cuando un proveedor crea un gasto, no debe poder seleccionar otros proveedores.
     * En caso de recibir un nif de emisor, se deshabilita la búsqueda y se asigna el nif recibido.
     * @type 
     */
    nifEmisor: null,
    
    controller: 'gastodetalle',
    viewModel: {
        type: 'gastodetalle'
    },
    
    requires: ['HreRem.model.GastoProveedor'],
    
    listeners: {    
		boxready: function(window) {
			var me = this,
			form = me.down('formBase');
			form.setBindRecord(Ext.create('HreRem.model.GastoProveedor'));
			if(!Ext.isEmpty(me.nifEmisor)) {
		        var fieldEmisor = me.down('field[reference=buscadorNifEmisorField]');
	        	fieldEmisor.setValue(me.nifEmisor);
	        	fieldEmisor.setReadOnly(true);
	        	fieldEmisor.lookupController().buscarProveedor(fieldEmisor);		
			}
			        	
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
    	
    	var storeEmisoresGasto = new Ext.data.Store({  
    		model: 'HreRem.model.Proveedor',
    		autoLoad: false,
    		pageSize: null,
			proxy: {
				type: 'uxproxy',
				actionMethods: {read: 'POST'},
				remoteUrl: 'gastosproveedor/searchProveedoresByNif'
			}   	
    	}); 

    	var storeDestinatarios = new Ext.data.Store({
    		model: 'HreRem.model.ComboBase',
    		autoLoadOnValue: true,
			proxy: {
				type: 'uxproxy',
				remoteUrl: 'generic/getDiccionario',
				extraParams: {diccionario: 'destinatariosGasto'}
			}    		
    	});    	
    	
    	me.setTitle(HreRem.i18n('title.nuevo.gasto'));
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Crear', handler: 'onClickBotonGuardarGasto'},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarGasto'}];
    	
    	me.items = [
    	
			    	{
			    		xtype: 'formBase',
			    		cls: 'anyadir-gasto-form',
			    		layout: 'fit',			    		
			    		collapsed: false,	  				
						recordName: "gastoNuevo",						
						recordClass: "HreRem.model.GastoProveedor",
					    items : [
								{
									xtype:'fieldset',
									cls: 'x-fieldset-anyadir-gasto',
									flex: 1,
									layout: {
									        type: 'table',
									        // The total column count must be specified here
									        columns: 1,
									        trAttrs: {height: '45px', width: '100%'},
									        tdAttrs: {width: '100%'},
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
													xtype: 'textfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gasto.nif.emisor'),		
													reference: 'buscadorNifEmisorField',
													readOnly: $AU.userIsRol(CONST.PERFILES['PROVEEDOR']),
													triggers: {														
															buscarEmisor: {
													            cls: Ext.baseCSSPrefix + 'form-search-trigger',
													            handler: 'buscarProveedor'
													        }
													        
													},
													cls: 'searchfield-input sf-con-borde',
													enableKeyEvents: true,
											        listeners: {
												        	specialKey: function(field, e) {
												        		if (e.getKey() === e.ENTER) {
												        			field.lookupController().buscarProveedor(field);											        			
												        		}
												        	},
												        	change: function(field, newvalue) {										        		
												        		if(Ext.isEmpty(newvalue)) {
												        			field.up("form").down("[reference=comboProveedores]").reset()
												        		}
												        	
												        	}
												    },
												    publishes: 'value'
								                },	
												{
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gasto.emisor'),													
													reference: 'comboProveedores',
													allowBlank: false,
													editable: false,
													autoLoadOnValue: false,
													queryMode: 'local',
													store: storeEmisoresGasto,
													loadOnBind: false,
													emptyText: HreRem.i18n('txt.seleccionar.emisor'),
    												valueField		: 'codigo',
    												bind: {
    													value: '{gastoNuevo.codigoEmisor}',
    													disabled: '{!buscadorNifEmisorField.value}'
    												},
    												tpl: Ext.create('Ext.XTemplate',
									            		    '<tpl for=".">',
									            		        '<div class="x-boundlist-item">{codigo} - {nombreProveedor} - {subtipoProveedorDescripcion}</div>',
									            		    '</tpl>'
									            	),
									            	displayTpl:  Ext.create('Ext.XTemplate',
									            		    '<tpl for=".">',
									            		        '{codigo} - {nombreProveedor} - {subtipoProveedorDescripcion}',
									            		    '</tpl>'
									            	)
							            	    },					        
												{ 
													xtype: 'comboboxfieldbase',
									               	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
									               	reference: 'tipoGasto',
					        						chainedStore: 'comboSubtipoGasto',
													chainedReference: 'subtipoGastoCombo',
											      	bind: {
										           		store: '{comboTiposGasto}',
										           		value: '{gastoNuevo.tipoGastoCodigo}'
										         	},
										         	listeners: {
									                	select: 'onChangeChainedCombo'
									            	},
										         	allowBlank: false
										    	},
											    { 
													xtype: 'comboboxfieldbase',
									               	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
									               	reference: 'subtipoGastoCombo',
											      	bind: {
										           		store: '{comboSubtiposNuevoGasto}',
										           		value: '{gastoNuevo.subtipoGastoCodigo}',
										           		disabled: '{!gastogastoNuevo.tipoGastoCodigo}'
										         	},
										         	allowBlank: false
											    },
							            	    {
							            	    	xtype: 'datefieldbase',
							            	    	fieldLabel: HreRem.i18n('fieldlabel.fecha.emision'),
													bind:		'{gastoNuevo.fechaEmision}',
													allowBlank: false
							            	    },
							            	    {
				    					        	fieldLabel:  HreRem.i18n('fieldlabel.referencia.emisor'),
				    					        	bind: {
				    				            		value: '{gastoNuevo.referenciaEmisor}'
				    				            	},
				    				            	allowBlank: false
				    				            	
												},							            	    
							            	    {
													xtype: 'comboboxfieldbase',
				    					        	fieldLabel:  HreRem.i18n('fieldlabel.destinatario.gasto'),
				    					        	store: storeDestinatarios,
				    					        	bind: {
				    				            		value: '{gastoNuevo.destinatarioGastoCodigo}'
				    				            	},
				    				            	listeners: {
				    				            		afterbind: function(combo, value) {
				    				            			// Para poner por defecto una opción.
				    				            			if(Ext.isEmpty(value)) {
				    				            				combo.up('form').getBindRecord().set('destinatarioGastoCodigo', CONST.TIPOS_DESTINATARIO_GASTO['PROPIETARIO']);				    				            				
				    				            			}
				    				            		},
				    				            		change: function(combo, newValue) {
				    				            			var disabled = CONST.TIPOS_DESTINATARIO_GASTO['PROPIETARIO'] != newValue;
			    				            				combo.up('form').down('[name=buscadorNifPropietarioField]').setDisabled(disabled);
			    				            				combo.up('form').down('[name=nombrePropietario]').setDisabled(disabled);
			    				            				if(disabled) {
			    				            					combo.up('form').down('[name=buscadorNifPropietarioField]').reset();
			    				            					combo.up('form').down('[name=nombrePropietario]').reset();
			    				            				}
				    				            			
				    				            		}
				    				            	},
				    				            	allowBlank: false
												},
												{
													xtype: 'textfieldbase',
													fieldLabel:  HreRem.i18n('fieldlabel.gasto.nif.propietario'),
													name: 'buscadorNifPropietarioField',
													disabled: true,
													bind: {
														value: '{gastoNuevo.nifPropietario}'
													},
													allowBlank: false,
													triggers: {
														
															buscarEmisor: {
													            cls: Ext.baseCSSPrefix + 'form-search-trigger',
													            handler: 'buscarPropietario'
													        }
													},
													cls: 'searchfield-input sf-con-borde',
													emptyText:  HreRem.i18n('txt.buscar.propietario'),
													enableKeyEvents: true,
											        listeners: {
											        	specialKey: function(field, e) {
											        		if (e.getKey() === e.ENTER) {
											        			field.lookupController().buscarPropietario(field);											        			
											        		}
											        	},
											        	
											        	blur: function(field, e) {											        		
											        		if(!Ext.isEmpty(field.getValue())) {
											        			field.lookupController().buscarPropietario(field);
											        		}
											        	}
											        	
											        	
											        }
							                	},
							                	{
													xtype: 'textfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gasto.nombre.propietario'),
													name: 'nombrePropietario',
													disabled: true,
													readOnly: true,
													allowBlank: false
												}
							            	  
							            ]
				
			    			}	
			    		]
			
			    	}
			  ];
			  
			  me.callParent();
	}
});