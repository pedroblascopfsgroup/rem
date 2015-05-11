package es.capgemini.pfs.politica.model;

/**
 * Objetivo que sive para agrupar la información del usuario conectado con respecto a los objetivos de una política.
 * @author pajimene
 *
 */
public class ObjetoPermisosGestionObjetivos {

    private Boolean esGestorExpediente;
    private Boolean esSupervisorExpediente;
    private Boolean esGestorObjetivos;
    private Boolean esSupervisorObjetivos;
    private Boolean esVigente;
    private Boolean esPropuesta;
    private Boolean esPropuestaSuperusuario;

    /**
     * @return the esPropuestaSuperusuario
     */
    public Boolean getEsPropuestaSuperusuario() {
        return esPropuestaSuperusuario;
    }

    /**
     * @param esPropuestaSuperusuario the esPropuestaSuperusuario to set
     */
    public void setEsPropuestaSuperusuario(Boolean esPropuestaSuperusuario) {
        this.esPropuestaSuperusuario = esPropuestaSuperusuario;
    }

    /**
     * @return the esGestorObjetivos
     */
    public Boolean getEsGestorObjetivos() {
        return esGestorObjetivos;
    }

    /**
     * @param esGestorObjetivos the esGestorObjetivos to set
     */
    public void setEsGestorObjetivos(Boolean esGestorObjetivos) {
        this.esGestorObjetivos = esGestorObjetivos;
    }

    /**
     * @return the esSupervisorObjetivos
     */
    public Boolean getEsSupervisorObjetivos() {
        return esSupervisorObjetivos;
    }

    /**
     * @param esSupervisorObjetivos the esSupervisorObjetivos to set
     */
    public void setEsSupervisorObjetivos(Boolean esSupervisorObjetivos) {
        this.esSupervisorObjetivos = esSupervisorObjetivos;
    }

    /**
     * @return the esVigente
     */
    public Boolean getEsVigente() {
        return esVigente;
    }

    /**
     * @param esVigente the esVigente to set
     */
    public void setEsVigente(Boolean esVigente) {
        this.esVigente = esVigente;
    }

    /**
     * @return the esPropuesta
     */
    public Boolean getEsPropuesta() {
        return esPropuesta;
    }

    /**
     * @param esPropuesta the esPropuesta to set
     */
    public void setEsPropuesta(Boolean esPropuesta) {
        this.esPropuesta = esPropuesta;
    }

    /**
     * @return the esGestor
     */
    public Boolean getEsGestorExpediente() {
        return esGestorExpediente;
    }

    /**
     * @param esGestorExpediente the esGestorExpediente to set
     */
    public void setEsGestorExpediente(Boolean esGestorExpediente) {
        this.esGestorExpediente = esGestorExpediente;
    }

    /**
     * @return the esSupervisor
     */
    public Boolean getEsSupervisorExpediente() {
        return esSupervisorExpediente;
    }

    /**
     * @param esSupervisorExpediente the esSupervisorExpediente to set
     */
    public void setEsSupervisorExpediente(Boolean esSupervisorExpediente) {
        this.esSupervisorExpediente = esSupervisorExpediente;
    }
}
