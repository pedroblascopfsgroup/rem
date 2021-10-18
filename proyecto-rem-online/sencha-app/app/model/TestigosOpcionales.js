/**
 * Modelo para el store del grid de testigos opcionales
 */
Ext.define('HreRem.model.TestigosOpcionales', {
	extend: 'HreRem.model.Base',
	idProperty: 'id',

	fields: [
		{
            name: 'fuenteTestigos'
        },
        {
        	name: 'eurosPorMetro'
        },
        {
        	name: 'precioMercado'
        },
        {
        	name: 'superficie'
        },
        {
        	name: 'tipoActivo'
        },
		{
        	name: 'subtipoActivo'
        },
        {
        	name: 'enlace'
        },
        {
        	name: 'direccion'
        },
        {
        	name: 'lat'
        },
        {
        	name: 'lng'
        },
        {
        	name: 'fechaTransaccion'
        }
		
	]
});