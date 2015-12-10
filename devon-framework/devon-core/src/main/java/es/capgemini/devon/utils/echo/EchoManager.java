package es.capgemini.devon.utils.echo;

import es.capgemini.devon.bo.FwkBusinessOperations;
import es.capgemini.devon.bo.annotations.BusinessOperation;

/**
 * @author Nicolás Cornaglia
 */
public interface EchoManager {

    @BusinessOperation(FwkBusinessOperations.ECHO)
    public String echo(String echo);

    @BusinessOperation(FwkBusinessOperations.TRANSACTIONAL_ECHO)
    public String transactionalEcho(String echo);

}
