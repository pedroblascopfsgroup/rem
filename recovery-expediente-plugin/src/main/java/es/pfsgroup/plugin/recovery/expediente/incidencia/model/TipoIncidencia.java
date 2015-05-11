package es.pfsgroup.plugin.recovery.expediente.incidencia.model;

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

@Entity
@Table(name = "DD_TII_TIPO_INCIDENCIA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class TipoIncidencia implements Auditable, Serializable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 2413849548470846776L;

	@Id
	@Column(name = "DD_TII_ID")
	private Long id;

	@Column(name = "DD_TII_CODIGO")
	private String codigo;

	@Column(name = "DD_TII_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_TII_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	/**
	 * Retorna el atributo auditoria.
	 * 
	 * @return auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * Setea el atributo auditoria.
	 * 
	 * @param auditoria
	 *            Auditoria
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * Retorna el atributo version.
	 * 
	 * @return version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * Setea el atributo version.
	 * 
	 * @param version
	 *            Integer
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}

}

