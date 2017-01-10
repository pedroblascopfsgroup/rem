package es.pfsgroup.plugin.rem.model.dd;

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
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de tipo de areas de bloqueos.
 */
@Entity
@Table(name = "DD_TBL_TIPO_BLOQUEOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoBloqueo implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TBL_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoBloqueoGenerator")
	@SequenceGenerator(name = "DDTipoBloqueoGenerator", sequenceName = "S_DD_TBL_TIPO_BLOQUEOS")
	private Long id;

	@Column(name = "DD_TBL_CODIGO")   
	private String codigo;

	@Column(name = "DD_TBL_DESCRIPCION")   
	private String descripcion;

	@Column(name = "DD_TBL_DESCRIPCION_LARGA")   
	private String descripcionLarga;

	@ManyToOne
    @JoinColumn(name = "DD_ABL_ID")
	private DDAreaBloqueo area;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
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

	public DDAreaBloqueo getArea() {
		return area;
	}

	public void setArea(DDAreaBloqueo area) {
		this.area = area;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}