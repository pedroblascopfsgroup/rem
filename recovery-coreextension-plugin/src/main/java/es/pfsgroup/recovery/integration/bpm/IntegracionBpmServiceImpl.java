package es.pfsgroup.recovery.integration.bpm;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.mejoras.recurso.model.MEJRecurso;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

@Service
public class IntegracionBpmServiceImpl implements IntegracionBpmService {

	@Autowired(required=false)
	private NotificarEventosBPMGateway notificacionGateway;

	//private SyncFramework syncFramework;

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
    	notificacionGateway.enviar(recurso, TIPO_CAB_RECURSO);
    }
	
	@Override
	public void notificarPropuestaAcuerdo(EXTAcuerdo acuerdo) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.notificarPropuestaAcuerdo(acuerdo, TIPO_PROPUESTA_ACUERDO);
	}

	@Override
	public void notificarCierreAcuerdo(EXTAcuerdo acuerdo) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.notificarCierreAcuerdo(acuerdo, TIPO_CIERRE_ACUERDO);
	}

	@Override
	public void notificarRechazarAcuerdo(EXTAcuerdo acuerdo) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.notificarRechazarAcuerdo(acuerdo, TIPO_RECHAZAR_ACUERDO);
	}

	@Override
	public void enviarCabecera(Subasta subasta) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.enviar(subasta, TIPO_CAB_SUBASTA);
	}
	
}
