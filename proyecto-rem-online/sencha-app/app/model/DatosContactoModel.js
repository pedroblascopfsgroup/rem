Ext.define('HreRem.model.DatosContactoModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
		    {
		    	name: 'id'
		    },
            {
            	name:'tipoLineaDeNegocioCodigo'
            },
            {
            	name:'tipoLineaDeNegocioDescripcion'
            },
            {
            	name:'gestionClientesCodigo'
            },
            {
            	name:'gestionClientesDescripcion'
            },
            {
            	name:'numeroComerciales'
            },
            {
            	name:'especialidadCodigo'
            },
            {
            	name:'idiomaCodigo'
            },
            {
            	name:'provinciaCodigo'
            },
            {
            	name:'provinciaDescripcion'
            },
            {
            	name:'municipioCodigo'
            },
            {
            	name:'municipioDescripcion'
            },
            {
            	name:'codigoPostalCodigo'
            },
            {
            	name:'codigoPostalDescripcion'
            }
            
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getDatosContactoById',
            update: 'proveedores/saveDatosContactoById'
        }
    }    
});