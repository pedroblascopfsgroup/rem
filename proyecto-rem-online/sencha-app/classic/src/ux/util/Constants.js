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
		GASTO: 6,
		AGRUPACION: 7
	},

	TIPOS_COMERCIALIZACION: {
		VENTA: '01',
		ALQUILER_VENTA: '02',
		SOLO_ALQUILER: '03',
		ALQUILER_OPCION_COMPRA: '04'
	},

	TIPO_COMERCIALIZACION_ACTIVO: {
		VENTA:'Venta',
		ALQUILER: 'Alquiler',
		ALQUILER_VENTA: 'Alquiler y venta',
		ALQUILER_OPCION_COMPRA: 'Alquiler con opci�n a compra',
		ALQUILER_NO_COMERCIAL: 'Alquiler no comercial'		
	},

	TIPOS_AGRUPACION: {
		OBRA_NUEVA: '01',
		RESTRINGIDA: '02',
		PROYECTO: '04',
		ASISTIDA: '13',
		LOTE_COMERCIAL: '14',
		COMERCIAL_ALQUILER:'15',
		COMERCIAL_VENTA:'14',
		PROMOCION_ALQUILER:'16'
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

	SUBTIPOS_ACTIVO: {
		OBRA_NUEVA: '23'
	},

	TIPOS_EXPEDIENTE_COMERCIAL: {
		VENTA: '01',
		ALQUILER: '02',
		ALQUILER_NO_COMERCIAL: '03'
	},

	TIPOS_TRABAJO: {
		TASACION: '01',
		OBTENCION_DOCUMENTACION: '02',
		ACTUACION_TECNICA: '03',
		PRECIOS: '04',
		PUBLICACIONES: '05',
		COMERCIALIZACION: '06',
		EDIFICACION: '07',
		SUELO: '08'
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
		SOCIEDAD_TASADORA: '02',
		MEDIADOR: '04',
		OFICINA_BBVA:'39',
		OFICINA_LIBERBANK:'38',
		OFICINA_BANKIA: '28',
		OFICINA_CAJAMAR: '29'
		
	},

	MAP_TAB_ACTIVO_XTYPE: {
		FICHA:			'datosgeneralesactivo',
		INFOREG:		'datosgeneralesactivo.tituloinformacionregistralactivo',
		INFOADM:		'datosgeneralesactivo.informacionadministrativaactivo',
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
		CHECKDOC:		'admisionactivo.admisioncheckdocactivo',
		GESTION:		'gestionactivo',
		HISTORICO:		'gestionactivo.historicopeticionesactivo',
		PRESUPUESTO:	'gestionactivo.presupuestoasignadosactivo',
		PUBLICACION:	'publicacionactivo',
		PUBLICACION_DATOS:		'publicacionactivo.datospublicacionactivo',
		OFERTAS:		'comercialactivo.ofertascomercialactivo',
		VISITAS:		'comercialactivo.visitascomercialactivo',
		GENCAT:			'comercialactivo.gencatactivo',
		OFERTASAGRU:	'comercialagrupacion.ofertascomercialagrupacion',
		PROPUESTAS:		'preciosactivo.propuestaspreciosactivo',
		PLUSVALIA:		'plusvaliaactivo'
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
		GESECO:			'gestioneconomicatrabajo',
		AGENDA:			'agendatrabajo'
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
		SEGREN: 			'segurorentasexpediente',
		GARANTIAS:			'garantiasexpediente'
//		INVISIBLE:		Si creamos un registro-enlace-expediente en TFI y como codigo (en TFI_NOMBRE) damos este valor, ocultara el enlace
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
    	THIRD: '11',
    	THIRDPARTIES: '11',
    	GIANTS: '12',
    	EGEO: '13',
    	GALEON:'15',
    	ZEUS: '14',
    	BBVA: '16',
    	TITULIZADA: '18'
    },

    NOMBRE_CARTERA:	{
    	'01': 'CAJAMAR',
    	'02': 'SAREB',
    	'03': 'CAIXABANK',
    	'04': 'TERCEROS',
    	'06': 'HYT',
    	'07': 'CERBERUS',
    	'08': 'UNICAJA',
    	'10': 'TANGO',
    	'11': 'THIRDPARTIES',
    	'12': 'GIANTS',
    	'15': 'GALEON',
    	'14': 'ZEUS',
    	'16': 'BBVA',
    	'18': 'TITULIZADA'
    },

    NOMBRE_CARTERA2: {
    	CAJAMAR: 'CAJAMAR',
    	SAREB: 'SAREB',
    	CERBERUS: 'CERBERUS',
    	BANKIA: 'BANKIA',
    	TANGO: 'TANGO',
    	THIRD: 'THIRD',
    	GIANTS: 'GIANTS',
    	LIBERBANK:'LIBERBANK',
    	GALEON:'GALEON',
    	ZEUS :'ZEUS',
    	BBVA :'BBVA',
		CAIXABANK : 'CAIXABANK',
		UNICAJA : 'UNICAJA',
		TITULIZADA: 'TITULIZADA'
    },

    SUBCARTERA: {
    	SAREBINMOBILIARIO: '04',
    	BH: '06',
    	BFA: '07',
    	BANKIA: '08',
    	ZEUSINMOBILIARIO: '133',
    	ZEUSFINANCIERO: '134',
    	AGORAINMOBILIARIO: '135',
		AGORAFINANCIERO: '137',
		APPLEINMOBILIARIO: '138',
		YUBAI: '139',
		SAREB: '15',
		LBKINMOBILIARIO: '18',
		BLUETHINV: '23',
		TIFIOS: '24',
		QUITASBANKIA: '25',
		COMERCIALING: '30',
		QUITASCAJAMAR: '032',
		GOLDENTREE: '32',
		GGIANTSREOI: '33',
		GGIANTSREOII: '34',
		GGIANTSREOIII: '35',
		GGIANTSREOIV: '36',
		JAIPURINMOBILIARIO: '37',
		JAIPURFINANCIERO: '38',
		EGEO: '39',
		ZEUS: '41',
		LIBERBANK: '56',
		MOSCATA: '57',
		BEYOSPONGA: '59',
		RETAMAR: '60',
		DIVARIAN: '150',
		OMEGA: '65',
		DIVARIANARROW:'151',
		DIVARIANREMAINING:'152',
		BBVA:'153',
		ANIDA:'154',
		CX:'155',
		GAT:'156',
		EDT:'157',
		USGAI:'158',
		TITEDT:'162',
		TITTDA:'163'
    },

    NOMBRE_SUBCARTERA: {
    	BANKIA_HABITAT: 'BANKIA HABITAT',
    	CERBERUS_AGORA: 'Agora - Inmobiliario',
    	YUBAI: 'YUBAI'
    },

    IMAGENES_CARTERA: {
    	CAJAMAR: 'logo_cajamar.svg',
    	SAREB: 'logo_sareb.svg',
    	BANKIA: 'logo_bankia.svg',
		CAIXABANK: 'logo_bankia.svg',
		UNICAJA: 'logo_unicajaBanco.svg'
    },

    PERFILES: {
    	PROVEEDOR: 'HAYAPROV',
    	GESTOR_ACTIVOS: 'HAYAGESACT',
    	GESTOR_ADMISION: 'HAYAGESTADM',
    	HAYASUPER: 'HAYASUPER',
    	SUPERUSUARO_ADMISION: 'SUPERADMIN',
    	GESTOPDV: 'GESTOPDV',
    	SUPERVISOR_ACTIVO: 'HAYASUPACT',
    	HAYACAL: 'HAYACAL',
    	HAYASUPCAL: 'HAYASUPCAL',
    	HAYAGESTPREC: 'HAYAGESTPREC',
    	HAYAGESTPUBL: 'HAYAGESTPUBL',
    	HAYASUPPUBL: 'HAYASUPPUBL',
		GESTSUE: 'GESTSUE',
		GESTEDI: 'GESTEDI',
		HAYAGESTFORMADM: 'HAYAGESTFORMADM',
		GESTIAFORM:'GESTIAFORM',
		USUARIO_CONSULTA: 'HAYACONSU',
		GESTOR_COMERCIAL: 'HAYAGESTCOM',
		SUPERVISOR_COMERCIAL:'HAYASUPCOM',
		GESTOR_FORM: 'HAYAGESTFORM',
		SUPERVISOR_FORM: 'HAYASUPFORM',
		GESTOR_COMERCIAL_BO_INM: 'HAYAGBOINM',
		SUPERVISOR_COMERCIAL_BO_INM: 'HAYASBOINM',
		GESTOR_COMERCIAL_SINGULAR: 'GCOMSIN',
		SUPERVISOR_ADMINISTRACION: 'HAYASADM',
		GESTOR_ADMINISTRACION: 'HAYAADM',
		GESTORIAS_ADMINISTRACION: 'HAYAGESTADMT',
		HAYAGESTFORM: 'HAYAGESTFORM',
		AUTOTRAMOFR: 'AUTOTRAMOFR',
		GESTORIA_ADMISION: 'GESTOADM',
		HAYA_GRUPO_CES:'HAYAGRUPOCES',
		DIRECCION_TERRITORIAL:'DIRTERRITORIAL',
		GESTOR_PRECIOS:'HAYAGESTPREC',
		PERFGCONTROLLER:'PERFGCONTROLLER',
		GESTOR_PUBLICACION:'HAYAGESTPUBL',
		SUPERVISOR_ADMISION:'HAYASUPADM',
		SUPER_EDITA_COMPRADOR: 'SUPEREDITACOMPRADOR',
		SUPERCOMERCIAL:'SUPERCOMERCIAL',
		GESTOR_ALQUILER_HPM: 'GESTALQ',
		SUPERVISOR_ADMISION: 'HAYASUPADM',
		PERFIL_SEGURIDAD:'PERFSEGURIDAD',
		GESTBOARDING: 'PERFGBOARDING',
		CARTERA_BBVA: 'CARTERA_BBVA',
		SUPERCOMERCIAL:'SUPERCOMERCIAL',
		SEGURIDAD_REAM: 'SEGURIDAD_REAM',
		USUARIOS_BC: 'USUARIOS_BC',
		ASSET_MANAGEMENT: 'HAYAGESTASSETMAN',
		TASADORA: 'TASADORA'
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
    	PENDIENTE: '04',
    	PDTE_CONSENTIMIENTO: '05',
    	CADUCADA: '06'
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
    	EN_DEVOLUCION: '16',
    	PTE_DE_SANCION_COMITE : '23',
    	PTE_SANCION_COMITE : '31',
    	PTE_RESOLUCION_COMITE : '34',
    	PTE_PBC: '24',
    	PTE_POSICIONAMIENTO: '25',
    	PTE_FIRMA: '27',
    	PTE_CIERRE: '28',
    	PTE_RESOLUCION_CES: '34',
    	AP_CES_PTE_MAN: '36',
    	CONT_CES: '38',
    	RES_PTE_MAN: '39',
    	AP_PTE_MAN : '40',
    	PEN_RES_OFER_COM : '43'
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
    	VIGENTE: '01',
    	NO_REQUIERE_GESTION: '02',
    	CANCELADA: '03',
    	CADUCADA: '04'    	
    },

    CLASE_ACTIVO: {
    	FINANCIERO: '01',
    	INMOBILIARIO: '02'
    },

	TIPOS_ORIGEN: {
		REM: 'REM',
		WCOM: 'WCOM'
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

	SUBTIPOS_TRABAJO: {
		TRAMITAR_PROPUESTA_PRECIOS: '44',
		TRAMITAR_PROPUESTA_DESCUENTO: '45',
		TOMA_POSESION: '57',
		OBRA_MENOR_NO_TARIFICADA:'38',
		PAQUETES:'PAQ'
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
		PDV: '03',
		UNIDAD_ALQUILABLE: '05'
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
	
	COMBO_SIN_NO: {
		SI: '01',
		NO: '02'
	},
	
	COMBO_SIN_SINO: {
		SI: '01',
		NO: '02'
	},
	
	COMBO_TRUE_FALSE: {
		TRUE: 'true',
		FALSE: 'false'
	},

	COMBO_TRUE_FALSE: {
		TRUE: 'true',
		FALSE: 'false'
	},

	COMBO_ESTADO_ALQUILER: {
		LIBRE: '01',
		ALQUILADO: '02',
		CON_DEMANDAS: '03'
	},

	EXPORTADOR:{
		LIMITE: '1000'
	},

	SANCION_GENCAT: {
		EJERCE: 'EJERCE',
		NO_EJERCE: 'NO_EJERCE'
	},

	ESTADO_COMUNICACION_GENCAT: {
		CREADO: 'CREADO',
		RECHAZADO: 'RECHAZADO',
		COMUNICADO: 'COMUNICADO',
		SANCIONADO: 'SANCIONADO',
		ANULADO: 'ANULADO'
	},

    MOTIVO_OCULTACION: {
         OTROS: '12'
     },

    ORIGEN_DATO: {
        REM: '01',
        RECOVERY: '02',
        PRISMA: '03'
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
    	T015_VERIFICARSEGURORENTAS : 'T015_VerificarSeguroRentas',
    	T013_DEFINICIONOFERTA : 'T013_DefinicionOferta',
    	T013_RESOLUCIONCOMITE: 'T013_ResolucionComite'
    },

    TIPO_INQUILINO: {
		SCORING: '01',
		SEGURO_RENTAS: '02',
		NINGUNA: '03'
	},
	
	TIPO_DOCUMENTO_JUNTAS: {
		RECEPCION_CONVOCATORIA: '153'
	},

	SUBTIPO_DOCUMENTO_EXPEDIENTE: {
		RENOVACION_CONTRATO: '46',
		CONTRATO: '49',
		FIANZA: '51',
		AVAL_BANCARIO: '52',
		JUSTIFICANTE_INGRESOS: '53',
		ALQUILER_CON_OPCION_A_COMPRA: '54'
	},
	DD_SAN_SANCION: {
		COD_EJERCE: 'EJERCE',
		COD_NO_EJERCE: 'NO_EJERCE'
	},
	COMBO_MOTIVO_CALIFICACION_NEGATIVA:{
 		OTROS: 'OTROS',
 		COD_OTROS: '21'
	},

 	COMBO_ESTADO_CALIFICACION_NEGATIVA:{
 		PENDIENTE: 'Pendiente',
 		SUBSANADO: 'Subsanado',
 		COD_PENDIENTE: '01',
 		COD_SUBSANADO: '02'

 	},
 	COMBO_ENTIDAD_FINANCIERA:{
 		BANKIA: '01',
 		OTRA_ENTIDAD: '07',
 		OTRA_ENTIDAD_CAIXA:'207'
 	},
 	DD_ETI_ESTADO_TITULO :{
		TRAMITACION: "01",
		INSCRITO: "02",
		IMPOSIBLE_INSCRIPCION: "03",
		DESCONOCIDO: "04",
		INMATRICULADOS: "05",
		SUBSANAR: "06",
		NULO: "07"
	},

	TIPOS_ESTADO_CIVIL:{
		SOLTERO: '01',
		CASADO: '02',
		DIVORCIADO: '03',
		VIUDO: '04'
	},

	TIPOS_REG_ECONOMICO_MATRIMONIAL:{
		GANANCIALES: '01',
		SEPARACION_DE_BIENES: '02',
		PARTICIPACION: '03'
	},

	TIPO_PERSONA: {
		FISICA: '1',
		JURIDICA: '2'
	},

	ESTADO_CIVIL: {
		CASADO: '02'
	},

	REGIMENES_MATRIMONIALES: {
		GANANCIALES: '01',
		SEPARACION_BIENES: '02',
		PARTICIPACION: '03'
	},

	TIPO_DOCUMENTO_IDENTIDAD: {
		DNI: '01',
		CIF: '02',
		TARJETA_DE_RESIDENTE_NIE: '03',
		PASAPORTE: '04',
		CIF_PAIS_EXTRANJERO: '05',
		DNI_PAIS_EXTRANJERO: '06',
		TJ_IDENTIFICACION_DIPLOMATICA: '07',
		MENOR: '08',
		OTROS_PERSONA_FISICA: '09',
		OTROS_PERSONA_JURIDICA: '10',
		IDENT_BANCO_DE_ESPAÑA: '11',
		NIF_PAIS_ORIGEN: '13',
		OTRO: '14',
		NIF: '15'
	},
	DD_REGIMEN_MATRIMONIAL:{
		COD_GANANCIALES:'1',
	 	COD_SEPARACION_BIENES:'2'
	},

	D_ESTADOS_CIVILES:{
	 	COD_CASADO	:'2'
	 },
	
	DD_MOTIVO_AUTORIZACION_TRAMITE: {
		COD_AUTORIZADO_ENTIDAD_CLIENTE: '01',
		COD_TRAMITACION_ANULADA_CORRECCION: '02',
		COD_OTROS: '03'
	},
	 
	DD_ESP_ESTADO_PRESENTACION:{
		PRESENTACION_EN_REGISTRO:'01',
		CALIFICADO_NEGATIVAMENTE:'02',
		INSCRITO:'03'
	},
	
	DD_CLASE_OFERTA:{
	PRINCIPAL:'01',
	DEPENDIENTE:'02',
	INDIVIDUAL:'03'
	},
	
	DD_TAL_TIPO_ALTA:{
	ALTA_AUTOMATICA:'AUT',
	MANUAL_ACTIVO_APARECIDO:'MAA',
	MANUAL_INCIDENCIA_PROCESO_AUTOMATICO:'MIA',
	MANUAL_DIVISION_HORIZONTAL:'MDH',
	MANUAL_AGRUPACIONES:'MAG'
	},
	
	DD_STA_SUBTIPO_TITULO_ACTIVO:{
	LEASING:'LEA',
	NOTARIAL_COMPRA:'NCC',
	EJECUCION_HIPOTECARIA:'EHC',
	NOTARIAL_LEASING:'NLE',
	NOTARIAL_RECOMPRA:'NRE'
	},
	
	DD_TIPO_RECARGO:{
	NO_EVITABLE:'NO_EVI'
	},

	DD_SINO:{
		NO:'0',
		SI:'1'
	},

	PVE_DOCUMENTONIF: {
		HAYA: 'A86744349'
	},
	
	DD_ESTADO_GEST_PLUVS: {
		EN_CURSO:'EN_CURSO',
		FINALIZADO:'FINALIZADO',
		RECHAZADO:'RECHAZADO'
	},
	
	CIF_PROPIETARIO: {
		OMEGA: 'B88203708'
	},

	DD_CDU_CESION_USO: {
		CARITAS:'01',
		CESION_GENERALITAT_CX:'02',
		OTRAS_OPERACIONES:'03',
		EN_TRAMITE_OTRAS_OPERACIONES:'04',
		NO_APLICA:'05'
	},

	TIPO_ALQUILER: {
		ORDINARIO : '01',
		CON_OPCION_COMPRA: '02',
		FONDO_SOCIAL: '03',
		ESPECIAL: '04',
		NO_DEFINIDO: '05',
		PAZ_SOCIAL: '06',
		CARITAS: '07',
		LEY_CATALANA: '08',
		ALQUILER_SOCIAL: '09',
		CESION_GENERALITAT_CX: '10',
		OTRAS_CORPORACIONES: '11'
	},
	COMITE_SANCIONADOR: {
		CODIGO_HAYA_REMAINING: '41',
		CODIGO_HAYA_APPLE: '42'
	},

	BTN: {
		CREAR_TRABAJO: 'BtnCrearTrabajo'
	},

	ESTADOS_TRABAJO: {
    	EN_CURSO : 'CUR',
    	RECHAZADO: 'REJ',
    	CANCELADO: 'CAN',
    	FINALIZADO: 'FIN',
    	SUBSANADO: 'SUB', 	
    	PDTE_CIERRE:'PCI',
    	CIERRE:'CIE',
    	SOLICITADO:'01',
    	ANULADO:'02',
    	RECHAZADO_COD:'03',
    	EN_TRAMITE:'04',
    	PDTE_PAGO:'05',
    	PAGADO:'06',
    	IMPOSIBLE_OBTENCION:'07',
    	FALLIDO:'08',
    	CON_CEE_PDTE_ETIQUETA:'09',
    	FINALIZADO_PDTE_VALIDACION:'10',
    	PDTE_CIERRE_ECONOMICO:'11',
    	FINALIZADO_COD:'12',
    	VALIDADO: '13',
    	PAGADO_CON_TARIFA_PLANA:'14'
    },
    
	ESTADOS_PREFACTURAS: {
		VALIDADO: 'Validada',
		PENDIENTE: 'Pendiente'
	},
	
	ESTADOS_ALBARANES: {
		VALIDADO: 'Validado',
		PENDIENTE: 'Pendiente'
    },
	
	PES_PESTANYAS: {
		DETALLE_ECONOMICO: 'DEC',
		FICHA: 'FIC'
	},

	TIPO_ELEMENTOS_GASTO:{
		CODIGO_ACTIVO: 'ACT',
		CODIGO_AGRUPACION: 'AGR',
		CODIGO_ACTIVO_GENERICO:  'GEN',
		CODIGO_PROMOCION: 'PRO',
		CODIGO_SIN_ACTIVOS: 'SIN'
	},
	

	ESTADO_ADMISION: {
		CODIGO_PENDIENTE_TITULO: 'PET',
		CODIGO_PENDIENTE_REVISION: 'PRT',
		CODIGO_PENDIENTE_SANEAMIENTO: 'PSR',
		CODIGO_SANEADO_REGISTRALMENTE: 'SAR'
	},
	
	SUBESTADO_ADMISION: {
		CODIGO_PENDIENTE_INSCRIPCION: 'PIN',
		CODIGO_INCIDENCIA_INSC: 'IIN',
		CODIGO_PENDIENTE_CARGAS: 'PCA',
		CODIGO_CONCURSO_ACREEDORES: 'CAC'

	},
	DD_TOB_TIPO_OBSERVACION: {
		STOCK: '01',
		POSESION: '02',
		INSCRIPCION: '03',
		CARGAS: '04',
		LLAVES: '05',
		SANEAMIENTO: '06',
		REVISION_TITULO: '07'
	},
	OBSERVACIONES_TAB_LAUNCH: {
		ACTIVO : 'activo',
		SANEAMIENTO: 'saneamiento',
		REVISION_TITULO: 'revisionTitulo'
	},
	
	APROBACION_COMITE: {
		SOLICITADO: 'SOL',
		APROBADO: 'APR',
		RECHAZADO: 'REC'
	},
	
	ESTADO_ADMISION: {
		CODIGO_PENDIENTE_TITULO: 'PET',
		CODIGO_PENDIENTE_REVISION: 'PRT',
		CODIGO_PENDIENTE_SANEAMIENTO: 'PSR',
		CODIGO_SANEADO_REGISTRALMENTE: 'SAR'
	},
	
	SUBESTADO_ADMISION: {
		CODIGO_PENDIENTE_INSCRIPCION: 'PIN',
		CODIGO_INCIDENCIA_INSC: 'IIN',
		CODIGO_PENDIENTE_CARGAS: 'PCA',
		CODIGO_CONCURSO_ACREEDORES: 'CAC'

	},
	DD_TOB_TIPO_OBSERVACION: {
		STOCK: '01',
		POSESION: '02',
		INSCRIPCION: '03',
		CARGAS: '04',
		LLAVES: '05',
		SANEAMIENTO: '06',
		REVISION_TITULO: '07'
	},
	OBSERVACIONES_TAB_LAUNCH: {
		ACTIVO : 'activo',
		SANEAMIENTO: 'saneamiento',
		REVISION_TITULO: 'revisionTitulo'
	},
	
	GRID_CALIDAD_DATO: {
		DATOSREGISTRALES: '01',
		DATOSREGISTRO: '02',
		DATFASE03: '03',
		DATFASE03DIRECCION: '04'
	},
	
	TIPO_RETENCION: {
		ANTES : 'ANT',
		DESPUES: 'DESP'
	},

	ESTADO_CONT_LISTAS:	{
		NO_SOLICITADO:'NS',
		PENDIENTE : 'PEND',
		NEGATIVO : 'NEG',
		FALSO_POSITIVO : 'FP',
		POSITIVO_REAL_APROBADO :'PRA',
		POSITIVO_REAL_DENEGADO : 'PRD'
	},

	SUBFASES_PUBLICACION: {
		COD_EXCLUIDO_CLIENTE : '14'
	},
	 ESTADOS_EXPEDIENTE_BC: {
	    	PT_SCORING: '007',
	    	CONTRAOFERTADO: '030'
	 },
	 ESTADO_VALIDACION_BC:{
		CODIGO_NO_ENVIADA: '01',
		CODIGO_PDTE_VALIDACION: '02',
		CODIGO_APROBADA_BC: '03',
		CODIGO_RECHAZADA_BC: '04',
		CODIGO_ANULADA: '05',
		CODIGO_APLAZADA: '06'
	 },
	 ESTADOS_RESERVA:{
 		CODIGO_PENDIENTE_FIRMA:'01',
		CODIGO_FIRMADA: '02',
		CODIGO_RESUELTA: '03',
		CODIGO_ANULADA: '04',
		CODIGO_PENDIENTE_DEVOLUCION: '05',
		CODIGO_RESUELTA_DEVUELTA: '06',
		CODIGO_RESUELTA_POSIBLE_REINTEGRO: '07',
		CODIGO_RESUELTA_REINTEGRADA: '08'
	 },
	 
	 RESPUESTA_COMPRADOR:{
 		CODIGO_AVAL:'AVA',
		CODIGO_DEPOSITO: 'DEP',
		CODIGO_SEGURO_RENTAS: 'SRT'
	 },
	 
	 TIPO_ARRAS:{
 		CODIGO_PENITENCIALES:'01',
		CODIGO_CONFIRMATORIAS: '02'
	 },
	 
	 RESCINSION_ARRAS:{
	 	COD_TITULO: '001',
	 	COD_POSESION: '002',
	 	COD_VPO: '003',
	 	COD_PROBLEMAS_TECNICOS: '004',
	 	COD_CARGAS: '005',
	 	COD_MOT_PERS_COMPRADOR: '006',
	 	COD_DISCREPANCIAS_REGISTRALES: '007',
	 	COD_ALQUILER: '008',
	 	COD_OTROS: '009'
	 },
	 
	 METODO_ATUALIZACION_RENTA:{
	 	COD_LIBRE: 'LIB',
	 	COD_PORCENTUAL: 'POR',
	 	COD_MERCADO: 'MER',
	 	COD_IPCMERCADO: 'IPM',
	 	COD_NINGUNO: 'NIN'
	 },

	ESTADO_DEPOSITO:{
	 	COD_PENDIENTE: 'PDT',
	 	COD_INGRESADO: 'ING',
	 	COD_DEVUELTO: 'DEV',
	 	COD_INCAUTADO: 'INC'
	 },
 	 TIPO_GRUPO_IMPUESTO:{
 		CODIGO_EXENTO:'10',
		CODIGO_GENERAL: '20',
		CODIGO_REDUCIDO:'30',
		CODIGO_SUPERREDUCIDO: '40',
		CODIGO_TASA_CERO: '50'
	 },
	 
	 TIPO_OFERTA_ALQUILER_NO_COMERCIAL:{
		CODIGO_RENOVACION : 'REN',
		CODIGO_SUBROGACION : 'SUB',
		CODIGO_ALQUILER_SOCIAL : 'ALS'
	 },
	 
	 TIPO_RESOLUCION_DUDAS: {
		APRUEBA: '01',
		RECHAZA: '02',
		DUDAS: '03'
	},
	
	SUBTIPO_OFERTA_ALQUILER_NO_COMERCIAL:{
		CODIGO_ALQUILER_SOCIAL_DACION: 'ZAD',
	    CODIGO_ALQUILER_SOCIAL_EJECUCION: 'ZAE',
	    CODIGO_OCUPA: 'ZAO',
	    CODIGO_NOVACIONES: 'ZAN',
	    CODIGO_RENOVACIONES: 'ZRE',
	    CODIGO_SUBROGACION_DACION: 'ZSD',
	    CODIGO_SUBROGACION_EJECUCION: 'ZSE'
	}
});
