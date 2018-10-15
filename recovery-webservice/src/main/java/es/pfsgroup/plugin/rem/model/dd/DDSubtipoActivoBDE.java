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
 * Modelo que gestiona el diccionario de los subtipos de activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_SBE_SUBTIPO_ACTIVO_BDE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipoActivoBDE implements Auditable, Dictionary {
	
	/**
	 * 
	 */
	public static final String CODIGO_INVERSION_INMOBILIARIA ="2";
	public static final String CODIGO_NO_SON_INMUEBLES ="3";
	public static final String CODIGO_OTROS ="4";
	public static final String CODIGO_VIV_RESID_HABITUAL="5";
	public static final String CODIGO_VIV_NO_RESID_HABITUAL ="6";
	public static final String CODIGO_VIVIENDAS_RESTOS ="7";
	public static final String CODIGO_OFICINAS_LOCALES_NAVES ="8";
	public static final String CODIGO_RESTOS_INMUEBLES ="9";
	public static final String CODIGO_SOLAR ="10";
	public static final String CODIGO_SUELO_URBANO ="11";
	public static final String CODIGO_SUELO_URBANIZABLE="12";
	public static final String CODIGO_SUELO_NO_URBANIZABLE ="13";
	public static final String CODIGO_SUELO_RUSTICO_VALORADO ="14";
	public static final String CODIGO_FINCAS_RUSTICAS_EN_EXPLOTAC ="15";
	public static final String CODIGO_RESTO_TERRENOS ="16";
	public static final String CODIGO_SUELO_URBANO_NO_CONSOLIDAD ="17";
	public static final String CODIGO_NO_C_6_7 ="18";
	
	private static final long serialVersionUID = 1L;
	
	/**
	 * 
	 */

	@Id
	@Column(name = "DD_SBE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubtipoActivoBDE")
	@SequenceGenerator(name = "DDSubtipoActivoBDE", sequenceName = "S_SBE_SUBTIPO_ACTIVO_BDE")
	private Long id;
	
	@Column(name = "DD_SBE_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SBE_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SBE_DESCRIPCION_LARGA")   
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
