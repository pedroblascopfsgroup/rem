/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.Actuacion', {
    extend: 'HreRem.model.Base',

    fields: [
    	'idActuacion', 
    	'idTipoActuacion', 
    	'tipoActuacion',
    	'idTipoActuacionPadre',
    	'tipoActuacionPadre', 
    	'idActivo',
    	'nombre', 
    	'fechaInicio', 
    	'fechaFin', 
    	'cliente', 
    	'idGestor',
    	'gestor', 
    	'estado',
    	'codigoTareaActiva',
    	{
        	name: 'descItemMenu',
        	convert: function (value, rec) {
        		
        		return  'Actuacion ' + rec.get("tipoActuacion") + rec.get("idActuacion") + '<br/> Activo ' + rec.get("idActivo");
        		
        	}
    	}
    ]

});
