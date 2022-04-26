package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 *  
 * @author Lara Pablo
 *
 */
@Entity
@Table(name = "V_HISTORICO_BLOQUEO_APIS", schema = "${entity.schema}")
public class VHistoricoBloqueosApis implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ID")
	private Long id;
	
	@Column(name = "PVE_ID")
	private Long idPve;
	
	@Column(name = "DD_TPB_DESCRIPCION")
	private String tipoBloqueo;
	
	@Column(name = "BLOQUEOS")
	private String bloqueos;
	
	@Column(name = "BHA_MOTIVO_BLOQUEO")
	private String motivoBloqueo;
	
	@Column(name = "FECHA_BLOQUEO")
	private Date fechaBloqueo;
	
	@Column(name = "USUARIO_BLOQUEO")
	private String usuarioBloqueo;
	
	@Column(name = "BHA_MOTIVO_DESBLOQUEO")
	private String motivoDesbloqueo;
	
	@Column(name = "FECHA_DESBLOQUEO")
	private Date fechaDesbloqueo;
	
	@Column(name = "USUARIO_DESBLOQUEO")
	private String usuarioDesbloqueo;

	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdPve() {
		return idPve;
	}

	public void setIdPve(Long idPve) {
		this.idPve = idPve;
	}

	public String getTipoBloqueo() {
		return tipoBloqueo;
	}

	public void setTipoBloqueo(String tipoBloqueo) {
		this.tipoBloqueo = tipoBloqueo;
	}

	public String getBloqueos() {
		return bloqueos;
	}

	public void setBloqueos(String bloqueos) {
		this.bloqueos = bloqueos;
	}

	public String getMotivoBloqueo() {
		return motivoBloqueo;
	}

	public void setMotivoBloqueo(String motivoBloqueo) {
		this.motivoBloqueo = motivoBloqueo;
	}

	public Date getFechaBloqueo() {
		return fechaBloqueo;
	}

	public void setFechaBloqueo(Date fechaBloqueo) {
		this.fechaBloqueo = fechaBloqueo;
	}

	public String getUsuarioBloqueo() {
		return usuarioBloqueo;
	}

	public void setUsuarioBloqueo(String usuarioBloqueo) {
		this.usuarioBloqueo = usuarioBloqueo;
	}

	public String getMotivoDesbloqueo() {
		return motivoDesbloqueo;
	}

	public void setMotivoDesbloqueo(String motivoDesbloqueo) {
		this.motivoDesbloqueo = motivoDesbloqueo;
	}

	public Date getFechaDesbloqueo() {
		return fechaDesbloqueo;
	}

	public void setFechaDesbloqueo(Date fechaDesbloqueo) {
		this.fechaDesbloqueo = fechaDesbloqueo;
	}

	public String getUsuarioDesbloqueo() {
		return usuarioDesbloqueo;
	}

	public void setUsuarioDesbloqueo(String usuarioDesbloqueo) {
		this.usuarioDesbloqueo = usuarioDesbloqueo;
	}

}
