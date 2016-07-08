/**
 * Controlador global de aplicación que gestiona la funcionalidad del menú de favoritos
 */
Ext.define('HreRem.controller.RefreshController', {
    extend: 'Ext.app.Controller',

    listen: {
    	component : {
    		'*': {
				refreshComponentOnActivate: 'refreshComponentOnActivate',
				refreshEntityOnActivate: 'refreshEntityOnActivate'
             }
    	}
   	},	
   	
   	
   	refreshComponentOnActivate: function(query) {
   		var me = this,
   		cmp, resultQuery;
   		
		resultQuery = Ext.ComponentQuery.query(query);
		if(resultQuery.length>0) {
			cmp = resultQuery[0];
			cmp.refreshOnActivate= true;
		}
   		
   	},
   	
   	refreshEntityOnActivate: function(entity, idEntity) {
   		var me = this;
   		
   		switch(entity) {
   			
   			case CONST.ENTITY_TYPES['ACTIVO']:
   				var entities =  Ext.ComponentQuery.query('activosdetallemain');
   				Ext.Array.each(entities, function(entity, index ) {
   					if(entity.getViewModel().get("activo.id") == idEntity) {   						
   						entity.lookupController().onClickBotonRefrescar();
   					}   				 
   				});
   			
   				break;
   			case CONST.ENTITY_TYPES['TRABAJO']:
   				var entities =  Ext.ComponentQuery.query('trabajosdetalle');   				
   				Ext.Array.each(entities, function(entity, index ) {
   					if(entity.getViewModel().get("trabajo.id") == idEntity) {
   						entity.lookupController().onClickBotonRefrescar();
   					}
   				 
   				});
   				
   			
   				break;
			case $CONST.ENTITY_TYPES['TRAMITE']:
				break;
			
			default: Ext.raise("ENTITY TYPE NOT EXIST");
   		}	
   	}
   	



    
});
