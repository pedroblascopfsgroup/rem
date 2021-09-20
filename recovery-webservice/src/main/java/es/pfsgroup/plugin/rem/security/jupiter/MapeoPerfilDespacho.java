
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
 * Modelo que el mapeo entre códigos de perfil y códigos de despacho y grupo
 *  
 * @author Pedro Blasco
 *
 */
@Entity
@Table(name = "MPD_MAPEO_PERFIL_DESPACHO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class MapeoPerfilDespacho  implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8143459658093989487L;

	@Id
    @Column(name = "MPD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MPDGenerator")
    @SequenceGenerator(name = "MPDGenerator", sequenceName = "S_MPD_MAPEO_JUPITER_REM")
    private Long id;
	
    @Column(name="MPD_CODIGO_PERFIL")
    private String codigoPerfil; 
    
    @Column(name="MPD_CODIGO_DESPACHO")
    private String codigoDespacho; 
    
    @Column(name="MPD_CODIGO_GRUPO")
    private String codigoGrupo; 
    
    @Column(name="MPD_NOTAS")
    private String notas; 
    
	@Column(name="MPD_MANUAL")
	private boolean manual;

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

	public String getCodigoPerfil() {
		return codigoPerfil;
	}

	public void setCodigoPerfil(String codigoPerfil) {
		this.codigoPerfil = codigoPerfil;
	}

	public String getCodigoDespacho() {
		return codigoDespacho;
	}

	public void setCodigoDespacho(String codigoDespacho) {
		this.codigoDespacho = codigoDespacho;
	}

	public String getCodigoGrupo() {
		return codigoGrupo;
	}

	public void setCodigoGrupo(String codigoGrupo) {
		this.codigoGrupo = codigoGrupo;
	}

	public String getNotas() {
		return notas;
	}

	public void setNotas(String notas) {
		this.notas = notas;
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

	public boolean isManual() {
		return manual;
	}

	public void setManual(boolean manual) {
		this.manual = manual;
	}

    
}
