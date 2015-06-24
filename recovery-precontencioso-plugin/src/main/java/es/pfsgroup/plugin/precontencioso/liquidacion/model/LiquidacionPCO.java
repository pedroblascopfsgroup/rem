package es.pfsgroup.plugin.precontencioso.liquidacion.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.precontencioso.procedimientoJudicial.model.ProcedimentoPCO;

@Entity
@Table(name = "PCO_LIQ_LIQUIDACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class LiquidacionPCO implements Serializable, Auditable {

	private static final long serialVersionUID = -9076449499543642580L;

	@Id
	@Column(name = "PCO_LIQ_LIQUIDACION_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "LiquidacionPCOGenerator")
	@SequenceGenerator(name = "LiquidacionPCOGenerator", sequenceName = "S_PCO_LIQ_LIQUIDACION")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "PRC_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private ProcedimentoPCO procedimientoPCO;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_LIQ_ESTADO_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDEstadoLiquidacion estadoLiquidacion;

	@Column(name = "CNT_ID")
	private Long cntId;

	@Column(name = "FECHA_SOLICITUD")
	private Date fechaSolicitud;

	@Column(name = "FECHA_RECEPCION")
	private Date fechaRecepcion;

	@Column(name = "FECHA_CONFIRMACION")
	private Date fechaConfirmacion;

	@Column(name = "FECHA_CIERRE")
	private Date fechaCierre;

	@Column(name = "CAPITAL_VENCIDO")
	private Float capitalVencido;

	@Column(name = "CAPITAL_NO_VENCIDO")
	private Float capitalNoVencido;

	@Column(name = "INTERESES_DEMORA")
	private Float interesesDemora;

	@Column(name = "TOTAL")
	private Float total;

	@Column(name = "APODERADO")
	private String apoderado;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/*
	 * GETTERS & SETTERS
	 */

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ProcedimentoPCO getProcedimientoPCO() {
		return procedimientoPCO;
	}

	public void setProcedimientoPCO(ProcedimentoPCO procedimientoPCO) {
		this.procedimientoPCO = procedimientoPCO;
	}

	public DDEstadoLiquidacion getEstadoLiquidacion() {
		return estadoLiquidacion;
	}

	public void setEstadoLiquidacion(DDEstadoLiquidacion estadoLiquidacion) {
		this.estadoLiquidacion = estadoLiquidacion;
	}

	public Long getCntId() {
		return cntId;
	}

	public void setCntId(Long cntId) {
		this.cntId = cntId;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaRecepcion() {
		return fechaRecepcion;
	}

	public void setFechaRecepcion(Date fechaRecepcion) {
		this.fechaRecepcion = fechaRecepcion;
	}

	public Date getFechaConfirmacion() {
		return fechaConfirmacion;
	}

	public void setFechaConfirmacion(Date fechaConfirmacion) {
		this.fechaConfirmacion = fechaConfirmacion;
	}

	public Date getFechaCierre() {
		return fechaCierre;
	}

	public void setFechaCierre(Date fechaCierre) {
		this.fechaCierre = fechaCierre;
	}

	public Float getCapitalVencido() {
		return capitalVencido;
	}

	public void setCapitalVencido(Float capitalVencido) {
		this.capitalVencido = capitalVencido;
	}

	public Float getCapitalNoVencido() {
		return capitalNoVencido;
	}

	public void setCapitalNoVencido(Float capitalNoVencido) {
		this.capitalNoVencido = capitalNoVencido;
	}

	public Float getInteresesDemora() {
		return interesesDemora;
	}

	public void setInteresesDemora(Float interesesDemora) {
		this.interesesDemora = interesesDemora;
	}

	public Float getTotal() {
		return total;
	}

	public void setTotal(Float total) {
		this.total = total;
	}

	public String getApoderado() {
		return apoderado;
	}

	public void setApoderado(String apoderado) {
		this.apoderado = apoderado;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
