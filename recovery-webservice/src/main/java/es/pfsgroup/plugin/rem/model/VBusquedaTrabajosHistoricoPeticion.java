package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;



@Entity
@Table(name = "V_BUSQUEDA_TRABAJOS_HISTORICO_PETICION", schema = "${entity.schema}")
public class VBusquedaTrabajosHistoricoPeticion implements Serializable {

	/**
	 * 
	 */
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ID")
	private Long idVista;
	
	@Column(name = "TBJ_ID")
	private Long id;
	
	@Column(name = "TBJ_NUM_TRABAJO")
	private String numTrabajo;
	
	@Column(name= "TBJ_FECHA_SOLICITUD")
	private Date fechaSolicitud;
	
	@Column(name = "DD_TTR_CODIGO")
	private String codigoTipo;
	
	@Column(name = "DD_TTR_DESCRIPCION")
	private String descripcionTipo;
	
	@Column(name = "DD_STR_DESCRIPCION")
	private String descripcionSubtipo;
	
	@Column(name = "DD_EST_DESCRIPCION")
	private String descripcionEstado;
	
	@Column(name = "SOLICITANTE")
	private String solicitante;
	
	@Column(name = "PVE_NOMBRE")
	private String proveedor;
	
	@Column(name="ACT_NUM_ACTIVO")
    private Long numActivo;
	
	@Column(name="DD_CRA_DESCRIPCION")
	private String cartera;
	
	@Column(name="DD_SCR_DESCRIPCION")
	private String subcartera; 
	
	@Column(name="PVE_ID")
	private Long idProveedor;

	public Long getIdVista() {
		return idVista;
	}

	public void setIdVista(Long idVista) {
		this.idVista = idVista;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(String numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public String getCodigoTipo() {
		return codigoTipo;
	}

	public void setCodigoTipo(String codigoTipo) {
		this.codigoTipo = codigoTipo;
	}

	public String getDescripcionTipo() {
		return descripcionTipo;
	}

	public void setDescripcionTipo(String descripcionTipo) {
		this.descripcionTipo = descripcionTipo;
	}

	public String getDescripcionSubtipo() {
		return descripcionSubtipo;
	}

	public void setDescripcionSubtipo(String descripcionSubtipo) {
		this.descripcionSubtipo = descripcionSubtipo;
	}

	public String getDescripcionEstado() {
		return descripcionEstado;
	}

	public void setDescripcionEstado(String descripcionEstado) {
		this.descripcionEstado = descripcionEstado;
	}

	public String getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(String solicitante) {
		this.solicitante = solicitante;
	}

	public String getProveedor() {
		return proveedor;
	}

	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public String getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(String subcartera) {
		this.subcartera = subcartera;
	}

	public Long getIdProveedor() {
		return idProveedor;
	}

	public void setIdProveedor(Long idProveedor) {
		this.idProveedor = idProveedor;
	}

	
}