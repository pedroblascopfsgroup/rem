package es.pfsgroup.recovery.integration.bpm;

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

public abstract class BaseIntegracionServiceImpl {

	public static final String PROPIEDAD_INTEGRACION_ACTIVA = "integracion.activa";

	protected final Log logger = LogFactory.getLog(getClass());

    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
	
    @Resource
    private Properties appProperties;
    
	protected boolean isTransactional() {
		return (transactionManager!=null); 
	}
	
	protected String getEntidad() {
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
	
	protected boolean isActive() {
		String valor = appProperties.getProperty(PROPIEDAD_INTEGRACION_ACTIVA);
		if (Checks.esNulo(valor)) {
			return false;
		}
		return Boolean.parseBoolean(valor);
	}

}
