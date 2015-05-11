package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * JAVADOC FO.
 * 
 * @author FO
 * 
 */
@Entity
@Table(name = "DD_EPI_EST_INSTRU", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDEstadoLoteSubasta implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;

	public static final String CONFORMADA = "CONFORMADA";
	public static final String PROPUESTA = "PROPUESTA";
	public static final String APROBADA = "APROBADA";
	public static final String DEVUELTA = "DEVUELTA";
	public static final String SUSPENDIDA = "SUSPENDIDA";

	@Id
	@Column(name = "DD_EPI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoLoteSubastaGenerator")
    @SequenceGenerator(name = "DDEstadoLoteSubastaGenerator", sequenceName = "S_DD_EPI_EST_PROP_INST")
	private Long id;

	@Column(name = "DD_EPI_CODIGO")
	private String codigo;

	@Column(name = "DD_EPI_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_EPI_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

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
	 * @return the codigo
	 */
	public String getCodigo() {
		return codigo;
	}

	/**
	 * @param codigo
	 *            the codigo to set
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
}
