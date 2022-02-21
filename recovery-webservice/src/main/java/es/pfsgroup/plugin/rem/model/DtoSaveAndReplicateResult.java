package es.pfsgroup.plugin.rem.model;

public class DtoSaveAndReplicateResult {

    private boolean replicateToBc;
    private boolean success;
    private Long numOferta;


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
}
