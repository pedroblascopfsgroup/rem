Ext.define('HreRem.model.ActivoSaneamiento', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [ 
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
			name: 'unidadAlquilable',
			type: 'boolean'
		},
		{
			name: 'noEstaInscrito',
			type: 'boolean'
		},
		{
			name:'conCargas'
		},
		{
			name:'estadoCargas'
		},
		{
			name:'fechaRevisionCarga',
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
			name:'tipoVpoCodigo'
		},
		{
			name:'descalificado'
		},
		{
			name:'fechaCalificacion',
			type:'date',
			dateFormat: 'c'
		},
		{
			name:'numExpediente'
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
			name:'obligatorioAutAdmVenta'
		},
		{
			name:'maxPrecioVenta'
		},
		{
			name:'obligatorioSolDevAyuda'
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
			name:'gestoriaAsignada'
		},
		{
			name:'fechaAsignacion',
			type:'date',
			dateFormat: 'c'
		},
		//por programar
		{
			name:'tieneTituloAdicional'
		},
		{
			name:'estadoTituloAdicional'
		},
		{
			name:'situacionTituloAdicional'
		},
		{
			name:'fechaInscriptionRegistroAdicional',
           	type: 'date',
    		dateFormat: 'c'
		},
		{
			name:'fechaEntregaTituloGestAdicional',
           	type: 'date',
    		dateFormat: 'c'
		},
		{
			name:'fechaRetiradaDefinitivaRegAdicional',
           	type: 'date',
    		dateFormat: 'c'
		},
		{
			name:'fechaPresentacionHaciendaAdicional',
           	type: 'date',
    		dateFormat: 'c'
		},
		{
			name:'fechaNotaSimpleAdicional',
           	type: 'date',
    		dateFormat: 'c'
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