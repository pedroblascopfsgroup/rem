Ext.define('HreRem.view.administracion.gastos.AnyadirNuevoGasto', {
    extend		: 'HreRem.view.common.WindowBase',
    xtype		: 'anyadirnuevogasto',
    layout	: 'fit',
    width	: Ext.Element.getViewportWidth() / 2.2,    
        
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
    
    requires: ['HreRem.model.GastoProveedor', 'HreRem.view.administracion.gastos.GastoRefacturadoGrid'],
    
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
									        columns: 2,
									        trAttrs: {height: '45px', width: '100%'},
									        tdAttrs: {width: '100%'},
									        tableAttrs: {
									            style: {
									                width: '90%'
												}
									        }
									},
									defaultType: 'textfieldbase',
									collapsed: false,
									scrollable	: 'y', 
									align:'left',
							        items: [
												{
													xtype: 'textfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gasto.nif.emisor'),
													colspan:1,
													width: '500px',
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
								                /////	columna2
								                {
								                	xtype:'checkboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gasto.refacturable'),
													reference: 'checkboxActivoRefacturable',
													colspan:1,
													name: 'nombrePropietario',
													bind:'{gasto.gastoRefacturable}',			
													width: '500px'
												},
												////
												{
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gasto.emisor'),	
													colspan:1,
													reference: 'comboProveedores',
													allowBlank: false,
													editable: false,
													autoLoadOnValue: false,
													matchFieldWidth: false,
													queryMode: 'local',
													store: storeEmisoresGasto,
													loadOnBind: false,
													emptyText: HreRem.i18n('txt.seleccionar.emisor'),
    												valueField		: 'id',
    												bind: {
    													value: '{gastoNuevo.idEmisor}',
    													disabled: '{!buscadorNifEmisorField.value}'
    												},
    												tpl: Ext.create('Ext.XTemplate',
									            		    '<tpl for=".">',
									            		        '<div class="x-boundlist-item">{codigo} - {nombreProveedor} - {subtipoProveedorDescripcion} - {estadoProveedorDescripcion}</div>',
									            		    '</tpl>'
									            	),
									            	displayTpl:  Ext.create('Ext.XTemplate',
									            		    '<tpl for=".">',
									            		        '{codigo} - {nombreProveedor} - {subtipoProveedorDescripcion} - {estadoProveedorDescripcion}',
									            		    '</tpl>'
									            	)
							            	    },
							            	    /////	columna2
								                {
													xtype: 'textfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gastos.a.refacturar'),
													width: '500px',
													colspan:1,
													reference: 'gastosArefacturar',	
													triggers: {														
															buscarEmisor: {
													            cls: Ext.baseCSSPrefix + 'form-search-trigger',
													            handler: 'buscarGastosRefacturables'
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
												    bind: {
														disabled: '{checkboxActivoRefacturable.checked}'
													},
												    publishes: 'value'
												},
												////
												{ 
													xtype: 'comboboxfieldbase',
									               	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
									               	colspan:1,
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
										    	 /////	columna2
								                {
													
													//fieldLabel: HreRem.i18n('fieldlabel.gasto.nombre.propietario'),
													xtype: 'gastoRefacturadoGrid', 
													width: '400px',
													colspan: 1,
													rowspan: 9,
													reference: 'gastoRefacturadoGrid',
													bind: {
														disabled: '{checkboxActivoRefacturable.checked}'
													}
											
												},
												////
											    { 
													xtype: 'comboboxfieldbase',
									               	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
									               	colspan:2,
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
							            	    	colspan:2,
													bind:		'{gastoNuevo.fechaEmision}',
													allowBlank: false
							            	    },
							            	    {
				    					        	fieldLabel:  HreRem.i18n('fieldlabel.referencia.emisor'),
				    					        	colspan:2,
				    					        	bind: {
				    				            		value: '{gastoNuevo.referenciaEmisor}'
				    				            	},
				    				            	allowBlank: false
				    				            	
												},							            	    
							            	    {
													xtype: 'comboboxfieldbase',
				    					        	fieldLabel:  HreRem.i18n('fieldlabel.destinatario.gasto'),
				    					        	colspan:2,
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
													colspan:2,
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
													colspan:2,
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