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
		        var fieldEmisor = me.down('field[name=buscadorNifEmisorField]'); 
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
    	me.setTitle(HreRem.i18n('title.nuevo.gasto'));
    	me.buttons = [ { itemId: 'btnGuardar', text: 'Crear', handler: 'onClickBotonGuardarGasto'},  { itemId: 'btnCancelar', text: 'Cancelar', handler: 'onClickBotonCancelarGasto'}];
    	
    	me.items = [
    	
			    	{
			    		xtype: 'formBase',
			    		collapsed: false,
						scrollable	: 'y',	  				
						recordName: "gastoNuevo",						
						recordClass: "HreRem.model.GastoProveedor",
					    items : [
								{
									
									xtype:'fieldset',
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
									cls:'',	    				
							        items: [
							        
												{
				    					        	fieldLabel:  HreRem.i18n('fieldlabel.referencia.emisor'),
				    					        	bind: {
				    				            		value: '{gastoNuevo.referenciaEmisor}'
				    				            	},
				    				            	allowBlank: true
				    				            	
												},
												/*{
													xtype: 'comboboxfieldbase',
				    					        	fieldLabel:  HreRem.i18n('fieldlabel.tipo'),
				    					        	bind: {
				    				            		store: '{comboTiposGasto}',
				    				            		value: '{gastoNuevo.tipoGastoCodigo}'
				    				            	},
				    				            	allowBlank: false
												},
												{
													xtype: 'comboboxfieldbase',
				    					        	fieldLabel:  HreRem.i18n('fieldlabel.subtipo'),
				    					        	bind: {
				    				            		store: '{comboSubtiposNuevoGasto}',
				    				            		value: '{gastoNuevo.subtipoGastoCodigo}',
				    				            		disabled: '{!gastoNuevo.tipoGastoCodigo}'
				    				            	},
				    				            	allowBlank: false
												},*/
												
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
													fieldLabel: HreRem.i18n('fieldlabel.nif.emisor'),
													bind:		'{gastoNuevo.nifEmisor}',
													name: 'buscadorNifEmisorField',												
													triggers: {
														
														buscarEmisor: {
												            cls: Ext.baseCSSPrefix + 'form-search-trigger',
												             handler: function(field) {
												            	field.lookupController().buscarProveedor(field);
												            }
												        }
													},
													cls: 'searchfield-input sf-con-borde',
													emptyText: HreRem.i18n('txt.buscar.emisor'),
													enableKeyEvents: true,
											        listeners: {
											        	specialKey: function(field, e) {
											        		if (e.getKey() === e.ENTER && !Ext.isEmpty(field.getValue())) {
											        			field.lookupController().buscarProveedor(field);											        			
											        		}
											        	}
											        }
							            	    },
							            	    {
							            	    	fieldLabel: HreRem.i18n('fieldlabel.nombre.emisor'),
							            	    	name:	'nombreEmisor',
							            	    	allowBlank: false,
													readOnly: true
							            	    },
							            	    {
							            	    	xtype: 'datefieldbase',
							            	    	fieldLabel: HreRem.i18n('fieldlabel.fecha.emision'),
													bind:		'{gastoNuevo.fechaEmision}',
													allowBlank: false
							            	    },
							            	    {
													xtype: 'comboboxfieldbase',
				    					        	fieldLabel:  HreRem.i18n('fieldlabel.destinatario.gasto'),
				    					        	bind: {
				    				            		store: '{comboDestinatarios}',
				    				            		value: '{gastoNuevo.destinatarioGastoCodigo}'
				    				            	},
				    				            	allowBlank: false
												}
							            	  
							            ]
				
			    			}	
			    		],
			    		getErrorsExtendedFormBase: function() {
			    			var errores = [],   		
			    			error, 	    			
			    			nombreEmisor = me.down('[name=nombreEmisor]');
			    			
			    			if(Ext.isEmpty(nombreEmisor.getValue())) {
			    				error = HreRem.i18n("txt.validacion.emisor.no.seleccionado");
   								errores.push(error);
   								me.down('[name=buscadorNifEmisorField]').markInvalid(error); 
			    			}
			    		}
			
			    	}
			  ];
			  
			  me.callParent();
	}
});