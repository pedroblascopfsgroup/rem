package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

/**
 * Modelo que gestiona la informacion de los adjuntos.
 */

public class DtoOrganismos implements Serializable{

	private static final long serialVersionUID = -7785802535778510517L;

    private Long idOrganismo;
    
    private String organismo;
    
    private String organismoDesc;
    
    private String comunidadAutonoma;   
    
    private String comunidadAutonomaDesc;   
   
    private Date fechaOrganismo;

    private String tipoActuacion;
    
    private String tipoActuacionDesc;
    
    private String gestorOrganismo;

	public Long getIdOrganismo() {
		return idOrganismo;
	}

	public void setIdOrganismo(Long idOrganismo) {
		this.idOrganismo = idOrganismo;
	}

	public String getOrganismo() {
		return organismo;
	}

	public void setOrganismo(String organismo) {
		this.organismo = organismo;
	}

	public String getOrganismoDesc() {
		return organismoDesc;
	}

	public void setOrganismoDesc(String organismoDesc) {
		this.organismoDesc = organismoDesc;
	}

	public String getComunidadAutonoma() {
		return comunidadAutonoma;
	}

	public void setComunidadAutonoma(String comunidadAutonoma) {
		this.comunidadAutonoma = comunidadAutonoma;
	}

	public String getComunidadAutonomaDesc() {
		return comunidadAutonomaDesc;
	}

	public void setComunidadAutonomaDesc(String comunidadAutonomaDesc) {
		this.comunidadAutonomaDesc = comunidadAutonomaDesc;
	}

	public Date getFechaOrganismo() {
		return fechaOrganismo;
	}

	public void setFechaOrganismo(Date fechaOrganismo) {
		this.fechaOrganismo = fechaOrganismo;
	}

	public String getTipoActuacion() {
		return tipoActuacion;
	}

	public void setTipoActuacion(String tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
	}

	public String getTipoActuacionDesc() {
		return tipoActuacionDesc;
	}

	public void setTipoActuacionDesc(String tipoActuacionDesc) {
		this.tipoActuacionDesc = tipoActuacionDesc;
	}

	public String getGestorOrganismo() {
		return gestorOrganismo;
	}

	public void setGestorOrganismo(String gestorOrganismo) {
		this.gestorOrganismo = gestorOrganismo;
	}

	
}
