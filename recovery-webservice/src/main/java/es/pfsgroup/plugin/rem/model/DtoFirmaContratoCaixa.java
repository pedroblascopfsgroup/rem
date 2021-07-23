package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

import java.util.Date;

public class DtoFirmaContratoCaixa extends WebDto{

    private Long idTarea;

    private Long numOferta;

    private Long idExpediente;

    private String fechaRespuesta;

    private String fechaPropuesta;

    private String comboValidacionBC;

    private String observacionesBC;

    public Long getIdTarea() {
        return idTarea;
    }

    public void setIdTarea(Long idTarea) {
        this.idTarea = idTarea;
    }

    public Long getNumOferta() {
        return numOferta;
    }

    public void setNumOferta(Long numOferta) {
        this.numOferta = numOferta;
    }

    public Long getIdExpediente() {
        return idExpediente;
    }

    public void setIdExpediente(Long idExpediente) {
        this.idExpediente = idExpediente;
    }

    public String getFechaRespuesta() {
        return fechaRespuesta;
    }

    public void setFechaRespuesta(String fechaRespuesta) {
        this.fechaRespuesta = fechaRespuesta;
    }

    public String getFechaPropuesta() {
        return fechaPropuesta;
    }

    public void setFechaPropuesta(String fechaPropuesta) {
        this.fechaPropuesta = fechaPropuesta;
    }

    public String getComboValidacionBC() {
        return comboValidacionBC;
    }

    public void setComboValidacionBC(String comboValidacionBC) {
        this.comboValidacionBC = comboValidacionBC;
    }

    public String getObservacionesBC() {
        return observacionesBC;
    }

    public void setObservacionesBC(String observacionesBC) {
        this.observacionesBC = observacionesBC;
    }
}
