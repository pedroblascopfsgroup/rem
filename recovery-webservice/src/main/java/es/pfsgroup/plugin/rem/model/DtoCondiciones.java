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
	private Boolean renunciaExencion;
	private Boolean reservaConImpuesto;
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
	private Boolean sujetoTramiteTanteo;
	private String licencia;
	private String estadoTramite;
	private Double cargasOtros;
	private String situacionPosesoriaCodigo;
	private String licenciaPorCuentaDe;
	private Date fechaInicioExpediente;
	private Date fechaInicioFinanciacion;
	private Date fechaFinFinanciacion;
	private Integer posesionInicial;
	private Double gastosIbi;
	private Double gastosComunidad;
	private Double gastosSuministros;
	private String ibiPorCuentaDe;
	private String comunidadPorCuentaDe;
	private String suministrosPorCuentaDe;
	private Integer solicitaReserva;
	private Boolean operacionExenta;
	private Boolean inversionDeSujetoPasivo;
	private Boolean tributosSobrePropiedad;
	private Boolean necesidadIf;
	
	private Integer mesesFianza;
	private Double importeFianza;
	private Boolean fianzaActualizable;
	private Integer mesesDeposito;
	private Double importeDeposito;
	private Boolean depositoActualizable;
	private String avalista;
	private String documentoFiador;
	private String codigoEntidad;
	private String importeAval;
	private Integer numeroAval;
	private Boolean renunciaTanteo;
	private Boolean carencia;
	private String mesesCarencia;
	private String importeCarencia;
	private Boolean bonificacion;
	private String mesesBonificacion;
	private String importeBonificacion;
	private String duracionBonificacion;
	private Boolean gastosRepercutibles;
	private String repercutiblesComments;
	private String entidadComments;
	private Boolean checkFijo;
	private Date fechaFijo;
	private Double incrementoRentaFijo;
	
	private Boolean checkPorcentual;
	private Boolean checkIPC;
	private Integer porcentaje;
	private Boolean checkRevisionMercado;
	private Date revisionMercadoFecha;
	private Integer revisionMercadoMeses;
	private Double	depositoReserva;
	
	//********Datos que vienen del activos (no se editan)********
	private Date fechaUltimaActualizacion;
	private Date fechaTomaPosesion;
	private Integer ocupado;
	private String conTitulo;
	private String tipoTitulo;
	private Integer vpo;
	//********-------------------------------------------********
	
	

	//Datos para el historico de condiciones, que se utilizan en el grid
	private Date fechaMinima;

	private Boolean insertarHistorico;
	
	private Boolean fianzaExonerada;
	private Date fechaIngresoFianzaArrendatario;
	private Boolean derechoCesionSubarriendo;
	private Boolean vulnerabilidadDetectada;
	private String regimenFianzaCCAACodigo;
	private Boolean certificaciones;
	private Boolean ofrNuevasCondiciones;
	private Boolean fianzaContratosSubrogados;
	private Boolean adecuaciones;
	private Boolean cntSuscritoPosteridadAdj;
	private Boolean antiguoDeudorLocalizable;
	
	private Boolean entregasCuenta;
	private Boolean rentasCuenta;
	private Double importeEntregasCuenta;
	
	private Double obligadoCumplimiento; //años
	private Date fechaPreavisoVencimientoCnt;
	private Date fechaInicioCnt;
	private Date fechaFinCnt;
	
	private String metodoActualizacionRentaCod;
	private Boolean checkIGC;
	private Long periodicidadMeses;
	private Date fechaActualizacion;
	
	private String tipoGrupoImpuestoCod;
	private Boolean bloqueDepositoEditable;
	private String tipoGrupoImpuestoCodAlq;
	private String tipoImpuestoCodigoAlq;
	
	public Integer getMesesFianza() {
		return mesesFianza;
	}

	public void setMesesFianza(Integer mesesFianza) {
		this.mesesFianza = mesesFianza;
	}

	public Double getImporteFianza() {
		return importeFianza;
	}

	public void setImporteFianza(Double importeFianza) {
		this.importeFianza = importeFianza;
	}

	public Boolean getFianzaActualizable() {
		return fianzaActualizable;
	}

	public void setFianzaActualizable(Boolean fianzaActualizable) {
		this.fianzaActualizable = fianzaActualizable;
	}

	public Integer getMesesDeposito() {
		return mesesDeposito;
	}

	public void setMesesDeposito(Integer mesesDeposito) {
		this.mesesDeposito = mesesDeposito;
	}

	public Double getImporteDeposito() {
		return importeDeposito;
	}

	public void setImporteDeposito(Double importeDeposito) {
		this.importeDeposito = importeDeposito;
	}

	public Boolean getDepositoActualizable() {
		return depositoActualizable;
	}

	public void setDepositoActualizable(Boolean depositoActualizable) {
		this.depositoActualizable = depositoActualizable;
	}

	public String getAvalista() {
		return avalista;
	}

	public void setAvalista(String avalista) {
		this.avalista = avalista;
	}

	public String getDocumentoFiador() {
		return documentoFiador;
	}

	public void setDocumentoFiador(String documentoFiador) {
		this.documentoFiador = documentoFiador;
	}

	public String getCodigoEntidad() {
		return codigoEntidad;
	}

	public void setCodigoEntidad(String codigoEntidad) {
		this.codigoEntidad = codigoEntidad;
	}

	public String getImporteAval() {
		return importeAval;
	}

	public void setImporteAval(String importeAval) {
		this.importeAval = importeAval;
	}

	public Integer getNumeroAval() {
		return numeroAval;
	}

	public void setNumeroAval(Integer numeroAval) {
		this.numeroAval = numeroAval;
	}

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

	public String getConTitulo() {
		return conTitulo;
	}

	public void setConTitulo(String conTitulo) {
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

	public Boolean getRenunciaExencion() {
		return renunciaExencion;
	}

	public void setRenunciaExencion(Boolean renunciaExencion) {
		this.renunciaExencion = renunciaExencion;
	}

	public Boolean getReservaConImpuesto() {
		return reservaConImpuesto;
	}

	public void setReservaConImpuesto(Boolean reservaConImpuesto) {
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

	public Boolean getSujetoTramiteTanteo() {
		return sujetoTramiteTanteo;
	}

	public void setSujetoTramiteTanteo(Boolean sujetoTramiteTanteo) {
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

	public Integer getPosesionInicial() {
		return posesionInicial;
	}

	public void setPosesionInicial(Integer posesionInicial) {
		this.posesionInicial = posesionInicial;
	}

	public Double getGastosIbi() {
		return gastosIbi;
	}

	public void setGastosIbi(Double gastosIbi) {
		this.gastosIbi = gastosIbi;
	}

	public Double getGastosComunidad() {
		return gastosComunidad;
	}

	public void setGastosComunidad(Double gastosComunidad) {
		this.gastosComunidad = gastosComunidad;
	}

	public Double getGastosSuministros() {
		return gastosSuministros;
	}

	public void setGastosSuministros(Double gastosSuministros) {
		this.gastosSuministros = gastosSuministros;
	}

	public String getIbiPorCuentaDe() {
		return ibiPorCuentaDe;
	}

	public void setIbiPorCuentaDe(String ibiPorCuentaDe) {
		this.ibiPorCuentaDe = ibiPorCuentaDe;
	}

	public String getComunidadPorCuentaDe() {
		return comunidadPorCuentaDe;
	}

	public void setComunidadPorCuentaDe(String comunidadPorCuentaDe) {
		this.comunidadPorCuentaDe = comunidadPorCuentaDe;
	}

	public String getSuministrosPorCuentaDe() {
		return suministrosPorCuentaDe;
	}

	public void setSuministrosPorCuentaDe(String suministrosPorCuentaDe) {
		this.suministrosPorCuentaDe = suministrosPorCuentaDe;
	}

	public Integer getSolicitaReserva() {
		return solicitaReserva;
	}

	public void setSolicitaReserva(Integer solicitaReserva) {
		this.solicitaReserva = solicitaReserva;
	}

	public Boolean getOperacionExenta() {
		return operacionExenta;
	}

	public void setOperacionExenta(Boolean operacionExenta) {
		this.operacionExenta = operacionExenta;
	}

	public Boolean getInversionDeSujetoPasivo() {
		return inversionDeSujetoPasivo;
	}

	public void setInversionDeSujetoPasivo(Boolean inversionDeSujetoPasivo) {
		this.inversionDeSujetoPasivo = inversionDeSujetoPasivo;
	}

	public Boolean getRenunciaTanteo() {
		return renunciaTanteo;
	}

	public void setRenunciaTanteo(Boolean renunciaTanteo) {
		this.renunciaTanteo = renunciaTanteo;
	}

	public Boolean getCarencia() {
		return carencia;
	}

	public void setCarencia(Boolean carencia) {
		this.carencia = carencia;
	}

	public Boolean getBonificacion() {
		return bonificacion;
	}

	public void setBonificacion(Boolean bonificacion) {
		this.bonificacion = bonificacion;
	}

	public Boolean getGastosRepercutibles() {
		return gastosRepercutibles;
	}

	public void setGastosRepercutibles(Boolean gastosRepercutibles) {
		this.gastosRepercutibles = gastosRepercutibles;
	}

	public String getMesesCarencia() {
		return mesesCarencia;
	}

	public void setMesesCarencia(String mesesCarencia) {
		this.mesesCarencia = mesesCarencia;
	}

	public String getImporteCarencia() {
		return importeCarencia;
	}

	public void setImporteCarencia(String importeCarencia) {
		this.importeCarencia = importeCarencia;
	}

	public String getMesesBonificacion() {
		return mesesBonificacion;
	}

	public void setMesesBonificacion(String mesesBonificacion) {
		this.mesesBonificacion = mesesBonificacion;
	}

	public String getImporteBonificacion() {
		return importeBonificacion;
	}

	public void setImporteBonificacion(String importeBonificacion) {
		this.importeBonificacion = importeBonificacion;
	}

	public String getDuracionBonificacion() {
		return duracionBonificacion;
	}

	public void setDuracionBonificacion(String duracionBonificacion) {
		this.duracionBonificacion = duracionBonificacion;
	}

	public String getRepercutiblesComments() {
		return repercutiblesComments;
	}

	public void setRepercutiblesComments(String repercutiblesComments) {
		this.repercutiblesComments = repercutiblesComments;
	}

	public String getEntidadComments() {
		return entidadComments;
	}

	public void setEntidadComments(String entidadComments) {
		this.entidadComments = entidadComments;
	}

	public Boolean getCheckFijo() {
		return checkFijo;
	}

	public void setCheckFijo(Boolean checkFijo) {
		this.checkFijo = checkFijo;
	}

	public Date getFechaFijo() {
		return fechaFijo;
	}

	public void setFechaFijo(Date fechaFijo) {
		this.fechaFijo = fechaFijo;
	}

	public Double getIncrementoRentaFijo() {
		return incrementoRentaFijo;
	}

	public void setIncrementoRentaFijo(Double incrementoRentaFijo) {
		this.incrementoRentaFijo = incrementoRentaFijo;
	}

	public Boolean getCheckPorcentual() {
		return checkPorcentual;
	}

	public void setCheckPorcentual(Boolean checkPorcentual) {
		this.checkPorcentual = checkPorcentual;
	}

	public Boolean getCheckIPC() {
		return checkIPC;
	}

	public void setCheckIPC(Boolean checkIPC) {
		this.checkIPC = checkIPC;
	}

	public Integer getPorcentaje() {
		return porcentaje;
	}

	public void setPorcentaje(Integer porcentaje) {
		this.porcentaje = porcentaje;
	}

	public Boolean getCheckRevisionMercado() {
		return checkRevisionMercado;
	}

	public void setCheckRevisionMercado(Boolean checkRevisionMercado) {
		this.checkRevisionMercado = checkRevisionMercado;
	}

	public Date getRevisionMercadoFecha() {
		return revisionMercadoFecha;
	}

	public void setRevisionMercadoFecha(Date revisionMercadoFecha) {
		this.revisionMercadoFecha = revisionMercadoFecha;
	}

	public Integer getRevisionMercadoMeses() {
		return revisionMercadoMeses;
	}

	public void setRevisionMercadoMeses(Integer revisionMercadoMeses) {
		this.revisionMercadoMeses = revisionMercadoMeses;
	}

	public Date getFechaMinima() {
		return fechaMinima;
	}

	public void setFechaMinima(Date fechaMinima) {
		this.fechaMinima = fechaMinima;
	}

	public Boolean getInsertarHistorico() {
		return insertarHistorico;
	}

	public void setInsertarHistorico(Boolean insertarHistorico) {
		this.insertarHistorico = insertarHistorico;
	}
	
	public Double getDepositoReserva() {
		return depositoReserva;
	}

	public void setDepositoReserva(Double depositoReserva) {
		this.depositoReserva = depositoReserva;
	}

	public Boolean getTributosSobrePropiedad() {
		return tributosSobrePropiedad;
	}

	public void setTributosSobrePropiedad(Boolean tributosSobrePropiedad) {
		this.tributosSobrePropiedad = tributosSobrePropiedad;
	}

	public Boolean getNecesidadIf() {
		return necesidadIf;
	}

	public void setNecesidadIf(Boolean necesidadIf) {
		this.necesidadIf = necesidadIf;
	}

	public Boolean getFianzaExonerada() {
		return fianzaExonerada;
	}

	public void setFianzaExonerada(Boolean fianzaExonerada) {
		this.fianzaExonerada = fianzaExonerada;
	}

	public Date getFechaIngresoFianzaArrendatario() {
		return fechaIngresoFianzaArrendatario;
	}

	public void setFechaIngresoFianzaArrendatario(Date fechaIngresoFianzaArrendatario) {
		this.fechaIngresoFianzaArrendatario = fechaIngresoFianzaArrendatario;
	}

	public Boolean getDerechoCesionSubarriendo() {
		return derechoCesionSubarriendo;
	}

	public void setDerechoCesionSubarriendo(Boolean derechoCesionSubarriendo) {
		this.derechoCesionSubarriendo = derechoCesionSubarriendo;
	}

	public Boolean getVulnerabilidadDetectada() {
		return vulnerabilidadDetectada;
	}

	public void setVulnerabilidadDetectada(Boolean vulnerabilidadDetectada) {
		this.vulnerabilidadDetectada = vulnerabilidadDetectada;
	}

	public String getRegimenFianzaCCAACodigo() {
		return regimenFianzaCCAACodigo;
	}

	public void setRegimenFianzaCCAACodigo(String regimenFianzaCCAACodigo) {
		this.regimenFianzaCCAACodigo = regimenFianzaCCAACodigo;
	}

	public Boolean getCertificaciones() {
		return certificaciones;
	}

	public void setCertificaciones(Boolean certificaciones) {
		this.certificaciones = certificaciones;
	}

	public Boolean getOfrNuevasCondiciones() {
		return ofrNuevasCondiciones;
	}

	public void setOfrNuevasCondiciones(Boolean ofrNuevasCondiciones) {
		this.ofrNuevasCondiciones = ofrNuevasCondiciones;
	}

	public Boolean getFianzaContratosSubrogados() {
		return fianzaContratosSubrogados;
	}

	public void setFianzaContratosSubrogados(Boolean fianzaContratosSubrogados) {
		this.fianzaContratosSubrogados = fianzaContratosSubrogados;
	}

	public Boolean getAdecuaciones() {
		return adecuaciones;
	}

	public void setAdecuaciones(Boolean adecuaciones) {
		this.adecuaciones = adecuaciones;
	}

	public Boolean getCntSuscritoPosteridadAdj() {
		return cntSuscritoPosteridadAdj;
	}

	public void setCntSuscritoPosteridadAdj(Boolean cntSuscritoPosteridadAdj) {
		this.cntSuscritoPosteridadAdj = cntSuscritoPosteridadAdj;
	}

	public Boolean getAntiguoDeudorLocalizable() {
		return antiguoDeudorLocalizable;
	}

	public void setAntiguoDeudorLocalizable(Boolean antiguoDeudorLocalizable) {
		this.antiguoDeudorLocalizable = antiguoDeudorLocalizable;
	}

	public Boolean getEntregasCuenta() {
		return entregasCuenta;
	}

	public void setEntregasCuenta(Boolean entregasCuenta) {
		this.entregasCuenta = entregasCuenta;
	}

	public Boolean getRentasCuenta() {
		return rentasCuenta;
	}

	public void setRentasCuenta(Boolean rentasCuenta) {
		this.rentasCuenta = rentasCuenta;
	}

	public Double getImporteEntregasCuenta() {
		return importeEntregasCuenta;
	}

	public void setImporteEntregasCuenta(Double importeEntregasCuenta) {
		this.importeEntregasCuenta = importeEntregasCuenta;
	}

	public Double getObligadoCumplimiento() {
		return obligadoCumplimiento;
	}

	public void setObligadoCumplimiento(Double obligadoCumplimiento) {
		this.obligadoCumplimiento = obligadoCumplimiento;
	}

	public Date getFechaPreavisoVencimientoCnt() {
		return fechaPreavisoVencimientoCnt;
	}

	public void setFechaPreavisoVencimientoCnt(Date fechaPreavisoVencimientoCnt) {
		this.fechaPreavisoVencimientoCnt = fechaPreavisoVencimientoCnt;
	}

	public Date getFechaInicioCnt() {
		return fechaInicioCnt;
	}

	public void setFechaInicioCnt(Date fechaInicioCnt) {
		this.fechaInicioCnt = fechaInicioCnt;
	}

	public Date getFechaFinCnt() {
		return fechaFinCnt;
	}

	public void setFechaFinCnt(Date fechaFinCnt) {
		this.fechaFinCnt = fechaFinCnt;
	}

	public String getMetodoActualizacionRentaCod() {
		return metodoActualizacionRentaCod;
	}

	public void setMetodoActualizacionRentaCod(String metodoActualizacionRentaCod) {
		this.metodoActualizacionRentaCod = metodoActualizacionRentaCod;
	}

	public Boolean getCheckIGC() {
		return checkIGC;
	}

	public void setCheckIGC(Boolean checkIGC) {
		this.checkIGC = checkIGC;
	}

	public Long getPeriodicidadMeses() {
		return periodicidadMeses;
	}

	public void setPeriodicidadMeses(Long periodicidadMeses) {
		this.periodicidadMeses = periodicidadMeses;
	}

	public Date getFechaActualizacion() {
		return fechaActualizacion;
	}

	public void setFechaActualizacion(Date fechaActualizacion) {
		this.fechaActualizacion = fechaActualizacion;
	}

	public String getTipoGrupoImpuestoCod() {
		return tipoGrupoImpuestoCod;
	}

	public void setTipoGrupoImpuestoCod(String tipoGrupoImpuestoCod) {
		this.tipoGrupoImpuestoCod = tipoGrupoImpuestoCod;
	}

	public Boolean getBloqueDepositoEditable() {
		return bloqueDepositoEditable;
	}

	public void setBloqueDepositoEditable(Boolean bloqueDepositoEditable) {
		this.bloqueDepositoEditable = bloqueDepositoEditable;
	}

	public String getTipoGrupoImpuestoCodAlq() {
		return tipoGrupoImpuestoCodAlq;
	}

	public void setTipoGrupoImpuestoCodAlq(String tipoGrupoImpuestoCodAlq) {
		this.tipoGrupoImpuestoCodAlq = tipoGrupoImpuestoCodAlq;
	}	
	
	public String getTipoImpuestoCodigoAlq() {
		return tipoImpuestoCodigoAlq;
	}

	public void setTipoImpuestoCodigoAlq(String tipoImpuestoCodigoAlq) {
		this.tipoImpuestoCodigoAlq = tipoImpuestoCodigoAlq;
	}	
}
