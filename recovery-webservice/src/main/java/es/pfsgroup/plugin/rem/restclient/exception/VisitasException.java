package es.pfsgroup.plugin.rem.restclient.exception;

public class VisitasException extends RestClientException{
    private static final long serialVersionUID = 777435050968060924L;
    private String errorFieldName;

    public VisitasException(String fieldName, String errorMsg){
        super(errorMsg);
        this.errorFieldName = fieldName;
    }

    public String getErrorFieldName() {
        return errorFieldName;
    }

    public void setErrorFieldName(String errorFieldName) {
        this.errorFieldName = errorFieldName;
    }
}
