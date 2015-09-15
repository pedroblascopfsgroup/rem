package es.pfsgroup.recovery.integration;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.Message;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.devon.utils.DbIdContextHolder;
import es.capgemini.pfs.dsm.dao.EntidadDao;
import es.capgemini.pfs.dsm.model.Entidad;

public class DataContainerPayloadService<T extends DataContainerPayload> {

    private final Log logger = LogFactory.getLog(getClass());

    @Resource(name = "entityTransactionManager")
    private PlatformTransactionManager transactionManager;
    
	@Autowired
	private EntidadDao entidadDao;
    
	private final ConsumerManager<T> consumerManager;
	private final String entidadWorkingCode;
	
	public DataContainerPayloadService(ConsumerManager<T> consumerManager
			, String entidadWorkingCode) {
		this.entidadWorkingCode = entidadWorkingCode;
		this.consumerManager = consumerManager;
	}

	protected void doBeforeDispatch(Message<T> message) {
	}

	protected void doAfterDispatch(Message<T> message) {
	}

	protected void doAfterCommit(Message<T> message) {
	}
	
	protected void doOnError(Message<T> message, Exception ex) {
	}

	public Message<T> dispatchMessage(Message<T> message) {
		final Entidad entidad = entidadDao.findByWorkingCode(this.entidadWorkingCode);
		DbIdContextHolder.setDbId(entidad.getId());
        TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		try {
			doBeforeDispatch(message);
			consumerManager.dispatch(message);
			doAfterDispatch(message);
			transactionManager.commit(transaction);
			doAfterCommit(message);
		} catch (IntegrationDataException ex) {
			doOnError(message, ex);
			transactionManager.rollback(transaction);
			logger.error("[INTEGRACION] Error de datos en consumer integración.", ex);
		} catch (Exception ex) {
			doOnError(message, ex);
			transactionManager.rollback(transaction);
			logger.error("[INTEGRACION] Error ejecutando consumer integración.", ex);
		}
		return message;
	}
	
}
