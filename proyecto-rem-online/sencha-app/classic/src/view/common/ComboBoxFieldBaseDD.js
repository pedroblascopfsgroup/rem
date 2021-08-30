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
		loadingHeight: 150,
		loadingText: '...Cargando Listado...',
		emptyText: ''
//		,getInnerTpl: function () {
//			var tpl = '<div>{codigo} - {descripcion}</div>';
//			return tpl;
//		}
    },

	initComponent: function() {
		var me = this;
		
		if(me.filtradoEspecial2){
			me.forceSelection = false,
			me.editable = true,
			me.minChars = 0,
			me.enableKeyEvents = true,
			me.mode = 'local',
			me.queryMode = 'local',
			me.triggerAction = 'query',
			me.anyMatch = true;	
			me.addListener({
				'keyup': function() {
					if(me.getStore().isLoaded()){
						me.queryMode='local';
						me.mode='local';
					}
		    	   me.getStore().clearFilter();
		    	   me.getStore().filter({
		        	    property: me.displayField,
		        	    value: me.getRawValue(),
		        	    anyMatch: true,
		        	    caseSensitive: false
		        	});
		     	}
			});
		}
		me.callParent();	
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
				var store = value;
				if(value.source != null){
					value.loadSource = false;
					store = value.getSource();
				}
				store.autoLoad = false;
				store.addListener({
					load: function(store, records, successful, operation, eOpts){
						if(successful && records.length > 0 && records.length < 1000){
							function esItem(record){
								return record.get(me.displayField) == me.valorMostrado || record.get(me.valueField) == me.valorMostrado;
							};
							var record = records.find(esItem);
							if(record != null){
								if(me.isExpanded){
									me.select(record.get(me.valueField));
									me.expand();
								}else{
									me.select(record.get(me.valueField));
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
			if(binding._config.names.set == 'setRawValue' && me.chainedReference != null
					&& me.up('form') != null && me.up('form').down('[reference='+me.chainedReference+']') != null
					&& me.up('form').down('[reference='+me.chainedReference+']').getStore() != null)
					me.up('form').down('[reference='+me.chainedReference+']').getStore().removeAll();
			this.validate();			
		},
		
		onTriggerClick: function() {
	        var me = this;
	        if (!me.readOnly && !me.disabled) {
	            if (me.isExpanded) {
	                me.collapse();
	            } else if (me.reloadOnTrigger || (!Ext.isEmpty(me.getStore()) && me.getStore().getCount()<1))
                {
					if(me.getStore().source != null){
						me.getStore().loadSource = true;
						me.getStore().updateSource(me.getStore().getSource(), null);
					}else{
						if((!me.getStore().isLoaded() || me.getStore().getCount()<1) && !me.getStore().isLoading()){
							me.getStore().load();
							me.expand();me.collapse();me.expand();
						}else if (me.triggerAction === 'all' && !me.getStore().isLoading() && !me.filtradoEspecial2) {
		                    me.doQuery(me.allQuery, true);
		                } else if (me.triggerAction === 'last' && !me.getStore().isLoading()&& !me.filtradoEspecial2) {
		                    me.doQuery(me.lastQuery, true);
		                } else if(!me.getStore().isLoading() && !me.filtradoEspecial2){
		                    me.doQuery(me.getRawValue(), false, true);
		                }else{
							me.expand();
						}
					}		                
                }
                else
                {
                	me.expand();
                }
	       	}
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
			var me = this;
			if(value == null) value = '';
			me.callParent([value]);
			me.setValorMostrado(value);
        },

		setValorMostrado: function(value){
			var me = this;
			if(me.inputEl != null)
				me.inputEl.dom.value = value;
			if(me.displayEl != null)
				me.displayEl.dom.innerText = value;
			me.valorMostrado = value;
			var dataObj = {},
			record = null;
			dataObj[me.valueField] = me.value;
			dataObj[me.displayField] = value;
			record = new HreRem.model.ComboBase(dataObj);
			me.valueNotFoundRecord = record;
		},
		
		clearValue: function(){
			var me = this;
			me.value = null;
			me.setRawValue('');
		},
		getValue: function() {
	        // If the user has not changed the raw field value since a value was selected from the list,
	        // then return the structured value from the selection. If the raw field value is different
	        // than what would be displayed due to selection, return that raw value.
	        var me = this,
	            store = me.getStore(),
	            picker = me.picker,
	            rawValue = me.getRawValue(), //current value of text field
	            value = me.value; //stored value from last selection or setValue() call

	        // getValue may be called from initValue before a valid store is bound - may still be the default empty one.
	        // Also, may be called before the store has been loaded.
	        // In these cases, just return the value.
	        // In other cases, check that the rawValue matches the selected records.
	        if (!Ext.isEmpty(store) && !store.isEmptyStore && me.getDisplayValue() !== rawValue) {
	            me.displayTplData = undefined;
	            if (picker) {
	                // We do not need to hear about this clearing out of the value collection,
	                // so suspend events.
	                me.valueCollection.suspendEvents();
	                picker.getSelectionModel().deselectAll();
	                me.valueCollection.resumeEvents();
	                me.lastSelection = null;
	            }
	            // If the raw input value gets out of sync in a multiple ComboBox, then we have to give up.
	            // Multiple is not designed for typing *and* displaying the comma separated result of selection.
	            // Same in the case of forceSelection.
	            // Unless the store is not yet loaded, which case will be handled in onLoad
	            if (store.isLoaded() && (me.multiSelect || me.forceSelection)) {
	                value = me.value = undefined;
	            } else {
	                value = me.value;
	            }
	        }
	
	        // Return null if value is undefined/null, not falsy.
	        me.value = value == null ? null : value;
	        return me.value;
	    },
		/**
	     * Sets the specified value(s) into the field. For each value, if a record is found in the {@link #store} that
	     * matches based on the {@link #valueField}, then that record's {@link #displayField} will be displayed in the
	     * field. If no match is found, and the {@link #valueNotFoundText} config option is defined, then that will be
	     * displayed as the default field text. Otherwise a blank value will be shown, although the value will still be set.
	     * @param {String/String[]} value The value(s) to be set. Can be either a single String or {@link Ext.data.Model},
	     * or an Array of Strings or Models.
	     * @return {Ext.form.field.Field} this
	     */
	    setValue: function(value) {
	        var me = this;
	        // Value needs matching and record(s) need selecting.
	        if (value != null) {
	        	me = me.doSetValue(value);
				me.validate();
				return me;
	        } else // Clearing is a special, simpler case.
	        {	
				if(me.getStore()!= null && me.getStore().isLoaded()){
		            me.suspendEvent('select');
		            me.valueCollection.beginUpdate();
		            me.pickerSelectionModel.deselectAll();
		            me.valueCollection.endUpdate();
		            me.lastSelectedRecords = null;
		            me.resumeEvent('select');
				}
	        }
	    },

		/**
	     * @private
	     * Sets or adds a value/values
	     */
	    doSetValue: function(value /* private for use by addValue */, add) {
	        var me = this,
	            store = me.getStore(),
	            Model = store.getModel(),
	            matchedRecords = [],
	            valueArray = [],
	            autoLoadOnValue = me.autoLoadOnValue,
	            isLoaded = store.getCount() > 0 || store.isLoaded(),
	            pendingLoad = store.hasPendingLoad(),
	            unloaded = autoLoadOnValue && !isLoaded && !pendingLoad,
	            forceSelection = me.forceSelection,
	            selModel = me.pickerSelectionModel,
	            displayIsValue = me.displayField === me.valueField,
	            isEmptyStore = store.isEmptyStore,
	            lastSelection = me.lastSelection,
	            i, len, record, dataObj,
	            valueChanged, key;
			
	        //<debug>
	        if (add && !me.multiSelect) {
	            Ext.raise('Cannot add values to non multiSelect ComboBox');
	        }
	        //</debug>
	
	        // Called while the Store is loading or we don't have the real store bound yet.
	        // Ensure it is processed by the onLoad/bindStore.
	        // Even if displayField === valueField, we still MUST kick off a load because even though
	        // the value may be correct as the raw value, we must still load the store, and
	        // upon load, match the value and select a record sop we can publish the *selection* to
	        // a ViewModel.
	        if (pendingLoad || unloaded || !isLoaded || isEmptyStore) {
	
	            // If they are setting the value to a record instance, we can
	            // just add it to the valueCollection and continue with the setValue.
	            // We MUST do this before kicking off the load in case the load is synchronous;
	            // this.value must be available to the onLoad handler.
	            if (!value.isModel) {
	                if (add) {
	                    me.value = Ext.Array.from(me.value).concat(value);
	                } else {
	                    me.value = value;
	                }
	
	                me.setHiddenValue(me.value);
	
	                // If we know that the display value is the same as the value, then show it.
	                // A store load is still scheduled so that the matching record can be published.
	                me.setRawValue(displayIsValue ? value : me.valorMostrado);
	            }
	
	            // Kick off a load. Doesn't matter whether proxy is remote - it needs loading
	            // so we can select the correct record for the value.
	            //
	            // Must do this *after* setting the value above in case the store loads synchronously
	            // and fires the load event, and therefore calls onLoad inline.
	            //
	            // If it is still the default empty store, then the real store must be arriving
	            // in a tick through binding. bindStore will call setValueOnData.
	            if (unloaded && !isEmptyStore) {
	                store.load();
	            }
	
	            // If they had set a string value, another setValue call is scheduled in the onLoad handler.
	            // If the store is the defauilt empty one, the setValueOnData call will be made in bindStore
	            // when the real store arrives.
	            if (!value.isModel || isEmptyStore) {
	                return me;
	            }
	        }
	
	        // This method processes multi-values, so ensure value is an array.
	        value = add ? Ext.Array.from(me.value).concat(value) : Ext.Array.from(value);
	
	        // Loop through values, matching each from the Store, and collecting matched records
	        for (i = 0, len = value.length; i < len; i++) {
	            record = value[i];
	
	            // Set value was a key, look up in the store by that key
	            if (!record || !record.isModel) {
	                record = me.findRecordByValue(key = record);
	
	                // The value might be in a new record created from an unknown value (if !me.forceSelection).
	                // Or it could be a picked record which is filtered out of the main store.
	                // Or it could be a setValue(record) passed to an empty store with autoLoadOnValue and aded above.
	                if (!record) {
	                    record = me.valueCollection.find(me.valueField, key);
	                }
	            }
	            // record was not found, this could happen because
	            // store is not loaded or they set a value not in the store
	            if (!record) {
	                // If we are allowing insertion of values not represented in the Store, then push the value and
	                // create a new record to push as a display value for use by the displayTpl
	                if (!forceSelection) {
	                    
	                    // We are allowing added values to create their own records.
	                    // Only if the value is not empty.
	                    if (!record && value[i]) {
	                        dataObj = {};
	                        dataObj[me.displayField] = me.valorMostrado;
	                        if (me.valueField && me.displayField !== me.valueField) {
	                            dataObj[me.valueField] = value[i];
	                        }
	                        record = new Model(dataObj);
	                    }
	                }
	                // Else, if valueNotFoundText is defined, display it, otherwise display nothing for this value
	                else if (me.valueNotFoundRecord) {
	                    record = me.valueNotFoundRecord;
	                }
	            }
	            // record found, select it.
	            if (record) {
	                matchedRecords.push(record);
	                valueArray.push(record.get(me.valueField));
	            }
	        }
	
	        // If the same set of records are selected, this setValue has been a no-op
	        if (lastSelection) {
	            len = lastSelection.length;
	            if (len === matchedRecords.length) {
	                for (i = 0; !valueChanged && i < len; i++) {
	                    if (Ext.Array.indexOf(me.lastSelection, matchedRecords[i]) === -1) {
	                        valueChanged = true;
	                    }
	                }
	            } else {
	                valueChanged = true;
	            }
	        } else {
	            valueChanged = matchedRecords.length;
	        }
	
	        if (valueChanged) {
	            // beginUpdate which means we only want to notify this.onValueCollectionEndUpdate after it's all changed.
	            me.suspendEvent('select');
	            me.valueCollection.beginUpdate();
	            if (matchedRecords.length) {
	                selModel.select(matchedRecords, false);
	            } else {
	                selModel.deselectAll();
	            }
	            me.valueCollection.endUpdate();
	            me.resumeEvent('select');
	        } else {
	            me.updateValue();
	        }
			
	        return me;
	    }
    }	
});     