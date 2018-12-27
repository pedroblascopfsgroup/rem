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
	private String conTitulo;
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
	private Date fechaRecepcionLlave;
	private String numJuegos;
	private String situacionJuridica;
	private Integer indicaPosesion;
	private Boolean tieneOkTecnico;
		
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
	public String getConTitulo() {
		return conTitulo;
	}
	public void setConTitulo(String conTitulo) {
		this.conTitulo = conTitulo;
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

	
}