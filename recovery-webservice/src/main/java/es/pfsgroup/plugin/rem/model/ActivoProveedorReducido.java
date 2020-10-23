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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedorRetirar;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRetencion;
import es.pfsgroup.plugin.rem.model.dd.DDOperativa;
import es.pfsgroup.plugin.rem.model.dd.DDResultadoProcesoBlanqueo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivosCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoZonaGeografica;
import es.pfsgroup.plugin.rem.model.dd.DDTiposColaborador;



/**
 * Modelo que gestiona la informacion de los proveedores de los activos pero de una forma reducida
 * para optimizar la cantidad de datos recibida.
 * 
 * @author Alberto Flores
 *
 */
@Entity
@Table(name = "ACT_PVE_PROVEEDOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoProveedorReducido implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "PVE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoProveedorGenerator")
	@SequenceGenerator(name = "ActivoProveedorGenerator", sequenceName = "S_ACT_PVE_PROVEEDOR")
	private Long id;
	
	@Column(name = "PVE_NOMBRE")
	private String nombre;
	
	@Column(name = "PVE_NOMBRE_COMERCIAL")
	private String nombreComercial;
	
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

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombreComercial() {
		return nombreComercial;
	}

	public void setNombreComercial(String nombreComercial) {
		this.nombreComercial = nombreComercial;
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
