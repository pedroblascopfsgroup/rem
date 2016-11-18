/**
 * Modelo para el grid de lista de mediadores para evaluar en pestana de administracion.
 */
Ext.define('HreRem.model.MediadorEvaluarModel', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',	  
    fields: [
            {
            	name: 'id'
            },
            {
            	name: 'codigoRem'
            },
            {
            	name: 'nombreApellidos'
            },            
            {
            	name: 'desProvincia'
            },
            {
            	name: 'desLocalidad'
            },
            {
            	name: 'fechaAlta',
    			type: 'date',
    			dateFormat: 'c'
            },
            {
            	name: 'esCustodio'
            },
            {
            	name: 'desEstadoProveedor'
            },
            {
            	name: 'desCartera'
            },
            {
            	name: 'desCalificacion'
            },
            {
            	name: 'esTop'
            },
            {
            	name: 'desCalificacionPropuesta'
            },
            {
            	name: 'esTopPropuesto'
            },
            {
            	name: 'esHomologado'
            }
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'proveedores/getMediadoresEvaluar',
            update: 'proveedores/updateMediadoresEvaluar'
		}
    }
});