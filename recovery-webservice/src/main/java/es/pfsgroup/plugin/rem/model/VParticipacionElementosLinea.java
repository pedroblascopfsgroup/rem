package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
@Table(name = "V_REPARTO_IMP_TBJ", schema = "${entity.schema}")
public class VParticipacionElementosLinea implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "GLD_ENT_ID")
	private Long id;
	
	@Column(name = "GLD_ID")
	private Long idLinea;

	@Column(name = "GPV_ID")
	private Long idGasto;
	
	@Column(name = "PARTICIPACION_PVE")
	private Double participacionPve;
	
	@Column(name = "PARTICIPACION_CLI")
	private Double participacionCli;

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

	public Long getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}

	public Double getParticipacionPve() {
		return participacionPve;
	}

	public void setParticipacionPve(Double participacionPve) {
		this.participacionPve = participacionPve;
	}

	public Double getParticipacionCli() {
		return participacionCli;
	}

	public void setParticipacionCli(Double participacionCli) {
		this.participacionCli = participacionCli;
	}

	
	
	
	
}
