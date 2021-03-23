Ext.define('HreRem.view.common.ComboBoxFieldBaseDD', { 	
	extend			: 'HreRem.view.common.ComboBoxFieldBase',
    xtype			: 'comboboxfieldbasedd',
   	loadOnBind		: false,
	autoLoadOnValue	: false,
	queryMode		: 'remote',
	matchFieldWidth	: true,
	forceSelection	: false,
	valorMostrado	: '',
	listConfig: {
		loadingHeight: 200,
		loadingText: '...Cargando Lista...',
		emptyText: 'No se han encontrado resultados'
//		,getInnerTpl: function () {
//			var tpl = '<div>{codigo} - {descripcion}</div>';
//			return tpl;
//		}
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
			var me = this;
			if (me.value == null || (me.value != binding.lastValue)) {
				if (me.loadOnBind && me.getStore() != null && me.getStore().type!="chained") {
					me.loadPage();
				}				
			}
			if(binding._config.names.set == 'setStore' && value != null){
				value.addListener({
					load: function(store, records, successful, operation, eOpts){
						if(successful && records.length > 0){
							function esItem(record){
								return record.get('descripcion') == me.valorMostrado;
							};
							var record = records.find(esItem);
							if(record != null){
								if(me.isExpanded){
									me.select(record.get('codigo'));
									me.expand();
								}else{
									me.select(record.get('codigo'));
								}
							}
							
						}
					}
				});
			}
						
			binding.syncing = (binding.syncing + 1) || 1;
			this[binding._config.names.set](value);
			--binding.syncing;
	    	this.fireEvent("afterbind", this, value);
			
		},
		
		bindStore: function(store, preventFilter, /* private */initial) {
	        var me = this,
	            filter = me.queryFilter;
	        me.mixins.storeholder.bindStore.call(me, store, initial);
	        store = me.getStore();
	        if (store && filter && !preventFilter) {
	            store.getFilters().add(filter);
	        }
	        if (!initial && store && !store.isEmptyStore && store.isLoaded()) {
	            me.setValueOnData();
	        }
	    },

		setRawValue: function (value) {
			if(value == null) value = '';
			this.callParent([value]);
			this.setValorMostrado(value);   		
        },

		setValorMostrado: function(value){
			var me = this;
			me.inputEl.dom.value = value;
			me.displayEl.dom.innerText = value;
			me.valorMostrado = value;
		}
    }
});     