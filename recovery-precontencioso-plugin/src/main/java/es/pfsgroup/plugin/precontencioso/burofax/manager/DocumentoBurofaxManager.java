package es.pfsgroup.plugin.precontencioso.burofax.manager;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.ContratoPersona;
import es.capgemini.pfs.contrato.model.DDTipoIntervencion;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.persona.model.PersonaManual;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.PrecontenciosoProjectContextImpl;
import es.pfsgroup.plugin.precontencioso.burofax.api.DocumentoBurofaxApi;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.documento.model.DocumentoPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.dao.LiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienEntidad;
import es.pfsgroup.recovery.geninformes.GENINFInformesManager;

@Service
public class DocumentoBurofaxManager implements DocumentoBurofaxApi {

	private static final String CABECERA_NOMBRE_PERSONA = "nombrePersona";
	private static final String CABECERA_DIRECCION1 = "direccion1";
	private static final String CABECERA_DIRECCION2 = "direccion2";
	private static final String CABECERA_DIRECCION3 = "direccion3";

	private static final String INICIO_MARCA = "${";
	private static final String FIN_MARCA = "}";
	private static final String BIENES_ENT = "bienesEnt";
	private static final String TITULAR_ORDEN_MENOR_CONTRATO = "TITULAR_ORDEN_MENOR_CONTRATO";
	private static final String NUM_CUENTA_ANTERIOR = "NUM_CUENTA_ANTERIOR";
	private static final String TOTAL_LIQUIDACION = "TOTAL_LIQUIDACION";
	private static final String FECHA_CIERRE_LIQUIDACION = "FECHA_CIERRE_LIQUIDACION";
	private static final String MOV_FECHA_POS_VIVA_VENCIDA = "MOV_FECHA_POS_VIVA_VENCIDA";
	private static final String CODIGO_DE_CONTRATO = "CODIGO_DE_CONTRATO";
	private static final String CODIGO_DE_CONTRATO_DE_17_DIGITOS = "CODIGO_DE_CONTRATO_DE_17_DIGITOS";
	private static final String TOTAL_LIQ = "totalLiq";
	private static final String FECHA_LIQUIDACION = "fechaLiquidacion";
	private static final String ENTIDAD_ORIGEN = "entidadOrigen";
	private static final String TIPO_INTERVENCION = "tipoIntervencion";
	private static final String FECHA_POSICION_VENCIDA = "fechaPosicionVencida";
	private static final String NUMERO_CONTRATO = "numeroContrato";
	private static final String ORIGEN_CONTRATO = "origenContrato";
	private static final String DOMICILIO = "domicilio";
	private static final String NOMBRE_FICHERO = "nombreFichero";
	private static final String APELLIDO2 = "apellido2";
	private static final String APELLIDO1 = "apellido1";
	private static final String NOMBRE = "nombre";
	private static final String SINNOMBRE = "SINNOMBRE";
	private static final String INICIO_CUERPO = "<br />";
	private static final String FIN_CUERPO = "";

	private static final String ERROR_NO_EXISTE_VALOR = "[ERROR - No existe valor]";

	private static final String DIRECTORIO_PLANTILLAS_LIQUIDACION = "directorioPlantillasLiquidacion";
	private static final String NOMBRE_PLANTILLA_BUROFAX = "plantillaBurofax.docx";
	private static final String NOMBRE_PLANTILLA_BUROFAX_BANKIA = "plantillaBurofaxBankia.docx";
	private static final String NOMBRE_PLANTILLA_BUROFAX_BFA = "plantillaBurofaxBFA.docx";

	private static final SimpleDateFormat fechaFormat = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY,MessageUtils.DEFAULT_LOCALE);
	private static final NumberFormat currencyInstance = NumberFormat.getCurrencyInstance(new Locale("es","ES"));

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	ProcedimientoManager procedimientoManager;
	
	@Autowired
	LiquidacionDao liquidacionDao; 
		
	@Autowired
	private ParametrizacionDao parametrizacionDao;

	@Autowired
	private GENINFInformesManager informesManager;

	@Override
	public HashMap<String, Object> obtenerMapeoVariables(EnvioBurofaxPCO envioBurofax) {
		
		HashMap<String, Object> mapaVariables=new HashMap<String, Object>();		

		Persona demandado = null;
		try {
			if(envioBurofax.getBurofax().isEsPersonaManual()){
				PersonaManual demandadoManual = envioBurofax.getBurofax().getDemandadoManual();
				demandado = new Persona();
				demandado.setNombre(demandadoManual.getNombre());
				demandado.setApellido1(demandadoManual.getApellido1());
				demandado.setApellido2(demandadoManual.getApellido2());
			}else{
				demandado = envioBurofax.getBurofax().getDemandado();
			}
			
		} catch (NullPointerException npe) {}
		
		String nombre = SINNOMBRE;
		String apellido1="";
		String apellido2="";
		String nombreFichero="";
		if (demandado != null) {
			if(!Checks.esNulo(demandado.getNombre())){
				nombre = demandado.getNombre();
			}
			if(!Checks.esNulo(demandado.getApellido1())){
				apellido1=demandado.getApellido1();
			}
			if(!Checks.esNulo(demandado.getApellido2())){
				apellido2=demandado.getApellido2();
			}
			if(!Checks.esNulo(demandado.getApellidoNombre())){
				nombreFichero=demandado.getApellidoNombre();
			}
		}
		mapaVariables.put(NOMBRE, nombre);
		mapaVariables.put(APELLIDO1, apellido1);
		mapaVariables.put(APELLIDO2, apellido2);
		mapaVariables.put(NOMBRE_FICHERO, nombreFichero);
		
		String domicilio = "";
		try {
			domicilio=envioBurofax.getDireccion().toString();
		} catch (NullPointerException npe) {}
		mapaVariables.put(DOMICILIO, domicilio);
		
		Contrato contrato = null;
		try {
			contrato = envioBurofax.getBurofax().getContrato();
		} catch (NullPointerException npe) {}
			
		try {
			mapaVariables.put(ORIGEN_CONTRATO,contrato.getAplicativoOrigen().getDescripcion());
		} catch (NullPointerException npe) {
			mapaVariables.put(ORIGEN_CONTRATO,ERROR_NO_EXISTE_VALOR);
		}

		try {
			mapaVariables.put(NUMERO_CONTRATO, contrato.getNroContratoFormat());
		} catch (NullPointerException npe) {
			mapaVariables.put(NUMERO_CONTRATO,ERROR_NO_EXISTE_VALOR);
		}

		try {
			mapaVariables.put(FECHA_POSICION_VENCIDA,fechaFormat.format(contrato.getFirstMovimiento().getFechaPosVencida()));
		} catch (NullPointerException npe) {
			mapaVariables.put(FECHA_POSICION_VENCIDA,ERROR_NO_EXISTE_VALOR);
		}

		try {
			mapaVariables.put(TIPO_INTERVENCION,envioBurofax.getBurofax().getTipoIntervencion().getDescripcion());
		} catch (NullPointerException npe) {
			mapaVariables.put(TIPO_INTERVENCION,ERROR_NO_EXISTE_VALOR);
		}

		try {
			mapaVariables.put(ENTIDAD_ORIGEN,contrato.getEntidadOrigen());
		} catch (NullPointerException npe) {
			mapaVariables.put(ENTIDAD_ORIGEN,ERROR_NO_EXISTE_VALOR);
		}
		
		Filter filtro = null;
		LiquidacionPCO liquidacion = null;
		try {
			filtro = genericDao.createFilter(FilterType.EQUALS, "contrato.id", contrato.getId());
			List<LiquidacionPCO> liquidaciones = genericDao.getList(LiquidacionPCO.class, filtro); ///Por si existe en algún caso mas de una
			if(!Checks.estaVacio(liquidaciones)){
				liquidacion = liquidaciones.get(0);
			}
			if(!Checks.esNulo(liquidacion) && !Checks.esNulo(liquidacion.getFechaConfirmacion())){
				mapaVariables.put(FECHA_LIQUIDACION,fechaFormat.format(liquidacion.getFechaConfirmacion()));
			} else {
				mapaVariables.put(FECHA_LIQUIDACION,ERROR_NO_EXISTE_VALOR);
			}
		} catch (NullPointerException npe) {		
			mapaVariables.put(FECHA_LIQUIDACION,ERROR_NO_EXISTE_VALOR);
		}
		
		if(!Checks.esNulo(liquidacion) && !Checks.esNulo(liquidacion.getTotal())){
			mapaVariables.put(TOTAL_LIQ,currencyInstance.format(liquidacion.getTotal()));
		} else {
			mapaVariables.put(TOTAL_LIQ,ERROR_NO_EXISTE_VALOR);
		}
		
		///Variables especificas BANKIA
		if (!Checks.esNulo(contrato)) {
			if(!Checks.esNulo(contrato.getNroContratoFormat())){
				mapaVariables.put(CODIGO_DE_CONTRATO, contrato.getDescripcion());
			} else{
				mapaVariables.put(CODIGO_DE_CONTRATO,ERROR_NO_EXISTE_VALOR);
			}
		} else {
			mapaVariables.put(CODIGO_DE_CONTRATO,ERROR_NO_EXISTE_VALOR);
		}
		
		if (!Checks.esNulo(contrato)) {
			if(!Checks.esNulo(contrato.getNroContratoFormat())){
				mapaVariables.put(CODIGO_DE_CONTRATO_DE_17_DIGITOS, contrato.getDescripcion());
			} else{
				mapaVariables.put(CODIGO_DE_CONTRATO_DE_17_DIGITOS,ERROR_NO_EXISTE_VALOR);
			}
		} else {
			mapaVariables.put(CODIGO_DE_CONTRATO_DE_17_DIGITOS,ERROR_NO_EXISTE_VALOR);
		}
		
		try {
			if (!Checks.esNulo(contrato)) {
				if(!Checks.esNulo(contrato.getMovimientos()) && !Checks.estaVacio(contrato.getMovimientos())){
					List<Movimiento> movimientos = contrato.getMovimientos();
					String valFechaPosVencida = ERROR_NO_EXISTE_VALOR;
					for (int i=movimientos.size() - 1; i>=0; i--){
						if (!Checks.esNulo(movimientos.get(i).getFechaPosVencida())) {
							valFechaPosVencida = fechaFormat.format(movimientos.get(i).getFechaPosVencida());	
							break;
						}
					}
					mapaVariables.put(MOV_FECHA_POS_VIVA_VENCIDA, valFechaPosVencida);	
				} else {
					mapaVariables.put(MOV_FECHA_POS_VIVA_VENCIDA,ERROR_NO_EXISTE_VALOR);
				}
			} else {
				mapaVariables.put(MOV_FECHA_POS_VIVA_VENCIDA,ERROR_NO_EXISTE_VALOR);
			}
		} catch (NullPointerException npe) {
			mapaVariables.put(MOV_FECHA_POS_VIVA_VENCIDA,ERROR_NO_EXISTE_VALOR);
		}
		LiquidacionPCO liquPCO = null;
		if (!Checks.esNulo(contrato)) {
			liquPCO = liquidacionDao.getLiquidacionDelContrato(contrato.getId());
		}
		
		if(!Checks.esNulo(liquPCO) && !Checks.esNulo(liquPCO.getFechaCierre())){
			mapaVariables.put(FECHA_CIERRE_LIQUIDACION,fechaFormat.format(liquPCO.getFechaCierre()));
		} else {
			mapaVariables.put(FECHA_CIERRE_LIQUIDACION,ERROR_NO_EXISTE_VALOR);
		}
		
		if(!Checks.esNulo(liquPCO) && (!Checks.esNulo(liquPCO.getTotal()) || !Checks.esNulo(liquPCO.getTotalOriginal()))){
			if(!Checks.esNulo(liquPCO.getTotal())) {
				mapaVariables.put(TOTAL_LIQUIDACION,currencyInstance.format(liquPCO.getTotal()));
			} else {
				mapaVariables.put(TOTAL_LIQUIDACION,currencyInstance.format(liquPCO.getTotalOriginal()));
			}
		} else{
			mapaVariables.put(TOTAL_LIQUIDACION,ERROR_NO_EXISTE_VALOR);
		}
				
		if(!Checks.esNulo(contrato) && !Checks.esNulo(contrato.getContratoAnterior()) && !contrato.getContratoAnterior().equals("0")){
			mapaVariables.put(NUM_CUENTA_ANTERIOR,contrato.getContratoAnterior());
		} else {
			mapaVariables.put(NUM_CUENTA_ANTERIOR,ERROR_NO_EXISTE_VALOR);
		}
				
		if(!Checks.esNulo(contrato) && !Checks.esNulo(contrato.getContratoPersonaOrdenado()) && 
				contrato.getContratoPersonaOrdenado().size()>0 ){
			ContratoPersona cntPers = contrato.getContratoPersonaOrdenado().get(0);
			mapaVariables.put(TITULAR_ORDEN_MENOR_CONTRATO,construyeNombre(cntPers.getPersona()));
		} else {
			mapaVariables.put(TITULAR_ORDEN_MENOR_CONTRATO,ERROR_NO_EXISTE_VALOR);
		}
		try {
			if(envioBurofax.getBurofax().getTipoIntervencion().getCodigo().equals(DDTipoIntervencion.CODIGO_TITULAR_REGISTRAL)){
				List<Bien> bienes = procedimientoManager.getBienesDeUnProcedimiento(envioBurofax.getBurofax().getProcedimientoPCO().getProcedimiento().getId());
				List<NMBBienEntidad> bienesNMBBienEntidad = new ArrayList<NMBBienEntidad>();
				for(Bien bien : bienes){
					NMBBien nmb = genericDao.get(NMBBien.class, genericDao.createFilter(FilterType.EQUALS, "id", bien.getId()));
					if(!Checks.esNulo(nmb.getBienEntidad())){
						bienesNMBBienEntidad.add(nmb.getBienEntidad());
					}
				}
				mapaVariables.put(BIENES_ENT,bienesNMBBienEntidad);
			} else {
				mapaVariables.put(BIENES_ENT,ERROR_NO_EXISTE_VALOR);
			}
		} catch (NullPointerException npe) {
			mapaVariables.put(BIENES_ENT,ERROR_NO_EXISTE_VALOR);
		}

		return mapaVariables;
	}

	@Override
	public String parseoFinalBurofax(String contenidoParseadoIntermedio,
			HashMap<String, Object> mapeoVariables) {

		String resultado = contenidoParseadoIntermedio;
		for (String key : mapeoVariables.keySet()) {
			if (mapeoVariables.get(key) != null) {
				resultado = resultado.replace(INICIO_MARCA + key + FIN_MARCA, mapeoVariables.get(key).toString());
			}
		}
		return resultado;
	}

	private String construyeNombre(Persona persona) {
	
		String r = "";
		if (!Checks.esNulo(persona.getNombre())) {
			r += persona.getNombre().trim() + " ";
		}
		if (!Checks.esNulo(persona.getApellido1())) {
			r += persona.getApellido1().trim() + " ";
		}
		if (!Checks.esNulo(persona.getApellido2())) {
			r += persona.getApellido2().trim();
		}
		return r.trim().toUpperCase();

	}

	private String construyeDireccion1(Direccion dir) {
		
		String resultado = "";
		if (!Checks.esNulo(dir.getTipoVia()) && !Checks.esNulo(dir.getTipoVia().getDescripcion())) {			
			resultado += dir.getTipoVia().getDescripcion().trim();
		}
		if (!Checks.esNulo(dir.getDomicilio())) {			
			resultado += " " + dir.getDomicilio().trim();
		}
		if (!Checks.esNulo(dir.getDomicilio_n())) {
			resultado += " " + dir.getDomicilio_n().trim();
		}
		return resultado.trim().toUpperCase();
	}
	
	private String construyeDireccion2(Direccion dir) {
		NumberFormat nf = new DecimalFormat("00000");
		String resultado = "";
		if (!Checks.esNulo(dir.getCodigoPostal())) {
			resultado += nf.format(dir.getCodigoPostal()) + " ";
		}
		if (!Checks.esNulo(dir.getLocalidad()) && !Checks.esNulo(dir.getLocalidad().getDescripcion())) {
			resultado += dir.getLocalidad().getDescripcion();
		} else if (!Checks.esNulo(dir.getMunicipio())) {
			resultado += dir.getMunicipio();
		}
		return resultado.trim().toUpperCase();
	}
	
	private String construyeDireccion3(Direccion dir) {
		String resultado = "";
		if (!Checks.esNulo(dir.getProvincia()) && !Checks.esNulo(dir.getProvincia().getDescripcion())) {
			resultado += " (" + dir.getProvincia().getDescripcion() + ")";
		}
		return resultado.trim().toUpperCase();
	}
	
	@Override
	public Map<String, String> obtenerCabecera(EnvioBurofaxPCO envioBurofax, String contexto) {

		Map<String, String> cabecera = new HashMap<String, String>();

		if (PrecontenciosoProjectContextImpl.RECOVERY_BANKIA.equals(contexto)) {
			cabecera.put(CABECERA_NOMBRE_PERSONA, construyeNombre(envioBurofax.getBurofax().getDemandado()));
			cabecera.put(CABECERA_DIRECCION1, construyeDireccion1(envioBurofax.getDireccion()));
			cabecera.put(CABECERA_DIRECCION2, construyeDireccion2(envioBurofax.getDireccion()));
			cabecera.put(CABECERA_DIRECCION3, construyeDireccion3(envioBurofax.getDireccion()));
		}
		return cabecera;
	}

	@Override
	public InputStream obtenerPlantillaBurofax(String proyectoRecovery, String operacionBFA) {

		String tipoPlantilla;
		if (!PrecontenciosoProjectContextImpl.RECOVERY_BANKIA.equals(proyectoRecovery)) {
			tipoPlantilla = NOMBRE_PLANTILLA_BUROFAX;
		} else {
			if ("S".equals(operacionBFA)) {
				tipoPlantilla = NOMBRE_PLANTILLA_BUROFAX_BFA;
			} else {
				tipoPlantilla = NOMBRE_PLANTILLA_BUROFAX_BANKIA;
			}
		}

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

	@Override
	public FileItem generarDocumentoBurofax(InputStream plantillaBurofax,
			String nombreFichero, Map<String, String> cabecera, String contenidoParseadoFinal) {
		
		FileItem documentoBurofax = null;
		try {
			documentoBurofax  = informesManager.generarEscritoConContenidoHTML(cabecera, contenidoParseadoFinal, nombreFichero, plantillaBurofax);
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return documentoBurofax;
		
	}

	@Override
	public File convertirAPdf(FileItem archivoBurofax, String nombreFicheroPdfSalida) {

		return informesManager.convertirAPdf(archivoBurofax, nombreFicheroPdfSalida);

	}

	@Override
	public String obtenerNombreFicheroPdf(String nombreFichero) {
		
		return  nombreFichero.replaceAll("docx", "pdf");
	}

	
	public String replaceVariablesGeneracionBurofax(Long idPcoBurofax, String textoBuro, DocumentoPCO doc){
		
		BurofaxPCO burofax=(BurofaxPCO) genericDao.get(BurofaxPCO.class,genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(idPcoBurofax)));
		
		String conCuentaAnterior = "";
		String tipoIntervencion = "";
		String aNombreDe = "";
		String listaBienes = "";
		String notario = "";
		String localidadNotario = "";
		String protocolo = "";;
		String diaEscritura = "";
		String mesEscritura = "";
		String anyoEscritura = "";
		String fechaEscritura = "";
		
		if(!Checks.esNulo(doc)){
			notario = doc.getNotario();
			protocolo = doc.getProtocolo();
			if(!Checks.esNulo(doc.getProvinciaNotario())){
				localidadNotario = doc.getProvinciaNotario().getDescripcion();
			}
			if(!Checks.esNulo(doc.getFechaEscritura())){
				SimpleDateFormat df = new SimpleDateFormat("dd");
				diaEscritura = df.format(doc.getFechaEscritura());
				df = new SimpleDateFormat("yyyy");
				anyoEscritura = df.format(doc.getFechaEscritura());
				df = new SimpleDateFormat("MM");
				mesEscritura = df.format(doc.getFechaEscritura());
				df = new SimpleDateFormat("dd/MM/yyyy");
				fechaEscritura = df.format(doc.getFechaEscritura());
			}
			
		}
		
		Contrato contrato = null;
		try {
			contrato = burofax.getContrato();
		} catch (NullPointerException npe) {}
			
		if(!Checks.esNulo(contrato) && !Checks.esNulo(contrato.getContratoAnterior()) && !contrato.getContratoAnterior().equals("0")){
			conCuentaAnterior = "ANTERIORMENTE IDENTIFICADO CON EL NUM. ${NUM_CUENTA_ANTERIOR}";
		}
		
		if(burofax.getTipoIntervencion().getCodigo().equals(DDTipoIntervencion.CODIGO_TITULAR_REGISTRAL)){
			tipoIntervencion="TITULAR REGISTRAL";
		}else if(burofax.getTipoIntervencion().getTitular()){
			tipoIntervencion="TITULAR";
		}else{
			tipoIntervencion="FIADOR";
		}
		
		if(burofax.getTipoIntervencion().getAvalista()){
			aNombreDe = "A NOMBRE DE ${TITULAR_ORDEN_MENOR_CONTRATO} <br />";
		}
		
		List<Bien> bienes = procedimientoManager.getBienesDeUnProcedimiento(burofax.getProcedimientoPCO().getProcedimiento().getId());
		if(burofax.getTipoIntervencion().getCodigo().equals(DDTipoIntervencion.CODIGO_TITULAR_REGISTRAL) && bienes.size()>0){			
			listaBienes += "<br />";
			//listaBienes += "[#list bienesEnt as bienEntidad]";
			listaBienes += "<br />";
			for(Bien bien : bienes){
				NMBBienEntidad nmbe = genericDao.get(NMBBien.class, genericDao.createFilter(FilterType.EQUALS, "id", bien.getId())).getBienEntidad();
				
				listaBienes += "FINCA REGISTRAL NÚMERO ";
				
				if(!Checks.esNulo(nmbe) && !Checks.esNulo(nmbe.getNumFinca())){
					//listaBienes += "${bienEntidad.numFinca} ";
					listaBienes += nmbe.getNumFinca() + " ";
				}else{
					listaBienes += "[ERROR - No existe valor] ";
				}
				
				listaBienes		+= "DEL REGISTRO DE LA PROPIEDAD NÚMERO ";
				
				if(!Checks.esNulo(nmbe) && !Checks.esNulo(nmbe.getNumRegistro())){
					//listaBienes += "${bienEntidad.numRegistro} ";
					listaBienes += " " + nmbe.getNumRegistro();
				}else{
					listaBienes += "[ERROR - No existe valor] ";
				}
				
				listaBienes += "DE ";
				
				if(!Checks.esNulo(nmbe) && !Checks.esNulo(nmbe.getPoblacion())){
					//listaBienes += "${bienEntidad.poblacion} ";
					listaBienes += " " + nmbe.getPoblacion();
				}else{
					listaBienes += "[ERROR - No existe valor] ";
				}
				
				listaBienes += "<br />";		
			}
			//listaBienes += "[/#list]";
		}
		if(notario.trim().length()>1){
			textoBuro = textoBuro.replace("#NOTARIO_DOCUMENTO_VINCULADO#", notario);
		}
		if(protocolo.trim().length()>1){
			textoBuro = textoBuro.replace("#PROTOCOLO_DOCUMENTO_VINCULADO#", protocolo);
		}
		if(localidadNotario.trim().length()>1){
			textoBuro = textoBuro.replace("#LOCALIDAD_NOTARIO_DOCUMENTO_VINCULADO#", localidadNotario);
		}
		if(diaEscritura.trim().length()>1){
			textoBuro = textoBuro.replace("#DIA_ESCRITURA_DOCUMENTO_VINCULADO#", diaEscritura);
		}
		if(diaEscritura.trim().length()>1){
			textoBuro = textoBuro.replace("#ANYO_ESCRITURA_DOCUMENTO_VINCULADO#", anyoEscritura);
		}
		if(diaEscritura.trim().length()>1){
			textoBuro = textoBuro.replace("#MES_ESCRITURA_DOCUMENTO_VINCULADO#", mesEscritura);
		}
		if(fechaEscritura.trim().length()>1){
			textoBuro = textoBuro.replace("#FECHA_ESCRITURA_DOCUMENTO_VINCULADO#", fechaEscritura);
		}
		textoBuro = textoBuro.replace("#CON_CUENTA_ANTERIOR#", conCuentaAnterior);
		textoBuro = textoBuro.replace("#TIPO_INTERVENCIO#", tipoIntervencion);
		textoBuro = textoBuro.replace("#A_NOMBRE_DE#", aNombreDe);
		textoBuro = textoBuro.replace("#LISTA_BIENES#", listaBienes);
				
		
		return textoBuro;
	}
}
