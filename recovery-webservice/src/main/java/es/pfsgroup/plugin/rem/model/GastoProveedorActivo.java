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
 * Modelo que gestiona la relación entre gastos y activo
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "GPV_ACT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class GastoProveedorActivo implements Serializable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "GPV_ACT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoProveedorActivoGenerator")
    @SequenceGenerator(name = "GastoProveedorActivoGenerator", sequenceName = "S_GPV_ACT")
    private Long id;
	
    @ManyToOne
    @JoinColumn(name = "GPV_ID")
    private GastoProveedor gastoProveedor; 

    @ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
    
    @Column(name = "GPV_PARTICIPACION_GASTO")
    private Double participacionGasto;
    
    @Column(name="GPV_REFERENCIA_CATASTRAL")
    private String referenciaCatastral;

	   
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Double getParticipacionGasto() {
		return participacionGasto;
	}

	public void setParticipacionGasto(Double participacionGasto) {
		this.participacionGasto = participacionGasto;
	}

	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}

	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
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
