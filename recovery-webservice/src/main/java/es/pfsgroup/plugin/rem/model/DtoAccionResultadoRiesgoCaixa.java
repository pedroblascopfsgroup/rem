package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoAccionResultadoRiesgoCaixa extends WebDto {

    private Long idExpediente;

    private Long numOferta;

    private String riesgoOperacion;

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

    public String getRiesgoOperacion() {
        return riesgoOperacion;
    }

    public void setRiesgoOperacion(String riesgoOperacion) {
        this.riesgoOperacion = riesgoOperacion;
    }
}
