package es.pfsgroup.recovery.integration.bpm.consumer;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.acuerdo.AcuerdoManager;
import es.capgemini.pfs.acuerdo.EXTAcuerdoManager;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.dto.DtoActuacionesAExplorar;
import es.capgemini.pfs.acuerdo.dto.DtoActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.dto.DtoAnalisisAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.DDResultadoAcuerdoActuacion;
import es.capgemini.pfs.acuerdo.model.DDTipoActuacionAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAyudaAcuerdo;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoManager;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.bienes.EXTBienesManager;
import es.pfsgroup.recovery.ext.impl.contrato.EXTContratoManager;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;
import es.pfsgroup.recovery.integration.bpm.payload.ActuacionesAExplorarPayload;
import es.pfsgroup.recovery.integration.bpm.payload.ActuacionesRealizadasPayload;
import es.pfsgroup.recovery.integration.bpm.payload.AcuerdoPayload;
import es.pfsgroup.recovery.integration.bpm.payload.TerminoAcuerdoPayload;

/**
 * 
 * Inicia el procedimiento si no existe sincronizado según el padre (que debe existir).
 * 
 * Tareas asociadas según el tipo de mensaje:
 * 
 * 	- Da de alta una tarea en la bd (PRC_PROCEDIMIENTO) e inicia el procedimiento que se pasa.
 *  - Cancela una tarea
 *  - Finaliza una tarea.
 * 
 * @author gonzalo
 *
 */
public class AcuerdoConsumer extends ConsumerAction<DataContainerPayload> {

	protected final Log logger = LogFactory.getLog(getClass());
	
	private final DiccionarioDeCodigos diccionarioCodigos;

	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private EXTAsuntoManager extAsuntoManager;

	@Autowired
	private EXTAcuerdoManager extAcuerdoManager;

	@Autowired
	private EXTBienesManager extBienesManager;
	
	@Autowired
	private AcuerdoDao acuerdoDao;
	
	@Autowired
	private MEJAcuerdoManager mejAcuerdoManager;

	@Autowired
	private EXTContratoManager extContratoManager;
	
	@Autowired
	private AcuerdoManager acuerdoManager;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	public AcuerdoConsumer(Rule<DataContainerPayload> rule, DiccionarioDeCodigos diccionarioCodigos) {
		super(rule);
		this.diccionarioCodigos = diccionarioCodigos; 
	}
	
	public AcuerdoConsumer(List<Rule<DataContainerPayload>> rules, DiccionarioDeCodigos diccionarioCodigos) {
		super(rules);
		this.diccionarioCodigos = diccionarioCodigos; 
	}

	private String getAcuerdoGuid(AcuerdoPayload acuerdo) {
		return acuerdo.getGuid(); //String.format("%d-EXT", acuerdo.getId());
	}

	private String getActuacionRealizadaGuid(ActuacionesRealizadasPayload payload) {
		return payload.getGuid(); //String.format("%d-EXT", payload.getId());
	}

	private String getActuacionAExplorarGuid(ActuacionesAExplorarPayload payload) {
		return payload.getGuid(); //String.format("%d-EXT", payload.getId());
	}

	private String getTerminoGuid(TerminoAcuerdoPayload payload) {
		return payload.getGuid(); //String.format("%d-EXT", payload.getId());
	}
	
	private void actualizaAnalisis(AcuerdoPayload acuerdoPayload, Long idAcuerdo) {
		DtoAnalisisAcuerdo dtoAnalisis = new DtoAnalisisAcuerdo();
		dtoAnalisis.setIdAcuerdo(idAcuerdo);
		dtoAnalisis.setAumentoCapPago(acuerdoPayload.getAnalisisImportePago());
		dtoAnalisis.setAumentoSolvencia(acuerdoPayload.getAnalisisImporteSolvencia());
		dtoAnalisis.setCambioCapPago(acuerdoPayload.getAnalisisCapacidadPago());
		dtoAnalisis.setCambioSolvencia(acuerdoPayload.getAnalisisCambioSolvenciaAcuerdo());
		dtoAnalisis.setConclusionTitulos(acuerdoPayload.getAnalisisConclusionTituloAcuerdo());
		dtoAnalisis.setObservacionesCapPago(acuerdoPayload.getAnalisisObservacionesPago());
		dtoAnalisis.setObservacionesSolvencia(acuerdoPayload.getAnalisisObservacionesSolvencia());
		dtoAnalisis.setObservacionesTitulos(acuerdoPayload.getAnalisisObservacionesTitulos());
		acuerdoManager.guardarAnalisisAcuerdo(dtoAnalisis);
	}

	
	// Guarda las actuaciones...
	private void mergeActuacionesRealizadas(ActuacionesRealizadasPayload actuacionPayload) {
		String guid = getActuacionRealizadaGuid(actuacionPayload);
		ActuacionesRealizadasAcuerdo actuacion = null;//mejAcuerdoManager.getActuacionesRealizadasAcuerdoByGuid(guid);
		DtoActuacionesRealizadasAcuerdo dto = new DtoActuacionesRealizadasAcuerdo();
		if (actuacion==null) {
			String acuerdoGuid = getAcuerdoGuid(actuacionPayload.getAcuerdo());
			EXTAcuerdo acuerdo = null;//mejAcuerdoManager.getAcuerdoByGuid(acuerdoGuid);
			if (acuerdo==null) {
				throw new IntegrationDataException(String.format("[INTEGRACION] Acuerdo con guid %s no existe, no se puede crear la actuación a explorar", acuerdoGuid));
			}
			dto.setIdAcuerdo(acuerdo.getId());
			actuacion = new ActuacionesRealizadasAcuerdo();
			actuacion.setAcuerdo(acuerdo);
			actuacion.setGuid(guid);
		} else {
			dto.setIdAcuerdo(actuacion.getAcuerdo().getId());
		}
		
		dto.setActuaciones(actuacion);
		String valor = actuacionPayload.getResultado();
		if (!Checks.esNulo(valor)) {
			DDResultadoAcuerdoActuacion resultado = (DDResultadoAcuerdoActuacion)diccionarioApi.dameValorDiccionarioByCod(DDResultadoAcuerdoActuacion.class, valor);
			actuacion.setDdResultadoAcuerdoActuacion(resultado);
		}
		valor = actuacionPayload.getTipo();
		if (!Checks.esNulo(valor)) {
			DDTipoActuacionAcuerdo ddTipoActuacionAcuerdo = (DDTipoActuacionAcuerdo)diccionarioApi.dameValorDiccionarioByCod(DDTipoActuacionAcuerdo.class, valor);
			actuacion.setDdTipoActuacionAcuerdo(ddTipoActuacionAcuerdo);
		}
		valor = actuacionPayload.getTipoAyudas();
		if (!Checks.esNulo(valor)) {
			DDTipoAyudaAcuerdo tipoAyudaActuacion = (DDTipoAyudaAcuerdo)diccionarioApi.dameValorDiccionarioByCod(DDTipoAyudaAcuerdo.class, valor);
			actuacion.setTipoAyudaActuacion(tipoAyudaActuacion);
		}
		actuacion.setFechaActuacion(actuacionPayload.getFecha());
		actuacion.setObservaciones(actuacionPayload.getObservaciones());
		if (actuacion.getAuditoria()!=null) {
			actuacion.getAuditoria().setBorrado(actuacionPayload.isBorrado());
		}
		extAcuerdoManager.saveActuacionesRealizadasAcuerdo(dto);
	}
	
	private void mergeActuacionesAExplorar(ActuacionesAExplorarPayload actuacionPayload) {
		String guid = getActuacionAExplorarGuid(actuacionPayload);
		ActuacionesAExplorarAcuerdo actuacion = null;//mejAcuerdoManager.getActuacionesAExplorarAcuerdoByGuid(guid);
		
		DtoActuacionesAExplorar dto = new DtoActuacionesAExplorar();
		if (actuacion==null) {
			String acuerdoGuid = getAcuerdoGuid(actuacionPayload.getAcuerdo());
			EXTAcuerdo acuerdo = null;//mejAcuerdoManager.getAcuerdoByGuid(acuerdoGuid);
			if (acuerdo==null) {
				throw new IntegrationDataException(String.format("[INTEGRACION] Acuerdo con guid %s no existe, no se puede crear la actuación a explorar", acuerdoGuid));
			}
			actuacion = new ActuacionesAExplorarAcuerdo();
			dto.setIdAcuerdo(acuerdo.getId());
			dto.setGuid(guid);
		} else {
			dto.setIdActuacion(actuacion.getId());
		}
		dto.setDdSubtipoSolucionAmistosaAcuerdo(actuacionPayload.getSubtipoSolucionAmistosa());
		dto.setDdValoracionActuacionAmistosa(actuacionPayload.getValoracionActuacionAmistosa());
		dto.setObservaciones(actuacionPayload.getObservaciones());
		
		extAcuerdoManager.saveActuacionAExplorarAcuerdo(dto);
	}

	// Merge términos...
	private void actualizaTerminosAcuerdo(TerminoAcuerdoPayload terminoPayload) {
		String valor;
		String guid = getTerminoGuid(terminoPayload);
		TerminoAcuerdo termino = null;//mejAcuerdoManager.getTerminoAcuerdoByGuid(guid);
		if (termino==null) {
			String acuerdoGuid = getAcuerdoGuid(terminoPayload.getAcuerdo());
			EXTAcuerdo acuerdo = null;//mejAcuerdoManager.getAcuerdoByGuid(acuerdoGuid);
			if (acuerdo==null) {
				throw new IntegrationDataException(String.format("[INTEGRACION] Acuerdo con guid %s no existe, no se puede crear el término", acuerdoGuid));
			}
			termino = new TerminoAcuerdo();
			termino.setAcuerdo(acuerdo);
			termino.setGuid(guid);;
		}
		
		if (terminoPayload.isBorrado()) {
			// Elimina los bienes
			List<TerminoBien> tbList = mejAcuerdoManager.getTerminoAcuerdoBienes(termino.getId());
			for (TerminoBien tb : tbList){
				proxyFactory.proxy(MEJAcuerdoApi.class).deleteTerminoBien(tb);
			}		
			// Elimina los contratos
			List<TerminoContrato> tcList = mejAcuerdoManager.getTerminoAcuerdoContratos(termino.getId());
			for (TerminoContrato tc : tcList){
				proxyFactory.proxy(MEJAcuerdoApi.class).deleteTerminoContrato(tc);
			}		
			// Elimina el término
			mejAcuerdoManager.deleteTerminoAcuerdo(termino);
			return;
		}
		
		termino.setComisiones(terminoPayload.getComisiones());
		termino.setFormalizacion(terminoPayload.getCampoFormalizacion());
		termino.setImporte(terminoPayload.getImporte());
		termino.setInformeLetrado(terminoPayload.getInformeLetrado());
		termino.setInteres(terminoPayload.getInteres());
		termino.setModoDesembolso(terminoPayload.getModoDesembolso());
		termino.setPeriodicidad(terminoPayload.getPeriodicidad());
		termino.setPeriodoFijo(terminoPayload.getPerioFijo());
		termino.setPeriodoVariable(terminoPayload.getPeridoVariable());
		termino.setSistemaAmortizacion(terminoPayload.getSistemaAmortizacion());

		if (termino.getAuditoria()!=null) {
			termino.getAuditoria().setBorrado(terminoPayload.isBorrado());
		}
		
		valor = terminoPayload.getTipoAcuerdo();
		if (!Checks.esNulo(valor)){
			DDTipoAcuerdo tipoAcuerdo = (DDTipoAcuerdo)diccionarioApi.dameValorDiccionarioByCod(DDTipoAcuerdo.class, valor);
			termino.setTipoAcuerdo(tipoAcuerdo);
		}
		valor = terminoPayload.getTipoProducto();
		if (!Checks.esNulo(valor)){
			DDTipoProducto tipoProducto = (DDTipoProducto)diccionarioApi.dameValorDiccionarioByCod(DDTipoProducto.class, valor);
			termino.setTipoProducto(tipoProducto);
		}
		
		mejAcuerdoManager.saveTerminoAcuerdo(termino);
		//termino = mejAcuerdoManager.getTerminoAcuerdoByGuid(guid);
		
		mergeTerminosContrato(terminoPayload.getContratosRelacionados(), termino);
		mergeTerminosBien(terminoPayload.getBienesRelacionados(), termino);
	}

	private void mergeTerminosContrato(List<String> cntGuids, TerminoAcuerdo termAcuerdo) {
		if (cntGuids==null) {
			return;
		}
		// El resto
		for (String guid : cntGuids) {
			Contrato cnt = extContratoManager.getContraoByNroContrato(guid);
			TerminoContrato tc = new TerminoContrato();
			tc.setContrato(cnt);
			tc.setTermino(termAcuerdo);
			proxyFactory.proxy(MEJAcuerdoApi.class).saveTerminoContrato(tc);
		}
	}
	
	
	private void mergeTerminosBien(List<String> bieGuids, TerminoAcuerdo termAcuerdo) {
		if (bieGuids==null) {
			return;
		}
		// El resto
		for (String guid : bieGuids) {
			Bien bien = extBienesManager.getBienByCodigoInterno(guid);
			TerminoBien tb = new TerminoBien();
			tb.setBien(bien);
			tb.setTermino(termAcuerdo);
			proxyFactory.proxy(MEJAcuerdoApi.class).saveTerminoBien(tb);
		}
	}
	
	
	private Acuerdo actualiza(AcuerdoPayload acuerdoPayload) {
		String acuerdoGuid = getAcuerdoGuid(acuerdoPayload);
		
		// Recupera valores:
		EXTAcuerdo acuerdo = null;//mejAcuerdoManager.getAcuerdoByGuid(acuerdoGuid);

		DtoAcuerdo dtoAcuerdo = new DtoAcuerdo();
		if (acuerdo==null) {
			EXTAsunto asunto = extAsuntoManager.getAsuntoByGuid(acuerdoPayload.getAsunto().getGuid());
			dtoAcuerdo.setIdAsunto(asunto.getId());
		} else {
			dtoAcuerdo.setIdAcuerdo(acuerdo.getId());
		}

		//
		dtoAcuerdo.setTipoAcuerdo(acuerdoPayload.getTipoAcuerdo());
		dtoAcuerdo.setSolicitante(acuerdoPayload.getSolicitante());
		dtoAcuerdo.setEstado(acuerdoPayload.getEstadoAcuerdo());
		dtoAcuerdo.setTipoPago(acuerdoPayload.getTipoPagoAcuerdo());
		dtoAcuerdo.setPeriodicidad(acuerdoPayload.getPeriodicidadAcuerdo());

		dtoAcuerdo.setObservaciones(acuerdoPayload.getObservaciones());
		
		SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
		
		Date fecha = acuerdoPayload.getFechaCierre();
		if (fecha!=null) {
			dtoAcuerdo.setFechaCierre(sdf1.format(fecha));
		}
		fecha = acuerdoPayload.getFechaLimite();
		if (fecha!=null) {
			dtoAcuerdo.setFechaLimite(sdf1.format(fecha));
		}
		
		Double valorDbl = acuerdoPayload.getImportePago();
		if (valorDbl!=null) {
			dtoAcuerdo.setImportePago(valorDbl.toString());
		}
		dtoAcuerdo.setPeriodo(acuerdoPayload.getPeriodo());
		dtoAcuerdo.setFechaEstado(acuerdoPayload.getFechaEstado());
		
		// Guarda el acuerdo.
		//Long idAcuerdo = mejAcuerdoManager.guardar(dtoAcuerdo);
		if (acuerdo==null) {
		//	acuerdo = mejAcuerdoManager.getAcuerdoById(idAcuerdo);
		}
		
		// datos adicionales
		acuerdo.setFechaPropuesta(acuerdoPayload.getFechaPropuesta());
		acuerdo.setFechaCierre(acuerdoPayload.getFechaCierre());
		acuerdo.setFechaResolucionPropuesta(acuerdoPayload.getFechaPropuesta());
		acuerdo.setImportePago(acuerdoPayload.getImportePago());
		acuerdo.setPeriodo(acuerdoPayload.getPeriodo());
		acuerdo.setPorcentajeQuita(acuerdoPayload.getPorcentajeQuita());
		
		//mergeActuacionesAExplorar(acuerdoPayload.getActuacionesAExplorar(), acuerdo);
		//mergeActuacionesRealizadas(acuerdoPayload.getActuacionesRealizadas(), acuerdo);
		//actualizaAnalisis(acuerdoPayload, idAcuerdo);
		
		acuerdoDao.saveOrUpdate(acuerdo);
		
		//mergeTerminosAcuerdo(acuerdoPayload.getTerminosAcuerdo(), acuerdo);
		
		return acuerdo;
	}
	
/*	
	private void proponerAcuerdo(Acuerdo acuerdo) {
        Long idEntidad = acuerdo.getAsunto().getId();
        String tipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO;
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_ACUERDO_PROPUESTO;
        Long plazo = Long.parseLong(PlazoTareasDefault.CODIGO_ACUERDO_PROPUESTO);
        Boolean espera = true;
        String descripcion = null;
        DtoGenerarTarea dto = new DtoGenerarTarea(idEntidad, tipoEntidad, codigoSubtipoTarea, espera, false, plazo, descripcion);
        proxyFactory.proxy(TareaNotificacionApi.class).crearTarea(dto);		
	}
	
	private void aceptarAcuerdo(Acuerdo acuerdo) {
		
		notificacionManager.getListByProcedimientoSubtipo(idProcedimiento, subtipoTarea)		
    	notificacionManager.borrarNotificacionTarea(idTarea);

    	
		// Cancelo las tareas del supervisor
		cancelarTareasAcuerdoPropuesto(acuerdo);
		
        Long idEntidad = acuerdo.getAsunto().getId();
        String tipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO;
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO;
        Long plazo = Long.parseLong(PlazoTareasDefault.CODIGO_ACUERDO_PROPUESTO);
        DtoGenerarTarea dto = new DtoGenerarTarea(idEntidad, tipoEntidad, codigoSubtipoTarea, espera, false, plazo, descripcion);
        proxyFactory.proxy(TareaNotificacionApi.class).crearTarea(dto);		
	}
*/
	
	protected void doAction(DataContainerPayload payload) {
		if (payload.getTipo().equals(IntegracionBpmService.TIPO_DATOS_ACUERDO_TERMINO)) {
			TerminoAcuerdoPayload terminoPayload = new TerminoAcuerdoPayload(payload);
			actualizaTerminosAcuerdo(terminoPayload);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_DATOS_ACUERDO_ACT_A_EXP)) {
			ActuacionesAExplorarPayload actAExplPayload = new ActuacionesAExplorarPayload(payload);
			mergeActuacionesAExplorar(actAExplPayload);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_DATOS_ACUERDO_ACT_REALIZAR)) {
			ActuacionesRealizadasPayload actRealizadas = new ActuacionesRealizadasPayload(payload);
			mergeActuacionesRealizadas(actRealizadas);
		} else {
			AcuerdoPayload acuerdoPayload = new AcuerdoPayload(payload);
			actualiza(acuerdoPayload);
		}
		

	}

	
}
