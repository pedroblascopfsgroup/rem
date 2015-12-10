package es.capgemini.devon.bo;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.events.EventManager;
import es.capgemini.devon.exception.FrameworkException;

/**
 * TODO Documentar
 * 
 * @author Nicolás Cornaglia
 */
public class DefaultExecutor implements Executor {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private EventManager eventManager;

    @Autowired
    private BusinessOperationRegistry businessOperationRegistry;

    @Autowired
    private BusinessOperationExecutor[] executorsArray;
    private Map<String, BusinessOperationExecutor> executors = new HashMap<String, BusinessOperationExecutor>();

    @PostConstruct
    public void initialize() {
        for (BusinessOperationExecutor executor : executorsArray) {
            executors.put(executor.getType(), executor);
        }
    }

    /**
     * @param id
     * @param args
     * @return
     */
    protected Object internalExecute(String id, Object[] args) {

        // Get the Business Operation
        BusinessOperationDefinition definition = getBusinessOperationDefinition(id);
        // Get the Executor
        BusinessOperationExecutor executor = getBusinessOperationExecutor(definition.getType());

        // TODO: Validate args

        // Execute
        Object result = null;
        result = executor.execute(definition, args);

        // TODO: Validate result

        return result;
    }

    /**
     * @param type
     * @return
     */
    protected BusinessOperationExecutor getBusinessOperationExecutor(String type) {
        BusinessOperationExecutor executor = executors.get(type);
        if (executor == null) {
            eventManager.fireEvent(EventManager.ERROR_CHANNEL, new FrameworkException("Business operation executor [" + type + "] not found."));
            throw new BusinessOperationExecutorNotFoundException("fwk.bo.businessOperationExecutorNotFound", type);
        }
        return executor;
    }

    /**
     * Gets the Business Operation, possibly overriden
     * 
     * @param id
     * @return
     */
    protected BusinessOperationDefinition getBusinessOperationDefinition(String id) {
        BusinessOperationDefinition definition = businessOperationRegistry.get(id);
        if (definition != null && definition.getOverwrittenBy() != null) {
            definition = businessOperationRegistry.get(definition.getOverwrittenBy());
        }
        if (definition == null) {
            eventManager.fireEvent(EventManager.ERROR_CHANNEL, new FrameworkException("Business operation definition [" + id + "] not found."));
            throw new BusinessOperationDefinitionNotFoundException("fwk.bo.businessOperationDefinitionNotFound", id);
        }
        return definition;
    }

    public Object execute(String id) throws FrameworkException {
        return internalExecute(id, new Object[] {});
    }

    public Object execute(String id, Object arg0) throws FrameworkException {
        return internalExecute(id, new Object[] { arg0 });
    }

    public Object execute(String id, Object arg0, Object arg1) throws FrameworkException {
        return internalExecute(id, new Object[] { arg0, arg1 });
    }

    public Object execute(String id, Object arg0, Object arg1, Object arg2) throws FrameworkException {
        return internalExecute(id, new Object[] { arg0, arg1, arg2 });
    }

    public Object execute(String id, Object arg0, Object arg1, Object arg2, Object arg3) throws FrameworkException {
        return internalExecute(id, new Object[] { arg0, arg1, arg2, arg3 });
    }

    public Object execute(String id, Object arg0, Object arg1, Object arg2, Object arg3, Object arg4) throws FrameworkException {
        return internalExecute(id, new Object[] { arg0, arg1, arg2, arg3, arg4 });
    }

}
