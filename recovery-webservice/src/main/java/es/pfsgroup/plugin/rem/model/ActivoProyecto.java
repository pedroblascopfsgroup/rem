package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;

/**
 * Modelo que gestiona la información de las agrupaciones de tipo proyecto de los activos.
 *  
 * @author Alejandro Valverde Herrera
 *
 */
@Entity
@Table(name = "ACT_PRY_PROYECTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoProyecto extends ActivoAgrupacion implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@ManyToOne
    @JoinColumn(name = "AGR_ID", insertable = false, updatable = false)
	private ActivoAgrupacion agrupacion;
	
    @ManyToOne
    @JoinColumn(name = "DD_PRV_ID")
	private DDProvincia provincia;

    @ManyToOne
    @JoinColumn(name = "DD_LOC_ID")
	private Localidad localidad;
	
    @Column(name = "PRY_DIRECCION")
	private String direccion;
	
    @Column(name = "PRY_ACREEDOR_PDV")
	private String acreedorPDV;
	
	@Column(name = "PRY_CP")
	private String codigoPostal;
	
	@ManyToOne
    @JoinColumn(name = "DD_TPA_ID")
	private DDTipoActivo tipoActivo;
	
	@ManyToOne
    @JoinColumn(name = "DD_SAC_ID")
	private DDSubtipoActivo subtipoActivo;
	
	@ManyToOne
    @JoinColumn(name = "DD_EAC_ID")
	private DDEstadoActivo estadoActivo;
	
	@ManyToOne
    @JoinColumn(name = "PRY_GESTOR_ACTIVO")
	private Usuario gestorActivo;
	
	@ManyToOne
    @JoinColumn(name = "PRY_DOBLE_GESTOR_ACTIVO")
	private Usuario dobleGestorActivo;
	
	@ManyToOne
    @JoinColumn(name = "PRY_GESTOR_COMERCIAL")
	private Usuario gestorcomercial;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CRA_ID")
    private DDCartera cartera;  
	
	public ActivoAgrupacion getAgrupacion() {
		return agrupacion;
	}

	public void setAgrupacion(ActivoAgrupacion agrupacion) {
		this.agrupacion = agrupacion;
	}

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

	public String getAcreedorPDV() {
		return acreedorPDV;
	}

	public void setAcreedorPDV(String acreedorPDV) {
		this.acreedorPDV = acreedorPDV;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public DDTipoActivo getTipoActivo() {
		return tipoActivo;
	}

	public void setTipoActivo(DDTipoActivo tipoActivo) {
		this.tipoActivo = tipoActivo;
	}

	public DDSubtipoActivo getSubtipoActivo() {
		return subtipoActivo;
	}

	public void setSubtipoActivo(DDSubtipoActivo subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}

	public DDEstadoActivo getEstadoActivo() {
		return estadoActivo;
	}

	public void setEstadoActivo(DDEstadoActivo estadoActivo) {
		this.estadoActivo = estadoActivo;
	}

	public Usuario getGestorActivo() {
		return gestorActivo;
	}

	public void setGestorActivo(Usuario gestorActivo) {
		this.gestorActivo = gestorActivo;
	}

	public Usuario getDobleGestorActivo() {
		return dobleGestorActivo;
	}

	public void setDobleGestorActivo(Usuario dobleGestorActivo) {
		this.dobleGestorActivo = dobleGestorActivo;
	}

	public Usuario getGestorcomercial() {
		return gestorcomercial;
	}

	public void setGestorcomercial(Usuario gestorcomercial) {
		this.gestorcomercial = gestorcomercial;
	}

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}
}