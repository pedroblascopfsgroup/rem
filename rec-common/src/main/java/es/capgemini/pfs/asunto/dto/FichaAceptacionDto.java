package es.capgemini.pfs.asunto.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * DTO la ficha de aceptación.
 * @author pamuller
 *
 */
public class FichaAceptacionDto extends WebDto {

    private static final long serialVersionUID = -3405426745721715825L;

    public static final Long ACEPTAR = 1L;
    public static final Long DEVOLVER = 2L;
    public static final Long ELEVAR_COMITE = 3L;
    public static final Long EDITAR = 4L;

    private Long idAsunto;
    private Long accion;
    private Boolean conflicto;
    private Boolean aceptacion;
    private Boolean documentacionRecibida;
    private String observaciones;
    /** Fecha de Recepción de la Documentación.	*/
    private String fechaRecepDoc;

    /**
     * @return the fechaRecepDoc
     */
    public String getFechaRecepDoc() {
        return fechaRecepDoc;
    }

    /**
     * @param fechaRecepDoc the fechaRecepDoc to set
     */
    public void setFechaRecepDoc(String fechaRecepDoc) {
        this.fechaRecepDoc = fechaRecepDoc;
    }

    /**
     * @return the conflicto
     */
    public Boolean getConflicto() {
        return conflicto;
    }

    /**
     * @param conflicto the conflicto to set
     */
    public void setConflicto(Boolean conflicto) {
        this.conflicto = conflicto;
    }

    /**
     * @return the aceptacion
     */
    public Boolean getAceptacion() {
        return aceptacion;
    }

    /**
     * @param aceptacion the aceptacion to set
     */
    public void setAceptacion(Boolean aceptacion) {
        this.aceptacion = aceptacion;
    }

    /**
     * @return the documentacionRecibida
     */
    public Boolean getDocumentacionRecibida() {
        return documentacionRecibida;
    }

    /**
     * @param documentacionRecibida the documentacionRecibida to set
     */
    public void setDocumentacionRecibida(Boolean documentacionRecibida) {
        this.documentacionRecibida = documentacionRecibida;
    }

    /**
     * @return the observaciones
     */
    public String getObservaciones() {
        return observaciones;
    }

    /**
     * @param observaciones the observaciones to set
     */
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    /**
     * @return the idAsunto
     */
    public Long getIdAsunto() {
        return idAsunto;
    }

    /**
     * @param idAsunto the idAsunto to set
     */
    public void setIdAsunto(Long idAsunto) {
        this.idAsunto = idAsunto;
    }

    /**
     * @return the accion
     */
    public Long getAccion() {
        return accion;
    }

    /**
     * @param accion the accion to set
     */
    public void setAccion(Long accion) {
        this.accion = accion;
    }

}
