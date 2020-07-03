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
 * Modelo que gestiona el diccionario de lo tipo de tributo
 * 
 */
@Entity
@Table(name = "DD_TPT_TIPO_TRIBUTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoTributo implements Auditable, Dictionary {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	
	public static final String COD_IBI_URBANO ="01";
	public static final String COD_IBI_RUSTICO ="02";
	public static final String COD_AGUA ="03";
	public static final String COD_ALCANTARILLADO ="04";
	public static final String COD_BASURA ="05";
	public static final String COD_EXTRACCIONES_MUNICIPALES ="06";
	public static final String COD_OTRAS_TASAS_MUNICIPALES ="07";
	public static final String COD_TASA_CANALONES ="08";
	public static final String COD_TASA_REGULACION_CATASTRAL ="09";
	public static final String COD_TASAS_ADMINISTRATIVAS ="10";
	public static final String COD_TRIBUTO_METROPOLITAN_MOVILIDAD ="11";
	public static final String COD_VADO ="12";
	public static final String COD_TASA_INCENDIOS ="13";


	@Id
	@Column(name = "DD_TPT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoTributoGenerator")
	@SequenceGenerator(name = "DDTipoTributoGenerator", sequenceName = "S_DD_TPT_TIPO_TRIBUTO")
	private Long id;
	    
	@Column(name = "DD_TPT_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TPT_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPT_DESCRIPCION_LARGA")   
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



