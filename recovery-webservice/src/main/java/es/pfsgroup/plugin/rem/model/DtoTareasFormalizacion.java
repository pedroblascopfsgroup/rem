package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto que gestiona la informacion de las resoluciones del expediente.
 *  
 * @author Lara
 *
 */
public class DtoTareasFormalizacion {
    /**
	 * 
	 */
    private static final long serialVersionUID = 1L;
    

	private Boolean llamadaRealizada;
	private Boolean burofaxEnviado;
	private Date fechaLlamadaRealizada;
	private Date fechaBurofaxEnviado;
	

	private Boolean fianzaExonerada;
	private	Date fechaAgendacion;
	private Date fechaReagendarIngreso;
	private	Double importe;
	private	String ibanDevolucion;
	
	private String tipoAdenda;
	private Boolean clienteAcepta;
	
	private Boolean adendaFirmada;
	private String motivo;

	private Date fechaFirma;
	private Date fechaInicioAlquiler;
	private Date fechaFinAlquiler;

	private String decisionComite;
	
	private Boolean comboResultado;
	private String tipoActivoRescision;
	
	private String motivoExoneracionFianza;
		

		

	
	
	public Boolean getLlamadaRealizada() {
		return llamadaRealizada;
	}
	public void setLlamadaRealizada(Boolean llamadaRealizada) {
		this.llamadaRealizada = llamadaRealizada;
	}
	public Boolean getBurofaxEnviado() {
		return burofaxEnviado;
	}
	public void setBurofaxEnviado(Boolean burofaxEnviado) {
		this.burofaxEnviado = burofaxEnviado;
	}
	public Date getFechaLlamadaRealizada() {
		return fechaLlamadaRealizada;
	}
	public void setFechaLlamadaRealizada(Date fechaLlamadaRealizada) {
		this.fechaLlamadaRealizada = fechaLlamadaRealizada;
	}
	public Date getFechaBurofaxEnviado() {
		return fechaBurofaxEnviado;
	}
	public void setFechaBurofaxEnviado(Date fechaBurofaxEnviado) {
		this.fechaBurofaxEnviado = fechaBurofaxEnviado;
	}
	
	
	public Boolean getFianzaExonerada() {
		return fianzaExonerada;
	}
	public void setFianzaExonerada(Boolean fianzaExonerada) {
		this.fianzaExonerada = fianzaExonerada;
	}
	public Date getFechaAgendacion() {
		return fechaAgendacion;
	}
	public void setFechaAgendacion(Date fechaAgendacion) {
		this.fechaAgendacion = fechaAgendacion;
	}
	public Date getFechaReagendarIngreso() {
		return fechaReagendarIngreso;
	}
	public void setFechaReagendarIngreso(Date fechaReagendarIngreso) {
		this.fechaReagendarIngreso = fechaReagendarIngreso;
	}
	public Double getImporte() {
		return importe;
	}
	public void setImporte(Double importe) {
		this.importe = importe;
	}
	public String getIbanDevolucion() {
		return ibanDevolucion;
	}
	public void setIbanDevolucion(String ibanDevolucion) {
		this.ibanDevolucion = ibanDevolucion;
	}
	
	
	public String getTipoAdenda() {
		return tipoAdenda;
	}
	public void setTipoAdenda(String tipoAdenda) {
		this.tipoAdenda = tipoAdenda;
	}
	public Boolean getClienteAcepta() {
		return clienteAcepta;
	}
	public void setClienteAcepta(Boolean clienteAcepta) {
		this.clienteAcepta = clienteAcepta;
	}
	public Boolean getAdendaFirmada() {
		return adendaFirmada;
	}
	public void setAdendaFirmada(Boolean adendaFirmada) {
		this.adendaFirmada = adendaFirmada;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public Date getFechaFirma() {
		return fechaFirma;
	}
	public void setFechaFirma(Date fechaFirma) {
		this.fechaFirma = fechaFirma;
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
	public String getDecisionComite() {
		return decisionComite;
	}
	public void setDecisionComite(String decisionComite) {
		this.decisionComite = decisionComite;
	}
	public Boolean getComboResultado() {
		return comboResultado;
	}
	public void setComboResultado(Boolean comboResultado) {
		this.comboResultado = comboResultado;
	}
	public String getTipoActivoRescision() {
		return tipoActivoRescision;
	}
	public void setTipoActivoRescision(String tipoActivoRescision) {
		this.tipoActivoRescision = tipoActivoRescision;
	}
	public String getMotivoExoneracionFianza() {
		return motivoExoneracionFianza;
	}
	public void setMotivoExoneracionFianza(String motivoExoneracionFianza) {
		this.motivoExoneracionFianza = motivoExoneracionFianza;
	}
	
}