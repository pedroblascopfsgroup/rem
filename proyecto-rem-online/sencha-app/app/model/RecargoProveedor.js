/**
 *  Modelo para el grid de tarifas asignadas al trabajo
 */
Ext.define('HreRem.model.RecargoProveedor', {
    extend: 'HreRem.model.Base',
    idProperty: 'idRecargo',

    fields: [    
            {
            	name:'idTrabajo'
            },
            {
            	name: 'tipoCalculoCodigo'
            },
            {
            	name: 'tipoRecargoCodigo'
            },
            {
            	name:'importeCalculo'
            },
            {
            	name:'importeFinal'
            }

    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'trabajo/getRecargoProveedor',

		api: {
            read: 'trabajo/getRecargoProveedor',
            create: 'trabajo/createRecargoProveedor',
            update: 'trabajo/saveRecargoProveedor',
            destroy: 'trabajo/deleteRecargoProveedor'
        }

    }    

});