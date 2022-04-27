package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoObraNueva;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;


/**
 * Modelo que gestiona la información de las agrupaciones de tipo obra nueva de los activos.
 *  
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_ONV_OBRA_NUEVA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@PrimaryKeyJoinColumn(name="AGR_ID")
public class ActivoObraNueva extends ActivoAgrupacion implements Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
    @ManyToOne
    @JoinColumn(name = "DD_PRV_ID")
    private DDProvincia provincia;
    
    @ManyToOne
    @JoinColumn(name = "DD_LOC_ID")
    private Localidad localidad; 
    
    @ManyToOne
    @JoinColumn(name = "DD_EON_ID")
	private DDEstadoObraNueva estadoObraNueva;
    
    @Column(name = "ONV_DIRECCION")
	private String direccion;
    
    @Column(name = "ONV_CP")
	private String codigoPostal;
	
	@Column(name = "ONV_ACREEDOR_PDV")
	private String acreedorPDV;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ONV_VENTA_PLANO")
	private DDSinSiNo ventaPlano;
	
	@OneToMany(mappedBy = "obraNueva", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "AGR_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ActivoSubdivision> subdivision;
	
	@Column(name = "ONV_DND_ID")
	private String idOnvDnd;

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

	public DDEstadoObraNueva getEstadoObraNueva() {
		return estadoObraNueva;
	}

	public void setEstadoObraNueva(DDEstadoObraNueva estadoObraNueva) {
		this.estadoObraNueva = estadoObraNueva;
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

	public DDSinSiNo getVentaPlano() {
		return ventaPlano;
	}

	public void setVentaPlano(DDSinSiNo ventaPlano) {
		this.ventaPlano = ventaPlano;
	}

	public List<ActivoSubdivision> getSubdivision() {
		return subdivision;
	}

	public void setSubdivision(List<ActivoSubdivision> subdivision) {
		this.subdivision = subdivision;
	}

	public String getIdOnvDnd() {
		return idOnvDnd;
	}

	public void setIdOnvDnd(String idOnvDnd) {
		this.idOnvDnd = idOnvDnd;
	}
	
	public Integer getIncluidos() {
        return Checks.estaVacio(this.getActivos()) ? 0 : this.getActivos().size();
    }
		

}
