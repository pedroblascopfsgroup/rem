package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_GESTORES_SUSTITUTOS", schema = "${entity.schema}")
public class VBusquedaGestoresSustitutos implements Serializable {	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "SGS_ID")
	private Long id;	

    @Column(name = "USERNAME_ORI")
    private String usernameOrigen;
    
    @Column(name = "USERNAME_SUS")
    private String usernameSustituto;
    
    @Column(name = "NOMBRE_ORI")
    private String nombreOrigen;
    
    @Column(name = "NOMBRE_SUS")
    private String nombreSustituto;
    
    @Column(name = "FECHA_INICIO")
    private Date fechaInicio;
    
    @Column(name = "FECHA_FIN")
    private Date fechaFin;
    
    @Column(name = "VIGENTE")
    private Boolean vigente;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getUsernameOrigen() {
		return usernameOrigen;
	}

	public void setUsernameOrigen(String usernameOrigen) {
		this.usernameOrigen = usernameOrigen;
	}

	public String getUsernameSustituto() {
		return usernameSustituto;
	}

	public void setUsernameSustituto(String usernameSustituto) {
		this.usernameSustituto = usernameSustituto;
	}

	public String getNombreOrigen() {
		return nombreOrigen;
	}

	public void setNombreOrigen(String nombreOrigen) {
		this.nombreOrigen = nombreOrigen;
	}

	public String getNombreSustituto() {
		return nombreSustituto;
	}

	public void setNombreSustituto(String nombreSustituto) {
		this.nombreSustituto = nombreSustituto;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public Boolean getVigente() {
		return vigente;
	}

	public void setVigente(Boolean vigente) {
		this.vigente = vigente;
	}
    
}
