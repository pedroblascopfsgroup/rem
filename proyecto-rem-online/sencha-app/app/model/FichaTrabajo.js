/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.FichaTrabajo', {
	extend : 'HreRem.model.Base',
	idProperty : 'id',


    fields: [ 
    		
		    {
		    	name: 'idTrabajo'
		    },
		    {
		    	name: 'idActivo'
		    },
		    {
		    	name: 'idAgrupacion'
		    },      
    		{
    			name:'numTrabajo'
    		},
    		{
    			name: 'nombreProveedor'
    		},
    		{
    			name: 'tipoTrabajoCodigo'
    		},
    		{
    			name: 'tipoTrabajoDescripcion'
    		},
    		{
    			name: 'subtipoTrabajoCodigo'
    		},
    		{
    			name: 'subtipoTrabajoDescripcion'
    		},
    		{
    			name: 'estadoCodigo'
    		},
    		{
    			name: 'estadoDescripcion'
    		},
    		{
    			name: 'descripcion'
    		},
    		{
    			name: 'fechaSolicitud',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaAprobacion',
    			type:'date',
    			dateFormat: 'c'		
    		},
    		{
    			name: 'fechaRechazo',
    			type:'date',
    			dateFormat: 'c'   			
    		},
    		{
    			name: 'fechaInicio',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaFin',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaEjecucionReal',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'continuoObservaciones'
    		},
    		{
    			name: 'cubreSeguro'
    		},
    		{
    			name: 'ciaAseguradora'
    		},
    		{
    			name: 'idGestorActivoResponsable'
    		},
    		{
    			name: 'gestorActivoResponsable'
    		},
    		{
    			name: 'idSupervisorActivo'
    		},
    		{
    			name: 'supervisorActivo'
    		},
    		{
    			name: 'idSupervisorAlquileres'
    		},
    		{
    			name: 'idSupervisorSuelos'
    		},
    		{
    			name: 'idSupervisorEdificaciones'
    		},
    		{
    			name: 'fechaConcreta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'horaConcreta',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaTope',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaCierreEconomico',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaValidacion',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaPago',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'fechaEleccionProveedor',
    			type:'date',
    			dateFormat: 'c'
    		}, 
    		{
    			name: 'bloquearResponsable',
    			type: 'boolean'
    		},
    		{
    			name: 'urgente'
    		},
    		{
    			name: 'riesgoInminenteTerceros'
    		},
    		{
    			name: 'motivoRechazo'
    		},
    		{
    			name: 'tipoCalidadCodigo'	
    		},
    		{
    			name: 'terceroNombre'
    		},
    		{
    			name: 'terceroEmail'
    		},
    		{    			
    			name: 'terceroDireccion'
    		},
    		{
    			name: 'terceroContacto'
    		},
    		{
    			name: 'terceroTel1'
    		},
    		{
    			name: 'terceroTel1'
    		},
    		{
    			name: 'esSolicitudConjunta',
    			convert: function(value) {
    				if(Ext.isEmpty(value))return false;
    				return value;
    			}
    		},
    		{
    			name: 'checkFechaConcreta',
    			calculate: function(data) {
    				return !Ext.isEmpty(data.fechaConcreta);
    			}
    		},
    		{
    			name: 'checkFechaTope'
    		},
    		{
    			name: 'checkFechaContinuado',
    			calculate: function(data) {
    				return !Ext.isEmpty(data.fechaInicio);
    			}
    			
    		},
    		{
    			name: 'checkRequeridoTercero',
    			calculate: function(data) {
    				return !Ext.isEmpty(data.terceroNombre);
    			}
    			
    		},
    		{
    			name: 'nombreMediador'
    		},
    		{
    			name: 'idProceso'
    		},
    		{
    			name: 'fechaEmisionFactura',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name: 'esTarifaPlana'
    		},
    		{
    			name: 'fechaAutorizacionPropietario',
    			type:'date',
        		dateFormat: 'c'
    		},
    		{
    			name: 'cartera'
    		},
    		{
    			name: 'codCartera'
    		},
    		{
    			name: 'requerimiento',
    			type: 'boolean'
    		},
    		{
    			name: 'esSareb',
    			calculate: function(data) {
    				 return data.codCartera == CONST.CARTERA['SAREB'];
    			}
    			
    		},
    		{
    			name: 'logadoGestorMantenimiento',
    			type: 'boolean'
    		}
    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'trabajo.json',
		remoteUrl: 'trabajo/getTrabajoById',
		timeout: 3000000,
		api: {
            read: 'trabajo/findOne',
            create: 'trabajo/create',
            update: 'trabajo/saveFichaTrabajo',
            destroy: 'trabajo/findOne'
        },
        extraParams: {pestana: 'ficha'},
        reader:{
        	messageProperty: 'error'
        }
    }    


});