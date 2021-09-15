package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoAccionAprobacionCaixa extends WebDto{

    private Long idTarea;

    private String comboResolucion;

    private String observacionesBC;

    private Long numOferta;

    private String codTarea;

    public Long getIdTarea() {
        return idTarea;
    }

    public void setIdTarea(Long idTarea) {
        this.idTarea = idTarea;
    }

    public String getComboResolucion() {
        return comboResolucion;
    }

    public void setComboResolucion(String comboResolucion) {
        this.comboResolucion = comboResolucion;
    }

    public String getObservacionesBC() {
        return observacionesBC;
    }

    public void setObservacionesBC(String observacionesBC) {
        this.observacionesBC = observacionesBC;
    }

    public Long getNumOferta() {
        return numOferta;
    }

    public void setNumOferta(Long numOferta) {
        this.numOferta = numOferta;
    }

    public String getCodTarea() {
        return codTarea;
    }

    public void setCodTarea(String codTarea) {
        this.codTarea = codTarea;
    }
}
