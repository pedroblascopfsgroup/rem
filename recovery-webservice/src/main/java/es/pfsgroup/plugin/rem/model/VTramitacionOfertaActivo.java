package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Modelo que gestiona la tramitación automatica de ofertas de un activo.
 * 
 * @author Álvaro Valero
 */
@Entity
@Table(name = "VI_TRAMITACION_OFR_ACT", schema = "${entity.schema}")
public class VTramitacionOfertaActivo implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ACT_ID")
	private Long idActivo;
	
	@Column(name = "APU_FECHA_CAMB_PUBL_VENTA")
	private Date fechaPublicacion;
	

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Date getFechaPublicacion() {
		return fechaPublicacion;
	}

	public void setFechaPublicacion(Date fechaPublicacion) {
		this.fechaPublicacion = fechaPublicacion;
	}
}
	
