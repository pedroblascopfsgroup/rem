/**
 * This view is used to present the details of a single AgendaItem.
 */
Ext.define('HreRem.model.ActivoDatosRegistrales', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    

    		{
    			name:'numeroActivo'
    		},
    		{
    			name:'poblacionRegistro'
    		},
    		{
    			name:'poblacionRegistroDescripcion'
    		},
			{
    			name:'provinciaRegistro'
    		},
			{
    			name:'provinciaRegistroDescripcion'
    		},
    		{
    			name:'numRegistro'
    		},
    		{
    			name:'tomo'
    		},
    		{
    			name:'libro'
    		},
    		{
    			name:'folio'
    		},
    		{
    			name:'numFinca'
    		},
    		{
    			name:'superficieUtil'
    		},
    		{
    			name:'superficieConstruida'
    		},
    		{
    			name:'idufir'
    		},
    		{
    			name:'hanCambiado'
    		},
    		{
    			name:'numAnterior'
    		},
    		{
    			name:'numFincaAnterior'
    		},
    		{
    			name:'superficieElementosComunes'
    		},
    		{
    			name:'superficieParcela'
    		},
    		{
    			name:'divHorInscrito'
    		},
    		{
    			name:'fechaCfo',
    			convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}
    			//FIXME SOLUCION PARA BORRAR FECHAS
    			/*type:'date',
    			dateWriteFormat: 'Y-m-d'*/
    		},
    		{
    			name:'superficieConstruida'
    		},
    		{
    			name:'superficieConstruida'
    		},
    		{
    			name:'estadoDivHorizontalCodigo'
    		},
			{
    			name:'estadoDivHorizontalDescripcion'
    		},
    		{
    			name:'divHorizontal'
    		},
    		{
    			name:'estadoObraNuevaCodigo'
    		},
			{
    			name:'estadoObraNuevaDescripcion'
    		},
    		{
    			name:'gestionHre'
    		},
    		{
    			name:'porcPropiedad'
    		},
    		{
    			name:'fechaTitulo',
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
    			name:'fechaFirmaTitulo',
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
    			name:'valorAdquisicion'
    		},
    		{
    			name:'tramitadorTitulo'
    		},
    		{
    			name:'propiedadActivoDescripcion'
    		},
    		{
    			name:'propiedadActivoCodigo'
    		},
    		{
    			name:'propiedadActivoNif'
    		},
    		{
    			name:'propiedadActivoDireccion'
    		},
    		{
    			name:'tipoGradoPropiedadCodigo'
    		},
    		{
    			name:'tipoTituloActivoCodigo'
    		},
    		{
    			name:'acreedorId'
    		},
    		{
    			name:'acreedorNombre'
    		},
    		{
    			name:'acreedorNif'
    		},
    		{
    			name:'acreedorDir'
    		},
    		{
    			name:'importeDeuda'
    		},
    		{
    			name:'rentaLibre'
    		},
    		{
    			name:'propNom'
    		},
    		{
    			name:'propId'
    		},
    		{
    			name:'propNif'
    		},
    		{
    			name:'propDir'
    		},
    		{
    			name:'propContactoNom'
    		},
    		{
    			name:'propTelf'
    		},
    		{
    			name:'propEmail'
    		},
    		{
    			name:'porcPropiedadPdv'
    		},
    		{
    			name:'acreedorNumExp'
    		},
    		{
    			name:'tipoTituloActivoMatriz'
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
    			name:'estadoTitulo'
    		},
    		{
    			name:'numReferencia'
    		},
    		{
    			name:'fechaAdjudicacion',
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
    			name:'numAuto'
    		},
    		{
    			name:'procurador'
    		},
    		{
    			name:'letrado'
    		},
    		{
    			name:'idAsunto'
    		},
    		{
                name:'idAsuntoRecAlaska'
            },
    		{
    			name:'numExpRiesgoAdj'
    		},
    		{
    			name:'fechaDecretoFirme',
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
    			name:'fechaSenalamientoPosesion',
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
    			name:'importeAdjudicacion'
    		},
    		{
    			name:'tipoJuzgadoCodigo'
    		},
			{
    			name:'tipoJuzgadoDescripcion'
    		},
    		{
    			name:'estadoAdjudicacionCodigo'
    		},
			{
    			name:'estadoAdjudicacionDescripcion'
    		},
    		{
    			name:'tipoPlazaCodigo'
    		},
			{
    			name:'tipoPlazaDescripcion'
    		},
    		{
    			name:'entidadAdjudicatariaCodigo'
    		},
    		{
    			name:'entidadEjecutanteCodigo'
    		},
			{
    			name:'entidadEjecutanteDescripcion'
    		},
    		{
    			name:'fechaRealizacionPosesion',
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
    			name:'lanzamientoNecesario'
    		},
    		{
    			name:'fechaSenalamientoLanzamiento',
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
    			name:'fechaRealizacionLanzamiento',
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
    			name:'fechaSolicitudMoratoria',
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
    			name:'resolucionMoratoriaCodigo'
    		},
			{
    			name:'resolucionMoratoriaDescripcion'
    		},
    		{
    			name:'fechaResolucionMoratoria',
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
    			name:'calificacionNegativa'
    		},
    		/*{
    			name:'motivoCalificacionNegativa'
    		},*/
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
    			name: 'puedeEditarCalificacionNegativa',
    			type: 'boolean'
    		},
    		{
    			name: 'isCalificacionNegativaEnabled',
    			type: 'boolean'
    		},
    		{
    			name: 'noEstaInscrito',
    			type: 'boolean'
    		},
    		{
    			name: 'fechaSubsanacion',
    			type:'date',
    			dateWriteFormat: 'Y-m.d',
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
    			name:'localidadAnteriorCodigo'
    		},
			{
    			name:'localidadAnteriorDescripcion'
    		},
    		{
    			name: 'isJudicial',
    			type:'boolean',
    			calculate: function(data) {
    				if (data.tipoTituloActivoMatriz === CONST.TIPO_TITULO_ACTIVO['JUDICIAL'] || data.tipoTituloCodigo === CONST.TIPO_TITULO_ACTIVO['JUDICIAL']) {
						return true;
    				}else{
    					return false;
    				}
    			},
    			depends: ['tipoTituloActivoMatriz','tipoTituloCodigo']
    		},
    		{
    			name: 'isNotJudicial',
    			type:'boolean',
    			calculate: function(data) {
    				if (data.tipoTituloActivoMatriz === CONST.TIPO_TITULO_ACTIVO['NO_JUDICIAL'] || data.tipoTituloCodigo === CONST.TIPO_TITULO_ACTIVO['NO_JUDICIAL']) {
						return true;
    				}else{
    					return false;
    				}
    			},
    			depends: ['tipoTituloActivoMatriz','tipoTituloCodigo']
    		},
			{
    			name: 'isPdv',
    			type:'boolean',
    			calculate: function(data) {
    				if (data.tipoTituloActivoMatriz === CONST.TIPO_TITULO_ACTIVO['PDV'] || data.tipoTituloCodigo === CONST.TIPO_TITULO_ACTIVO['PDV']) {
						return true;
    				}else{
    					return false;
    				}
    			},
    			depends: ['tipoTituloActivoMatriz','tipoTituloCodigo']
    		},
    		{
    			name: 'origenAnteriorActivoCodigo'
    		},
			{
    			name: 'origenAnteriorActivoDescripcion'
    		},
    		{
    			name: 'origenAnteriorActivoBbvaCodigo'
    		},
			{
    			name: 'origenAnteriorActivoBbvaDescripcion'
    		},
    		{
    			name:'fechaTituloAnterior',
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
    			name: 'tieneAnejosRegistralesInt'
    		},
    		{
    			name: 'idProcesoOrigen'
    		},
    		{
    			name: 'sociedadPagoAnterior'
    		},
    		{
    			name: 'fechaPosesion',
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
    			name: 'sociedadPagoAnteriorDescripcion'
    		},
			{
				name: 'tipoTituloCodigo'
			},
			{
				name: 'tipoTituloDescripcion'
			},
			{
				name: 'subtipoTituloCodigo'
			},
			{
				name: 'subtipoTituloDescripcion'
			},
			{
				name: 'superficieBajoRasante'
			},
			{
				name: 'superficieSobreRasante'
			},
			{
    			name:'superficieParcelaUtil'
			},
			{
    			name:'sociedadOrigenCodigo'
			},
			{
    			name:'sociedadOrigenDescripcion'
			},
			{
    			name:'bancoOrigenCodigo'
			},
			{
    			name:'bancoOrigenDescripcion'
			},
			{
			    name:'nombreRegistro'
			}
    ],
    
    
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoDatosRegistrales',
            update: 'activo/saveActivoDatosRegistrales',
            destroy: 'activo/getTabActivo'
        },
		extraParams: {tab: 'datosregistrales'}
    }
    
    
    
    

});