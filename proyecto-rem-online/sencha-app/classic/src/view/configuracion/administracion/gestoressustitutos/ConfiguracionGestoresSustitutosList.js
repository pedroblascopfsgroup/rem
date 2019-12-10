Ext.define('HreRem.view.configuracion.administracion.gestoressustitutos.ConfiguracionGestoresSustitutosList', {
    extend			: 'HreRem.view.common.GridBaseEditableRow',
    xtype			: 'configuraciongestoressustitutoslist',
	reference		: 'configuracionGestoresSustitutosList',
	idPrincipal 	: 'gestorsustituto.id',
	editOnSelect	: false,
    bind			: {
        store: '{configuraciongestoressustitutos}'
    },

    initComponent: function () {
     	var me = this;
     	
     	var estadoRenderer =  function(value, cell, record) {
        	
        	var src = '',
        	alt = '';
        	
        	if (value) {
        		src = 'icono_OK.svg';
        		alt = 'OK';
        	} else { 
        		src = 'icono_KO.svg';
        		alt = 'KO';
        	} 

        	return '<div> <img src="resources/images/'+src+'" alt ="'+alt+'" width="15px"></div>';
        };
        
        me.topBar = $AU.userHasFunction(['ADD_QUITAR_GESTORESSUSTITUTOS']);
        
		me.columns = [
		        {
		            dataIndex: 'id',		       
		            hidden: true
		        },		        
		        {
		        	dataIndex: 'usernameOrigen',
		            text: HreRem.i18n('header.gestor.sustituir'),
		            flex: 1,
		            renderer: function(value, cell, record) {
		            	var nombre = record.get("nombreOrigen");
		            	if(!Ext.isEmpty(nombre)) {
		            		return value + ' - ' + nombre;
		            	}
		            },
		            editor: { 
						xtype: 'comboboxsearchfieldbase',
						allowBlank: false,
						bind: {
							store: '{comboUsuariosGestorSustituto}'
						}
					}
		        },
			    {
		            dataIndex: 'usernameSustituto',
		            text: HreRem.i18n('header.gestor.sustituto'),
		            flex: 1,
		            renderer: function(value, cell, record) {
		            	var nombre = record.get("nombreSustituto");
		            	if(!Ext.isEmpty(nombre)) {
		            		return value + ' - ' + nombre;
		            	}
		            },
		            editor: { 
						xtype: 'comboboxsearchfieldbase',
						allowBlank: false,
						bind: {
							store: '{comboUsuariosGestorSustituto}'
						}
					}
		        },
		        {
		            dataIndex: 'fechaInicio',
		            text: HreRem.i18n('header.fecha.inicio'),
		            flex: .5,
		            formatter: 'date("d/m/Y")',
		            editor: {
			        	xtype:'datefield',
			        	reference: 'fechaini',
			        	allowBlank: false,
			        	listeners:{
			        		change: function(field, newValue, oldValue){
			        			if(field.up().down('[reference=fechafin]').getValue() > newValue){
			        				field.up().down('[reference=fechafin]').setValue();
			        			}
			        			field.up().down('[reference=fechafin]').setMinValue(newValue);
			        		}
			        	}
		            }
		        },
		        {
		            dataIndex: 'fechaFin',
		            text: HreRem.i18n('header.fecha.fin'),
		            flex: .5,
		            formatter: 'date("d/m/Y")',		            
		            editor: {
			        	xtype:'datefield',
			        	reference: 'fechafin'			        	
	        		}
		        },
		        {
		            text: HreRem.i18n('header.gestor.vigente'),
		            renderer: estadoRenderer,
		            flex: .2,
		            dataIndex: 'vigente',
		            align: 'center'
		        }
		
		];
		me.editFuncion=function(editor, context){
		   		
	   		var me= this;
			me.mask(HreRem.i18n("msg.mask.espere"));
	
				if (me.isValidRecord(context.record)) {				
					
	        		context.record.save({
	
	                    success: function (a, operation, c) {
	                        if (context.store.load) {
	                        	context.store.load();
	                        }
	                        me.unmask();
	                        me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));																			
							me.saveSuccessFn();								
							
	                    },
	                    
						failure: function (a, operation) {
	                    	
	                    	context.store.load();
	                    	try {
	                    		var response = Ext.JSON.decode(operation.getResponse().responseText)
	                    		
	                    	}catch(err) {}
	                    	
	                    	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.data)) {
	                    		me.fireEvent("errorToast", response.data);
	                    	} else {
	                    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                    	}                        	
							me.unmask();
	                    }
	                });	                            
	        		me.disableAddButton(false);
	        		me.disablePagingToolBar(false);
	        		me.getSelectionModel().deselectAll();
	        		editor.isNew = false;
	        		
				}
		        
		   };
		   me.onDeleteClick= function (btn) {
			var me= this;
			var numAgrupacionRem= me.getSelection()[0].get('id');
			Ext.Msg.show({
				   title: HreRem.i18n('title.confirmar.eliminacion'),
				   msg: HreRem.i18n('msg.desea.eliminar'),
				   buttons: Ext.MessageBox.YESNO,
				   fn: function(buttonId) {
				        if (buttonId == 'yes') {
				        	me.mask(HreRem.i18n("msg.mask.espere"));
				    		me.rowEditing.cancelEdit();
				            var sm = me.getSelectionModel();
				            sm.getSelection()[0].erase({
				            	success: function (a, operation, c) {
	                                me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
									me.unmask();
									me.deleteSuccessFn();
	                            },
	                            
	                            failure: function (a, operation) {
	                            	var data = {};
	                            	try {
	                            		data = Ext.decode(operation._response.responseText);
	                            	}
	                            	catch (e){ };
	                            	if (!Ext.isEmpty(data.msg)) {
	                            		me.fireEvent("errorToast", data.msg);
	                            	} else {
	                            		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                            	}
									me.unmask();
									me.deleteFailureFn();
	                            }
	                        }
				            	
				            	
				            );
				            if (me.getStore().getCount() > 0) {
				                sm.select(0);
				            }
				        }
				   }
				});
			};
		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'gestorSustitutoPaginationToolbar',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{configuraciongestoressustitutos}'
		            }
		        }
		    ];

		    me.callParent();
   }
});