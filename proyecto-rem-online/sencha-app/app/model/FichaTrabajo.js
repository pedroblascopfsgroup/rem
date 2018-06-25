/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.FichaTrabajo', {
	extend : 'HreRem.model.Base',
	idProperty : 'id',

	/**
	 * Al crear un registro se genera como id un número negativo y no un String
	 */
	// identifier: 'negative',
	fields : [

	{
		name : 'idTrabajo'
	}, {
		name : 'idActivo'
	}, {
		name : 'idAgrupacion'
	}, {
		name : 'numTrabajo'
	}, {
		name : 'nombreProveedor'
	},{
		name : 'idProveedor'
	}, {
		name : 'tipoTrabajoCodigo'
	}, {
		name : 'tipoTrabajoDescripcion'
	}, {
		name : 'subtipoTrabajoCodigo'
	}, {
		name : 'subtipoTrabajoDescripcion'
	}, {
		name : 'estadoCodigo'
	}, {
		name : 'estadoDescripcion'
	}, {
		name : 'descripcion'
	}, {
		name : 'fechaSolicitud',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'fechaAprobacion',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'fechaRechazo',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'fechaInicio',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'fechaFin',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'fechaEjecucionReal',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'continuoObservaciones'
	}, {
		name : 'cubreSeguro'
	}, {
		name : 'ciaAseguradora'
	}, {
		name : 'idGestorActivoResponsable'
	}, {
		name : 'gestorActivoResponsable'
	}, {
		name : 'idSupervisorActivo'
	}, {
		name : 'supervisorActivo'
	}, {
		name : 'responsableTrabajo'
	}, {
		name : 'idResponsableTrabajo'
	}, {
		name : 'fechaConcreta',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'horaConcreta',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'fechaTope',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'fechaCierreEconomico',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'fechaValidacion',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'fechaPago',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'fechaEleccionProveedor',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'urgente'
	}, {
		name : 'riesgoInminenteTerceros'
	}, {
		name : 'motivoRechazo'
	}, {
		name : 'tipoCalidadCodigo'
	}, {
		name : 'terceroNombre'
	}, {
		name : 'terceroEmail'
	}, {
		name : 'terceroDireccion'
	}, {
		name : 'terceroContacto'
	}, {
		name : 'terceroTel1'
	}, {
		name : 'terceroTel1'
	}, {
		name : 'esSolicitudConjunta',
		convert : function(value) {
			if (Ext.isEmpty(value))
				return false;
			return value;
		}
	}, {
		name : 'checkFechaConcreta',
		calculate : function(data) {
			return !Ext.isEmpty(data.fechaConcreta);
		}
	}, {
		name : 'checkFechaTope',
		calculate : function(data) {
			return !Ext.isEmpty(data.fechaTope);
		}
	}, {
		name : 'checkFechaContinuado',
		calculate : function(data) {
			return !Ext.isEmpty(data.fechaInicio);
		}

	}, {
		name : 'checkRequeridoTercero',
		calculate : function(data) {
			return !Ext.isEmpty(data.terceroNombre);
		}

	}, {
		name : 'nombreMediador'
	}, {
		name : 'idProceso'
	}, {
		name : 'fechaEmisionFactura',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'esTarifaPlana'
	}, {
		name : 'fechaAutorizacionPropietario',
		type : 'date',
		dateFormat : 'c'
	}, {
		name : 'cartera'
	} ],

	proxy : {
		type : 'uxproxy',
		localUrl : 'trabajo.json',
		remoteUrl : 'trabajo/getTrabajoById',
		timeout : 300000,
		api : {
			read : 'trabajo/findOne',
			create : 'trabajo/create',
			update : 'trabajo/saveFichaTrabajo',
			destroy : 'trabajo/findOne'
		},
		extraParams : {
			pestana : 'ficha'
		}
	}

});