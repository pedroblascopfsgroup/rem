/**
 *  Modelo para el grid de adecuaciones alquiler del tab Patrimonio de Activos 
 */
Ext.define('HreRem.model.HistoricoAdecuacionesPatrimonioModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    

    fields: [    
     		
    		{
    			name:'checkPerimetroAlquiler'
    		},
    		{
    			name:'descripcionAdecuacion'
    		},
    		{
    			name:'fechaInicioAdecuacion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaFinAdecuacion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaInicioPerimetroAlquiler',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaFinPerimetroAlquiler',
    			type:'date',
    			dateFormat: 'c'
    		}
    		
    ]

});