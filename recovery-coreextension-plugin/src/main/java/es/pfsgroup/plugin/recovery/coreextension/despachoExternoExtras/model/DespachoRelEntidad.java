package es.pfsgroup.plugin.recovery.coreextension.despachoExternoExtras.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * 
 */
@Entity
@Table(name = "DD_DRE_DESPACHO_REL_ENTIDAD", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DespachoRelEntidad implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 447518964016803435L;

	@Id
	@Column(name = "DD_DRE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DespachoRelEntidadGenerator")
	@SequenceGenerator(name = "DespachoRelEntidadGenerator", sequenceName = "S_DD_DRE_DESPACHO_REL_ENTIDAD")
	private Long id;

	@Column(name = "DD_DRE_CODIGO")
	private String codigo;

	@Column(name = "DD_DRE_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_DRE_DESCRIPCION_LARGA")
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

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

}
