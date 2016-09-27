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
 * Modelo que gestiona el diccionario de los tipos de activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_TPA_TIPO_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoActivo implements Auditable, Dictionary {
	
	
	public static final String COD_SUELO ="01";
	public static final String COD_VIVIENDA ="02";
	public static final String COD_COMERCIAL ="03";
	public static final String COD_INDUSTRIAL ="04";
	public static final String COD_EDIFICIO_COMPLETO ="05";
	public static final String COD_EN_COSTRUCCION ="06";
	public static final String COD_OTROS ="07";
	
	

	/**
	 * 
	 */
	private static final long serialVersionUID = 2307957295534774606L;

	@Id
	@Column(name = "DD_TPA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoActivoGenerator")
	@SequenceGenerator(name = "DDTipoActivoGenerator", sequenceName = "S_DD_TPA_TIPO_ACTIVO")
	private Long id;
	
	@Column(name = "DD_TPA_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TPA_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPA_DESCRIPCION_LARGA")   
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
