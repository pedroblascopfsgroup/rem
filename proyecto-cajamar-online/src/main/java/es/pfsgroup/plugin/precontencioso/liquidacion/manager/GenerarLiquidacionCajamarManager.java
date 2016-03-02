package es.pfsgroup.plugin.precontencioso.liquidacion.manager;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectUtils;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarDocumentoApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.DatosPlantillaFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.DDTipoLiquidacionPCO;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
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
	
}
