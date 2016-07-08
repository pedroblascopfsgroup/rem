Ext.define('HreRem.store.MenuTopStore', {
    extend: 'Ext.data.TreeStore',
	alias: 'menutopstore',
	
    storeId: 'MenuTopStore',
    
    proxy: {
     type : 'ajax',
     method: 'GET',
     url: $AC.getRemoteUrl('generic/getMenuItems'),
     extraParams: {tipo: 'top'},
     reader: {
         type: 'json',
         rootProperty: 'data'
     }
 	},
 	
 	autoLoad:false,

 	root: {
        expanded: false
    },
    fields: [
        {
            name: 'text'
        }
    ]
});
