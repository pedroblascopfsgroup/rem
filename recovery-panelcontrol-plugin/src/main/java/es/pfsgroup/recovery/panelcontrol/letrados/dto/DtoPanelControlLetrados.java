package es.pfsgroup.recovery.panelcontrol.letrados.dto;

import es.capgemini.devon.dto.WebDto;

public class DtoPanelControlLetrados extends WebDto{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4941793190245334384L;
	
	private Long id;
	private String nivel;
	private String cod;
	private String userName;
	private Long totalExpedientes;
	private float importe;
	private Float importeVencido;
	private Float importePendiente;
	private Long vencidasMas6Meses;
	private Long vencidas6Meses;
	private Long vencidas5Meses;
	private Long vencidas4Meses;
	private Long vencidas3Meses;
	private Long vencidas2Meses;
	private Long vencidas1Mes;
	private Long vencidasSemana;
	private Long tareasVencidas;
	private Long tareasPendientesHoy;
	private Long tareasPendientesSemana;
	private Long tareasPendientesMes;
	private Long tareasPendientes2Meses;
	private Long tareasPendientes3Meses;
	private Long tareasPendientes4Meses;
	private Long tareasPendientes5Meses;
	private Long tareasPendientesMas6Meses;
	private Long tareasPendientesMasMes;
	private Long tareasPendientesMasAnyo;
	private Long tareasFinalizadasAyer;
	private Long tareasFinalizadasSemana;
	private Long tareasFinalizadasMes;
	private Long tareasFinalizadasAnyo;
	private Long tareasFinalizadas;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
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
	public void setTotalExpedientes(Long totalExpedientes) {
		this.totalExpedientes = totalExpedientes;
	}
	public Long getTotalExpedientes() {
		return totalExpedientes;
	}
	public void setImporte(float importe) {
		this.importe = importe;
	}
	public float getImporte() {
		return importe;
	}
	public void setTareasVencidas(Long tareasVencidas) {
		this.tareasVencidas = tareasVencidas;
	}
	public Long getTareasVencidas() {
		return tareasVencidas;
	}
	public Long getTareasPendientesHoy() {
		return tareasPendientesHoy;
	}
	public void setTareasPendientesHoy(Long tareasPendientesHoy) {
		this.tareasPendientesHoy = tareasPendientesHoy;
	}
	public Long getTareasPendientesSemana() {
		return tareasPendientesSemana;
	}
	public void setTareasPendientesSemana(Long tareasPendientesSemana) {
		this.tareasPendientesSemana = tareasPendientesSemana;
	}
	public Long getTareasPendientesMes() {
		return tareasPendientesMes;
	}
	public void setTareasPendientesMes(Long tareasPendientesMes) {
		this.tareasPendientesMes = tareasPendientesMes;
	}
	public Long getTareasPendientesMasMes() {
		return tareasPendientesMasMes;
	}
	public void setTareasPendientesMasMes(Long tareasPendientesMasMes) {
		this.tareasPendientesMasMes = tareasPendientesMasMes;
	}
	public Long getTareasPendientesMasAnyo() {
		return tareasPendientesMasAnyo;
	}
	public void setTareasPendientesMasAnyo(Long tareasPendientesMasAnyo) {
		this.tareasPendientesMasAnyo = tareasPendientesMasAnyo;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public Long getTareasFinalizadasAyer() {
		return tareasFinalizadasAyer;
	}
	public void setTareasFinalizadasAyer(Long tareasFinalizadasAyer) {
		this.tareasFinalizadasAyer = tareasFinalizadasAyer;
	}
	public Long getTareasFinalizadasSemana() {
		return tareasFinalizadasSemana;
	}
	public void setTareasFinalizadasSemana(Long tareasFinalizadasSemana) {
		this.tareasFinalizadasSemana = tareasFinalizadasSemana;
	}
	public Long getTareasFinalizadasMes() {
		return tareasFinalizadasMes;
	}
	public void setTareasFinalizadasMes(Long tareasFinalizadasMes) {
		this.tareasFinalizadasMes = tareasFinalizadasMes;
	}
	public Long getTareasFinalizadasAnyo() {
		return tareasFinalizadasAnyo;
	}
	public void setTareasFinalizadasAnyo(Long tareasFinalizadasAnyo) {
		this.tareasFinalizadasAnyo = tareasFinalizadasAnyo;
	}
	public Long getTareasFinalizadas() {
		return tareasFinalizadas;
	}
	public void setTareasFinalizadas(Long tareasFinalizadas) {
		this.tareasFinalizadas = tareasFinalizadas;
	}
	public Long getVencidasMas6Meses() {
		return vencidasMas6Meses;
	}
	public void setVencidasMas6Meses(Long vencidasMas6Meses) {
		this.vencidasMas6Meses = vencidasMas6Meses;
	}
	public Long getVencidas5Meses() {
		return vencidas5Meses;
	}
	public void setVencidas5Meses(Long vencidas5Meses) {
		this.vencidas5Meses = vencidas5Meses;
	}
	public Long getVencidas4Meses() {
		return vencidas4Meses;
	}
	public void setVencidas4Meses(Long vencidas4Meses) {
		this.vencidas4Meses = vencidas4Meses;
	}
	public Long getVencidas3Meses() {
		return vencidas3Meses;
	}
	public void setVencidas3Meses(Long vencidas3Meses) {
		this.vencidas3Meses = vencidas3Meses;
	}
	public Long getVencidas2Meses() {
		return vencidas2Meses;
	}
	public void setVencidas2Meses(Long vencidas2Meses) {
		this.vencidas2Meses = vencidas2Meses;
	}
	public Long getVencidas1Mes() {
		return vencidas1Mes;
	}
	public void setVencidas1Mes(Long vencidas1Mes) {
		this.vencidas1Mes = vencidas1Mes;
	}
	public Long getVencidasSemana() {
		return vencidasSemana;
	}
	public void setVencidasSemana(Long vencidasSemana) {
		this.vencidasSemana = vencidasSemana;
	}
	public Long getTareasPendientes2Meses() {
		return tareasPendientes2Meses;
	}
	public void setTareasPendientes2Meses(Long tareasPendientes2Meses) {
		this.tareasPendientes2Meses = tareasPendientes2Meses;
	}
	public Long getTareasPendientes3Meses() {
		return tareasPendientes3Meses;
	}
	public void setTareasPendientes3Meses(Long tareasPendientes3Meses) {
		this.tareasPendientes3Meses = tareasPendientes3Meses;
	}
	public Long getTareasPendientes4Meses() {
		return tareasPendientes4Meses;
	}
	public void setTareasPendientes4Meses(Long tareasPendientes4Meses) {
		this.tareasPendientes4Meses = tareasPendientes4Meses;
	}
	public Long getTareasPendientes5Meses() {
		return tareasPendientes5Meses;
	}
	public void setTareasPendientes5Meses(Long tareasPendientes5Meses) {
		this.tareasPendientes5Meses = tareasPendientes5Meses;
	}
	public Long getTareasPendientesMas6Meses() {
		return tareasPendientesMas6Meses;
	}
	public void setTareasPendientesMas6Meses(Long tareasPendientesMas6Meses) {
		this.tareasPendientesMas6Meses = tareasPendientesMas6Meses;
	}
	public void setVencidas6Meses(Long vencidas6Meses) {
		this.vencidas6Meses = vencidas6Meses;
	}
	public Long getVencidas6Meses() {
		return vencidas6Meses;
	}
	public void setImporteVencido(Float importeVencido) {
		this.importeVencido = importeVencido;
	}
	public Float getImporteVencido() {
		return importeVencido;
	}
	public void setImportePendiente(Float importePendiente) {
		this.importePendiente = importePendiente;
	}
	public Float getImportePendiente() {
		return importePendiente;
	}
	
	
}
