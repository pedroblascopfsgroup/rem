package es.pfsgroup.listadoPreProyectado.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Immutable;

import es.capgemini.pfs.expediente.model.Expediente;

@Entity
@Table(name="V_LIS_PREPROYECT_EXP_CALC", schema="${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Immutable
public class VListadoPreProyectadoExtCalc implements Serializable {

	private static final long serialVersionUID = -5737304070287017845L;

	//@Column(name="EXP_ID")
    @OneToOne(targetEntity = Expediente.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "EXP_ID")
	private Expediente expediente;

	@Id
	@Column(name = "CNT_ID")
	private Long cntId;

	@Column(name="DIAS_VENCIDOS")
	private Long diasVencidos;

	@Column(name="COD_TRAMO")
	private String codTramo ;

	@Column(name="RIESGO_TOTAL_EXP")
	private BigDecimal riesgoTotalExp;

	@Column(name="DEUDA_IRREGULAR_EXP")
	private BigDecimal deudaIrregularExp ;

	@Column(name="FECHA_PREV_REGU_CNT")
	private Date fechaPrevReguCnt;

	@Column(name="FECHA_PASE_A_MORA_EXP")
	private Date fechaPaseAMoraExp;

	@Column(name="PER_NOM_COMPLETO")
	private String titularNombreCompleto;

	@Column(name="PER_DOC_ID")
	private String titularDocId;

	// GETTERS & SETTERS

	public Expediente getExpediente() {
		return expediente;
	}

	public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

	public Long getCntId() {
		return cntId;
	}

	public void setCntId(Long cntId) {
		this.cntId = cntId;
	}

	public Long getDiasVencidos() {
		return diasVencidos;
	}

	public void setDiasVencidos(Long diasVencidos) {
		this.diasVencidos = diasVencidos;
	}

	public String getCodTramo() {
		return codTramo;
	}

	public void setCodTramo(String codTramo) {
		this.codTramo = codTramo;
	}

	public BigDecimal getRiesgoTotalExp() {
		return riesgoTotalExp;
	}

	public void setRiesgoTotalExp(BigDecimal riesgoTotalExp) {
		this.riesgoTotalExp = riesgoTotalExp;
	}

	public BigDecimal getDeudaIrregularExp() {
		return deudaIrregularExp;
	}

	public void setDeudaIrregularExp(BigDecimal deudaIrregularExp) {
		this.deudaIrregularExp = deudaIrregularExp;
	}

	public Date getFechaPrevReguCnt() {
		return fechaPrevReguCnt;
	}

	public void setFechaPrevReguCnt(Date fechaPrevReguCnt) {
		this.fechaPrevReguCnt = fechaPrevReguCnt;
	}

	public Date getFechaPaseAMoraExp() {
		return fechaPaseAMoraExp;
	}

	public void setFechaPaseAMoraExp(Date fechaPaseAMoraExp) {
		this.fechaPaseAMoraExp = fechaPaseAMoraExp;
	}

	public String getTitularNombreCompleto() {
		return titularNombreCompleto;
	}

	public void setTitularNombreCompleto(String titularNombreCompleto) {
		this.titularNombreCompleto = titularNombreCompleto;
	}

	public String getTitularDocId() {
		return titularDocId;
	}

	public void setTitularDocId(String titularDocId) {
		this.titularDocId = titularDocId;
	}
}
