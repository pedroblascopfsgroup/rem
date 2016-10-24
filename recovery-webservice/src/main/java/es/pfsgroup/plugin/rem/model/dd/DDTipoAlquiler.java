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
 * Modelo que gestiona el diccionario de tipos de alquiler
 * 
 * @author jros
 *
 */
@Entity
@Table(name = "DD_TAL_TIPO_ALQUILER", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoAlquiler implements Auditable, Dictionary {
	
	public static final String CODIGO_ORDINARIO = "01";
    public static final String CODIGO_ALQUILER_OPCION_COMPRA = "02";
    public static final String CODIGO_FONDO_SOCIAL = "03";
    public static final String CODIGO_ESPECIAL = "04";

	/**
	 * 
	 */
	private static final long serialVersionUID = -3085379805977887759L;

	@Id
	@Column(name = "DD_TAL_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoAlquilerGenerator")
	@SequenceGenerator(name = "DDTipoAlquilerGenerator", sequenceName = "S_DD_TAL_TIPO_ALQUILER")
	private Long id;
	 
	@Column(name = "DD_TAL_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TAL_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TAL_DESCRIPCION_LARGA")   
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
