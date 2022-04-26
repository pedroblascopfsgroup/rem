/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.BloqueoApisHistorico', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: 
    	[   
    		{
    			name:'id'
    		},
    		{
    			name:'idPve'
    		},
    		{
				name:'tipoBloqueo'
			},
    		{
    			name:'bloqueos'
    		},
    		{
    			name: 'fechaBloqueo',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'usuarioBloqueo'
    		},
    		{
    			name:'motivoBloqueo'
    		},
    		{
    			name: 'fechaDesbloqueo',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'usuarioDesbloqueo'
    		},
    		{
    			name:'motivoDesbloqueo'
    		}
	  ]
});