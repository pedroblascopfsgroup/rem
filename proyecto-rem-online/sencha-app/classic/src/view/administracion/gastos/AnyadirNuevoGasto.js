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
									        tableAttrs: {
									            style: {
									                width: '100%'
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
													reference: 'buscadorNifEmisorField',	
													readOnly: $AU.userIsRol(CONST.PERFILES['PROVEEDOR']),
													name: 'nifEmisor',
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
												        		if (e.getKey() === e.ENTER && field.enableKeyEvents === true) {
												        			field.lookupController().buscarProveedor(field);											        			
												        		}
												        	},
												        	change: function(field, newvalue) {	
												        		if(Ext.isEmpty(newvalue)) {
												        			field.up("form").down("[reference=comboProveedores]").reset();
												        		}
												        	
												        	},
												        	blur: function(field, e) {											        		
												        		if(!Ext.isEmpty(field.getValue()) && field.enableKeyEvents === true) {
												        			field.lookupController().buscarProveedor(field);
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
													name: 'checkboxActivoRefacturable',
													bind: {
										           		value: '{gastoNuevo.gastoRefacturable}'										 
										         	}
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
									            	),
									            	listeners: {
									            		change: 'mostrarGastosRefacturables'
									            	}
							            	    },
							            	    /////	columna2
								                {
													xtype: 'textfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gastos.a.refacturar'),
													colspan:1,
													reference: 'gastosArefacturar',
													name: 'gastosArefacturar',
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
												        			field.lookupController().buscarGastosRefacturables(field);											        			
												        		}
												        	},
												        	change: function(field, newvalue) {										        		
												        		if(Ext.isEmpty(newvalue)) {
												        			field.lookupController().buscarGastosRefacturables(field);
												        		}
												        	
												        	}
												    },
												    bind: {
														value: '{gastoNuevo.listaTotalGastosRefacturados}'
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
													
													//fieldLabel: HreRem.i18n('fieldlabel.nombre.propietario'),
													xtype: 'gastoRefacturadoGrid', 
													colspan: 1,
													rowspan: 9,
													reference: 'gastoRefacturadoGrid',
													name: 'gastoRefacturadoGrid'									
												},
							            	    {
							            	    	xtype: 'datefieldbase',
							            	    	fieldLabel: HreRem.i18n('fieldlabel.fecha.emision'),
							            	    	colspan:1,
													bind:		'{gastoNuevo.fechaEmision}',
													allowBlank: false
							            	    },
							            	    {
				    					        	fieldLabel:  HreRem.i18n('fieldlabel.referencia.emisor'),
				    					        	colspan:1,
				    					        	bind: {
				    				            		value: '{gastoNuevo.referenciaEmisor}'
				    				            	},
				    				            	allowBlank: false
				    				            	
												},							            	    
							            	    {
													xtype: 'comboboxfieldbase',
				    					        	fieldLabel:  HreRem.i18n('fieldlabel.destinatario.gasto'),
				    					        	colspan:1,
				    					        	name: 'destinatarioGastoCodigo',
				    					        	store: storeDestinatarios,
				    					        	bind: {
				    				            		value: '{gastoNuevo.destinatarioGastoCodigo}',
				    				            		readOnly: '{gastoRefacturadoGrid.store}'
				    				            	},
				    				            	listeners: {
				    				            		afterbind: function(combo, value) {
				    				            			// Para poner por defecto una opción.
				    				            			if(Ext.isEmpty(value)) {
				    				            				combo.up('form').getBindRecord().set('destinatarioGastoCodigo', CONST.TIPOS_DESTINATARIO_GASTO['PROPIETARIO']);				    				            				
				    				            			}
				    				            		},
				    				            		change: 'mostrarGastosRefacturables'
				    				            	},
				    				            	allowBlank: false
												},
												{
													xtype: 'textfieldbase',
													fieldLabel:  HreRem.i18n('fieldlabel.gasto.nif.propietario'),
													colspan:1,
													reference:'buscadorNifPropietarioField',
													name: 'buscadorNifPropietarioField',
													//disabled: true,
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
											        	},
											        	change: 'mostrarGastosRefacturables'								        	
											        }
							                	},
							                	{
													xtype: 'textfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gasto.nombre.propietario'),
													colspan:1,
													name: 'nombrePropietario',
													//disabled: true,
													readOnly: true,
													allowBlank: true,
													listeners: {
														change: 'mostrarGastosRefacturables'
													}
													
												}
							            	  
							            ]
				
			    			}	
			    		]
			
			    	}
			  ];
			  
			  me.callParent();
	}
});