package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.factory.AltaActivoTPFactoryApi;
import es.pfsgroup.plugin.rem.model.DtoAltaActivoThirdParty;
import es.pfsgroup.plugin.rem.service.AltaActivoThirdPartyService;

@Component
public class MSVAltaActivosTPProcesar extends AbstractMSVActualizador implements MSVLiberator{
	
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private AltaActivoTPFactoryApi altaActivoTPFactoryApi;
	
	public static final class COL_NUM{
		static final int FILA_CABECERA = 1;
		static final int DATOS_PRIMERA_FILA = 2;
		
		//lalves
		static final int NUM_ACTIVO_HAYA = 0;
		static final int COD_SUBCARTERA = 1;
		static final int COD_SUBTIPO_TITULO = 2;
		static final int NUM_ACTIVO_EXTERNO = 3;
		static final int COD_TIPO_ACTIVO = 4;
		static final int COD_SUBTIPO_ACTIVO = 5;
		static final int COD_ESTADO_FISICO = 6;
		static final int COD_USO_DOMINANTE = 7;
		static final int DESC_ACTIVO = 8;
		
		//Dirección
		static final int COD_TIPO_VIA = 9;
		static final int NOMBRE_VIA = 10;
		static final int NUM_VIA = 11;
		static final int ESCALERA = 12;
		static final int PLANTA = 13;
		static final int PUERTA = 14;
		static final int COD_PROVINCIA = 15;
		static final int COD_MUNICIPIO = 16;
		static final int COD_UNIDAD_MUNICIPIO = 17;
		static final int CODPOSTAL = 18;
		
		//Comercializacion
		static final int COD_DESTINO_COMER = 19;
		static final int COD_TIPO_ALQUILER = 20;
		
		//Inscripción
		static final int POBL_REGISTRO = 21;
		static final int NUM_REGISTRO = 22;
		static final int TOMO = 23;
		static final int LIBRO = 24;
		static final int FOLIO = 25;
		static final int FINCA = 26;
		static final int IDUFIR_CRU = 27;
		static final int SUPERFICIE_CONSTRUIDA_M2 = 28;
		static final int SUPERFICIE_UTIL_M2 = 29;
		static final int SUPERFICIE_REPERCUSION_EE_CC = 30;
		static final int PARCELA = 31; // (INCLUIDA OCUPADA EDIFICACION)
		static final int ES_INTEGRADO_DIV_HORIZONTAL = 32;
		
		//Titulo
		static final int NIF_PROPIETARIO = 33;
		static final int GRADO_PROPIEDAD = 34;
		static final int PERCENT_PROPIEDAD = 35;
		static final int PROP_ANTERIOR = 36;
		
		//
		static final int REF_CATASTRAL = 37;
		static final int VPO = 38;
		static final int CALIFICACION_CEE = 39;
		static final int CED_HABITABILIDAD = 40;
		
		//Información publicación
		static final int NIF_MEDIADOR = 41;
		static final int VIVIENDA_NUM_PLANTAS = 42;
		static final int VIVIENDA_NUM_BANYOS = 43;
		static final int VIVIENDA_NUM_ASEOS = 44;
		static final int VIVIENDA_NUM_DORMITORIOS = 45;
		static final int TRASTERO_ANEJO = 46;
		static final int GARAJE_ANEJO = 47;
		static final int ASCENSOR = 48;
		
		//Información precios
		static final int PRECIO_MINIMO = 49;
		static final int PRECIO_VENTA_WEB = 50;
		static final int VALOR_TASACION = 51;
		static final int FECHA_TASACION = 52;
		
		//Gestores del activo
		static final int GESTOR_COMERCIAL = 53;
		static final int SUPER_GESTOR_COMERCIAL = 54;
		static final int GESTOR_FORMALIZACION = 55;
		static final int SUPER_GESTOR_FORMALIZACION = 56;
		static final int GESTOR_ADMISION = 57;
		static final int GESTOR_ACTIVOS = 58;
		static final int GESTORIA_DE_FORMALIZACION= 59;
		
		//Datos relevantes admisión
		static final int FECHA_INSCRIPCION = 60;
		static final int FECHA_OBT_TITULO = 61;
		static final int FECHA_TOMA_POSESION = 62;
		static final int FECHA_LANZAMIENTO = 63;
		static final int OCUPADO = 64;
		static final int TIENE_TITULO = 65;
		static final int LLAVES = 66;
		static final int CARGAS = 67;
		
		//
		static final int TIPO_ACTIVO = 68;
		static final int FORMALIZACION = 69;
		
		//Datos propietarios
		static final int NOMBRE_PROPIETARIO = 70;
		static final int APELLIDO1_PROPIETARIO = 71;
		static final int APELLIDO2_PROPIETARIO = 72;
		static final int TIPO_PROPIETARIO = 73;
		static final int NIF_CIF_PROPIETARIO = 74;
	};
	
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ALTA_ACTIVOS_THIRD_PARTY;
	}
	
	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws Exception {
		
		// Carga los datos de activo de la Fila excel al DTO
		DtoAltaActivoThirdParty dtoAATP = new DtoAltaActivoThirdParty();
		dtoAATP = filaExcelToDtoAltaActivoThirdParty(exc, dtoAATP, fila);

		// Factoria de alta de activos
		// -------------------------------------------------

		AltaActivoThirdPartyService altaActivoThirdPartyService = altaActivoTPFactoryApi.getService(AltaActivoThirdPartyService.CODIGO_ALTA_ACTIVO_THIRD_PARTY);
		altaActivoThirdPartyService.procesarAlta(dtoAATP);
		return new ResultadoProcesarFila();
	}
	
	private DtoAltaActivoThirdParty filaExcelToDtoAltaActivoThirdParty (MSVHojaExcel exc,DtoAltaActivoThirdParty dtoAATP, int fila) throws IllegalArgumentException, IOException, ParseException
	{
	
		dtoAATP.setNumActivoHaya(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.NUM_ACTIVO_HAYA)));
		dtoAATP.setCodSubCartera(exc.dameCelda(fila, COL_NUM.COD_SUBCARTERA));
		dtoAATP.setSubtipoTituloCodigo(exc.dameCelda(fila, COL_NUM.COD_SUBTIPO_TITULO));
		dtoAATP.setNumActivoExterno(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.NUM_ACTIVO_EXTERNO)));
		dtoAATP.setTipoActivoCodigo(exc.dameCelda(fila, COL_NUM.COD_TIPO_ACTIVO));
		dtoAATP.setSubtipoActivoCodigo(exc.dameCelda(fila, COL_NUM.COD_SUBTIPO_ACTIVO));
		dtoAATP.setEstadoFisicoCodigo(exc.dameCelda(fila, COL_NUM.COD_ESTADO_FISICO));
		dtoAATP.setUsoDominanteCodigo(exc.dameCelda(fila, COL_NUM.COD_USO_DOMINANTE));
		dtoAATP.setDescripcionActivo(exc.dameCelda(fila, COL_NUM.DESC_ACTIVO));
		
		dtoAATP.setTipoViaCodigo(exc.dameCelda(fila, COL_NUM.COD_TIPO_VIA));
		dtoAATP.setNombreVia(exc.dameCelda(fila, COL_NUM.NOMBRE_VIA));
		dtoAATP.setNumVia(exc.dameCelda(fila, COL_NUM.NUM_VIA));
		dtoAATP.setEscalera(exc.dameCelda(fila, COL_NUM.ESCALERA));
		dtoAATP.setPlanta(exc.dameCelda(fila, COL_NUM.PLANTA));
		dtoAATP.setPuerta(exc.dameCelda(fila, COL_NUM.PUERTA));
		dtoAATP.setProvinciaCodigo(exc.dameCelda(fila, COL_NUM.COD_PROVINCIA));
		dtoAATP.setMunicipioCodigo(exc.dameCelda(fila, COL_NUM.COD_MUNICIPIO));
		dtoAATP.setUnidadMunicipioCodigo(exc.dameCelda(fila, COL_NUM.COD_UNIDAD_MUNICIPIO));
		dtoAATP.setCodigoPostal(exc.dameCelda(fila, COL_NUM.CODPOSTAL));
		
		dtoAATP.setDestinoComercialCodigo(exc.dameCelda(fila, COL_NUM.COD_DESTINO_COMER));
		dtoAATP.setTipoAlquilerCodigo(exc.dameCelda(fila, COL_NUM.COD_TIPO_ALQUILER));
		
		dtoAATP.setPoblacionRegistroCodigo(exc.dameCelda(fila, COL_NUM.POBL_REGISTRO));
		dtoAATP.setNumRegistro(exc.dameCelda(fila, COL_NUM.NUM_REGISTRO));
		dtoAATP.setTomoRegistro(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.TOMO)));
		dtoAATP.setLibroRegistro(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.LIBRO)));
		dtoAATP.setFolioRegistro(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.FOLIO)));
		dtoAATP.setFincaRegistro(exc.dameCelda(fila, COL_NUM.FINCA));
		dtoAATP.setIdufirCruRegistro(exc.dameCelda(fila, COL_NUM.IDUFIR_CRU));
		dtoAATP.setSuperficieConstruidaRegistro(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.SUPERFICIE_CONSTRUIDA_M2)));
		dtoAATP.setSuperficieUtilRegistro(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.SUPERFICIE_UTIL_M2)));
		dtoAATP.setSuperficieRepercusionEECCRegistro(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.SUPERFICIE_REPERCUSION_EE_CC)));
		dtoAATP.setParcelaRegistro(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.PARCELA)));
		dtoAATP.setEsIntegradoDivHorizontalRegistro(exc.dameCelda(fila, COL_NUM.ES_INTEGRADO_DIV_HORIZONTAL));
		
		dtoAATP.setNifPropietario(exc.dameCelda(fila, COL_NUM.NIF_PROPIETARIO));
		dtoAATP.setGradoPropiedadCodigo(exc.dameCelda(fila, COL_NUM.GRADO_PROPIEDAD));
		dtoAATP.setPercentParticipacionPropiedad(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.PERCENT_PROPIEDAD)));
		
		dtoAATP.setPropiedadAnterior(exc.dameCelda(fila, COL_NUM.PROP_ANTERIOR));
		dtoAATP.setReferenciaCatastral(exc.dameCelda(fila, COL_NUM.REF_CATASTRAL));
		dtoAATP.setEsVPO(exc.dameCelda(fila, COL_NUM.VPO));
		dtoAATP.setCalificacionCeeCodigo(exc.dameCelda(fila, COL_NUM.CALIFICACION_CEE));
		dtoAATP.setCedudaHabitabilidad(exc.dameCelda(fila, COL_NUM.CED_HABITABILIDAD));
		
		dtoAATP.setNifMediador(exc.dameCelda(fila, COL_NUM.NIF_MEDIADOR));
		dtoAATP.setNumPlantasVivienda(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_PLANTAS)));
		dtoAATP.setNumBanyosVivienda(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_BANYOS)));
		dtoAATP.setNumAseosVivienda(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_ASEOS)));
		dtoAATP.setNumDormitoriosVivienda(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_DORMITORIOS)));
		dtoAATP.setTrasteroAnejo(exc.dameCelda(fila, COL_NUM.TRASTERO_ANEJO));
		dtoAATP.setGarajeAnejo(exc.dameCelda(fila, COL_NUM.GARAJE_ANEJO));
		dtoAATP.setAscensor(exc.dameCelda(fila, COL_NUM.ASCENSOR));
		
		dtoAATP.setPrecioMinimo(this.obtenerDoubleExcel(exc.dameCelda(fila, COL_NUM.PRECIO_MINIMO)));
		dtoAATP.setPrecioVentaWeb(this.obtenerDoubleExcel(exc.dameCelda(fila, COL_NUM.PRECIO_VENTA_WEB)));
		dtoAATP.setValorTasacion(this.obtenerDoubleExcel(exc.dameCelda(fila, COL_NUM.VALOR_TASACION)));
		dtoAATP.setFechaTasacion(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.FECHA_TASACION)));
		
		dtoAATP.setGestorComercial(exc.dameCelda(fila, COL_NUM.GESTOR_COMERCIAL));
		dtoAATP.setSupervisorGestorComercial(exc.dameCelda(fila, COL_NUM.SUPER_GESTOR_COMERCIAL));
		dtoAATP.setGestorFormalizacion(exc.dameCelda(fila, COL_NUM.GESTOR_FORMALIZACION));
		dtoAATP.setSupervisorGestorFormalizacion(exc.dameCelda(fila, COL_NUM.SUPER_GESTOR_FORMALIZACION));
		dtoAATP.setGestorAdmision(exc.dameCelda(fila, COL_NUM.GESTOR_ADMISION));
		dtoAATP.setGestorActivos(exc.dameCelda(fila, COL_NUM.GESTOR_ACTIVOS));
		dtoAATP.setGestoriaDeFormalizacion(exc.dameCelda(fila, COL_NUM.GESTORIA_DE_FORMALIZACION));
		
		dtoAATP.setFechaInscripcion(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.FECHA_INSCRIPCION)));
		dtoAATP.setFechaObtencionTitulo(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.FECHA_OBT_TITULO)));
		dtoAATP.setFechaTomaPosesion(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.FECHA_TOMA_POSESION)));
		dtoAATP.setFechaLanzamiento(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.FECHA_LANZAMIENTO)));
		dtoAATP.setOcupado(exc.dameCelda(fila, COL_NUM.OCUPADO));
		dtoAATP.setTieneTitulo(exc.dameCelda(fila, COL_NUM.TIENE_TITULO));
		dtoAATP.setLlave(exc.dameCelda(fila, COL_NUM.LLAVES));
		dtoAATP.setCargas(exc.dameCelda(fila, COL_NUM.CARGAS));
		
		dtoAATP.setTipoActivo(exc.dameCelda(fila, COL_NUM.TIPO_ACTIVO));
		dtoAATP.setFormalizacion(exc.dameCelda(fila, COL_NUM.FORMALIZACION));
		
		dtoAATP.setNombrePropietario(exc.dameCelda(fila, COL_NUM.NOMBRE_PROPIETARIO));
		dtoAATP.setApellidoPropietario1(exc.dameCelda(fila, COL_NUM.APELLIDO1_PROPIETARIO));
		dtoAATP.setApellidoPropietario2(exc.dameCelda(fila, COL_NUM.APELLIDO2_PROPIETARIO));
		dtoAATP.setTipoPropietario(exc.dameCelda(fila, COL_NUM.TIPO_PROPIETARIO));
		dtoAATP.setNIFCIFPropietario(exc.dameCelda(fila, COL_NUM.NIF_CIF_PROPIETARIO));
			
		return dtoAATP;
	}
	
	
	private Long obtenerLongExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Long.valueOf(celdaExcel);
	}
	
	private Integer obtenerIntegerExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}else{
			if(celdaExcel.contains("%")){
				celdaExcel = celdaExcel.replace("%", "");
			}
		}

		return Integer.valueOf(celdaExcel);
	}
	
	private Double obtenerDoubleExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Double.valueOf(celdaExcel);
	}
	
	private Float obtenerFloatExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Float.parseFloat(celdaExcel);
	}
	
	private Boolean obtenerBooleanExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		if (celdaExcel.equalsIgnoreCase("s") || celdaExcel.equalsIgnoreCase("si")) {
			return true;
		} else {
			return false;
		}
	}
	
	private Date obtenerDateExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fecha = null;

		try {
			fecha = ft.parse(celdaExcel);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return fecha;
	}
	
	@Override
	public int getFilaInicial() {
		return COL_NUM.DATOS_PRIMERA_FILA;
	}
}
