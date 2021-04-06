package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "VI_AGRUPACION_ACTIVOS_GESTOR_COMERCIAL", schema = "${entity.schema}")
public class VAgrupacionActivosGestorComercial implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	@Id
	@Column(name = "AGA_ID")
	private Long idAgrupacionActivo;
	
	@Column(name = "AGR_ID")
	private Long idAgrupacion;
	
	@Column(name = "ACT_ID")
	private Long idActivo;
	
	@Column(name = "USU_ID")
	private Long idUsuario;

	public Long getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getIdUsuario() {
		return idUsuario;
	}

	public void setIdUsuario(Long idUsuario) {
		this.idUsuario = idUsuario;
	}

	public Long getIdAgrupacionActivo() {
		return idAgrupacionActivo;
	}

	public void setIdAgrupacionActivo(Long idAgrupacionActivo) {
		this.idAgrupacionActivo = idAgrupacionActivo;
	}
}
