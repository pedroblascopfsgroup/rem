package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.adjunto.model.Adjunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipologiaAgenda;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;

/**
 * Modelo que gestiona las Revisiones en el Título de un Activo
 * 
 * @author Alberto Flores
 *
 */
@Entity
@Table(name = "ACT_ART_AGENDA_REV_TITULO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoAgendaRevisionTitulo implements Serializable, Auditable {

	private static final long serialVersionUID = -7785802535778510517L;

	@Id
	@Column(name = "ART_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAgendaRevisionTitulo")
	@SequenceGenerator(name = "ActivoAgendaRevisionTitulo", sequenceName = "S_ACT_ART_AGENDA_REV_TITULO")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_STA_ID")
	private DDSubtipologiaAgenda subtipologiaAgenda;
	
	@Column(name = "ART_OBSERVACIONES")
	private String observaciones;
	
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

	public DDSubtipologiaAgenda getSubtipologiaAgenda() {
		return subtipologiaAgenda;
	}

	public void setSubtipologiaAgenda(DDSubtipologiaAgenda subtipologiaAgenda) {
		this.subtipologiaAgenda = subtipologiaAgenda;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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
