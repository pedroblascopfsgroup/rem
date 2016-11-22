/**
 * Controlador global de aplicación que gestiona la funcionalidad del menú de favoritos
 */
Ext.define('HreRem.controller.RefreshController', {
    extend: 'Ext.app.Controller',

    listen: {
    	component : {
    		'*': {
    			refreshComponent: 'refreshComponent',
				refreshComponentOnActivate: 'refreshComponentOnActivate',
				refreshEntityOnActivate: 'refreshEntityOnActivate'
             }
    	}
   	},
   	
	refreshComponent: function(query) {
   		var me = this,
   		cmp, resultQuery;   		
		resultQuery = Ext.ComponentQuery.query(query);
		
		if(resultQuery.length==1) {			
			cmp = resultQuery[0];
			cmp.fireEvent("refrescar", cmp);
		}
// TODO: Controlar error de otra forma
//		else if(resultQuery.length==0) {	
//			Ext.raise("No se ha encontrado el componente a refrescar");
//		} else {
//			Ext.raise("No es posible utilizar esta funciñon para refrescar componentes instanciados más de una vez");
//		}
   	},
   	
   	
   	refreshComponentOnActivate: function(query) {
   		var me = this,
   		cmp, resultQuery;
   		
		resultQuery = Ext.ComponentQuery.query(query);
		
		if(resultQuery.length == 1) {
			cmp = resultQuery[0];
			cmp.refreshOnActivate= true;
		}
// TODO: Controlar error de otra forma		
//		else if(resultQuery.length==0) {	
//			Ext.raise("No se ha encontrado el componente a refrescar");
//		} else {
//			Ext.raise("No es posible utilizar esta funciñon para refrescar componentes instanciados más de una vez");
//		}
  		
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
			case CONST.ENTITY_TYPES['TRAMITE']:
				break;
				
			case CONST.ENTITY_TYPES['GASTO']:
   				var entities =  Ext.ComponentQuery.query('gastodetallemain');
   				Ext.Array.each(entities, function(entity, index ) {
   					if(entity.getViewModel().get("gasto.id") == idEntity) {   						
   						entity.lookupController().onClickBotonRefrescar();
   					}   				 
   				});
   			
   				break;
			default: Ext.raise("ENTITY TYPE NOT EXIST");
   		}	
   	}
   	



    
});
