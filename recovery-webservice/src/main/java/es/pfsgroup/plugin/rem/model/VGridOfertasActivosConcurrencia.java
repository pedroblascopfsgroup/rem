package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "VI_GRID_OFR_CONCURRENCIA", schema = "${entity.schema}")
public class VGridOfertasActivosConcurrencia implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name= "ID")
	private Long id;
	
	@Column(name = "NUM_ACTIVO_AGRUPACION")  
	private Long numActivoAgrupacion;
	
	@Column(name = "IMPORTEOFERTA")  
	private Long importeOferta;
	
	@Column(name = "NUMOFERTA")  
	private Long numOferta;

	@Column(name = "OFERTANTE")
	private String ofertante;
	
	@Column(name = "TIPOOFERTACODIGO")  
	private String codigoTipoOferta;
	
	@Column(name = "TIPOOFERTA")  
	private String descripcionTipoOferta;
	
	@Column(name = "ESTADOOFERTACODIGO")  
	private String codigoEstadoOferta;
	
	@Column(name = "ESTADOOFERTA")  
	private String descripcionEstadoOferta;
	
	@Column(name = "ESTADODEPOSITOCODIGO")  
	private String codigoEstadoDeposito;
	
	@Column(name = "ESTADODEPOSITO")  
	private String descripcionEstadoDeposito;
	
	@Column(name = "FECHAALTA")
	private Date fechaCreacion;
	
	@Column(name = "DIASCONCURRENCIA")  
	private Long diasConcurrencia;
	
	@Column(name = "ACT_ID")  
	private Long idActivo;
	
	@Column(name = "ACT_NUM_ACTIVO")  
	private Long numActivo;
	
	@Column(name = "CON_ID")  
	private Long idConcurrencia;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getNumOferta() {
		return numOferta;
	}

	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}

	public String getOfertante() {
		return ofertante;
	}

	public void setOfertante(String ofertante) {
		this.ofertante = ofertante;
	}

	public String getCodigoTipoOferta() {
		return codigoTipoOferta;
	}

	public void setCodigoTipoOferta(String codigoTipoOferta) {
		this.codigoTipoOferta = codigoTipoOferta;
	}

	public String getDescripcionTipoOferta() {
		return descripcionTipoOferta;
	}

	public void setDescripcionTipoOferta(String descripcionTipoOferta) {
		this.descripcionTipoOferta = descripcionTipoOferta;
	}

	public String getCodigoEstadoOferta() {
		return codigoEstadoOferta;
	}

	public void setCodigoEstadoOferta(String codigoEstadoOferta) {
		this.codigoEstadoOferta = codigoEstadoOferta;
	}

	public String getDescripcionEstadoOferta() {
		return descripcionEstadoOferta;
	}

	public void setDescripcionEstadoOferta(String descripcionEstadoOferta) {
		this.descripcionEstadoOferta = descripcionEstadoOferta;
	}

	public String getCodigoEstadoDeposito() {
		return codigoEstadoDeposito;
	}

	public void setCodigoEstadoDeposito(String codigoEstadoDeposito) {
		this.codigoEstadoDeposito = codigoEstadoDeposito;
	}

	public String getDescripcionEstadoDeposito() {
		return descripcionEstadoDeposito;
	}

	public void setDescripcionEstadoDeposito(String descripcionEstadoDeposito) {
		this.descripcionEstadoDeposito = descripcionEstadoDeposito;
	}

	public Date getFechaCreacion() {
		return fechaCreacion;
	}

	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}

	public Long getDiasConcurrencia() {
		return diasConcurrencia;
	}

	public void setDiasConcurrencia(Long diasConcurrencia) {
		this.diasConcurrencia = diasConcurrencia;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Long getIdConcurrencia() {
		return idConcurrencia;
	}

	public void setIdConcurrencia(Long idConcurrencia) {
		this.idConcurrencia = idConcurrencia;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(Long importeOferta) {
		this.importeOferta = importeOferta;
	}

	public Long getNumActivoAgrupacion() {
		return numActivoAgrupacion;
	}

	public void setNumActivoAgrupacion(Long numActivoAgrupacion) {
		this.numActivoAgrupacion = numActivoAgrupacion;
	}
	
}