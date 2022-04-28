package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "VI_GRID_OFR_ACT_AGR_INC_ANULADAS", schema = "${entity.schema}")
public class VGridOfertasActivosAgrupacionIncAnuladas implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name= "ID")
	private Long id;
	
	@Column(name = "OFR_ID")
	private Long idOferta;
	
	@Column(name = "OFR_NUM_OFERTA")  
	private Long numOferta;
	
	@Column(name = "NUM_ACTIVO_AGRUPACION")
	private Long numActivoAgrupacion;
	
	@Column(name = "OFR_FECHA_ALTA")
	private Date fechaCreacion;
	
	@Column(name = "DD_TOF_DESCRIPCION")  
	private String descripcionTipoOferta;
	
	@Column(name = "OFERTANTE")
	private String ofertante;
	
	@Column(name = "OFR_IMPORTE")
	private String importeOferta;
	
	@Column(name = "OFR_IMPORTE_CONTRAOFERTA")
	private String importeContraoferta;

	@Column(name = "DD_EOF_DESCRIPCION")
	private String estadoOferta;
	
	@Column(name = "DD_EOF_CODIGO")
	private String codigoEstadoOferta;
	
	@Column(name = "ECO_ID")
	private Long idExpediente;
	
	@Column(name = "ECO_NUM_EXPEDIENTE")
	private Long numExpediente;
	
	@Column(name = "DD_EEC_DESCRIPCION")
	private String descripcionEstadoExpediente;
	
	@Column(name = "DD_EEC_CODIGO")
	private String codigoEstadoExpediente;
	
	@Column(name = "DD_TOF_CODIGO")  
	private String codigoTipoOferta;
	
	@Column(name= "ACT_ID")
	private Long idActivo;	
	
	@Column(name= "AGR_ID")
	private Long idAgrupacion;
	
	@Column(name="OFERTA_EXPRESS")
	private Boolean ofertaExpress;
	
	@Column(name="CANAL")
	private String canal;
	
	@Column(name="CANAL_DESCRIPCION")
	private String canalDescripcion;
	
    @Column(name="GENCAT")
	private Boolean gencat;
    
    @Column(name="EST_CODIGO_C4C")
    private String codigoEstadoC4C;
    
    @Column(name="ESTADODEPOSITOCODIGO")
    private String codigoEstadoDeposito;
    
    @Column(name="ESTADODEPOSITO")
    private String estadoDeposito;

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

	public Date getFechaCreacion() {
		return fechaCreacion;
	}

	public void setFechaCreacion(Date fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}

	public String getDescripcionTipoOferta() {
		return descripcionTipoOferta;
	}

	public void setDescripcionTipoOferta(String descripcionTipoOferta) {
		this.descripcionTipoOferta = descripcionTipoOferta;
	}

	public String getOfertante() {
		return ofertante;
	}

	public void setOfertante(String ofertante) {
		this.ofertante = ofertante;
	}

	public String getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(String importeOferta) {
		this.importeOferta = importeOferta;
	}

	public String getImporteContraoferta() {
		return importeContraoferta;
	}

	public void setImporteContraoferta(String importeContraoferta) {
		this.importeContraoferta = importeContraoferta;
	}

	public String getEstadoOferta() {
		return estadoOferta;
	}

	public void setEstadoOferta(String estadoOferta) {
		this.estadoOferta = estadoOferta;
	}

	public String getCodigoEstadoOferta() {
		return codigoEstadoOferta;
	}

	public void setCodigoEstadoOferta(String codigoEstadoOferta) {
		this.codigoEstadoOferta = codigoEstadoOferta;
	}

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public Long getNumExpediente() {
		return numExpediente;
	}

	public void setNumExpediente(Long numExpediente) {
		this.numExpediente = numExpediente;
	}

	public String getDescripcionEstadoExpediente() {
		return descripcionEstadoExpediente;
	}

	public void setDescripcionEstadoExpediente(String descripcionEstadoExpediente) {
		this.descripcionEstadoExpediente = descripcionEstadoExpediente;
	}

	public String getCodigoEstadoExpediente() {
		return codigoEstadoExpediente;
	}

	public void setCodigoEstadoExpediente(String codigoEstadoExpediente) {
		this.codigoEstadoExpediente = codigoEstadoExpediente;
	}

	public String getCodigoTipoOferta() {
		return codigoTipoOferta;
	}

	public void setCodigoTipoOferta(String codigoTipoOferta) {
		this.codigoTipoOferta = codigoTipoOferta;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public Boolean getOfertaExpress() {
		return ofertaExpress;
	}

	public void setOfertaExpress(Boolean ofertaExpress) {
		this.ofertaExpress = ofertaExpress;
	}

	public String getCanal() {
		return canal;
	}

	public void setCanal(String canal) {
		this.canal = canal;
	}

	public String getCanalDescripcion() {
		return canalDescripcion;
	}

	public void setCanalDescripcion(String canalDescripcion) {
		this.canalDescripcion = canalDescripcion;
	}

	public Boolean getGencat() {
		return gencat;
	}

	public void setGencat(Boolean gencat) {
		this.gencat = gencat;
	}

	public String getCodigoEstadoC4C() {
		return codigoEstadoC4C;
	}

	public void setCodigoEstadoC4C(String codigoEstadoC4C) {
		this.codigoEstadoC4C = codigoEstadoC4C;
	}

	public String getCodigoEstadoDeposito() {
		return codigoEstadoDeposito;
	}

	public void setCodigoEstadoDeposito(String codigoEstadoDeposito) {
		this.codigoEstadoDeposito = codigoEstadoDeposito;
	}

	public String getEstadoDeposito() {
		return estadoDeposito;
	}

	public void setEstadoDeposito(String estadoDeposito) {
		this.estadoDeposito = estadoDeposito;
	}	
	

}