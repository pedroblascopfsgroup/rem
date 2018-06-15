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
import es.pfsgroup.plugin.rem.factory.AltaActivoFactoryApi;
import es.pfsgroup.plugin.rem.model.DtoAltaActivoFinanciero;
import es.pfsgroup.plugin.rem.service.AltaActivoService;

@Component
public class MSVAltaActivosProcesar extends AbstractMSVActualizador implements MSVLiberator {

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private AltaActivoFactoryApi altaActivoFactoryApi;

	// Posicion fija de Columnas excel, para cualquier referencia por posicion
	public static final class COL_NUM {
		static final int FILA_CABECERA = 2;
		static final int DATOS_PRIMERA_FILA = 3;

		static final int NUM_ACTIVO_HAYA = 0;
		static final int COD_CARTERA = 1;
		static final int COD_SUBTIPO_TITULO = 2;
		static final int NUM_ACTIVO_CARTERA = 3; // (UVEM, PRINEX, SAREB)
		static final int NUM_BIEN_RECOVERY = 4;
		static final int ID_ASUNTO_RECOVERY = 5;
		static final int COD_TIPO_ACTIVO = 6;
		static final int COD_SUBTIPO_ACTIVO = 7;
		static final int COD_ESTADO_FISICO = 8;
		static final int COD_USO_DOMINANTE = 9;
		static final int DESC_ACTIVO = 10;

		static final int COD_TIPO_VIA = 11;
		static final int NOMBRE_VIA = 12;
		static final int NUM_VIA = 13;
		static final int ESCALERA = 14;
		static final int PLANTA = 15;
		static final int PUERTA = 16;
		static final int COD_PROVINCIA = 17;
		static final int COD_MUNICIPIO = 18;
		static final int COD_UNIDAD_MUNICIPIO = 19;
		static final int CODPOSTAL = 20;

		static final int COD_DESTINO_COMER = 21;
		static final int COD_TIPO_ALQUILER = 22;

		static final int NUM_PRESTAMO = 23; // (MATRIZ, DIVIDIDO)
		static final int ESTADO_EXP_RIESGO = 24;
		static final int NIF_SOCIEDAD_ACREEDORA = 25;
		static final int CODIGO_SOCIEDAD_ACREEDORA = 26;
		static final int NOMBRE_SOCIEDAD_ACREEDORA = 27;
		static final int DIRECCION_SOCIEDAD_ACREEDORA = 28;
		static final int IMPORTE_DEUDA = 29;
		static final int ID_GARANTIA = 30;

		static final int POBL_REGISTRO = 31;
		static final int NUM_REGISTRO = 32;
		static final int TOMO = 33;
		static final int LIBRO = 34;
		static final int FOLIO = 35;
		static final int FINCA = 36;
		static final int IDUFIR_CRU = 37;
		static final int SUPERFICIE_CONSTRUIDA_M2 = 38;
		static final int SUPERFICIE_UTIL_M2 = 39;
		static final int SUPERFICIE_REPERCUSION_EE_CC = 40;
		static final int PARCELA = 41; // (INCLUIDA OCUPADA EDIFICACION)
		static final int ES_INTEGRADO_DIV_HORIZONTAL = 42;

		static final int NIF_PROPIETARIO = 43;
		static final int GRADO_PROPIEDAD = 44;
		static final int PERCENT_PROPIEDAD = 45;

		static final int REF_CATASTRAL = 46;
		static final int VPO = 47;
		static final int CALIFICACION_CEE = 48;

		static final int NIF_MEDIADOR = 49;
		static final int VIVIENDA_NUM_PLANTAS = 50;
		static final int VIVIENDA_NUM_BANYOS = 51;
		static final int VIVIENDA_NUM_ASEOS = 52;
		static final int VIVIENDA_NUM_DORMITORIOS = 53;
		static final int TRASTERO_ANEJO = 54;
		static final int GARAJE_ANEJO = 55;
		static final int ASCENSOR = 56;

		static final int PRECIO_MINIMO = 57;
		static final int PRECIO_VENTA_WEB = 58;
		static final int VALOR_TASACION = 59;
		static final int FECHA_TASACION = 60;
	};

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ALTA_ACTIVOS_FINANCIEROS;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws Exception {
		
		// Carga los datos de activo de la Fila excel al DTO
		DtoAltaActivoFinanciero dtoAAF = new DtoAltaActivoFinanciero();
		dtoAAF = filaExcelToDtoAltaActivoFinanciero(exc, dtoAAF, fila);

		// Factoria de alta de activos
		// -------------------------------------------------

		// FINANCIEROS
		AltaActivoService altaActivoService = altaActivoFactoryApi.getService(AltaActivoService.CODIGO_ALTA_ACTIVO_FINANCIERO);
		altaActivoService.procesarAlta(dtoAAF);
		return new ResultadoProcesarFila();
	}

	/**
	 * Este método establece cada columna de la hoja excel en la variable
	 * correspondiente del DTO.
	 * 
	 * @param exc
	 *            : Hoja excel.
	 * @param dtoAAF
	 *            : DTO para settear las columnas de la hoja excel.
	 * @param fila
	 *            : indica la fila actual para obtener datos de la hoja excel.
	 * @return Devuelve un objeto DtoAltaActivoFinanciero relleno con la
	 *         información de las columnas de la excel.
	 * @throws IllegalArgumentException
	 * @throws IOException
	 * @throws ParseException
	 */
	private DtoAltaActivoFinanciero filaExcelToDtoAltaActivoFinanciero(MSVHojaExcel exc, DtoAltaActivoFinanciero dtoAAF,
			int fila) throws IllegalArgumentException, IOException, ParseException {

		dtoAAF.setNumActivoHaya(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.NUM_ACTIVO_HAYA)));
		dtoAAF.setCarteraCodigo(exc.dameCelda(fila, COL_NUM.COD_CARTERA));
		dtoAAF.setSubtipoTituloCodigo(exc.dameCelda(fila, COL_NUM.COD_SUBTIPO_TITULO));
		dtoAAF.setNumActivoCartera(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.NUM_ACTIVO_CARTERA)));
		dtoAAF.setNumBienRecovery(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.NUM_BIEN_RECOVERY)));
		dtoAAF.setIdAsuntoRecovery(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.ID_ASUNTO_RECOVERY)));
		dtoAAF.setTipoActivoCodigo(exc.dameCelda(fila, COL_NUM.COD_TIPO_ACTIVO));
		dtoAAF.setSubtipoActivoCodigo(exc.dameCelda(fila, COL_NUM.COD_SUBTIPO_ACTIVO));
		dtoAAF.setEstadoFisicoCodigo(exc.dameCelda(fila, COL_NUM.COD_ESTADO_FISICO));
		dtoAAF.setUsoDominanteCodigo(exc.dameCelda(fila, COL_NUM.COD_USO_DOMINANTE));
		dtoAAF.setDescripcionActivo(exc.dameCelda(fila, COL_NUM.DESC_ACTIVO));

		dtoAAF.setTipoViaCodigo(exc.dameCelda(fila, COL_NUM.COD_TIPO_VIA));
		dtoAAF.setNombreVia(exc.dameCelda(fila, COL_NUM.NOMBRE_VIA));
		dtoAAF.setNumVia(exc.dameCelda(fila, COL_NUM.NUM_VIA));
		dtoAAF.setEscalera(exc.dameCelda(fila, COL_NUM.ESCALERA));
		dtoAAF.setPlanta(exc.dameCelda(fila, COL_NUM.PLANTA));
		dtoAAF.setPuerta(exc.dameCelda(fila, COL_NUM.PUERTA));
		dtoAAF.setProvinciaCodigo(exc.dameCelda(fila, COL_NUM.COD_PROVINCIA));
		dtoAAF.setMunicipioCodigo(exc.dameCelda(fila, COL_NUM.COD_MUNICIPIO));
		dtoAAF.setUnidadMunicipioCodigo(exc.dameCelda(fila, COL_NUM.COD_UNIDAD_MUNICIPIO));
		dtoAAF.setCodigoPostal(exc.dameCelda(fila, COL_NUM.CODPOSTAL));

		dtoAAF.setDestinoComercialCodigo(exc.dameCelda(fila, COL_NUM.COD_DESTINO_COMER));
		dtoAAF.setTipoAlquilerCodigo(exc.dameCelda(fila, COL_NUM.COD_TIPO_ALQUILER));

		dtoAAF.setNumPrestamo(exc.dameCelda(fila, COL_NUM.NUM_PRESTAMO));
		dtoAAF.setEstadoExpedienteRiesgoCodigo(exc.dameCelda(fila, COL_NUM.ESTADO_EXP_RIESGO));
		dtoAAF.setNifSociedadAcreedora(exc.dameCelda(fila, COL_NUM.NIF_SOCIEDAD_ACREEDORA));
		dtoAAF.setCodigoSociedadAcreedora(
				this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.CODIGO_SOCIEDAD_ACREEDORA)));
		dtoAAF.setNombreSociedadAcreedora(exc.dameCelda(fila, COL_NUM.NOMBRE_SOCIEDAD_ACREEDORA));
		dtoAAF.setDireccionSociedadAcreedora(exc.dameCelda(fila, COL_NUM.DIRECCION_SOCIEDAD_ACREEDORA));
		dtoAAF.setImporteDeuda(this.obtenerDoubleExcelImporte(exc.dameCelda(fila, COL_NUM.IMPORTE_DEUDA)));
		dtoAAF.setIdGarantia(this.obtenerLongExcel(exc.dameCelda(fila, COL_NUM.ID_GARANTIA)));

		dtoAAF.setPoblacionRegistroCodigo(exc.dameCelda(fila, COL_NUM.POBL_REGISTRO));
		dtoAAF.setNumRegistro(exc.dameCelda(fila, COL_NUM.NUM_REGISTRO));
		dtoAAF.setTomoRegistro(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.TOMO)));
		dtoAAF.setLibroRegistro(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.LIBRO)));
		dtoAAF.setFolioRegistro(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.FOLIO)));
		dtoAAF.setFincaRegistro(exc.dameCelda(fila, COL_NUM.FINCA));
		dtoAAF.setIdufirCruRegistro(exc.dameCelda(fila, COL_NUM.IDUFIR_CRU));
		dtoAAF.setSuperficieConstruidaRegistro(
				this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.SUPERFICIE_CONSTRUIDA_M2)));
		dtoAAF.setSuperficieUtilRegistro(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.SUPERFICIE_UTIL_M2)));
		dtoAAF.setSuperficieRepercusionEECCRegistro(
				this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.SUPERFICIE_REPERCUSION_EE_CC)));
		dtoAAF.setParcelaRegistro(this.obtenerFloatExcel(exc.dameCelda(fila, COL_NUM.PARCELA)));
		dtoAAF.setEsIntegradoDivHorizontalRegistro(
				this.obtenerBooleanExcel(exc.dameCelda(fila, COL_NUM.ES_INTEGRADO_DIV_HORIZONTAL)));

		dtoAAF.setNifPropietario(exc.dameCelda(fila, COL_NUM.NIF_PROPIETARIO));
		dtoAAF.setGradoPropiedadCodigo(exc.dameCelda(fila, COL_NUM.GRADO_PROPIEDAD));
		dtoAAF.setPercentParticipacionPropiedad(
				this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.PERCENT_PROPIEDAD)));

		dtoAAF.setReferenciaCatastral(exc.dameCelda(fila, COL_NUM.REF_CATASTRAL));
		dtoAAF.setEsVPO(this.obtenerBooleanExcel(exc.dameCelda(fila, COL_NUM.VPO)));
		dtoAAF.setCalificacionCeeCodigo(exc.dameCelda(fila, COL_NUM.CALIFICACION_CEE));

		dtoAAF.setNifMediador(exc.dameCelda(fila, COL_NUM.NIF_MEDIADOR));
		dtoAAF.setNumPlantasVivienda(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_PLANTAS)));
		dtoAAF.setNumBanyosVivienda(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_BANYOS)));
		dtoAAF.setNumAseosVivienda(this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_ASEOS)));
		dtoAAF.setNumDormitoriosVivienda(
				this.obtenerIntegerExcel(exc.dameCelda(fila, COL_NUM.VIVIENDA_NUM_DORMITORIOS)));
		dtoAAF.setTrasteroAnejo(this.obtenerBooleanExcel(exc.dameCelda(fila, COL_NUM.TRASTERO_ANEJO)));
		dtoAAF.setGarajeAnejo(this.obtenerBooleanExcel(exc.dameCelda(fila, COL_NUM.GARAJE_ANEJO)));
		dtoAAF.setAscensor(this.obtenerBooleanExcel(exc.dameCelda(fila, COL_NUM.ASCENSOR)));

		dtoAAF.setPrecioMinimo(this.obtenerDoubleExcelImporte(exc.dameCelda(fila, COL_NUM.PRECIO_MINIMO)));
		dtoAAF.setPrecioVentaWeb(this.obtenerDoubleExcelImporte(exc.dameCelda(fila, COL_NUM.PRECIO_VENTA_WEB)));
		dtoAAF.setValorTasacion(this.obtenerDoubleExcelImporte(exc.dameCelda(fila, COL_NUM.VALOR_TASACION)));
		dtoAAF.setFechaTasacion(this.obtenerDateExcel(exc.dameCelda(fila, COL_NUM.FECHA_TASACION)));

		return dtoAAF;
	}

	/**
	 * Este método devuelve un objeto Date regulado de la celda excel.
	 * 
	 * @param celdaExcel
	 *            : valor Date de la celda excel a analizar.
	 * @return Devuelve Null si la celda está vacía, o la fecha parseada al
	 *         objeto Date si contiene una fecha válida.
	 */
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

	/**
	 * Este método devuelve un objeto Boolean regulado de la celda excel.
	 * 
	 * @param celdaExcel
	 *            : valor Boolean de la celda excel a analizar.
	 * @return Devuelve Null si la celda está vacía, True si el String es S/SI o
	 *         False en cualquier otro caso.
	 */
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

	/**
	 * Este método devuelve un objeto Integer regulado de la celda excel.
	 * 
	 * @param celdaExcel
	 *            : valor Integer de la celda excel a analizar.
	 * @return Devuelve Null si la celda está vacía o un objeto de tipo Integer
	 *         con la conversión de la celda excel.
	 */
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

	/**
	 * Este método devuelve un objeto Double regulado de la celda excel.
	 * 
	 * @param celdaExcel
	 *            : valor Double de la celda excel a analizar.
	 * @return Devuelve Null si la celda está vacía o un objeto de tipo Double
	 *         con la conversión de la celda excel.
	 */
	private Double obtenerDoubleExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Double.valueOf(celdaExcel);
	}

	private Double obtenerDoubleExcelImporte(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		if (celdaExcel != null && !celdaExcel.isEmpty()) {
			if (celdaExcel.contains(",")) {
				celdaExcel = celdaExcel.replace(",", ".");
			}
		}

		return Double.valueOf(celdaExcel);
	}

	/**
	 * Este método devuelve un objeto Float regulado de la celda excel.
	 * 
	 * @param celdaExcel
	 *            : valor Float de la celda excel a analizar.
	 * @return Devuelve Null si la celda está vacía o un objeto de tipo Double
	 *         con la conversión de la celda excel.
	 */
	private Float obtenerFloatExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Float.parseFloat(celdaExcel);
	}

	/**
	 * Este método devuelve un objeto Long regulado de la celda excel.
	 * 
	 * @param celdaExcel
	 *            : valor Long de la celda excel a analizar.
	 * @return Devuelve Null si la celda está vacía o un objeto de tipo Long con
	 *         la conversión de la celda excel.
	 */
	private Long obtenerLongExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Long.valueOf(celdaExcel);
	}
	
	@Override
	public int getFilaInicial() {
		return 3;
	}

}
