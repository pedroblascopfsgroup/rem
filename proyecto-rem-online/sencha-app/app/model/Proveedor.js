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
				name: 'nombre'
			},
			{
				name: 'descripcion',
				calculate: function(data){
					return data.nombre != null ? data.nombre : data.nombreProveedor;
				},
    			depends: ['nombre', 'nombreProveedor']
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
            },
            {
            	name: 'especialidadCodigo'
            },
            {
            	name: 'lineaNegocioCodigo'
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