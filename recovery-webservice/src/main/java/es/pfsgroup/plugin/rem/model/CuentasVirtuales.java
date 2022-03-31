package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

/**
 * Modelo que gestiona la tabla de cuentas virtuales 
 * 
 * 
 * @author IRF
 */
@Entity
@Table(name = "CVC_CUENTAS_VIRTUALES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class CuentasVirtuales implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "CVC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CuentasVirtualesGenerator")
	@SequenceGenerator(name = "CuentasVirtualesGenerator", sequenceName = "S_ALB_ALBARAN")
	private Long id;
	
	@Column(name = "CVC_CUENTA_VIRTUAL")
	private String cuentaVirtual;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_SRC_ID")
	private DDSubcartera subcartera;
	
	@Column(name = "CVC_FECHA_INICIO")
	private Date fechaInicio;

	@Column(name = "CVC_FECHA_FIN")
	private Date fechaFin;
	
	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCuentaVirtual() {
		return cuentaVirtual;
	}

	public void setCuentaVirtual(String cuentaVirtual) {
		this.cuentaVirtual = cuentaVirtual;
	}

	public DDSubcartera getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(DDSubcartera subcartera) {
		this.subcartera = subcartera;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	
}
