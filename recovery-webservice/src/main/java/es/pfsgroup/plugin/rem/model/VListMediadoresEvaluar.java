package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.rem.model.dd.DDCalificacionProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProveedor;


@Entity
@Table(name = "V_LIST_MEDIADORES_EVALUAR", schema = "${entity.schema}")
public class VListMediadoresEvaluar implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 101L;
	
	@Id
	@Column(name = "ID_MEDIADOR")
	private Long id;
	
	@Column(name = "CODIGO_REM")
	private String codigoRem;	
	
	@Column(name = "NOMBRE_MEDIADOR")
	private String nombreApellidos; 

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PROVINCIA_MEDIADOR")
   	private DDProvincia provincia;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "LOCALIDAD_MEDIADOR")
   	private Localidad localidad;
    
	@Column(name = "FECHA_ALTA")
	private Date fechaAlta;  
	
    @Column(name = "ES_CUSTODIO")
    private Integer esCustodio;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "EPR_ESTADO_PROVEEDOR")
   	private DDEstadoProveedor estadoProveedor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CRA_CARTERA")
   	private DDCartera cartera;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="CPR_CALIFICACION_VIGENTE")
	private DDCalificacionProveedor calificacion;
	
	@Column(name = "ES_TOP_150_VIGENTE")
	private Integer esTop;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CPR_CALIFICACION_PROPUESTA")
	private DDCalificacionProveedor calificacionPropuesta;
	
	@Column(name = "ES_TOP_150_PROPUESTO")
	private Integer esTopPropuesto;

	@Column(name = "ES_HOMOLOGADO")
	private Integer esHomologado;

	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigoRem() {
		return codigoRem;
	}

	public void setCodigoRem(String codigoRem) {
		this.codigoRem = codigoRem;
	}

	public String getNombreApellidos() {
		return nombreApellidos;
	}

	public void setNombreApellidos(String nombreApellidos) {
		this.nombreApellidos = nombreApellidos;
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

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Integer getEsCustodio() {
		return esCustodio;
	}

	public void setEsCustodio(Integer esCustodio) {
		this.esCustodio = esCustodio;
	}

	public DDEstadoProveedor getEstadoProveedor() {
		return estadoProveedor;
	}

	public void setEstadoProveedor(DDEstadoProveedor estadoProveedor) {
		this.estadoProveedor = estadoProveedor;
	}

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDCalificacionProveedor getCalificacion() {
		return calificacion;
	}

	public void setCalificacion(DDCalificacionProveedor calificacion) {
		this.calificacion = calificacion;
	}

	public Integer getEsTop() {
		return esTop;
	}

	public void setEsTop(Integer esTop) {
		this.esTop = esTop;
	}

	public DDCalificacionProveedor getCalificacionPropuesta() {
		return calificacionPropuesta;
	}

	public void setCalificacionPropuesta(DDCalificacionProveedor calificacionPropuesta) {
		this.calificacionPropuesta = calificacionPropuesta;
	}

	public Integer getEsTopPropuesto() {
		return esTopPropuesto;
	}

	public void setEsTopPropuesto(Integer esTopPropuesto) {
		this.esTopPropuesto = esTopPropuesto;
	}

	public Integer getEsHomologado() {
		return esHomologado;
	}

	public void setEsHomologado(Integer esHomologado) {
		this.esHomologado = esHomologado;
	}
	
}