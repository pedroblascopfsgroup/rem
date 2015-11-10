package es.capgemini.pfs.politica.dto;

import java.io.Serializable;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.politica.model.Politica;

/**
 * @author Andrés Esteban
 *
 */
public class DtoPolitica extends WebDto implements Serializable {

    private static final long serialVersionUID = -1739794541044723181L;
    private Politica politica;
    private Long idPersona;
    private Long idExpediente;
    private Long idCicloMarcadoPolitica;
    private String codigoTipoPolitica;
    private String codigoGestorPerfil;
    private String codigoGestorZona;
    private String codigoSupervisorPerfil;
    private String codigoSupervisorZona;
    private String motivo;
    private String fecha;

    /**
     * @return the politica
     */
    public Politica getPolitica() {
        return politica;
    }

    /**
     * @param politica the politica to set
     */
    public void setPolitica(Politica politica) {
        this.politica = politica;
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
     * @return the codigoTipoPolitica
     */
    public String getCodigoTipoPolitica() {
        return codigoTipoPolitica;
    }

    /**
     * @param codigoTipoPolitica the codigoTipoPolitica to set
     */
    public void setCodigoTipoPolitica(String codigoTipoPolitica) {
        this.codigoTipoPolitica = codigoTipoPolitica;
    }

    /**
     * @return the idGestorPerfil
     */
    public String getCodigoGestorPerfil() {
        return codigoGestorPerfil;
    }

    /**
     * @param idGestorPerfil the idGestorPerfil to set
     */
    public void setCodigoGestorPerfil(String idGestorPerfil) {
        this.codigoGestorPerfil = idGestorPerfil;
    }

    /**
     * @return the idGestorZona
     */
    public String getCodigoGestorZona() {
        return codigoGestorZona;
    }

    /**
     * @param codigoGestorZona the codigoGestorZona to set
     */
    public void setCodigoGestorZona(String codigoGestorZona) {
        this.codigoGestorZona = codigoGestorZona;
    }

    /**
     * @return the idSupervisorPerfil
     */
    public String getCodigoSupervisorPerfil() {
        return codigoSupervisorPerfil;
    }

    /**
     * @param idSupervisorPerfil the idSupervisorPerfil to set
     */
    public void setCodigoSupervisorPerfil(String idSupervisorPerfil) {
        this.codigoSupervisorPerfil = idSupervisorPerfil;
    }

    /**
     * @return the idSupervisorZona
     */
    public String getCodigoSupervisorZona() {
        return codigoSupervisorZona;
    }

    /**
     * @param idSupervisorZona the idSupervisorZona to set
     */
    public void setCodigoSupervisorZona(String idSupervisorZona) {
        this.codigoSupervisorZona = idSupervisorZona;
    }

    /**
     * @param idCicloMarcadoPolitica the idCicloMarcadoPolitica to set
     */
    public void setIdCicloMarcadoPolitica(Long idCicloMarcadoPolitica) {
        this.idCicloMarcadoPolitica = idCicloMarcadoPolitica;
    }

    /**
     * @return the idCicloMarcadoPolitica
     */
    public Long getIdCicloMarcadoPolitica() {
        return idCicloMarcadoPolitica;
    }

    /**
     * @param idExpediente the idExpediente to set
     */
    public void setIdExpediente(Long idExpediente) {
        this.idExpediente = idExpediente;
    }

    /**
     * @return the idExpediente
     */
    public Long getIdExpediente() {
        return idExpediente;
    }

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

}
