/**
 * Controlador global de aplicación que gestiona la funcionalidad del menú de favoritos
 */
Ext.define('HreRem.controller.RefreshController', {
    extend: 'HreRem.ux.controller.ControllerBase',

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
		else if(resultQuery.length==0) {	
			me.log("No se ha encontrado el componente a refrescar");
		} else {
			me.log("No es posible utilizar esta función para refrescar componentes instanciados más de una vez");
		}
   	},
   	
   	
   	refreshComponentOnActivate: function(query) {
   		var me = this,
   		cmp, resultQuery;
   		
		resultQuery = Ext.ComponentQuery.query(query);
		
		if(resultQuery.length == 1) {
			cmp = resultQuery[0];
			cmp.refreshOnActivate= true;
		}
		else if(resultQuery.length==0) {	
			me.log("No se ha encontrado el componente a refrescar");
		} else {
			me.log("No es posible utilizar esta funciñon para refrescar componentes instanciados más de una vez");
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
			case CONST.ENTITY_TYPES['TRAMITE']:
				var entities =  Ext.ComponentQuery.query('tramitesdetalle');   				
   				Ext.Array.each(entities, function(entity, index ) {
   					if(entity.getViewModel().get("tramite.idTramite") == idEntity) {
   						entity.lookupController().onClickBotonRefrescar();
   					}
   				});
				break;
				
			case CONST.ENTITY_TYPES['GASTO']:
   				var entities =  Ext.ComponentQuery.query('gastodetallemain');
   				Ext.Array.each(entities, function(entity, index ) {
   					if(entity.getViewModel().get("gasto.id") == idEntity) {   						
   						entity.lookupController().onClickBotonRefrescar();
   					}   				 
   				});
   			
   				break;
   				
   			case CONST.ENTITY_TYPES['EXPEDIENTE']:
   				var entities =  Ext.ComponentQuery.query('expedientedetallemain');
   				Ext.Array.each(entities, function(entity, index ) {
   					if(entity.getViewModel().get("expediente.id") == idEntity) {   						
   						entity.lookupController().onClickBotonRefrescar();
   					}   				 
   				});
   			
   				break;
   			case CONST.ENTITY_TYPES['AGRUPACION']:
   				var entities =  Ext.ComponentQuery.query('agrupacionesdetallemain');
   				Ext.Array.each(entities, function(entity, index ) {
   					if(entity.getViewModel().get("agrupacion.id") == idEntity) {   						
   						entity.lookupController().onClickBotonRefrescar();
   					}   				 
   				});
   			
   				break;
			default: Ext.raise("ENTITY TYPE NOT EXIST");
   		}	
   	}
   	



    
});
