package es.pfsgroup.plugin.rem.model;

public class DtoSaveAndReplicateResult {

    private boolean replicateToBc;
    private boolean success;
    private Long numOferta;
    private String message;


    public boolean isReplicateToBc() {
        return replicateToBc;
    }

    public void setReplicateToBc(boolean replicateToBc) {
        this.replicateToBc = replicateToBc;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public Long getNumOferta() {
        return numOferta;
    }

    public void setNumOferta(Long numOferta) {
        this.numOferta = numOferta;
    }

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
    
    
}
