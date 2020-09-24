/**
 *  Modelo para el grid de cargas de Activos 
 */
Ext.define('HreRem.model.ActivoComplementoTituloModel', {
    extend: 'HreRem.model.Base',
	idProperty: 'id',
	requires: ['HreRem.model.Activo'],
	
    fields: [    
  
		    {
		    	name: 'id'
		    },
    		{
    			name:'activoId'
    		},
    		{
    			name:'fechaAlta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'gestorAlta'
    		},
    		{
    			name:'tipoTitulo'
    		},
    		{
    			name:'fechaSolicitud',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaTitulo',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaRecepcion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaInscripcion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'observaciones'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',

		api: {
            create: 'activo/saveActivoComplementoTitulo',
            update: 'activo/updateActivoComplementoTitulo',
            destroy: 'activo/deleteActivoComplementoTitulo'
        }
    }
    
    

});