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
    			name: 'fechaEntrega'
    		},
    		{
    			name: 'titular'
    		},
    		{
    			name: 'observaciones'
    		}
    ]

});