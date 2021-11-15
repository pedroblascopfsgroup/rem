/**
 *  Modelo para el tab Valoracion y precios de Activos 
 */
Ext.define('HreRem.model.ActivoTasacion', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
     		{
    			name:'numActivo'
    		},
    		{
    			name:'numActivoRem'
    		},
    		{
    			name:'trabajoTasacion'
    		},
    		{
    			name:'tipoTasacion'
    		},
    		{
    			name:'tipoTasacionDescripcion'
    		},
    		{
    			name:'tipoTasacionCodigo'
    		},
    		{
    			name:'fechaInicioTasacion',
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
    			name:'fechaValorTasacion',
    			type:'date',
    			dateFormat: 'c'
    			/* HREOS-628 Cambiado por [type:'date'] para poder ordenar correctamente
    			 
    			  convert: function(value) {
    				if (!Ext.isEmpty(value)) {
						if  ((typeof value) == 'string') {
	    					return value.substr(8,2) + '/' + value.substr(5,2) + '/' + value.substr(0,4);
	    				} else {
	    					return value;
	    				}
    				}
    			}*/
    		},
    		{
    			name:'fechaRecepcionTasacion',
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
    			name:'fechaSolicitudTasacion',
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
    			name:'codigoFirma'
    		},
    		{
    			name:'nomTasador',
    			convert: function(value){
    				if(value)
    					return value;
    				else
    					return '-';
    			}
    		},
    		{
    			name:'importeTasacionFin'
    		},
    		{
    			name:'costeRepoNetoActual'
    		},
    		{
    			name:'costeRepoNetoFinalizado'
    		},
    		{
    			name:'coeficienteMercadoEstado'
    		},
    		{
    			name:'coeficientePondValorAnanyadido'
    		},
    		{
    			name:'valorReperSueloConst'
    		},
    		{
    			name:'costeConstConstruido'
    		},
    		{
    			name:'indiceDepreFisica'
    		},
    		{
    			name:'indiceDepreFuncional'
    		},
    		{
    			name:'indiceTotalDepre'
    		},
    		{
    			name:'costeConstDepreciada'
    		},
    		{
    			name:'costeUnitarioRepoNeto'
    		},
    		{
    			name:'costeReposicion'
    		},
    		{
    			name:'porcentajeObra'
    		},
    		{
    			name:'importeValorTerminado'
    		},
    		{
    			name:'idTextoAsociado'
    		},
    		{
    			name:'importeValorLegalFinca'
    		},
    		{
    			name:'importeValorSolar'
    		},
    		{
    			name:'observaciones'
    		},
    		{
    			name:'ilocalizable',
    			type: 'boolean'
    		},
			{
    			name:'externoBbva'
    		},
    		{
    		    name:'numGastoHaya'
    		},
    		{
    		    name:'idGasto'
    		},
    		{
    		    name:'superficieParcela'
    		},
    		{
    		    name:'superficie'
    		},
    		{
    		    name:'referenciaTasadora'
    		},
    		{
    		    name: 'acogidaNormativa'
    		},
    		{
    		    name: 'valorHipotesisEdificioTerminadoPromocion'
    		},
    		{
    		    name: 'advertencias'
    		},
    		{
    		    name: 'codigoSociedadTasacionValoracion'
    		},
    		{
    		    name: 'condicionantes'
    		},
    		{
    		    name: 'metodoValoracionCodigo'
    		},
    		{
    		    name: 'valorTerreno'
    		},
    		{
    		    name: 'valorTerrenoAjustado'
    		},
    		{
    		    name: 'valorHipotesisEdificioTerminado'
    		},
    		{
    		    name: 'valorHipotecario'
    		},
    		{
    		    name: 'visitaAnteriorInmueble'
    		},
    		{
    		    name: 'superficieAdoptada'
    		},
    		{
    		    name: 'costeEstimadoTerminarObra'
    		},
    		{
    		    name: 'costeDestinaUsoPropio'
    		},
    		{
    		    name: 'fechaEstimadaTerminarObra',
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
    		    name: 'mrdPlazoMaximoFinalizarComercializacion'
    		},
    		{
    		    name: 'mrdPlazoMaximoFinalizarConstruccion'
    		},
    		{
    		    name: 'mrdTasaAnualizadaHomogenea'
    		},
    		{
    		    name: 'mrdTasaActualizacion'
    		},
    		{
    		    name: 'mreMargenBeneficioPromotor'
    		},
    		{
    		    name: 'superficieTerreno'
    		},
    		{
    		    name: 'tasaAnualMedioVariacionPrecioMercado'
    		},
    		{
    		    name: 'aprovechamientoParcelaSuelo'
    		},
    		{
    		    name: 'desarrolloPlanteamientoCodigo'
    		},
    		{
    		    name: 'faseGestionCodigo'
    		},
    		{
    		    name: 'numeroViviendas'
    		},
    		{
    		    name: 'porcentajeAmbitoValorado'
    		},
    		{
    		    name: 'productoDesarrollarCodigo'
    		},
    		{
    		    name: 'proximidadRespectoNucleoUrbanoCodigo'
    		},
    		{
    		    name: 'sistemaGestionCodigo'
    		},
    		{
    		    name: 'tipoSueloCodigo'
    		},
    		{
    		    name: 'aprovechamiento'
    		},
    		{
    		    name: 'fechaUltimoGradoAvanceEstimado',
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
    		    name: 'porcentajeUrbanizacionEjecutado'
    		},
    		{
    		    name: 'porcentajeAmbitoValoradoEntero'
    		},
    		{
    		    name: 'productoDesarrollarPrevistoCodigo'
    		},
    		{
    		    name: 'proyectoObra'
    		},
    		{
    		    name: 'gastosComercialesTasacion'
    		},
    		{
    		    name: 'porcentajeCosteDefecto'
    		},
    		{
    		    name: 'fincaRusticaExpectativasUrbanisticas'
    		},
    		{
    		    name: 'paralizacionUrbanizacion'
    		},
    		{
    		    name: 'tipoDatoUtilizadoInmuebleComparableCodigo'
    		}    		
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'tasacion.json',
		api: {
            read: 'activo/getTasacionById',
            create: 'activo/createTasacionActivo',
            update: 'activo/saveTasacionActivo'
        },
		extraParams: {tab: 'tasacion', pestana: '6'}
    }
});