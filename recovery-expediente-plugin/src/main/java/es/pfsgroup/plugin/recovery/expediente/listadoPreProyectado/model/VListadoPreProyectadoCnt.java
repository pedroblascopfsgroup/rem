package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.model;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name="V_LIS_PREPROYECT_CNT", schema="${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Inheritance(strategy= InheritanceType.SINGLE_TABLE)
public class VListadoPreProyectadoCnt {

	@Id
	@Column(name="CNT_ID")
	private Long cntId;
	
	@Column(name="CNT_CONTRATO")
	private String contrato;
	
	@Column(name="EXP_ID")
	private Long expId;
	
	@Column(name="RIESGO_TOTAL")
	private BigDecimal riesgoTotal;
	
	@Column(name="DEUDA_IRREGULAR")
	private BigDecimal deudaIrregular;
	
	@Column(name="TRAMO")
	private String tramo;

	@Column(name="DIAS_VENCIDOS")
	private Long diasVencidos;
	
	@Column(name="FECHA_PASE_A_MORA_CNT")
	private Date fechaPaseAMoraCnt;
	
	@Column(name="FECHA_PREV_REGU_CNT")
	private Date fechaPrevReguCnt;
	
	@Column(name="ESTADO_GESTION_ID")
	private Long estadoGestionId;
	
	@Column(name="TIPO_PERSONA_ID")
	private Long tipoPersonaId;
	
	@Column(name="TRAMO_ID")
	private Long tramoId;
	
	@Column(name="TIPO_PROPUESTA_ID")
	private Long tipoPropuestaId;
	
	@Column(name="N_PROPUESTAS")
	private Long nPropuestas;
	
	@Column(name="ZON_EXP")
	private String zonExp;
	
	@Column(name="FASE_ID")
	private Long faseId;
	
	@Column(name="ZON_COD_CONTRATO")
	private String zonCodContrato;

	public Long getCntId() {
		return cntId;
	}

	public void setCntId(Long cntId) {
		this.cntId = cntId;
	}

	public String getContrato() {
		return contrato;
	}

	public void setContrato(String contrato) {
		this.contrato = contrato;
	}

	public Long getExpId() {
		return expId;
	}

	public void setExpId(Long expId) {
		this.expId = expId;
	}

	public BigDecimal getRiesgoTotal() {
		return riesgoTotal;
	}

	public void setRiesgoTotal(BigDecimal riesgoTotal) {
		this.riesgoTotal = riesgoTotal;
	}

	public BigDecimal getDeudaIrregular() {
		return deudaIrregular;
	}

	public void setDeudaIrregular(BigDecimal deudaIrregular) {
		this.deudaIrregular = deudaIrregular;
	}

	public String getTramo() {
		return tramo;
	}

	public void setTramo(String tramo) {
		this.tramo = tramo;
	}

	public Long getDiasVencidos() {
		return diasVencidos;
	}

	public void setDiasVencidos(Long diasVencidos) {
		this.diasVencidos = diasVencidos;
	}

	public Date getFechaPaseAMoraCnt() {
		return fechaPaseAMoraCnt;
	}

	public void setFechaPaseAMoraCnt(Date fechaPaseAMoraCnt) {
		this.fechaPaseAMoraCnt = fechaPaseAMoraCnt;
	}

	public Date getFechaPrevReguCnt() {
		return fechaPrevReguCnt;
	}

	public void setFechaPrevReguCnt(Date fechaPrevReguCnt) {
		this.fechaPrevReguCnt = fechaPrevReguCnt;
	}

	public Long getEstadoGestionId() {
		return estadoGestionId;
	}

	public void setEstadoGestionId(Long estadoGestionId) {
		this.estadoGestionId = estadoGestionId;
	}

	public Long getTipoPersonaId() {
		return tipoPersonaId;
	}

	public void setTipoPersonaId(Long tipoPersonaId) {
		this.tipoPersonaId = tipoPersonaId;
	}

	public Long getTramoId() {
		return tramoId;
	}

	public void setTramoId(Long tramoId) {
		this.tramoId = tramoId;
	}

	public Long getTipoPropuestaId() {
		return tipoPropuestaId;
	}

	public void setTipoPropuestaId(Long tipoPropuestaId) {
		this.tipoPropuestaId = tipoPropuestaId;
	}

	public Long getnPropuestas() {
		return nPropuestas;
	}

	public void setnPropuestas(Long nPropuestas) {
		this.nPropuestas = nPropuestas;
	}

	public String getZonExp() {
		return zonExp;
	}

	public void setZonExp(String zonExp) {
		this.zonExp = zonExp;
	}

	public Long getFaseId() {
		return faseId;
	}

	public void setFaseId(Long faseId) {
		this.faseId = faseId;
	}

	public String getZonCodContrato() {
		return zonCodContrato;
	}

	public void setZonCodContrato(String zonCodContrato) {
		this.zonCodContrato = zonCodContrato;
	}	
	
}
