package es.pfsgroup.plugin.rem.model;

import java.util.Date;



/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoSituacionPosesoria extends DtoTabActivo {

	private static final long serialVersionUID = 0L;

	private String numeroActivo;
	
    private String tipoTituloPosesorioCodigo;
    
    private Date fechaRevisionEstado;
	private Date fechaTomaPosesion;
	private Integer ocupado;
	private String conTituloCodigo;
	private String conTituloDescripcion;
	private Integer riesgoOcupacion;
	private Date fechaAccesoTapiado;
	private Date fechaAccesoAntiocupa;
	private Integer accesoTapiado;
	private Integer accesoAntiocupa;
	private Date fechaTitulo;
	private Date fechaVencTitulo;
	private String rentaMensual;
	private Date fechaSolDesahucio;
	private Date fechalanzamiento;
	private Date fechaLanzamientoEfectivo;
	private Integer necesarias;
	private Integer llaveHre;
	private String numJuegos;
	private String situacionJuridica;
	private Integer indicaPosesion;
	private Boolean tieneOkTecnico;
	private String tipoEstadoAlquiler;
	private Integer diasCambioPosesion;
	private Integer diasCambioTitulo;
	private Date diaCambioPosesion;
	private Date diaCambioTitulo;
	private Integer diasTapiado;
	private Date fechaRecepcionLlave;
	private Date fechaPrimerAnillado;
	private String posesionNegociada;
	private Integer tieneAlarma;
	private Date fechaInstalacionAlarma;
	private Date fechaDesinstalacionAlarma;
	private Integer tieneVigilancia;
	private Date fechaInstalacionVigilancia;
	private Date fechaDesinstalacionVigilancia;
	private Boolean perteneceActivoREAM;
	private String necesariaFuerzaPublica;
	private String estadoTecnicoCodigo;
	private String estadoTecnicoDescripcion;
	private Date fechaEstadoTecnico;
		
	public String getTipoEstadoAlquiler() {
		return tipoEstadoAlquiler;
	}
	public void setTipoEstadoAlquiler(String tipoEstadoAlquiler) {
		this.tipoEstadoAlquiler = tipoEstadoAlquiler;
	}
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}
	public String getTipoTituloPosesorioCodigo() {
		return tipoTituloPosesorioCodigo;
	}
	public void setTipoTituloPosesorioCodigo(String tipoTituloPosesorioCodigo) {
		this.tipoTituloPosesorioCodigo = tipoTituloPosesorioCodigo;
	}
	public Date getFechaRevisionEstado() {
		return fechaRevisionEstado;
	}
	public void setFechaRevisionEstado(Date fechaRevisionEstado) {
		this.fechaRevisionEstado = fechaRevisionEstado;
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
	public String getConTituloCodigo() {
		return conTituloCodigo;
	}
	public void setConTituloCodigo(String conTituloCodigo) {
		this.conTituloCodigo = conTituloCodigo;
	}
	public Integer getRiesgoOcupacion() {
		return riesgoOcupacion;
	}
	public void setRiesgoOcupacion(Integer riesgoOcupacion) {
		this.riesgoOcupacion = riesgoOcupacion;
	}
	public Date getFechaAccesoTapiado() {
		return fechaAccesoTapiado;
	}
	public void setFechaAccesoTapiado(Date fechaAccesoTapiado) {
		this.fechaAccesoTapiado = fechaAccesoTapiado;
	}
	public Date getFechaAccesoAntiocupa() {
		return fechaAccesoAntiocupa;
	}
	public void setFechaAccesoAntiocupa(Date fechaAccesoAntiocupa) {
		this.fechaAccesoAntiocupa = fechaAccesoAntiocupa;
	}
	public Integer getAccesoTapiado() {
		return accesoTapiado;
	}
	public void setAccesoTapiado(Integer accesoTapiado) {
		this.accesoTapiado = accesoTapiado;
	}
	public Integer getAccesoAntiocupa() {
		return accesoAntiocupa;
	}
	public void setAccesoAntiocupa(Integer accesoAntiocupa) {
		this.accesoAntiocupa = accesoAntiocupa;
	}
	public Date getFechaTitulo() {
		return fechaTitulo;
	}
	public void setFechaTitulo(Date fechaTitulo) {
		this.fechaTitulo = fechaTitulo;
	}
	public Date getFechaVencTitulo() {
		return fechaVencTitulo;
	}
	public void setFechaVencTitulo(Date fechaVencTitulo) {
		this.fechaVencTitulo = fechaVencTitulo;
	}
	public String getRentaMensual() {
		return rentaMensual;
	}
	public void setRentaMensual(String rentaMensual) {
		this.rentaMensual = rentaMensual;
	}
	public Date getFechaSolDesahucio() {
		return fechaSolDesahucio;
	}
	public void setFechaSolDesahucio(Date fechaSolDesahucio) {
		this.fechaSolDesahucio = fechaSolDesahucio;
	}
	public Date getFechalanzamiento() {
		return fechalanzamiento;
	}
	public void setFechalanzamiento(Date fechalanzamiento) {
		this.fechalanzamiento = fechalanzamiento;
	}
	public Date getFechaLanzamientoEfectivo() {
		return fechaLanzamientoEfectivo;
	}
	public void setFechaLanzamientoEfectivo(Date fechaLanzamientoEfectivo) {
		this.fechaLanzamientoEfectivo = fechaLanzamientoEfectivo;
	}
	public Integer getNecesarias() {
		return necesarias;
	}
	public void setNecesarias(Integer necesarias) {
		this.necesarias = necesarias;
	}
	public Integer getLlaveHre() {
		return llaveHre;
	}
	public void setLlaveHre(Integer llaveHre) {
		this.llaveHre = llaveHre;
	}
	public Date getFechaRecepcionLlave() {
		return fechaRecepcionLlave;
	}
	public void setFechaRecepcionLlave(Date fechaRecepcionLlave) {
		this.fechaRecepcionLlave = fechaRecepcionLlave;
	}
	public String getNumJuegos() {
		return numJuegos;
	}
	public void setNumJuegos(String numJuegos) {
		this.numJuegos = numJuegos;
	}
	public String getSituacionJuridica() {
		return situacionJuridica;
	}
	public void setSituacionJuridica(String situacionJuridica) {
		this.situacionJuridica = situacionJuridica;
	}
	public Integer getIndicaPosesion() {
		return indicaPosesion;
	}
	public void setIndicaPosesion(Integer indicaPosesion) {
		this.indicaPosesion = indicaPosesion;
	}
	public Boolean getTieneOkTecnico() {
		return tieneOkTecnico;
	}
	public void setTieneOkTecnico(Boolean tieneOkTecnico) {
		this.tieneOkTecnico = tieneOkTecnico;
	}
	public Integer getDiasCambioTitulo() {
		return diasCambioTitulo;
	}
	public void setDiasCambioTitulo(Integer diasCambioTitulo) {
		this.diasCambioTitulo = diasCambioTitulo;
	}
	public Integer getDiasCambioPosesion() {
		return diasCambioPosesion;
	}
	public void setDiasCambioPosesion(Integer diasCambioPosesion) {
		this.diasCambioPosesion = diasCambioPosesion;
	}
	public Date getDiaCambioPosesion() {
		return diaCambioPosesion;
	}
	public void setDiaCambioPosesion(Date diaCambioPosesion) {
		this.diaCambioPosesion = diaCambioPosesion;
	}
	public Date getDiaCambioTitulo() {
		return diaCambioTitulo;
	}
	public void setDiaCambioTitulo(Date diaCambioTitulo) {
		this.diaCambioTitulo = diaCambioTitulo;
	}
	public Integer getDiasTapiado() {
		return diasTapiado;
	}
	public void setDiasTapiado(Integer diasTapiado) {
		this.diasTapiado = diasTapiado;
	}
	public Date getFechaPrimerAnillado() {
		return fechaPrimerAnillado;
	}
	public void setFechaPrimerAnillado(Date fechaPrimerAnillado) {
		this.fechaPrimerAnillado = fechaPrimerAnillado;
	}
	public String getPosesionNegociada() {
		return posesionNegociada;
	}
	public void setPosesionNegociada(String posesionNegociada) {
		this.posesionNegociada = posesionNegociada;
	}
	public Integer getTieneAlarma() {
		return tieneAlarma;
	}
	public void setTieneAlarma(Integer tieneAlarma) {
		this.tieneAlarma = tieneAlarma;
	}
	public Date getFechaInstalacionAlarma() {
		return fechaInstalacionAlarma;
	}
	public void setFechaInstalacionAlarma(Date fechaInstalacionAlarma) {
		this.fechaInstalacionAlarma = fechaInstalacionAlarma;
	}
	public Date getFechaDesinstalacionAlarma() {
		return fechaDesinstalacionAlarma;
	}
	public void setFechaDesinstalacionAlarma(Date fechaDesinstalacionAlarma) {
		this.fechaDesinstalacionAlarma = fechaDesinstalacionAlarma;
	}
	public Integer getTieneVigilancia() {
		return tieneVigilancia;
	}
	public void setTieneVigilancia(Integer tieneVigilancia) {
		this.tieneVigilancia = tieneVigilancia;
	}
	public Date getFechaInstalacionVigilancia() {
		return fechaInstalacionVigilancia;
	}
	public void setFechaInstalacionVigilancia(Date fechaInstalacionVigilancia) {
		this.fechaInstalacionVigilancia = fechaInstalacionVigilancia;
	}
	public Date getFechaDesinstalacionVigilancia() {
		return fechaDesinstalacionVigilancia;
	}
	public void setFechaDesinstalacionVigilancia(Date fechaDesinstalacionVigilancia) {
		this.fechaDesinstalacionVigilancia = fechaDesinstalacionVigilancia;
	}
	public Boolean getPerteneceActivoREAM() {
		return perteneceActivoREAM;
	}
	public void setPerteneceActivoREAM(Boolean perteneceActivoREAM) {
		this.perteneceActivoREAM = perteneceActivoREAM;
	}
	
	public String getConTituloDescripcion() {
		return conTituloDescripcion;
	}
	public void setConTituloDescripcion(String conTituloDescripcion) {
		this.conTituloDescripcion = conTituloDescripcion;
	}
	public String getNecesariaFuerzaPublica() {
		return necesariaFuerzaPublica;
	}
	public void setNecesariaFuerzaPublica(String necesariaFuerzaPublica) {
		this.necesariaFuerzaPublica = necesariaFuerzaPublica;
	}
	public String getEstadoTecnicoCodigo() {
		return estadoTecnicoCodigo;
	}
	public void setEstadoTecnicoCodigo(String estadoTecnicoCodigo) {
		this.estadoTecnicoCodigo = estadoTecnicoCodigo;
	}
	public String getEstadoTecnicoDescripcion() {
		return estadoTecnicoDescripcion;
	}
	public void setEstadoTecnicoDescripcion(String estadoTecnicoDescripcion) {
		this.estadoTecnicoDescripcion = estadoTecnicoDescripcion;
	}
	public Date getFechaEstadoTecnico() {
		return fechaEstadoTecnico;
	}
	public void setFechaEstadoTecnico(Date fechaEstadoTecnico) {
		this.fechaEstadoTecnico = fechaEstadoTecnico;
	}
	
}