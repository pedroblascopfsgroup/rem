package es.pfsgroup.recovery.haya.integration.bpm;

import javax.annotation.Resource;
import javax.xml.ws.ServiceMode;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.support.TransactionSynchronizationAdapter;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.dsm.model.EntidadConfig;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.concursal.convenio.model.Convenio;
import es.pfsgroup.recovery.hrebcc.dto.ActualizarRiesgoOperacionalDto;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.bpm.BaseIntegracionServiceImpl;
import es.pfsgroup.recovery.integration.bpm.IntegracionBpmServiceImpl;

@Service
public class IntegracionBpmServiceImplHaya extends BaseIntegracionServiceImpl implements IntegracionBpmService {
	
	protected final Log logger = LogFactory.getLog(getClass());

	private static final String LOG_MSG_ENCOLANDO = "[INTEGRACION] Preparando Mensaje-HAYA en cola %s...";
	private static final String LOG_MSG_ENCOLADO = "[INTEGRACION] Mensaje-HAYA %s encolado!";
	
	@Autowired(required=false)
	private NotificarEventosBPMGateway notificacionGateway;

	@Override
	public void enviarDatos(final Convenio convenio) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_CAB_CONVENIO));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(convenio, TIPO_CAB_CONVENIO, DbIdContextHolder.getDbId());
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_CAB_CONVENIO));
	    		}
			});
    	} else {
    		notificacionGateway.enviar(convenio, TIPO_CAB_CONVENIO, DbIdContextHolder.getDbId());
    		logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_CAB_CONVENIO));
    	}
	}
	
	@Override
	public void enviarDatos(final ActualizarRiesgoOperacionalDto riesgoOperacional) {
		if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.debug(String.format(LOG_MSG_ENCOLANDO, TIPO_DATOS_RIESGO_OPERACIONAL));
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(riesgoOperacional, TIPO_DATOS_RIESGO_OPERACIONAL, entidadId);
	    			logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_RIESGO_OPERACIONAL));
	    		}
			});
    	} else {
    		notificacionGateway.enviar(riesgoOperacional, TIPO_DATOS_RIESGO_OPERACIONAL, entidadId);
    		logger.debug(String.format(LOG_MSG_ENCOLADO, TIPO_DATOS_RIESGO_OPERACIONAL));
    		
    	}
	}
	
}
