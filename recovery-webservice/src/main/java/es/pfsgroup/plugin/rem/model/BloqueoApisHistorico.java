package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEspecialidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoBloqueoApi;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;



/**
 * Modelo que gestiona la informacion de los proveedores de los activos.
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "BHA_HIST_BLOQUEO_APIS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class BloqueoApisHistorico implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "BHA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "BloqueoApisHistoricoGenerator")
    @SequenceGenerator(name = "BloqueoApisHistoricoGenerator", sequenceName = "S_BHA_HIST_BLOQUEO_APIS")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "PVE_ID")
    private ActivoProveedor proveedor; 
    
	@ManyToOne
	@JoinColumn(name = "DD_TPB_ID")
	private DDTipoBloqueoApi tipoBloqueo;
	
	@ManyToOne
	@JoinColumn(name = "BHA_BLOQUEO_LN")
	private DDTipoComercializacion bloqueoApisLineaNegocio;
    
	@ManyToOne
	@JoinColumn(name = "BHA_BLOQUEO_CARTERA")
	private DDCartera bloqueoApisCartera;
    
	@ManyToOne
	@JoinColumn(name = "BHA_BLOQUEO_ESPECIALIDAD")
	private DDEspecialidad bloqueoApisEspecialidad;
    
	@ManyToOne
	@JoinColumn(name = "BHA_BLOQUEO_PRV")
	private DDProvincia bloqueoApisProvincia;
	
	@Column(name = "BHA_MOTIVO_BLOQUEO")
	private String motivoBloqueo;
	
	@Column(name = "BHA_MOTIVO_DESBLOQUEO")
	private String motivoDesbloqueo;
	
	
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

	public DDTipoBloqueoApi getTipoBloqueo() {
		return tipoBloqueo;
	}

	public void setTipoBloqueo(DDTipoBloqueoApi tipoBloqueo) {
		this.tipoBloqueo = tipoBloqueo;
	}

	public DDTipoComercializacion getBloqueoApisLineaNegocio() {
		return bloqueoApisLineaNegocio;
	}

	public void setBloqueoApisLineaNegocio(DDTipoComercializacion bloqueoApisLineaNegocio) {
		this.bloqueoApisLineaNegocio = bloqueoApisLineaNegocio;
	}

	public DDCartera getBloqueoApisCartera() {
		return bloqueoApisCartera;
	}

	public void setBloqueoApisCartera(DDCartera bloqueoApisCartera) {
		this.bloqueoApisCartera = bloqueoApisCartera;
	}

	public DDEspecialidad getBloqueoApisEspecialidad() {
		return bloqueoApisEspecialidad;
	}

	public void setBloqueoApisEspecialidad(DDEspecialidad bloqueoApisEspecialidad) {
		this.bloqueoApisEspecialidad = bloqueoApisEspecialidad;
	}

	public DDProvincia getBloqueoApisProvincia() {
		return bloqueoApisProvincia;
	}

	public void setBloqueoApisProvincia(DDProvincia bloqueoApisProvincia) {
		this.bloqueoApisProvincia = bloqueoApisProvincia;
	}

	public String getMotivoBloqueo() {
		return motivoBloqueo;
	}

	public void setMotivoBloqueo(String motivoBloqueo) {
		this.motivoBloqueo = motivoBloqueo;
	}

	public String getMotivoDesbloqueo() {
		return motivoDesbloqueo;
	}

	public void setMotivoDesbloqueo(String motivoDesbloqueo) {
		this.motivoDesbloqueo = motivoDesbloqueo;
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
