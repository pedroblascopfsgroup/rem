/**
 * @class HreRem.ux.util.Constants
 * @author Jose Villel
 *
 * Clase para implementar constantes globales.
 * 
 * Ejemplo de uso: * 
 * CONST.ENTITY_TYPES
 * 
 * @singleton
 */
Ext.define('HreRem.ux.util.Constants', {
	alternateClassName: ['CONST'],
	singleton: true,

    constructor: function (config) {
    	this.initConfig(config)
    },    
         
    ENTITY_TYPES: {
        	
    	ACTIVO: 1,
        TRABAJO: 2,
        TRAMITE: 3,
        TAREA: 4
    },
    
    TIPOS_AGRUPACION: {
    	
    	OBRA_NUEVA: '01',
    	RESTRINGIDA: '02'    
    },
    
    TIPOS_ACTIVO: {
    	
    	SUELO: '01'    	
    },
    
    TIPOS_INFO_COMERCIAL: {
    	
    	VIVIENDA: '01',
    	LOCAL_COMERCIAL: '02',
    	PLAZA_APARCAMIENTO: '03'
    },
    
    TIPOS_ACTIVO: {
    	
    	SUELO: '01',
    	VIVIENDA: '02',
    	COMERCIAL_Y_TERCIARIO: '03',
    	INDUSTRIAL: '04',
    	EDIFICIO_COMPLETO: '05',
    	EN_CONSTRUCCION: '06',
    	OTROS: '07'
    },
    
    TIPOS_EXPEDIENTE_COMERCIAL: {
    	
    	VENTA: '01',
    	ALQUILER: '02'
    },
    
    TIPOS_TRABAJO: {
    	TASACION: '01',
		OBTENCION_DOCUMENTACION: '02',
		ACTUACION_TECNICA: '03',
		PRECIOS: '04',
		PUBLICACIONES: '05',
		COMERCIALIZACION: '06'
    	
    },
        
    TIPOS_CALCULO: {
    	PORCENTAJE: '01',
    	FIJO: '02'
    },
    
    TIPOS_DESTINATARIO_GASTO: {
    	PROPIETARIO: '01',
    	HAYA: '02'
    },

	TIPOS_PROVEEDOR: {
    	ENTIDAD: '01',
    	ADMINISTRACION: '02',
    	PROVEEDOR: '03'
    },
    
    SUBTIPOS_PROVEEDOR: {
    	MEDIADOR: '04'
    },
    
    MAP_TAB_ACTIVO_XTYPE: {
		FICHA:			'datosgeneralesactivo',
		INFOREG:		'datosgeneralesactivo.tituloinformacionregistralactivo',
		INFOADM:		'datosgeneralesactivo.informacionadministrativaactivo',
		CARGAS:			'datosgeneralesactivo.cargasactivo',
		POSESORIA:		'datosgeneralesactivo.situacionposesoriaactivo',
		VALORACION:		'datosgeneralesactivo.valoracionesactivo',
		INFOCOM:		'datosgeneralesactivo.informacioncomercialactivo',
		COMUNIDAD:		'datosgeneralesactivo.datoscomunidadactivo',
		TRAMITES:		'tramitesactivo',
		GESTORES:		'gestoresactivo',
		OBSERVACIONES:	'observacionesactivo',
		FOTOS:			'fotosactivo',
		FOTOSWEB:		'fotosactivo.fotoswebactivo',
		FOTOSTEC:		'fotosactivo.fotostecnicasactivo',
		DOCU:			'documentosactivo',
		AGRUPACIONES:	'agrupacionesactivo',
		ADMISION:		'admisionactivo',
		CHECKINFO:		'admisionactivo.admisioncheckinfoactivo',
		CHECKDOC:		'admisionactivo.admisioncheckdocactivo',
		GESTION:		'gestionactivo',
		HISTORICO:		'gestionactivo.historicopeticionesactivo',
		PRESUPUESTO:	'gestionactivo.presupuestoasignadosactivo',
		PUBLICACION:	'publicacionactivo',
		OFERTAS:		'comercialactivo.ofertascomercialactivo',
		VISITAS:		'comercialactivo.visitascomercialactivo',
		OFERTASAGRU:	'comercialagrupacion.ofertascomercialagrupacion',
		PROPUESTAS:		'preciosactivo.propuestaspreciosactivo'
//		INVISIBLE:		Si creamos un registro-enlace-activo en TFI y como codigo (en TFI_NOMBRE) damos este valor, ocultara el enlace		
    },
    
    MAP_TAB_TRABAJO_XTYPE: {
		FICHA:			'fichatrabajo',
		ACTIVOS:		'activostrabajo',
		TAREAS:			'tramitestareastrabajo',
		DIARIO:			'diariogestionestrabajo',
		FOTOS:			'fotostrabajo',
		FOTOSSOLI:		'fotostrabajo.fotostrabajosolicitante',
		FOTOSPROV:		'fotostrabajo.fotostrabajoproveedor',
		DOCU:			'documentostrabajo',
		GESECO:			'gestioneconomicatrabajo'
//		INVISIBLE:		Si creamos un registro-enlace-trabajo en TFI y como codigo (en TFI_NOMBRE) damos este valor, ocultara el enlace
    },
    
    CARTERA: {
    	CAJAMAR: '01',
    	SAREB: '02',
    	BANKIA: '03',
    	TERCEROS: '04'
    }
    

});
