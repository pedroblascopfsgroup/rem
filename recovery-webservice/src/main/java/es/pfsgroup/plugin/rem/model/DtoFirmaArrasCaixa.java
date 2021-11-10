package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

import java.util.Date;

public class DtoFirmaArrasCaixa extends WebDto{

    private Long idTarea;

    private Long numOferta;

    private String observacionesBC;

    private String fechaPropuesta;

    private String comboValidacionBC;

    private Long idExpediente;

    private Long idFae;

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

    public String getObservacionesBC() {
        return observacionesBC;
    }

    public void setObservacionesBC(String observacionesBC) {
        this.observacionesBC = observacionesBC;
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

    public Long getIdExpediente() {
        return idExpediente;
    }

    public void setIdExpediente(Long idExpediente) {
        this.idExpediente = idExpediente;
    }

    public Long getIdFae() {
        return idFae;
    }

    public void setIdFae(Long idFae) {
        this.idFae = idFae;
    }
}
