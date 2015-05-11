package es.capgemini.pfs.ruleengine;

/**
 * Clase que determinar el resultado de implantacion de una regla
 *
 * @author lgiavedo
 *
 */
public class RuleResult {

    public static final int STATUS_FINISHED_OK = 1;
    public static final int STATUS_FINISHED_WITH_ERRORS = -1;
    public static final int STATUS_FINISHED_WITH_WARNINGS = -2;
    public static final int STATUS_UNKNOWN = 0;

    private long ini_time;
    private long end_time;
    private long rowsModified = -1L;
    private String ruleName;
    private int status = STATUS_UNKNOWN;
    private String error;
    private String warning;

    public RuleResult(String ruleName) {
        super();
        this.ruleName = ruleName;
    }

    public RuleResult() {
        super();
    }

    public void start() {
        ini_time = System.currentTimeMillis();
    }

    /**
     * @return the time
     */
    public long getTimeInSeconds() {
        return (end_time - ini_time) / 1000;
    }

    /**
     * @return the rowsModified
     */
    public long getRowsModified() {
        return rowsModified;
    }

    /**
     * @param rowsModified the rowsModified to set
     */
    public void setRowsModified(long rowsModified) {
        this.rowsModified = rowsModified;
    }

    /**
     * @return the ruleName
     */
    public String getRuleName() {
        return ruleName;
    }

    /**
     * @param ruleName the ruleName to set
     */
    public void setRuleName(String ruleName) {
        this.ruleName = ruleName;
    }

    public String getWarning() {
        return warning;
    }

    public String getError() {
        return error;
    }

    public void finishOK(long rowsModified) {
        status = STATUS_FINISHED_OK;
        end_time = System.currentTimeMillis();
        this.rowsModified = rowsModified;
    }

    public void finishWithErrors(String e) {
        status = STATUS_FINISHED_WITH_ERRORS;
        error = e.toString();
    }

    public void finishWithWarnings(String w) {
        status = STATUS_FINISHED_WITH_WARNINGS;
        warning = w;
    }

    public void finishWithErrors(Exception e) {
        finishWithErrors(e.getStackTrace().toString());
    }

    public boolean isFinishedOK() {
        return status == STATUS_FINISHED_OK ? true : false;
    }

    public boolean isFinishedOK(boolean allowWarnings) {
        if (allowWarnings == false) { return isFinishedOK(); }

        if (isFinishedOK() || status == STATUS_FINISHED_WITH_WARNINGS) { return true; }
        return false;
    }

}
