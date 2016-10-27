/**
 * Modelo para el grid del buscador de proveedores de la pestaña de administración.
 */
Ext.define('HreRem.model.Proveedor', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
            {
            	name:'id'
            },
            {
            	name: 'codigo'
            },
            {
            	name: 'tipoProveedorDescripcion'
            },
            {
            	name:'subtipoProveedorDescripcion'
            },
            {
            	name:'nifProveedor'
            },
            {
            	name:'nombreProveedor'
            },
            {
            	name:'nombreComercialProveedor'
            },
            {
            	name:'estadoProveedorDescripcion'
            },
            {
            	name:'observaciones'
            },

            {
            	name: 'tipoProveedorCodigo'
            },
            {
            	name: 'estadoProveedorCodigo'
            },
            {
            	name: 'fechaAlta',
    			type:'date',
    			dateFormat: 'c'
            },
            {
            	name: 'subtipoProveedorCodigo'
            },
            {
            	name: 'fechaBaja',
    			type:'date',
    			dateFormat: 'c'
            },
            {
            	name: 'tipoPersonaCodigo'
            },
            {
            	name: 'cartera'
            },
            {
            	name: 'propietario'
            },
            {
            	name: 'subcartera'
            },
            {
            	name: 'provinciaCodigo'
            },
            {
            	name: 'municipioCodigo'
            },
            {
            	name: 'codigoPostal'
            },
            {
            	name: 'nombrePersContacto'
            },
            {
            	name: 'homologadoCodigo'
            },
            {
            	name: 'calificacionCodigo'
            },
            {
            	name: 'topCodigo'
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getProveedores',
            create: 'proveedores/createProveedor'
		}
    }
});