/**
 * Modelo para el store del grid de testigos opcionales
 */
Ext.define('HreRem.model.TestigosOpcionales', {
	extend: 'HreRem.model.Base',
	idProperty: 'id',

	fields: [
		{
            name: 'informesMediadores'
        },
        {
            name: 'fuenteTestigos'
        },
        {
        	name: 'precio'
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
        	name: 'link'
        },
        {
        	name: 'direccion'
        },
        {
        	name: 'idTestigoSF'
        },
        {
        	name: 'nombre'
        }
		
	]
});