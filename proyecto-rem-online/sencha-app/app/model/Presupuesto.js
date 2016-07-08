/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.Presupuesto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'importeInicial',
    			type: 'number'
    		},
    		{
    			name:'ejercicioAnyo'
    		},
    		{
    			name:'sumaIncrementos',
    			type: 'number'
    		},
    		{
    			name: 'presupuesto'
    		},
		    {
		    	name: 'gastadoPorcentaje',
    			type: 'number'
		    },
		    {
		    	name: 'dispuestoPorcentaje',
    			type: 'number'
		    },
		    {
		    	name: 'disponiblePorcentaje',
    			type: 'number'
		    },
		    {
		    	name: 'gastado',
    			type: 'number'
		    },
		    {
		    	name: 'dispuesto',
    			type: 'number'
		    },
		    {
		    	name: 'disponible',
    			type: 'number'
		    }
    		
    		
    ]

});