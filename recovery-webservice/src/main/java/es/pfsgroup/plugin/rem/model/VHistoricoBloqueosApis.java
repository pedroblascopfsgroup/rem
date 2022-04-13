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
@Table(name = "V_BLOQUEO_APIS", schema = "${entity.schema}")
public class VHistoricoBloqueosApis implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "PVE_ID")
	private Long id;
	
	@Column(name = "BHA_BLOQUEOS")
	private String bloqueos;
	
	@Column(name = "BHA_MOTIVO")
	private String motivo;
	
	@Column(name = "NOMBRE_USUARIO")
	private String usuario;
	
	@Column(name = "BHA_FECHA")
	private Date fecha;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getBloqueos() {
		return bloqueos;
	}

	public void setBloqueos(String bloqueos) {
		this.bloqueos = bloqueos;
	}

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	
}
