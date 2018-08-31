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
        TAREA: 4,
        EXPEDIENTE: 5,
        GASTO: 6
    },

    TIPOS_COMERCIALIZACION: {    	
    	VENTA: '01',
    	ALQUILER_VENTA: '02',
    	SOLO_ALQUILER: '03',
    	ALQUILER_OPCION_COMPRA: '04'
    },
    
    TIPOS_AGRUPACION: {
    	
    	OBRA_NUEVA: '01',
    	RESTRINGIDA: '02',
    	ASISTIDA: '13',
    	LOTE_COMERCIAL: '14'
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
		PUBLICACION_DATOS:		'publicacionactivo.datospublicacionactivo',
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
    
    MAP_TAB_EXPEDIENTE_XTYPE: {
		BASICOS:			'datosbasicosexpediente',
		OFERTAS:			'ofertaexpediente',
		CONDICIONES:		'condicionesexpediente',
		ACTIVOS:			'activosexpediente',
		RESERVA:			'reservaexpediente',
		COMPRADOR:			'compradoresexpediente',
		DIARIO:				'diariogestionesexpediente',
		TRAMITES:			'tramitestareasexpediente',
		DOCU:				'documentosexpediente',
		FORMA:				'formalizacionexpediente',
		GESECO:				'gestioneconomicaexpediente'		
//		INVISIBLE:		Si creamos un registro-enlace-expediente en TFI y como codigo (en TFI_NOMBRE) damos este valor, ocultara el enlace
    },

    CARTERA: {
    	CAJAMAR: '01',
    	SAREB: '02',
    	BANKIA: '03',
    	TERCEROS: '04',
    	HYT: '06',
    	LIBERBANK: '08',
    	TANGO: '10',
    	GIANTS: '12',
    	GALEON:'15'
    },

    NOMBRE_CARTERA:	{
    	'01': 'CAJAMAR',
    	'02': 'SAREB',
    	'03': 'BANKIA',
    	'04': 'TERCEROS',
    	'06': 'HYT',
    	'08': 'LIBERBANK',    	
    	'10': 'TANGO',
    	'12': 'GIANTS',
    	'15': 'GALEON'
    },

    
    NOMBRE_CARTERA2: {
    	CAJAMAR: 'CAJAMAR',
    	SAREB: 'SAREB',
    	BANKIA: 'BANKIA',
    	TANGO: 'TANGO',
    	GIANTS: 'GIANTS',
    	LIBERBANK:'LIBERBANK',
    	GALEON:'GALEON'
    },
    
    SUBCARTERA: {
    	BH: '06'
    },
    
    NOMBRE_SUBCARTERA: {
    	BANKIA_HABITAT: 'BANKIA HABITAT'
    },

    IMAGENES_CARTERA: {
    	CAJAMAR: 'logo_cajamar.svg',
    	SAREB: 'logo_sareb.svg',
    	BANKIA: 'logo_bankia.svg'
    },
    
    PERFILES: {   	
    	PROVEEDOR: 'HAYAPROV',
    	GESTOR_ACTIVOS: 'GESTACT',
    	GESTOR_ADMISION: 'GESTADM',
    	HAYASUPER: 'HAYASUPER',
    	GESTOPDV: 'GESTOPDV',
    	SUPERVISOR_ACTIVO: 'HAYASUPACT',
    	HAYACAL: 'HAYACAL',
    	HAYASUPCAL: 'HAYASUPCAL',
    	HAYAGESTPREC: 'HAYAGESTPREC',
    	HAYAGESTPUBL: 'HAYAGESTPUBL'
    },
    
    TIPOS_OFERTA: {
    	VENTA : '01',
    	ALQUILER: '02'
    },
    
    TIPOS_PROVEEDOR_EXPEDIENTE: {
    	CAT : '28',
    	MEDIADOR_OFICINA: '29'
    },
    
    ESTADOS_OFERTA: {
    	ACEPTADA : '01',
    	RECHAZADA: '02'
    },
    
    ESTADOS_EXPEDIENTE: {
    	EN_TRAMITACION: '01',
    	ANULADO: '02',
    	FIRMADO: '03',
    	CONTRAOFERTADO: '04',
    	BLOQUEO_ADM: '05',
    	RESERVADO: '06',
    	POSICIONADO: '07',
    	VENDIDO: '08',
    	RESUELTO: '09',
    	PENDIENTE_SANCION: '10',
    	APROBADO: '11',
    	DENEGADO: '12',
    	PTE_DOBLE_FIRMA: '13',
    	RPTA_OFERTANTE: '14',
    	EN_DEVOLUCION: '16'
    },
    
    ESTADOS_GASTO: {
    	PAGADO_SIN_JUSTIFICANTE: '13',
    	INCOMPLETO: '12',
    	SUBSANADO_GESTOR: '11',
    	SUBSANADO: '10',
    	AUTORIZADO_PROPIETARIO: '09',
    	RECHAZADO_PROPIETARIO: '08',
    	RETENIDO: '07',
    	ANULADO: '06',
    	PAGADO: '05',
    	CONTABILIZADO: '04',
    	AUTORIZADO: '03',
    	RECHAZADO: '02',
    	PENDIENTE: '01'    	
    },
    
    ESTADOS_AUTORIZACION_HAYA: {
    	AUTORIZADO: '03',
    	RECHAZADO: '02',
    	PENDIENTE: '01'    	
    },
    
    ESTADOS_PROVISION: {
    	RECHAZADA_SUBSANABLE: '03'	
    },

    ESTADOS_PUBLICACION: {
    	PUBLICADO: '01',
    	PUBLICADO_FORZADO: '02',
    	PUBLICADO_OCULTO: '03',
    	PUBLICADO_PRECIO_OCULTO: '04',
    	DESPUBLICADO: '05',
    	NO_PUBLICADO: '06',
    	PUBLICADO_FORZADO_PRECIO_OCULTO: '07'
    },
    
    SITUACION_COMERCIAL: {
    	NO_COMERCIALIZABLE: '01',
    	DISPONIBLE_VENTA: '02',
    	DISPONIBLE_VENTA_OFERTA: '03',
    	DISPONIBLE_VENTA_RESERVA: '04',
    	VENDIDO: '05',
    	TRASPASADO: '06',
    	DISPONIBLE_ALQUILER: '07',
    	DISPONIBLE_VENTA_ALQUILER: '08',
    	DISPONIBLE_CONDICIONADO: '09'
    },

    ACCION_GASTOS: {
    	PRESCRIPCION: '04',
    	COLABORACION: '05',
    	RESPONSABLE_CLIENTE: '06'
    },

    TIPO_PROVEEDOR_HONORARIO: {
    	MEDIADOR: '04',
    	FVD: '18',
    	OFICINA_BANKIA: '28',
    	OFICINA_CAJAMAR: '29',
    	CAT: '31'
    },
    
    SITUACION_CARGA: {
    	VIEGENTE: 'VIG',
    	NO_CANCELABLE: 'NCN',
    	CANCELADA: 'CAN',
    	EN_SANEAMIENTO: 'SAN'
    },
    
    CLASE_ACTIVO: {
    	FINANCIERO: '01',
    	INMOBILIARIO: '02'
    },
    
    SUBTIPOS_TRABAJO: {

		TRAMITAR_PROPUESTA_PRECIOS: '44',
		TRAMITAR_PROPUESTA_DESCUENTO: '45',
		TOMA_POSESION: '57'   	
    },

    TIPO_IMPUESTO: {
    	IVA: '01',
		ITP: '02',
		IGIC: '03',
		IPSI: '04'
    },
    
    TIPO_TITULO_ACTIVO: {
    	JUDICIAL: '01',
    	NO_JUDICIAL: '02',
    	PDV: '03'
    },
    
    TIPO_RESOLUCION_COMITE: {
    	APRUEBA: '01',
    	RECHAZA: '02',
    	CONTRAOFERTA: '03'
    }
    
});
