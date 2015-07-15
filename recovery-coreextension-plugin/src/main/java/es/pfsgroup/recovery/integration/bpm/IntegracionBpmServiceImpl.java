package es.pfsgroup.recovery.integration.bpm;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionSynchronizationAdapter;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;

@Service
public class IntegracionBpmServiceImpl implements IntegracionBpmService {

	public static final String PROPIEDAD_INTEGRACION_ACTIVA = "integracion.activa";

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
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.inicioTarea(tareaNotificacion, TIPO_TAREA_NOTIFICACION);		
	    		}
			});
    	} else {
			notificacionGateway.inicioTarea(tareaNotificacion, TIPO_TAREA_NOTIFICACION);		
    	}
	}

	
    public void notificaInicioTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.inicioTarea(tareaExterna, TIPO_INICIO_TAREA);		
	    		}    		
			});
    	} else {
    		notificacionGateway.inicioTarea(tareaExterna, TIPO_INICIO_TAREA);
    	}
    }
    
    public void notificaFinTarea(final TareaExterna tareaExterna, final String transicion) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}	
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.finTarea(tareaExterna, TIPO_FINALIZACION_TAREA, transicion);		
	    		}
	    		
			});
    	} else {
    		notificacionGateway.finTarea(tareaExterna, TIPO_FINALIZACION_TAREA, transicion);
    	}
    }

	@Override
	public void notificaCancelarTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.cancelacionTarea(tareaExterna, TIPO_CANCELACION_TAREA);		
	    		}
			});
    	} else {
    		notificacionGateway.cancelacionTarea(tareaExterna, TIPO_CANCELACION_TAREA);
    	}
	}

	@Override
	public void notificaFinBPM(final Procedimiento procedimiento, final String tarGuidOrigen, final String transicion) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.finBPM(procedimiento, TIPO_FIN_BPM, tarGuidOrigen, transicion);
	    		}
			});
    	} else {
    		notificacionGateway.finBPM(procedimiento, TIPO_FIN_BPM, tarGuidOrigen, transicion);
    	}
	}

	@Override
	public void notificaParalizarTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.paralizarTarea(tareaExterna, TIPO_PARALIZAR_TAREA);
	    		}
			});
    	} else {
    		notificacionGateway.paralizarTarea(tareaExterna, TIPO_PARALIZAR_TAREA);
    	}
	}

	@Override
	public void notificaActivarTarea(final TareaExterna tareaExterna) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.activarTarea(tareaExterna, TIPO_ACTIVAR_TAREA);
	    		}
			});
    	} else {
    		notificacionGateway.activarTarea(tareaExterna, TIPO_ACTIVAR_TAREA);
    	}
	}

	@Override
	public void finalizarBPM(final Procedimiento procedimiento) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.finalizarBPM(procedimiento, TIPO_FINALIZAR_BPM);
	    		}
			});
    	} else {
    		notificacionGateway.finalizarBPM(procedimiento, TIPO_FINALIZAR_BPM);
    	}
	}

	@Override
	public void paralizarBPM(final Procedimiento procedimiento) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.finalizarBPM(procedimiento, TIPO_PARALIZAR_BPM);
	    		}
			});
    	} else {
    		notificacionGateway.finalizarBPM(procedimiento, TIPO_PARALIZAR_BPM);
    	}
    	
	}

	@Override
	public void activarBPM(final Procedimiento procedimiento) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.finalizarBPM(procedimiento, TIPO_ACTIVAR_BPM);
	    		}
			});
    	} else {
    		notificacionGateway.finalizarBPM(procedimiento, TIPO_ACTIVAR_BPM);
    	}
	}

	@Override
    public void actualizar(final MEJRecurso recurso) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	        		notificacionGateway.enviar(recurso, TIPO_DATOS_RECURSO);
	    		}
			});
    	} else {
    		notificacionGateway.enviar(recurso, TIPO_DATOS_RECURSO);
    	}
    }

	@Override
	public void enviarDatos(final Subasta subasta) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(subasta, TIPO_DATOS_SUBASTA);
	    		}
			});
    	} else {
    		notificacionGateway.enviar(subasta, TIPO_DATOS_SUBASTA);
    	}
	}
	
	@Override
	public void enviarDatos(final Acuerdo acuerdo) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(acuerdo, TIPO_DATOS_ACUERDO);
	    		}
			});
    	} else {
    		notificacionGateway.enviar(acuerdo, TIPO_DATOS_ACUERDO);
    	}
	}

	@Override
	public void notificaCambioEstado(final Acuerdo acuerdo) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(acuerdo, String.format("%s-%s", TIPO_DATOS_ACUERDO, acuerdo.getEstadoAcuerdo().getCodigo()));
	    		}
			});
    	} else {
    		notificacionGateway.enviar(acuerdo, String.format("%s-%s", TIPO_DATOS_ACUERDO, acuerdo.getEstadoAcuerdo().getCodigo()));
    	}
	}
	
	@Override
	public void enviarDatos(final ActuacionesRealizadasAcuerdo actuacionRealizada) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(actuacionRealizada, TIPO_DATOS_ACUERDO_ACT_REALIZAR);
	    		}
			});
    	} else {
    		notificacionGateway.enviar(actuacionRealizada, TIPO_DATOS_ACUERDO_ACT_REALIZAR);
    	}
	}

	@Override
	public void enviarDatos(final ActuacionesAExplorarAcuerdo actuacionAExplorar) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(actuacionAExplorar, TIPO_DATOS_ACUERDO_ACT_A_EXP);
	    		}
			});
    	} else {
    		notificacionGateway.enviar(actuacionAExplorar, TIPO_DATOS_ACUERDO_ACT_A_EXP);
    	}
	}

	@Override
	public void enviarDatos(final TerminoAcuerdo terminoAcuerdo) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(terminoAcuerdo, TIPO_DATOS_ACUERDO_TERMINO);
	    		}
			});
    	} else {
    		notificacionGateway.enviar(terminoAcuerdo, TIPO_DATOS_ACUERDO_TERMINO);
    	}
	}

}
