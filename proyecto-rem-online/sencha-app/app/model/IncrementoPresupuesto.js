/**
 *  Modelo para el tab Informacion Administrativa de Activos 
 */
Ext.define('HreRem.model.IncrementoPresupuesto', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
  
    		{
    			name:'presupuestoActivoImporte',
    			type:'number'
    		},
    		{
    			name:'codigoTrabajo'
    		},
    		{
    			name:'importeIncremento',
    			type:'number'
    		},
    		{
    			name:'fechaAprobacion',
    			type:'date',
    			dateFormat: 'c'
    		}

    ]

});