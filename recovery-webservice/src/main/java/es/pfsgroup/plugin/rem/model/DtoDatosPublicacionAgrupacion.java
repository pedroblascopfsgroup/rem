package es.pfsgroup.plugin.rem.model;

public class DtoDatosPublicacionAgrupacion extends DtoDatosPublicacionActivo {
	
	private static final long serialVersionUID = -3202851556168833024L;

	public DtoDatosPublicacionAgrupacion(DtoDatosPublicacionActivo aux) {
		this.setIdActivo(aux.getIdActivo());
		this.setEstadoPublicacionVenta(aux.getEstadoPublicacionVenta());
		this.setEstadoPublicacionAlquiler(aux.getEstadoPublicacionAlquiler());
		this.setPrecioWebVenta(aux.getPrecioWebVenta());
		this.setPrecioWebAlquiler(aux.getPrecioWebAlquiler());
		this.setAdecuacionAlquilerCodigo(aux.getAdecuacionAlquilerCodigo());
		this.setTotalDiasPublicadoVenta(aux.getTotalDiasPublicadoVenta());
		this.setTotalDiasPublicadoAlquiler(aux.getTotalDiasPublicadoAlquiler());
		this.setPublicarVenta(aux.getPublicarVenta());
		this.setOcultarVenta(aux.getOcultarVenta());
		this.setPublicarSinPrecioVenta(aux.getPublicarSinPrecioVenta());
		this.setNoMostrarPrecioVenta(aux.getNoMostrarPrecioVenta());
		this.setMotivoOcultacionVentaCodigo(aux.getMotivoOcultacionVentaCodigo());
		this.setMotivoOcultacionManualVenta(aux.getMotivoOcultacionManualVenta());
		this.setPublicarAlquiler(aux.getPublicarAlquiler());
		this.setOcultarAlquiler(aux.getOcultarAlquiler());
		this.setPublicarSinPrecioAlquiler(aux.getPublicarSinPrecioAlquiler());
		this.setNoMostrarPrecioAlquiler(aux.getNoMostrarPrecioAlquiler());
		this.setMotivoOcultacionAlquilerCodigo(aux.getMotivoOcultacionAlquilerCodigo());
		this.setMotivoOcultacionManualAlquiler(aux.getMotivoOcultacionManualAlquiler());
		this.setDeshabilitarCheckPublicarVenta(aux.getDeshabilitarCheckPublicarVenta());
		this.setDeshabilitarCheckOcultarVenta(aux.getDeshabilitarCheckOcultarVenta());
		this.setDeshabilitarCheckPublicarSinPrecioVenta(aux.getDeshabilitarCheckPublicarSinPrecioVenta());
		this.setDeshabilitarCheckNoMostrarPrecioVenta(aux.getDeshabilitarCheckNoMostrarPrecioVenta());
		this.setDeshabilitarCheckPublicarAlquiler(aux.getDeshabilitarCheckPublicarAlquiler());
		this.setDeshabilitarCheckOcultarAlquiler(aux.getDeshabilitarCheckOcultarAlquiler());
		this.setDeshabilitarCheckPublicarSinPrecioAlquiler(aux.getDeshabilitarCheckPublicarSinPrecioAlquiler());
		this.setDeshabilitarCheckNoMostrarPrecioAlquiler(aux.getDeshabilitarCheckNoMostrarPrecioAlquiler());
		this.setFechaInicioEstadoVenta(aux.getFechaInicioEstadoVenta());
		this.setFechaInicioEstadoAlquiler(aux.getFechaInicioEstadoAlquiler());
		this.setTipoPublicacionVentaCodigo(aux.getTipoPublicacionVentaCodigo());
		this.setTipoPublicacionAlquilerCodigo(aux.getTipoPublicacionAlquilerCodigo());
		this.setTipoPublicacionVentaDescripcion(aux.getTipoPublicacionVentaDescripcion());
		this.setTipoPublicacionAlquilerDescripcion(aux.getTipoPublicacionAlquilerDescripcion());
		this.setEleccionUsuarioTipoPublicacionAlquiler(aux.getEleccionUsuarioTipoPublicacionAlquiler());
	}
	
	private Long id;
	
	private Boolean incluidoEnPerimetro;
	private Long idActivoPrincipal;
	private String claseActivoCodigo;
	private String codigoEstadoPublicacionVenta;
	private String codigoEstadoPublicacionAlquiler;
	
	//Condicionantes
	private Boolean ruina;
	private Boolean pendienteInscripcion;
	private Boolean obraNuevaSinDeclarar;
	private Boolean sinTomaPosesionInicial;
	private Boolean proindiviso;
	private Boolean obraNuevaEnConstruccion;
	private Boolean ocupadoConTitulo;
	private Boolean tapiado;
	private String otro;
	private Boolean portalesExternos;
	private Boolean ocupadoSinTitulo;
	private Boolean divHorizontalNoInscrita;
	private Boolean isCondicionado;
	private String estadoCondicionadoCodigo;
	private Boolean sinInformeAprobado;
	private Boolean vandalizado;
	private Boolean conCargas;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Boolean getIncluidoEnPerimetro() {
		return incluidoEnPerimetro;
	}

	public void setIncluidoEnPerimetro(Boolean incluidoEnPerimetro) {
		this.incluidoEnPerimetro = incluidoEnPerimetro;
	}

	public Long getIdActivoPrincipal() {
		return idActivoPrincipal;
	}

	public void setIdActivoPrincipal(Long idActivoPrincipal) {
		this.idActivoPrincipal = idActivoPrincipal;
	}

	public String getClaseActivoCodigo() {
		return claseActivoCodigo;
	}

	public void setClaseActivoCodigo(String claseActivoCodigo) {
		this.claseActivoCodigo = claseActivoCodigo;
	}

	public Boolean getRuina() {
		return ruina;
	}

	public void setRuina(Boolean ruina) {
		this.ruina = ruina;
	}

	public Boolean getPendienteInscripcion() {
		return pendienteInscripcion;
	}

	public void setPendienteInscripcion(Boolean pendienteInscripcion) {
		this.pendienteInscripcion = pendienteInscripcion;
	}

	public Boolean getObraNuevaSinDeclarar() {
		return obraNuevaSinDeclarar;
	}

	public void setObraNuevaSinDeclarar(Boolean obraNuevaSinDeclarar) {
		this.obraNuevaSinDeclarar = obraNuevaSinDeclarar;
	}

	public Boolean getSinTomaPosesionInicial() {
		return sinTomaPosesionInicial;
	}

	public void setSinTomaPosesionInicial(Boolean sinTomaPosesionInicial) {
		this.sinTomaPosesionInicial = sinTomaPosesionInicial;
	}

	public Boolean getProindiviso() {
		return proindiviso;
	}

	public void setProindiviso(Boolean proindiviso) {
		this.proindiviso = proindiviso;
	}

	public Boolean getObraNuevaEnConstruccion() {
		return obraNuevaEnConstruccion;
	}

	public void setObraNuevaEnConstruccion(Boolean obraNuevaEnConstruccion) {
		this.obraNuevaEnConstruccion = obraNuevaEnConstruccion;
	}

	public Boolean getOcupadoConTitulo() {
		return ocupadoConTitulo;
	}

	public void setOcupadoConTitulo(Boolean ocupadoConTitulo) {
		this.ocupadoConTitulo = ocupadoConTitulo;
	}

	public Boolean getTapiado() {
		return tapiado;
	}

	public void setTapiado(Boolean tapiado) {
		this.tapiado = tapiado;
	}

	public String getOtro() {
		return otro;
	}

	public void setOtro(String otro) {
		this.otro = otro;
	}

	public Boolean getPortalesExternos() {
		return portalesExternos;
	}

	public void setPortalesExternos(Boolean portalesExternos) {
		this.portalesExternos = portalesExternos;
	}

	public Boolean getOcupadoSinTitulo() {
		return ocupadoSinTitulo;
	}

	public void setOcupadoSinTitulo(Boolean ocupadoSinTitulo) {
		this.ocupadoSinTitulo = ocupadoSinTitulo;
	}

	public Boolean getDivHorizontalNoInscrita() {
		return divHorizontalNoInscrita;
	}

	public void setDivHorizontalNoInscrita(Boolean divHorizontalNoInscrita) {
		this.divHorizontalNoInscrita = divHorizontalNoInscrita;
	}

	public Boolean getIsCondicionado() {
		return isCondicionado;
	}

	public void setIsCondicionado(Boolean isCondicionado) {
		this.isCondicionado = isCondicionado;
	}

	public String getEstadoCondicionadoCodigo() {
		return estadoCondicionadoCodigo;
	}

	public void setEstadoCondicionadoCodigo(String estadoCondicionadoCodigo) {
		this.estadoCondicionadoCodigo = estadoCondicionadoCodigo;
	}

	public Boolean getSinInformeAprobado() {
		return sinInformeAprobado;
	}

	public void setSinInformeAprobado(Boolean sinInformeAprobado) {
		this.sinInformeAprobado = sinInformeAprobado;
	}

	public Boolean getVandalizado() {
		return vandalizado;
	}

	public void setVandalizado(Boolean vandalizado) {
		this.vandalizado = vandalizado;
	}

	public Boolean getConCargas() {
		return conCargas;
	}

	public void setConCargas(Boolean conCargas) {
		this.conCargas = conCargas;
	}

	public String getCodigoEstadoPublicacionVenta() {
		return codigoEstadoPublicacionVenta;
	}

	public void setCodigoEstadoPublicacionVenta(String codigoEstadoPublicacionVenta) {
		this.codigoEstadoPublicacionVenta = codigoEstadoPublicacionVenta;
	}

	public String getCodigoEstadoPublicacionAlquiler() {
		return codigoEstadoPublicacionAlquiler;
	}

	public void setCodigoEstadoPublicacionAlquiler(String codigoEstadoPublicacionAlquiler) {
		this.codigoEstadoPublicacionAlquiler = codigoEstadoPublicacionAlquiler;
	}
}
