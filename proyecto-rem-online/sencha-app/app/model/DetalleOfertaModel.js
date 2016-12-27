/**
 *  Modelo para el detalle de una oferta del activo. 
 */
Ext.define('HreRem.model.DetalleOfertaModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
 		{
			name:'numOferta'
		},
		{
			name:'intencionFinanciar'
		},
		{
			name:'numVisitaRem'
		},
		{
			name:'procedenciaVisita'
		}
    ],

	proxy: {
		type: 'uxproxy',
		api: {
            read: 'ofertas/getDetalleOfertaById'
        }
    }
});