package es.pfsgroup.listadoPreProyectado.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;	
import javax.persistence.Transient;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name="V_LIS_PREPROYECT_EXP" ,schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class VListadoPreProyectadoExp implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6947618963807794347L;

	@Id
	@Column(name = "EXP_ID")
	private Long expId;
	
	@Column(name="TITULAR")
	private String titular;
	
	@Column(name="NIF_TITULAR")
	private String nifTitular;

	@Column(name="TELF_1")
	private String telf1;
	
	@Column(name="FASE")
	private String fase;
	
	@Column(name="FECHA_VTO_TAREA")
	private Date fechaVtoTarea;
	
	@Column(name="NUM_CONTRATOS")
	private Long numContratos;
	
	@Column(name="VOL_RIESGO_EXP")
	private BigDecimal volRiesgoExp;

	@Column(name="IMPORTE_INICIAL_EXP")
	private BigDecimal importeInicialExp;
	
	@Column(name="REGULARIZADO_EXP")
	private BigDecimal regularizadoExp;
	
	@Column(name="IMPORTE_ACTUAL")
	private BigDecimal importeActual;
	
	@Column(name="IMPORTE_PTE_DIFER")
	private BigDecimal importePteDifer;
	
	@Column(name="TRAMO_EXP")
	private String tramoExp;
	
	@Column(name="DIAS_VENCIDOS_EXP")
	private Long diasVencidosExp;
	
	@Column(name="FECHA_PASE_A_MORA_EXP")
	private Date fechaPaseAMoraExp;
	
	@Column(name="PROPUESTA")
	private String propuesta;
	
	@Column(name="FECHA_PREV_REGU_EXP")
	private Date fechaPrevReguExp;
	
	@Column(name="EXP_DESCRIPCION")
	private String expDescripcion;
	
	@Transient
	private List<VListadoPreProyectadoCnt> contratos;

	public Long getExpId() {
		return expId;
	}

	public void setExpId(Long expId) {
		this.expId = expId;
	}

	public String getTitular() {
		return titular;
	}

	public void setTitular(String titular) {
		this.titular = titular;
	}

	public String getNifTitular() {
		return nifTitular;
	}

	public void setNifTitular(String nifTitular) {
		this.nifTitular = nifTitular;
	}

	public String getTelf1() {
		return telf1;
	}

	public void setTelf1(String telf1) {
		this.telf1 = telf1;
	}

	public String getFase() {
		return fase;
	}

	public void setFase(String fase) {
		this.fase = fase;
	}

	public Date getFechaVtoTarea() {
		return fechaVtoTarea;
	}

	public void setFechaVtoTarea(Date fechaVtoTarea) {
		this.fechaVtoTarea = fechaVtoTarea;
	}

	public Long getNumContratos() {
		return numContratos;
	}

	public void setNumContratos(Long numContratos) {
		this.numContratos = numContratos;
	}

	public BigDecimal getVolRiesgoExp() {
		return volRiesgoExp;
	}

	public void setVolRiesgoExp(BigDecimal volRiesgoExp) {
		this.volRiesgoExp = volRiesgoExp;
	}

	public BigDecimal getImporteInicialExp() {
		return importeInicialExp;
	}

	public void setImporteInicialExp(BigDecimal importeInicialExp) {
		this.importeInicialExp = importeInicialExp;
	}

	public BigDecimal getRegularizadoExp() {
		return regularizadoExp;
	}

	public void setRegularizadoExp(BigDecimal regularizadoExp) {
		this.regularizadoExp = regularizadoExp;
	}

	public BigDecimal getImporteActual() {
		return importeActual;
	}

	public void setImporteActual(BigDecimal importeActual) {
		this.importeActual = importeActual;
	}

	public BigDecimal getImportePteDifer() {
		return importePteDifer;
	}

	public void setImportePteDifer(BigDecimal importePteDifer) {
		this.importePteDifer = importePteDifer;
	}

	public String getTramoExp() {
		return tramoExp;
	}

	public void setTramoExp(String tramoExp) {
		this.tramoExp = tramoExp;
	}

	public Long getDiasVencidosExp() {
		return diasVencidosExp;
	}

	public void setDiasVencidosExp(Long diasVencidosExp) {
		this.diasVencidosExp = diasVencidosExp;
	}

	public Date getFechaPaseAMoraExp() {
		return fechaPaseAMoraExp;
	}

	public void setFechaPaseAMoraExp(Date fechaPaseAMoraExp) {
		this.fechaPaseAMoraExp = fechaPaseAMoraExp;
	}

	public String getPropuesta() {
		return propuesta;
	}

	public void setPropuesta(String propuesta) {
		this.propuesta = propuesta;
	}

	public Date getFechaPrevReguExp() {
		return fechaPrevReguExp;
	}

	public void setFechaPrevReguExp(Date fechaPrevReguExp) {
		this.fechaPrevReguExp = fechaPrevReguExp;
	}
	
	public String getExpDescripcion() {
		return expDescripcion;
	}

	public void setExpDescripcion(String expDescripcion) {
		this.expDescripcion = expDescripcion;
	}	

	public List<VListadoPreProyectadoCnt> getContratos() {
		return contratos;
	}

	public void setContratos(List<VListadoPreProyectadoCnt> contratos) {
		this.contratos = contratos;
	}
}
