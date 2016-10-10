/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.EntregaReserva', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
        	{
    			name: 'idEntrega'
    		},
    		{
    			name:'idReserva'
    		},
    		{
    			name: 'importe'
    		},
    		{
    			name: 'fechaEntrega',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'titular'
    		},
    		{
    			name: 'observaciones'
    		},
    		{
    			name: 'fechaCobro',
    			type:'date',
    			dateFormat: 'c'
    		}
    ],
    
    proxy: {
		type: 'uxproxy',
		writeAll: true,
		localUrl: 'entregareserva.json',
		api: {
			create: 'expedientecomercial/saveEntregaReserva',
            update: 'expedientecomercial/updateEntregaReserva',
            destroy: 'expedientecomercial/deleteEntregaReserva'
        }
    }

});