/**
 * This view is used to present the details of a single Oferta.
 */

Ext.define('HreRem.model.Ofertantes', {
    extend: 'HreRem.model.Base',

    fields: [
             
    	'idOferta',
    	'ofertante',
    	'docIdentificativo',
    	'telefono',
    	'email',
    	'fechaVisita',
    	'tipo',
    	'porcentajeCompra'
    ]

});
          