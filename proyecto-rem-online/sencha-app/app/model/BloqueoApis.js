/**
 * This view is used to present the details of a single Proveedor item.
 */
Ext.define('HreRem.model.BloqueoApis', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    	{
    		name:'idBloqueo'
    	},
    	{
    		name:'carteraCodigo'
    	},
    	{
    		name:'lineaNegocioCodigo'
    	},
    	{
    		name:'especialidadCodigo'
    	},
    	{
    		name:'provinciaCodigo'
    	},
    	{
    		name:'motivo'
    	},
    	{
    		name:'id'
    	}
		    
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getBloqueoByProveedorId',
            update: 'proveedores/saveBloqueoProveedorById'
        }
    }    
});