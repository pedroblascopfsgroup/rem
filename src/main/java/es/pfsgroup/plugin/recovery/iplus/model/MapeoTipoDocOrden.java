package es.pfsgroup.plugin.recovery.iplus.model;

import java.io.Serializable;

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

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Entity
@Table(name = "MTO_MAPEO_TDOC_ORDEN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class MapeoTipoDocOrden implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "MTO_ID")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "DD_TFA_ID", nullable = true)
	private DDTipoFicheroAdjunto tipoFichero;

	@Column (name = "MTO_NUM_ORDEN")
	private Integer numOrden;
	

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

	public DDTipoFicheroAdjunto getTipoFichero() {
		return tipoFichero;
	}

	public void setTipoFichero(DDTipoFicheroAdjunto tipoFichero) {
		this.tipoFichero = tipoFichero;
	}

	public Integer getNumOrden() {
		return numOrden;
	}

	public void setNumOrden(Integer numOrden) {
		this.numOrden = numOrden;
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
