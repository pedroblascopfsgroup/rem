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
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAsistida;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoLoteComercial;


/**
 * Modelo que gestiona la información de las agrupaciones de tipo asistidas de los activos.
 */
@Entity
@Table(name = "ACT_LCO_LOTE_COMERCIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@PrimaryKeyJoinColumn(name="AGR_ID")
public class ActivoLoteComercial extends ActivoAgrupacion implements Serializable {

	private static final long serialVersionUID = 1L;

    @ManyToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
    
    @ManyToOne
    @JoinColumn(name = "DD_LOC_ID")
    private Localidad localidad; 
    
    @ManyToOne
    @JoinColumn(name = "DD_ELC_ID")
	private DDEstadoLoteComercial estadoLoteComercial;
    
    @Column(name = "LCO_DIRECCION")
	private String direccion;
    
    @Column(name = "LCO_CP")
	private String codigoPostal;
	
	@Column(name = "LCO_ACREEDOR_PDV")
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

	public DDEstadoLoteComercial getEstadoLoteComercial() {
		return estadoLoteComercial;
	}

	public void setEstadoLoteComercial(DDEstadoLoteComercial estadoLoteComercial) {
		this.estadoLoteComercial = estadoLoteComercial;
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
	
	public Integer getIncluidos() {
		return Checks.estaVacio(this.getActivos()) ? 0 : this.getActivos().size();
	}

}
