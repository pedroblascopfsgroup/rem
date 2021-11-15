package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoOnlyExpedienteOfertaCaixaYFecha extends WebDto {

    private Long idExpediente;

    private Long numOferta;

    private String fechaReal;

    public Long getIdExpediente() {
        return idExpediente;
    }

    public void setIdExpediente(Long idExpediente) {
        this.idExpediente = idExpediente;
    }

    public Long getNumOferta() {
        return numOferta;
    }

    public void setNumOferta(Long numOferta) {
        this.numOferta = numOferta;
    }

    public String getFechaReal() {
        return fechaReal;
    }

    public void setFechaReal(String fechaReal) {
        this.fechaReal = fechaReal;
    }
}
