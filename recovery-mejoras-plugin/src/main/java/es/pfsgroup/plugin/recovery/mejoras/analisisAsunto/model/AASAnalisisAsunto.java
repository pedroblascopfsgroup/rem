package es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;

@Entity
@Table(name = "AAS_ANALISIS_ASUNTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class AASAnalisisAsunto implements Serializable, Auditable {

	private static final long serialVersionUID = 4391965937596568541L;

	@Id
	@Column(name = "AAS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "AnalisisAsuntoGenerator")
	@SequenceGenerator(name = "AnalisisAsuntoGenerator", sequenceName = "S_AAS_ANALISIS_ASUNTO")
	private Long id;

	@OneToOne
    @JoinColumn(name = "ASU_ID")
	private Asunto asunto;

	@Column(name = "AAS_OBSERVACION")
	private String observacion;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getObservacion() {
		return observacion;
	}

	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}

	@Embedded
	private Auditoria auditoria;

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;

	}

	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

	public Asunto getAsunto() {
		return asunto;
	}

	/**
	 * Texto sin formato HTML
	 * 
	 * @return
	 */
	public String getObservacionSinHTML() {
		if (Checks.esNulo(this.observacion)) return this.observacion;
		String cleanText = this.observacion.replaceAll("(<\\/p.*?>)", "$1\n");
		cleanText = cleanText.replaceAll("<br.*?>", "\n");
		cleanText = cleanText.replaceAll("<[^>]*>", "");
		return cleanText;
	}
	
}