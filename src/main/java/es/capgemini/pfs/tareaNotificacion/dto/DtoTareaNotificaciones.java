package es.capgemini.pfs.tareaNotificacion.dto;

import java.io.Serializable;

import org.springframework.security.userdetails.UserDetails;

import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

/**
 * Clase que transfiere información a la vista con la tarea y la info calculada que necesiten.
 * @author pamuller
 *
 */
public class DtoTareaNotificaciones implements Serializable {

    /**
     *
     */
    private static final long serialVersionUID = 6877735449127132292L;
    private TareaNotificacion tarea;
    private Integer plazo;
    private String plazoDias;
    private UserDetails usuarioDetails;

    /**
     * getUsuarioDetails.
     * @return usuario
     */
    public UserDetails getUsuarioDetails() {
        return usuarioDetails;
    }

    /**
     * setUsuarioDetails.
     * @param usuarioDetails usuarioDetails
     */
    public void setUsuarioDetails(UserDetails usuarioDetails) {
        this.usuarioDetails = usuarioDetails;
    }

    /**
     * @return the tarea
     */
    public TareaNotificacion getTarea() {
        return tarea;
    }

    /**
     * @param tarea the tarea to set
     */
    public void setTarea(TareaNotificacion tarea) {
        this.tarea = tarea;
    }

    /**
     * @return the plazo
     */
    public Integer getPlazo() {
        return plazo;
    }

    /**
     * @param plazo the plazo to set
     */
    public void setPlazo(Integer plazo) {
        this.plazo = plazo;
    }

	/**
	 * @return the plazoDias
	 */
	public String getPlazoDias() {
		return plazoDias;
	}

	/**
	 * @param plazoDias the plazoDias to set
	 */
	public void setPlazoDias(String plazoDias) {
		this.plazoDias = plazoDias;
	}

}
