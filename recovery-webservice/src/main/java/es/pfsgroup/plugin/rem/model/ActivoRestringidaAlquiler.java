package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;

@Entity
@Table(name = "ACT_RAL_RESTRINGIDA_ALQUILER", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@PrimaryKeyJoinColumn(name="AGR_ID")
public class ActivoRestringidaAlquiler extends ActivoAgrupacion implements Serializable{

	private static final long serialVersionUID = 1L;
	
    @ManyToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
    
    @ManyToOne
    @JoinColumn(name = "DD_LOC_ID")
    private Localidad localidad; 
    
    @Column(name = "RAL_DIRECCION")
	private String direccion;
    
    @Column(name = "RAL_CP")
	private String codigoPostal;
	
	@Column(name = "RAL_ACREEDOR_PDV")
	private String acreedorPDV;	

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

	public Localidad getLocalidad() {
		return localidad;
	}

	public void setLocalidad(Localidad localidad) {
		this.localidad = localidad;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getAcreedorPDV() {
		return acreedorPDV;
	}

	public void setAcreedorPDV(String acreedorPDV) {
		this.acreedorPDV = acreedorPDV;
	}

}
