package es.capgemini.pfs.expediente.dto;

/**
 * DTO para la creación manual del expediente.
 * @author marruiz
 */
public class DtoCreacionManualExpediente {

    private Long idExpediente;
    private Long idPersona;
    private String codigoMotivo;
    private String observaciones;
    private Boolean isSupervisor;
    private Long idPropuesta;
    private Long idArquetipo;


    /**
     * @return the idExpediente
     */
    public Long getIdExpediente() {
        return idExpediente;
    }
    /**
     * @param idExpediente the idExpediente to set
     */
    public void setIdExpediente(Long idExpediente) {
        this.idExpediente = idExpediente;
    }
    /**
     * @return the idPersona
     */
    public Long getIdPersona() {
        return idPersona;
    }
    /**
     * @param idPersona the idPersona to set
     */
    public void setIdPersona(Long idPersona) {
        this.idPersona = idPersona;
    }
    /**
     * @return the codigoMotivo
     */
    public String getCodigoMotivo() {
        return codigoMotivo;
    }
    /**
     * @param codigoMotivo the codigoMotivo to set
     */
    public void setCodigoMotivo(String codigoMotivo) {
        this.codigoMotivo = codigoMotivo;
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
     * @return the isSupervisor
     */
    public Boolean getIsSupervisor() {
        return isSupervisor;
    }
    /**
     * @param isSupervisor the isSupervisor to set
     */
    public void setIsSupervisor(Boolean isSupervisor) {
        this.isSupervisor = isSupervisor;
    }
    /**
     * @return the idPropuesta
     */
    public Long getIdPropuesta() {
        return idPropuesta;
    }
    /**
     * @param idPropuesta the idPropuesta to set
     */
    public void setIdPropuesta(Long idPropuesta) {
        this.idPropuesta = idPropuesta;
    }
	public Long getIdArquetipo() {
		return idArquetipo;
	}
	public void setIdArquetipo(Long idArquetipo) {
		this.idArquetipo = idArquetipo;
	}
}
