package es.pfsgroup.recovery.integration;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;
import org.springframework.security.Authentication;
import org.springframework.security.context.SecurityContext;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.AuthenticationProvider;
import org.springframework.security.providers.preauth.PreAuthenticatedAuthenticationToken;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.EntidadManager;
import es.capgemini.pfs.dsm.model.Entidad;
import es.capgemini.pfs.security.model.UsuarioSecurity;
import es.pfsgroup.commons.utils.Checks;

public class DataContainerPayloadService<T extends DataContainerPayload> {

    private static final Object EMPTY_PASSWORD = "";

	private final Log logger = LogFactory.getLog(getClass());

    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
    
	@Autowired
	private EntidadManager entidadMgr;

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

	
	private UsuarioSecurity loadUser(DataContainerPayload payload, Entidad entidad) {
		UsuarioSecurity user = new UsuarioSecurity();
		user.setId(-1L);
		user.setUsername(payload.getUsername());
		user.setAccountNonExpired(true);
		user.setAccountNonLocked(true);
		user.setEnabled(true);
		user.setEntidad(entidad);
		return user;
	}
	
	
	protected SecurityContext doLogin(Message<T> message, Entidad entidad) { 
		DataContainerPayload payload =  message.getPayload();

		if (Checks.esNulo(payload.getUsername())) {
			logger.warn("[INTEGRACION] Ups, No se ha proporcionado usuario en el mensaje!!!");
			return null;
		}
		
		logger.debug("[INTEGRACION] Configurando usuario \"ficticio\" para ejecución de mensajería...");
		UsuarioSecurity user = loadUser(payload, entidad);
		logger.debug("[INTEGRACION] Usuario configurado!!!");
		
		logger.debug("[INTEGRACION] Authenticando usuario para mensajería...");
		SecurityContext securityContext = SecurityContextHolder.getContext();
		PreAuthenticatedAuthenticationToken authToken = new PreAuthenticatedAuthenticationToken(payload.getUsername(), EMPTY_PASSWORD);
		authToken.setDetails(user);
		Authentication authentication = authprovider.authenticate(authToken);
		securityContext.setAuthentication(authentication);
		logger.debug(String.format("[INTEGRACION] Usuario autenticado [%s]!", authToken.getName()));
		
		return securityContext;
	}
	
	public Message<T> dispatchMessage(Message<T> message) {
		Entidad entidad = entidadMgr.findByWorkingCode(this.entidadWorkingCode);
		DbIdContextHolder.setDbId(entidad.getId());
        TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
        SecurityContext securityContext = null;
		try {
			securityContext = doLogin(message, entidad);
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
