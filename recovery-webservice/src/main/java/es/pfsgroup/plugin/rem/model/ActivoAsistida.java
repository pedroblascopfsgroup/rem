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


/**
 * Modelo que gestiona la información de las agrupaciones de tipo asistidas de los activos.
 *  
 * @author Daniel Gutiérrez
 */
@Entity
@Table(name = "ACT_ASI_ASISTIDA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@PrimaryKeyJoinColumn(name="AGR_ID")
public class ActivoAsistida extends ActivoAgrupacion implements Serializable {

	private static final long serialVersionUID = 1L;


    @ManyToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
    
    @ManyToOne
    @JoinColumn(name = "DD_LOC_ID")
    private Localidad localidad; 
    
    @ManyToOne
    @JoinColumn(name = "DD_EAS_ID")
	private DDEstadoAsistida estadoAsistida;
    
    @Column(name = "ASI_DIRECCION")
	private String direccion;
    
    @Column(name = "ASI_CP")
	private String codigoPostal;
	
	@Column(name = "ASI_ACREEDOR_PDV")
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

	public DDEstadoAsistida getEstadoAsistida() {
		return estadoAsistida;
	}

	public void setEstadoAsistida(DDEstadoAsistida estadoAsistida) {
		this.estadoAsistida = estadoAsistida;
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
