/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.BloqueoApisHistorico', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: 
    	[    
    		{
    			name:'bloqueos'
    		},
    		{
    			name: 'fecha',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'usuario'
    		},
    		{
    			name:'motivo'
    		}
	  ]
});