package es.capgemini.pfs.scoring.dto;

/**
 * Pseudo modelo de Alerta que no tiene relacion con hibernate.
 * @author aesteban
 *
 */
public class DtoAlerta {

    private Long personaId;
    private String codigoTipoAlerta;
    private String codigoNivelGravedad;
    /**
     * Codigo del segmento de la persona relacionada a la alerta.
     */
    private String codigoSegmento;
    /**
     * Codigo del tipo de persona de la persona relacionada a la alerta.
     */
    private String codigoTipoPersona;

    private Float riesgoPersona;

    /**
     * @return the personaId
     */
    public Long getPersonaId() {
        return personaId;
    }

    /**
     * @param personaId the personaId to set
     */
    public void setPersonaId(Long personaId) {
        this.personaId = personaId;
    }

    /**
     * @return the codigoTipoAlerta
     */
    public String getCodigoTipoAlerta() {
        return codigoTipoAlerta;
    }

    /**
     * @param codigoTipoAlerta the codigoTipoAlerta to set
     */
    public void setCodigoTipoAlerta(String codigoTipoAlerta) {
        this.codigoTipoAlerta = codigoTipoAlerta;
    }

    /**
     * @return the codigoNivelGravedad
     */
    public String getCodigoNivelGravedad() {
        return codigoNivelGravedad;
    }

    /**
     * @param codigoNivelGravedad the codigoNivelGravedad to set
     */
    public void setCodigoNivelGravedad(String codigoNivelGravedad) {
        this.codigoNivelGravedad = codigoNivelGravedad;
    }

    /**
     * @return the codigoSegmento
     */
    public String getCodigoSegmento() {
        return codigoSegmento;
    }

    /**
     * @param codigoSegmento the codigoSegmento to set
     */
    public void setCodigoSegmento(String codigoSegmento) {
        this.codigoSegmento = codigoSegmento;
    }

    /**
     * @return the codigoTipoPersona
     */
    public String getCodigoTipoPersona() {
        return codigoTipoPersona;
    }

    /**
     * @param codigoTipoPersona the codigoTipoPersona to set
     */
    public void setCodigoTipoPersona(String codigoTipoPersona) {
        this.codigoTipoPersona = codigoTipoPersona;
    }

    /**
     * @return the riesgoPersona
     */
    public Float getRiesgoPersona() {
        return riesgoPersona;
    }

    /**
     * @param riesgoPersona the riesgoPersona to set
     */
    public void setRiesgoPersona(Float riesgoPersona) {
        this.riesgoPersona = riesgoPersona;
    }

}
