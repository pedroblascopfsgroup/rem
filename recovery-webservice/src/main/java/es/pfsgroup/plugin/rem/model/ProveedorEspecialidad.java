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
import es.pfsgroup.plugin.rem.model.dd.DDEspecialidad;



/**
 * clase modelo de PVE_PROVEEDOR_ESPECIALIDAD.
 *
 */
@Entity
@Table(name = "PVE_PROVEEDOR_ESPECIALIDAD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class ProveedorEspecialidad implements Serializable,Auditable {
    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "PVE_ESP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ProveedorEspecialidadGenerator")
    @SequenceGenerator(name = "ProveedorEspecialidadGenerator", sequenceName = "S_PVE_PROVEEDOR_ESPECIALIDAD")
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "PVE_ID")
    private ActivoProveedor proveedor;

    @ManyToOne
    @JoinColumn(name = "DD_ESP_ID")
    private DDEspecialidad especialidad;
    
    @ManyToOne
    @JoinColumn(name = "PRD_ID")
    private ActivoProveedorDireccion direccion;

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

	public DDEspecialidad getEspecialidad() {
		return especialidad;
	}

	public void setEspecialidad(DDEspecialidad especialidad) {
		this.especialidad = especialidad;
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

	public ActivoProveedorDireccion getDireccion() {
		return direccion;
	}

	public void setDireccion(ActivoProveedorDireccion direccion) {
		this.direccion = direccion;
	}

}
