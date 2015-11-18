package es.pfsgroup.plugin.precontencioso.burofax.manager;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import org.apache.poi.xwpf.converter.pdf.PdfConverter;
import org.apache.poi.xwpf.converter.pdf.PdfOptions;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
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
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.parametrizacion.dao.ParametrizacionDao;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.precontencioso.burofax.api.DocumentoBurofaxApi;
import es.pfsgroup.plugin.precontencioso.burofax.model.BurofaxPCO;
import es.pfsgroup.plugin.precontencioso.burofax.model.EnvioBurofaxPCO;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.GenerarLiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.dao.LiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.manager.LiquidacionManager;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienEntidad;
import es.pfsgroup.recovery.geninformes.GENINFInformesManager;

@Service
public class DocumentoBurofaxManager implements DocumentoBurofaxApi {

	private static final String INICIO_MARCA = "${";
	private static final String FIN_MARCA = "}";
	private static final String BIENES_ENT = "bienesEnt";
	private static final String TITULAR_ORDEN_MENOR_CONTRATO = "TITULAR_ORDEN_MENOR_CONTRATO";
	private static final String NUM_CUENTA_ANTERIOR = "NUM_CUENTA_ANTERIOR";
	private static final String TOTAL_LIQUIDACION = "TOTAL_LIQUIDACION";
	private static final String FECHA_CIERRE_LIQUIDACION = "FECHA_CIERRE_LIQUIDACION";
	private static final String MOV_FECHA_POS_VIVA_VENCIDA = "MOV_FECHA_POS_VIVA_VENCIDA";
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
			demandado = envioBurofax.getBurofax().getDemandado();
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
			liquidacion = genericDao.get(LiquidacionPCO.class, filtro);
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
				mapaVariables.put(CODIGO_DE_CONTRATO_DE_17_DIGITOS, contrato.getNroContratoFormat());
			} else{
				mapaVariables.put(CODIGO_DE_CONTRATO_DE_17_DIGITOS,ERROR_NO_EXISTE_VALOR);
			}
		} else {
			mapaVariables.put(CODIGO_DE_CONTRATO_DE_17_DIGITOS,ERROR_NO_EXISTE_VALOR);
		}
		
		try {
			if (!Checks.esNulo(contrato)) {
				if(!Checks.esNulo(contrato.getMovimientos())){
					List<Movimiento> movimientos = contrato.getMovimientos(); 
					if(movimientos.size()>0 && !Checks.esNulo(movimientos.get(movimientos.size() - 1).getFechaPosVencida())){
						mapaVariables.put(MOV_FECHA_POS_VIVA_VENCIDA, fechaFormat.format(movimientos.get(movimientos.size() - 1).getFechaPosVencida()));	
					} else {
						mapaVariables.put(MOV_FECHA_POS_VIVA_VENCIDA,ERROR_NO_EXISTE_VALOR);
					}
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
			mapaVariables.put(TITULAR_ORDEN_MENOR_CONTRATO,cntPers.getPersona().getNombre()+" "+cntPers.getPersona().getApellido1()+" "+cntPers.getPersona().getApellido2());
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
		return INICIO_CUERPO+resultado+FIN_CUERPO;
	}

	@Override
	public String obtenerCabecera(HashMap<String, Object> mapeoVariables) {

		String cabecera = "<table style='font-size:12px'>"
				+ "<tr>"
				+ "<td width='45%' style='border:1px solid black'>BANKIA S.A<br />PASEO DE LA CASTELLANA, 189<br />28046 Madrid</td>"
				+ "<td width='10%' style='border-style: hidden'></td>"
				+ "<td width='45%' style='border:1px solid black'>" 
				+ mapeoVariables.get(NOMBRE) 
				+ " "+ mapeoVariables.get(APELLIDO1) 
				+ " "+ mapeoVariables.get(APELLIDO1) 
				+ "<br/>"+ mapeoVariables.get(DOMICILIO) 
				+ "</td>"
				+ "</tr>"
				+ "</table><br />";
		
		return cabecera;
	}

	@Override
	public InputStream obtenerPlantillaBurofax() {

		String directorio = parametrizacionDao.buscarParametroPorNombre(DIRECTORIO_PLANTILLAS_LIQUIDACION).getValor();

		String nombreFichero = "";
		if (!directorio.endsWith(File.separator)) {
			nombreFichero = directorio + File.separator + NOMBRE_PLANTILLA_BUROFAX;
		} else {
			nombreFichero = directorio + NOMBRE_PLANTILLA_BUROFAX;
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
			String nombreFichero, String cabecera, String contenidoParseadoFinal) {
		
		FileItem documentoBurofax = null;
		try {
			documentoBurofax  = informesManager.generarEscritoConContenidoHTML(cabecera, contenidoParseadoFinal, nombreFichero,plantillaBurofax);
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

	
	public String replaceVariablesGeneracionBurofax(Long idPcoBurofax, String textoBuro){
		
		BurofaxPCO burofax=(BurofaxPCO) genericDao.get(BurofaxPCO.class,genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(idPcoBurofax)));
		
		String conCuentaAnterior = "";
		String tipoIntervencion = "";
		String aNombreDe = "";
		String listaBienes = "";
		
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
		
		textoBuro = textoBuro.replace("#CON_CUENTA_ANTERIOR#", conCuentaAnterior);
		textoBuro = textoBuro.replace("#TIPO_INTERVENCIO#", tipoIntervencion);
		textoBuro = textoBuro.replace("#A_NOMBRE_DE#", aNombreDe);
		textoBuro = textoBuro.replace("#LISTA_BIENES#", listaBienes);
				
		
		return textoBuro;
	}
}
