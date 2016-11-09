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

			if(!Ext.isEmpty(me.buttonSecurity)) {
				
				for(var key in me.buttonSecurity) {					
					configAddButton[key] = me.buttonSecurity[key];
					configRemoveButton[key] = me.buttonSecurity[key];					
				}
			}
			
			me.tbar = {
	    		xtype: 'toolbar',
	    		dock: 'top',
	    		items: [configAddButton, configRemoveButton]
    		};

		};
		
		me.addListener('selectionchange', function(grid, records) {
				if(!Ext.isEmpty(records) && !records.length) {
					me.disableRemoveButton(true);
				} else {
					me.disableRemoveButton(false);
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
		
	},
	
	disableRemoveButton: function(disabled) {
    	
    	var me = this;
    	
    	if (!Ext.isEmpty(me.down('#removeButton'))) {
    		me.down('#removeButton').setDisabled(disabled);    		
    	}
    },
	
	onClickAdd: function(btn) {
		
		var me = this;
		me.fireEvent("abrirFormulario", me);
	},
	
    
    onClickRemove: function(btn) {
    	
    	var me = this,
    	sm = me.getSelectionModel();
		me.fireEvent("onClickRemove", me, sm.getSelection()[0]);
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