package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;

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
@Table(name = "VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE", schema = "${entity.schema}")
public class VParticipacionLineaDetalle implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "GASTO")
	private Long id;
	
	@Column(name = "LINEA")
	private Long idLinea;
	
	@Column(name = "PARTICIPACION")
	private BigDecimal participacion;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdLinea() {
		return idLinea;
	}

	public void setIdLinea(Long idLinea) {
		this.idLinea = idLinea;
	}

	public BigDecimal getParticipacion() {
		return participacion;
	}

	public void setParticipacion(BigDecimal participacion) {
		this.participacion = participacion;
	}
	
}
