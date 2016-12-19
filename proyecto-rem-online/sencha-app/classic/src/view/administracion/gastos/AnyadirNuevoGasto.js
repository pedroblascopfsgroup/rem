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
    codEmisor: null,
    
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
			if(!Ext.isEmpty(me.codEmisor)) {
		        var fieldEmisor = me.down('field[name=buscadorCodigoProveedorRem]'); 
	        	fieldEmisor.setValue(me.codEmisor);
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
			proxy: {
				type: 'uxproxy',
				actionMethods: {read: 'POST'},
				remoteUrl: 'gastosproveedor/searchProveedoresByNif'
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
													xtype: 'comboboxfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.gasto.nif.emisor'),													
													name: 'buscadorCodigoProveedorRem',													
													hideTrigger: true,
													editable: true,
													queryMode: 'remote',
													autoLoadOnValue: false,
													store: storeEmisoresGasto,
													emptyText: HreRem.i18n('txt.buscar.emisor'),
													queryParam: 'nifProveedor',
													displayField	: 'nifProveedor',
    												valueField		: 'codigo',
    												tpl: Ext.create('Ext.XTemplate',
									            		    '<tpl for=".">',
									            		        '<div class="x-boundlist-item">{nombreProveedor} - {subtipoProveedorDescripcion}</div>',
									            		    '</tpl>'
									            	),
									            	displayTpl:  Ext.create('Ext.XTemplate',
									            		    '<tpl for=".">',
									            		        '{nifProveedor}',
									            		    '</tpl>'
									            	),
											        listeners: {
											        	beforequery: function (op, e) {
											        		// Sólamente búscamos a partir de 9 caracteres
											        		if(!Ext.isEmpty(op.query) && op.query.length==9) {
											        			return true;
											        		} else {
											        			return false;
											        		}
											        		
											        	},
											        	change: function(combo, newValue) {
											        		var nombre = "";
											        		var codigo = "";
											        		if(combo.getSelectedRecord()) {
											        			nombre = combo.getSelectedRecord().get('nombreProveedor'); 
											        			codigo = combo.getSelectedRecord().get('codigo');
											        		} else {
											        			combo.lastQuery = "";
											        			combo.store.load();
											        		}
											        		combo.up('form').down('[name=nombreEmisor]').setValue(nombre);
											        		combo.up('form').down('[name=codigoEmisor]').setValue(codigo);
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
							            	    	fieldLabel: HreRem.i18n('fieldlabel.gasto.codigo.rem.emisor'),
							            	    	name:	'codigoEmisor',
							            	    	allowBlank: false,
													readOnly: true
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
   								me.down('[name=buscadorCodigoProveedorRem]').markInvalid(error); 
			    			}
			    		}
			
			    	}
			  ];
			  
			  me.callParent();
	}
});