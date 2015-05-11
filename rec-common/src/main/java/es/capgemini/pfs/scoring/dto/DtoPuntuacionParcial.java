package es.capgemini.pfs.scoring.dto;

/**
 * Pseudo modelo de puntacion parcial que no tiene relacion con hibernate.
 * @author aesteban
 *
 */
public class DtoPuntuacionParcial {

    private Long personaId;
    private Long puntuacion;
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
     * @return the puntuacion
     */
    public Long getPuntuacion() {
        return puntuacion;
    }

    /**
     * @param puntuacion the puntuacion to set
     */
    public void setPuntuacion(Long puntuacion) {
        this.puntuacion = puntuacion;
    }

    /**
     * @return the riesgoPersona
     */
    public Float getRiesgoPersona() {
        return riesgoPersona != null ? riesgoPersona : 0F;
    }

    /**
     * @param riesgoPersona the riesgoPersona to set
     */
    public void setRiesgoPersona(Float riesgoPersona) {
        this.riesgoPersona = riesgoPersona;
    }

}
