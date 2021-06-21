package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;

@Entity
@Table(name = "TPD_STR_DOCSUBTBJ", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class TipoDocumentoSubtipoTrabajo implements Serializable, Auditable{

	private static final long serialVersionUID = -8745320767092816790L;

	@Id
	@Column(name = "TPS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "MetadatosDocumentosGenerator")
	@SequenceGenerator(name = "MetadatosDocumentosGenerator", sequenceName = "S_TPD_STR_DOCSUBTBJ")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TPD_ID")
	private DDTipoDocumentoActivo tipoDocumento;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_STR_ID")
	private DDSubtipoTrabajo subtipoTrabajo;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDTipoDocumentoActivo getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(DDTipoDocumentoActivo tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public DDSubtipoTrabajo getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(DDSubtipoTrabajo subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}	
}
