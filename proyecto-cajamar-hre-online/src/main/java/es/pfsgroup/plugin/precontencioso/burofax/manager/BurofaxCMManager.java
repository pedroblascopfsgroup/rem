package es.pfsgroup.plugin.precontencioso.burofax.manager;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.persona.model.PersonaManual;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContext;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectUtils;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxEnvioIntegracionPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDEstadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDResultadoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.DDTipoBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.dao.LiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.recovery.geninformes.GENINFInformesManager;

@Service
public class BurofaxCMManager implements BurofaxCMApi {

	private static final String INICIO_MARCA = "${";
	private static final String FIN_MARCA = "}";

	private static final String CABECERA_NOMBRE_PERSONA = "nombrePersona";
	private static final String CABECERA_DIRECCION1 = "direccion1";
	private static final String CABECERA_DIRECCION2 = "direccion2";

	private static final String ERROR_NO_EXISTE_VALOR = "[ERROR - No existe valor]";
	private static final String INICIO_NO_DISP = "[CAMPO ";
	private static final String FIN_NO_DISP = " NO DISPONIBLE]";	

	private static final String tipoIntervencion = "tipoIntervencion";
	private static final String CODIGO_DE_CONTRATO = "CODIGO_DE_CONTRATO";
	private static final String FECFORMALIZ = "FECFORMALIZ";
	private static final String GEN_ENT_N = "GEN_ENT_N";
	private static final String FECHA_CIERRE_LIQUIDACION = "FECHA_CIERRE_LIQUIDACION";
	private static final String CAPITALCER = "CAPITALCER";
	private static final String INTERESCER = "INTERESCER";
	private static final String DEMORACER = "DEMORACER";
	private static final String IMPCER = "IMPCER";
	private static final String LOCCRD = "LOCCRD";
	private static final String CAL_RUT_POLIZA = "CAL_RUT_POLIZA";
	private static final String IMPINTERESTELEG = "IMPINTERESTELEG";
	private static final String IMPCOMITELEG = "IMPCOMITELEG";
	private static final String nombreNotario = "nombreNotario";

	private static final String NOMBRE_PLANTILLA_BUROFAX = "plantillaBurofaxCM.docx";
	private static final String DIRECTORIO_PLANTILLAS_LIQUIDACION = "directorioPlantillasLiquidacion";
	private static final String DIRECTORIO_PDF_BUROFAX_PCO = "directorioPdfBurofaxPCO";
	private static final String DEVON_HOME = "DEVON_HOME";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private LiquidacionDao liquidacionDao; 

	@Autowired
	private ParametrizacionDao parametrizacionDao;

	@Autowired(required = false)
	private PrecontenciosoProjectUtils precontenciosoUtils;
	
	@Autowired
	private PrecontenciosoProjectContext precontenciosoContext;
	
	@Autowired
	private GENINFInformesManager informesManager;

	private final Log logger = LogFactory.getLog(getClass());

	private static final Locale localeSpa = new java.util.Locale("es", "ES");
	private static final SimpleDateFormat formatFecha = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY, localeSpa);
	private static final NumberFormat codigoPostalFormat = new DecimalFormat("00000");
	private static final NumberFormat currencyInstance = NumberFormat.getCurrencyInstance(localeSpa);
	
	@Override
	@Transactional(readOnly = false)
	public List<EnvioBurofaxPCO> configurarTipoBurofax(Long idTipoBurofax,
			String[] arrayIdDirecciones, String[] arrayIdBurofax,
			String[] arrayIdEnvios, Boolean manual) {
		
		List<EnvioBurofaxPCO> listaEnvioBurofax=new ArrayList<EnvioBurofaxPCO>(); 

		Filter borrado = genericDao.createFilter(FilterType.EQUALS, "borrado", false);
						
		try {
			for(int i=0;i<arrayIdDirecciones.length;i++){
				if(!Checks.esNulo(arrayIdDirecciones[i])){
					Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoBurofaxPCO.NO_NOTIFICADO);
					DDEstadoBurofaxPCO estadoBurofaxPCO=(DDEstadoBurofaxPCO) genericDao.get(DDEstadoBurofaxPCO.class,filtro1, borrado);
					
					Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoBurofaxPCO.ESTADO_PREPARADO);
					DDResultadoBurofaxPCO resultadoBurofaxPCO=(DDResultadoBurofaxPCO) genericDao.get(DDResultadoBurofaxPCO.class,filtro2, borrado);
					
					Filter filtro3 = genericDao.createFilter(FilterType.EQUALS, "id", idTipoBurofax);
						DDTipoBurofaxPCO tipoBurofax=(DDTipoBurofaxPCO) genericDao.get(DDTipoBurofaxPCO.class,filtro3, borrado);
					
					Filter filtro4 = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(arrayIdBurofax[i]));
						BurofaxPCO burofax=(BurofaxPCO) genericDao.get(BurofaxPCO.class,filtro4, borrado);
					
					Filter filtro5 = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(arrayIdDirecciones[i]));
						Direccion direccion=(Direccion) genericDao.get(Direccion.class,filtro5, borrado);
					
					burofax.setEstadoBurofax(estadoBurofaxPCO);
					
					EnvioBurofaxPCO envio=null;
					//Si id Envio Existe actualizamos el envio
					if(!Checks.esNulo(arrayIdEnvios) && !arrayIdEnvios[i].equals("-1")){
						Filter filtro6 = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(arrayIdEnvios[i]));
							envio=(EnvioBurofaxPCO) genericDao.get(EnvioBurofaxPCO.class,filtro6, borrado);
					}			
					//Si idEnvio=-1 Creamos un nuevo envio
					else {
						envio=new EnvioBurofaxPCO();	
					}
					//Comun
					envio.setBurofax(burofax);
					envio.setDireccion(direccion);
					envio.setTipoBurofax(tipoBurofax);	
					envio.setContenidoBurofax(tipoBurofax.getPlantilla());
					envio.setResultadoBurofax(resultadoBurofaxPCO);
					envio.setManual(manual);
					
					//Guardamos nuevo envio
					genericDao.save(EnvioBurofaxPCO.class,envio);
					listaEnvioBurofax.add(envio);
				}
			}	
		} catch(Exception e){
			logger.error("configurarTipoBurofax: " + e);
		}
		
		return listaEnvioBurofax;
	}

	@Override
	@Transactional(readOnly = false)
	public void guardarEnvioBurofax(Boolean certificado,
			List<EnvioBurofaxPCO> listaEnvioBurofaxPCO,
			String codigoPropietaria, String localidadFirma, String notario) {
		
		try{

			Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "codigo", DDResultadoBurofaxPCO.ESTADO_SOLICITADO);
			DDResultadoBurofaxPCO resultado=(DDResultadoBurofaxPCO) genericDao.get(DDResultadoBurofaxPCO.class,filtro1);
			
			for(EnvioBurofaxPCO envioBurofax : listaEnvioBurofaxPCO){
				
				String contenidoParseadoIntermedio = envioBurofax.getContenidoBurofax();
				
				envioBurofax.setResultadoBurofax(resultado);
				envioBurofax.setFechaSolicitud(new Date());
				HashMap<String, Object> mapeoVariables = obtenerMapeoVariables(envioBurofax, codigoPropietaria, localidadFirma, notario);
				
				String contenidoParseadoFinal = parseoFinalBurofax(contenidoParseadoIntermedio, mapeoVariables);
				
				envioBurofax.setContenidoBurofax(contenidoParseadoFinal);
				genericDao.save(EnvioBurofaxPCO.class, envioBurofax);
				
				BurofaxEnvioIntegracionPCO envioIntegracion=new BurofaxEnvioIntegracionPCO();
				envioIntegracion.setEnvioId(envioBurofax.getId());
				envioIntegracion.setBurofaxId(envioBurofax.getBurofax().getId());
				envioIntegracion.setDireccionId(envioBurofax.getDireccion().getId());
				
				envioIntegracion.setDireccion(envioBurofax.getDireccion().getDomicilio());
				if(!Checks.esNulo(envioBurofax.getBurofax().getContrato())){
					envioIntegracion.setContrato(envioBurofax.getBurofax().getContrato().getNroContrato());
				} else {
					envioIntegracion.setContrato(null);
				}
				envioIntegracion.setTipoBurofax(envioBurofax.getTipoBurofax().getDescripcion());
				envioIntegracion.setFechaSolicitud(new Date());
				envioIntegracion.setFechaEnvio(new Date());
				envioIntegracion.setFechaAcuse(new Date());
				envioIntegracion.setCertificado(certificado);
				
				envioIntegracion.setContenido(contenidoParseadoFinal);
				
				if(envioBurofax.getBurofax().isEsPersonaManual()){
					envioIntegracion.setPersonaManualId(envioBurofax.getBurofax().getDemandadoManual().getId());
					envioIntegracion.setCliente(envioBurofax.getBurofax().getDemandadoManual().getApellidoNombre());
					envioIntegracion.setEsPersonaManual(true);
				}else{
					envioIntegracion.setPersonaId(envioBurofax.getBurofax().getDemandado().getId());
					envioIntegracion.setCliente(envioBurofax.getBurofax().getDemandado().getApellidoNombre());
					envioIntegracion.setEsPersonaManual(false);
				}
				
				
				// Obtener nombre de fichero
				String nombreFichero = obtenerNombreFichero(envioBurofax.getTipoBurofax().getCodigo(), envioBurofax.getId());
				
				//Generar documento a partir de la plantilla y de los campos HTML cabecera y contenido
				HashMap<String, String> cabecera = new HashMap<String, String>();
				cabecera.put(CABECERA_NOMBRE_PERSONA, (String)mapeoVariables.get(CABECERA_NOMBRE_PERSONA));
				cabecera.put(CABECERA_DIRECCION1, (String)mapeoVariables.get(CABECERA_DIRECCION1));
				cabecera.put(CABECERA_DIRECCION2, (String)mapeoVariables.get(CABECERA_DIRECCION2));
				String nombreFicheroPdf = generarBurofaxPDF(envioBurofax, nombreFichero, cabecera).getFileName();
				
				envioIntegracion.setNombreFichero(nombreFicheroPdf);
				envioIntegracion.setIdAsunto(envioBurofax.getBurofax().getProcedimientoPCO().getProcedimiento().getAsunto().getId());
					
				genericDao.save(BurofaxEnvioIntegracionPCO.class, envioIntegracion);
			}
		} catch (Exception e) {
			logger.error("guardarEnvioBurofax: " + e);
		}

	}

	private HashMap<String, Object> obtenerMapeoVariables(EnvioBurofaxPCO envioBurofax, String codigoPropietaria, String localidadFirma, String notario) {
		
		HashMap<String, Object> mapaVariables=new HashMap<String, Object>();		

		BurofaxPCO burofax = envioBurofax.getBurofax();
		
		mapaVariables.put(CABECERA_NOMBRE_PERSONA, construyeNombre(burofax.isEsPersonaManual(), burofax.getDemandado(), burofax.getDemandadoManual()));
		mapaVariables.put(CABECERA_DIRECCION1, construyeDireccion1(envioBurofax.getDireccion()));
		mapaVariables.put(CABECERA_DIRECCION2, construyeDireccion2(envioBurofax.getDireccion()));

		Contrato contrato = null;
		try {
			contrato = burofax.getContrato();
		} catch (NullPointerException npe) {
			logger.error(npe.getMessage());
		}

		LiquidacionPCO liquidacion = null;
		if (!Checks.esNulo(contrato)) {
			try {
				liquidacion = liquidacionDao.getLiquidacionDelContrato(contrato.getId());
			} catch (Exception e) {
				logger.error("Error al obtener la liquidacion correspondiente al contrato: " + e.getMessage());
			}
		}
		
		if (!Checks.esNulo(contrato)) {
			if(!Checks.esNulo(contrato.getNroContratoFormat())){
				mapaVariables.put(CODIGO_DE_CONTRATO, contrato.getDescripcion());
			} else{
				mapaVariables.put(CODIGO_DE_CONTRATO, ERROR_NO_EXISTE_VALOR);
			}
		} else {
			mapaVariables.put(CODIGO_DE_CONTRATO, ERROR_NO_EXISTE_VALOR);
		}

		try {
			mapaVariables.put(tipoIntervencion, envioBurofax.getBurofax().getTipoIntervencion().getDescripcion());
		} catch (NullPointerException npe) {
			mapaVariables.put(tipoIntervencion, ERROR_NO_EXISTE_VALOR);
		}

		// FECFORMALIZ
		mapaVariables.put(FECFORMALIZ, obtenerFechaFormalizacion(contrato, FECFORMALIZ));

		// GEN_ENT_N
		String nombreEntidad = "";
		if (precontenciosoUtils != null) {
			nombreEntidad = precontenciosoUtils.obtenerNombrePorClave(codigoPropietaria);
		}
		mapaVariables.put(GEN_ENT_N, nombreEntidad);

		// FECHA_CIERRE_LIQUIDACION
		if(!Checks.esNulo(liquidacion) && !Checks.esNulo(liquidacion.getFechaCierre())){
			mapaVariables.put(FECHA_CIERRE_LIQUIDACION, formateaFecha(liquidacion.getFechaCierre()));
		} else {
			mapaVariables.put(FECHA_CIERRE_LIQUIDACION, noDisponible(FECHA_CIERRE_LIQUIDACION));
		}

		// CAPITALCER
		mapaVariables.put(CAPITALCER, obtenerImporteCapitalPendiente(liquidacion, CAPITALCER));

		// INTERESCER
		mapaVariables.put(INTERESCER, obtenerImporteInteresesRemuneratorios(liquidacion, INTERESCER));

		// DEMORACER
		mapaVariables.put(DEMORACER, obtenerImporteInteresesMoratorios(liquidacion, DEMORACER));

		// IMPCER
		mapaVariables.put(IMPCER, obtenerImporteLiquidacion(liquidacion, IMPCER));

		// LOCCRD
		mapaVariables.put(LOCCRD, localidadFirma);

		// CAL_RUT_POLIZA
		mapaVariables.put(CAL_RUT_POLIZA,obtenerImportePrestamo(liquidacion, CAL_RUT_POLIZA));

		// IMPINTERESTELEG
		mapaVariables.put(IMPINTERESTELEG, obtenerImporteIntereseCreditoDispuesto(liquidacion, IMPINTERESTELEG));

		// IMPCOMITELEG
		mapaVariables.put(IMPCOMITELEG, obtenerImporteComisionesPagadas(liquidacion, IMPCOMITELEG));

		// nombreNotario
		if(!Checks.esNulo(notario)){
			mapaVariables.put(nombreNotario, notario);
		} else {
			mapaVariables.put(nombreNotario, noDisponible(nombreNotario));
		}
		
		return mapaVariables;
	
	}

	private String construyeNombre(boolean esManual, Persona persona, PersonaManual pmanual) {
		
		String r = "";
		String nombre = (esManual ? pmanual.getNombre() : persona.getNombre());
		String ape1 = (esManual ? pmanual.getApellido1() : persona.getApellido1());
		String ape2 = (esManual ? pmanual.getApellido2() : persona.getApellido2());
		if (!Checks.esNulo(nombre)) {
			r += nombre.trim() + " ";
		}
		if (!Checks.esNulo(ape1)) {
			r += ape1.trim() + " ";
		}
		if (!Checks.esNulo(ape2)) {
			r += ape2.trim();
		}
		return r.trim().toUpperCase();

	}

	private String construyeDireccion1(Direccion dir) {
		
		String resultado = "";
		if (!Checks.esNulo(dir)) {
			if (!Checks.esNulo(dir.getTipoVia()) && !Checks.esNulo(dir.getTipoVia().getDescripcion())) {			
				resultado += dir.getTipoVia().getDescripcion().trim();
			}
			if (!Checks.esNulo(dir.getDomicilio())) {			
				resultado += " " + dir.getDomicilio().trim();
			}
			if (!Checks.esNulo(dir.getDomicilio_n())) {
				resultado += " " + dir.getDomicilio_n().trim();
			}
			if (!Checks.esNulo(dir.getPortal())) {
				resultado += " " + dir.getPortal().trim();
			}
			if (!Checks.esNulo(dir.getEscalera())) {
				resultado += " " + dir.getEscalera().trim();
			}
			if (!Checks.esNulo(dir.getPiso())) {
				resultado += " " + dir.getPiso().trim();
			}
			if (!Checks.esNulo(dir.getPuerta())) {
				resultado += " " + dir.getPuerta().trim();
			}
		}
		return resultado.trim().toUpperCase();
	}
	
	private String construyeDireccion2(Direccion dir) {
		String resultado = "";
		if (!Checks.esNulo(dir)) {
			if (!Checks.esNulo(dir.getCodigoPostal())) {
				resultado += codigoPostalFormat.format(dir.getCodigoPostal()) + " ";
			}
			if (!Checks.esNulo(dir.getLocalidad()) && !Checks.esNulo(dir.getLocalidad().getDescripcion())) {
				resultado += dir.getLocalidad().getDescripcion();
			} else if (!Checks.esNulo(dir.getMunicipio())) {
				resultado += dir.getMunicipio();
			}
		}
		return resultado.trim().toUpperCase();
	}
	
	private String obtenerFechaFormalizacion(Contrato contrato, String campo) {
		String resultado = "";
		if (!Checks.esNulo(contrato.getFechaCreacion())) {
			resultado = formateaFecha(contrato.getFechaCreacion());
		} else {
			logger.debug(campo + " es nulo");
			resultado = noDisponible(campo);
		}
		return resultado;
	}

	private String obtenerImporteCapitalPendiente(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo); 
		try {
			resultado = currencyInstance.format(liquidacion.getCapitalNoVencido());
		} catch (Exception e) {
			logger.debug(campo + " error: " + e.getMessage());
		}
		return resultado;
	}

	private String obtenerImporteInteresesRemuneratorios(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo); 
		try {
			resultado = currencyInstance.format(liquidacion.getInteresesOrdinarios());
		} catch (Exception e) {
			logger.debug(campo + " error: " + e.getMessage());
		}
		return resultado;
	}

	private String obtenerImporteInteresesMoratorios(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo); 
		try {
			resultado = currencyInstance.format(liquidacion.getInteresesDemora());
		} catch (Exception e) {
			logger.debug(campo + " error: " + e.getMessage());
		}
		return resultado;
	}

	private String obtenerImporteIntereseCreditoDispuesto(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo);
		if (!Checks.esNulo(liquidacion.getInteresesOrdinarios())) {
			resultado = currencyInstance.format( liquidacion.getInteresesOrdinarios());
		}
		return resultado;
	}
	
	private String obtenerImporteComisionesPagadas(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo);
		if (!Checks.esNulo(liquidacion.getComisiones())) {
			resultado = currencyInstance.format( liquidacion.getComisiones());
		}
		return resultado;
	}

	private String obtenerImporteLiquidacion(LiquidacionPCO liq, String nombreCampo) {
		String resultado = "";
		try {
			resultado = currencyInstance.format(liq.getTotal());
		} catch (Exception e) {
			resultado = noDisponible(nombreCampo);
		}
		return resultado;
	}

	private String obtenerImportePrestamo(LiquidacionPCO liquidacion, String campo) {
		String resultado = noDisponible(campo); 
		try {
			resultado = currencyInstance.format(liquidacion.getCapitalVencido().add(liquidacion.getCapitalNoVencido()));
		} catch (Exception e) {
			logger.debug(campo + " error: " + e.getMessage());
		}
		return resultado;
	}
	
	private String formateaFecha(Date fecha) {
		return formatFecha.format(fecha);
	}

	private String noDisponible(String campo) {
		logger.debug(campo + " no disponible"); 
		return INICIO_NO_DISP + campo + FIN_NO_DISP;
	}


	private String parseoFinalBurofax(String contenidoParseadoIntermedio,
			HashMap<String, Object> mapeoVariables) {

		String resultado = contenidoParseadoIntermedio;
		for (String key : mapeoVariables.keySet()) {
			if (mapeoVariables.get(key) != null) {
				resultado = resultado.replace(INICIO_MARCA + key + FIN_MARCA, mapeoVariables.get(key).toString());
			}
		}
		return resultado;
	}

	private String obtenerNombreFichero(String tipoBurofax, Long idEnvio) {
		if (tipoBurofax.length() > 15) {
			tipoBurofax = tipoBurofax.substring(0,15);
		}
		return tipoBurofax+String.format("%011d", idEnvio)+".docx";
	}
	
	private FileItem generarBurofaxPDF(EnvioBurofaxPCO envioBurofax, String nombreFichero, HashMap<String, String> cabecera) {
		
		FileItem archivoBurofax = null;
		try {
			archivoBurofax  = informesManager.generarEscritoConContenidoHTML(cabecera, envioBurofax.getContenidoBurofax(), nombreFichero, 
					obtenerPlantillaBurofax(NOMBRE_PLANTILLA_BUROFAX));
		} catch (Throwable e) {
			logger.error(e.getMessage());
		}
		
		// Transformar el archivo docx en PDF
		String directorio =  File.separator + System.getenv(DEVON_HOME); 
		try {
			directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PDF_BUROFAX_PCO).getValor();
		} catch (Exception e) {
			logger.info("No se puede recuperar el parámetro " + DIRECTORIO_PDF_BUROFAX_PCO + " :" + e.getMessage());
		}
		String nombreFicheroPdf = obtenerNombreFicheroPdf(nombreFichero);
		File archivoBurofaxPDF = informesManager.convertirAPdf(archivoBurofax, directorio + File.separator + nombreFicheroPdf);
		FileItem fi = new FileItem();
		fi.setFile(archivoBurofaxPDF);
		fi.setFileName(nombreFicheroPdf);
		fi.setContentType("application/pdf");
		fi.setLength(archivoBurofaxPDF.length());
		return fi;
	}

	private InputStream obtenerPlantillaBurofax(String tipoPlantilla) {

		String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PLANTILLAS_LIQUIDACION).getValor();

		String nombreFichero = "";
		if (!directorio.endsWith(File.separator)) {
			nombreFichero = directorio + File.separator + tipoPlantilla;
		} else {
			nombreFichero = directorio + tipoPlantilla;
		}

		InputStream is = null;
		try {
			is = new FileInputStream(nombreFichero);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		} catch (Throwable e) {
			e.printStackTrace();
			throw new BusinessOperationException(e);
		}
		return is;
	}

	private String obtenerNombreFicheroPdf(String nombreFichero) {
		return  nombreFichero.replaceAll("docx", "pdf");
	}

}
