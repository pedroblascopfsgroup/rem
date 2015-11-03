package es.capgemini.pfs.decisionProcedimiento.model;


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
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * poner javadoc FO.
 * @author fo
 *
 */
@Entity
@Table(name = "DD_EDE_ESTADOS_DECISION", schema = "${master.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_ONLY)
public class DDEstadoDecision implements Auditable, Dictionary {

	/**
	 * serialVersionUID.
	 */
	private static final long serialVersionUID = -6478855940385958256L;
	public static final String ESTADO_PROPUESTO = "01";
	public static final String ESTADO_ACEPTADO = "02";
	public static final String ESTADO_RECHAZADO = "03";
	public static final String ESTADO_EN_CONFORMACION = "04";
	@Id
	@Column(name = "DD_EDE_ID")
	private Long id;
	@Column(name = "DD_EDE_CODIGO")
	private String codigo;
	@Column(name = "DD_EDE_DESCRIPCION")
	private String descripcion;
	@Column(name = "DD_EDE_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@Version
	private Long version;

	@Embedded
	private Auditoria auditoria;


	/**
	 * toString.
	 * @return string
	 */
	@Override
	public String toString() {
		return descripcion;
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
	 * @return the codigo
	 */
	public String getCodigo() {
		return codigo;
	}


	/**
	 * @param codigo the codigo to set
	 */
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}


	/**
	 * @return the descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}


	/**
	 * @param descripcion the descripcion to set
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
	 * @param descripcionLarga the descripcionLarga to set
	 */
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}


	/**
	 * @return the version
	 */
	public Long getVersion() {
		return version;
	}


	/**
	 * @param version the version to set
	 */
	public void setVersion(Long version) {
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
}
