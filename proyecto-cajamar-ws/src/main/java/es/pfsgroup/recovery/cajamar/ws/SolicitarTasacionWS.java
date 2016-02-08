package es.pfsgroup.recovery.cajamar.ws;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.cajamar.ws.S_A_RECOVERY_TASACION.INPUT;
import org.cajamar.ws.S_A_RECOVERY_TASACION.OUTPUT;
import org.cajamar.ws.S_A_RECOVERY_TASACION.ObjectFactory;
import org.cajamar.ws.S_A_RECOVERY_TASACION.SARECOVERYTASACION;
import org.cajamar.ws.S_A_RECOVERY_TASACION.SARECOVERYTASACIONType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import javax.xml.namespace.QName;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBValoracionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDTasadora;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBPersonasBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.recovery.cajamar.serviciosonline.SolicitarTasacionWSApi;

public class SolicitarTasacionWS extends BaseWS implements SolicitarTasacionWSApi {

	private static final String WEB_SERVICE_NAME = "S_A_RECOVERY_TASACION";

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Override
	public String getWSName() {
		return WEB_SERVICE_NAME;
	}	
	
	// Corresponde a la funcionalidad alta de solicitud
	private final static String ALTA_SOLICITUD = "1";
	
	private final static String FINALIDAD = "03";
	private final static String INCO = "N";
	private final static String TENC = "1";
	private final static String CKCA = "1";
	
	private Map<String, String> mapaTIMN;
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	@Transactional(readOnly = false)
	public boolean altaSolicitud(NMBBien bien, List<NMBPersonasBien> personasBien, List<NMBContratoBien> contratosBien, Long cuenta, String personaContacto, Long telefono, String observaciones) {
		
		logger.info("Inicio del método altaSolicitud");
		boolean resultado = true;
		
		try {
			ObjectFactory objectFactory = new ObjectFactory();
			INPUT input = objectFactory.createINPUT();
			
			logger.info("OPCI: " + ALTA_SOLICITUD);
			input.setOPCION(ALTA_SOLICITUD);
			
			completaSolicitud(input, bien, personasBien, contratosBien, cuenta, personaContacto, telefono, observaciones);
			resultado = ejecutaServicio(input, bien);			
		}
		catch(Exception e) {
			logger.error("Error en el método altaSolicitud: " + e.getMessage());
			resultado = false;
		}
		
		logger.info("Fin del método altaSolicitud");
		
		return resultado;
	}

	private boolean ejecutaServicio(INPUT input, NMBBien bien) throws MalformedURLException {
		
		String urlWSDL = getWSURL();
		String targetNamespace = getWSNamespace();
		String name = getWSName();
		
		logger.info("Invocando invocado al WS de tasación...");
		logger.info(String.format("LLamada [%s] [%s] [%s]", targetNamespace, name, urlWSDL));
		
		if(urlWSDL == null || targetNamespace == null || name == null) {
			logger.error("Error en la ejecución del WS de Alta Tasación: no se han configurado correctamente las propiedades para la llamada al WS");
			return false;
		}

		URL wsdlLocation = new URL(urlWSDL);
		QName qName = new QName(targetNamespace, name);
		
		SARECOVERYTASACION service = new SARECOVERYTASACION(wsdlLocation, qName);
		SARECOVERYTASACIONType servicePort = service.getSARECOVERYTASACIONPort();
		OUTPUT output = servicePort.sARECOVERYTASACION(input);

		logger.info("WS Solicitud de tasación invocado! Valores de respuesta:");
		logger.info(String.format("CODERROR: %s", output.getCODERROR()));
		logger.info(String.format("TXTERROR: %s", output.getTXTERROR()));
		logger.info(String.format("TASA: %s", output.getTASA()));
		logger.info(String.format("IDTA: %s", output.getIDTA()));
		logger.info(String.format("ESTADO: %s", output.getESTADO()));
		logger.info(String.format("DOCSOLICITUD: %s", output.getDOCSOLICITUD()));
		
		if(output.getESTADO().equals("1")) {
			logger.error(String.format("Error en la ejecución del WS de Alta Tasación: [%s] - [%s]", output.getCODERROR(), output.getTXTERROR()));
			return false;
		}
		else {
			guardarRespuesta(output, bien);
		}
		
		return true;
	}

	private void guardarRespuesta(OUTPUT output, NMBBien bien) {
		List<NMBValoracionesBien> valoraciones = bien.getValoraciones();
		NMBValoracionesBienInfo valoracionActiva = bien.getValoracionActiva();
		NMBValoracionesBien nueva = new NMBValoracionesBien();
		
		if(valoracionActiva != null){
			for (NMBValoracionesBien val : valoraciones) {
				if (val.getId() == valoracionActiva.getId() ) 
					nueva = val;
				
					nueva.setCodigoNuita(new Long(output.getIDTA()));
					nueva.setFechaSolicitudTasacion(new Date());
					Auditoria auditoria = Auditoria.getNewInstance();
					nueva.setAuditoria(auditoria);
					break;
	        }
		} else {
			nueva.setCodigoNuita(new Long(output.getIDTA()));
			nueva.setBien(bien);
			Auditoria auditoria = Auditoria.getNewInstance();
			nueva.setAuditoria(auditoria);
		}
		
		nueva.setFechaSolicitudTasacion(new Date());
		
		String codigoTasadora = output.getTASA();
		if(codigoTasadora != null) {
			Filter filtroTasadora = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTasadora);
			DDTasadora tasadora = genericDao.get(DDTasadora.class, filtroTasadora);
			nueva.setTasadora(tasadora);
		}
		
		valoraciones.add(nueva);
		
		bien.setValoraciones(valoraciones);
		genericDao.update(NMBBien.class, bien);		
	}

	private void completaSolicitud(INPUT input, NMBBien bien, List<NMBPersonasBien> personasBien, List<NMBContratoBien> contratosBien, Long cuenta, String personaContacto, Long telefono, String observaciones) {
		
		// Se selecciona el contrato que tiene mayor importe garantizado
		String numeroContrato = "";
		Float importeGarantizado = 0f;
		Integer secuenciaGarantia = 0; 
		
		for(NMBContratoBien contratoBien : contratosBien) {
			
			if(contratoBien.getContrato().getNroContrato() != null) {
			
				if(contratoBien.getImporteGarantizado() != null) {
					if(contratoBien.getImporteGarantizado() > importeGarantizado) {
						numeroContrato = contratoBien.getContrato().getNroContrato();
						importeGarantizado = contratoBien.getImporteGarantizado();
						secuenciaGarantia = contratoBien.getSecuenciaGarantia();
					}
				}
				else {
					if("".equals(numeroContrato)) {
						numeroContrato = contratoBien.getContrato().getNroContrato();
						secuenciaGarantia = contratoBien.getSecuenciaGarantia();
					}
				}
			}
		}
		
		if(numeroContrato != null) {
			logger.info("NCTA: " + numeroContrato);
			input.setNCTA(numeroContrato);
		}
		else {
			logger.info("NCTA: ");
			input.setNCTA("");
		}

		if(secuenciaGarantia != null) {
			logger.info("NSECUENCIA: " + secuenciaGarantia);
			input.setNSECUENCIA(String.valueOf(secuenciaGarantia));
		}
		else {
			logger.info("NSECUENCIA: ");
			input.setNSECUENCIA("");
		}
		
		// Se selecciona la persona que tiene una mayor participación. En caso de igualdad, el primer registro
		Long nPersona = null;
		if(bien.getPersonas() != null) {
			
			float participacion = -1;
			for(NMBPersonasBien personaBien : personasBien) {
				if(personaBien.getParticipacion() != null && personaBien.getParticipacion() > participacion) {
					nPersona = personaBien.getPersona().getCodClienteEntidad();
					participacion = personaBien.getParticipacion();
				}
			}			
		}
		
		
		String sPersona = "";
		if(nPersona != null) {
			sPersona = nPersona.toString();
		}
		
		logger.info("NPERSONA: " + StringUtils.substring(sPersona, 0, 10));
		input.setNPERSONA(StringUtils.substring(sPersona, 0, 10));		
		
		String sCuenta = "";
		if(cuenta != null) {
			sCuenta = StringUtils.leftPad(cuenta.toString(), 20, "0");
		}
		
		logger.info("CTAC: " + sCuenta);
		input.setCTAC(sCuenta);
		
		logger.info("FINALIDAD: " + FINALIDAD);
		input.setFINALIDAD(FINALIDAD);

		String codBien = "";
		if(bien.getTipoBien() != null) {
			codBien = bien.getTipoBien().getCodigo();
		}
		
		if(codBien != null) {
			logger.info("TBIEN: " + codBien);
			input.setTBIEN(codBien);
		}
		else {
			logger.info("TBIEN: ");
			input.setTBIEN("");
		}

		logger.info("ESTADOBIEN: ");
		input.setESTADOBIEN("");

		logger.info("OCUPACIONBIEN: ");
		input.setOCUPACIONBIEN("");

		logger.info("SITUACIONBIEN: ");
		input.setSITUACIONBIEN("");
		
		if(bien.getIdDireccion() != null) {
			logger.info("RINM: " + bien.getIdDireccion());
			input.setCODDIR(bien.getIdDireccion());
		}
		else {
			logger.info("RINM: ");
			input.setCODDIR("");
		}
		
		String poblacion = "";
		if(bien.getLocalizacionActual() != null && bien.getLocalizacionActual().getPoblacion() != null) {
			poblacion = bien.getLocalizacionActual().getPoblacion();
		}
		
		logger.info("LOCALIDAD: " + StringUtils.substring(poblacion, 0, 30));
		input.setLOCALIDAD(StringUtils.substring(poblacion, 0, 30));

		logger.info("PROVINCIA: ");
		input.setPROVINCIA("");

		String codPostal = "";
		if(bien.getLocalizacionActual() != null && bien.getLocalizacionActual().getCodPostal() != null && NumberUtils.isNumber(bien.getLocalizacionActual().getCodPostal())) {
			codPostal = bien.getLocalizacionActual().getCodPostal();
		}
		
		logger.info("CODPOSTAL: " + StringUtils.substring(codPostal, 0, 6));
		input.setCODPOSTAL(StringUtils.substring(codPostal, 0, 6));

		String numFinca = "";
		if(bien.getLocalizacionActual() != null && bien.getLocalizacionActual().getNumeroDomicilio() != null) {
			numFinca = bien.getLocalizacionActual().getNumeroDomicilio();
		}
				
		logger.info("NFINCAREG: " + StringUtils.substring(numFinca, 0, 10));
		input.setNFINCAREG(StringUtils.substring(numFinca, 0, 10));

		logger.info("FOLIO: ");
		input.setFOLIO("");

		logger.info("LIBRO: ");
		input.setLIBRO("");

		logger.info("TOMO: ");
		input.setTOMO("");

		logger.info("NOMBPERSCONT: " + personaContacto);
		input.setNOMBPERSCONT(personaContacto);

		String sTelefono = "";
		if(telefono != null) {
			sTelefono = telefono.toString();
		}
		logger.info("TLF1: " + sTelefono);
		input.setTLF1(sTelefono);

		logger.info("TLF2: ");
		input.setTLF2("");
				
		logger.info("INSCRIP: ");
		input.setINSCRIP("");
		
		logger.info("COMAUT: ");
		input.setCOMAUT("");

		logger.info("INCO: " + INCO);
		input.setINCO(INCO);
		
		logger.info("TIPOPER: " + TENC);
		input.setTIPOPER(TENC);
		
		logger.info("IMPORIESGVIV: ");
		input.setIMPORIESGVIV("");
				
		String tinmu = "";
		if(bien.getTipoBien() != null) {
			tinmu = mapaTIMN.get(bien.getTipoBien().getCodigo());
		}		
		
		logger.info("TINMU: " + tinmu);
		input.setTINMU(tinmu);
		
		logger.info("OBSERV: " + observaciones);
		input.setOBSERV(observaciones);			

		logger.info("SOLICITANTE: " + CKCA);
		input.setSOLICITANTE(CKCA);

		logger.info("NRPROP: ");
		input.setNRPROP("");

		logger.info("TELFNCONTAS: ");
		input.setTELFNCONTAS("");

		logger.info("TENCRELA: ");
		input.setTENCRELA("");	
	}

	/**
	 * @return the mapaTIMN
	 */
	@Override
	public Map<String, String> getMapaTIMN() {
		return mapaTIMN;
	}

	/**
	 * @param mapaTIMN the mapaTIMN to set
	 */
	public void setMapaTIMN(Map<String, String> mapaTIMN) {
		this.mapaTIMN = mapaTIMN;
	}

}
