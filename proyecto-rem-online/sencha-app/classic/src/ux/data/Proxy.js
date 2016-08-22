/**
 * @class HreRem.ux.data.Proxy
 * @author Jose Villel
 * 
 * Proxy base que extiende de Ext.data.proxy.Ajax para configuración común de la aplicación * 
 */
 
 Ext.define('HreRem.ux.data.Proxy', {
	alias : 'proxy.uxproxy',
	extend: 'Ext.data.proxy.Ajax',
	
	config : {
		localUrl : null,
		remoteUrl : null,
		writeAll : false
	},
	
	requires : [ 
        'HreRem.ux.data.SinglePost'
    ],
	
	constructor : function (config) {
		
		var me = this;
        config = config || {};
        
        var root = Ext.isEmpty(config.rootProperty) ? 'data' : config.rootProperty;
        var url = $AC.isLocalDataMode() ? $AC.getLocalUrl(config.localUrl) : $AC.getRemoteUrl(config.remoteUrl);
        var writeAll = Ext.isEmpty(config.writeAll) ? me.writeAll : config.writeAll;
		
		if (!Ext.isEmpty(config.api)) {
			
			if(!Ext.isEmpty(config.api.read)){
				config.api.read = $AC.isLocalDataMode() ? $AC.getLocalUrl(config.localUrl) : $AC.getRemoteUrl(config.api.read);
			}
			if(!Ext.isEmpty(config.api.create)){
				config.api.create = $AC.isLocalDataMode() ? $AC.getLocalUrl(config.localUrl) : $AC.getRemoteUrl(config.api.create);
			}
			if(!Ext.isEmpty(config.api.update)){
				config.api.update = $AC.isLocalDataMode() ? $AC.getLocalUrl(config.localUrl) : $AC.getRemoteUrl(config.api.update);
			}
			if(!Ext.isEmpty(config.api.destroy)){
				config.api.destroy = $AC.isLocalDataMode() ? $AC.getLocalUrl(config.localUrl) : $AC.getRemoteUrl(config.api.destroy);
			}
		}
		
		Ext.apply(config,{
				simpleSortMode: true,
				headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' }, 
				url : url,
			    reader: {
			        rootProperty: root,
			        type: 'json',
			        totalProperty: 'totalCount'
			    },
			    writer: {
			        rootProperty: root,
			        type: 'singlepost',
			        totalProperty: 'totalCount',
			        writeAllFields: writeAll
			    }
		});
		
		this.callParent([config]);
		
	}	
});