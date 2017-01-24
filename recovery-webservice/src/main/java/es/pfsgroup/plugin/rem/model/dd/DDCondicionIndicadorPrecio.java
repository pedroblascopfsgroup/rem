package es.pfsgroup.plugin.rem.model.dd;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de condiciones indicadores precios.
 */
@Entity
@Table(name = "DD_CIP_CONDIC_IND_PRECIOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDCondicionIndicadorPrecio implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_CIP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDCondicionIndicadorPrecioGenerator")
	@SequenceGenerator(name = "DDCondicionIndicadorPrecioGenerator", sequenceName = "S_DD_CIP_CONDIC_IND_PRECIOS")
	private Long id;

	@Column(name = "DD_CIP_CODIGO")   
	private String codigo;

	@Column(name = "DD_CIP_DESCRIPCION")   
	private String descripcion;

	@Column(name = "DD_CIP_DESCRIPCION_LARGA")   
	private String descripcionLarga;

	@Column(name = "DD_CIP_TEXTO")   
	private String texto;

	@Column(name = "CIP_NECESITA_CONDICION")
	private Integer necesitaCondicion;

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

	public String getTexto() {
		return texto;
	}

	public void setTexto(String texto) {
		this.texto = texto;
	}

	public Integer getNecesitaCondicion() {
		return necesitaCondicion;
	}

	public void setNecesitaCondicion(Integer necesitaCondicion) {
		this.necesitaCondicion = necesitaCondicion;
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
