package es.pfsgroup.plugin.liquidaciones.avanzado.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.EXTContrato;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@Entity
@Table(name = "CAL_CALCULO_LIQUIDACION", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class CalculoLiquidacion implements Auditable, Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4502479621786306745L;
	
	@Id
    @Column(name = "CAL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CalculoLiquidacionGenerator")
    @SequenceGenerator(name = "CalculoLiquidacionGenerator", sequenceName = "S_CAL_CALCULO_LIQUIDACION")
	private Long id;
	
	@Column(name = "CAL_NOMBRE")
	private String nombre;
	
	@ManyToOne
	@JoinColumn(name = "ASU_ID")
	private EXTAsunto asunto;
	
	@ManyToOne
	@JoinColumn(name = "PRC_ID")
	private MEJProcedimiento actuacion;
	
	@ManyToOne
	@JoinColumn(name = "CNT_ID")
	private EXTContrato contrato;
	
	@Column(name = "CAL_NOMBRE_PER")
	private String nombrePersona;
	
	@Column(name = "CAL_DOC_ID")
	private String documentoId;
	
	@Column(name = "CAL_CAPITAL")
	private BigDecimal capital;
	
	@Column(name = "CAL_INTERESES_ORDINARIOS")
	private BigDecimal interesesOrdinarios;
	
	@Column(name = "CAL_INTERESES_DEMORA")
	private BigDecimal interesesDemora;
	
	@Column(name = "CAL_COMISIONES")
	private BigDecimal comisiones;
	
	@Column(name = "CAL_IMPUESTOS")
	private BigDecimal impuestos;
	
	@Column(name = "CAL_GASTOS")
	private BigDecimal gastos;

	@Column(name = "CAL_FECHA_CIERRE")
	private Date fechaCierre;
	
	@Column(name = "CAL_COSTAS_LETRADO")
	private BigDecimal costasLetrado;

	@Column(name = "CAL_COSTAS_PROCURADOR")
	private BigDecimal costasProcurador;

	@Column(name = "CAL_OTROS_GASTOS")
	private BigDecimal otrosGastos;

	@Column(name = "CAL_BASE_CALCULO")
	private Integer baseCalculo;

	@Column(name = "CAL_FECHA_LIQUIDACION")
	private Date fechaLiquidacion;
	
	@Column(name = "CAL_TIPO_MORA_CIERRE")
	private Float tipoMoraCierre;
	
	@Column(name = "CAL_TOTAL_LIQUIDACION")
	private BigDecimal totalCaculo;

	@ManyToOne
	@JoinColumn(name = "DD_ECA_ID")
	private DDEstadoCalculo estadoCalculo;
	
	@OneToMany(fetch = FetchType.LAZY)
	@JoinColumn(name = "CAL_ID")
	private List<ActualizacionTipoCalculoLiq> actualizacionesTipo;
	
	@Embedded
	private Auditoria auditoria;
	
	@Version
    private Integer version;


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public EXTAsunto getAsunto() {
		return asunto;
	}

	public void setAsunto(EXTAsunto asunto) {
		this.asunto = asunto;
	}

	public MEJProcedimiento getActuacion() {
		return actuacion;
	}

	public void setActuacion(MEJProcedimiento actuacion) {
		this.actuacion = actuacion;
	}

	public EXTContrato getContrato() {
		return contrato;
	}

	public void setContrato(EXTContrato contrato) {
		this.contrato = contrato;
	}

	public String getNombrePersona() {
		return nombrePersona;
	}

	public void setNombrePersona(String nombrePersona) {
		this.nombrePersona = nombrePersona;
	}

	public String getDocumentoId() {
		return documentoId;
	}

	public void setDocumentoId(String documentoId) {
		this.documentoId = documentoId;
	}

	public BigDecimal getCapital() {
		return capital;
	}

	public void setCapital(BigDecimal capital) {
		this.capital = capital;
	}

	public BigDecimal getInteresesOrdinarios() {
		return interesesOrdinarios;
	}

	public void setInteresesOrdinarios(BigDecimal interesesOrdinarios) {
		this.interesesOrdinarios = interesesOrdinarios;
	}

	public BigDecimal getInteresesDemora() {
		return interesesDemora;
	}

	public void setInteresesDemora(BigDecimal interesesDemora) {
		this.interesesDemora = interesesDemora;
	}

	public BigDecimal getComisiones() {
		return comisiones;
	}

	public void setComisiones(BigDecimal comisiones) {
		this.comisiones = comisiones;
	}

	public BigDecimal getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(BigDecimal impuestos) {
		this.impuestos = impuestos;
	}

	public BigDecimal getGastos() {
		return gastos;
	}

	public void setGastos(BigDecimal gastos) {
		this.gastos = gastos;
	}

	public Date getFechaCierre() {
		return fechaCierre;
	}

	public void setFechaCierre(Date fechaCierre) {
		this.fechaCierre = fechaCierre;
	}

	public BigDecimal getCostasLetrado() {
		return costasLetrado;
	}

	public void setCostasLetrado(BigDecimal costasLetrado) {
		this.costasLetrado = costasLetrado;
	}

	public BigDecimal getCostasProcurador() {
		return costasProcurador;
	}

	public void setCostasProcurador(BigDecimal costasProcurador) {
		this.costasProcurador = costasProcurador;
	}

	public BigDecimal getOtrosGastos() {
		return otrosGastos;
	}

	public void setOtrosGastos(BigDecimal otrosGastos) {
		this.otrosGastos = otrosGastos;
	}

	public Integer getBaseCalculo() {
		return baseCalculo;
	}

	public void setBaseCalculo(Integer baseCalculo) {
		this.baseCalculo = baseCalculo;
	}

	public Date getFechaLiquidacion() {
		return fechaLiquidacion;
	}

	public void setFechaLiquidacion(Date fechaLiquidacion) {
		this.fechaLiquidacion = fechaLiquidacion;
	}

	public Float getTipoMoraCierre() {
		return tipoMoraCierre;
	}

	public void setTipoMoraCierre(Float tipoMoraCierre) {
		this.tipoMoraCierre = tipoMoraCierre;
	}

	public BigDecimal getTotalCaculo() {
		return totalCaculo;
	}

	public void setTotalCaculo(BigDecimal totalCaculo) {
		this.totalCaculo = totalCaculo;
	}

	public DDEstadoCalculo getEstadoCalculo() {
		return estadoCalculo;
	}

	public void setEstadoCalculo(DDEstadoCalculo estadoCalculo) {
		this.estadoCalculo = estadoCalculo;
	}

	public List<ActualizacionTipoCalculoLiq> getActualizacionesTipo() {
		return actualizacionesTipo;
	}

	public void setActualizacionesTipo(
			List<ActualizacionTipoCalculoLiq> actualizacionesTipo) {
		this.actualizacionesTipo = actualizacionesTipo;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
	
}
