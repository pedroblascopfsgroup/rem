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
 * Modelo que gestiona el diccionario de comites sancionadores internos
 */
@Entity
@Table(name = "DD_CIS_COMITE_INTERNO_SAN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDCisComiteInternoSancionador implements Auditable, Dictionary{
	
	public static final String CODIGO_PLANIFICACION_Y_CONTROL_INMOBILIARIO = "01";
	public static final String CODIGO_DIRECTOR_DE_PLANIFICACION_Y_CONTROL_INMOBILIARIO = "02";
	public static final String CODIGO_COMITE_DE_INVERSIONES_INMOBILIARIAS = "03";
	public static final String CODIGO_COMITE_DE_DIRECCION = "04";
	public static final String CODIGO_DIRECTOR_DE_RECUPERACIONES_Y_CENTROS_SUPERIORES = "05";
	public static final String CODIGO_COMITE_DE_SEGUIMIENTO_E_IMPAGOS = "06";
	public static final String CODIGO_COMITE_DE_RIESGOS = "07";
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "DD_CIS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSancionadorGenerator")
	@SequenceGenerator(name = "DDSancionadorGenerator", sequenceName = "S_DD_CIS_COMITE_INTERNO_SAN")
	private Long id;
	
	@Column(name = "DD_CIS_CODIGO")   
	private String codigo;
	
	@Column(name = "DD_CIS_DESCRIPCION")   
	private String descripcion;
	
	@Column(name = "DD_CIS_DESCRIPCION_LARGA")   
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
}
