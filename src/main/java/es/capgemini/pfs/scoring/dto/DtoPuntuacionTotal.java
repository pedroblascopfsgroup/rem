package es.capgemini.pfs.scoring.dto;

/**
 * Pseudo modelo de puntacion total que no tiene relacion con hibernate.
 * @author aesteban
 *
 */
public class DtoPuntuacionTotal {

    private Long puntuacion;
    private Float volumenRiesgoCliente;
    private Integer rating;
    private Integer rangoIntervalo;
    private String intervalo;
    private Integer rangoVolumenRiesgoCliente;
    private Long personaId;

    /**
     * @return the rangoVolumenRiesgoCliente
     */
    public Integer getRangoVolumenRiesgoCliente() {
        return rangoVolumenRiesgoCliente;
    }

    /**
     * @param rangoVolumenRiesgoCliente the rangoVolumenRiesgoCliente to set
     */
    public void setRangoVolumenRiesgoCliente(Integer rangoVolumenRiesgoCliente) {
        this.rangoVolumenRiesgoCliente = rangoVolumenRiesgoCliente;
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
     * @return the volumenRiesgoCliente
     */
    public Float getVolumenRiesgoCliente() {
        return volumenRiesgoCliente;
    }

    /**
     * @param volumenRiesgoCliente the volumenRiesgoCliente to set
     */
    public void setVolumenRiesgoCliente(Float volumenRiesgoCliente) {
        this.volumenRiesgoCliente = volumenRiesgoCliente;
    }

    /**
     * @return the rating
     */
    public Integer getRating() {
        return rating;
    }

    /**
     * @param rating the rating to set
     */
    public void setRating(Integer rating) {
        this.rating = rating;
    }

    /**
     * @return the rangoIntervalo
     */
    public Integer getRangoIntervalo() {
        return rangoIntervalo;
    }

    /**
     * @param rangoIntervalo the rangoIntervalo to set
     */
    public void setRangoIntervalo(Integer rangoIntervalo) {
        this.rangoIntervalo = rangoIntervalo;
    }

    /**
     * @return the intervalo
     */
    public String getIntervalo() {
        return intervalo;
    }

    /**
     * @param intervalo the intervalo to set
     */
    public void setIntervalo(String intervalo) {
        this.intervalo = intervalo;
    }

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
}
