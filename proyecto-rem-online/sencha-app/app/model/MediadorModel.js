Ext.define('HreRem.model.MediadorModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'idProveedor',

    fields: [
    		{
    			name:'idProveedor'
    		},
    		{
    			name:'codigoProveedor'
    		},
    		{
    			name:'nombreProveedor'
    		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getMediadorFiltered'
        }
    }
});