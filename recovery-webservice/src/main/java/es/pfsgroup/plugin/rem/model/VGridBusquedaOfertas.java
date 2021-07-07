package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_GRID_BUSQUEDA_OFERTAS", schema = "${entity.schema}")
public class VGridBusquedaOfertas implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "OFR_ID")
	private Long id;
	
	@Column(name = "NUM_OFERTA")  
	private Long numOferta;
	
	@Column(name = "NUM_ACTIVO_AGRUPACION")
	private Long numActivoAgrupacion;
	
	@Column(name = "FECHA_ALTA")
	private Date fechaCreacion;
	
	@Column(name = "TIPO_OFERTA_CODIGO")  
	private String codigoTipoOferta;
	
	@Column(name = "TIPO_OFERTA_DESCRIPCION")  
	private String descripcionTipoOferta;
	
	@Column(name = "OFERTANTE_NOMBRE")
	private String ofertante;
	
	@Column(name= "OFERTANTE_TELEFONO")
	private String telefonoOfertante;
	
	@Column(name="OFERTANTE_EMAIL")
	private String emailOfertante;
	
	@Column(name="OFERTANTE_DOC")
	private String documentoOfertante;
	
	@Column(name = "IMPORTE_OFERTA")
	private Double importeOferta;

	@Column(name = "ESTADO_OFERTA_DESCRIPCION")
	private String descripcionEstadoOferta;
	
	@Column(name = "ESTADO_OFERTA_CODIGO")
	private String codigoEstadoOferta;
	
	@Column(name = "ECO_ID")
	private Long idExpediente;
	
	@Column(name = "NUM_EXPEDIENTE")
	private Long numExpediente;
	
	@Column(name = "ESTADO_EXPEDIENTE_DESCRIPCION")
	private String descripcionEstadoExpediente;
	
	@Column(name = "ESTADO_EXPEDIENTE_CODIGO")
	private String codigoEstadoExpediente;
	
	@Column(name= "ACT_ID")
	private Long idActivo;	
	
	@Column(name= "AGR_ID")
	private Long idAgrupacion;

	@Column(name = "CANAL_PRESCRIPCION_DESCRIPCION")
	private String canalPrescripcionDescripcion;
	
	@Column(name = "CANAL_PRESCRIPCION_CODIGO")
	private String canalPrescripcionCodigo;
	
	@Column(name="FECHA_FIRMA_RESERVA")
	private Date fechaFirmaReserva;
	
	@Column(name="VIS_ID")
	private Long idVisita;
	
	@Column(name="NUM_VISITA")
	private Long numVisita;
	
	@Column(name="CANAL_NOMBRE")
	private String nombreCanal;
	
	@Column(name="CANAL_CODIGO")
	private String canalCodigo;
	
	@Column(name="CANAL_DESCRIPCION")
	private String canalDescripcion;

	@Column(name="CARTERA_CODIGO")
	private String carteraCodigo;
	
	@Column(name="SUBCARTERA_CODIGO")
	private String subcarteraCodigo;
	
	@Column(name="NUM_ACTIVO")
	private Long numActivo;
	
	@Column(name="NUM_AGRUPACION")
	private Long numAgrupacion;
	
	@Column(name="NUM_ACTIVO_UVEM")
	private Long numActivoUvem;
	
	@Column(name="NUM_ACTIVO_SAREB")
	private String numActivoSareb;
	
	@Column(name="NUM_ACTIVO_PRINEX")
	private Long numActivoPrinex;
	
	@Column(name="COD_PROMO_PRINEX")
	private String codigoPromocionPrinex;

	@Column(name="TIPO_COMERCIALIZACION_CODIGO")
	private String tipoComercializacionCodigo;
	
	@Column(name="OFERTA_EXPRESS")
	private Integer ofertaExpress;
	
	@Column(name="FECHA_OFERTA_PENDIENTE")
	private Date fechaOfertaPendiente;

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

	public String getOfertante() {
		return ofertante;
	}

	public void setOfertante(String ofertante) {
		this.ofertante = ofertante;
	}

	public String getTelefonoOfertante() {
		return telefonoOfertante;
	}

	public void setTelefonoOfertante(String telefonoOfertante) {
		this.telefonoOfertante = telefonoOfertante;
	}

	public String getEmailOfertante() {
		return emailOfertante;
	}

	public void setEmailOfertante(String emailOfertante) {
		this.emailOfertante = emailOfertante;
	}

	public String getDocumentoOfertante() {
		return documentoOfertante;
	}

	public void setDocumentoOfertante(String documentoOfertante) {
		this.documentoOfertante = documentoOfertante;
	}

	public Double getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}

	public String getDescripcionEstadoOferta() {
		return descripcionEstadoOferta;
	}

	public void setDescripcionEstadoOferta(String descripcionEstadoOferta) {
		this.descripcionEstadoOferta = descripcionEstadoOferta;
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

	public String getCanalPrescripcionDescripcion() {
		return canalPrescripcionDescripcion;
	}

	public void setCanalPrescripcionDescripcion(String canalPrescripcionDescripcion) {
		this.canalPrescripcionDescripcion = canalPrescripcionDescripcion;
	}

	public String getCanalPrescripcionCodigo() {
		return canalPrescripcionCodigo;
	}

	public void setCanalPrescripcionCodigo(String canalPrescripcionCodigo) {
		this.canalPrescripcionCodigo = canalPrescripcionCodigo;
	}

	public Date getFechaFirmaReserva() {
		return fechaFirmaReserva;
	}

	public void setFechaFirmaReserva(Date fechaFirmaReserva) {
		this.fechaFirmaReserva = fechaFirmaReserva;
	}

	public Long getIdVisita() {
		return idVisita;
	}

	public void setIdVisita(Long idVisita) {
		this.idVisita = idVisita;
	}

	public Long getNumVisita() {
		return numVisita;
	}

	public void setNumVisita(Long numVisita) {
		this.numVisita = numVisita;
	}

	public String getNombreCanal() {
		return nombreCanal;
	}

	public void setNombreCanal(String nombreCanal) {
		this.nombreCanal = nombreCanal;
	}

	public String getCanalCodigo() {
		return canalCodigo;
	}

	public void setCanalCodigo(String canalCodigo) {
		this.canalCodigo = canalCodigo;
	}

	public String getCanalDescripcion() {
		return canalDescripcion;
	}

	public void setCanalDescripcion(String canalDescripcion) {
		this.canalDescripcion = canalDescripcion;
	}

	public String getCarteraCodigo() {
		return carteraCodigo;
	}

	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}

	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}

	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}

	public Long getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}

	public Long getNumAgrupacion() {
		return numAgrupacion;
	}

	public void setNumAgrupacion(Long numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}

	public Long getNumActivoUvem() {
		return numActivoUvem;
	}

	public void setNumActivoUvem(Long numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}

	public String getNumActivoSareb() {
		return numActivoSareb;
	}

	public void setNumActivoSareb(String numActivoSareb) {
		this.numActivoSareb = numActivoSareb;
	}

	public Long getNumActivoPrinex() {
		return numActivoPrinex;
	}

	public void setNumActivoPrinex(Long numActivoPrinex) {
		this.numActivoPrinex = numActivoPrinex;
	}

	public String getCodigoPromocionPrinex() {
		return codigoPromocionPrinex;
	}

	public void setCodigoPromocionPrinex(String codigoPromocionPrinex) {
		this.codigoPromocionPrinex = codigoPromocionPrinex;
	}

	public String getTipoComercializacionCodigo() {
		return tipoComercializacionCodigo;
	}

	public void setTipoComercializacionCodigo(String tipoComercializacionCodigo) {
		this.tipoComercializacionCodigo = tipoComercializacionCodigo;
	}

	public Integer getOfertaExpress() {
		return ofertaExpress;
	}

	public void setOfertaExpress(Integer ofertaExpress) {
		this.ofertaExpress = ofertaExpress;
	}

	public Date getFechaOfertaPendiente() {
		return fechaOfertaPendiente;
	}

	public void setFechaOfertaPendiente(Date fechaOfertaPendiente) {
		this.fechaOfertaPendiente = fechaOfertaPendiente;
	}
	

}