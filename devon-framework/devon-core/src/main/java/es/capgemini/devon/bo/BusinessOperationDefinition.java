package es.capgemini.devon.bo;

/**
 * BUsiness Operations interface
 * 
 * @author Nicolás Cornaglia
 */
public interface BusinessOperationDefinition {

    /**
     * @return
     */
    public String getType();

    /**
     * Business Operation id
     * 
     * @return
     */
    public String getId();

    /**
     * The id of the Business Operation that overrides this one
     * 
     * @return
     */
    public String getOverwrittenBy();

    /**
     * @param overwrittenBy
     */
    public void setOverwrittenBy(String overwrittenBy);

    /**
     * The id of the Business Operation being overriden by this one 
     * 
     * @return
     */
    public String getOverrides();

}
