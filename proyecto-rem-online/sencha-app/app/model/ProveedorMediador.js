/**
 */
Ext.define('HreRem.model.ProveedorMediador', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
    	'idProveedor', 'nombre'
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getComboApiPrimario'
		}
    }
});