Ext.define('HreRem.model.CalidadDatoPublicacionActivo', {
	extend: 'HreRem.model.Base',
	idProperty: 'idActivo',

	fields: [
	//FASE0
		{
			name: 'idActivo'
		},{
			name: 'drIdufirFase1'
		},{
			name: 'dqIdufirFase1'
		},{
			name: 'correctoIdufirFase1'
		},{
			name: 'drFincaRegistralFase1'
		},{
			name: 'dqFincaRegistralFase1'
		},{
			name: 'correctoFincaRegistralFase1'
		},{
			name: 'drTomoFase1'
		},{
			name: 'dqTomoFase1'
		},{
			name: 'correctoTomoFase1'
		},{
			name: 'drLibroFase1'
		},{
			name: 'dqLibroFase1'
		},{
			name: 'correctoLibroFase1'
		},{
			name: 'drFolioFase1'
		},{
			name: 'dqFolioFase1'
		},{
			name: 'correctoFolioFase1'
		},{
			name: 'drUsoDominanteFase1'
		},{
			name: 'dqUsoDominanteFase1'
		},{
			name: 'correctoUsoDominanteFase1'
		},{
			name: 'drMunicipioDelRegistroFase1'
		},{
			name: 'dqMunicipioDelRegistroFase1'
		},{
			name: 'correctoMunicipioDelRegistroFase1'
		},{
			name: 'drProvinciaDelRegistroFase1'
		},{
			name: 'dqProvinciaDelRegistroFase1'
		},{
			name: 'correctoProvinciaDelRegistroFase1'
		},{
			name: 'drNumeroDelRegistroFase1'
		},{
			name: 'dqNumeroDelRegistroFase1'
		},{
			name: 'correctoNumeroDelRegistroFase1'
		},{
			name: 'drVpoFase1'
		},{
			name: 'dqVpoFase1'
		},{
			name: 'correctoVpoFase1'
		},{
			name: 'drAnyoConstruccionFase1'
		},{
			name: 'dqAnyoConstruccionFase1'
		},{
			name: 'correctoAnyoConstruccionFase1'
		},{
			name: 'drTipologianFase1'
		},{
			name: 'dqTipologiaFase1'
		},{
			name: 'correctoTipologiaFase1'
		},{
			name: 'drSubtipologianFase1'
		},{
			name: 'dqSubtipologiaFase1'
		},{
			name: 'correctoSubtipologiaFase1'
		},{
			name: 'drInformacionCargasFase1'
		},{
			name: 'dqInformacionCargasFase1'
		},{
			name: 'correctoInformacionCargasFase1'
		},{
			name:'descripcionCargasInformacionCargasFase1'
		},{
			name: 'drInscripcionCorrectaFase1'
		},{
			name: 'dqInscripcionCorrectaFase1'
		},{
			name: 'correctoInscripcionCorrectaFase1'
		},{
			name: 'drPor100PropiedadFase1'
		},{
			name: 'dqPor100PropiedadFase1'
		},{
			name: 'correctoPor100PropiedadFase1'
		},
	//FASE3
		//FASE4
		
		//Fotos
		{
			name: 'numFotos'
		},
		{
			name: 'numFotosExterior'
		},
		{
			name: 'numFotosInterior'
		},
		{
			name: 'numFotosObra'
		},
		{
			name: 'numFotosMinimaResolucion'
		},
		{
			name: 'numFotosMinimaResolucionY'
		},
		{
			name: 'numFotosMinimaResolucionX'
		},
		{
			name: 'correctoFotos'
		},
		{
			name: 'mensajeDQFotos'
		}, //Descripcion
		{
			name: 'drFase4Descripcion'
		},
		{
			name: 'dqFase4Descripcion'
		},
		{
			name: 'correctoDescripcion'
		}, //Localizacion
		{
			name: 'drf4LocalizacionLatitud'
		},
		{
			name: 'dqF4Localizacionlatitud'
		},
		{
			name: 'drf4LocalizacionLongitud'
		},
		{
			name: 'dqf4LocalizacionLongitud'
		},
		{
			name: 'correctoLocalizacion'
		},
		{
			name: 'geodistanciaDQ'
		},
		{ //CEE
			name: 'etiquetaCEERem'
		},
		{
			name: 'numEtiquetaA'
		},
		{
			name: 'numEtiquetaB'
		},
		{
			name: 'numEtiquetaC'
		},
		{
			name: 'numEtiquetaD'
		},
		{
			name: 'numEtiquetaE'
		},
		{
			name: 'numEtiquetaF'
		},
		{
			name: 'numEtiquetaG'
		},
		{
			name: 'correctoCEE'
		},
		{
			name: 'mensajeDQCEE'
		}
		
	],

	proxy: {
		type: 'uxproxy',
		api: {
			//create: 'activo/saveFasePublicacionActivo',
			read: 'activo/getCalidadDatoPublicacionActivo'//,
			//update: 'activo/saveFasePublicacionActivo'
		}/*,
		extraParams: {tab: 'calidaddatopublicacion'}*/
	}
});
