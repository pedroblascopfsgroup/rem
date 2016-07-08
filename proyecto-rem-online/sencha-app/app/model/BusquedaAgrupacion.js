/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.BusquedaAgrupacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',    
    

    fields: [    
  
    		{
    			name:'nombre'
    		},
    		{
    			name: 'tipoAgrupacion',
    			reference: 'HreRem.model.DDBase'
    		},
    		{
    			name:'fechaCreacionDesde'
    		},
    		{
    			name:'fechaCreacionHasta'
    		},
    		{
    			name:'numAgrupacionRem'
    		},
    		{
    			name:'publicado',
    			reference: 'HreRem.model.DDBase'
    		}
    		
        
        
    ] 
    

});