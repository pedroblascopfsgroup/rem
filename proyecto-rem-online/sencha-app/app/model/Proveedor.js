/**
 * 
 *//**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.Proveedor', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
            {
            	name:'id'
            },
            {
            	name: 'tipoProveedor'
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		remoteUrl: 'proveedor/getProveedores',

		api: {
            read: 'proveedor/getProveedores',
            create: 'proveedor/getProveedores',
            update: 'proveedor/getProveedores',
            destroy: 'proveedor/getProveedores'
		}

    }

});