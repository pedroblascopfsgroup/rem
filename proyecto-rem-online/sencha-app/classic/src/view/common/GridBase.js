Ext.define('HreRem.view.common.GridBase', { 
    extend		: 'Ext.grid.Panel',
    xtype		: 'gridBase',
	
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
	
	/**
	 * Para mostrar en la botonera el boton de eliminar
	 * @type Boolean
	 */
	propagationButton: true,
	
	/**
	 * Parámetro para decidir si queremos que el grid se carge después del bind
	 * 
	 */
	loadAfterBind: true,
	
	viewConfig:{
    	markDirty:false
	},
	
	reference: null,
	
	flex: 1,
	
	minHeight: 280,
	
	/**
	 * Para incluir configuración de seguridad.
	 * @type Object
	 */
	buttonSecurity: null,

	initComponent: function() {
		
		var me = this;
		
		me.addCls('panel-base shadow-panel grid-base');
		
		me.emptyText = HreRem.i18n("grid.empty.text");
		
		if(me.topBar) {

			var configAddButton = {iconCls:'x-fa fa-plus', itemId:'addButton', handler: 'onClickAdd', scope: this, hidden: !me.addButton };
			var configRemoveButton = {iconCls:'x-fa fa-minus', itemId:'removeButton', handler: 'onClickRemove', scope: this, disabled: true, hidden: !me.removeButton };
			
			//var configPropagationButton = {iconCls:'x-fa fa-th-list', itemId:'propagationButton', handler: 'onClickPropagation', disabled: true, hidden: !me.propagationButton };
			// ^- HREOS-2775 Este item se queda es standby 
			
			if(!Ext.isEmpty(me.buttonSecurity)) {
				
				for(var key in me.buttonSecurity) {					
					configAddButton[key] = me.buttonSecurity[key];
					configRemoveButton[key] = me.buttonSecurity[key];
					//configPropagationButton[key] = me.buttonSecurity[key];
					// ^- HREOS-2775 Este item se queda es standby
				}
			}
			
			me.tbar = {
	    		xtype: 'toolbar',
	    		dock: 'top',
	    		tipo: 'toolbarañadireliminar',
	    		items: [configAddButton, configRemoveButton] //, configPropagationButton] <- HREOS-2775 Este item se queda es standby
    		};

		};
		
		me.addListener('selectionchange', function(grid, records) {
				if(!Ext.isEmpty(records) && !records.length) {
					me.disableRemoveButton(true);
					me.disablePropagationButton(true);
				} else {
					me.disableRemoveButton(false);
					me.disablePropagationButton(false);
				}
		});
		
		if (me.loadAfterBind) {
			me.addListener('afterbind', function(grid) {
				grid.getStore().load(me.loadCallbackFunction);		
			});
		}

		/*me.addListener('afterbind', function(grid) {
			//grid.mask();
			grid.getStore().load({callback:function() {grid.unmask();}});			
		})*/;
		me.callParent();
		
		me.disableAddButton($AU.userIsRol('HAYACONSU'));
		me.disablePropagationButton($AU.userIsRol('HAYACONSU'));
				
	},
	
	disableAddButton: function(disabled) {
    	
    	var me = this;
    	
    	if (!Ext.isEmpty(me.down('#addButton'))) {
    		me.down('#addButton').setDisabled(disabled);    		
    	}
    },
	
	disableRemoveButton: function(disabled) {
    	
    	var me = this;
    	
    	if (!Ext.isEmpty(me.down('#removeButton'))) {
    		me.down('#removeButton').setDisabled(disabled);    		
    	}
    },
    
    disablePropagationButton: function(disabled) {
    	
    	var me = this;
    	
    	if (!Ext.isEmpty(me.down('#propagationButton'))) {
    		me.down('#propagationButton').setDisabled(disabled);    		
    	}
    },
	
	onClickAdd: function(btn) {
		
		var me = this;
		me.fireEvent("abrirFormulario", me);
	},
	
    
    onClickRemove: function(btn) {
    	
    	var me = this,
    	sm = me.getSelectionModel();
    	if(sm.getSelection() && sm.getSelection()[0]){
    		me.fireEvent("onClickRemove", me, sm.getSelection()[0]);
    	}else{
    		me.disableRemoveButton(true);
    	}
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
		var toolbarDockItem = me.dockedItems.filterBy(
    		function (item, key) {
    			return item.tipo == "toolbarañadireliminar";
    		}
    	);
		if(!Ext.isEmpty(toolbarDockItem) && toolbarDockItem.items.length > 0 ) {
			toolbarDockItem.items[0].setVisible(topBar);
		}
    },

	privates: {
               
               /**
                * Overrride del método original para en el momento de hacer el bind del value, 
                * igualar el valor de lastValue a ese mismo valor, de manera que no se lance el evento change
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