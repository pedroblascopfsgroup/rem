Ext.define('HreRem.model.ActivosIntegradosModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'id'
    		},
    		{
    			name:'idActivo'
    		},
    		{
    			name:'numActivo'
    		},
    		{
    			name:'tipoCodigo'
    		},
    		{
    			name:'subtipoCodigo'
    		},
    		{
    			name:'carteraCodigo'
    		},
    		{
    			name:'direccion'
    		},
    		{
    			name:'participacion'
    		},
    		{
    			name:'fechaInclusion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaExclusion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'motivoExclusion'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getActivosIntegradosByProveedor'
        }

    }

});