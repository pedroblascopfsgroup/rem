package es.pfsgroup.recovery.integration;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;
import org.springframework.security.Authentication;
import org.springframework.security.GrantedAuthorityImpl;
import org.springframework.security.context.SecurityContext;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.AuthenticationProvider;
import org.springframework.security.providers.preauth.PreAuthenticatedAuthenticationToken;
import org.springframework.security.ui.preauth.PreAuthenticatedGrantedAuthoritiesAuthenticationDetails;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.EntidadManager;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.commons.utils.Checks;

public class DataContainerPayloadService<T extends DataContainerPayload> {

    private static final Object EMPTY_PASSWORD = "";

	private final Log logger = LogFactory.getLog(getClass());

    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
    
	@Autowired
	private EntidadDao entidadDao;
	
	@Autowired
	private EntidadManager entidadManager;
    
	private final ConsumerManager<T> consumerManager;
	private final String entidadWorkingCode;
	private final AuthenticationProvider authprovider;
	
	
	public DataContainerPayloadService(ConsumerManager<T> consumerManager
			, String entidadWorkingCode
			,AuthenticationProvider authprovider) {
		this.entidadWorkingCode = entidadWorkingCode;
		this.consumerManager = consumerManager;
		this.authprovider = authprovider;
	}

	protected void doBeforeDispatch(Message<T> message) {
	}

	protected void doAfterDispatch(Message<T> message) {
	}

	protected void doAfterCommit(Message<T> message) {
	}
	
	protected void doOnError(Message<T> message, Exception ex) {
	}

	protected SecurityContext doLogin(Message<T> message) { 
		DataContainerPayload payload =  message.getPayload();
		if (Checks.esNulo(payload.getUsername())) {
			logger.warn("[INTEGRACION] No se ha proporcionado usuario en el mensaje");
			return null;
		}
		UsuarioSecurity usuarioSecurity = new UsuarioSecurity();
		usuarioSecurity.setId(-1L);
		usuarioSecurity.setUsername(payload.getUsername());
		
		Entidad entidad = entidadManager.getEntidadById(1L);
		usuarioSecurity.setEntidad(entidad);
		
	    SecurityContext securityContext = SecurityContextHolder.getContext();
		PreAuthenticatedAuthenticationToken authRequest = new PreAuthenticatedAuthenticationToken(payload.getUsername(), EMPTY_PASSWORD);
		authRequest.setDetails(usuarioSecurity);
		Authentication authentication = authprovider.authenticate(authRequest);
		securityContext.setAuthentication(authentication);
		logger.info(String.format("[INTEGRACION] Usuario autenticado [%s]!", authRequest.getName()));
		return securityContext;
	}
	
	public Message<T> dispatchMessage(Message<T> message) {
		final Entidad entidad = entidadDao.findByWorkingCode(this.entidadWorkingCode);
		DbIdContextHolder.setDbId(entidad.getId());
        TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
        SecurityContext securityContext = null;
		try {
			securityContext = doLogin(message);
			doBeforeDispatch(message);
			consumerManager.dispatch(message);
			doAfterDispatch(message);
			transactionManager.commit(transaction);
			doAfterCommit(message);
		} catch (IntegrationDataException ex) {
			logger.error("[INTEGRACION] Error de datos en consumer integración.", ex);
			transactionManager.rollback(transaction);
			doOnError(message, ex);
		} catch (Exception ex) {
			logger.error("[INTEGRACION] Error ejecutando consumer integración.", ex);
			transactionManager.rollback(transaction);
			doOnError(message, ex);
		} finally {
			if (securityContext!=null) {
				 securityContext.getAuthentication().setAuthenticated(false);
				 SecurityContextHolder.clearContext();
			}
		}
		return message;
	}
	
}
