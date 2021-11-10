package es.pfsgroup.plugin.rem.model;

public class LlamadaPbcDto {

    private Long numOferta;

    private String codAccion;

    private String descripcionAccion;

    private String motivo;

    private String riesgoOperacion;

    private String fechaReal;

    private Long numInterlocutor;

    public Long getNumOferta() {
        return numOferta;
    }

    public void setNumOferta(Long numOferta) {
        this.numOferta = numOferta;
    }

    public String getCodAccion() {
        return codAccion;
    }

    public void setCodAccion(String codAccion) {
        this.codAccion = codAccion;
    }

    public String getDescripcionAccion() {
        return descripcionAccion;
    }

    public void setDescripcionAccion(String descripcionAccion) {
        this.descripcionAccion = descripcionAccion;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getRiesgoOperacion() {
        return riesgoOperacion;
    }

    public void setRiesgoOperacion(String riesgoOperacion) {
        this.riesgoOperacion = riesgoOperacion;
    }

    public String getFechaReal() {
        return fechaReal;
    }

    public void setFechaReal(String fechaReal) {
        this.fechaReal = fechaReal;
    }

    public Long getNumInterlocutor() {
        return numInterlocutor;
    }

    public void setNumInterlocutor(Long numInterlocutor) {
        this.numInterlocutor = numInterlocutor;
    }
}
