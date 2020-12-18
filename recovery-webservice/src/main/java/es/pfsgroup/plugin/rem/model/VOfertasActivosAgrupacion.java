package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "VI_OFERTAS_ACTIVOS_AGRUPACION", schema = "${entity.schema}")
public class VOfertasActivosAgrupacion implements Serializable {

	/**
	 * 
	 */
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
	
	@Column(name = "PRECIO_PUBLICADO")
	private String precioPublicado;
	
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
	
	@Column(name = "DD_TRO_CODIGO")  
	private String tipoRechazoCodigo;
	
	@Column(name = "DD_MRO_CODIGO")  
	private String motivoRechazoCodigo;
	
//	@Column(name = "ACTIVOS")  
//	private String activos;
	
	@Column(name= "ACT_ID")
	private Long idActivo;	
	
	@Column(name= "AGR_ID")
	private Long idAgrupacion;
	
	@Column(name= "GESTOR_LOTE")
	private Long gestorLote;

	@Column(name = "DD_CAP_DESCRIPCION")
	private String canalPrescripcionDescripcion;
	
	@Column(name = "DD_CAP_CODIGO")
	private String canalPrescripcionCodigo;
	
	@Column(name = "FECHAMODIFICAR")
	private Date fechaModificar;
	
	@Column(name= "TELEFONO_OFERTANTE")
	private String telefonoOfertante;
	
	@Column(name="EMAIL_OFERTANTE")
	private String emailOfertante;
	
	@Column(name="DOCUMENTO_OFERTANTE")
	private String documentoOfertante;
	
	@Column(name="RES_FECHA_FIRMA")
	private Date fechaFirmaReserva;
	
	@Column(name="VIS_ID")
	private Long idVisita;
	
	@Column(name="VIS_NUM_VISITA")
	private Long numVisita;
	
	@Column(name="NOMBRE_CANAL")
	private String nombreCanal;
	
	@Column(name="CANAL")
	private String canal;
	
	@Column(name="CANAL_DESCRIPCION")
	private String canalDescripcion;

	@Column(name="CARTERA_CODIGO")
	private String carteraCodigo;
	
	@Column(name="SUBCARTERA_CODIGO")
	private String subcarteraCodigo;
	
	@Column(name="NUM_ACTIVO_UVEM")
	private Long numActivoUvem;
	
	@Column(name="NUM_ACTIVO_SAREB")
	private String numActivoSareb;
	
	@Column(name="NUM_ACTIVO_PRINEX")
	private Long numActivoPrinex;

	@Column(name="TIPO_COMERCIALIZACION")
	private Long tipoComercializacion;
	
	@Column(name="CLASE_ACTIVO")
	private Long claseActivoBancario;
	
	@Column(name="OFERTA_EXPRESS")
	private Boolean ofertaExpress;	
    
    @Column(name="NECESITA_FINANCIACION")
	private Boolean necesitaFinanciacion;	
    
    @Column(name="OBSERVACIONES")
	private String observaciones;	
	
    @Column(name="GENCAT")
	private Boolean gencat;
    
    @Column(name = "FECHA_ENT_CRM_SF")
    private Date fechaEntradaCRMSF;

	public Date getFechaModificar() {
		return fechaModificar;
	}

	public void setFechaModificar(Date fechaModificar) {
		this.fechaModificar = fechaModificar;
	}

	public Long getIdOferta() {
		return idOferta;
	}

	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
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

	public String getPrecioPublicado() {
		return precioPublicado;
	}

	public void setPrecioPublicado(String precioPublicado) {
		this.precioPublicado = precioPublicado;
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

	public Long getNumOferta() {
		return numOferta;
	}

	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}

	public Long getIdExpediente() {
		return idExpediente;
	}

	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}

	public String getDescripcionCodigoOferta() {
		return codigoTipoOferta;
	}

	public void setDescripcionCodigoOferta(String codigoTipoOferta) {
		this.codigoTipoOferta = codigoTipoOferta;
	}

	public Long getNumActivoAgrupacion() {
		return numActivoAgrupacion;
	}

	public void setNumActivoAgrupacion(Long numActivoAgrupacion) {
		this.numActivoAgrupacion = numActivoAgrupacion;
	}

	public String getCodigoTipoOferta() {
		return codigoTipoOferta;
	}

	public void setCodigoTipoOferta(String codigoTipoOferta) {
		this.codigoTipoOferta = codigoTipoOferta;
	}

//	public String getActivos() {
//		return activos;
//	}

//	public void setActivos(String activos) {
//		this.activos = activos;
//	}


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

	public String getCodigoEstadoExpediente() {
		return codigoEstadoExpediente;
	}

	public void setCodigoEstadoExpediente(String codigoEstadoExpediente) {
		this.codigoEstadoExpediente = codigoEstadoExpediente;
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

	public String getTipoRechazoCodigo() {
		return tipoRechazoCodigo;
	}

	public void setTipoRechazoCodigo(String tipoRechazoCodigo) {
		this.tipoRechazoCodigo = tipoRechazoCodigo;
	}

	public String getMotivoRechazoCodigo() {
		return motivoRechazoCodigo;
	}

	public void setMotivoRechazoCodigo(String motivoRechazoCodigo) {
		this.motivoRechazoCodigo = motivoRechazoCodigo;
	}

	public Long getNumActivoUvem() {
		return numActivoUvem;
	}

	public void setNumActivoUvem(Long numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}

	public Long getNumActivoPrinex() {
		return numActivoPrinex;
	}

	public void setNumActivoPrinex(Long numActivoPrinex) {
		this.numActivoPrinex = numActivoPrinex;
	}
	
	public Boolean getOfertaExpress() {
		return ofertaExpress;
	}

	public void setOfertaExpress(Boolean ofertaExpress) {
		this.ofertaExpress = ofertaExpress;
	}

	public Boolean getNecesitaFinanciacion() {
		return necesitaFinanciacion;
	}

	public void setNecesitaFinanciacion(Boolean necesitaFinanciacion) {
		this.necesitaFinanciacion = necesitaFinanciacion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Boolean getGencat() {
		return gencat;
	}

	public void setGencat(Boolean gencat) {
		this.gencat = gencat;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
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

	public Long getGestorLote() {
		return gestorLote;
	}

	public void setGestorLote(Long gestorLote) {
		this.gestorLote = gestorLote;
	}

	public String getNumActivoSareb() {
		return numActivoSareb;
	}

	public void setNumActivoSareb(String numActivoSareb) {
		this.numActivoSareb = numActivoSareb;
	}

	public Long getTipoComercializacion() {
		return tipoComercializacion;
	}

	public void setTipoComercializacion(Long tipoComercializacion) {
		this.tipoComercializacion = tipoComercializacion;
	}

	public Long getClaseActivoBancario() {
		return claseActivoBancario;
	}

	public void setClaseActivoBancario(Long claseActivoBancario) {
		this.claseActivoBancario = claseActivoBancario;
	}

	public Date getFechaEntradaCRMSF() {
		return fechaEntradaCRMSF;
	}

	public void setFechaEntradaCRMSF(Date fechaEntradaCRMSF) {
		this.fechaEntradaCRMSF = fechaEntradaCRMSF;
	}

}