package es.capgemini.pfs.analisisExterna.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import es.capgemini.pfs.analisisExterna.model.DDPlazoAceptacion;

/**
 * DTO para el reporte de Analisis Externa.
 * @author marruiz
 */
public class DtoAnalisisExterna implements Serializable {

    private static final long serialVersionUID = -2289729854625004191L;

    private String tipoSalida;
    private Date fechaCarga;
    private DDPlazoAceptacion plazoAceptacion;
    private String tiposProcedimiento;
    private String despachos;
    private String supervisores;
    private String gestores;
    private String fasesProcesal;
    private Boolean procedimientosActivos;

    private List<DtoAnalisisExternaTabla> data;

    /**
     * @return the data
     */
    public List<DtoAnalisisExternaTabla> getData() {
        return data;
    }

    /**
     * @param data the data to set
     */
    public void setData(List<DtoAnalisisExternaTabla> data) {
        this.data = data;
    }

    /**
     * @return the tipoSalida
     */
    public String getTipoSalida() {
        return tipoSalida;
    }

    /**
     * @param tipoSalida the tipoSalida to set
     */
    public void setTipoSalida(String tipoSalida) {
        this.tipoSalida = tipoSalida;
    }

    /**
     * @return the fechaCarga
     */
    public Date getFechaCarga() {
        return fechaCarga;
    }

    /**
     * @param fechaCarga the fechaCarga to set
     */
    public void setFechaCarga(Date fechaCarga) {
        this.fechaCarga = fechaCarga;
    }

    /**
     * @return the fasesProcesal
     */
    public String getFasesProcesal() {
        return fasesProcesal;
    }

    /**
     * @param fasesProcesal the fasesProcesal to set
     */
    public void setFasesProcesal(String fasesProcesal) {
        this.fasesProcesal = fasesProcesal;
    }

    /**
     * @return the plazoAceptacion
     */
    public DDPlazoAceptacion getPlazoAceptacion() {
        return plazoAceptacion;
    }

    /**
     * @param plazoAceptacion the plazoAceptacion to set
     */
    public void setPlazoAceptacion(DDPlazoAceptacion plazoAceptacion) {
        this.plazoAceptacion = plazoAceptacion;
    }

    /**
     * @return the tiposProcedimiento
     */
    public String getTiposProcedimiento() {
        return tiposProcedimiento;
    }

    /**
     * @param tiposProcedimiento the tiposProcedimiento to set
     */
    public void setTiposProcedimiento(String tiposProcedimiento) {
        this.tiposProcedimiento = tiposProcedimiento;
    }

    /**
     * @return the despachos
     */
    public String getDespachos() {
        return despachos;
    }

    /**
     * @param despachos the despachos to set
     */
    public void setDespachos(String despachos) {
        this.despachos = despachos;
    }

    /**
     * @return the supervisores
     */
    public String getSupervisores() {
        return supervisores;
    }

    /**
     * @param supervisores the supervisores to set
     */
    public void setSupervisores(String supervisores) {
        this.supervisores = supervisores;
    }

    /**
     * @return the gestores
     */
    public String getGestores() {
        return gestores;
    }

    /**
     * @param gestores the gestores to set
     */
    public void setGestores(String gestores) {
        this.gestores = gestores;
    }

    /**
     * @param procedimientosActivos the procedimientosActivos to set
     */
    public void setProcedimientosActivos(Boolean procedimientosActivos) {
        this.procedimientosActivos = procedimientosActivos;
    }

    /**
     * @return the procedimientosActivos
     */
    public Boolean getProcedimientosActivos() {
        return procedimientosActivos;
    }
}
