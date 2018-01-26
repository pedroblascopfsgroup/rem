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
 * Modelo que gestiona el diccionario de situación jurídica
 * 
 * @author Guillem Rey
 *
 */
@Entity
@Table(name = "DD_SIJ_SITUACION_JURIDICA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSituacionJuridica implements Auditable, Dictionary {
	
	public static String SITUACION_JURIDICA_DESCONOCIDO="0";
	public static String SITUACION_JURIDICA_ACTA="3";
	public static String SITUACION_JURIDICA_SE_DESCONOCE="4";
	public static String SITUACION_JURIDICA_PTE_INSCRIPCION="5";
	public static String SITUACION_JURIDICA_FIRME_SIN_POSESION_SIN_LANZAMIENTO="6";
	public static String SITUACION_JURIDICA_FIRME_PTE_POSESION="7";
	public static String SITUACION_JURIDICA_FIRME_SENYALADA_POSESION="8";
	public static String SITUACION_JURIDICA_FIRME_CON_POSESION_SIN_LANZAMIENTO="9";
	public static String SITUACION_JURIDICA_FIRME_CON_POSESION_PTE_LANZAMIENTO="10";
	public static String SITUACION_JURIDICA_FIRME_CON_POSESION_SENYALADO_LANZAMIENTO="11";
	public static String SITUACION_JURIDICA_FIRME_CON_POSESION_CON_LANZAMIENTO="12";
	public static String SITUACION_JURIDICA_FIRME_Y_ARRENDAMIENTO="13";
	public static String SITUACION_JURIDICA_FIRME_SIN_POSIBILIDAD_POSESION="15";
	public static String SITUACION_JURIDICA_AUTO_ADJUDICACION_PENDIENTE_DILIGENCIA="16";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_SIJ_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSituacionJuridica")
	@SequenceGenerator(name = "DDSituacionJuridica", sequenceName = "S_DD_SIJ_SITUACION_JURIDICA")
	private Long id;
	    
	@Column(name = "DD_SIJ_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SIJ_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SIJ_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_SIJ_INDICA_POSESION")   
	private Integer indicaPosesion;

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

	public Integer getIndicaPosesion() {
		return indicaPosesion;
	}

	public void setIndicaPosesion(Integer indicaPosesion) {
		this.indicaPosesion = indicaPosesion;
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