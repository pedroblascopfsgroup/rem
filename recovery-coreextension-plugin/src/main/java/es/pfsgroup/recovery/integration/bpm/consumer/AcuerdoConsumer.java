package es.pfsgroup.recovery.integration.bpm.consumer;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.actitudAptitudActuacion.model.DDTipoAyudaActuacion;
import es.capgemini.pfs.acuerdo.AcuerdoManager;
import es.capgemini.pfs.acuerdo.EXTAcuerdoManager;
import es.capgemini.pfs.acuerdo.dao.AcuerdoDao;
import es.capgemini.pfs.acuerdo.dto.DtoActuacionesAExplorar;
import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.dto.DtoAnalisisAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.acuerdo.model.AnalisisAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDResultadoAcuerdoActuacion;
import es.capgemini.pfs.acuerdo.model.DDSubtipoSolucionAmistosaAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoActuacionAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAyudaAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDValoracionActuacionAmistosa;
import es.capgemini.pfs.asunto.EXTAsuntoManager;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.core.api.tareaNotificacion.TareaNotificacionApi;
import es.capgemini.pfs.tareaNotificacion.dto.DtoGenerarTarea;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.mejoras.acuerdos.MEJAcuerdoManager;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;
import es.pfsgroup.recovery.ext.impl.bienes.EXTBienesManager;
import es.pfsgroup.recovery.ext.impl.contrato.EXTContratoManager;
import es.pfsgroup.recovery.integration.ConsumerAction;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.Rule;
import es.pfsgroup.recovery.integration.bpm.ActuacionesAExplorarPayload;
import es.pfsgroup.recovery.integration.bpm.ActuacionesRealizadasPayload;
import es.pfsgroup.recovery.integration.bpm.AcuerdoPayload;
import es.pfsgroup.recovery.integration.bpm.DiccionarioDeCodigos;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmService;
import es.pfsgroup.recovery.integration.bpm.TerminoAcuerdoBienPayload;
import es.pfsgroup.recovery.integration.bpm.TerminoAcuerdoContratoPayload;
import es.pfsgroup.recovery.integration.bpm.TerminoAcuerdoPayload;

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
		return String.format("%d-EXT", acuerdo.getIdOrigen());
		
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
	private void mergeActuacionesRealizadas(List<ActuacionesRealizadasPayload> actuaciones, Acuerdo acuerdo) {
		String valor;
		List<ActuacionesRealizadasAcuerdo> finales = new ArrayList<ActuacionesRealizadasAcuerdo>();
		
		// Almacena IDs
		Map<String, ActuacionesRealizadasAcuerdo> guidActuales = new HashMap<String, ActuacionesRealizadasAcuerdo>();
		if (acuerdo.getActuacionesRealizadas()!=null) {
			for (ActuacionesRealizadasAcuerdo actuacion : acuerdo.getActuacionesRealizadas()) {
				guidActuales.put(actuacion.getGuid(), actuacion);
			}
		}

		if (actuaciones!=null) {
			for (ActuacionesRealizadasPayload actuacionPayload : actuaciones) {
				String guid = actuacionPayload.getGuid();
				ActuacionesRealizadasAcuerdo actuacion;
				if (guidActuales.containsKey(guid)) {
					actuacion = guidActuales.get(guid);
					guidActuales.remove(guid);
				} else {
					actuacion = new ActuacionesRealizadasAcuerdo();
					actuacion.setAcuerdo(acuerdo);
					actuacion.setGuid(guid);
				}
				valor = actuacionPayload.getResultado();
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
				finales.add(actuacion);
			}
		}
		
		// Marcar como borradas el resto????
		
		acuerdo.setActuacionesRealizadas(finales);
	}
	
	private void mergeActuacionesAExplorar(List<ActuacionesAExplorarPayload> actuaciones, Acuerdo acuerdo) {
		String valor;
		List<ActuacionesAExplorarAcuerdo> finales = new ArrayList<ActuacionesAExplorarAcuerdo>();
		
		// Almacena IDs
		Map<String, ActuacionesAExplorarAcuerdo> guidActuales = new HashMap<String, ActuacionesAExplorarAcuerdo>();
		if (acuerdo.getActuacionesAExplorar()!=null) {
			for (ActuacionesAExplorarAcuerdo actuacion : acuerdo.getActuacionesAExplorar()) {
				guidActuales.put(actuacion.getGuid(), actuacion);
			}
		}

		if (actuaciones!=null) {
			for (ActuacionesAExplorarPayload actuacionPayload : actuaciones) {
				String guid = actuacionPayload.getGuid();
				ActuacionesAExplorarAcuerdo actuacion;
				if (guidActuales.containsKey(guid)) {
					actuacion = guidActuales.get(guid);
					guidActuales.remove(guid);
				} else {
					actuacion = new ActuacionesAExplorarAcuerdo();
					actuacion.setAcuerdo(acuerdo);
					actuacion.setGuid(guid);
				}
				valor = actuacionPayload.getSubtipoSolucionAmistosa();
				if (!Checks.esNulo(valor)) {
					DDSubtipoSolucionAmistosaAcuerdo subtipo = (DDSubtipoSolucionAmistosaAcuerdo)diccionarioApi.dameValorDiccionarioByCod(DDSubtipoSolucionAmistosaAcuerdo.class, valor);
					actuacion.setDdSubtipoSolucionAmistosaAcuerdo(subtipo);
				}
				valor = actuacionPayload.getValoracionActuacionAmistosa();
				if (!Checks.esNulo(valor)) {
					DDValoracionActuacionAmistosa valoracion = (DDValoracionActuacionAmistosa)diccionarioApi.dameValorDiccionarioByCod(DDValoracionActuacionAmistosa.class, valor);
					actuacion.setDdValoracionActuacionAmistosa(valoracion);
				}
				actuacion.setObservaciones(actuacionPayload.getObservaciones());
				finales.add(actuacion);
			}
		}
		
		// Marcar como borradas el resto????
				
		acuerdo.setActuacionesAExplorar(finales);
	}

	// Merge términos...
	private void mergeTerminosAcuerdo(List<TerminoAcuerdoPayload> terminos, Acuerdo acuerdo) {
		String valor;
		Map<String, TerminoAcuerdo> guidActuales = new HashMap<String, TerminoAcuerdo>();
		
		// Almacena IDs
		if (acuerdo!=null && acuerdo.getId()!=null) {
			List<TerminoAcuerdo> actuales = mejAcuerdoManager.getTerminosAcuerdo(acuerdo.getId());
			for (TerminoAcuerdo termino : actuales) {
				guidActuales.put(termino.getGuid(), termino);
			}
		}

		for (TerminoAcuerdoPayload terminoPayload : terminos) {
			String guid = terminoPayload.getGuid();
			TerminoAcuerdo termino;
			if (guidActuales.containsKey(guid)) {
				termino = guidActuales.get(guid);
				guidActuales.remove(guid);
			} else {
				termino = mejAcuerdoManager.getTerminoAcuerdoByGuid(guid);
				if (termino==null) {
					termino = new TerminoAcuerdo();
					termino.setAcuerdo(acuerdo);
					termino.setGuid(guid);
				} 
			}
			if (terminoPayload.isBorrado()) {
				mejAcuerdoManager.deleteTerminoAcuerdo(termino);
				continue;
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
			
			mergeTerminosContrato(terminoPayload.getTerminoContratos(), termino);
			mergeTerminosBien(terminoPayload.getTerminoBienes(), termino);
		}
	}
	
	
	private void mergeTerminosContrato(List<TerminoAcuerdoContratoPayload> listadoTerminosContrato, TerminoAcuerdo termino) {
		Map<String, TerminoContrato> guidActuales = new HashMap<String, TerminoContrato>();
		
		// Almacena IDs
		if (termino!=null && termino.getId()!=null) {
			List<TerminoContrato> actuales = mejAcuerdoManager.getTerminoAcuerdoContratos(termino.getId());
			for (TerminoContrato terminoContrato : actuales) {
				guidActuales.put(terminoContrato.getGuid(), terminoContrato);
			}
		}

		for (TerminoAcuerdoContratoPayload terminoPayload : listadoTerminosContrato) {
			String guid = terminoPayload.getGuid();
			TerminoContrato terminoContrato;
			if (guidActuales.containsKey(guid)) {
				terminoContrato = guidActuales.get(guid);
				guidActuales.remove(guid);
			} else {
				terminoContrato = mejAcuerdoManager.getTerminoAcuerdoContratoByGuid(guid);
				if (terminoContrato==null) {
					terminoContrato = new TerminoContrato();
					terminoContrato.setTermino(termino);
					terminoContrato.setGuid(guid);
				} 
			}
			if (terminoPayload.isBorrado()) {
				mejAcuerdoManager.deleteTerminoContrato(terminoContrato);
				continue;
			}
			
			Contrato contrato = extContratoManager.getContraoByNroContrato(terminoPayload.getContratoGuid());
			terminoContrato.setContrato(contrato);
			
			if (terminoContrato.getAuditoria()!=null) {
				terminoContrato.getAuditoria().setBorrado(terminoPayload.isBorrado());
			}
			
			mejAcuerdoManager.saveTerminoContrato(terminoContrato);
		}
	}

	
	private void mergeTerminosBien(List<TerminoAcuerdoBienPayload> listadoTerminosBien, TerminoAcuerdo termino) {
		Map<String, TerminoBien> guidActuales = new HashMap<String, TerminoBien>();
		
		// Almacena IDs
		if (termino!=null && termino.getId()!=null) {
			List<TerminoBien> actuales = mejAcuerdoManager.getTerminoAcuerdoBienes(termino.getId());
			for (TerminoBien terminoBien : actuales) {
				guidActuales.put(terminoBien.getGuid(), terminoBien);
			}
		}

		for (TerminoAcuerdoBienPayload terminoPayload : listadoTerminosBien) {
			String guid = terminoPayload.getGuid();
			TerminoBien terminoBien;
			if (guidActuales.containsKey(guid)) {
				terminoBien = guidActuales.get(guid);
				guidActuales.remove(guid);
			} else {
				terminoBien = mejAcuerdoManager.getTerminoAcuerdoBienByGuid(guid);
				if (terminoBien == null) {
					terminoBien = new TerminoBien();
					terminoBien.setTermino(termino);
					terminoBien.setGuid(guid);
				} 
			}
			if (terminoPayload.isBorrado()) {
				mejAcuerdoManager.deleteTerminoBien(terminoBien);
				continue;
			}
			
			Bien bien = extBienesManager.getBienByCodigoInterno(terminoPayload.getBienGuid());
			terminoBien.setBien(bien);
			
			if (terminoBien.getAuditoria()!=null) {
				terminoBien.getAuditoria().setBorrado(terminoPayload.isBorrado());
			}
			mejAcuerdoManager.saveTerminoBien(terminoBien);
		}
	}
	
	
	private Acuerdo actualiza(AcuerdoPayload acuerdoPayload) {
		String acuerdoGuid = getAcuerdoGuid(acuerdoPayload);
		
		// Recupera valores:
		EXTAcuerdo acuerdo = mejAcuerdoManager.getAcuerdoByGuid(acuerdoGuid);

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
		Long idAcuerdo = mejAcuerdoManager.guardar(dtoAcuerdo);
		if (acuerdo==null) {
			acuerdo = mejAcuerdoManager.getAcuerdoById(idAcuerdo);
		}
		
		// datos adicionales
		acuerdo.setFechaPropuesta(acuerdoPayload.getFechaPropuesta());
		acuerdo.setFechaCierre(acuerdoPayload.getFechaCierre());
		acuerdo.setFechaResolucionPropuesta(acuerdoPayload.getFechaPropuesta());
		acuerdo.setImportePago(acuerdoPayload.getImportePago());
		acuerdo.setPeriodo(acuerdoPayload.getPeriodo());
		acuerdo.setPorcentajeQuita(acuerdoPayload.getPorcentajeQuita());
		
		mergeActuacionesAExplorar(acuerdoPayload.getActuacionesAExplorar(), acuerdo);
		mergeActuacionesRealizadas(acuerdoPayload.getActuacionesRealizadas(), acuerdo);
		actualizaAnalisis(acuerdoPayload, idAcuerdo);
		
		acuerdoDao.saveOrUpdate(acuerdo);
		
		mergeTerminosAcuerdo(acuerdoPayload.getTerminosAcuerdo(), acuerdo);
		
		return acuerdo;
	}
	
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
/*
	private void aceptarAcuerdo(Acuerdo acuerdo) {
		Acuerdo acuerdo = acuerdoDao.get(idAcuerdo);
		// NO PUEDE HABER OTROS ACUERDOS VIGENTES.
		if (acuerdoDao.hayAcuerdosVigentes(acuerdo.getAsunto().getId(),
				idAcuerdo)) {
			throw new BusinessOperationException("acuerdos.hayOtrosVigentes");
		}
		DDEstadoAcuerdo estadoAcuerdoVigente = (DDEstadoAcuerdo) executor
				.execute(ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
						DDEstadoAcuerdo.class, DDEstadoAcuerdo.ACUERDO_VIGENTE);

		acuerdo.setEstadoAcuerdo(estadoAcuerdoVigente);
		acuerdo.setFechaEstado(new Date());
		// Cancelo las tareas del supervisor
		cancelarTareasAcuerdoPropuesto(acuerdo);
		// Genero tareas al gestor para el cierre del acuerdo.
		String codigoPlazoTarea = buscaCodigoPorPeriodo(acuerdo
				.getPeriodicidadAcuerdo());

		acuerdoDao.save(acuerdo);
		
        Long idEntidad = acuerdo.getAsunto().getId();
        String tipoEntidad = DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO;
        String codigoSubtipoTarea = SubtipoTarea.CODIGO_GESTIONES_CERRAR_ACUERDO;
        Long plazo = Long.parseLong(PlazoTareasDefault.CODIGO_ACUERDO_PROPUESTO);
        DtoGenerarTarea dto = new DtoGenerarTarea(idEntidad, tipoEntidad, codigoSubtipoTarea, espera, false, plazo, descripcion);
        proxyFactory.proxy(TareaNotificacionApi.class).crearTarea(dto);		
	}
	*/
	
	protected void doAction(DataContainerPayload payload) {
		AcuerdoPayload acuerdoPayload = new AcuerdoPayload(payload);
		Acuerdo acuerdo = actualiza(acuerdoPayload);
		
		if (payload.getTipo().equals(IntegracionBpmService.TIPO_CAB_ACUERDO_ACEPTAR)) {
			
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_CAB_ACUERDO_CIERRE)) {
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_CAB_ACUERDO_FINALIZAR)) {
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_CAB_ACUERDO_PROPUESTA)) {
			proponerAcuerdo(acuerdo);
		} else if (payload.getTipo().equals(IntegracionBpmService.TIPO_CAB_ACUERDO_RECHAZAR)) {
		}
		

	}

	
}
