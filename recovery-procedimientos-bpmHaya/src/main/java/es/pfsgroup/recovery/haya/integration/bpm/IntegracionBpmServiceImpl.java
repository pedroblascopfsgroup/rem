package es.pfsgroup.recovery.haya.integration.bpm;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionSynchronizationAdapter;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.concursal.convenio.model.Convenio;

@Service("IntegracionBpmServiceImplHaya")
public class IntegracionBpmServiceImpl implements IntegracionBpmService {

	@Autowired(required=false)
	private NotificarEventosBPMGateway notificacionGateway;

    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
    @Resource
    Properties appProperties;
	
	protected boolean isTransactional() {
		return (transactionManager!=null); 
	}
	
	protected boolean isActive() {
		String valor = appProperties.getProperty(es.pfsgroup.recovery.integration.bpm.IntegracionBpmServiceImpl.PROPIEDAD_INTEGRACION_ACTIVA);
		if (Checks.esNulo(valor)) {
			return false;
		}
		return Boolean.parseBoolean(valor);
	}
	
	@Override
	public void enviarDatos(final Convenio convenio) {
    	if (!isActive() || notificacionGateway==null) {
			return;
		}
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(convenio, TIPO_CAB_CONVENIO, DbIdContextHolder.getDbId());
	    		}
			});
    	} else {
    		notificacionGateway.enviar(convenio, TIPO_CAB_CONVENIO, DbIdContextHolder.getDbId());
    	}
	}	
}
