package es.pfsgroup.recovery.integration.bpm;

import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.PlatformTransactionManager;

import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.dsm.model.EntidadConfig;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.integration.IntegrationDataException;

public abstract class BaseIntegracionServiceImpl {

	public static final String PROPIEDAD_INTEGRACION_ACTIVA = "integracion.activa";

	protected final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private UsuarioManager usuarioManager;

    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
    @Resource
    private Properties appProperties;
    
	protected boolean isTransactional() {
		return (transactionManager!=null); 
	}
	
	protected String getEntidad() {
		Usuario usuario = usuarioManager.getUsuarioLogado();
		if (usuario==null) {
			throw new IntegrationDataException("[INTEGRACION] No se puede enviar el mensaje, no hay un usuario autenticado para firmarlo.");
		}
		
		String entidad = "";
		Map<String, EntidadConfig> mapa = usuario.getEntidad().getConfiguracion();
		if (mapa.containsKey(Entidad.WORKING_CODE_KEY)) {
			entidad = mapa.get(Entidad.WORKING_CODE_KEY).getDataValue();
		}
		return entidad;
	}
	
	protected boolean isActive() {
		String valor = appProperties.getProperty(PROPIEDAD_INTEGRACION_ACTIVA);
		if (Checks.esNulo(valor)) {
			return false;
		}
		return Boolean.parseBoolean(valor);
	}

}
