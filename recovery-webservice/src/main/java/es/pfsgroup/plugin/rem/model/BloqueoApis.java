package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.*;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedorRetirar;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencion;
import es.pfsgroup.plugin.rem.model.dd.DDOperativa;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenPeticionHomologacion;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoProcesoBlanqueo;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivosCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoZonaGeografica;
import es.pfsgroup.plugin.rem.model.dd.DDTiposColaborador;



/**
 * Modelo que gestiona la informacion de los proveedores de los activos.
 * 
 * @author Lara
 *
 */
@Entity
@Table(name = "BAP_BLOQUEO_APIS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class BloqueoApis implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "BAP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "BloqueoApisGenerator")
    @SequenceGenerator(name = "BloqueoApisGenerator", sequenceName = "S_BAP_BLOQUEO_APIS")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "PVE_ID")
    private ActivoProveedor proveedor; 
    
	@Column(name = "BAP_MOTIVO")
	private String motivoBloqueo;
	
    @OneToMany(mappedBy = "bloqueoApis", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BAC_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<BloqueoApisCartera> bloqueoApisCartera;    
    
    @OneToMany(mappedBy = "bloqueoApis", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BAL_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<BloqueoApisLineaNegocio> bloqueoApisLineaNegocio;    
    
    @OneToMany(mappedBy = "bloqueoApis", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BAE_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<BloqueoApisEspecialidad> bloqueoApisEspecialidad;    
    
    @OneToMany(mappedBy = "bloqueoApis", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "BAR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
	private List<BloqueoApisProvincia> bloqueoApisProvincia;    
	

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

	public ActivoProveedor getProveedor() {
		return proveedor;
	}

	public void setProveedor(ActivoProveedor proveedor) {
		this.proveedor = proveedor;
	}

	public String getMotivoBloqueo() {
		return motivoBloqueo;
	}

	public void setMotivoBloqueo(String motivoBloqueo) {
		this.motivoBloqueo = motivoBloqueo;
	}

	public List<BloqueoApisCartera> getBloqueoApisCartera() {
		return bloqueoApisCartera;
	}

	public void setBloqueoApisCartera(List<BloqueoApisCartera> bloqueoApisCartera) {
		this.bloqueoApisCartera = bloqueoApisCartera;
	}

	public List<BloqueoApisLineaNegocio> getBloqueoApisLineaNegocio() {
		return bloqueoApisLineaNegocio;
	}

	public void setBloqueoApisLineaNegocio(List<BloqueoApisLineaNegocio> bloqueoApisLineaNegocio) {
		this.bloqueoApisLineaNegocio = bloqueoApisLineaNegocio;
	}

	public List<BloqueoApisEspecialidad> getBloqueoApisEspecialidad() {
		return bloqueoApisEspecialidad;
	}

	public void setBloqueoApisEspecialidad(List<BloqueoApisEspecialidad> bloqueoApisEspecialidad) {
		this.bloqueoApisEspecialidad = bloqueoApisEspecialidad;
	}

	public List<BloqueoApisProvincia> getBloqueoApisProvincia() {
		return bloqueoApisProvincia;
	}

	public void setBloqueoApisProvincia(List<BloqueoApisProvincia> bloqueoApisProvincia) {
		this.bloqueoApisProvincia = bloqueoApisProvincia;
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
