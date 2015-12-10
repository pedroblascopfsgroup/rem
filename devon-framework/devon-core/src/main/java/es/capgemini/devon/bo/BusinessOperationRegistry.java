package es.capgemini.devon.bo;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.exception.FrameworkException;
import es.capgemini.devon.registry.DefaultRegistry;
import es.capgemini.devon.startup.Initializable;

/**
 * @author Nicolás Cornaglia
 */
@Service
public class BusinessOperationRegistry extends DefaultRegistry<BusinessOperationDefinition> implements Initializable {

    private final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private BusinessOperationScanner[] scanners;

    /**
     * @see es.capgemini.devon.startup.Initializable#initialize()
     */
    @Override
    public void initialize() throws FrameworkException {
        for (BusinessOperationScanner scanner : scanners) {
            putAll(scanner.scan());
        }
        postProcessBusinessOperationsOverwrides();
    }

    /**
     * Searches for @BusinessOperation(overrides = "...") and overrides that BusinessOperation 
     */
    protected void postProcessBusinessOperationsOverwrides() {
        for (BusinessOperationDefinition operation : getObjectsRegistry().values()) {

            if (operation.getOverrides() != null) {
                if (logger.isDebugEnabled()) {
                    logger.debug("Overriding local business operation '" + operation.getOverrides() + "' with '" + operation.getId() + "'.");
                }
                BusinessOperationDefinition overwrittenBusinessOperation = get(operation.getOverrides());
                if (overwrittenBusinessOperation.getOverwrittenBy() != null) {
                    throw new FrameworkException("fwk.extensions.BOAlreadyOverridden", new Object[] { operation.getOverrides(), overwrittenBusinessOperation.getOverwrittenBy() });
                }
                overwrittenBusinessOperation.setOverwrittenBy(operation.getId());
            }
        }
    }

    @Override
    public int getOrder() {
        return Integer.MAX_VALUE - 1000;
    }

}
