/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.Tramite', {
    extend: 'HreRem.model.Base',
    idProperty: 'idTramite',

    fields: [
    	'idTramite', 
    	'idTipoTramite', 
    	'tipoTramite',
    	'idTipoTramitePadre',
    	'tipoTramitePadre', 
    	'idActivo',
    	'nombre',
     	 {
     		name : 'fechaInicio',
     		//type : 'date',
     		convert : function(value, rec) {
    			if(!Ext.isEmpty(value)) {
					var newDate = new Date(value);
					var formattedDate = Ext.Date.format(newDate, 'd/m/Y');
					return formattedDate;
    			} else {
    				return value;
    			}
 			}
     	 },
     	 {
      		name : 'fechaFinalizacion',
      		//type : 'date',
    		convert : function(value, rec) {
    			if(!Ext.isEmpty(value)) {
					var newDate = new Date(value);
					var formattedDate = Ext.Date.format(newDate, 'd/m/Y');
					return formattedDate;
    			} else {
    				return value;
    			}
			}
      	 },
    	'cliente', 
    	'idGestor',
    	'gestor', 
    	'estado',
    	'tipoTrabajo',
    	'subtipoTrabajo',
    	'idExpediente',
    	'descripcionEstadoEC',
    	'numEC',
    	{
	    	name: 'tieneEC',
	    	type: 'boolean'
    	},
    	'codigoTareaActiva',
    	{
        	name: 'descItemMenu',
        	convert: function (value, rec) {
        		
        		return  'Tramite ' + rec.get("tipoTramite") + rec.get("idTramite") + '<br/> Activo ' + rec.get("idActivo");
        		
        	}
    	},
    	'idTrabajo',
    	'numTrabajo',
    	'cartera',
    	'tipoActivo',
    	'subtipoActivo',
        'numActivo',
        'esMultiActivo',
        'countActivos'
    ],
    
	proxy: {
		type: 'uxproxy',
		remoteUrl: 'activo/getTramite'
    }    

});
