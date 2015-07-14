package es.pfsgroup.recovery.integration.bpm;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.acuerdo.model.ActuacionesAExplorarAcuerdo;
import es.capgemini.pfs.acuerdo.model.ActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;

@Service
public class IntegracionBpmServiceImpl implements IntegracionBpmService {

	@Autowired(required=false)
	private NotificarEventosBPMGateway notificacionGateway;

	//private SyncFramework syncFramework;

	@Override
	public void notificaTarea(TareaNotificacion tareaNotificacion) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.inicioTarea(tareaNotificacion, TIPO_TAREA_NOTIFICACION);
	}

	
    public void notificaInicioTarea(TareaExterna tareaExterna) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.inicioTarea(tareaExterna, TIPO_INICIO_TAREA);
    }

    public void notificaFinTarea(TareaExterna tareaExterna, String transicion) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.finTarea(tareaExterna, TIPO_FINALIZACION_TAREA, transicion);
    }

	@Override
	public void notificaCancelarTarea(TareaExterna tareaExterna) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.cancelacionTarea(tareaExterna, TIPO_CANCELACION_TAREA);
	}

	@Override
	public void notificaFinBPM(Procedimiento procedimiento, String tarGuidOrigen, String transicion) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.finBPM(procedimiento, TIPO_FIN_BPM, tarGuidOrigen, transicion);
	}

	@Override
	public void notificaParalizarTarea(TareaExterna tareaExterna) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.paralizarTarea(tareaExterna, TIPO_PARALIZAR_TAREA);
	}

	@Override
	public void notificaActivarTarea(TareaExterna tareaExterna) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.activarTarea(tareaExterna, TIPO_ACTIVAR_TAREA);
	}

	@Override
	public void finalizarBPM(Procedimiento procedimiento) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.finalizarBPM(procedimiento, TIPO_FINALIZAR_BPM);
	}

	@Override
	public void paralizarBPM(Procedimiento procedimiento) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.finalizarBPM(procedimiento, TIPO_PARALIZAR_BPM);
	}

	@Override
	public void activarBPM(Procedimiento procedimiento) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.finalizarBPM(procedimiento, TIPO_ACTIVAR_BPM);
	}

	@Override
    public void actualizar(MEJRecurso recurso) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.enviar(recurso, TIPO_DATOS_RECURSO);
    }

	@Override
	public void enviarDatos(Subasta subasta) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.enviar(subasta, TIPO_DATOS_SUBASTA);
	}
	
	@Override
	public void enviarDatos(Acuerdo acuerdo) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.enviar(acuerdo, TIPO_DATOS_ACUERDO);
	}

	@Override
	public void notificaCambioEstado(Acuerdo acuerdo) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.enviar(acuerdo, String.format("%s-%s", TIPO_DATOS_ACUERDO, acuerdo.getEstadoAcuerdo().getCodigo()));
	}
	
	@Override
	public void enviarDatos(ActuacionesRealizadasAcuerdo actuacionRealizada) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.enviar(actuacionRealizada, TIPO_DATOS_ACUERDO_ACT_REALIZAR);
	}

	@Override
	public void enviarDatos(ActuacionesAExplorarAcuerdo actuacionAExplorar) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.enviar(actuacionAExplorar, TIPO_DATOS_ACUERDO_ACT_A_EXP);
	}

	@Override
	public void enviarDatos(TerminoAcuerdo terminoAcuerdo) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.enviar(terminoAcuerdo, TIPO_DATOS_ACUERDO_TERMINO);
	}

}
