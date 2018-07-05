Ext.define('HreRem.view.common.GridBaseEditableRow', { 
    extend		: 'Ext.grid.Panel',
    xtype		: 'gridBaseEditableRow',
	
	/**
	 * Para mostrar una botonera arriba con botones de añadir, editar, eliminar
	 * @type Boolean
	 */
	topBar: false,
	
	/**
	 * Para mostrar en la botonera el boton de añadir
	 * @type Boolean
	 */
	addButton: true,
	
	/**
	 * Para mostrar en la botonera el boton de eliminar
	 * @type Boolean
	 */
	removeButton: true,
	
	propagationButton: false,
	
	idPrincipal: null,
	
	idSecundaria: null,
	
	/**
	 * Parámetro para decidir si queremos que el grid se carge después del bind
	 * 
	 */
	loadAfterBind: true,
	
	/**
	 * Será true si añadimos el plugin de edición
	 * @type Boolean
	 */
	editable: false,
	
	editOnSelect: true,
	
	editPosition: null,
	
	// Esta opcion permite no habilitar nunca el boton de borrar.
	disabledDeleteBtn: false,
	
	//sortableColumns: false,
	
	/**
	 * Para incluir configuración de seguridad de los botones.
	 * @type Object
	 */
	buttonSecurity: null,
	
	/**
	 * Para incluir configuración de seguridad para la edición.
	 * @type 
	 */
	rowPluginSecurity: null,
	
	/**
	 * Se utilizará para mostrar el botón de borrar todos los registros del grid, que llamará a esa url
	 * @type 
	 */
	deleteAllUrl: null,

	allowDeselect: true,
	
	allowBlank: true,
	
	minHeight: 300,
	
	flex: 1,
	
	viewConfig:{
    	markDirty:false
	},
	
	initComponent: function() {
		
		var me = this;
		
		me.emptyText = HreRem.i18n("grid.empty.text");
				
		me.addCls('panel-base shadow-panel grid-base-editable');

		me.rowEditing = new Ext.grid.plugin.RowEditing({	
			pluginId: 'rowEditingPlugin',
			// Puesto para cancelar el save con el onEnterKey
			config: {
	            buttonFocus: ''
	        },  
	        onEnterKey: function (){},
			saveBtnText  : HreRem.i18n('btn.saveBtnText'),
			cancelBtnText: HreRem.i18n('btn.cancelBtnText'),
			errorsText: HreRem.i18n('btn.errorsText'),
			dirtyText: HreRem.i18n('btn.dirtyText'),
            clicksToMoveEditor: 1,
       	 	autoCancel: false,
       	 	errorSummary: false
        });
        
        if(me.editOnSelect) {
			me.selModel = 'rowmodel';
		} else {
			me.rowEditing.triggerEvent ='none';
		}
		
		var addRowPluginFunction = function() {
			Ext.apply(me, {
				plugins: [me.rowEditing],
				editable: true
				});	
				
		};
		
		if(Ext.isEmpty(me.rowPluginSecurity) && Ext.isEmpty(me.secFunToEdit)) {		
			addRowPluginFunction();
		} else if (!Ext.isEmpty(me.secFunToEdit)) {
			$AU.confirmFunToFunctionExecution(addRowPluginFunction, me.secFunToEdit);
		} else {
			$AU.confirmRolesToFunctionExecution(addRowPluginFunction, me.rowPluginSecurity);
		}
        
		
		
		

	    me.addListener ('edit', function(editor, context, eOpts) {
			me.editFuncion(editor, context);
        });
        
        me.addListener ('beforeedit', function(editor) {
        	//Si ya estamos editando o no estamos creando un registro nuevo ni se permiete la edición
        	if (editor.editing || (!editor.isNew && !me.editOnSelect)) {
        		return false;
        	}
        });
        	
        me.addListener('canceledit', function(editor){
			me.disableAddButton(false);
			me.disablePagingToolBar(false);
        	me.getSelectionModel().deselectAll();
        	if(editor.isNew) {
        		me.getStore().remove(me.getStore().getAt(me.editPosition));
        		editor.isNew = false;
        	}
        });
        	
        me.addListener('selectionchange', function(grid, records) {
        	me.onGridBaseSelectionChange(grid, records);
        });

	    me.addListener('rowdblclick', function(){
        	me.getSelectionModel().deselectAll();
        	if(me.editable) {
	        	if(me.getPlugin("rowEditingPlugin").editing) {
	        		me.disableAddButton(true);
	        		me.disablePagingToolBar(true);
	        	}
        	}
        	me.disableRemoveButton(true);
	     });
            
        me.addListener('containerclick', function(editor){
        	if(me.allowDeselect)
        		me.getSelectionModel().deselectAll();
        });
        	
        me.addListener('afterbind', function(grid) {
    		if (me.loadAfterBind) {
				grid.getStore().load();
    		}
		});	
		
		if(me.topBar) {

			var configAddButton = {iconCls:'x-fa fa-plus', itemId:'addButton', handler: 'onAddClick', scope: this, hidden: !me.addButton  };
			var configRemoveButton = {iconCls:'x-fa fa-minus', itemId:'removeButton', handler: 'onDeleteClick', scope: this, disabled: true, hidden: !me.removeButton };
			var configPropagationButton = {iconCls:'x-fa fa-th-list', itemId:'propagationButton', handler: 'onClickPropagation', disabled: true, hidden: !me.propagationButton };
			
			if(!Ext.isEmpty(me.buttonSecurity)) {
				
				for(var key in me.buttonSecurity) {					
					configAddButton[key] = me.buttonSecurity[key];
					configRemoveButton[key] = me.buttonSecurity[key];
					configPropagationButton[key] = me.buttonSecurity[key];
				}
			}
			
			if(!Ext.isEmpty(me.secButtons)) {
				
				for(var key in me.secButtons) {					
					configAddButton[key] = me.secButtons[key];
					configRemoveButton[key] = me.secButtons[key];	
					configPropagationButton[key] = me.secButtons[key];	
				}
			}
			
			me.tbar = {
	    		xtype: 'toolbar',
	    		dock: 'top',
	    		tipo: 'toolbaredicion',
	    		hidden: !me.topBar,
	    		items: [configAddButton, configRemoveButton, configPropagationButton]
    		};

		};
		
		me.callParent();
		
		me.disableAddButton($AU.userIsRol('HAYACONSU') || $AU.userIsRol('PERFGCCLIBERBANK'));
		me.disablePropagationButton($AU.userIsRol('HAYACONSU') || $AU.userIsRol('PERFGCCLIBERBANK'));
		me.disablePagingToolBar($AU.userIsRol('HAYACONSU') || $AU.userIsRol('PERFGCCLIBERBANK'));
		
	},
	
	onAddClick: function(btn){
    	
		var me = this;
		var rec = Ext.create(me.getStore().config.model);
		me.getStore().sorters.clear();
		me.editPosition = 0;
        me.getStore().insert(me.editPosition, rec);
        me.rowEditing.isNew = true;
        me.rowEditing.startEdit(me.editPosition, 0);
        me.disableAddButton(true);
        me.disablePagingToolBar(true);
        me.disableRemoveButton(true);

    },
    
    onDeleteClick: function(btn){
    	
    	var me = this;
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

    },
    
    onGridBaseSelectionChange: function(grid, records) {
    	
    	var me = this;
		if(!records.length)
		{
			me.disableRemoveButton(true);
			me.disablePropagationButton(true);
			//S�lo si no estamos editando, se llamar� a las dos l�neas siguientes
			//if (!me.getPlugin("rowEditingPlugin").editing || typeof me.getPlugin("rowEditingPlugin").editing != 'undefined')
			//{
			me.disableAddButton($AU.userIsRol('HAYACONSU') || $AU.userIsRol('PERFGCCLIBERBANK'));
			me.disablePagingToolBar(false); 
			//}
		}
		else
		{
			if(me.editable) {
				
				if (me.getPlugin("rowEditingPlugin").editing) {
					me.disableRemoveButton(true);
					me.disablePropagationButton(true);
				}					
				else {
					me.disableRemoveButton(false);
					me.disablePropagationButton(false);
				}				
			}
		}
    	
    },

    disableAddButton: function(disabled) {
    	
    	var me = this;
    	
    	if (!Ext.isEmpty(me.down('#addButton'))) {
    		me.down('#addButton').setDisabled(disabled);    		
    	}
    },
    
    disableRemoveButton: function(disabled) {
    	
    	var me = this;

    	if (!Ext.isEmpty(me.down('#removeButton')) && !me.disabledDeleteBtn) {
    		me.down('#removeButton').setDisabled(disabled);    		
    	}
    },
    
    disablePropagationButton: function(disabled) {
    	
    	var me = this;
    	
    	if (!Ext.isEmpty(me.down('#propagationButton'))) {
    		me.down('#propagationButton').setDisabled(disabled);    		
    	}
    },
    
    disablePagingToolBar: function(disabled) {
    	
    	var me = this,
    	paginToolBar = me.down('pagingtoolbar');
    	
    	if(!Ext.isEmpty(paginToolBar)) {
    		paginToolBar.setDisabled(disabled);
    	}
    	
    },
    
    isValidRecord: function(record) {    	
    	return true;    	
    },
    
    /**
     * Funci�n que se sobreescribir� si queremos que se haga algo adicional después del save del record
     */
    saveSuccessFn: function() {
    	var me = this;
    	return true;
    },
    
     /**
     * Funci�n que se sobreescribir� si queremos que se haga algo adicional después del destroy del record
     */
    deleteSuccessFn: function() {
    	var me = this;
    	return true;
    },
    
    deleteFailureFn: function() {
    	var me = this;
    	return true;
    },
    
    getTopBar: function()
    {
    	var me = this;
    	return me.topBar;
    },
    
    setTopBar: function(topBar)
    {
    	var me = this;
    	me.topBar = topBar;
    	//if(!me.topBar) {
    		var toolbarDockItem = me.dockedItems.filterBy(
	    		function (item, key) {
	    			return item.tipo == "toolbaredicion";
	    		}
	    	);
    		if(!Ext.isEmpty(toolbarDockItem) && toolbarDockItem.items.length > 0 ) {
    			toolbarDockItem.items[0].setVisible(topBar);
    		}
    	//}
    },
    
    getEditOnSelect: function()
    {
    	var me = this;
    	return me.editOnSelect;
    },
    
    setEditOnSelect: function(editOnSelect)
    {
    	var me = this;
    	me.editOnSelect = editOnSelect;
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
   
   },
   
   editFuncion: function(editor, context){
   		
   		var me= this;
		me.mask(HreRem.i18n("msg.mask.espere"));

			if (me.isValidRecord(context.record)) {				
			
        		context.record.save({

                    params: {
                        idEntidad: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal),
                        idEntidadPk: Ext.isEmpty(me.idSecundaria) ? "" : this.up('{viewModel}').getViewModel().get(me.idSecundaria)	
                    },
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
                    	
                    	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msg)) {
                    		me.fireEvent("errorToast", response.msg);
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
        
   }
    
});