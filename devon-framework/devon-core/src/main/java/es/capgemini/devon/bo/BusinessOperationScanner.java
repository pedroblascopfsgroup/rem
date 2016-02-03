package es.capgemini.devon.bo;

import java.util.Map;

/**
 * Interface to be implemented by BusinessOperation scanners
 * 
 * @author Nicolás Cornaglia
 */
public interface BusinessOperationScanner {

    /**
     * Do the scan and returns the Business Operations found
     */
    public Map<String, BusinessOperationDefinition> scan();

}
