package es.capgemini.pfs.acuerdo.model;

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

/**
 * Clase que representa a un ActuacionesAExplorarAcuerdo.
 * @author jbosnjak
 *
 */
@Entity
@Table(name="AEA_ACTUACIO_EXPLOR_ACUERDO", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ActuacionesAExplorarAcuerdo implements Serializable,Auditable,Comparable<Object> {

	private static final long serialVersionUID = 0L;

	@Id
	@Column(name="AEA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActuacionesAExplorarAcuerdoGenerator")
    @SequenceGenerator(name = "ActuacionesAExplorarAcuerdoGenerator", sequenceName = "S_AEA_ACTUACIO_EXPLOR_ACUERDO")
	private Long id;

	@ManyToOne
	@JoinColumn(name="ACU_ID")
	private Acuerdo acuerdo;

	@ManyToOne
	@JoinColumn(name="DD_SSA_ID")
	private DDSubtipoSolucionAmistosaAcuerdo ddSubtipoSolucionAmistosaAcuerdo;

	@ManyToOne
	@JoinColumn(name="DD_VAA_ID")
	private DDValoracionActuacionAmistosa ddValoracionActuacionAmistosa;

	@Column(name="AEA_OBSERVACIONES")
	private String observaciones;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	@Column(name = "SYS_GUID")
	private String guid;
	
	/**
	 * Se implementa este método para poder ordenar un List de esta clase
	 * para la lista de acuerdos a explorar, donde debe aparecer ordenada por el
	 * tipo del ddSubtipoSolucionAmistosaAcuerdo.
	 * @param o Object
	 * @return int
	 */
	public int compareTo(Object o) {
	    ActuacionesAExplorarAcuerdo act = (ActuacionesAExplorarAcuerdo) o;
	    return ddSubtipoSolucionAmistosaAcuerdo.getDdTipoSolucionAmistosa().getCodigo()
	            .compareTo(act.getDdSubtipoSolucionAmistosaAcuerdo().getDdTipoSolucionAmistosa().getCodigo());
	}

	/**
	 * @return boolean: si el tipo o subtipo de solución es activo <code>true</code>, sino <code>false</code>
	 */
	public boolean isActivo() {
	    return (ddSubtipoSolucionAmistosaAcuerdo.getDdTipoSolucionAmistosa().isActivo()
                && ddSubtipoSolucionAmistosaAcuerdo.isActivo());
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
	 * @return the acuerdo
	 */
	public Acuerdo getAcuerdo() {
		return acuerdo;
	}
	/**
	 * @param acuerdo the acuerdo to set
	 */
	public void setAcuerdo(Acuerdo acuerdo) {
		this.acuerdo = acuerdo;
	}
	/**
	 * @return the ddSubtipoSolucionAmistosaAcuerdo
	 */
	public DDSubtipoSolucionAmistosaAcuerdo getDdSubtipoSolucionAmistosaAcuerdo() {
		return ddSubtipoSolucionAmistosaAcuerdo;
	}
	/**
	 * @param ddSubtipoSolucionAmistosaAcuerdo the ddSubtipoSolucionAmistosaAcuerdo to set
	 */
	public void setDdSubtipoSolucionAmistosaAcuerdo(
			DDSubtipoSolucionAmistosaAcuerdo ddSubtipoSolucionAmistosaAcuerdo) {
		this.ddSubtipoSolucionAmistosaAcuerdo = ddSubtipoSolucionAmistosaAcuerdo;
	}
	/**
	 * @return the ddValoracionActuacionAmistosa
	 */
	public DDValoracionActuacionAmistosa getDdValoracionActuacionAmistosa() {
		return ddValoracionActuacionAmistosa;
	}
	/**
	 * @param ddValoracionActuacionAmistosa the ddValoracionActuacionAmistosa to set
	 */
	public void setDdValoracionActuacionAmistosa(
			DDValoracionActuacionAmistosa ddValoracionActuacionAmistosa) {
		this.ddValoracionActuacionAmistosa = ddValoracionActuacionAmistosa;
	}
	/**
	 * @return the observaciones
	 */
	public String getObservaciones() {
		return observaciones;
	}
	/**
	 * @param observaciones the observaciones to set
	 */
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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
	 * @return the auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}
	/**
	 * @param auditoria the auditoria to set
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
	
	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}
	
}
