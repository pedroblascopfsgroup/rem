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
    }
    

});
