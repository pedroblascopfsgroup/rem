package es.pfsgroup.plugin.precontencioso.burofax.model;

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
import es.capgemini.pfs.direccion.model.Direccion;

@Entity
@Table(name = "PCO_BUR_ENVIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class EnvioBurofaxPCO implements Serializable, Auditable {

	private static final long serialVersionUID = -3872650022711770597L;

	@Id
	@Column(name = "PCO_BUR_ENVIO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EnvioBurofaxPCOGenerator")
	@SequenceGenerator(name = "EnvioBurofaxPCOGenerator", sequenceName = "S_PCO_BUR_ENVIO_ID")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "PCO_BUR_BUROFAX_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private BurofaxPCO burofax;

	@ManyToOne
	@JoinColumn(name = "DIR_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Direccion direccion;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_BFT_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDTipoBurofaxPCO tipoBurofax;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_BFR_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDResultadoBurofaxPCO resultadoBurofax;

	@Column(name = "PCO_BUR_ENVIO_FECHA_SOLICITUD")
	private Date fechaSolicitud;

	@Column(name = "PCO_BUR_ENVIO_FECHA_ENVIO")
	private Date fechaEnvio;

	@Column(name = "PCO_BUR_ENVIO_FECHA_ACUSO")
	private Date fechaAcuse;

	@Column(name = "PCO_BUR_ENVIO_CONTENIDO")
	private String contenidoBurofax;

	@Column(name = "PCO_BUR_ACUSE_RECIBO")
	private Long acuseRecibo;

	@Column(name = "SYS_GUID")
	private String sysGuid;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	

	/*
	 * GETTERS & SETTERS
	 */
	
	public BurofaxPCO getBurofax() {
		return burofax;
	}

	public void setBurofax(BurofaxPCO burofax) {
		this.burofax = burofax;
	}

	public Direccion getDireccion() {
		return direccion;
	}

	public void setDireccion(Direccion direccion) {
		this.direccion = direccion;
	}

	public DDTipoBurofaxPCO getTipoBurofax() {
		return tipoBurofax;
	}

	public void setTipoBurofax(DDTipoBurofaxPCO tipoBurofax) {
		this.tipoBurofax = tipoBurofax;
	}

	public DDResultadoBurofaxPCO getResultadoBurofax() {
		return resultadoBurofax;
	}

	public void setResultadoBurofax(DDResultadoBurofaxPCO resultadoBurofax) {
		this.resultadoBurofax = resultadoBurofax;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Date getFechaAcuse() {
		return fechaAcuse;
	}

	public void setFechaAcuse(Date fechaAcuse) {
		this.fechaAcuse = fechaAcuse;
	}

	public Long getAcuseRecibo() {
		return acuseRecibo;
	}

	public void setAcuseRecibo(Long acuseRecibo) {
		this.acuseRecibo = acuseRecibo;
	}
	
	public String getSysGuid() {
		return sysGuid;
	}

	public void setSysGuid(String sysGuid) {
		this.sysGuid = sysGuid;
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

	public Long getId() {
		return id;
	}

	public String getContenidoBurofax() {
		return contenidoBurofax;
	}

	public void setContenidoBurofax(String contenidoBurofax) {
		this.contenidoBurofax = contenidoBurofax;
	}

	
}
