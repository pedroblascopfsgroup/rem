package es.capgemini.devon.startup;

import es.capgemini.devon.exception.FrameworkException;

public interface Initializable {

    /**
     * Order of execution
     * 
     * @return
     */
    public int getOrder();

    /**
     * Perform the initialization
     */
    public void initialize() throws FrameworkException;

}
