package es.capgemini.pfs.expediente;

import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Esta clase mapea una regla contra una entidad de comprobación.
 * @author pajimene
 *
 */
public class ObjetoEntidadRegla {

    /* Variables estaticas para determinar si el objeto es una persona o un contrato*/
    public static final String TIPO_PERSONA = "PER";
    public static final String TIPO_CONTRATO = "CNT";

    private Persona persona = null;
    private Contrato contrato = null;
    private Boolean cumple;
    private Boolean pase;

    /**
     * @return String
     */
    public String getNombreEntidad() {
        if (persona != null) { return persona.getApellidoNombre(); }
        if (contrato != null) { return contrato.getCodigoContrato(); }
        return "";
    }

    /**
     * @return String
     */
    public String getTipoEntidad() {
        if (persona != null) { return persona.getTipoPersona().getDescripcion(); }
        if (contrato != null) { return contrato.getTipoProducto().getDescripcion(); }
        return "";
    }

    /**
     * @param persona the persona to set
     */
    public void setEntidad(Persona persona) {
        this.persona = persona;
    }

    /**
     * @param contrato the contrato to set
     */
    public void setEntidad(Contrato contrato) {
        this.contrato = contrato;
    }

    /**
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @return the contrato
     */
    public Contrato getContrato() {
        return contrato;
    }

    /**
     * @param cumple the cumple to set
     */
    public void setCumple(Boolean cumple) {
        this.cumple = cumple;
    }

    /**
     * @return the cumple
     */
    public Boolean getCumple() {
        return cumple;
    }

    /**
     * @param pase the pase to set
     */
    public void setPase(Boolean pase) {
        this.pase = pase;
    }

    /**
     * @return the pase
     */
    public Boolean getPase() {
        return pase;
    }

    public String getTipoObjetoEntidad() {
        if (persona != null) { return TIPO_PERSONA; }
        if (contrato != null) { return TIPO_CONTRATO; }
        return "";

    }

}
