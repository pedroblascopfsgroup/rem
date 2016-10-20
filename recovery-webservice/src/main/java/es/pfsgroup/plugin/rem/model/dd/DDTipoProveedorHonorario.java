

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
 * Modelo que gestiona el diccionario tipos proveedores del honorario del expediente
 */
@Entity
@Table(name = "DD_TPH_TIPO_PROV_HONORARIO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoProveedorHonorario implements Auditable, Dictionary {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TPH_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoProveedorHonorarioGenerator")
	@SequenceGenerator(name = "DDTipoProveedorHonorarioGenerator", sequenceName = "S_DD_TPH_TIPO_PROV_HONORARIO")
	private Long id;
	    
	@Column(name = "DD_TPH_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TPH_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TPH_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	public static final String CODIGO_MEDIADOR = "04";
	public static final String CODIGO_FVD = "18";
	public static final String CODIGO_CAT = "28";
	public static final String CODIGO_MEDIADOR_OFICINA = "29";
	public static final String CODIGO_OFICINA_BANKIA = "30";
	public static final String CODIGO_OFICINA_CAJAMAR = "31";
	    
	
	    
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



