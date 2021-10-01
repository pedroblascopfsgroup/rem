package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoAccionRechazoCaixa extends WebDto {

    private Long idExpediente;

    private Long numOferta;

    private String tipoArras;

    private String motivoAnulacion;

    private String estadoReserva;

    private Long idTarea;

    private String estadoBc;

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

    public String getTipoArras() {
        return tipoArras;
    }

    public void setTipoArras(String tipoArras) {
        this.tipoArras = tipoArras;
    }

    public String getMotivoAnulacion() {
        return motivoAnulacion;
    }

    public void setMotivoAnulacion(String motivoAnulacion) {
        this.motivoAnulacion = motivoAnulacion;
    }

    public String getEstadoReserva() {
        return estadoReserva;
    }

    public void setEstadoReserva(String estadoReserva) {
        this.estadoReserva = estadoReserva;
    }

    public Long getIdTarea() {
        return idTarea;
    }

    public void setIdTarea(Long idTarea) {
        this.idTarea = idTarea;
    }

    public String getEstadoBc() {
        return estadoBc;
    }

    public void setEstadoBc(String estadoBc) {
        this.estadoBc = estadoBc;
    }
}
