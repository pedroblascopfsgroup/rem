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

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;


/**
 * Modelo que gestiona la relación de proveedores con las provincias en las que ejercen.
 */
@Entity
@Table(name = "ACT_PTE_PROVEED_TERRITORIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ProveedorTerritorial implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "PTE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ProveedorTerritorialGenerator")
    @SequenceGenerator(name = "ProveedorTerritorialGenerator", sequenceName = "S_ACT_PTE_PROVEED_TERRITORIAL")
    private Long id;
	
    @ManyToOne
    @JoinColumn(name = "PVE_ID")
    private ActivoProveedor proveedor;
    
    @ManyToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
	
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

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

}
