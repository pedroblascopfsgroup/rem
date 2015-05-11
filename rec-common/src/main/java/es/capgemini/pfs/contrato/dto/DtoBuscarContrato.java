package es.capgemini.pfs.contrato.dto;

import es.capgemini.devon.dto.WebDto;

/**
 * Clase que contiene los parámetros utilizados para realizar una búsqueda de contratos.
 */
public class DtoBuscarContrato extends WebDto {

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = 7663286400234504864L;

    private Long id;

    private Boolean pase;

    private Long idExpediente;

    private Long idPersona;

    private Integer tipoBusquedaPersona;

    private Long idProcedimiento;

    /**
     * @return the pase
     */
    public Boolean getPase() {
        return pase;
    }

    /**
     * @param pase the pase to set
     */
    public void setPase(Boolean pase) {
        this.pase = pase;
    }

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
     * @return the tipoBusquedaPersona
     */
    public Integer getTipoBusquedaPersona() {
        return tipoBusquedaPersona;
    }

    /**
     * @param tipoBusquedaPersona the tipoBusquedaPersona to set
     */
    public void setTipoBusquedaPersona(Integer tipoBusquedaPersona) {
        this.tipoBusquedaPersona = tipoBusquedaPersona;
    }

    /**
     * Retorna el atributo id.
     * @return id
     */
    public Long getId() {
        return id;
    }

    /**
     * Setea el atributo id.
     * @param id Long
     */
    public void setId(Long id) {
        this.id = id;
    }

	/**
	 * @return the idProcedimiento
	 */
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	/**
	 * @param idProcedimiento the idProcedimiento to set
	 */
	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}
}
