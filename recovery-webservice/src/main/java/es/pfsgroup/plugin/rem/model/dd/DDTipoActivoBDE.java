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
@Table(name = "DD_TBE_TIPO_ACTIVO_BDE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoActivoBDE implements Auditable, Dictionary {
	
	/**
	 * 
	 */
	public static final String CODIGO_EFICIOS_TERMINADOS ="2";
	public static final String CODIGO_SUELOS ="3";
	public static final String CODIGO_DCHOS_HEREDITARIOS ="4";
	public static final String CODIGO_INVERSION_INMOBILIARIA ="5";
	public static final String CODIGO_NO_SON_INMUEBLES ="6";
	public static final String CODIGO_EDIF_EN_CONTRUC_OBRA_EN_MARCHA ="7";
	public static final String CODIGO_EDIF_TERMINADO_POR_SAREB ="8";
	public static final String CODIGO_OTROS ="99";

	private static final long serialVersionUID = 1L;
	
	/**
	 * 
	 */

	@Id
	@Column(name = "DD_TBE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoActivoBDE")
	@SequenceGenerator(name = "DDTipoActivoBDE", sequenceName = "S_TBE_TIPO_ACTIVO_BDE")
	private Long id;
	
	@Column(name = "DD_TBE_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TBE_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TBE_DESCRIPCION_LARGA")   
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
