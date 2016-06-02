package es.capgemini.pfs.termino.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name="ACU_VALORES_TERMINOS", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class ValoresCamposTermino implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4382781358351005719L;
	
	@Id
	@Column(name="AVT_ID")
	@GeneratedValue(strategy=GenerationType.AUTO, generator="ValoresCamposTerminos")
	@SequenceGenerator(name="ValoresCamposTerminos", sequenceName="S_ACU_VALORES_TERMINOS")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name="TEA_ID")
	private TerminoAcuerdo termino;
	
	@ManyToOne
	@JoinColumn(name="CMP_ID")
	private CamposTerminoTipoAcuerdo campo;
	
	@Column(name="AVT_VALOR")
	private String valor;
	
	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public TerminoAcuerdo getTermino() {
		return termino;
	}

	public void setTermino(TerminoAcuerdo termino) {
		this.termino = termino;
	}

	public CamposTerminoTipoAcuerdo getCampo() {
		return campo;
	}

	public void setCampo(CamposTerminoTipoAcuerdo campo) {
		this.campo = campo;
	}

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
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
