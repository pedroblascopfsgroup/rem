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
import es.pfsgroup.plugin.rem.model.dd.DDEstEstadoPrefactura;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;

/**
 * Modelo que gestiona el modelo de Prefacturas para la gestión, 
 * flujo e información de los trabajos.
 * 
 * @author Alberto Flores
 */
@Entity
@Table(name = "PFA_PREFACTURA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class Prefactura implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "PFA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "PrefacturaGenerator")
	@SequenceGenerator(name = "PrefacturaGenerator", sequenceName = "S_PFA_PREFACTURA")
	private Long id;

	@Column(name = "PFA_NUM_PREFACTURA")
	private Long numPrefactura;

	@Column(name = "PFA_FECHA_PREFACTURA")
	private Date fechaPrefactura;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PVE_ID")
	private ActivoProveedor proveedor;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PRO_ID")
	private ActivoPropietario propietario;
	
	@ManyToOne
	@JoinColumn(name = "DD_EPF_ID")
	private DDEstEstadoPrefactura estadoPrefactura;
	
	
	@ManyToOne
	@JoinColumn(name = "ALB_ID")
	private Albaran albaran;
	
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

	public Long getNumPrefactura() {
		return numPrefactura;
	}

	public void setNumPrefactura(Long numPrefactura) {
		this.numPrefactura = numPrefactura;
	}

	public Date getFechaPrefactura() {
		return fechaPrefactura;
	}

	public void setFechaPrefactura(Date fechaPrefactura) {
		this.fechaPrefactura = fechaPrefactura;
	}

	public ActivoProveedor getProveedor() {
		return proveedor;
	}

	public void setProveedor(ActivoProveedor proveedor) {
		this.proveedor = proveedor;
	}

	public ActivoPropietario getPropietario() {
		return propietario;
	}

	public void setPropietario(ActivoPropietario propietario) {
		this.propietario = propietario;
	}

	public DDEstEstadoPrefactura getEstadoPrefactura() {
		return estadoPrefactura;
	}

	public void setEstadoPrefactura(DDEstEstadoPrefactura estadoPrefactura) {
		this.estadoPrefactura = estadoPrefactura;
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

	public Albaran getAlbaran() {
		return albaran;
	}

	public void setAlbaran(Albaran albaran) {
		this.albaran = albaran;
	}
	
	
	
}
