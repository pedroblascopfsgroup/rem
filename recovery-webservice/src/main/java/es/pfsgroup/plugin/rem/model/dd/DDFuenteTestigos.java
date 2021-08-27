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
 * Modelo que gestiona el diccionario de las fuentes de testigos
 * 
 * @author Ivan Repiso
 *
 */
@Entity
@Table(name = "DD_FTE_FUENTE_TESTIGOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDFuenteTestigos implements Auditable, Dictionary {
	
	
	public final static String COD_FUENTE_PORTAL = "01";
	public final static String COD_FUENTE_TRANS_REAL = "02";

	/**
	 * 
	 */
	private static final long serialVersionUID = -4491891020118703404L;

	@Id
	@Column(name = "DD_FTE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDFuenteTestigosGenerator")
	@SequenceGenerator(name = "DDFuenteTestigosGenerator", sequenceName = "S_DD_FTE_FUENTE_TESTIGOS")
	private Long id;
	
	@Column(name = "DD_FTE_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_FTE_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_FTE_DESCRIPCION_LARGA")   
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