package es.pfsgroup.recovery.integration.bpm;

import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionSynchronizationAdapter;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;

@Service
public class IntegracionBpmServiceImpl implements IntegracionBpmService {

	public static final String PROPIEDAD_INTEGRACION_ACTIVA = "integracion.activa";
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired(required=false)
	private NotificarEventosBPMGateway notificacionGateway;

    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
    @Resource
    private Properties appProperties;
    
	protected boolean isTransactional() {
		return (transactionManager!=null); 
	}
	
	protected boolean isActive() {
		String valor = appProperties.getProperty(PROPIEDAD_INTEGRACION_ACTIVA);
		if (Checks.esNulo(valor)) {
			return false;
		}
		return Boolean.parseBoolean(valor);
	}
	
	@Override
	public void notificaTarea(final TareaNotificacion tareaNotificacion) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío notificaTarea...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.notificaTarea(tareaNotificacion, TIPO_TAREA_NOTIFICACION, DbIdContextHolder.getDbSchema());		
	    			logger.info("[INTEGRACION] Enviado notificaTarea!!!");
	    		}
			});
    	} else {
			notificacionGateway.notificaTarea(tareaNotificacion, TIPO_TAREA_NOTIFICACION, DbIdContextHolder.getDbSchema());		
			logger.info("[INTEGRACION] Enviado notificaTarea!!!");
    	}
	}

	
    public void notificaInicioTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío notificaInicioTarea...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.inicioTarea(tareaExterna, TIPO_INICIO_TAREA, DbIdContextHolder.getDbSchema());		
	    			logger.info("[INTEGRACION] Enviado notificaInicioTarea!!!");
	    		}    		
			});
    	} else {
    		notificacionGateway.inicioTarea(tareaExterna, TIPO_INICIO_TAREA, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado notificaInicioTarea!!!");
    	}
    }
    
    public void notificaFinTarea(final TareaExterna tareaExterna, final String transicion) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}	
    	logger.info("[INTEGRACION] Preparando para envío notificaFinTarea...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.finTarea(tareaExterna, TIPO_FINALIZACION_TAREA, DbIdContextHolder.getDbSchema(), transicion);		
	    			logger.info("[INTEGRACION] Enviado notificaFinTarea!!!");
	    		}
	    		
			});
    	} else {
    		notificacionGateway.finTarea(tareaExterna, TIPO_FINALIZACION_TAREA, DbIdContextHolder.getDbSchema(), transicion);
			logger.info("[INTEGRACION] Enviado notificaFinTarea!!!");
    	}
    }

	@Override
	public void notificaCancelarTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío notificaCancelarTarea...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.cancelacionTarea(tareaExterna, TIPO_CANCELACION_TAREA, DbIdContextHolder.getDbSchema());		
	    			logger.info("[INTEGRACION] Enviado notificaCancelarTarea!!!");
	    		}
			});
    	} else {
    		notificacionGateway.cancelacionTarea(tareaExterna, TIPO_CANCELACION_TAREA, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado notificaCancelarTarea!!!");
    	}
	}

	@Override
	public void notificaFinBPM(final Procedimiento procedimiento, final String tarGuidOrigen, final String transicion) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío notificaFinBPM...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.finBPM(procedimiento, TIPO_FIN_BPM, DbIdContextHolder.getDbSchema(), tarGuidOrigen, transicion);
	    			logger.info("[INTEGRACION] Enviado notificaFinBPM!!!");
	    		}
			});
    	} else {
    		notificacionGateway.finBPM(procedimiento, TIPO_FIN_BPM, DbIdContextHolder.getDbSchema(), tarGuidOrigen, transicion);
			logger.info("[INTEGRACION] Enviado notificaFinBPM!!!");
    	}
	}

	@Override
	public void notificaParalizarTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío notificaParalizarTarea...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.paralizarTarea(tareaExterna, TIPO_PARALIZAR_TAREA, DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado notificaParalizarTarea!!!");
	    		}
			});
    	} else {
    		notificacionGateway.paralizarTarea(tareaExterna, TIPO_PARALIZAR_TAREA, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado notificaParalizarTarea!!!");
    	}
	}

	@Override
	public void notificaActivarTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío notificaActivarTarea...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.activarTarea(tareaExterna, TIPO_ACTIVAR_TAREA, DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado notificaActivarTarea!!!");
	    		}
			});
    	} else {
    		notificacionGateway.activarTarea(tareaExterna, TIPO_ACTIVAR_TAREA, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado notificaActivarTarea!!!");
    	}
	}


	@Override
	public void activarBPM(final Procedimiento procedimiento) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío activarBPM...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.activarBPM(procedimiento, TIPO_ACTIVAR_BPM, DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado activarBPM!!!");
	    		}
			});
    	} else {
    		notificacionGateway.activarBPM(procedimiento, TIPO_ACTIVAR_BPM, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado activarBPM!!!");
    	}
	}

	@Override
    public void actualizar(final MEJRecurso recurso) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío enviarDatos-Recurso...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	        		notificacionGateway.enviar(recurso, TIPO_DATOS_RECURSO, DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado enviarDatos-Recurso!!!");
	    		}
			});
    	} else {
    		notificacionGateway.enviar(recurso, TIPO_DATOS_RECURSO, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado enviarDatos-Recurso!!!");
    	}
    }

	@Override
	public void enviarDatos(final Subasta subasta) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío enviarDatos-Subasta...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(subasta, TIPO_DATOS_SUBASTA, DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado enviarDatos-Subasta!!!");
	    		}
			});
    	} else {
    		notificacionGateway.enviar(subasta, TIPO_DATOS_SUBASTA, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado enviarDatos-Subasta!!!");
    	}
	}
	
	@Override
	public void enviarDatos(final Acuerdo acuerdo) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío enviarDatos-Acuerdo...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(acuerdo, TIPO_DATOS_ACUERDO, DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado enviarDatos-Acuerdo!!!");
	    		}
			});
    	} else {
    		notificacionGateway.enviar(acuerdo, TIPO_DATOS_ACUERDO, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado enviarDatos-Acuerdo!!!");
    	}
	}

	@Override
	public void notificaCambioEstado(final Acuerdo acuerdo) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío cambioEstado-Acuerdo...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(acuerdo, String.format("%s-%s", TIPO_DATOS_ACUERDO, acuerdo.getEstadoAcuerdo().getCodigo()), DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado cambioEstado-Acuerdo!!!");
	    		}
			});
    	} else {
    		notificacionGateway.enviar(acuerdo, String.format("%s-%s", TIPO_DATOS_ACUERDO, acuerdo.getEstadoAcuerdo().getCodigo()), DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado cambioEstado-Acuerdo!!!");
    	}
	}
	
	@Override
	public void enviarDatos(final ActuacionesRealizadasAcuerdo actuacionRealizada) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío enviarDatos-Acuerdo-Actuaciones-Realizadas...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(actuacionRealizada, TIPO_DATOS_ACUERDO_ACT_REALIZAR, DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado enviarDatos-Acuerdo-Actuaciones-Realizadas!!!");
	    		}
			});
    	} else {
    		notificacionGateway.enviar(actuacionRealizada, TIPO_DATOS_ACUERDO_ACT_REALIZAR, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado enviarDatos-Acuerdo-Actuaciones-Realizadas!!!");
    	}
	}

	@Override
	public void enviarDatos(final ActuacionesAExplorarAcuerdo actuacionAExplorar) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío enviarDatos-Acuerdo-Actuaciones-Explorar...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(actuacionAExplorar, TIPO_DATOS_ACUERDO_ACT_A_EXP, DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado enviarDatos-Acuerdo-Actuaciones-Explorar!!!");
	    		}
			});
    	} else {
    		notificacionGateway.enviar(actuacionAExplorar, TIPO_DATOS_ACUERDO_ACT_A_EXP, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado enviarDatos-Acuerdo-Actuaciones-Explorar!!!");
    	}
	}

	@Override
	public void enviarDatos(final TerminoAcuerdo terminoAcuerdo) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío enviarDatos-Acuerdo-Termino...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(terminoAcuerdo, TIPO_DATOS_ACUERDO_TERMINO, DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado enviarDatos-Acuerdo-Actuaciones-Termino!!!");
	    		}
			});
    	} else {
    		notificacionGateway.enviar(terminoAcuerdo, TIPO_DATOS_ACUERDO_TERMINO, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado enviarDatos-Acuerdo-Actuaciones-Termino!!!");
    	}
	}
	
	@Override
	public void enviarDatos(final MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío enviarDatos-Decision-Procedimiento...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(dtoDecisionProcedimiento, TIPO_DATOS_DECISION_PROCEDIMIENTO, DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado enviarDatos-Decision-Procedimiento!!!");
	    		}
			});
    	} else {
    		notificacionGateway.enviar(dtoDecisionProcedimiento, TIPO_DATOS_DECISION_PROCEDIMIENTO, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado enviarDatos-Decision-Procedimiento!!!");
    	}
	}

	@Override
	public void finalizarAsunto(final MEJFinalizarAsuntoDto finAsunto) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío Finalizar Asunto...");
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.finalizaAsunto(finAsunto, TIPO_FIN_ASUNTO, DbIdContextHolder.getDbSchema());
	    			logger.info("[INTEGRACION] Enviado Finalizar Asunto!!!");
	    		}
			});
    	} else {
    		notificacionGateway.finalizaAsunto(finAsunto, TIPO_FIN_ASUNTO, DbIdContextHolder.getDbSchema());
			logger.info("[INTEGRACION] Enviado Finalizar Asunto!!!");
    	}
	}

}
