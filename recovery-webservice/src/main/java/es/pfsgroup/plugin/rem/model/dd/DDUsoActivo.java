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
 * Modelo que gestiona el diccionario de uso activo
 * 
 * @author Ivan Repiso
 *
 */
@Entity
@Table(name = "DD_USA_USO_ACTIVO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDUsoActivo implements Auditable, Dictionary {
	
	
	public static final String COD_RESIDENCIAL ="01";
	public static final String COD_INDUSTRIAL ="02";
	public static final String COD_TERCIARIO = "03";
	public static final String COD_DOTACIONAL = "04";
	

	/**
	 * 
	 */
	private static final long serialVersionUID = 2307957295534774606L;

	@Id
	@Column(name = "DD_USA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDUsoActivoGenerator")
	@SequenceGenerator(name = "DDUsoActivoGenerator", sequenceName = "S_DD_USA_USO_ACTIVO")
	private Long id;
	
	@Column(name = "DD_USA_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_USA_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_USA_DESCRIPCION_LARGA")   
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
