package es.capgemini.pfs.persona.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = "PER_PERSONAS_FORMULAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class PersonaFormulas implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4637547044292036246L;

	@Id
	@Column(name = "PER_ID")
	private Long id;

	@Column(name = "EST_CICLO_VIDA")
	private String estadoCicloVida;

	@Column(name = "DIAS_VENC_RIESGO_DIRECTO")
	private Integer diasVencidoRiegoDirecto;

	@Column(name = "DIAS_VENC_RIESGO_INDIRECTO")
	private Integer diasVencidoRiegoIndirecto;

	@Column(name = "RIESGO_TOTAL")
	private Float riesgoTot;

	@Column(name = "RIESGO_TOTAL_DIRECTO")
	private Float riesgoTotalDirecto;

	@Column(name = "RIESGO_TOTAL_INDIRECTO")
	private Float riesgoTotalIndirecto;

	@Column(name = "SITUACION_CLIENTE")
	private String situacionCliente;

	@Column(name = "DIAS_VENCIDO")
	private Integer diasVencido;

	@Column(name = "NUM_EXP_ACTIVOS")
	private Integer numExpedientesActivos;

	@Column(name = "NUM_ASU_ACTIVOS")
	private Integer numAsuntosActivos;

	@Column(name = "NUM_ASU_ACTIVOS_POR_PRC")
	private Integer numAsuntosActivosPorPrc;

	@Column(name = "SITUACION")
	private String situacion;

	@Column(name = "RELACION_EXP")
	private String relacionExpediente;

	@Column(name = "SERV_NOMINIA_PENSION")
	private String servicioNominaPension;

	@Column(name = "ULTIMA_ACTUACION")
	private String ultimaActuacion;

	@Column(name = "DISPUESTO_NO_VENCIDO")
	private String dispuestoNoVencido;

	@Column(name = "DISPUESTO_VENCIDO")
	private String dispuestoVencido;

	@Column(name = "DESC_CNAE")
	private String descripcionCnae;

	public Long getId() {
		return id;
	}

	public String getEstadoCicloVida() {
		return estadoCicloVida;
	}

	public Integer getDiasVencidoRiegoDirecto() {
		return diasVencidoRiegoDirecto;
	}

	public Integer getDiasVencidoRiegoIndirecto() {
		return diasVencidoRiegoIndirecto;
	}

	public Float getRiesgoTot() {
		return riesgoTot;
	}

	public Float getRiesgoTotalDirecto() {
		return riesgoTotalDirecto;
	}

	public Float getRiesgoTotalIndirecto() {
		return riesgoTotalIndirecto;
	}

	public String getSituacionCliente() {
		return situacionCliente;
	}

	public Integer getDiasVencido() {
		return diasVencido;
	}

	public Integer getNumExpedientesActivos() {
		return numExpedientesActivos;
	}

	public Integer getNumAsuntosActivos() {
		return numAsuntosActivos;
	}

	public Integer getNumAsuntosActivosPorPrc() {
		return numAsuntosActivosPorPrc;
	}

	public String getSituacion() {
		return situacion;
	}

	public String getRelacionExpediente() {
		return relacionExpediente;
	}

	public String getServicioNominaPension() {
		return servicioNominaPension;
	}

	public String getUltimaActuacion() {
		return ultimaActuacion;
	}

	public String getDispuestoNoVencido() {
		return dispuestoNoVencido;
	}

	public String getDispuestoVencido() {
		return dispuestoVencido;
	}

	public String getDescripcionCnae() {
		return descripcionCnae;
	}

	

}
