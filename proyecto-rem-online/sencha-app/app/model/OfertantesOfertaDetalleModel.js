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
            	name: 'ofertaID'
            },
            {
            	name: 'tipoDocumento'
            },
            {
            	name: 'numDocumento'
            },
            {
            	name: 'nombre'
            },
            {
            	name: 'tipoPersona'
            },
            {
            	name: 'estadoCivil'
            },
            {
            	name: 'regimenMatrimonial'
            },
            {
            	name: 'ADCOMIdDocumentoIdentificativo'
            },
            {
            	name: 'ADCOMIdDocumentoGDPR'
            },
            {
            	name: 'aceptacionOferta'
            }
            
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'ofertas/getOfertantesByOfertaId',
            update: 'ofertas/updateOfertantesByOfertaId'
		}
    }
});