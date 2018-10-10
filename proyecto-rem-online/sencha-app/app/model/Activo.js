/**
 * This view is used to present the details of an Activo.
 */
Ext.define('HreRem.model.Activo', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
      
    		{
    			name:'numActivoRem'
    		},
    		{
    			name:'numActivo'
    		},
    		{
    			name:'tipoTitulo'
    		},
    		{
    			name:'entidadPropietaria'
    		},
    		{
    			name:'entidadPropietariaCodigo' 
    		},
    		{
    			name: 'isCarteraBankia',
    			calculate: function(data) { 
    				return data.entidadPropietariaCodigo == CONST.CARTERA['BANKIA'];
    			},
    			depends: 'entidadPropietariaCodigo'
    		},
    		{
    			name: 'isCarteraCajamar',
    			calculate: function(data) { 
    				return data.entidadPropietariaCodigo == CONST.CARTERA['CAJAMAR'];
    			},
    			depends: 'entidadPropietariaCodigo'
    		},
    		{
    			name: 'isCarteraHyT',
    			calculate: function(data) { 
    				return data.entidadPropietariaCodigo == CONST.CARTERA['HYT'];
    			},
    			depends: 'entidadPropietariaCodigo'
    		},
    		{
    			name: 'isCarteraLiberbank',
    			calculate: function(data) { 
    				return data.entidadPropietariaCodigo == CONST.CARTERA['LIBERBANK'];
    			},
    			depends: 'entidadPropietariaCodigo'
    		},
    		{
    			name: 'subcarteraCodigo'
    		},
    		{
    			name: 'subcarteraDescripcion'
    		},
    		{
    			name:'entidadPropietariaDescripcion'
    		},
    		{
    			name:'tipoUsoDestino'
    		},
    		{
    			name:'tipoUsoDestinoCodigo'
    		},
    		{
    			name:'tipoUsoDestinoDescripcion'
    		},    	
    		{
    			name:'tipoTituloCodigo'
    		},
    		{
    			name:'tipoTituloDescripcion'
    		},
    		{
    			name:'tipoViaCodigo'
    		},
    		{
    			name:'tipoViaDescripcion'
    		},
    		{
    			name:'escalera'
    		},
    		{
    			name:'puerta'
    		},
    		{
    			name:'direccion'
    		},
    		{
    			name:'nombreVia'
    		},
    		{
    			name:'piso'
    		},
    		{
    			name:'puerta' 
    		},
    		{
    			name:'provinciaCodigo'
    		},
    		{
    			name:'codPostal'
    		},
    		{
    			name:'codPostalFormateado',
    			convert: function(value, record) {
    				if (Ext.isEmpty(record.get('codPostal'))) {
    					return "";
    				} else {
    					return '(' + record.get('codPostal') + ')';
    				}
    			},
    			depends: 'codPostal'
    		},
    		{
    			name:'numeroDomicilio',
    			depends: [ 'provinciaCodigo']
    		},
    		{
    			name:'municipioCodigo'
    		},
    		{
    			name:'paisCodigo'
    		},
    		{
    			name: 'idufir'
    		},
    		{
    			name:'descripcion'
    		},
    		{
    			name:'observaciones'
    		},        
			{
    			name:'referenciaCatastral'
    		},
    		{
    			name:'finca'

    		},
    		{
    			name:'idProp'
    		},
    		{
    			name: 'propietario',
    			convert: function (value) {
    				
    				if(!Ext.isEmpty(value) && value=='varios') {
    					return HreRem.i18n('txt.varios');
    				} else {
    					return value;
    				}
    				
    				
    			}
    		},
    		{
    			name:'idSareb'
    		}, 
    		{
    			name:'idRecovery'
    		}, 
    		{
    			name:'idUvem'
    		}, 
    		{
    			name:'tipoActivoCodigo'
    		}, 
    		{
    			name:'subtipoActivoCodigo'
    		}, 
    		{
    			name:'subtipoActivoDescripcion'
    		}, 
    		{
    			name:'tipoActivoDescripcion'
    		}, 
    		{
    			name:'municipioDescripcion'
    		},
    		{
    			name:'provinciaDescripcion'
    		},
    		{
    			name:'estadoActivoCodigo'
    		},
    		{
    			name:'divHorizontal'
    		},
    		
    		//Comunidad de propietarios
    		{
    			name:'tipoCuotaCodigo'
    		},
    		{
    			name:'direccionComunidad'
    		},
    		{
    			name:'nombre'
    		},
    		{
    			name:'nif'
    		},
    		{
    			name:'numCuenta'
    		},
    		{
    			name:'numCuentaUno'
    		},
    		{
    			name:'numCuentaDos'
    		},
    		{
    			name:'numCuentaTres'
    		},
    		{
    			name:'numCuentaCuatro'
    		},
    		{
    			name:'numCuentaCinco'
    		},
    		{
    			name:'nomPresidente'
    		},
    		{
    			name:'telfPresidente'
    		},
    		{
    			name:'telfPresidente2'
    		},
    		{
    			name:'emailPresidente'
    		},
    		{
    			name:'dirPresidente'
    		},
    		{
    			name:'fechaInicioPresidente',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'fechaFinPresidente',
    			type:'date',
    			dateFormat: 'c'
    		},
    		{
    			name:'nomAdministrador'
    		},
    		{
    			name:'telfAdministrador'
    		},
    		{
    			name:'telfAdministrador2'
    		},
    		{
    			name:'emailAdministrador'
    		},
    		{
    			name:'dirAdministrador'
    		},
    		{
    			name:'importeMedio'
    		},
    		{
    			name:'estatutos'
    		},    		
    		{
    			name:'libroEdificio'
    		},
    		{
    			name:'certificadoIte'
    		},
    		{
    			name:'observaciones'
    		},
    		{
    			name:'latitud',
    			type: 'number'
    		},
    		{
    			name:'longitud',
    			type: 'number'
    		},
    		{
    			name:'inferiorMunicipioCodigo'
    		},
    		{
    			name:'inferiorMunicipioDescripcion'
    		},
    		{
    			name: 'selloCalidad',
    			type: 'boolean'
    		},
    		{
    			name: 'admision',
    			type: 'boolean'
    		},
    		{
    			name: 'gestion',
    			type: 'boolean'
    		},
    		{
    			name: 'informeComercialAceptado',
    			type: 'boolean'
    		},
    		{
    			name: 'tipoActivoAdmisionMediadorCorresponde',
    			type: 'boolean'
    		},
    		{
    			name: 'isPublicable',
    			calculate: function(data) {
    				if(data.admision && data.gestion && data.informeComercialAceptado && data.tipoActivoAdmisionMediadorCorresponde) {
    					return true;
    				} else {
    					return false;
    				}
    			},
    			depends: 'admision'
    		},
    		{
    			name: 'rating',
    			convert: function(value) {
    				return Ext.isEmpty(value) ? '0' : value;
    			}
    		},
    		{
    			name: 'tipoInfoComercialCodigo'
    		},
    		{
    			name: 'isVivienda',
    			calculate: function(data) {
    				return data.tipoInfoComercialCodigo == CONST.TIPOS_INFO_COMERCIAL['VIVIENDA'];
    			},
    			depends: 'tipoInfoComercialCodigo'
    		},
    		{
    			name: 'isLocalComercial',
    			calculate: function(data) {
    				return data.tipoInfoComercialCodigo ==  CONST.TIPOS_INFO_COMERCIAL['LOCAL_COMERCIAL'];
    			},
    			depends: 'tipoInfoComercialCodigo'
    			
    		},
    		{
    			name: 'isPlazaAparcamiento',
    			calculate: function(data) { 
    				return data.tipoInfoComercialCodigo ==  CONST.TIPOS_INFO_COMERCIAL['PLAZA_APARCAMIENTO'];
    			},
    			depends: 'tipoInfoComercialCodigo'
    			
    		},
    		{
    			name: 'tipoActivoMediadorCodigo'
    		},
    		{
    			name: 'isViviendaMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoMediadorCodigo)){
    					return false;
    				}
    				return data.tipoActivoMediadorCodigo == CONST.TIPOS_ACTIVO['VIVIENDA'];
    			},
    			depends: 'tipoActivoMediadorCodigo'
    		},
    		{
    			name: 'isPlazaAparcamientoMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoMediadorCodigo)){
    					return false;
    				}
    				return data.tipoActivoMediadorCodigo == CONST.TIPOS_ACTIVO['PLAZA_APARCAMIENTO'];
    			},
    			depends: 'tipoActivoMediadorCodigo'
    		},
    		{
    			name: 'isLocalComercialMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoMediadorCodigo)){
    					return false;
    				}
    				return data.tipoActivoMediadorCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO'];
    			},
    			depends: 'tipoActivoMediadorCodigo'
    		},
    		{
    			name: 'isIndustrialMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoMediadorCodigo)){
    					return false;
    				}
    				return data.tipoActivoMediadorCodigo == CONST.TIPOS_ACTIVO['INDUSTRIAL'];
    			},
    			depends: 'tipoActivoMediadorCodigo'
    		},
    		{
    			name: 'isEdificioCompletoMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoMediadorCodigo)){
    					return false;
    				}
    				return data.tipoActivoMediadorCodigo == CONST.TIPOS_ACTIVO['EDIFICIO_COMPLETO'];
    			},
    			depends: 'tipoActivoMediadorCodigo'
    		},
    		{
    			name: 'isSueloMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoMediadorCodigo)){
    					return false;
    				}
    				return data.tipoActivoMediadorCodigo == CONST.TIPOS_ACTIVO['SUELO'];
    			},
    			depends: 'tipoActivoMediadorCodigo'
    		},
    		{
    			name: 'isEnConstruccionMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoMediadorCodigo)){
    					return false;
    				}
    				return data.tipoActivoMediadorCodigo == CONST.TIPOS_ACTIVO['EN_CONSTRUCCION'];
    			},
    			depends: 'tipoActivoMediadorCodigo'
    		},
    		{
    			name: 'isOtrosMediador',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.tipoActivoMediadorCodigo)){
    					return false;
    				}
    				return data.tipoActivoMediadorCodigo == CONST.TIPOS_ACTIVO['OTROS'];
    			},
    			depends: 'tipoActivoMediadorCodigo'
    		},
    		{
    			name: 'tipoComercializacionDescripcion'
    		},
    		{
    			name: 'estadoPublicacionDescripcion'
    		},
    		{
    			name: 'estadoPublicacionCodigo'
    		},
			{
				name: 'incluidoEnPerimetro'
			},
			{
				name: 'fechaAltaActivoRem',
    			type:'date',
    			dateFormat: 'c'
			},
			{
				name: 'aplicaTramiteAdmision',
				type: 'boolean'
			},
			{
				name: 'fechaAplicaTramiteAdmision',
    			type:'date',
    			dateFormat: 'c'
			},
			{
				name: 'motivoAplicaTramiteAdmision'
			},
			{
				name: 'aplicaGestion',
				type: 'boolean'
			},
			{
				name: 'fechaAplicaGestion',
    			type:'date',
    			dateFormat: 'c'
			},
			{
				name: 'motivoAplicaGestion'
			},
			{
				name: 'aplicaAsignarMediador',
				type: 'boolean'
			},
			{
				name: 'fechaAplicaAsignarMediador',
    			type:'date',
    			dateFormat: 'c'
			},
			{
				name: 'motivoAplicaAsignarMediador'
			},
			{
				name: 'aplicaComercializar',
				type: 'boolean'
			},
			{
				name: 'tipoComercializacionCodigo'
			},
			{
				name: 'isDestinoComercialAlquiler',
    			calculate: function(data) { 
    				return data.tipoComercializacionCodigo !=  CONST.TIPOS_COMERCIALIZACION['VENTA'];
    			},
    			depends: 'tipoComercializacionCodigo'
			},
			{
				name: 'fechaAplicaComercializar',
    			type:'date',
    			dateFormat: 'c'
			},
			{
				name: 'motivoAplicaComercializarDescripcion'
			},
			{
				name: 'motivoNoAplicaComercializarDescripcion'
			},
			{
				name: 'aplicaFormalizar',
				type: 'boolean'
			},
			{
				name: 'fechaAplicaFormalizar',
    			type:'date',
    			dateFormat: 'c'
			},
			{
				name: 'motivoAplicaFormalizar'
			},
			{
				name: 'claseActivoCodigo'
			},
			{
				name: 'subtipoClaseActivoCodigo'
			},
			{
				name: 'numExpRiesgo'
			},
			{
				name: 'tipoProducto'
			},
			{
				name: 'estadoExpRiesgo'
			},
			{
				name: 'estadoExpIncorriente'
			},
			{
				name: 'claseActivoDescripcion'
			},
			{
				name: 'motivoNoAplicaComercializar'
			},
			{
				name: 'pertenceAgrupacionRestringida',
				type: 'boolean'
			},
			{
				name: 'pertenceAgrupacionComercial',
				type: 'boolean'
			},
			{
				name: 'pertenceAgrupacionAsistida',
				type: 'boolean'
			},
			{
				name: 'pertenceAgrupacionObraNueva',
				type: 'boolean'
			},
			{
				name: 'bloqueoTipoComercializacionAutomatico',
				type: 'boolean'
			},
			{
				name: 'situacionComercialCodigo'
			},
    		{
    			name: 'isVendido',
    			calculate: function(data) {
    				if(Ext.isEmpty(data.situacionComercialCodigo)){
    					return false;
    				}
    				return data.situacionComercialCodigo == CONST.SITUACION_COMERCIAL['VENDIDO'];
    			},
    			depends: 'situacionComercialCodigo'
    		},
    		{
				name: 'nombreGestorSelloCalidad'
			},
			{
				name: 'fechaRevisionSelloCalidad',
				type:'date',
    			dateFormat: 'c'
			},
			{
				name: 'ibiExento',
				type: 'boolean'
			},
			{
				name: 'codigoPromocionPrinex'
			},
			{
				name: 'entradaActivoBankiaCodigo'
			},
			{
				name: 'numInmovilizadoBankia'
			},
			{
				name: 'activoBNK'
			},
			{
				name: 'ocupado'
			},
			{
				name: 'tipoEstadoAlquiler'
			},
			{
				name: 'tieneOfertaAlquilerViva',
				type: 'boolean'
			},
			{
				name: 'esGestorAlquiler',
				type: 'boolean'
			}
    ],
    
	proxy: {
		type: 'uxproxy',
		localUrl: 'activos.json',
		remoteUrl: 'activo/getTabActivo',

		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveDatosBasicos',
            update: 'activo/saveDatosBasicos',
            destroy: 'activo/getTabActivo'
        },
        
		extraParams: {tab: 'datosbasicos'}

    }

});