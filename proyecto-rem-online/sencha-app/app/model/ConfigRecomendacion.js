/*
 *  Modelo para el grid de la configuracion de recomendacion de la pestaña de administración.
 */
Ext.define('HreRem.model.ConfigRecomendacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
            {
            	name: 'id'
            },
            {
            	name: 'cartera'
            },
            {
            	name: 'subcartera'
            },
            {
            	name: 'tipoComercializacion'
            },
            {
            	name: 'equipoGestion'
            },
            {
            	name: 'porcentajeDescuento'
            },
            {
            	name: 'importeMinimo'
            },
            {
            	name: 'recomendacionRCDC'
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'recomendacion/getConfiguracionesRecomendacion',
            create: 'recomendacion/saveConfigRecomendacion',
            update: 'recomendacion/saveConfigRecomendacion',
            destroy: 'recomendacion/deleteConfigRecomendacion'
		}
    }
});