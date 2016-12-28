/**
 * Modelo para el grid de ofertantes de la pestaña de ofertas del activo.
 */
Ext.define('HreRem.model.OfertantesOfertaDetalleModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
            {
            	name:'id'
            },
            {
            	name: 'tipoDocumento'
            },
            {
            	name: 'numDocumento'
            },
            {
            	name: 'nombre'
            }
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'ofertas/getOfertantesByOfertaId'
		}
    }
});