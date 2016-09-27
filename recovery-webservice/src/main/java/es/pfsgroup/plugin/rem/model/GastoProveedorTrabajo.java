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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;


/**
 * Modelo que gestiona la relación entre gastos y trabajo
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "GPV_TBJ", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class GastoProveedorTrabajo implements Serializable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "GPV_TBJ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoProveedorTrabajoGenerator")
    @SequenceGenerator(name = "GastoProveedorTrabajoGenerator", sequenceName = "S_GPV_TBJ")
    private Long id;
	
    @ManyToOne
    @JoinColumn(name = "GPV_ID")
    private GastoProveedor gastoProveedor; 

    @ManyToOne
    @JoinColumn(name = "TBJ_ID")
    private Trabajo trabajo;

	   
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public GastoProveedor getGastoProveedor() {
		return gastoProveedor;
	}

	public void setGastoProveedor(GastoProveedor gastoProveedor) {
		this.gastoProveedor = gastoProveedor;
	}

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}

	@Version   
	private Long version;
	

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}    
    
   
}
