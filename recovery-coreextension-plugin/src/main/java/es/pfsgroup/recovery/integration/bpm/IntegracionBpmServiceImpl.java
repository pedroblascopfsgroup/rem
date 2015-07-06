package es.pfsgroup.recovery.integration.bpm;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
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
	public void enviarPropuesta(Acuerdo acuerdo) {
		enviar(acuerdo, TIPO_CAB_ACUERDO_PROPUESTA);
	}

	@Override
	public void enviarRechazo(Acuerdo acuerdo) {
		enviar(acuerdo, TIPO_CAB_ACUERDO_RECHAZAR);
	}

	@Override
	public void enviarCierre(Acuerdo acuerdo) {
		enviar(acuerdo, TIPO_CAB_ACUERDO_CIERRE);
	}

	@Override
	public void enviarAceptar(Acuerdo acuerdo) {
		enviar(acuerdo, TIPO_CAB_ACUERDO_ACEPTAR);
	}

	@Override
	public void enviarFinalizar(Acuerdo acuerdo) {
		enviar(acuerdo, TIPO_CAB_ACUERDO_FINALIZAR);
	}
	
	private void enviar(Acuerdo acuerdo, String tipo) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.enviar(acuerdo, tipo);
	}

	@Override
	public void enviarCabecera(Subasta subasta) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.enviar(subasta, TIPO_CAB_SUBASTA);
	}
	
}
