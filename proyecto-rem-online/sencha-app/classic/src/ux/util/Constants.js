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
		PROYECTO: '04',
		ASISTIDA: '13',
		LOTE_COMERCIAL: '14',
		COMERCIAL_ALQUILER:'15',
		COMERCIAL_VENTA:'14'
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
		FIJO: '02',
		PORCENTAJE_ALQ: '03',
		FIJO_ALQ: '04',
		MENSUALIDAD_ALQ: '05'
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
		GESECO:				'gestioneconomicaexpediente',
		PLUVTA:             'plusvaliaventaexpedediente',
		SEGREN: 			'segurorentasexpediente'
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
    	GALEON:'15',
    	ZEUS: '14'
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
    	'15': 'GALEON',
    	'15': 'ZEUS'
    },

    
    NOMBRE_CARTERA2: {
    	CAJAMAR: 'CAJAMAR',
    	SAREB: 'SAREB',
    	BANKIA: 'BANKIA',
    	TANGO: 'TANGO',
    	GIANTS: 'GIANTS',
    	LIBERBANK:'LIBERBANK',
    	GALEON:'GALEON',
    	ZEUS :'ZEUS'
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
    	HAYAGESTPUBL: 'HAYAGESTPUBL',
    	HAYASUPPUBL: 'HAYASUPPUBL',
		GESTSUE: 'GESTSUE',
		GESTEDI: 'GESTEDI'
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
    	RECHAZADA: '02',
    	CONGELADA: '03',
    	PENDIENTE: '04'
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
    	DISPONIBLE_CONDICIONADO: '09',
    	ALQUILADO: '10',
    	DISPONIBLE_ALQUILER_OFERTA: '11',
    	DISPONIBLE_VENTA_ALQUILER_OFERTA: '12',
    	ALQUILADO_PARCIALMENTE: '13'
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
    

	CARTERA: {
		CAJAMAR: '01',
		SAREB: '02',
		BANKIA: '03',
		TERCEROS: '04',
		HYT: '06',
		CERBERUS: '07',
		LIBERBANK: '08',
		TANGO: '10',
		GIANTS: '12'
	},

	SUBCARTERA: {
		BH: '06',
		AGORAINMOBILIARIO: '135',
		AGORAFINANCIERO: '137'
	},

	NOMBRE_CARTERA:	{
		'01': 'CAJAMAR',
		'02': 'SAREB',
		'03': 'BANKIA',
		'04': 'TERCEROS',
		'06': 'HYT',
		'07': 'CERBERUS',
		'08': 'LIBERBANK',
		'10': 'TANGO',
		'12': 'GIANTS'
	},

	NOMBRE_CARTERA2: {
		CAJAMAR: 'CAJAMAR',
		SAREB: 'SAREB',
		CERBERUS: 'CERBERUS',
		BANKIA: 'BANKIA',
		TANGO: 'TANGO',
		GIANTS: 'GIANTS',
		LIBERBANK:'LIBERBANK'
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
		GESTOR_ACTIVOS: 'HAYAGESACT',
		GESTOR_ADMISION: 'GESTADM',
		HAYASUPER: 'HAYASUPER',
		GESTOPDV: 'GESTOPDV',
		SUPERVISOR_ACTIVO: 'HAYASUPACT',
		HAYACAL: 'HAYACAL',
		HAYASUPCAL: 'HAYASUPCAL',
		HAYAGESTPREC: 'HAYAGESTPREC',
		HAYAGESTPUBL: 'HAYAGESTPUBL',
		HAYASUPPUBL: 'HAYASUPPUBL',
		GESTSUE: 'GESTSUE',
		GESTEDI: 'GESTEDI'
	},

	TIPOS_OFERTA: {
		VENTA : '01',
		ALQUILER: '02'
	},

	TIPOS_ORIGEN: {
		REM: 'REM',
		WCOM: 'WCOM'
	},

	TIPOS_PROVEEDOR_EXPEDIENTE: {
		CAT : '28',
		MEDIADOR_OFICINA: '29'
	},

	ESTADO_ACTIVO: {
		SUELO : '01',
		EN_CONSTRUCCION_EN_CURSO : '02',
		OBRA_NUEVA_TERMINADO : '03',
		NO_OBRA_NUEVA_TERMINADO : '04',
		RUINA : '05',
		EN_CONSTRUCCION_PARADA : '06',
		OBRA_NUEVA_VANDALIZADO : '07',
		NO_OBRA_NUEVA_VANDALIZADO : '08',
		EDIFICIO_A_REHABILITAR : '09',
		OBRA_NUEVA_PDTE_LEGALIZAR : '10',
		NO_OBRA_NUEVA_PDTE_LEGALIZAR : '11'
	},

	ESTADOS_OFERTA: {
		ACEPTADA : '01',
		RECHAZADA: '02',
		CONGELADA: '03',
	    PENDIENTE: '04'
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
	},

	ES_VENTA: {
    	SI: 1,
    	NO: 0
    },

    COMBO_OCUPACION: {
		SI: 1,
		NO: 0
	},

	COMBO_CON_TITULO: {
		SI: 1,
		NO: 0
    },

	COMBO_SI_NO: {
		SI: 1,
		NO: 0
	},

	COMBO_ESTADO_ALQUILER: {
		LIBRE: '01',
		ALQUILADO: '02',
		CON_DEMANDAS: '03'
	},

	EXPORTADOR:{
		LIMITE: '1000'
	},

    MOTIVO_OCULTACION: {
         OTROS: '12'
     },

    ORIGEN_DATO: {
        REM: '01',
        RECOVERY: '02'
    },

    MODO_PUBLICACION_ALQUILER: {
        PRE_PUBLICAR: '0',
        FORZADO: '1'
    },

    ESTADO_PUBLICACION_ALQUILER: {
         NO_PUBLICADO: '01',
         PRE_PUBLICADO: '02',
         PUBLICADO: '03',
         OCULTO: '04'
    },

	ESTADO_PUBLICACION_VENTA: {
        NO_PUBLICADO: '01',
        PRE_PUBLICADO: '02',
        PUBLICADO: '03',
        OCULTO: '04'
    },

    DESCRIPCION_PUBLICACION:{
        PUBLICADO_VENTA: 'Publicado Venta',
        OCULTO_VENTA: 'Oculto Venta',
        PUBLICADO_ALQUILER: 'Publicado Alquiler',
        OCULTO_ALQUILER: 'Oculto Alquiler'
    },

	MOTIVOS_CAL_NEGATIVA:{
		OTROS: '21'
	},
	
	ESTADOS_MOTIVOS_CAL_NEGATIVA:{
		PENDIENTE: '01',
		SUBSANADO: '02'
	},
    
    TAREAS:{
    	T015_DEFINICIONOFERTA : 'T015_DefinicionOferta',
    	T015_VERIFICARSCORING : 'T015_VerificarScoring',
    	T015_VERIFICARSEGURORENTAS : 'T015_VerificarSeguroRentas'
    },

    TIPO_INQUILINO: {
		SCORING: '01',
		SEGURO_RENTAS: '02',
		NINGUNA: '03'
	},

	SUBTIPO_DOCUMENTO_EXPEDIENTE: {
		RENOVACION_CONTRATO: '46',
		CONTRATO: '49',
		FIANZA: '51',
		AVAL_BANCARIO: '52',
		JUSTIFICANTE_INGRESOS: '53',
		ALQUILER_CON_OPCION_A_COMPRA: '54'
	}
});
