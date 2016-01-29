package es.pfsgroup.recovery.hrebcc.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name="CRI_CONTRATO_RIESGOOPERACIONAL", schema = "${entity.schema}")
public class CntRiesgoOperacional implements Auditable, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 900518608719237907L;

	@Id
	@Column(name="CRI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "CntRiegoOperacionalGenerator")
    @SequenceGenerator(name = "CntRiegoOperacionalGenerator", sequenceName = "S_CRI_CONTRATO_RIESOPERACIONAL")	
	private Long id;
	
    @ManyToOne
    @JoinColumn(name = "CNT_ID")
	private Contrato contrato;

    @ManyToOne
	@JoinColumn(name="DD_RIO_ID")
	private DDRiesgoOperacional riesgoOperacional;	
	
	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public DDRiesgoOperacional getRiesgoOperacional() {
		return riesgoOperacional;
	}

	public void setRiesgoOperacional(DDRiesgoOperacional riesgoOperacional) {
		this.riesgoOperacional = riesgoOperacional;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
