package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;

/**
 * Modelo que gestiona las configuraciones de las transiciones de fases de publicacion de los activos.
 */
@Entity
@Table(name = "ACT_GTP_GES_TRANS_PERMITIDAS", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoConfiguracionesTransiciones implements Serializable, Auditable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "GTP_ID")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_TGE_ID")
	private EXTDDTipoGestor tipoGestor;
	
	@ManyToOne
	@JoinColumn(name = "DD_TPR_ID")
	private DDTipoProveedor tipoProveedor;
	
	@ManyToOne
	@JoinColumn(name = "TFP_ID")
	private ActivoTransicionesFasesPublicacion transicion;
	
	@Column(name = "GTP_TOTAL")
	private Boolean gtpTotal;
	
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

	public EXTDDTipoGestor getTipoGestor() {
		return tipoGestor;
	}

	public void setTipoGestor(EXTDDTipoGestor tipoGestor) {
		this.tipoGestor = tipoGestor;
	}

	public DDTipoProveedor getTipoProveedor() {
		return tipoProveedor;
	}

	public void setTipoProveedor(DDTipoProveedor tipoProveedor) {
		this.tipoProveedor = tipoProveedor;
	}

	public ActivoTransicionesFasesPublicacion getTransicion() {
		return transicion;
	}

	public void setTransicion(ActivoTransicionesFasesPublicacion transicion) {
		this.transicion = transicion;
	}

	public Boolean getGtpTotal() {
		return gtpTotal;
	}

	public void setGtpTotal(Boolean gtpTotal) {
		this.gtpTotal = gtpTotal;
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
