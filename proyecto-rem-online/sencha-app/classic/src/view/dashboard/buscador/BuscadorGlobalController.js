Ext.define('HreRem.view.dashboard.buscador.BuscadorGlobalController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.buscadorglobal',
    
   
    
    onSpecialKey: function(field, e) {
        if (e.getKey() === e.ENTER) {
            this.doSearch(field);
        }
    },
    
    onClickSearch: function(btn) {
    	
    	var me = this;
    },
    
    doSearch: function() {
    	
    	var me = this;
   	
    	
    }    

});