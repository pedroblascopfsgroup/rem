package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoAvanzaScoringBC extends WebDto{

    private Long idTarea;

    private Long numOferta;

    private String comboResultado;

    private String observaciones;

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

    public String getComboResultado() {
        return comboResultado;
    }

    public void setComboResultado(String comboResultado) {
        this.comboResultado = comboResultado;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }
}
