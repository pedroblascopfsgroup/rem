package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.web.dto;

import java.io.Serializable;

public class GestorWebDto implements Serializable {

    /**
     * 
     */
    private static final long serialVersionUID = -1664036222426586868L;

    private Long id;
    private String nombre;
    private String username;
    private boolean tieneEmail;
    
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public void setTieneEmail(boolean tieneEmail) {
		this.tieneEmail = tieneEmail;
	}

	public boolean isTieneEmail() {
		return tieneEmail;
	}
	public boolean getTieneEmail() {
		return tieneEmail;
	}

}
