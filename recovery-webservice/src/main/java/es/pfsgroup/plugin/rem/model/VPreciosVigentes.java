package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_PRECIOS_VIGENTES", schema = "${entity.schema}")
public class VPreciosVigentes implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	@Id
	@Column(name = "ID")  
	private String id;	
	
	@Column(name = "VAL_ID")  
	private String idPrecioVigente;
	
	@Column(name = "ACT_ID")  
	private String idActivo;
	
	@Column(name = "DD_TPC_DESCRIPCION")
	private String descripcionTipoPrecio;
	
	@Column(name = "DD_TPC_CODIGO")
	private String codigoTipoPrecio;
	
	@Column(name="DD_TPC_ORDEN")
	private Integer orden;

	@Column(name = "VAL_IMPORTE")
	private Double importe;
	
	@Column(name = "VAL_FECHA_APROBACION")
	private Date fechaAprobacion;
	
	@Column(name = "VAL_FECHA_CARGA")
	private Date fechaCarga;
	
	@Column(name = "VAL_FECHA_INICIO")
	private Date fechaInicio;
	
	@Column(name = "VAL_FECHA_FIN")
	private Date fechaFin;
	
	@Column(name = "GESTOR_PRECIOS")
	private String gestor;
	
	@Column(name = "VAL_OBSERVACIONES")
	private String observaciones;
	
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIdPrecioVigente() {
		return idPrecioVigente;
	}

	public void setIdPrecioVigente(String idPrecioVigente) {
		this.idPrecioVigente = idPrecioVigente;
	}

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}
	
	public String getDescripcionTipoPrecio() {
		return descripcionTipoPrecio;
	}

	public void setDescripcionTipoPrecio(String descripcionTipoPrecio) {
		this.descripcionTipoPrecio = descripcionTipoPrecio;
	}

	public String getCodigoTipoPrecio() {
		return codigoTipoPrecio;
	}

	public void setCodigoTipoPrecio(String codigoTipoPrecio) {
		this.codigoTipoPrecio = codigoTipoPrecio;
	}

	public Integer getOrden() {
		return orden;
	}

	public void setOrden(Integer orden) {
		this.orden = orden;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public Date getFechaAprobacion() {
		return fechaAprobacion;
	}

	public void setFechaAprobacion(Date fechaAprobacion) {
		this.fechaAprobacion = fechaAprobacion;
	}

	public Date getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(Date fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public String getGestor() {
		return gestor;
	}

	public void setGestor(String gestor) {
		this.gestor = gestor;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	

}