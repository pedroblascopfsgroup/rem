package es.pfsgroup.recovery.tasacion;

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

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBValoracionesBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBPersonasBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.recovery.haya.bienes.manager.SolicitarTasacionWSApi;

public class SolicitarTasacionWS implements SolicitarTasacionWSApi {

	protected final Log logger = LogFactory.getLog(getClass());
	
	// Corresponde a la funcionalidad alta de solicitud
	private final static String ALTA_SOLICITUD = "1";
	
	private final static String FINALIDAD = "03";
	private final static String INCO = "N";
	private final static String TENC = "1";
	private final static String ADJU = "N";
	private final static String CKCA = "1";
	
	private Map<String, String> mapaTIMN;
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	@Transactional(readOnly = false)
	public boolean altaSolicitud(NMBBien bien, List<NMBPersonasBien> personasBien, List<NMBContratoBien> contratosBien, Long cuenta, String personaContacto, Long telefono, String observaciones) {
		
		logger.info("Inicio del método altaSolicitud");
		
		try {
			ObjectFactory objectFactory = new ObjectFactory();
			INPUT input = objectFactory.createINPUT();
			
			logger.info("OPCI: " + ALTA_SOLICITUD);
			input.setOPCION(ALTA_SOLICITUD);
			
			completaSolicitud(input, bien, personasBien, contratosBien, cuenta, personaContacto, telefono, observaciones);
			ejecutaServicio(input, bien);
			
			
		}
		catch(Exception e) {
			logger.error("Error en el método altaSolicitud: " + e.getMessage());
			return false;
		}
		
		logger.info("Fin del método altaSolicitud");
		
		return true;
	}

	private void ejecutaServicio(INPUT input, NMBBien bien) {
		SARECOVERYTASACION service = new SARECOVERYTASACION();
		SARECOVERYTASACIONType servicePort = service.getSARECOVERYTASACIONPort();
		OUTPUT output = servicePort.sARECOVERYTASACION(input);
		
		logger.info("CODERROR: " + output.getCODERROR());
		logger.info("TXTERROR: " + output.getTXTERROR());
		//logger.info("DESCESTADO: " + output.getDESCESTADO());  QUITADO: YA NO ESTA EN LA INTERFACE
		// TASA nuevas
		// IDTA nuevas 
		logger.info("ESTADO: " + output.getESTADO());
		logger.info("DOCSOLICITUD: " + output.getDOCSOLICITUD());	
		
		if(output.getESTADO().equals("1")) {
			logger.error("Error en la ejecución del WS de Alta Tasación: " + output.getCODERROR() + " - " + output.getTXTERROR());
		}
		else {
			guardarRespuesta(output, bien);
		}
	}

	private void guardarRespuesta(OUTPUT output, NMBBien bien) {
		List<NMBValoracionesBien> valoraciones = bien.getValoraciones();
		NMBValoracionesBienInfo valoracionActiva = bien.getValoracionActiva();
		NMBValoracionesBien nueva = new NMBValoracionesBien();
		if(valoracionActiva != null){
			for (NMBValoracionesBien val : valoraciones) {
				if (val.getId() == valoracionActiva.getId() ) 
					nueva = val;
					nueva.setCodigoNuita(new Integer(output.getDOCSOLICITUD()));
					nueva.setFechaSolicitudTasacion(new Date());
					Auditoria auditoria = Auditoria.getNewInstance();
					nueva.setAuditoria(auditoria);
					break;
	        }
		} else {
			nueva.setCodigoNuita(new Integer(output.getDOCSOLICITUD()));
			nueva.setBien(bien);
			Auditoria auditoria = Auditoria.getNewInstance();
			nueva.setAuditoria(auditoria);
		}
		valoraciones.add(nueva);
		bien.setValoraciones(valoraciones);
		genericDao.update(NMBBien.class, bien);	
	}

	private void completaSolicitud(INPUT input, NMBBien bien, List<NMBPersonasBien> personasBien, List<NMBContratoBien> contratosBien, Long cuenta, String personaContacto, Long telefono, String observaciones) {
		
		// Se selecciona el contrato que tiene mayor importe garantizado
		String numeroContrato = "";
		float importeGarantizado = 0;
		float secuenciaGarantia = 0; 
		
		for(NMBContratoBien contratoBien : contratosBien) {
			
			if(contratoBien.getContrato().getNroContrato() != null && contratoBien.getImporteGarantizado() != null && contratoBien.getImporteGarantizado() > importeGarantizado ) {
				numeroContrato = contratoBien.getContrato().getNroContrato();
				importeGarantizado = contratoBien.getImporteGarantizado();
				secuenciaGarantia = contratoBien.getSecuenciaGarantia();
			}
		}
		
		logger.info("NCTA: " + numeroContrato);
		input.setNCTA(numeroContrato);

		logger.info("NSEC: " + secuenciaGarantia);
		input.setNSECUENCIA(String.valueOf(secuenciaGarantia));
		
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
		
		logger.info("NPER: " + nPersona);
		
		String sPersona = "";
		if(nPersona != null) {
			sPersona = nPersona.toString();
		}
		
		input.setNPERSONA(StringUtils.substring(sPersona, 0, 10));
		
		logger.info("CTAC: " + cuenta);
		
		String sCuenta = "";
		if(cuenta != null) {
			sCuenta = cuenta.toString();
		}
		
		input.setCTAC(sCuenta);
		
		logger.info("FINA: " + FINALIDAD);
		input.setFINALIDAD(FINALIDAD);

		String codBien = null;
		if(bien.getTipoBien() != null) {
			codBien = bien.getTipoBien().getCodigo();
		}
		logger.info("BIEN: " + codBien);
		input.setTBIEN(codBien);

		logger.info("ESTA: " + null);
		input.setESTADOBIEN(null);

		logger.info("OCUP: " + null);
		input.setOCUPACIONBIEN(null);

		logger.info("SITU: " + null);
		input.setSITUACIONBIEN(null);
		
		String codTipoVia = null;
		if(bien.getLocalizacionActual() != null && bien.getLocalizacionActual().getTipoVia() != null) {
			codTipoVia = bien.getLocalizacionActual().getTipoVia().getCodigo();
		}
		
		logger.info("CODC: " + codTipoVia);
		input.setCODDIR(codTipoVia);
		
		String nombreVia = "";
		if(bien.getLocalizacionActual() != null && bien.getLocalizacionActual().getNombreVia() != null) {
			nombreVia = bien.getLocalizacionActual().getNombreVia();
		}
		logger.info("NOMC: " + nombreVia);
		//input.setNOMC(nombreVia);
		
		logger.info("NUMC: " + bien.getNumDomicilio());
		//input.setNUMC(bien.getNumDomicilio());
		
		String poblacion = "";
		if(bien.getLocalizacionActual() != null && bien.getLocalizacionActual().getPoblacion() != null) {
			poblacion = bien.getLocalizacionActual().getPoblacion();
		}
		
		logger.info("POBL: " + poblacion);
		input.setLOCALIDAD(StringUtils.substring(poblacion, 0, 30));

		logger.info("PROV: " + null);
		input.setPROVINCIA(null);

		String codPostal = "";
		if(bien.getLocalizacionActual() != null && bien.getLocalizacionActual().getCodPostal() != null && NumberUtils.isNumber(bien.getLocalizacionActual().getCodPostal())) {
			codPostal = bien.getLocalizacionActual().getCodPostal();
		}
		
		logger.info("CPOS: " + codPostal);
		input.setCODPOSTAL(StringUtils.substring(codPostal, 0, 6));

		String numFinca = "";
		if(bien.getLocalizacionActual() != null && bien.getLocalizacionActual().getNumeroDomicilio() != null) {
			numFinca = bien.getLocalizacionActual().getNumeroDomicilio();
		}
				
		logger.info("NFCA: " + numFinca);
		input.setNFINCAREG(StringUtils.substring(numFinca, 0, 10) );

		logger.info("FOLI: " + null);
		input.setFOLIO(null);

		logger.info("LBRO: " + null);
		input.setLIBRO(null);

		logger.info("TOMO: " + null);
		input.setTOMO(null);

		logger.info("PERS: " + personaContacto);
		input.setNOMBPERSCONT(personaContacto);

		String sTelefono = "";
		if(telefono != null) {
			sTelefono = telefono.toString();
		}
		logger.info("TLF1: " + sTelefono);
		input.setTLF1(sTelefono);

		logger.info("TLF2: " + null);
		input.setTLF2(null);
		
		logger.info("OBSE: " + null);
		//input.setOBSE(null);

		logger.info("NRPR: " + null);
		//input.setNRPR(null);
		
		logger.info("INSC: " + null);
		input.setINSCRIP(null);
		
		logger.info("CAUT: " + null);
		input.setCOMAUT(null);

		logger.info("IDTA: " + null);
		//input.setIDTA(null);
		
		logger.info("FECH: " + null);
		//input.setFECH(null);
		
		logger.info("SECU: " + null);
		//input.setSECU(null);
		
		logger.info("MODI: " + null);
		//input.setMODI(null);
		
		logger.info("OPER: " + null);
		//input.setOPER(null);
		
		logger.info("TASA: " + null);
		//input.setTASA(null);

		logger.info("INCO: " + INCO);
		input.setINCO(INCO);
		
		logger.info("TENC: " + TENC);
		input.setTIPOPER(TENC);
		
		logger.info("ADJU: " + ADJU);
		//input.setADJU(ADJU); 
		
		logger.info("IMPO: " + null);
		input.setIMPORIESGVIV(null);
		
		logger.info("PRET: " + null);
		//input.setPRET(null);
				
		String tinmu = null;
		if(bien.getTipoBien() != null) {
			tinmu = mapaTIMN.get(bien.getTipoBien().getCodigo());
		}		
		
		logger.info("TINMU: " + tinmu);
		input.setTINMU(tinmu);
		
		logger.info("OBSE2: " + observaciones);
		input.setOBSERV(observaciones);			

		logger.info("RINM: " + bien.getIdDireccion());
		//input.setRINM(bien.getIdDireccion());
		
		logger.info("CKCA: " + CKCA);
		input.setSOLICITANTE(CKCA);
		
		logger.info("NPCE: " + null);
		//input.setNPCE(null);
		
		logger.info("CTCE: " + null);
		//input.setCTCE(null);
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
