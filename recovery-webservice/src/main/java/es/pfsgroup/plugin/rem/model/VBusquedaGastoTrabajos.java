package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "VI_BUSQUEDA_GASTO_TRABAJOS", schema = "${entity.schema}")
public class VBusquedaGastoTrabajos implements Serializable {

	private static final long serialVersionUID = 1L;


	@Id
	@Column(name = "GPV_TBJ_ID")
	private Long id;
	
	@Column(name="TBJ_ID")
	private Long idTrabajo;
		
	@Column(name = "GPV_ID")
	private Long idGasto;
		
    @Column(name = "TBJ_NUM_TRABAJO")
    private String numTrabajo;

    @Column(name = "DD_TTR_CODIGO")
	private String codigoTipo;
    
    @Column(name = "DD_STR_CODIGO")
	private String codigoSubtipo;
    
    @Column(name = "DD_TTR_DESCRIPCION")
	private String descripcionTipo;
    
    @Column(name = "DD_STR_DESCRIPCION")
	private String descripcionSubtipo;

	@Column(name= "TBJ_FECHA_SOLICITUD")
	private Date fechaSolicitud;
	
	@Column(name="TBJ_CUBRE_SEGURO")
	private Integer cubreSeguro;
	
	@Column(name="TBJ_IMPORTE_TOTAL")
	private Double importeTotal;
	
	@Column(name="TBJ_FECHA_EJECUTADO")
	private Date fechaEjecutado;
	
	@Column(name="TBJ_FECHA_CIERRE_ECONOMICO")
	private Date fechaCierreEconomico;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}

	public Long getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}

	public String getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(String numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public String getCodigoTipo() {
		return codigoTipo;
	}

	public void setCodigoTipo(String codigoTipo) {
		this.codigoTipo = codigoTipo;
	}

	public String getCodigoSubtipo() {
		return codigoSubtipo;
	}

	public void setCodigoSubtipo(String codigoSubtipo) {
		this.codigoSubtipo = codigoSubtipo;
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

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Integer getCubreSeguro() {
		return cubreSeguro;
	}

	public void setCubreSeguro(Integer cubreSeguro) {
		this.cubreSeguro = cubreSeguro;
	}

	public Double getImporteTotal() {
		return importeTotal;
	}

	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}

	public Date getFechaEjecutado() {
		return fechaEjecutado;
	}

	public void setFechaEjecutado(Date fechaEjecutado) {
		this.fechaEjecutado = fechaEjecutado;
	}

	public Date getFechaCierreEconomico() {
		return fechaCierreEconomico;
	}

	public void setFechaCierreEconomico(Date fechaCierreEconomico) {
		this.fechaCierreEconomico = fechaCierreEconomico;
	}

}