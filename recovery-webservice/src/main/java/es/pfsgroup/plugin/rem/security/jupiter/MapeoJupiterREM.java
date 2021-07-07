
package es.pfsgroup.plugin.rem.security.jupiter;

import java.io.Serializable;

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

/**
 * Modelo que el mapeo entre códigos Júpiter y códigos REM
 *  
 * @author Pedro Blasco
 *
 */
@Entity
@Table(name = "MJR_MAPEO_JUPITER_REM", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class MapeoJupiterREM  implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8143459658093989487L;

	@Id
    @Column(name = "MJR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MJRGenerator")
    @SequenceGenerator(name = "MJRGenerator", sequenceName = "S_MJR_MAPEO_JUPITER_REM")
    private Long id;
	
    @Column(name="MJR_CODIGO_JUPITER")
    private String codigoJupiter; 
    
    @Column(name="MJR_NOMBRE")
    private String nombre; 
    
    @Column(name="MJR_DESCRIPCION")
    private String descripcion; 
    
    @Column(name="MJR_TIPO_PERFIL")
    private String tipoPerfil; 
    
    @Column(name="MJR_CODIGO_REM")
    private String codigoREM; 
    
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

	public String getCodigoJupiter() {
		return codigoJupiter;
	}

	public void setCodigoJupiter(String codigoJupiter) {
		this.codigoJupiter = codigoJupiter;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getTipoPerfil() {
		return tipoPerfil;
	}

	public void setTipoPerfil(String tipoPerfil) {
		this.tipoPerfil = tipoPerfil;
	}

	public String getCodigoREM() {
		return codigoREM;
	}

	public void setCodigoREM(String codigoREM) {
		this.codigoREM = codigoREM;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
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
