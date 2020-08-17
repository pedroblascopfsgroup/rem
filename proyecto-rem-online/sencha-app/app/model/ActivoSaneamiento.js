Ext.define('HreRem.model.ActivoSaneamiento', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [
		{
			name:'idActivo'
		},
		{
			name:'estadoTitulo'
		},
		{
			name:'fechaEntregaGestoria',
			convert: function(value) {
				if (!Ext.isEmpty(value)) {
					if  ((typeof value) == 'string') {
    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
    				} else {
    					return value;
    				}
				}
			}
		},
		{
			name:'fechaPresHacienda',
			convert: function(value) {
				if (!Ext.isEmpty(value)) {
					if  ((typeof value) == 'string') {
    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
    				} else {
    					return value;
    				}
				}
			}
		},
		{
			name:'fechaPres1Registro',
			convert: function(value) {
				if (!Ext.isEmpty(value)) {
					if  ((typeof value) == 'string') {
    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
    				} else {
    					return value;
    				}
				}
			}
		},
		{
			name:'fechaEnvioAuto',
			convert: function(value) {
				if (!Ext.isEmpty(value)) {
					if  ((typeof value) == 'string') {
    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
    				} else {
    					return value;
    				}
				}
			}
		},
		{
			name:'fechaPres2Registro',
			convert: function(value) {
				if (!Ext.isEmpty(value)) {
					if  ((typeof value) == 'string') {
    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
    				} else {
    					return value;
    				}
				}
			}
		},
		{
			name:'fechaInscripcionReg',
			convert: function(value) {
				if (!Ext.isEmpty(value)) {
					if  ((typeof value) == 'string') {
    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
    				} else {
    					return value;
    				}
				} else {
					return value;
				}
			}
		},
		{
			name:'fechaRetiradaReg',
			convert: function(value) {
				if (!Ext.isEmpty(value)) {
					if  ((typeof value) == 'string') {
    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
    				} else {
    					return value;
    				}
				}
			}
		},
		{
			name:'fechaNotaSimple',
			convert: function(value) {
				if (!Ext.isEmpty(value)) {
					if  ((typeof value) == 'string') {
    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
    				} else {
    					return value;
    				}
				}
			}
		},
		{
			name:'numeroActivo'
		},
		{
			name:'gestoriaAsignada'
		},
		{
			name:'fechaAsignacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'conCargas'
		},
		{
			name:'estadoCargas'
		},
		{
			name:'fechaRevisionCarga',
			type:'date',
			dateFormat: 'c'
		},
		{
			name: 'unidadAlquilable',
			type: 'boolean'
		},
		{
			name:'vpo',
			convert: function(value) {
				if (!Ext.isEmpty(value)) {
					if  (value == 1 || value == '01') {
    					return true;
    				} else {
    					return false;
    				}			
    			}
			}
		},
		{
			name:'tipoVpoId'
		},
		{
			name:'tipoVpoCodigo'
		},
		{
			name:'tipoVpoDescripcion'
		},
		{
			name:'vigencia',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'comunicarAdquisicion'
		},
		{
			name:'necesarioInscribirVpo'
		},
		{
			name:'libertadCesion'
		},
		{
			name:'renunciaTanteoRetrac'
		},
		{
			name:'visaContratoPriv'
		},
		{
			name:'venderPersonaJuridica'
		},
		{
			name:'minusvalia'
		},
		{
			name:'inscripcionRegistroDemVpo'
		},
		{
			name:'ingresosInfNivel'
		},
		{
			name:'residenciaComAutonoma'
		},
		{
			name:'noTitularOtraVivienda'
		},
		{
			name:'sueloVpo'
		},
		{
			name:'promocionVpo'
		},
		{
			name:'numExpediente'
		},
		{
			name:'fechaCalificacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'obligatorioSolDevAyuda'
		},
		{
			name:'obligatorioAutAdmVenta'
		},
		{
			name:'descalificado'
		},
		{
			name:'sujetoAExpediente'
		},
		{
			name:'organismoExpropiante'
		},
		{
			name:'fechaInicioExpediente',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'refExpedienteAdmin'
		},
		{
			name:'refExpedienteInterno'
		},
		{
			name:'observacionesExpropiacion'
		},
		{
			name:'maxPrecioVenta'
		},
		{
			name:'observaciones'
		},
		{
			name:'calificacionNegativa'
		},
		{
			name:'descripcionCalificacionNegativa'
		},
  		{
			name:'estadoMotivoCalificacionNegativa'
		},
		{
			name: 'responsableSubsanar'
		},
		{
			name: 'isCalificacionNegativaEnabled',
			type: 'boolean'
		},
		{
			name: 'puedeEditarCalificacionNegativa',
			type: 'boolean'
		}
    ],

    proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',

		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoSaneamiento',
            update: 'activo/saveActivoSaneamiento',
            destroy: 'activo/getTabActivo'
        },
        extraParams: {tab: 'saneamiento'}
    }

});