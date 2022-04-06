Ext.define('HreRem.model.DetallePrefacturaGridModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'idTrabajo',

    fields: [
			{
				name:'idTrabajo' 
			},
			{
				name:'numTrabajo'
			},
    		{
    			name:'tipologiaTrabajo'
    		},
    		{
    			name:'subtipologiaTrabajo'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'fechaAlta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'estadoTrabajo'
    		},
    		{
    			name:'importeTotalPrefactura'
    		},
    		{
    			name:'importeTotalClientePrefactura'
    		},
    		{
    			name:'checkIncluirTrabajo'
    		},
    		{
    			name:'nombrePropietario'
    		}
    ]
});