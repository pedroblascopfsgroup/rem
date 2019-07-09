package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

/**
 * Modelo que gestiona la informacion de los proveedores de los activos.
 * 
 * @author Vicente Martinez Cifre
 *
 */
@Entity
@Table(name = "PCC_PROV_CARTERA_CONFIG", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoProveedorCartera implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "PCC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoProveedorCarteraGenerator")
    @SequenceGenerator(name = "ActivoProveedorCarteraGenerator", sequenceName = "S_PCC_PROV_CARTERA_CONFIG")
    private Long id;
	
	@ManyToOne
	@JoinColumn(name = "PVE_ID")
    private ActivoProveedor proveedor; 
	
	@ManyToOne
	@JoinColumn(name = "DD_CRA_ID")
	private DDCartera cartera;
	
	@JoinColumn(name = "ID_HAYA")
	private Long idPersonaHaya;

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

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public Long getIdPersonaHaya() {
		return idPersonaHaya;
	}

	public void setIdPersonaHaya(Long idPersonaHaya) {
		this.idPersonaHaya = idPersonaHaya;
	}
	
	

}
