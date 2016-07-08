Ext.define('HreRem.ux.data.store.Diccionario', {
	alias: 'store.diccionario',
	requires: ['Ext.data.Store', 'HreRem.model.DDBase', 'HreRem.ux.data.Proxy'],
	
	tipo: null,
    
    constructor : function (config) {
        config = config || {};

        Ext.apply(config,{
        		model: 'HreRem.model.DDBase',
			    autoLoad: true,
			    proxy: Ext.create('HreRem.ux.data.Proxy',{
					remoteUrl: 'generic/getDiccionario',
					extraParams: config.tipoDiccionario
				})
				
		});
						
		return new Ext.data.Store(config); 
		
	}


 });

 
