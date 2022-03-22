package es.pfsgroup.plugin.rem.model;

public class DtoCompradorLLamadaBC {

    Boolean sucessComprador;
    Boolean replicarCLiente;
    Boolean replicarOferta;
    Long idComprador;
    Long numOferta;

    public Boolean getSucessComprador() {
        return sucessComprador;
    }

    public void setSucessComprador(Boolean sucessComprador) {
        this.sucessComprador = sucessComprador;
    }

    public Boolean getReplicarCLiente() {
        return replicarCLiente;
    }

    public void setReplicarCLiente(Boolean replicarCLiente) {
        this.replicarCLiente = replicarCLiente;
    }

    public Boolean getReplicarOferta() {
        return replicarOferta;
    }

    public void setReplicarOferta(Boolean replicarOferta) {
        this.replicarOferta = replicarOferta;
    }

    public Long getIdComprador() {
        return idComprador;
    }

    public void setIdComprador(Long idComprador) {
        this.idComprador = idComprador;
    }

    public Long getNumOferta() {
        return numOferta;
    }

    public void setNumOferta(Long numOferta) {
        this.numOferta = numOferta;
    }
}
