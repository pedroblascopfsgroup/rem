package es.pfsgroup.plugin.rem.model;

import java.util.Date;
import java.util.List;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto que gestiona la informacion del deguro de rentas del expediente.
 *  
 * @author Juan Angel Sánchez
 *
 */

public class DtoSeguroRentas extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	

	private Long id;
	private String motivoRechazo;
	private Boolean revision;
	private String estado;
	private String aseguradoras;
	private String emailPoliza;
	private Long version;
	private String usuarioCrear;
	private Date fechaCrear;
	private String usuarioModificar;
	private Date fechaModificar;
	private String usuarioBorrar;
	private Date fechaBorrar;
	private int borrado;
	private String comentarios;
	


	public String getComentarios() {
		return comentarios;
	}
	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}
	public String getMotivoRechazo() {
		return motivoRechazo;
	}
	public void setMotivoRechazo(String motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Boolean getRevision() {
		return revision;
	}

	public void setRevision(Boolean revision) {
		this.revision = revision;
	}


	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public String getEmailPoliza() {
		return emailPoliza;
	}

	public void setEmailPoliza(String emailPoliza) {
		this.emailPoliza = emailPoliza;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public String getUsuarioCrear() {
		return usuarioCrear;
	}

	public void setUsuarioCrear(String usuarioCrear) {
		this.usuarioCrear = usuarioCrear;
	}

	public Date getFechaCrear() {
		return fechaCrear;
	}

	public void setFechaCrear(Date fechaCrear) {
		this.fechaCrear = fechaCrear;
	}

	public String getUsuarioModificar() {
		return usuarioModificar;
	}

	public void setUsuarioModificar(String usuarioModificar) {
		this.usuarioModificar = usuarioModificar;
	}

	public Date getFechaModificar() {
		return fechaModificar;
	}

	public void setFechaModificar(Date fechaModificar) {
		this.fechaModificar = fechaModificar;
	}

	public String getUsuarioBorrar() {
		return usuarioBorrar;
	}

	public void setUsuarioBorrar(String usuarioBorrar) {
		this.usuarioBorrar = usuarioBorrar;
	}

	public Date getFechaBorrar() {
		return fechaBorrar;
	}

	public void setFechaBorrar(Date fechaBorrar) {
		this.fechaBorrar = fechaBorrar;
	}

	public int getBorrado() {
		return borrado;
	}

	public void setBorrado(int borrado) {
		this.borrado = borrado;
	}
	
	public String getAseguradoras() {
		return aseguradoras;
	}
	public void setAseguradoras(String aseguradoras) {
		this.aseguradoras = aseguradoras;
	}

	
}
