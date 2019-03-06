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
    			name:'provinciaRegistro'
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
    			name:'divHorizontal'
    		},
    		{
    			name:'estadoObraNuevaCodigo'
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
    			name:'estadoAdjudicacionCodigo'
    		},
    		{
    			name:'tipoPlazaCodigo'
    		},
    		{
    			name:'entidadAdjudicatariaCodigo'
    		},
    		{
    			name:'entidadEjecutanteCodigo'
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
    		{
    			name:'motivoCalificacionNegativa'
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