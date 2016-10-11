Ext.define('HreRem.model.PersonasContactoModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    		{
    			name:'id'
    		},
    		{
    			name:'proveedorID'
    		},
    		{
    			name:'personaPrincipal'
    		},
    		{
    			name:'nombre'
    		},
    		{
    			name:'apellido1'
    		},
    		{
    			name:'apellido2'
    		},
    		{
    			name:'cargoCombobox'
    		},
    		{
    			name:'cargoTexto'
    		},
    		{
    			name:'nif'
    		},
    		{
    			name:'codigoUsuario'
    		},
    		{
    			name:'telefono'
    		},
    		{
    			name:'email'
    		},
    		{
    			name:'direccion'
    		},
    		{
    			name:'delegacion'
    		},
    		{
    			name:'fechaAlta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaBaja',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'observaciones'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getPersonasContactoByProveedor',
            create: 'proveedores/createPersonasContacto',
            update: 'proveedores/updatePersonasContacto',
            destroy: 'proveedores/deletePersonasContacto'
        }
    }

});