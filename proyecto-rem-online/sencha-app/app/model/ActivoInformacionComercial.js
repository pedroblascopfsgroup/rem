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
    			name:'fechaVisita'
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
	 { name: 'subtipoActivoCodigo' },
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
    
    //Valores económicos
     { name: 'valorEstimadoVenta' },
	 { name: 'valorEstimadoRenta' },
	 { name: 'valorEstimadoMinVenta' },
	 { name: 'valorEstimadoMinRenta' },
	 { name: 'valorEstimadoMaxVenta' },
	 { name: 'valorEstimadoMaxRenta' },
	
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
	 { name: 'ascensorCod' },
	 { name: 'ascensorDesc' },
	 { name: 'plazasGaraje' },
	 { name: 'terrazaCod' },
	 { name: 'terrazaDesc' },
	 { name: 'superficieTerraza' },
	 { name: 'patioCod' },
	 { name: 'patioDesc' },
	 { name: 'superficiePatio' },
	 { name: 'rehabilitadoCod' },
	 { name: 'rehabilitadoDesc' },
	 { name: 'anyoRehabilitacion' },
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
	 { name: 'calefaccion' },
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
	 { name: 'valUbicacionDesc' },

	//Otra info de interes
	 { name: 'modificadoInforme' },
	 { name: 'completadoInforme' },
	 { name: 'fechaModificadoInforme' },
	 { name: 'fechaCompletadoInforme' },
	 { name: 'fechaRecepcionInforme' }
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