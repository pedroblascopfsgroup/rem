Ext.define('HreRem.ux.menu.MenuFavoritos', {
	extend: 'Ext.menu.Menu',
	xtype: 'menufavoritos',
	reference: 'menuFavoritos',
    width: 250,
    cls: 'menu-favoritos',
    plain: true,
    floating: true,
    
    requires: ['Ext.Action'],
    
    initComponent: function() {
    	
    	var me = this;
    	
    	me.itemSinFavoritos = Ext.create('Ext.Action',{
    						width: 250,
				    		text: '( vacio )',
				    		cls: 'delete-focus-bg no-pointer item-sin-favoritos',
				    		reference: 'itemSinFavoritos',
				    		disabled: true
				    	});
    	
    	me.items= me.itemSinFavoritos;    	
    	
    	me.callParent();
    	
    },
    
    addFavorito: function(actionMenu) {

    	var me = this;
   		me.itemSinFavoritos.hide();   		
   		me.add(actionMenu);
    	
    },
    
    removeFavorito: function(id) {
    	
    	var me = this,
    	favorito;
    	
    	
    	Ext.Array.each(me.items.items, function (item, posicion) {
    		
    		if(item.openId == id) {
    			favorito = item;
    		}
    	
    	});
    	
    	me.remove(favorito);
    	
    	if(me.items.length == 1) {
    		me.itemSinFavoritos.show();  		
    	}

    },
    
    getFavoritos: function() {
    	
    	var me = this;    	
    	return me.items.items;
    	
    }
});