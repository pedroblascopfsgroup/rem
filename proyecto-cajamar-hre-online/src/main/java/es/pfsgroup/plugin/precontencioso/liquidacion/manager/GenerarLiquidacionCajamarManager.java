package es.pfsgroup.plugin.precontencioso.liquidacion.manager;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.dao.BienDao;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectUtils;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarDocumentoApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.BienesVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.DatosPlantillaFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.recovery.geninformes.api.GENINFInformesApi;

@Service("GenerarDocumentoApi")
public class GenerarLiquidacionCajamarManager implements GenerarDocumentoApi {

	private static final String LOCCRD = "LOCCRD";
	private static final String TEXTO_LOGO = "TEXTO_LOGO";
	private static final String GEN_ENT_N = "GEN_ENT_N";
	private static final String NOMBRE_NOT_TELE = "NOMBRE_NOT_TELE";
	private static final String NOMNOT = "NOMNOT";
	private static final String LOCNOM = "LOCNOM";
	private static final String ADJUNTOSTELEGRAM = "ADJUNTOSTELEGRAM";
	private static final String NOMCRD = "NOMCRD";
	
	private static final Locale localeSpa = new java.util.Locale("es", "ES");
	protected static final SimpleDateFormat formatFecha = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY, localeSpa);

	@Autowired
	private ParametrizacionDao parametrizacionDao;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;

	@Autowired
	private GENINFInformesApi informesApi;

	@Autowired
	private List<DatosPlantillaFactory> datosPlantillaFactoryList;

	@Autowired(required = false)
	PrecontenciosoProjectUtils precontenciosoUtils;
	
	@Autowired
	private ProcedimientoManager procedimientoManager;

	@Autowired
    private BienDao bienDao;

	@Override
	public FileItem generarDocumento(Long idLiquidacion, Long idPlantilla) {
		DDTipoLiquidacionPCO tipoLiquidacion = (DDTipoLiquidacionPCO) diccionarioApi.dameValorDiccionario(DDTipoLiquidacionPCO.class, idPlantilla);
		String nombrePlantilla = tipoLiquidacion.getPlantilla();

		HashMap<String, Object> datosPlantilla = obtenerDatosParaPlantilla(idLiquidacion, tipoLiquidacion);

		FileItem ficheroLiquidacion;

		try {

			String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PLANTILLAS_LIQUIDACION).getValor();

			InputStream is = new FileInputStream(directorio + nombrePlantilla);
			ficheroLiquidacion = informesApi.generarEscritoConVariables(datosPlantilla, nombrePlantilla, is);

		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		} catch (Throwable e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		}

		return ficheroLiquidacion;
	}

	@Override
	public FileItem generarCertificadoSaldo(Long idLiquidacion, Long idPlantilla, String codigoPropietaria, String localidadFirma, String notario) {
		
		DDTipoLiquidacionPCO tipoLiquidacion = (DDTipoLiquidacionPCO) diccionarioApi.dameValorDiccionario(DDTipoLiquidacionPCO.class, idPlantilla);
		String nombrePlantilla = tipoLiquidacion.getPlantilla();

		HashMap<String, Object> datosPlantilla = obtenerDatosParaPlantilla(idLiquidacion, tipoLiquidacion);

		// Añadimos la variable localidad de Firma
		datosPlantilla.put(LOCCRD, localidadFirma);
		
		// Añadimos la variable nombre de la entidad y el texto de cabecera
		String nombreEntidad = "";
		String textoLogo = "";
		if (precontenciosoUtils != null) {
			nombreEntidad = precontenciosoUtils.obtenerNombrePorClave(codigoPropietaria);
			textoLogo = precontenciosoUtils.obtenerInfoPorClave(codigoPropietaria);
		}
		datosPlantilla.put(GEN_ENT_N, nombreEntidad);
		datosPlantilla.put(TEXTO_LOGO, textoLogo);
		if (Checks.esNulo(notario)) {
			datosPlantilla.put(NOMBRE_NOT_TELE, "[ Campo " + NOMBRE_NOT_TELE + " no disponible]");
		} else {
			datosPlantilla.put(NOMBRE_NOT_TELE, notario);
		}
		
		FileItem ficheroLiquidacion;
		try {
			String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PLANTILLAS_LIQUIDACION).getValor();
			InputStream is = new FileInputStream(directorio + nombrePlantilla);
			String rutaLogo = directorio + "logos/" + codigoPropietaria + ".jpg";
			ficheroLiquidacion = informesApi.generarEscritoConVariablesYLogo(datosPlantilla, nombrePlantilla, is, rutaLogo);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		} catch (Throwable e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		}

		return ficheroLiquidacion;
	}

	/**
	 * Se obtiene los datos para rellenar la plantilla en base al tipo de liquidacion y el identificador de la liquidacion
	 * 
	 * @param idLiquidacion id de la liquidacion de la que se quiere generar los datos para el informe
	 * @param tipoLiquidacion tipo de liquidacion
	 * @return
	 */
	private HashMap<String, Object> obtenerDatosParaPlantilla(Long idLiquidacion, DDTipoLiquidacionPCO tipoLiquidacion) {

		if (!Checks.esNulo(datosPlantillaFactoryList)) {
			for (DatosPlantillaFactory datosPlantilla : datosPlantillaFactoryList) {
				if (!Checks.esNulo(tipoLiquidacion) && !Checks.esNulo(datosPlantilla.codigoTipoLiquidacion()) )
				if (tipoLiquidacion.getCodigo().startsWith(datosPlantilla.codigoTipoLiquidacion())) {
					return datosPlantilla.obtenerDatos(idLiquidacion);
				}
			}
		}

		throw new RuntimeException("Error al obtenerDatosParaPlantilla: no hay implementaciones disponibles.");
	}

	@Override
	public FileItem generarInstanciaRegistro(Long idLiquidacion, Long idPlantilla, String codigoPropietaria, String localidadFirma) {
		
		DDTipoLiquidacionPCO tipoLiquidacion = (DDTipoLiquidacionPCO) diccionarioApi.dameValorDiccionario(DDTipoLiquidacionPCO.class, idPlantilla);
		String nombrePlantilla = tipoLiquidacion.getPlantilla();
	
		HashMap<String, Object> datosPlantilla = obtenerDatosParaPlantilla(idLiquidacion, tipoLiquidacion);
	
		// Añadimos la variable localidad de Firma
		datosPlantilla.put(LOCCRD, localidadFirma);
		
		// Añadimos la variable nombre de la entidad y el texto de cabecera
		String nombreEntidad = "";
		String textoLogo = "";
		if (precontenciosoUtils != null) {
			nombreEntidad = precontenciosoUtils.obtenerNombrePorClave(codigoPropietaria);
			textoLogo = precontenciosoUtils.obtenerInfoPorClave(codigoPropietaria);
		}
		datosPlantilla.put(GEN_ENT_N, nombreEntidad);
		datosPlantilla.put(TEXTO_LOGO, textoLogo);
		
		FileItem ficheroLiquidacion;
		try {
			String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PLANTILLAS_LIQUIDACION).getValor();
			InputStream is = new FileInputStream(directorio + nombrePlantilla);
			String rutaLogo = directorio + "logos/" + codigoPropietaria + ".jpg";
			ficheroLiquidacion = informesApi.generarEscritoConVariablesYLogo(datosPlantilla, nombrePlantilla, is, rutaLogo);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		} catch (Throwable e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		}
	
		return ficheroLiquidacion;
	}

	@Override
	public FileItem generarCartaNotario(Long idLiquidacion, String notario,
			String localidadNotario, String adjuntosAdicionales,
			String codigoPropietaria, String centro, String localidadFirma) {

		final String codigoPlantilla = "CARTA_NOTARIO";
		final String nombrePlantilla = codigoPlantilla + ".docx";
		DDTipoLiquidacionPCO tipoLiquidacion = new DDTipoLiquidacionPCO();
		tipoLiquidacion.setCodigo(codigoPlantilla);
		HashMap<String, Object> datosPlantilla = obtenerDatosParaPlantilla(idLiquidacion, tipoLiquidacion);
	
		// Añadimos la variable localidad de Firma
		datosPlantilla.put(LOCCRD, localidadFirma);
		
		// Añadimos la variable nombre de la entidad y el texto de cabecera
		String nombreEntidad = "";
		String textoLogo = "";
		if (precontenciosoUtils != null) {
			nombreEntidad = precontenciosoUtils.obtenerNombrePorClave(codigoPropietaria);
			textoLogo = precontenciosoUtils.obtenerInfoPorClave(codigoPropietaria);
		}
		datosPlantilla.put(GEN_ENT_N, nombreEntidad);
		datosPlantilla.put(TEXTO_LOGO, textoLogo);
		datosPlantilla.put(NOMNOT, notario);
		datosPlantilla.put(LOCNOM, localidadNotario);
		datosPlantilla.put(ADJUNTOSTELEGRAM, adjuntosAdicionales);
		datosPlantilla.put(NOMCRD, centro);
		
		FileItem ficheroLiquidacion;
		try {
			String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PLANTILLAS_LIQUIDACION).getValor();
			InputStream is = new FileInputStream(directorio + nombrePlantilla);
			String rutaLogo = directorio + "logos/" + codigoPropietaria + ".jpg";
			ficheroLiquidacion = informesApi.generarEscritoConVariablesYLogo(datosPlantilla, nombrePlantilla, is, rutaLogo);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		} catch (Throwable e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		}
	
		return ficheroLiquidacion;

	}

	private static final String NUMEXP="NUMEXP";
	private static final String DATOS_TITULAR_PRINCIPAL="DATOS_TITULAR_PRINCIPAL";
	private static final String LOCRP="LOCRP";
	private static final String NUMRP="NUMRP";
	private static final String FESC="FESC";
	private static final String NUMPRO="NUMPRO";
	private static final String DATOS_BIENES="DATOS_BIENES";
	private static final String FECHAHOY="FECHAHOY";
	
	@Override
	public FileItem generarDocumentoBienes(Long idProcedimiento,
			String idsBien, String localidad, String nombreNotario,
			String localidadNotario, String numProtocolo, String fechaEscritura, 
			String localidadRegProp, String numeroRegProp) {


		final String codigoPlantilla = "INSTANCIA_CAJAMAR";
		final String nombrePlantilla = codigoPlantilla + ".docx";
		HashMap<String, Object> datosPlantilla = obtenerDatosParaPlantillaProc(idProcedimiento, idsBien);
	
		// Añadimos la variables recibidas desde el popup
		datosPlantilla.put(LOCCRD, localidad);
		datosPlantilla.put(LOCRP, localidadRegProp);
		datosPlantilla.put(NUMRP, numeroRegProp);
		datosPlantilla.put(NOMNOT, nombreNotario);
		datosPlantilla.put(LOCNOM, localidadNotario);
		datosPlantilla.put(FESC, fechaEscritura);
		datosPlantilla.put(NUMPRO, numProtocolo);
		datosPlantilla.put(FECHAHOY, formateaFecha(new Date()));
		
		FileItem ficheroDocumento;
		try {
			String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PLANTILLAS_LIQUIDACION).getValor();
			InputStream is = new FileInputStream(directorio + nombrePlantilla);
			ficheroDocumento = informesApi.generarEscritoConVariables(datosPlantilla, nombrePlantilla, is);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		} catch (Throwable e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		}
	
		return ficheroDocumento;

	}
	
	private HashMap<String, Object> obtenerDatosParaPlantillaProc(
			Long idProcedimiento, String idsBien) {
		
		HashMap<String, Object> resultado = new HashMap<String, Object>();
		Contrato contrato = null;
		String datosTitular = "DATOS_TITULAR_PRINCIPAL_NO_INFORMADO";
		
		Procedimiento proc = procedimientoManager.getProcedimiento(idProcedimiento);
		if (!Checks.esNulo(proc)) {
			List<Contrato> contratos = new ArrayList<Contrato>(proc.getAsunto().getContratos());
			if (contratos.size()>0) {
				contrato = contratos.get(0);
			}
			if (!Checks.esNulo(contrato)) {
				resultado.put(NUMEXP, contrato.getDescripcion());
				if (!Checks.esNulo(contrato.getTitulares()) && (contrato.getTitulares().size()>0)) {
					try {
						datosTitular = contrato.getTitulares().get(0).getNom50();
						datosTitular = datosTitular + " DNI/CIF: ";
						datosTitular = datosTitular + contrato.getTitulares().get(0).getDocId();
					} catch (Exception e) {} 
				}
				resultado.put(DATOS_TITULAR_PRINCIPAL, datosTitular);
			} else {
				resultado.put(NUMEXP, "NUMEXP_NO_INFORMADO");
				resultado.put(DATOS_TITULAR_PRINCIPAL, datosTitular);
			}
			resultado.put(DATOS_BIENES, obtenerDatosBienes(idsBien));
		}
		return resultado;
	}

	private List<BienesVO> obtenerDatosBienes(String idsBien) {
		String[] arrBien = idsBien.split(",");
		List<BienesVO> resultado = new ArrayList<BienesVO>(); 
		for (int i = 0; i < arrBien.length; i++) {
			NMBBien bien = NMBBien.instanceOf(bienDao.get(Long.parseLong(arrBien[i])));
			resultado.add(mapeDatosRegistralesBien(bien));
		}
		return resultado;
	}

	private BienesVO mapeDatosRegistralesBien(NMBBien bien) {
		String municipio = bien.getDatosRegistralesActivo().getMunicipoLibro();
		if (Checks.esNulo(municipio)) {
			municipio = bien.getDatosRegistralesActivo().getLocalidad().getDescripcion();
		}
		return new BienesVO(bien.getDatosRegistralesActivo().getNumFinca(),
				municipio, bien.getDatosRegistralesActivo().getTomo(), 
				bien.getDatosRegistralesActivo().getLibro(), bien.getDatosRegistralesActivo().getFolio());
	}

	protected String formateaFecha(Date fecha) {
		return formatFecha.format(fecha);
	}

}
