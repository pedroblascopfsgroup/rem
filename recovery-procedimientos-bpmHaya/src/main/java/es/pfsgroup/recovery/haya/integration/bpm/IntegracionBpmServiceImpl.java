package es.pfsgroup.recovery.haya.integration.bpm;

import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.userdetails.UserDetails;
import org.springframework.transaction.PlatformTransactionManager;
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

@Service("IntegracionBpmServiceImplHaya")
public class IntegracionBpmServiceImpl implements IntegracionBpmService {
	
	protected final Log logger = LogFactory.getLog(getClass());

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
	
	@Override
	public void enviarDatos(final ActualizarRiesgoOperacionalDto riesgoOperacional) {
		if (!isActive() || notificacionGateway==null) {
			return;
		}
    	logger.info("[INTEGRACION] Preparando para envío de datos de riesgo operacional...");
    	final String entidadId = getEntidad();
    	if (isTransactional()) {
	    	TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronizationAdapter() {
	    		@Override
	    		public void beforeCommit(boolean readOnly) {
	    			super.beforeCommit(readOnly);
	    			notificacionGateway.enviar(riesgoOperacional, TIPO_DATOS_RIESGO_OPERACIONAL, entidadId);
	    			logger.info("[INTEGRACION] Enviado datos de riesgo operacional!!!");
	    		}
			});
    	} else {
    		notificacionGateway.enviar(riesgoOperacional, TIPO_DATOS_RIESGO_OPERACIONAL, entidadId);
			logger.info("[INTEGRACION] Enviado datos de riesgo operacional!!!");
    	}
	}
	
	private String getEntidad() {
		UserDetails userDetails = SecurityUtils.getCurrentUser();
		if (userDetails==null || !(userDetails instanceof UsuarioSecurity)) {
			throw new IntegrationDataException("[INTEGRACION] No se puede enviar el mensaje, no hay un usuario autenticado para firmarlo.");
		}
		
		UsuarioSecurity usuario = (UsuarioSecurity)userDetails;
		String entidad = "";
		Map<String, EntidadConfig> mapa = usuario.getEntidad().getConfiguracion();
		if (mapa.containsKey(Entidad.WORKING_CODE_KEY)) {
			entidad = mapa.get(Entidad.WORKING_CODE_KEY).getDataValue();
		}
		return entidad;
	}
}
