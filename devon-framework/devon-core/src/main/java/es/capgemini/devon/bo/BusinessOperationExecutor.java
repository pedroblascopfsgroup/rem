package es.capgemini.devon.bo;

/**
 * TODO Documentar
 * 
 * @author Nicolás Cornaglia
 */
public interface BusinessOperationExecutor {

    /**
     * @return
     */
    public abstract String getType();

    /**
     * @param target
     * @param arg
     * @return
     */
    public abstract Object execute(BusinessOperationDefinition definition, Object[] args);

}
