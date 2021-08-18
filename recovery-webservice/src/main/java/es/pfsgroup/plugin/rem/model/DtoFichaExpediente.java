package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto que gestiona la informacion de un expediente.
 * 
 * @author Jose Villel
 *
 */
public class DtoFichaExpediente extends WebDto {

	private static final long serialVersionUID = 3574353502838449106L;

	private Long id;

	private Long idOferta;

	private Long idAgrupacion;

	private Long numAgrupacion;

	private Long idActivo;

	private Long numActivo;

	private Long numExpediente;

	private Long numEntidad;

	private String tipoExpedienteCodigo;

	private String tipoExpedienteDescripcion;

	private String mediador;

	private String propietario;

	private String comprador;

	private String estado;

	private Double importe;

	private String entidadPropietariaDescripcion;

	private String entidadPropietariaCodigo;

	private Date fechaAlta;

	private Date fechaSancion;

	private String origen;

	private Date fechaReserva;

	private Date fechaFin;

	private Date fechaAltaOferta;
	
	private Date fechaContabilizacionReserva;

	private Date fechaPosicionamiento;
	
	private Date fechaSancionComite;

	private String codMotivoAnulacion;

	private String descMotivoAnulacion;

	private String codMotivoRechazoExp;

	private String descMotivoRechazoExp;
	
	private String codMotivoAnulacionAlq;

	private String descMotivoAnulacionAlq;

	private Date fechaAnulacion;

	private Date fechaContabilizacionPropietario;

	private String peticionarioAnulacion;

	private Double importeDevolucionEntregas;

	private Date fechaDevolucionEntregas;
	
	private String tipoAlquiler;
	
	private String tipoInquilino;

	private Long idTrabajo;
	
	private String estadoTrabajo;
	
	private String motivoAnulacionTrabajo;
	
	private Long numTrabajo;

	private boolean tieneReserva;

	private Date fechaInicioAlquiler;
	private Date fechaFinAlquiler;
	private Double importeRentaAlquiler;
	private String numContratoAlquiler;
	private Date fechaPlazoOpcionCompraAlquiler;
	private Double primaOpcionCompraAlquiler;
	private Double precioOpcionCompraAlquiler;
	private String condicionesOpcionCompraAlquiler;
	private Integer conflictoIntereses;
	private Integer riesgoReputacional;
	private Integer estadoPbc;
	private Integer estadoPbcR;
	private Date fechaVenta;
	

	private Integer alquilerOpcionCompra;
	private String codigoEstado;

	private String estadoDevolucionCodigo;
	private Boolean ocultarPestTanteoRetracto;
	
	private String estadoReserva;
	private String estadoReservaCod;
	private String codDevolucionReserva;
	
	private Boolean bloqueado;
	

	private Integer solicitaReserva; 
	
	private String codigoComiteSancionador;
	
	private Boolean definicionOfertaFinalizada;
	
	private Boolean definicionOfertaScoring;

	private String subcarteraCodigo;
	private Boolean estaFirmado;
	private Boolean problemasUrsus;
	private Long idOfertaAnterior;
	private Boolean noEsOfertaFinalGencat;
	
	private Date fechaEnvioAdvisoryNote;
	
	private Date fechaRecomendacionCes;
	
	private Date fechaAprobacionProManzana;
	
	private Date fechaContabilizacionVenta;

	private Boolean esComiteHaya;
	
	private Boolean finalizadoCierreEconomico;
	
	private String codigoEstadoBc;
	
	private Integer estadoPbcCn;
	
	private Integer estadoPbcArras;
	
	private Date fechaContabilizacion;
	
	private Date fechaReservaDeposito;
	
	private Date fechaFirmaContrato;
	
	private String clasificacionCodigo;
	
	
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

	public Long getNumExpediente() {
		return numExpediente;
	}

	public void setNumExpediente(Long numExpediente) {
		this.numExpediente = numExpediente;
	}

	public String getMediador() {
		return mediador;
	}

	public void setMediador(String mediador) {
		this.mediador = mediador;
	}

	public String getPropietario() {
		return propietario;
	}

	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}

	public String getComprador() {
		return comprador;
	}

	public void setComprador(String comprador) {
		this.comprador = comprador;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String estado) {
		this.estado = estado;
	}

	public Double getImporte() {
		return importe;
	}

	public void setImporte(Double importe) {
		this.importe = importe;
	}

	public String getEntidadPropietariaDescripcion() {
		return entidadPropietariaDescripcion;
	}

	public void setEntidadPropietariaDescripcion(String entidadPropietariaDescripcion) {
		this.entidadPropietariaDescripcion = entidadPropietariaDescripcion;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaSancion() {
		return fechaSancion;
	}

	public void setFechaSancion(Date fechaSancion) {
		this.fechaSancion = fechaSancion;
	}

	public String getOrigen() {
		return origen;
	}
	
	public void setOrigen(String origen) {
		this.origen = origen;
	}

	public Date getFechaReserva() {
		return fechaReserva;
	}

	public void setFechaReserva(Date fechaReserva) {
		this.fechaReserva = fechaReserva;
	}
	
	public Date getFechaContabilizacionReserva() {
		return fechaContabilizacionReserva;
	}

	public void setFechaContabilizacionReserva(Date fechaContabilizacionReserva) {
		this.fechaContabilizacionReserva = fechaContabilizacionReserva;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public String getTipoExpedienteCodigo() {
		return tipoExpedienteCodigo;
	}

	public void setTipoExpedienteCodigo(String tipoExpedienteCodigo) {
		this.tipoExpedienteCodigo = tipoExpedienteCodigo;
	}

	public String getTipoExpedienteDescripcion() {
		return tipoExpedienteDescripcion;
	}

	public void setTipoExpedienteDescripcion(String tipoExpedienteDescripcion) {
		this.tipoExpedienteDescripcion = tipoExpedienteDescripcion;
	}

	public Long getNumEntidad() {
		return numEntidad;
	}

	public void setNumEntidad(Long numEntidad) {
		this.numEntidad = numEntidad;
	}

	public Date getFechaAltaOferta() {
		return fechaAltaOferta;
	}

	public void setFechaAltaOferta(Date fechaAltaOferta) {
		this.fechaAltaOferta = fechaAltaOferta;
	}

	public Date getFechaPosicionamiento() {
		return fechaPosicionamiento;
	}

	public void setFechaPosicionamiento(Date fechaPosicionamiento) {
		this.fechaPosicionamiento = fechaPosicionamiento;
	}

	public String getCodMotivoAnulacion() {
		return codMotivoAnulacion;
	}

	public void setCodMotivoAnulacion(String codMotivoAnulacion) {
		this.codMotivoAnulacion = codMotivoAnulacion;
	}
	
	public String getDescMotivoAnulacion() {
		return descMotivoAnulacion;
	}

	public void setDescMotivoAnulacion(String descMotivoAnulacion) {
		this.descMotivoAnulacion = descMotivoAnulacion;
	}

	public String getCodMotivoRechazoExp() {
		return codMotivoRechazoExp;
	}

	public void setCodMotivoRechazoExp(String codMotivoRechazoExp) {
		this.codMotivoRechazoExp = codMotivoRechazoExp;
	}

	public String getDescMotivoRechazoExp() {
		return descMotivoRechazoExp;
	}

	public void setDescMotivoRechazoExp(String descMotivoRechazoExp) {
		this.descMotivoRechazoExp = descMotivoRechazoExp;
	}

	public Date getFechaAnulacion() {
		return fechaAnulacion;
	}

	public void setFechaAnulacion(Date fechaAnulacion) {
		this.fechaAnulacion = fechaAnulacion;
	}

	public Date getFechaContabilizacionPropietario() {
		return fechaContabilizacionPropietario;
	}

	public void setFechaContabilizacionPropietario(Date fechaContabilizacionPropietario) {
		this.fechaContabilizacionPropietario = fechaContabilizacionPropietario;
	}

	public String getPeticionarioAnulacion() {
		return peticionarioAnulacion;
	}

	public void setPeticionarioAnulacion(String peticionarioAnulacion) {
		this.peticionarioAnulacion = peticionarioAnulacion;
	}

	public Double getImporteDevolucionEntregas() {
		return importeDevolucionEntregas;
	}

	public void setImporteDevolucionEntregas(Double importeDevolucionEntregas) {
		this.importeDevolucionEntregas = importeDevolucionEntregas;
	}

	public Date getFechaDevolucionEntregas() {
		return fechaDevolucionEntregas;
	}

	public void setFechaDevolucionEntregas(Date fechaDevolucionEntregas) {
		this.fechaDevolucionEntregas = fechaDevolucionEntregas;
	}

	public void setTieneReserva(boolean tieneReserva) {
		this.tieneReserva = tieneReserva;
	}

	public boolean getTieneReserva() {
		return this.tieneReserva;

	}

	public Date getFechaInicioAlquiler() {
		return fechaInicioAlquiler;
	}

	public void setFechaInicioAlquiler(Date fechaInicioAlquiler) {
		this.fechaInicioAlquiler = fechaInicioAlquiler;
	}

	public Date getFechaFinAlquiler() {
		return fechaFinAlquiler;
	}

	public void setFechaFinAlquiler(Date fechaFinAlquiler) {
		this.fechaFinAlquiler = fechaFinAlquiler;
	}

	public Double getImporteRentaAlquiler() {
		return importeRentaAlquiler;
	}

	public void setImporteRentaAlquiler(Double importeRentaAlquiler) {
		this.importeRentaAlquiler = importeRentaAlquiler;
	}

	public String getNumContratoAlquiler() {
		return numContratoAlquiler;
	}

	public void setNumContratoAlquiler(String numContratoAlquiler) {
		this.numContratoAlquiler = numContratoAlquiler;
	}

	public Date getFechaPlazoOpcionCompraAlquiler() {
		return fechaPlazoOpcionCompraAlquiler;
	}

	public void setFechaPlazoOpcionCompraAlquiler(Date fechaPlazoOpcionCompraAlquiler) {
		this.fechaPlazoOpcionCompraAlquiler = fechaPlazoOpcionCompraAlquiler;
	}

	public Double getPrimaOpcionCompraAlquiler() {
		return primaOpcionCompraAlquiler;
	}

	public void setPrimaOpcionCompraAlquiler(Double primaOpcionCompraAlquiler) {
		this.primaOpcionCompraAlquiler = primaOpcionCompraAlquiler;
	}

	public Double getPrecioOpcionCompraAlquiler() {
		return precioOpcionCompraAlquiler;
	}

	public void setPrecioOpcionCompraAlquiler(Double precioOpcionCompraAlquiler) {
		this.precioOpcionCompraAlquiler = precioOpcionCompraAlquiler;
	}

	public String getCondicionesOpcionCompraAlquiler() {
		return condicionesOpcionCompraAlquiler;
	}

	public void setCondicionesOpcionCompraAlquiler(String condicionesOpcionCompraAlquiler) {
		this.condicionesOpcionCompraAlquiler = condicionesOpcionCompraAlquiler;
	}

	public Integer getConflictoIntereses() {
		return conflictoIntereses;
	}

	public void setConflictoIntereses(Integer conflictoIntereses) {
		this.conflictoIntereses = conflictoIntereses;
	}

	public Integer getRiesgoReputacional() {
		return riesgoReputacional;
	}

	public void setRiesgoReputacional(Integer riesgoReputacional) {
		this.riesgoReputacional = riesgoReputacional;
	}

	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}

	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}

	public Integer getEstadoPbc() {
		return estadoPbc;
	}

	public void setEstadoPbc(Integer estadoPbc) {
		this.estadoPbc = estadoPbc;
	}
	public Integer getEstadoPbcR() {
		return estadoPbcR;
	}

	public void setEstadoPbcR(Integer estadoPbcR) {
		this.estadoPbcR = estadoPbcR;
	}

	public Integer getAlquilerOpcionCompra() {
		return alquilerOpcionCompra;
	}

	public void setAlquilerOpcionCompra(Integer alquilerOpcionCompra) {
		this.alquilerOpcionCompra = alquilerOpcionCompra;
	}

	public Date getFechaVenta() {
		return fechaVenta;
	}

	public void setFechaVenta(Date fechaVenta) {
		this.fechaVenta = fechaVenta;
	}

	public String getCodigoEstado() {
		return codigoEstado;
	}

	public void setCodigoEstado(String codigoEstado) {
		this.codigoEstado = codigoEstado;
	}

	public String getEstadoDevolucionCodigo() {
		return estadoDevolucionCodigo;
	}

	public void setEstadoDevolucionCodigo(String estadoDevolucionCodigo) {
		this.estadoDevolucionCodigo = estadoDevolucionCodigo;
	}

	public Boolean getOcultarPestTanteoRetracto() {
		return ocultarPestTanteoRetracto;
	}

	public void setOcultarPestTanteoRetracto(Boolean ocultarPestTanteoRetracto) {
		this.ocultarPestTanteoRetracto = ocultarPestTanteoRetracto;
	}

	public String getCodDevolucionReserva() {
		return codDevolucionReserva;
	}

	public void setCodDevolucionReserva(String codDevolucionReserva) {
		this.codDevolucionReserva = codDevolucionReserva;
	}

	public Boolean getBloqueado() {
		return bloqueado;
	}

	public void setBloqueado(Boolean bloqueado) {
		this.bloqueado = bloqueado;
	}

	public String getEstadoReserva() {
		return estadoReserva;
	}

	public void setEstadoReserva(String estadoReserva) {
		this.estadoReserva = estadoReserva;
	}

	public Integer getSolicitaReserva() {
		return solicitaReserva;
	}

	public void setSolicitaReserva(Integer solicitaReserva) {
		this.solicitaReserva = solicitaReserva;
	}

	public String getCodigoComiteSancionador() {
		return codigoComiteSancionador;
	}

	public void setCodigoComiteSancionador(String codigoComiteSancionador) {
		this.codigoComiteSancionador = codigoComiteSancionador;
	}

	public String getTipoAlquiler() {
		return tipoAlquiler;
	}

	public void setTipoAlquiler(String tipoAlquiler) {
		this.tipoAlquiler = tipoAlquiler;
	}

	public String getTipoInquilino() {
		return tipoInquilino;
	}

	public void setTipoInquilino(String tipoInquilino) {
		this.tipoInquilino = tipoInquilino;
	}

	public Long getIdTrabajo() {
		return idTrabajo;
	}

	public void setIdTrabajo(Long idTrabajo) {
		this.idTrabajo = idTrabajo;
	}
	
	public void setEstadoTrabajo(String estadoTrabajo) {
		this.estadoTrabajo = estadoTrabajo;
	}
	
	public String getEstadoTrabajo() {
		return estadoTrabajo;
	}
	
	public String getMotivoAnulacionTrabajo() {
		return motivoAnulacionTrabajo;
	}

	public void setMotivoAnulacionTrabajo(String motivoAnulacionTrabajo) {
		this.motivoAnulacionTrabajo = motivoAnulacionTrabajo;
	}

	public Date getFechaSancionComite() {
		return fechaSancionComite;
	}

	public void setFechaSancionComite(Date fechaSancionComite) {
		this.fechaSancionComite = fechaSancionComite;
	}

	public Boolean getDefinicionOfertaFinalizada() {
		return definicionOfertaFinalizada;
	}

	public void setDefinicionOfertaFinalizada(Boolean definicionOfertaFinalizada) {
		this.definicionOfertaFinalizada = definicionOfertaFinalizada;
	}

	public Boolean getDefinicionOfertaScoring() {
		return definicionOfertaScoring;
	}

	public void setDefinicionOfertaScoring(Boolean definicionOfertaScoring) {
		this.definicionOfertaScoring = definicionOfertaScoring;

	}

	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}

	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;

	}

	public Boolean getEstaFirmado() {
		return estaFirmado;
	}

	public void setEstaFirmado(Boolean estaFirmado) {
		this.estaFirmado = estaFirmado;
	}

	public Long getNumTrabajo() {
		return numTrabajo;
	}

	public void setNumTrabajo(Long numTrabajo) {
		this.numTrabajo = numTrabajo;
	}

	public String getCodMotivoAnulacionAlq() {
		return codMotivoAnulacionAlq;
	}

	public void setCodMotivoAnulacionAlq(String codMotivoAnulacionAlq) {
		this.codMotivoAnulacionAlq = codMotivoAnulacionAlq;
	}

	public String getDescMotivoAnulacionAlq() {
		return descMotivoAnulacionAlq;
	}

	public void setDescMotivoAnulacionAlq(String descMotivoAnulacionAlq) {
		this.descMotivoAnulacionAlq = descMotivoAnulacionAlq;
	}

	public Boolean getProblemasUrsus() {
		return problemasUrsus;
	}

	public void setProblemasUrsus(Boolean problemasUrsus) {
		this.problemasUrsus = problemasUrsus;
	}
	public Long getIdOfertaAnterior() {
		return idOfertaAnterior;
	}

	public void setIdOfertaAnterior(Long idOfertaAnterior) {
		this.idOfertaAnterior = idOfertaAnterior;
	}

	public Boolean getNoEsOfertaFinalGencat() {
		return noEsOfertaFinalGencat;
	}

	public void setNoEsOfertaFinalGencat(Boolean noEsOfertaFinalGencat) {
		this.noEsOfertaFinalGencat = noEsOfertaFinalGencat;
	}

	public Date getFechaEnvioAdvisoryNote() {
		return fechaEnvioAdvisoryNote;
	}

	public void setFechaEnvioAdvisoryNote(Date fechaEnvioAdvisoryNote) {
		this.fechaEnvioAdvisoryNote = fechaEnvioAdvisoryNote;
	}

	public Date getFechaRecomendacionCes() {
		return fechaRecomendacionCes;
	}

	public void setFechaRecomendacionCes(Date fechaRecomendacionCes) {
		this.fechaRecomendacionCes = fechaRecomendacionCes;
	}

	public Date getFechaAprobacionProManzana() {
		return fechaAprobacionProManzana;
	}

	public void setFechaAprobacionProManzana(Date fechaAprobacionProManzana) {
		this.fechaAprobacionProManzana = fechaAprobacionProManzana;
	}

	public Date getFechaContabilizacionVenta() {
		return fechaContabilizacionVenta;
	}

	public void setFechaContabilizacionVenta(Date fechaContabilizacionVenta) {
		this.fechaContabilizacionVenta = fechaContabilizacionVenta;
	}
	
	public Boolean getEsComiteHaya() {
		return esComiteHaya;
	}

	public void setEsComiteHaya(Boolean esComiteHaya) {
		this.esComiteHaya = esComiteHaya;
	}

	public Boolean getFinalizadoCierreEconomico() {
		return finalizadoCierreEconomico;
	}

	public void setFinalizadoCierreEconomico(Boolean finalizadoCierreEconomico) {
		this.finalizadoCierreEconomico = finalizadoCierreEconomico;
	}

	public String getCodigoEstadoBc() {
		return codigoEstadoBc;
	}

	public void setCodigoEstadoBc(String codigoEstadoBc) {
		this.codigoEstadoBc = codigoEstadoBc;
	}

	public Integer getEstadoPbcCn() {
		return estadoPbcCn;
	}

	public void setEstadoPbcCn(Integer estadoPbcCn) {
		this.estadoPbcCn = estadoPbcCn;
	}

	public Integer getEstadoPbcArras() {
		return estadoPbcArras;
	}

	public void setEstadoPbcArras(Integer estadoPbcArras) {
		this.estadoPbcArras = estadoPbcArras;
	}

	public Date getFechaContabilizacion() {
		return fechaContabilizacion;
	}

	public void setFechaContabilizacion(Date fechaContabilizacion) {
		this.fechaContabilizacion = fechaContabilizacion;
	}

	public Date getFechaReservaDeposito() {
		return fechaReservaDeposito;
	}

	public void setFechaReservaDeposito(Date fechaReservaDeposito) {
		this.fechaReservaDeposito = fechaReservaDeposito;
	}

	public String getEstadoReservaCod() {
		return estadoReservaCod;
	}

	public void setEstadoReservaCod(String estadoReservaCod) {
		this.estadoReservaCod = estadoReservaCod;
	}

	public Date getFechaFirmaContrato() {
		return fechaFirmaContrato;
	}

	public void setFechaFirmaContrato(Date fechaFirmaContrato) {
		this.fechaFirmaContrato = fechaFirmaContrato;
	}

	public String getClasificacionCodigo() {
		return clasificacionCodigo;
	}

	public void setClasificacionCodigo(String clasificacionCodigo) {
		this.clasificacionCodigo = clasificacionCodigo;
	}
	
}
