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
 * Modelo que gestiona el diccionario de tipos de adecuacion alquiler.
 *
 * @author Vicente Martinez
 *
 */
@Entity
@Table(name = "DD_ROP_RIESGO_OPERACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDRiesgoOperacion implements Auditable, Dictionary {

	public static final String CODIGO_ROP_ALTO = "01";
	public static final String CODIGO_ROP_MEDIO = "02";
	public static final String CODIGO_ROP_BAJO = "03";
	public static final String CODIGO_ROP_NO_APLICA = "04";
	public static final String CODIGO_ROP_ALTO_C4C = "HIGH";
	public static final String CODIGO_ROP_MEDIO_C4C = "MEDIUM";
	public static final String CODIGO_ROP_BAJO_C4C = "LOW";
	public static final String CODIGO_ROP_ALTO_PBC = "A";
	public static final String CODIGO_ROP_MEDIO_PBC = "M";
	public static final String CODIGO_ROP_BAJO_PBC = "B";

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_ROP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDRiesgoOperacionGenerator")
	@SequenceGenerator(name = "DDRiesgoOperacionGenerator", sequenceName = "S_DD_ROP_RIESGO_OPERACION")
	private Long id;

	@Column(name = "DD_ROP_CODIGO")
	private String codigo;

	@Column(name = "DD_ROP_CODIGO_C4C")
	private String codigoC4C;

	@Column(name = "DD_ROP_CODIGO_PBC")
	private String codigoPbc;

	@Column(name = "DD_ROP_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_ROP_DESCRIPCION_LARGA")
	private String descripcionLarga;

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

	public String getCodigoC4C() {
		return codigoC4C;
	}

	public void setCodigoC4C(String codigoC4C) {
		this.codigoC4C = codigoC4C;
	}

	public String getCodigoPbc() {
		return codigoPbc;
	}

	public void setCodigoPbc(String codigoPbc) {
		this.codigoPbc = codigoPbc;
	}

}