///**
// * Modelo para el store del grid de testigos de oferta
// */
//Ext.define('HreRem.model.Testigos', {
//	extend: 'HreRem.model.Base',
//	idProperty: 'id',
//
//	fields: [
//		
//		{
//			name: 'id'
//		},
//        {
//            name: 'fuenteTestigosDesc'
//        },
//        {
//        	name: 'eurosMetro'
//        },
//        {
//        	name: 'precioMercado'
//        },
//        {
//        	name: 'superficie'
//        },
//        {
//        	name: 'tipoActivoDesc'
//        },
//        {
//        	name: 'enlace'
//        },
//        {
//        	name: 'direccion'
//        }
//		
//	],
//    
//	proxy: {
//		type: 'uxproxy',
//		api: {
//            read: 'expedientecomercial/getTestigos',
//            create: 'expedientecomercial/saveTestigos',
//            update: 'expedientecomercial/saveTestigos',
//            destroy: 'expedientecomercial/deleteTestigos'
//		}
//    }
//});