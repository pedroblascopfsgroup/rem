package es.capgemini.pfs.vencidos.model;

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
 * Entidad Tipo Vencido
 * @author abarrantes
 */


@Entity
@Table(name = "DD_TVE_TIPO_VENCIDO", schema = "${entity.schema}")
@Cache(usage =CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoVencido implements Dictionary, Auditable {

	private static final long serialVersionUID = -4519203895538605774L;

	
	@Id
	@Column(name="DD_TVE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoVencidoGenerator")
	@SequenceGenerator(name="DDTipoVencidoGenerator", sequenceName="S_DD_TVE_TIPO_VENCIDO")
	private Long id;
	
	
	@Column(name="DD_TVE_CODIGO")
	private String codigo;
	
	@Column(name="DD_TVE_DESCRIPCION")
	private String descripcion;
	
	@Column(name="DD_TVE_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@Embedded
	private Auditoria auditoria;
	
	@Version
	private Integer version;

	/**
	 * @return id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return codigo
	 */
	public String getCodigo() {
		return codigo;
	}

	/**
	 * @param codigo
	 */
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	/**
	 * @return descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}

	/**
	 * @param descripcion
	 */
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	/**
	 * @return descripcionLarga
	 */
	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	/**
	 * @param descripcionLarga
	 */
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	/**
	 * @return auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * @param auditoria
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * @return version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * @param version
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}
}
