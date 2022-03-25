/**
 *  Modelo para el tab Informacion comercial de Activos 
 */
Ext.define('HreRem.model.ActivoInformacionComercial', {
    extend: 'HreRem.model.Base',
    idProperty: 'id',

    fields: [    
			{
    			name:'codigoMediador'
    		},
    		{
    			name:'nombreMediador'
    		},
    		{
    			name:'emailMediador'
    		},
    		{
    			name:'telefonoMediador'
    		},
			{
    			name:'fechaVisita',
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
    	    	name: 'nombreMediadorEspejo'
    	    },
    	    {
    	    	name: 'codigoMediadorEspejo'
    	    },
    	    {
    			name:'telefonoMediadorEspejo'
    		},
    		{
    			name:'emailMediadorEspejo'
    		},
			{
    			name:'numActivo'
    		},{
    			name:'autorizacionWeb'
    		},
     		{
    			name:'fechaAutorizacionHasta'
    		},
     		{
    			name:'recepcionLlavesApi',
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
    			name:'autorizacionWebEspejo'
    		},
     		{
    			name:'recepcionLlavesEspejo',
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
    		

	 { name: 'envioLlavesApi' },
	 { name: 'recepcionLlavesApi' },
	 { name: 'autorizacionWeb' },
	 { name: 'fechaAutorizacionHasta' },
	 { name: 'recepcionLlavesEspejo' },
	 { name: 'autorizacionWebEspejo' },
	 { name: 'codigoProveedor' },
	 { name: 'nombreProveedor' },
	 { name: 'tipoActivoCodigo' },
	 { name: 'subtipoActivoCodigo' },
	 { name: 'tipoActivoDescripcion' },
		{
			name: 'isVivienda',
			calculate: function(data) { 
				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['VIVIENDA'];
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isSuelo',
			calculate: function(data) { 
				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['SUELO'];
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isComercial',
			calculate: function(data) { 
				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO'];
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isConstruccion',
			calculate: function(data) { 
				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EN_CONSTRUCCION'];
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isComercialOrGaraje',
			calculate: function(data) { 
				if(data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO'] || data.subtipoActivoCodigo == CONST.SUBTIPOS_ACTIVO['GARAJE']){
					return true;
				}else{
					return false;
				}
			},
			depends: ['subtipoActivoCodigo', 'tipoActivoCodigo']
			
		},
		{
			name: 'isSueloEdificioConstruccion',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['SUELO'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EN_CONSTRUCCION']
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EDIFICIO_COMPLETO']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isEdificioConstruccion',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EN_CONSTRUCCION']
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EDIFICIO_COMPLETO']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isSueloComercialConstruccion',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['SUELO'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EN_CONSTRUCCION']
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isViviendaComercialEdificio',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['VIVIENDA'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO']
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EDIFICIO_COMPLETO']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isViviendaEdificio',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['VIVIENDA'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EDIFICIO_COMPLETO']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isViviendaComercialOtros',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['VIVIENDA'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO']
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['OTROS']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isViviendaComercialConstruccion',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['VIVIENDA'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO']
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EN_CONSTRUCCION']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isViviendaOtros',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['VIVIENDA'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['OTROS']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isOtros',
			calculate: function(data) { 
				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['OTROS'];
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isComercialOtros',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['OTROS']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isViviendaComercialIndustrial',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['VIVIENDA'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO']
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['INDUSTRIAL']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isIndustrialOtros',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['OTROS']
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['INDUSTRIAL']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isIndustrial',
			calculate: function(data) { 
				return data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['INDUSTRIAL'];
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isComercialIndustrial',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO']
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['INDUSTRIAL']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isSueloOtros',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['SUELO'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['OTROS']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isSueloConstruccionOtros',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['SUELO'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EN_CONSTRUCCION']
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['OTROS']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isViviendaComercial',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['VIVIENDA'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['COMERCIAL_Y_TERCIARIO']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isSueloConstruccionIndustrial',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['SUELO'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['INDUSTRIAL']
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EN_CONSTRUCCION']);
			},
			depends: 'tipoActivoCodigo'
			
		},
		{
			name: 'isSueloConstruccion',
			calculate: function(data) { 
				return (data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['SUELO'] 
						|| data.tipoActivoCodigo == CONST.TIPOS_ACTIVO['EN_CONSTRUCCION']);
			},
			depends: 'tipoActivoCodigo'
			
		},
	 { name: 'subtipoActivoDescripcion' },
	 { name: 'tipoViaCodigo' },
	 { name: 'tipoViaDescripcion' },
	 { name: 'nombreVia' },
	 { name: 'numeroDomicilio' },
	 { name: 'escalera' },
	 { name: 'piso' },
	 { name: 'puerta' },
	 { name: 'provinciaCodigo' },
	 { name: 'provinciaDescripcion' },
	 { name: 'municipioCodigo' },
	 { name: 'municipioDescripcion' },
	 { name: 'inferiorMunicipioCodigo' },
	 { name: 'inferiorMunicipioDescripcion' },
	 { name: 'codPostal' },
	 { name: 'latitud' },
	 { name: 'longitud' },
	 { name: 'posibleInforme' },
	 { name: 'motivoNoPosibleInforme' },
	 { name: 'ubicacionActivoCodigo' },
	 { name: 'ubicacionActivoDescripcion' },
	 { name: 'distrito' },

    { name: 'numeroActivo' },
	 { name: 'descripcionComercial' },
	 { name: 'fechaEmisionInforme' },
    
	//Datos activo
	 { name: 'regimenInmuebleCod' },
	 { name: 'regimenInmuebleDesc' },
	 { name: 'estadoOcupacionalCod' },
	 { name: 'estadoOcupacionalDesc' },
	 { name: 'anyoConstruccion' },

	//Caracteristicas del activo
	 { name: 'visitableCod' },
	 { name: 'visitableDesc' },
	 { name: 'ocupadoCod' },
	 { name: 'ocupadoDesc' },
	 { name: 'dormitorios' },
	 { name: 'banyos' },
	 { name: 'aseos' },
	 { name: 'salones' },
	 { name: 'estancias' },
	 { name: 'plantas' },
	 { name: 'planta' },
	 { name: 'ascensorCod' },
	 { name: 'ascensorDesc' },
	 { name: 'plazasGaraje' },
	 { name: 'terrazaCod' },
	 { name: 'terrazaDesc' },
	 { name: 'superficieUtil' },
	 { name: 'superficieTerraza' },
	 { name: 'patioCod' },
	 { name: 'patioDesc' },
	 { name: 'superficiePatio' },
	 { name: 'rehabilitadoCod' },
	 { name: 'rehabilitadoDesc' },
	 { name: 'anyoRehabilitacion' },
	 { name: 'licenciaObraCod' },
	 { name: 'licenciaObraDesc' },
	 { name: 'estadoConservacionCod' },
	 { name: 'estadoConservacionDesc' },
	 { name: 'anejoGarajeCod' },
	 { name: 'anejoGarajeDesc' },
	 { name: 'anejoTrasteroCod' },
	 { name: 'anejoTrasteroDesc' },
	
	//Caracteristicas ppales del activo
	 { name: 'orientacion' },
	 { name: 'extIntCod' },
	 { name: 'extIntDesc' },
	 { name: 'cocRatingCod' },
	 { name: 'cocRatingDesc' },
	 { name: 'cocAmuebladaCod' },
	 { name: 'cocAmuebladaDesc' },
	 { name: 'armEmpotradosCod' },
	 { name: 'armEmpotradosDesc' },
	 { name: 'calefaccionCod' },
	 { name: 'calefaccionDesc' },
	 { name: 'tipoCalefaccionCod' },
	 { name: 'tipoCalefaccionDesc' },
	 { name: 'aireAcondCod' },
	 { name: 'aireAcondDesc' },
	
	//Otras caracteristicas del activo (vivienda)
	 { name: 'estadoConservacionEdiCod' },
	 { name: 'estadoConservacionEdiDesc' },
	 { name: 'plantasEdificio' },
	 { name: 'puertaAccesoCod' },
	 { name: 'puertaAccesoDesc' },
	 { name: 'estadoPuertasIntCod' },
	 { name: 'estadoPuertasIntDesc' },
	 { name: 'estadoPersianasCod' },
	 { name: 'estadoPersianasDesc' },
	 { name: 'estadoVentanasCod' },
	 { name: 'estadoVentanasDesc' },
	 { name: 'estadoPinturaCod' },
	 { name: 'estadoPinturaDesc' },
	 { name: 'estadoSoladosCod' },
	 { name: 'estadoSoladosDesc' },
	 { name: 'estadoBanyosCod' },
	 { name: 'estadoBanyosDesc' },
	 { name: 'admiteMascotaCod' },
	 { name: 'admiteMascotaDesc' },
	
	//Otras caracteristicas del activo (!vivienda)
	 { name: 'licenciaAperturaCod' },
	 { name: 'licenciaAperturaDesc' },
	 { name: 'salidaHumoCod' },
	 { name: 'salidaHumoDesc' },
	 { name: 'aptoUsoCod' },
	 { name: 'aptoUsoDesc' },
	 { name: 'accesibilidadCod' },
	 { name: 'accesibilidadDesc' },
	 { name: 'edificabilidadTecho' },
	 { name: 'superficieSuelo' },
	 { name: 'porcUrbEjecutada' },
	 { name: 'clasificacionCod' },
	 { name: 'clasificacionDesc' },
	 { name: 'usoCod' },
	 { name: 'usoDesc' },
	 { name: 'metrosFachada' },
	 { name: 'almacenCod' },
	 { name: 'almacenDesc' },
	 { name: 'metrosAlmacen' },
	 { name: 'supVentaExpoCod' },
	 { name: 'supVentaExpoDesc' },
	 { name: 'metrosSupVentaExpo' },
	 { name: 'entreplantaCod' },
	 { name: 'entrePlantaDesc' },
	 { name: 'alturaLibre' },
	 { name: 'porcEdiEjecutada' },
	 { name: 'accesibilidadCod' },
	 { name: 'accesibilidadDesc' },
	
	//Equipamientos
	 { name: 'zonaVerdeCod' },
	 { name: 'zonaVerdeDesc' },
	 { name: 'jardinCod' },
	 { name: 'jardinDesc' },
	 { name: 'zonaDeportivaCod' },
	 { name: 'zonaDeportivaDesc' },
	 { name: 'gimnasioCod' },
	 { name: 'gimnasioDesc' },
	 { name: 'piscinaCod' },
	 { name: 'piscinaDesc' },
	 { name: 'conserjeCod' },
	 { name: 'conserjeDesc' },
	 { name: 'accesoMovReducidaCod' },
	 { name: 'accesoMovReducidaDesc' },
	
	//Comunicaciones y servicios
	 { name: 'ubicacionCod' },
	 { name: 'ubicacionDesc' },
	 { name: 'valUbicacionCod' },
	 { name: 'valUbicacionDesc' }
    ],
    
	proxy: {
		type: 'uxproxy',
		api: {
            read: 'activo/getTabActivo',
            create: 'activo/saveActivoInformacionComercial',
            update: 'activo/saveActivoInformacionComercial',
            destroy: 'activo/getTabActivo'
        },
		extraParams: {tab: 'informacioncomercial'}
    }

});