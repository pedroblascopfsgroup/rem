package es.pfsgroup.recovery.bpmframework.api.config;

import java.io.Serializable;

/**
 * DTO con información sobre el nombre y el grupo de un determinado dato
 * 
 * @author bruno
 * 
 */
public class RecoveryBPMfwkGrupoDatoDto implements Serializable {

	private static final long serialVersionUID = -5002297664071277385L;

    private String nombreInput;

    private String grupo;

    private String dato;

    /**
     * Devuelve el nombre que tiene el dato en el input
     * 
     * @return
     */
    public String getNombreInput() {
        return nombreInput;
    }

    /**
     * Setea el nombre que tienen el dato en el input
     * 
     * @param nombreInput
     */
    public void setNombreInput(final String nombreInput) {
        this.nombreInput = nombreInput;
    }

    /**
     * Devuelve el grupo al que pertenece el dato en el procedimiento
     * 
     * @return
     */
    public String getGrupo() {
        return grupo;
    }

    /**
     * Setea el nombre del grupo al que pertenede el dato en el procedimiento.
     * 
     * @param grupo
     */
    public void setGrupo(final String grupo) {
        this.grupo = grupo;
    }

    /**
     * Devuelve el nombre del dato en el procedimiento.
     * 
     * @return
     */
    public String getDato() {
        return dato;
    }

    /**
     * Setea el nombre del dato en el procedimiento.
     * 
     * @param dato
     */
    public void setDato(final String dato) {
        this.dato = dato;
    }
    
    @Override
	public String toString() {
		return "RecoveryBPMfwkGrupoDatoDto [nombreInput=" + nombreInput
				+ ", grupo=" + grupo + ", dato=" + dato + "]";
	}

}
