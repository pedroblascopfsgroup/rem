package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de los datos básicos de las condiciones de un expediente.
 *  
 * @author Jose Villel
 *
 */
public class DtoCondiciones extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idCondiciones;
	
	private Integer solicitaFinanciacion;
	private Date inicioExpediente;
	private Date inicioFinanciacion;
	private String entidadFinanciacion;
	private String estadosFinanciacion;
	private Date finFinanciacion;
	private String tipoCalculo;
	private Double porcentajeReserva;
	private Integer plazoFirmaReserva;
	private Double importeReserva;
	private String tipoImpuestoCodigo;
	private Double tipoAplicable;
	private Integer renunciaExencion;
	private Integer reservaConImpuesto;
	private Double gastosPlusvalia;
	private String plusvaliaPorCuentaDe;
	private Double gastosNotaria;
	private String notariaPorCuentaDe;
	private Double gastosOtros;
	private String gastosCompraventaOtrosPorCuentaDe;
	private String impuestosPorCuentaDe;
	private String comunidadesPorCuentaDe;
	private String cargasPendientesOtrosPorCuentaDe;
	private String estadoTituloCodigo;
	private Integer renunciaSaneamientoEviccion;
	private Integer renunciaSaneamientoVicios;
	private Integer procedeDescalificacion;
	private String procedeDescalificacionPorCuentaDe;
	private Double impuestos;
	private Double comunidades;
	private Integer sujetoTramiteTanteo;
	private String licencia;
	private String estadoTramite;
	private Double cargasOtros;
	private String situacionPosesoriaCodigo;
	private String licenciaPorCuentaDe;
	private Integer posesionInical;
	private Date fechaInicioExpediente;
	private Date fechaInicioFinanciacion;
	private Date fechaFinFinanciacion;
	

	//********Datos que vienen del activos (no se editan)********
	private Date fechaUltimaActualizacion;
	private Date fechaTomaPosesion;
	private Integer ocupado;
	private Integer conTitulo;
	private String tipoTitulo;
	private Integer vpo;
	//********-------------------------------------------********

	public Long getIdCondiciones() {
		return idCondiciones;
	}

	public void setIdCondiciones(Long idCondiciones) {
		this.idCondiciones = idCondiciones;
	}
	
	public Integer getSolicitaFinanciacion() {
		return solicitaFinanciacion;
	}

	public void setSolicitaFinanciacion(Integer solicitaFinanciacion) {
		this.solicitaFinanciacion = solicitaFinanciacion;
	}

	public Date getFechaUltimaActualizacion() {
		return fechaUltimaActualizacion;
	}

	public void setFechaUltimaActualizacion(Date fechaUltimaActualizacion) {
		this.fechaUltimaActualizacion = fechaUltimaActualizacion;
	}

	public Date getFechaTomaPosesion() {
		return fechaTomaPosesion;
	}

	public void setFechaTomaPosesion(Date fechaTomaPosesion) {
		this.fechaTomaPosesion = fechaTomaPosesion;
	}

	public Integer getOcupado() {
		return ocupado;
	}

	public void setOcupado(Integer ocupado) {
		this.ocupado = ocupado;
	}

	public Integer getConTitulo() {
		return conTitulo;
	}

	public void setConTitulo(Integer conTitulo) {
		this.conTitulo = conTitulo;
	}

	public String getTipoTitulo() {
		return tipoTitulo;
	}

	public void setTipoTitulo(String tipoTitulo) {
		this.tipoTitulo = tipoTitulo;
	}

	public Integer getVpo() {
		return vpo;
	}

	public void setVpo(Integer vpo) {
		this.vpo = vpo;
	}

	public Date getInicioExpediente() {
		return inicioExpediente;
	}

	public void setInicioExpediente(Date inicioExpediente) {
		this.inicioExpediente = inicioExpediente;
	}

	public Date getInicioFinanciacion() {
		return inicioFinanciacion;
	}

	public void setInicioFinanciacion(Date inicioFinanciacion) {
		this.inicioFinanciacion = inicioFinanciacion;
	}

	public String getEntidadFinanciacion() {
		return entidadFinanciacion;
	}

	public void setEntidadFinanciacion(String entidadFinanciacion) {
		this.entidadFinanciacion = entidadFinanciacion;
	}

	public String getEstadosFinanciacion() {
		return estadosFinanciacion;
	}

	public void setEstadosFinanciacion(String estadosFinanciacion) {
		this.estadosFinanciacion = estadosFinanciacion;
	}

	public Date getFinFinanciacion() {
		return finFinanciacion;
	}

	public void setFinFinanciacion(Date finFinanciacion) {
		this.finFinanciacion = finFinanciacion;
	}

	public String getTipoCalculo() {
		return tipoCalculo;
	}

	public void setTipoCalculo(String tipoCalculo) {
		this.tipoCalculo = tipoCalculo;
	}

	public Double getPorcentajeReserva() {
		return porcentajeReserva;
	}

	public void setPorcentajeReserva(Double porcentajeReserva) {
		this.porcentajeReserva = porcentajeReserva;
	}

	public Integer getPlazoFirmaReserva() {
		return plazoFirmaReserva;
	}

	public void setPlazoFirmaReserva(Integer plazoFirmaReserva) {
		this.plazoFirmaReserva = plazoFirmaReserva;
	}

	public Double getImporteReserva() {
		return importeReserva;
	}

	public void setImporteReserva(Double importeReserva) {
		this.importeReserva = importeReserva;
	}

	public String getTipoImpuestoCodigo() {
		return tipoImpuestoCodigo;
	}

	public void setTipoImpuestoCodigo(String tipoImpuestoCodigo) {
		this.tipoImpuestoCodigo = tipoImpuestoCodigo;
	}

	public Double getTipoAplicable() {
		return tipoAplicable;
	}

	public void setTipoAplicable(Double tipoAplicable) {
		this.tipoAplicable = tipoAplicable;
	}

	public Integer getRenunciaExencion() {
		return renunciaExencion;
	}

	public void setRenunciaExencion(Integer renunciaExencion) {
		this.renunciaExencion = renunciaExencion;
	}

	public Integer getReservaConImpuesto() {
		return reservaConImpuesto;
	}

	public void setReservaConImpuesto(Integer reservaConImpuesto) {
		this.reservaConImpuesto = reservaConImpuesto;
	}


	public Double getGastosPlusvalia() {
		return gastosPlusvalia;
	}

	public void setGastosPlusvalia(Double gastosPlusvalia) {
		this.gastosPlusvalia = gastosPlusvalia;
	}

	public String getPlusvaliaPorCuentaDe() {
		return plusvaliaPorCuentaDe;
	}

	public void setPlusvaliaPorCuentaDe(String plusvaliaPorCuentaDe) {
		this.plusvaliaPorCuentaDe = plusvaliaPorCuentaDe;
	}

	public Double getGastosNotaria() {
		return gastosNotaria;
	}

	public void setGastosNotaria(Double gastosNotaria) {
		this.gastosNotaria = gastosNotaria;
	}

	public String getNotariaPorCuentaDe() {
		return notariaPorCuentaDe;
	}

	public void setNotariaPorCuentaDe(String notariaPorCuentaDe) {
		this.notariaPorCuentaDe = notariaPorCuentaDe;
	}

	public Double getGastosOtros() {
		return gastosOtros;
	}

	public void setGastosOtros(Double gastosOtros) {
		this.gastosOtros = gastosOtros;
	}

	public String getGastosCompraventaOtrosPorCuentaDe() {
		return gastosCompraventaOtrosPorCuentaDe;
	}

	public void setGastosCompraventaOtrosPorCuentaDe(
			String gastosCompraventaOtrosPorCuentaDe) {
		this.gastosCompraventaOtrosPorCuentaDe = gastosCompraventaOtrosPorCuentaDe;
	}

	public String getImpuestosPorCuentaDe() {
		return impuestosPorCuentaDe;
	}

	public void setImpuestosPorCuentaDe(String impuestosPorCuentaDe) {
		this.impuestosPorCuentaDe = impuestosPorCuentaDe;
	}

	public String getComunidadesPorCuentaDe() {
		return comunidadesPorCuentaDe;
	}

	public void setComunidadesPorCuentaDe(String comunidadesPorCuentaDe) {
		this.comunidadesPorCuentaDe = comunidadesPorCuentaDe;
	}

	public String getCargasPendientesOtrosPorCuentaDe() {
		return cargasPendientesOtrosPorCuentaDe;
	}

	public void setCargasPendientesOtrosPorCuentaDe(
			String cargasPendientesOtrosPorCuentaDe) {
		this.cargasPendientesOtrosPorCuentaDe = cargasPendientesOtrosPorCuentaDe;
	}

	public String getEstadoTituloCodigo() {
		return estadoTituloCodigo;
	}

	public void setEstadoTituloCodigo(String estadoTituloCodigo) {
		this.estadoTituloCodigo = estadoTituloCodigo;
	}

	public Integer getRenunciaSaneamientoEviccion() {
		return renunciaSaneamientoEviccion;
	}

	public void setRenunciaSaneamientoEviccion(Integer renunciaSaneamientoEviccion) {
		this.renunciaSaneamientoEviccion = renunciaSaneamientoEviccion;
	}

	public Integer getRenunciaSaneamientoVicios() {
		return renunciaSaneamientoVicios;
	}

	public void setRenunciaSaneamientoVicios(Integer renunciaSaneamientoVicios) {
		this.renunciaSaneamientoVicios = renunciaSaneamientoVicios;
	}

	public Integer getProcedeDescalificacion() {
		return procedeDescalificacion;
	}

	public void setProcedeDescalificacion(Integer procedeDescalificacion) {
		this.procedeDescalificacion = procedeDescalificacion;
	}

	public String getProcedeDescalificacionPorCuentaDe() {
		return procedeDescalificacionPorCuentaDe;
	}

	public void setProcedeDescalificacionPorCuentaDe(
			String procedeDescalificacionPorCuentaDe) {
		this.procedeDescalificacionPorCuentaDe = procedeDescalificacionPorCuentaDe;
	}

	public Double getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(Double impuestos) {
		this.impuestos = impuestos;
	}

	public Double getComunidades() {
		return comunidades;
	}

	public void setComunidades(Double comunidades) {
		this.comunidades = comunidades;
	}

	public Integer getSujetoTramiteTanteo() {
		return sujetoTramiteTanteo;
	}

	public void setSujetoTramiteTanteo(Integer sujetoTramiteTanteo) {
		this.sujetoTramiteTanteo = sujetoTramiteTanteo;
	}

	public String getLicencia() {
		return licencia;
	}

	public void setLicencia(String licencia) {
		this.licencia = licencia;
	}

	public String getEstadoTramite() {
		return estadoTramite;
	}

	public void setEstadoTramite(String estadoTramite) {
		this.estadoTramite = estadoTramite;
	}

	public Double getCargasOtros() {
		return cargasOtros;
	}

	public void setCargasOtros(Double cargasOtros) {
		this.cargasOtros = cargasOtros;
	}

	public String getSituacionPosesoriaCodigo() {
		return situacionPosesoriaCodigo;
	}

	public void setSituacionPosesoriaCodigo(String situacionPosesoriaCodigo) {
		this.situacionPosesoriaCodigo = situacionPosesoriaCodigo;
	}

	public String getLicenciaPorCuentaDe() {
		return licenciaPorCuentaDe;
	}

	public void setLicenciaPorCuentaDe(String licenciaPorCuentaDe) {
		this.licenciaPorCuentaDe = licenciaPorCuentaDe;
	}

	public Integer getPosesionInical() {
		return posesionInical;
	}

	public void setPosesionInical(Integer posesionInical) {
		this.posesionInical = posesionInical;
	}

	public Date getFechaInicioExpediente() {
		return fechaInicioExpediente;
	}

	public void setFechaInicioExpediente(Date fechaInicioExpediente) {
		this.fechaInicioExpediente = fechaInicioExpediente;
	}

	public Date getFechaInicioFinanciacion() {
		return fechaInicioFinanciacion;
	}

	public void setFechaInicioFinanciacion(Date fechaInicioFinanciacion) {
		this.fechaInicioFinanciacion = fechaInicioFinanciacion;
	}

	public Date getFechaFinFinanciacion() {
		return fechaFinFinanciacion;
	}

	public void setFechaFinFinanciacion(Date fechaFinFinanciacion) {
		this.fechaFinFinanciacion = fechaFinFinanciacion;
	}  
   	
   	
   	
}
