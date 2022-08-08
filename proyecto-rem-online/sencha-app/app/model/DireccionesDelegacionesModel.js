Ext.define('HreRem.model.DireccionesDelegacionesModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'id'
    		},
    		{
    			name:'tipoDireccion'
    		},
    		{
    			name:'localAbiertoPublicoCodigo'
    		},
    		{
    			name:'referencia'
    		},
    		{
    			name:'tipoViaCodigo'
    		},
    		{
    			name:'nombreVia'
    		},
    		{
    			name:'numeroVia'
    		},
    		{
    			name:'piso'
    		},
    		{
    			name:'puerta'
    		},
    		{
    			name:'localidadCodigo'
    		},
    		{
    			name:'provincia'
    		},
    		{
    			name:'codigoPostal'
    		},
    		{
    			name:'telefono'
    		},
    		{
    			name:'email'
    		},
    		{
    			name:'otros'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getDireccionesDelegacionesByProveedor',
            create: 'proveedores/createDireccionDelegacion',
            update: 'proveedores/updateDireccionDelegacion',
            destroy: 'proveedores/deleteDireccionDelegacion'
        }

    }

});