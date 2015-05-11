package es.pfsgroup.recovery.panelcontrol.judicial.dto;

import es.capgemini.devon.dto.WebDto;

/***
 * 	Dto usado para los datos del grid del panel de control
 * 
 * **/
public class DtoPanelControl  extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -672391584508980130L;
	
	private Long id;
	private String nivel;
	private String cod;
	private String ofiCodigo;
	private Long clientes;
	private Long contratosTotal;
	private Long contratosIrregulares;
	private Double saldoVencido;
	private Double saldoNoVencido;
	private Double saldoNoVencidoDanyado;
	
	private Long tareasPendientesVencidas;
	private Long tareasPendientesHoy;
	private Long tareasPendientesSemana;
	private Long tareasPendientesMes;

	public DtoPanelControl(){super();};
	
	public DtoPanelControl(Long id, String nivel, Long clientes, Long contratosTotal,
			Long contratosIrregulares, Double saldoVencido,
			Double saldoNoVencido) {
		super();
		this.id = id;
		this.nivel = nivel;
		this.clientes = clientes;
		this.contratosTotal = contratosTotal;
		this.contratosIrregulares = contratosIrregulares;
		this.saldoVencido = saldoVencido;
		this.saldoNoVencido = saldoNoVencido;
		
	}
	
	public DtoPanelControl(Long id,String nivel, Long clientes, Long contratosTotal,
			Long contratosIrregulares, Double saldoVencido,
			Double saldoNoVencido, Double saldoNoVencidoDanyado,
			Long tareasPendientesVencidas, Long tareasPendientesHoy,
			Long tareasPendientesSemana, Long tareasPendientesMes) {
		super();
		this.id = id;
		this.nivel = nivel;
		this.clientes = clientes;
		this.contratosTotal = contratosTotal;
		this.contratosIrregulares = contratosIrregulares;
		this.saldoVencido = saldoVencido;
		this.saldoNoVencido = saldoNoVencido;
		this.saldoNoVencidoDanyado = saldoNoVencidoDanyado;
		this.tareasPendientesVencidas = tareasPendientesVencidas;
		this.tareasPendientesHoy = tareasPendientesHoy;
		this.tareasPendientesSemana = tareasPendientesSemana;
		this.tareasPendientesMes = tareasPendientesMes;
	}
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getClientes() {
		return clientes;
	}
	public void setClientes(Long clientes) {
		this.clientes = clientes;
	}
	public Long getContratosTotal() {
		return contratosTotal;
	}
	public void setContratosTotal(Long contratosTotal) {
		this.contratosTotal = contratosTotal;
	}
	public Long getContratosIrregulares() {
		return contratosIrregulares;
	}
	public void setContratosIrregulares(Long contratosIrregulares) {
		this.contratosIrregulares = contratosIrregulares;
	}
	public Double getSaldoVencido() {
		return saldoVencido;
	}
	public void setSaldoVencido(Double saldoVencido) {
		this.saldoVencido = saldoVencido;
	}
	public Double getSaldoNoVencido() {
		return saldoNoVencido;
	}
	public void setSaldoNoVencido(Double saldoNoVencido) {
		this.saldoNoVencido = saldoNoVencido;
	}
	public Long getTareasPendientesVencidas() {
		return tareasPendientesVencidas;
	}
	public void setTareasPendientesVencidas(Long tareasPendientesVencidas) {
		this.tareasPendientesVencidas = tareasPendientesVencidas;
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
	public Double getSaldoNoVencidoDanyado() {
		return saldoNoVencidoDanyado;
	}
	public void setSaldoNoVencidoDanyado(Double saldoNoVencidoDanyado) {
		this.saldoNoVencidoDanyado = saldoNoVencidoDanyado;
	}

	public void setNivel(String nivel) {
		this.nivel = nivel;
	}

	public String getNivel() {
		return nivel;
	}

	public void setCod(String cod) {
		this.cod = cod;
	}

	public String getCod() {
		return cod;
	}

	public void setOfiCodigo(String ofiCodigo) {
		
		while(ofiCodigo.length()<4){
			ofiCodigo = "0"+ofiCodigo;
		}
		
		this.ofiCodigo = ofiCodigo;
	}

	public String getOfiCodigo() {
		return ofiCodigo;
	}
}
