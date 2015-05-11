package es.capgemini.pfs.zona.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;

/**
 * Clase que representa un nivel.
 *
 * @author jbosnjak
 *
 */
@Entity
@Table(name = "NIV_NIVEL", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class Nivel implements Serializable, Auditable {

	private static final long serialVersionUID = 1687925201006608232L;
	public static final Long NIVEL_ENTIDAD = 1L;
	public static final Long NIVEL_TERRITORIO = 2L;
	public static final Long NIVEL_ZONA = 3L;
	public static final Long NIVEL_OFICINA = 4L;

	@Id
	@Column(name = "NIV_ID")
	private Long id;

	@Column(name = "NIV_DESCRIPCION")
	private String descripcion;

	@Column(name = "NIV_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@Column(name = "NIV_CODIGO")
	private Integer codigo;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}

	/**
	 * @param descripcion
	 *            the descripcion to set
	 */
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	/**
	 * @return the descripcionLarga
	 */
	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	/**
	 * @param descripcionLarga
	 *            the descripcionLarga to set
	 */
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	/**
	 * @return the version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * @param version
	 *            the version to set
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
	 * @param auditoria
	 *            the auditoria to set
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * @return the serialVersionUID
	 */
	public static long getSerialVersionUID() {
		return serialVersionUID;
	}

	/**
	 * @return the codigo
	 */
	public String getCodigo() {
		return (!Checks.esNulo(codigo)) ? codigo.toString() : getId().toString(); 
	}
}
