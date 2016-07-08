Ext.define('HreRem.view.common.GridBaseEditableRowSinEdicion', { 
    extend		: 'Ext.grid.Panel',
    xtype		: 'gridBaseEditableRowSinEdicion',
	cls	: 'panel-base shadow-panel',
	
	/**
	 * Para mostrar una botonera arriba con botones de añadir, editar, eliminar
	 * @type Boolean
	 */
	topBar: false,
	idPrincipal: 'activo.id',
	
	/**
	 * Parámetro para decidir si queremos que el grid se carge después del bind
	 * 
	 */
	loadAfterBind: true,
	
	/**
	 * Si el grid será editable o no por permisos
	 * @type 
	 */
	editable: false,	
	borrarTodos: false,
	selModel: 'rowmodel',
	deleteUrl: 'agrupacion/deleteActivosAgrupacion',
	
	/**
	 * Para incluir configuración de seguridad.
	 * @type Object
	 */
	buttonSecurity: null,
	
	rowPluginSecurity: null,

	allowDeselect: true,
	
	allowBlank: true,
	
	minHeight: 240,
	
	flex: 1,
	
	viewConfig:{
    	markDirty:false
	},
	
	initComponent: function() {
		
		var me = this;
		
		//me.selModel = selModel;
		
		me.rowEditing = new Ext.grid.plugin.RowEditing({	
			saveBtnText  : HreRem.i18n('btn.saveBtnText'),
			cancelBtnText: HreRem.i18n('btn.cancelBtnText'),
			errorsText: HreRem.i18n('btn.errorsText'),
			dirtyText: HreRem.i18n('btn.dirtyText'),
            clicksToMoveEditor: 1,
            triggerEvent : 'none',
       	 	autoCancel: false
        });
		
		var addRowPluginFunction = function() {
			Ext.apply(me, {
				plugins: [me.rowEditing],
				editable: true
				});	
				
		};
		
		if(Ext.isEmpty(me.rowPluginSecurity)) {		
			addRowPluginFunction();		
		} else {
			$AU.confirmRolesToFunctionExecution(addRowPluginFunction, me.rowPluginSecurity);
		}
        
		

	     me.listeners = {
	     	
        	edit: function(editor, context, eOpts) {
				me.mask("Guardando..");
        		context.record.save({
                                
                        params: {
                        	//TODO: Si se reutiliza fuera de agrupación, tener en cuenta el nombre del parámetro
                            idAgrupacion: this.up('{viewModel}').getViewModel().get(me.idPrincipal)
                        },
                        
                        success: function (a, operation, c) {
                        	//debugger;
                            context.store.load();
							me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
							 me.unmask();
                        },
                        
                        failure: function (a, operation) {
                        	
                        	context.store.load();
                        	try {
                        		var response = Ext.JSON.decode(operation.getResponse().responseText)
                        		
                        	}catch(err) {}
                        	
                        	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msg)) {
                        		me.fireEvent("errorToast", response.msg);
                        	} else {
                        		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                        	}                        	
							me.unmask();
                        }
                    });
                            
        		me.disableAddButton(false);
        		me.getSelectionModel().deselectAll();
        	}, 
        	
        	canceledit: function(editor){

				me.disableAddButton(false);
        		me.getSelectionModel().deselectAll();
        		if(editor.isNew) {
        			me.getStore().remove(me.getStore().getAt(0));
        			editor.isNew=false;
        		}
        	},
        	
        	selectionchange: function(grid, records) {
				
        		if(!records.length)	me.disableRemoveButton(true);
            },
            
            rowclick: function() {
                me.disableRemoveButton(false);
            },

	        rowdblclick:function(){
	        	me.getSelectionModel().deselectAll();
	        	//me.disableAddButton(true);
	        	me.disableRemoveButton(true);
	        },
            
            containerclick:function(editor){
            	me.getSelectionModel().deselectAll();
        	},
        	afterbind:function(grid) {
        		if (me.loadAfterBind) {
					grid.getStore().load();
				}
			}
        	
        	

    	};
	
		
		if(me.topBar) {

			var configAddButton = {iconCls:'x-fa fa-plus', itemId:'addButton', handler: 'onAddClick', scope: this };
			var configRemoveButton = {iconCls:'x-fa fa-minus', itemId:'removeButton', handler: 'onDeleteClick', scope: this, disabled: true };
			var configRemoveAllButton = {iconCls:'x-fa fa fa-times', itemId:'removeAllButton', handler: 'onDeleteAllClick', scope: this, disabled: false };
			
			if(!Ext.isEmpty(me.buttonSecurity)) {
				
				for(var key in me.buttonSecurity) {					
					configAddButton[key] = me.buttonSecurity[key];
					configRemoveButton[key] = me.buttonSecurity[key];
					if (me.borrarTodos) {
						configRemoveAllButton[key] = me.buttonSecurity[key];
					}					
				
				}
			}
			
			if (me.borrarTodos) {
				
				me.tbar = {
		    		xtype: 'toolbar',
		    		dock: 'top',
		    		items: [configAddButton, configRemoveButton, configRemoveAllButton]
	    		};
				
			} else {
				
				me.tbar = {
		    		xtype: 'toolbar',
		    		dock: 'top',
		    		items: [configAddButton, configRemoveButton]
	    		};
				
			}
			
			

		};
		
		me.callParent();	
		
	},
	
	onAddClick: function(btn){
    	
		var me = this;

		var rec = Ext.create(me.getStore().config.model);

        me.getStore().insert(0, rec);
        me.rowEditing.startEdit(0,0);
        me.rowEditing.isNew = true;
        me.disableAddButton(true);
    },
    
    onDeleteClick: function(btn){
    	
    	var me = this;

        Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.eliminacion'),
			   msg: HreRem.i18n('msg.desea.eliminar'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	
			    		me.rowEditing.cancelEdit();
			    		
			    		var seleccionados = me.getSelectionModel().getSelection();
			    		
			    		var idSeleccionados = [];
			    		for (var i=0; i<seleccionados.length; i++) {
			    			idSeleccionados[i] = seleccionados[i].id;
			    		}

			        	var url =  $AC.getRemoteUrl(me.deleteUrl);
			    		Ext.Ajax.request({
			    			
			    		     url: url,
			    		     params: {id : idSeleccionados},
			    		
			    		     success: function (a, operation, context) {
                                	
                                	me.getStore().remove(seleccionados);
                                	me.getStore().load();
                                    //context.store.load();
                                    Ext.toast({
									     html: 'LA OPERACIÓN SE HA REALIZADO CORRECTAMENTE',
									     width: 360,
									     height: 100,
									     align: 't'
									 });
									 me.unmask();
                                },
                                
                                failure: function (a, operation, context) {
                                	//context.store.load();
                                	  Ext.toast({
									     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
									     width: 360,
									     height: 100,
									     align: 't'									     
									 });
									 me.unmask();
                                }
			    		     
			    		 });
				    		
			    		
			    		
			    	/*	
			            var sm = me.getSelectionModel();
			            sm.getSelection()[0].erase({
                                
                                success: function (a, operation, context) {
                                	
                                    //context.store.load();
                                    Ext.toast({
									     html: 'LA OPERACIÓN SE HA REALIZADO CORRECTAMENTE',
									     width: 360,
									     height: 100,
									     align: 't'
									 });
									 me.unmask();
                                },
                                
                                failure: function (a, operation, context) {
                                	//context.store.load();
                                	  Ext.toast({
									     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
									     width: 360,
									     height: 100,
									     align: 't'									     
									 });
									 me.unmask();
                                }
                            });

			            if (me.getStore().getCount() > 0) {
			                sm.select(0);
			            }*/
			        }
			   }
		});

    },
    
    onDeleteAllClick: function(btn){
    	
    	var me = this;

        Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.eliminacion.todos'),
			   msg: HreRem.i18n('msg.desea.eliminar.todos'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	
			    		me.rowEditing.cancelEdit();
			    		
			    		var idAgrupacionBorrar = me.getStore().data.items[0].data.agrId;

			        	var url =  $AC.getRemoteUrl('agrupacion/deleteAllActivosAgrupacion');
			    		Ext.Ajax.request({
			    			
			    		     url: url,
			    		     params: {id : idAgrupacionBorrar},
			    		
			    		     success: function (a, operation, context) {
                                	
                                	me.getStore().removeAll();
                                	me.getStore().load();
                                    //context.store.load();
                                    Ext.toast({
									     html: 'LA OPERACIÓN SE HA REALIZADO CORRECTAMENTE',
									     width: 360,
									     height: 100,
									     align: 't'
									 });
									 me.unmask();
                                },
                                
                                failure: function (a, operation, context) {
                                	//context.store.load();
                                	  Ext.toast({
									     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
									     width: 360,
									     height: 100,
									     align: 't'									     
									 });
									 me.unmask();
                                }
			    		     
			    		 });

			        }
			   }
		});

    },
    
    
    disableAddButton: function(disabled) {
    	
    	var me = this;
    	
    	if (me.topBar && me.editable) {
    		me.down('#addButton').setDisabled(disabled);    		
    	}
    },
    
    disableRemoveButton: function(disabled) {
    	
    	var me = this;
    	
    	if (me.topBar && me.editable) {
    		me.down('#removeButton').setDisabled(disabled);    		
    	}
    },
    
    privates: {
               
				/**
				* Overrride del método original para en el momento de hacer el bind del value, lanzar el evento 
				* afterbind
                * @param {} value
                * @param {} oldValue
                * @param {} binding
                */
               onBindNotify: function(value, oldValue, binding) {
               binding.syncing = (binding.syncing + 1) || 1;
               this[binding._config.names.set](value);
               --binding.syncing;
               this.fireEvent("afterbind", this);
               
               }
   
   }
   

    
    
});