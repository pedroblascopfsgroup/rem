package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "VI_GRID_OFR_HIST_CONCURRENCIA", schema = "${entity.schema}")
public class VGridHistoricoOfertasConcurrencia implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name= "CON_ID")
	private Long id;
	
	@Column(name = "OFR_ID")
	private Long idOferta;
	
	@Column(name = "OFR_NUM_OFERTA")  
	private Long numOferta;
	
	@Column(name = "NUM_ACTIVO_AGRUPACION")
	private Long numActivoAgrupacion;
	
	@Column(name= "ACT_ID")
	private Long idActivo;	
	
	@Column(name = "ACT_NUM_ACTIVO")  
	private Long numActivo;
	
	@Column(name= "AGR_ID")
	private Long idAgrupacion;
	
	@Column(name = "AGR_NUM_AGRUP_REM")  
	private Long numAgrupacion;
	
	@Column(name = "CON_FECHA_INI")
	private Date fechaInicio;
	
	@Column(name = "CON_FECHA_FIN")
	private Date fechaFin;
	
	@Column(name = "CON_IMPORTE_MIN_OFR")
	private Double importeMinOferta;
	
	@Column(name = "CON_IMPORTE_DEPOSITO")
	private Double importeDeposito;
	
	@Column(name = "OFR_CONCURRENCIA")
	private Boolean concurrencia;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdOferta() {
		return idOferta;
	}

	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}

	public Long getNumOferta() {
		return numOferta;
	}

	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}

	public Long getNumActivoAgrupacion() {
		return numActivoAgrupacion;
	}

	public void setNumActivoAgrupacion(Long numActivoAgrupacion) {
		this.numActivoAgrupacion = numActivoAgrupacion;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Long getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public Long getNumAgrupacion() {
		return numAgrupacion;
	}

	public void setNumAgrupacion(Long numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
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

	public Double getImporteMinOferta() {
		return importeMinOferta;
	}

	public void setImporteMinOferta(Double importeMinOferta) {
		this.importeMinOferta = importeMinOferta;
	}

	public Double getImporteDeposito() {
		return importeDeposito;
	}

	public void setImporteDeposito(Double importeDeposito) {
		this.importeDeposito = importeDeposito;
	}

	public Boolean getConcurrencia() {
		return concurrencia;
	}

	public void setConcurrencia(Boolean concurrencia) {
		this.concurrencia = concurrencia;
	}
	
}