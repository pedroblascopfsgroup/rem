/**
 * Modelo para el grid de honorarios de la pestaña de ofertas del activo.
 */
Ext.define('HreRem.model.HonorariosOfertaDetalleModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
            {
            	name:'id'
            },
            {
            	name: 'tipoComision'
            },
            {
            	name: 'tipoProveedor'
            },
            {
            	name:'nombre'
            },
            {
            	name:'idProveedor'
            },
            {
            	name:'tipoCalculo'
            },
            {
            	name:'importeCalculo'
            },
            {
            	name:'honorarios'
            }
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'ofertas/getHonorariosByOfertaId'
		}
    }
});