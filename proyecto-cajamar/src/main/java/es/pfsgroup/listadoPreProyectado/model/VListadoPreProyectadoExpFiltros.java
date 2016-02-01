package es.pfsgroup.listadoPreProyectado.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name="V_LIS_PREPROYECT_EXP_FILTROS", schema="${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class VListadoPreProyectadoExpFiltros implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -2459420509381031776L;

	@Id
	@Column(name="CNT_ID")
	private Long cntId;
	
	@Column(name="ESTADO_GESTION_COD")
	private String estadoGestion;
	
	@Column(name="TIPO_PERSONA_COD")
	private String tipoPersonaCod;
	
	@Column(name="RIESGO_TOTAL_EXP")
	private BigDecimal riesgoTotal;
	
	@Column(name="DEUDA_IRREGULAR_EXP")
	private BigDecimal deudaIrregular;
	
	@Column(name="DIAS_VENCIDOS")
	private Long diasVencidos;
	
	@Column(name="FECHA_PASE_A_MORA_EXP")
	private Date fechaPaseAMoraExp;
	
	@Column(name="TRAMO_EXP")
	private String tramoCod;
	
	@Column(name="TIPO_PROPUESTA_COD")
	private String tipoPropuestaCod;
	
	@Column(name="NUM_PROPUESTAS")
	private Long nPropuestas;
	
	@Column(name="ZON_COD")
	private String zonExp;
	
	@Column(name="FASE_COD")
	private String faseCod;
	
	@Column(name="NRO_CONTRATO")
	private String contrato;
	
	@Column(name="FECHA_PREV_REGU_CNT")
	private Date fechaPrevReguCnt;
	
	@Column(name="ZON_COD_CONTRATO")
	private String zonCodContrato;
	
	@Column(name="EXP_ID")
	private Long expId;
	
    @Column(name="NIF_TITULAR")
    private String nifTitular;
    
    @Column(name="NOM_TITULAR")
    private String nomTitular;
    
    @Column(name="NIF_CLIENTE")
    private String nifCliente;
    
    @Column(name="NOM_CLIENTE")
    private String nomCliente;

	public Long getCntId() {
		return cntId;
	}

	public void setCntId(Long cntId) {
		this.cntId = cntId;
	}

	public String getEstadoGestion() {
		return estadoGestion;
	}

	public void setEstadoGestion(String estadoGestion) {
		this.estadoGestion = estadoGestion;
	}

	public String getTipoPersonaCod() {
		return tipoPersonaCod;
	}

	public void setTipoPersonaCod(String tipoPersonaCod) {
		this.tipoPersonaCod = tipoPersonaCod;
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

	public String getTramoCod() {
		return tramoCod;
	}

	public void setTramoCod(String tramoCod) {
		this.tramoCod = tramoCod;
	}

	public Long getDiasVencidos() {
		return diasVencidos;
	}

	public void setDiasVencidos(Long diasVencidos) {
		this.diasVencidos = diasVencidos;
	}

	public Date getFechaPaseAMoraExp() {
		return fechaPaseAMoraExp;
	}

	public void setFechaPaseAMoraExp(Date fechaPaseAMoraExp) {
		this.fechaPaseAMoraExp = fechaPaseAMoraExp;
	}

	public String getTipoPropuestaCod() {
		return tipoPropuestaCod;
	}

	public void setTipoPropuestaCod(String tipoPropuestaCod) {
		this.tipoPropuestaCod = tipoPropuestaCod;
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

	public String getFaseCod() {
		return faseCod;
	}

	public void setFaseCod(String faseCod) {
		this.faseCod = faseCod;
	}

	public String getContrato() {
		return contrato;
	}

	public void setContrato(String contrato) {
		this.contrato = contrato;
	}

	public Date getFechaPrevReguCnt() {
		return fechaPrevReguCnt;
	}

	public void setFechaPrevReguCnt(Date fechaPrevReguCnt) {
		this.fechaPrevReguCnt = fechaPrevReguCnt;
	}

	public String getZonCodContrato() {
		return zonCodContrato;
	}

	public void setZonCodContrato(String zonCodContrato) {
		this.zonCodContrato = zonCodContrato;
	}

	public Long getExpId() {
		return expId;
	}

	public void setExpId(Long expId) {
		this.expId = expId;
	}

	public String getNifTitular() {
		return nifTitular;
	}

	public void setNifTitular(String nifTitular) {
		this.nifTitular = nifTitular;
	}

	public String getNomTitular() {
		return nomTitular;
	}

	public void setNomTitular(String nomTitular) {
		this.nomTitular = nomTitular;
	}

	public String getNifCliente() {
		return nifCliente;
	}

	public void setNifCliente(String nifCliente) {
		this.nifCliente = nifCliente;
	}

	public String getNomCliente() {
		return nomCliente;
	}

	public void setNomCliente(String nomCliente) {
		this.nomCliente = nomCliente;
	}

}