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

	@Column(name = "COD_PROVINCIA")
   	private String codProvincia;

	@Column(name = "DES_PROVINCIA")
   	private String desProvincia;
	
	@Column(name = "COD_LOCALIDAD")
   	private String codLocalidad;

	@Column(name = "DES_LOCALIDAD")
   	private String desLocalidad;
	
	@Column(name = "FECHA_ALTA")
	private Date fechaAlta;  
	
    @Column(name = "ES_CUSTODIO")
    private Integer esCustodio;
    
    @Column(name = "COD_ESTADO_PROVEEDOR")
   	private String codEstadoProveedor;

    @Column(name = "DES_ESTADO_PROVEEDOR")
   	private String desEstadoProveedor;
    
    @Column(name = "COD_CARTERA")
   	private String codCartera;

    @Column(name = "DES_CARTERA")
   	private String desCartera;
    
    @Column(name = "COD_CALIFICACION_VIGENTE")
	private String codCalificacion;

    @Column(name = "DES_CALIFICACION_VIGENTE")
	private String desCalificacion;
    
	@Column(name = "ES_TOP_150_VIGENTE")
	private Integer esTop;
	
    @Column(name = "COD_CALIFICACION_PROPUESTA")
	private String codCalificacionPropuesta;

    @Column(name = "DES_CALIFICACION_PROPUESTA")
	private String desCalificacionPropuesta;
    
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

	public String getCodProvincia() {
		return codProvincia;
	}

	public void setCodProvincia(String codProvincia) {
		this.codProvincia = codProvincia;
	}

	public String getDesProvincia() {
		return desProvincia;
	}

	public void setDesProvincia(String desProvincia) {
		this.desProvincia = desProvincia;
	}

	public String getCodLocalidad() {
		return codLocalidad;
	}

	public void setCodLocalidad(String codLocalidad) {
		this.codLocalidad = codLocalidad;
	}

	public String getDesLocalidad() {
		return desLocalidad;
	}

	public void setDesLocalidad(String desLocalidad) {
		this.desLocalidad = desLocalidad;
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

	public String getCodEstadoProveedor() {
		return codEstadoProveedor;
	}

	public void setCodEstadoProveedor(String codEstadoProveedor) {
		this.codEstadoProveedor = codEstadoProveedor;
	}

	public String getDesEstadoProveedor() {
		return desEstadoProveedor;
	}

	public void setDesEstadoProveedor(String desEstadoProveedor) {
		this.desEstadoProveedor = desEstadoProveedor;
	}

	public String getCodCartera() {
		return codCartera;
	}

	public void setCodCartera(String codCartera) {
		this.codCartera = codCartera;
	}

	public String getDesCartera() {
		return desCartera;
	}

	public void setDesCartera(String desCartera) {
		this.desCartera = desCartera;
	}

	public String getCodCalificacion() {
		return codCalificacion;
	}

	public void setCodCalificacion(String codCalificacion) {
		this.codCalificacion = codCalificacion;
	}

	public String getDesCalificacion() {
		return desCalificacion;
	}

	public void setDesCalificacion(String desCalificacion) {
		this.desCalificacion = desCalificacion;
	}

	public Integer getEsTop() {
		return esTop;
	}

	public void setEsTop(Integer esTop) {
		this.esTop = esTop;
	}

	public String getCodCalificacionPropuesta() {
		return codCalificacionPropuesta;
	}

	public void setCodCalificacionPropuesta(String codCalificacionPropuesta) {
		this.codCalificacionPropuesta = codCalificacionPropuesta;
	}

	public String getDesCalificacionPropuesta() {
		return desCalificacionPropuesta;
	}

	public void setDesCalificacionPropuesta(String desCalificacionPropuesta) {
		this.desCalificacionPropuesta = desCalificacionPropuesta;
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