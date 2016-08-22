/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.Tarea', {
    extend: 'HreRem.model.Base',

    fields: [
    	'idTarea', 
    	'idTipoTarea',
    	'nombreTarea', 
    	'descripcionTarea',
    	'idTipoActuacion',  
    	'tipoActuacion',
    	'idTipoActuacionPadre', 	
    	'tipoActuacionPadre', 
    	'idActuacion',
    	'idActuacionPadre',
    	'idActivo',
    	'codEntidad',
    	'descripcionEntidad',
    	'usuarioPendiente',
    	'contrato',
    	{
    		name : 'fechaInicio',
    		type : 'date',
    		dateFormat: 'c'
    	},
    	{
    		name : 'fechaFin',
    		type : 'date',
    		dateFormat: 'c'
    	},    
    	{
    		name : 'fechaVenc',
    		type : 'date',
    		dateFormat: 'c'
    	},    	
        'diasVencidoSQL',
        {
			name : 'diasVencidaNumber',
			calculate : function(data) {
				return Ext.isEmpty(data.diasVencidoSQL)
						? parseInt(0)
						: parseInt(data.diasVencidoSQL);
			}
		},
		'idEstadoVencimiento',
		{
			name : 'semaforo',
			calculate : function(data) {
				if(!Ext.isEmpty(data.diasVencidoSQL)){
					if(parseInt(data.diasVencidoSQL) <0){
						return 2;
					}else if(parseInt(data.diasVencidoSQL) >= 0 && parseInt(data.diasVencidoSQL) <=2){
						return 1;
					}else{
						return 0;
					}
				}
			}
		},
        'idGestor',
    	'gestor',
    	'fechaVerificacionSolicitud',
        'idVerificacionSolicitud',
        'verificacionSolicitud',
        'obsCATSolicitud',
        'fechaContactoClienteSolicitud',
        'idMedioContactoClienteSolicitud',
        'medioContactoClienteSolicitud',
        'idResulContactoClienteSolicitud',
        'resulContactoClienteSolicitud',           
        'idVisita',         
        'idAdjuntoVisita',
        'fechaContactoClienteVisita',
        'fechaPropuestaVisita',
        'obsContactoClienteVisita',
        'fechaRevisionInmuebleVisita',
        'idEstadoInmuebleVisita',
        'estadoInmuebleVisita',
        'obsEstadoInmuebleVisita',
        'fechaContactoClienteCancelVisita',
        'obsCancelVisita',
        'idRealizacionVisita',
        'realizacionVisita',
        'fechaVisita',
        'idMotivoNoRealizacionVisita',
        'motivoNoRealizacionVisita',
        'obsRealizacionVisita',
    	'idVisita',
        'idAdjuntoVisita',
        'idOferta',
        'fechaOferta',
        'idTramitarOferta',
        'tramitarOferta',
        'idMotivoRechazoOferta',	
        'motivoRechazoOferta',
        'obsVerificarOferta',	          
        'idComercializarActivoGADMOferta',
        'comercializarActivoGADMOferta',
        'obsVerificaGADMOfertaOferta',	
        'idComercializarActivoGACTOferta',
        'comercializarActivoGACTOferta',
        'obsVerificaGACTOferta',	
        'idComercializarActivoGADMONOferta',
        'comercializarActivoGADMONOferta',
        'obsVerificaGADMONOferta',                      
        'idRatificarOferta',
        'ratificarOferta',	
        'idRequiereComiteOferta',
        'requiereComiteOferta',	
        'idResolucionGestorOferta',
        'resolucionGestorOferta',
        'obsGestorAComiteOferta',
        'fechaPropuestaOferta',
        'fechaEnvíoPropuestaOferta',
        'idResolucionComiteOferta',
        'resolucionComiteOferta',
        'fechaResolucionComiteOferta',
        'precioContraofertaComiteOferta',
        'obsResolucionComiteOferta',
        'fechaNotifContraofertaClienteOferta',
        'idRespuestaContraofertaClienteOferta',
        'respuestaContraofertaClienteOferta',
        'obsRespuestaClienteOferta',
        'idResolucionGestorOferta',
        'resolucionGestorOferta',
        'fechaResolucionGestorOferta',
        'precioContraofertaGestorOferta',
        'obsResolucionGestorOferta',
        'idEntidad'
    ]

});