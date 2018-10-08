/**
 * This view is used to present the details of a single Tramite item.
 */
Ext.define('HreRem.model.Tramite', {
    extend: 'HreRem.model.Base',
    idProperty: 'idTramite',

    fields: [
    	{
     		name : 'idTramite',
     		type : 'int'
    	},
    	{
     		name : 'idTipoTramite'
    	},
    	{
     		name : 'tipoTramite'
    	},
    	{
     		name : 'idTipoTramitePadre'
    	},
    	{
     		name : 'tipoTramitePadre'
    	}, 
    	{
     		name : 'idActivo'
    	},
    	{
     		name : 'nombre'
    	},
     	{
     		name : 'fechaInicio'
     	},
     	{
      		name : 'fechaFinalizacion'
      	},
      	{
       		name : 'cliente'
      	}, 
      	{
      		name : 'idGestor'
      	},
      	{
      		name : 'gestor'
      	}, 
      	{
      		name : 'estado'
      	},
      	{
      		name : 'tipoTrabajo'
      	},
      	{
      		name : 'subtipoTrabajo'
      	},
      	{
      		name: 'codigoSubtipoTrabajo'
      	},
      	{
      		name : 'idExpediente'
      	},
      	{
      		name : 'descripcionEstadoEC'}
      	,
      	{
      		name : 'numEC'
      	},
    	{
	    	name: 'tieneEC',
	    	type: 'boolean'
    	},
    	{
      		name : 'codigoTareaActiva'
    	},
    	{
        	name: 'descItemMenu',
        	convert: function (value, rec) {
        		return  'Tramite ' + rec.get("tipoTramite") + rec.get("idTramite") + '<br/> Activo ' + rec.get("idActivo");
        	}
    	},
    	{
      		name : 'idTrabajo'
    	},
    	{
      		name : 'numTrabajo'
    	},
    	{
      		name : 'cartera'
    	},
    	{
      		name : 'codigoCartera'
    	},
    	{
      		name : 'tipoActivo'
    	},
    	{
      		name : 'subtipoActivo'
    	},
    	{
      		name : 'numActivo'
    	},
    	{
      		name : 'esMultiActivo'
    	},
    	{
      		name : 'countActivos'
    	},
    	{
    		name: 'ocultarBotonResolucion'
    	},
    	{
    		name: 'ocultarBotonCierre',
    		type: 'boolean'
    	},
    	{
    		name: 'estaTareaRespuestaBankiaDevolucion',
    		type: 'boolean'
    	},
    	{
    		name: 'estaTareaPendienteDevolucion',
    		type: 'boolean'
    	},
    	{
    		name: 'estaTareaRespuestaBankiaAnulacionDevolucion',
    		type: 'boolean'
    	},
    	{
    		name: 'estaEnTareaSiguienteResolucionExpediente',
    		type: 'boolean'
    	},
    	{
    		name: 'ocultarBotonLanzarTareaAdministrativa',
    		type: 'boolean'
    	},
    	{
    		name: 'ocultarBotonReactivarTramite',
    		type: 'boolean'
    	},
    	{
    		name: 'desactivarBotonLanzarTareaAdministrativa',
    		type: 'boolean'
    	},
    	{
    		name: 'esTarifaPlana',
    		type: 'boolean'
    	},
    	{
    		name: 'activoAplicaGestion',
    		type: 'boolean'
    	},
    	{
    		name: 'esTareaAutorizacionBankia',
    		type: 'boolean'
    	}
    ],

	proxy: {
		type: 'uxproxy',
		remoteUrl: 'activo/getTramite'
    }
});