package es.capgemini.pfs.politica.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;

/**
 * Clase que representa un registro en la tabla APO_ANALISIS_PERSONA_OPERAC.
 * @author pamuller
 *
 */
@Entity
@Table(name="APO_ANALISIS_PERSONA_OPERAC", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class AnalisisPersonaOperacion implements Serializable, Auditable {

	private static final long serialVersionUID = -2887036278778247978L;

	@Id
	@Column(name="APO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "AnalisisPersonaOperacionGenerator")
    @SequenceGenerator(name = "AnalisisPersonaOperacionGenerator", sequenceName = "S_APO_ANALISIS_PER_CNT")
	private Long id;

	@ManyToOne
	@JoinColumn(name="APP_ID")
	private AnalisisPersonaPolitica analisisPersonaPolitica;

	@ManyToOne
	@JoinColumn(name="CNT_ID")
	private Contrato contrato;

	@ManyToOne
	@JoinColumn(name="DD_IMP_ID")
	private DDImpacto impacto;

	@ManyToOne
	@JoinColumn(name="DD_VAL_ID")
	private DDValoracion valoracion;

	@Column(name="APO_COMENTARIO")
	private String comentario;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/**
	 * Devuelve la auditoría.
	 * @return auditoria
	 */
	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * setea auditoria.
	 * @param auditoria la auditoria.
	 */
	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the analisisPersonaPolitica
	 */
	public AnalisisPersonaPolitica getAnalisisPersonaPolitica() {
		return analisisPersonaPolitica;
	}

	/**
	 * @param analisisPersonaPolitica the analisisPersonaPolitica to set
	 */
	public void setAnalisisPersonaPolitica(
			AnalisisPersonaPolitica analisisPersonaPolitica) {
		this.analisisPersonaPolitica = analisisPersonaPolitica;
	}

	/**
	 * @return the contrato
	 */
	public Contrato getContrato() {
		return contrato;
	}

	/**
	 * @param contrato the contrato to set
	 */
	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	/**
	 * @return the impacto
	 */
	public DDImpacto getImpacto() {
		return impacto;
	}

	/**
	 * @param impacto the impacto to set
	 */
	public void setImpacto(DDImpacto impacto) {
		this.impacto = impacto;
	}

	/**
	 * @return the valoracion
	 */
	public DDValoracion getValoracion() {
		return valoracion;
	}

	/**
	 * @param valoracion the valoracion to set
	 */
	public void setValoracion(DDValoracion valoracion) {
		this.valoracion = valoracion;
	}

	/**
	 * @return the version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * @param version the version to set
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}

	/**
	 * @return the comentario
	 */
	public String getComentario() {
		return comentario;
	}

	/**
	 * @param comentario the comentario to set
	 */
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}

}
