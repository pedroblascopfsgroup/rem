Ext.define('HreRem.model.BusquedaActivosPublicacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',    
    

    fields: [    
  
    		{
    			name:'numActivo'
    		},
    		{
    			name: 'tipoActivoDescripcion'
    		},
    		{
    			name: 'subtipoActivoDescripcion'
    		},
    		{
    			name:'direccion'
    		},
    		{
    			name:'despubliForzado'
    		},
    		{
    			name:'publiForzado'
    		},
    		{
    			name: 'admision'
    		},
    		{
				name:'gestion'
    		},
    		{
    			name:'publicacion'
    		},
    		{
    			name: 'precio'
    		},
    		{
    			name: 'okventa'
    		},
    		{
    			name: 'okalquiler'
    		},
    		{
    			name: 'fechaPublicacionVenta',
    			type: 'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaPublicacionAlquiler',
    			type: 'date',
    			dateFormat: 'c'
    		}
    ] 
    

});