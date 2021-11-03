/*
 *  Modelo para el grid de los testigos obligatorios de la pestaña de administración.
 */
Ext.define('HreRem.model.Testigo', {
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
            	name: 'requiereTestigos',
            	convert: function(value, record) {
            		if (value === "true") {
						return "Si";
					} else if (value === "false") {
						return "No";
					} else {
						return value;
					}
    			}
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'testigos/getTestigosObligatorios',
            create: 'testigos/saveTestigoObligatorio',
            update: 'testigos/updateTestigoObligatorio',
            destroy: 'testigos/deleteTestigoObligatorio'
		}
    }
});