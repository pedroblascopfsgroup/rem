package es.capgemini.pfs.ruleengine;

/**
 * TODO DOCUMENTAR FO.
 * @author lgiavedo
 */
public class RuleExecutorConfig {

    public static final String RULE_DEFINITION_TYPE_XML = "XML";
    public static final String RULE_DEFINITION_TYPE_JSON = "JSON";

    protected String tableFrom;
    protected String tableToUpdate;
    protected String columnToUpdate;
    protected String columnFromRef;
    protected String columnToRef;
    protected String ruleDefinitionType = RULE_DEFINITION_TYPE_XML;

    public RuleExecutorConfig() {
        super();
    }

    public RuleExecutorConfig(String tableFrom, String tableToUpdate, String columnToUpdate, String columnFromRef, String columnToRef) {
        super();
        this.tableFrom = tableFrom;
        this.tableToUpdate = tableToUpdate;
        this.columnToUpdate = columnToUpdate;
        this.columnFromRef = columnFromRef;
        this.columnToRef = columnToRef;
    }

    /**
     * @return the tableFrom
     */
    public String getTableFrom() {
        return tableFrom;
    }

    /**
     * @param tableFrom the tableFrom to set
     */
    public void setTableFrom(String tableFrom) {
        this.tableFrom = tableFrom;
    }

    /**
     * @return the tableToUpdate
     */
    public String getTableToUpdate() {
        return tableToUpdate;
    }

    /**
     * @param tableToUpdate the tableToUpdate to set
     */
    public void setTableToUpdate(String tableToUpdate) {
        this.tableToUpdate = tableToUpdate;
    }

    /**
     * @return the columnToUpdate
     */
    public String getColumnToUpdate() {
        return columnToUpdate;
    }

    /**
     * @param columnToUpdate the columnToUpdate to set
     */
    public void setColumnToUpdate(String columnToUpdate) {
        this.columnToUpdate = columnToUpdate;
    }

    /**
     * @return the columnFromRef
     */
    public String getColumnFromRef() {
        return columnFromRef;
    }

    /**
     * @param columnFromRef the columnFromRef to set
     */
    public void setColumnFromRef(String columnFromRef) {
        this.columnFromRef = columnFromRef;
    }

    /**
     * @return the columnToRef
     */
    public String getColumnToRef() {
        return columnToRef;
    }

    /**
     * @param columnToRef the columnToRef to set
     */
    public void setColumnToRef(String columnToRef) {
        this.columnToRef = columnToRef;
    }

    /**
     * @return the ruleDefinitionType
     */
    public String getRuleDefinitionType() {
        return ruleDefinitionType;
    }

    /**
     * @param ruleDefinitionType the ruleDefinitionType to set
     */
    public void setRuleDefinitionType(String ruleDefinitionType) {
        this.ruleDefinitionType = ruleDefinitionType;
    }

    public boolean isJsonDefinition() {
        if (RULE_DEFINITION_TYPE_JSON.equals(ruleDefinitionType)) return true;
        return false;
    }

    public boolean isXmlDefinition() {
        if (RULE_DEFINITION_TYPE_XML.equals(ruleDefinitionType)) return true;
        return false;
    }
}
