package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoOnlyExpedienteYOfertaCaixa extends WebDto {

    private Long idExpediente;

    private Long numOferta;

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
}
