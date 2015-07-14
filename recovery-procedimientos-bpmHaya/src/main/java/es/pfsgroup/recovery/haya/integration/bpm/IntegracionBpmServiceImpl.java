package es.pfsgroup.recovery.haya.integration.bpm;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.pfsgroup.concursal.convenio.model.Convenio;

@Service("IntegracionBpmServiceImplHaya")
public class IntegracionBpmServiceImpl implements IntegracionBpmService {

	@Autowired(required=false)
	private NotificarEventosBPMGateway notificacionGateway;

	@Override
	public void enviarDatos(Convenio convenio) {
    	if (notificacionGateway==null) {
			return;
		}
    	notificacionGateway.enviar(convenio, TIPO_CAB_CONVENIO);
	}	
}
