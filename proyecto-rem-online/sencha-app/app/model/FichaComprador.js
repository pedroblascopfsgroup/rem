/**
 * This view is used to present the details of a single CompradorItem.
 */
Ext.define('HreRem.model.FichaComprador', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',
    
    /**
     * Al crear un registro se genera como id un número negativo y no un String 
     */

    fields: [ 
    	'id',
    	'codTipoPersona',
    	'titularReserva',
    	'porcentajeCompra',
    	'titularContratacion'
    ],
    
	proxy: {
		type: 'uxproxy',
		remoteUrl: 'expedientecomercial/getCompradorById',
		api: {
            read: 'expedientecomercial/getCompradorById',
            create: 'expedientecomercial/create',
            update: 'expedientecomercial/saveFichaComprador',
            destroy: 'expedientecomercial/findOne'
        },
        extraParams: {idCliente: 'idCliente'}
    }    

});