package es.pfsgroup.recovery.panelcontrol.letrados.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoPanelListado extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4941793190245334384L;
	
	private String id;
	private String nivel;
	private String cod;
	private String userName;
	private String totalExpedientes;
	private String importe;
	private String tareasVencidas;
	private String tareasPendientesHoy;
	private String tareasPendientesSemana;
	private String tareasPendientesMes;
	private String tareasPendientesMasMes;
	private String tareasPendientesMasAnyo;
	private String tareasFinalizadasAyer;
	private String tareasFinalizadasSemana;
	private String tareasFinalizadasMes;
	private String tareasFinalizadasAnyo;
	private String tareasFinalizadas;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNivel() {
		return nivel;
	}
	public void setNivel(String nivel) {
		this.nivel = nivel;
	}
	public String getCod() {
		return cod;
	}
	public void setCod(String cod) {
		this.cod = cod;
	}
	public void setTotalExpedientes(String totalExpedientes) {
		this.totalExpedientes = totalExpedientes;
	}
	public String getTotalExpedientes() {
		return totalExpedientes;
	}
	public void setImporte(String importe) {
		this.importe = importe;
	}
	public String getImporte() {
		return importe;
	}
	public void setTareasVencidas(String tareasVencidas) {
		this.tareasVencidas = tareasVencidas;
	}
	public String getTareasVencidas() {
		return tareasVencidas;
	}
	public String getTareasPendientesHoy() {
		return tareasPendientesHoy;
	}
	public void setTareasPendientesHoy(String tareasPendientesHoy) {
		this.tareasPendientesHoy = tareasPendientesHoy;
	}
	public String getTareasPendientesSemana() {
		return tareasPendientesSemana;
	}
	public void setTareasPendientesSemana(String tareasPendientesSemana) {
		this.tareasPendientesSemana = tareasPendientesSemana;
	}
	public String getTareasPendientesMes() {
		return tareasPendientesMes;
	}
	public void setTareasPendientesMes(String tareasPendientesMes) {
		this.tareasPendientesMes = tareasPendientesMes;
	}
	public String getTareasPendientesMasMes() {
		return tareasPendientesMasMes;
	}
	public void setTareasPendientesMasMes(String tareasPendientesMasMes) {
		this.tareasPendientesMasMes = tareasPendientesMasMes;
	}
	public String getTareasPendientesMasAnyo() {
		return tareasPendientesMasAnyo;
	}
	public void setTareasPendientesMasAnyo(String tareasPendientesMasAnyo) {
		this.tareasPendientesMasAnyo = tareasPendientesMasAnyo;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getTareasFinalizadasAyer() {
		return tareasFinalizadasAyer;
	}
	public void setTareasFinalizadasAyer(String tareasFinalizadasAyer) {
		this.tareasFinalizadasAyer = tareasFinalizadasAyer;
	}
	public String getTareasFinalizadasSemana() {
		return tareasFinalizadasSemana;
	}
	public void setTareasFinalizadasSemana(String tareasFinalizadasSemana) {
		this.tareasFinalizadasSemana = tareasFinalizadasSemana;
	}
	public String getTareasFinalizadasMes() {
		return tareasFinalizadasMes;
	}
	public void setTareasFinalizadasMes(String tareasFinalizadasMes) {
		this.tareasFinalizadasMes = tareasFinalizadasMes;
	}
	public String getTareasFinalizadasAnyo() {
		return tareasFinalizadasAnyo;
	}
	public void setTareasFinalizadasAnyo(String tareasFinalizadasAnyo) {
		this.tareasFinalizadasAnyo = tareasFinalizadasAnyo;
	}
	public String getTareasFinalizadas() {
		return tareasFinalizadas;
	}
	public void setTareasFinalizadas(String tareasFinalizadas) {
		this.tareasFinalizadas = tareasFinalizadas;
	}
	
}
