package es.pfsgroup.recovery.integration.bpm;

import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.xml.ws.ServiceMode;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.transaction.support.TransactionSynchronizationAdapter;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.dsm.model.EntidadConfig;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.asunto.controller.dto.MEJFinalizarAsuntoDto;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;
import es.pfsgroup.recovery.integration.IntegrationDataException;

@Service
public class IntegracionBpmServiceImpl extends BaseIntegracionServiceImpl implements IntegracionBpmService {

	private static final String LOG_MSG_ENCOLANDO = "[INTEGRACION] Preparando mensaje en cola %s...";
	private static final String LOG_MSG_ENCOLADO = "[INTEGRACION] Mensaje %s encolado!";

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired(required=false)
	private NotificarEventosBPMGateway notificacionGateway;

	@Override
	public void notificaTarea(final TareaNotificacion tareaNotificacion) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_TAREA_NOTIFICACION));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.notificaTarea(tareaNotificacion, TIPO_TAREA_NOTIFICACION, entidadId);		
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_TAREA_NOTIFICACION));
	    		}
			});
    	} else {
			notificacionGateway.notificaTarea(tareaNotificacion, TIPO_TAREA_NOTIFICACION, entidadId);		
			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_TAREA_NOTIFICACION));
    	}
	}

	
    public void notificaInicioTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_INICIO_TAREA));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.inicioTarea(tareaExterna, TIPO_INICIO_TAREA, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_INICIO_TAREA));
	    		}    		
			});
    	} else {
    		notificacionGateway.inicioTarea(tareaExterna, TIPO_INICIO_TAREA, entidadId);
    		logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_INICIO_TAREA));
    	}
    }
    
    public void notificaFinTarea(final TareaExterna tareaExterna, final String transicion) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}	
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_FINALIZACION_TAREA));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.finTarea(tareaExterna, TIPO_FINALIZACION_TAREA, entidadId, transicion);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_FINALIZACION_TAREA));
	    		}
	    		
			});
    	} else {
    		notificacionGateway.finTarea(tareaExterna, TIPO_FINALIZACION_TAREA, entidadId, transicion);
			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_FINALIZACION_TAREA));
    	}
    }

	@Override
	public void notificaCancelarTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_CANCELACION_TAREA));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.cancelacionTarea(tareaExterna, TIPO_CANCELACION_TAREA, entidadId);		
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_CANCELACION_TAREA));
	    		}
			});
    	} else {
    		notificacionGateway.cancelacionTarea(tareaExterna, TIPO_CANCELACION_TAREA, entidadId);
			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_CANCELACION_TAREA));
    	}
	}

	@Override
	public void notificaFinBPM(final Procedimiento procedimiento, final String tarGuidOrigen, final String transicion) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_FIN_BPM));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.finBPM(procedimiento, TIPO_FIN_BPM, entidadId, tarGuidOrigen, transicion);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_FIN_BPM));
	    		}
			});
    	} else {
    		notificacionGateway.finBPM(procedimiento, TIPO_FIN_BPM, entidadId, tarGuidOrigen, transicion);
			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_FIN_BPM));
    	}
	}

	@Override
	public void notificaParalizarTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_PARALIZAR_TAREA));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.paralizarTarea(tareaExterna, TIPO_PARALIZAR_TAREA, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_PARALIZAR_TAREA));
	    		}
			});
    	} else {
    		notificacionGateway.paralizarTarea(tareaExterna, TIPO_PARALIZAR_TAREA, entidadId);
			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_PARALIZAR_TAREA));
    	}
	}

	@Override
	public void notificaActivarTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_ACTIVAR_TAREA));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.activarTarea(tareaExterna, TIPO_ACTIVAR_TAREA, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_ACTIVAR_TAREA));
	    		}
			});
    	} else {
    		notificacionGateway.activarTarea(tareaExterna, TIPO_ACTIVAR_TAREA, entidadId);
			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_ACTIVAR_TAREA));
    	}
	}


	@Override
	public void activarBPM(final Procedimiento procedimiento) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_ACTIVAR_BPM));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.activarBPM(procedimiento, TIPO_ACTIVAR_BPM, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_ACTIVAR_BPM));
	    		}
			});
    	} else {
    		notificacionGateway.activarBPM(procedimiento, TIPO_ACTIVAR_BPM, entidadId);
			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_ACTIVAR_BPM));
    	}
	}

	@Override
    public void actualizar(final MEJRecurso recurso) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_DATOS_RECURSO));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	        		notificacionGateway.enviar(recurso, TIPO_DATOS_RECURSO, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_RECURSO));
	    		}
			});
    	} else {
    		notificacionGateway.enviar(recurso, TIPO_DATOS_RECURSO, entidadId);
			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_RECURSO));
    	}
    }

	@Override
	public void enviarDatos(final Subasta subasta) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_DATOS_SUBASTA));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(subasta, TIPO_DATOS_SUBASTA, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_SUBASTA));
	    		}
			});
    	} else {
    		notificacionGateway.enviar(subasta, TIPO_DATOS_SUBASTA, entidadId);
			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_SUBASTA));
    	}
	}
	
	@Override
	public void enviarDatos(final Acuerdo acuerdo) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_DATOS_ACUERDO));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(acuerdo, TIPO_DATOS_ACUERDO, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_ACUERDO));
	    		}
			});
    	} else {
    		notificacionGateway.enviar(acuerdo, TIPO_DATOS_ACUERDO, entidadId);
			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_ACUERDO));
    	}
	}

	@Override
	public void notificaCambioEstado(final Acuerdo acuerdo) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_DATOS_ACUERDO));
    	final String entidadId = getEntidad();
    	final String msgType = String.format("%s-%s", TIPO_DATOS_ACUERDO, acuerdo.getEstadoAcuerdo().getCodigo());
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(acuerdo, msgType, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, msgType));
	    		}
			});
    	} else {
    		notificacionGateway.enviar(acuerdo, String.format("%s-%s", TIPO_DATOS_ACUERDO, acuerdo.getEstadoAcuerdo().getCodigo()), entidadId);
    		logger.debug(String.format(LOG_MSG_ENCOLADO, msgType));
    	}
	}
	
	@Override
	public void enviarDatos(final ActuacionesRealizadasAcuerdo actuacionRealizada) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_DATOS_ACUERDO_ACT_REALIZAR));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(actuacionRealizada, TIPO_DATOS_ACUERDO_ACT_REALIZAR, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_ACUERDO_ACT_REALIZAR));
	    		}
			});
    	} else {
    		notificacionGateway.enviar(actuacionRealizada, TIPO_DATOS_ACUERDO_ACT_REALIZAR, entidadId);
    		logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_ACUERDO_ACT_REALIZAR));
    	}
	}

	@Override
	public void enviarDatos(final ActuacionesAExplorarAcuerdo actuacionAExplorar) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_DATOS_ACUERDO_ACT_A_EXP));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(actuacionAExplorar, TIPO_DATOS_ACUERDO_ACT_A_EXP, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_ACUERDO_ACT_A_EXP));
	    		}
			});
    	} else {
    		notificacionGateway.enviar(actuacionAExplorar, TIPO_DATOS_ACUERDO_ACT_A_EXP, entidadId);
    		logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_ACUERDO_ACT_A_EXP));
    	}
	}

	@Override
	public void enviarDatos(final TerminoAcuerdo terminoAcuerdo) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_DATOS_ACUERDO_TERMINO));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(terminoAcuerdo, TIPO_DATOS_ACUERDO_TERMINO, entidadId);
	        		logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_ACUERDO_TERMINO));
	    		}
			});
    	} else {
    		notificacionGateway.enviar(terminoAcuerdo, TIPO_DATOS_ACUERDO_TERMINO, entidadId);
    		logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_ACUERDO_TERMINO));
    	}
	}
	
	@Override
	public void enviarDatos(final MEJDtoDecisionProcedimiento dtoDecisionProcedimiento) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_DATOS_DECISION_PROCEDIMIENTO));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(dtoDecisionProcedimiento, TIPO_DATOS_DECISION_PROCEDIMIENTO, entidadId);
	        		logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_DECISION_PROCEDIMIENTO));
	    		}
			});
    	} else {
    		notificacionGateway.enviar(dtoDecisionProcedimiento, TIPO_DATOS_DECISION_PROCEDIMIENTO, entidadId);
    		logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_DECISION_PROCEDIMIENTO));
    	}
	}

	@Override
	public void finalizarAsunto(final MEJFinalizarAsuntoDto finAsunto) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_FIN_ASUNTO));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.finalizaAsunto(finAsunto, TIPO_FIN_ASUNTO, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_FIN_ASUNTO));
	    		}
			});
    	} else {
    		notificacionGateway.finalizaAsunto(finAsunto, TIPO_FIN_ASUNTO, entidadId);
    		logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_FIN_ASUNTO));
    	}
	}

}
