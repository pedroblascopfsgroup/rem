Ext.define('HreRem.store.MenuPrincipalStore', {
    extend: 'Ext.data.TreeStore',
	alias: 'menuprincipalstore',
	
    storeId: 'MenuPrincipalStore',
    
    proxy: {
     type : 'ajax',
     method: 'GET',
     url: $AC.getRemoteUrl('generic/getMenuItems'),
     extraParams: {tipo: 'left'},
     //url: 'resources/data/menuitems.json',
     reader: {
         type: 'json',
         rootProperty: 'data'
     }
 	},
 	
 	autoLoad:true,

 	root: {
        expanded: false
    },
    fields: [
        {
            name: 'text'
        }
    ]
});
