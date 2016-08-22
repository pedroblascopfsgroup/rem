Ext.define('Ext.overrides.data.ChainedStore', {
	override: 'Ext.data.ChainedStore',
	
	updateSource: function(source, oldSource) {
        var me = this,
            data, sourceData;
        if (oldSource) {
            oldSource.removeObserver(me);
        }

        if (source) {
            data = me.getData();
            sourceData = source.getData();
            
            if(!Ext.isEmpty(sourceData) && sourceData.length > 0 ) {
            	data.setSource(sourceData);

            } else if(me.loadSource){
            	source.load({            		
            		callback: function(record, operation, success){
            			 data.setSource(source.getData());
            		}
            	});
            }
           
            if (!me.isInitializing) {
                me.fireEvent('refresh', me);
                me.fireEvent('datachanged', me);
            }
            source.addObserver(me);
        }
    }
	
	
});