package es.pfsgroup.recovery.panelcontrol.judicial.vistas.panelControl.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

@Entity
@Table(name = " V_PC_ZONAS_JUDICIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class PanelControlVista implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7413090533239283304L;
	
	@Column(name="OFICODIGO")
	private String ofiCodigo;
	
	@Id
	@Column(name="ID")
	private Long id;
	
	@Column(name="COD")
	private String cod;
	
	@Column(name="NIVEL")
	private String nivel;
	
	@Column(name="CLIENTES")
	private Integer clientes;
	
	@Column(name="CONTRATOSTOTAL")
	private Integer contratosTotal;
	
	@Column(name="CONTRATOSIRREGULARES")
	private Integer contratosIrregulares;
	
	@Column(name="SALDOVENCIDO")
	private Float saldoVencido;
	
	@Column(name="SALDONOVENCIDO")
	private Float saldoNoVencido;
	
	@Column(name="saldoNoVencidoDanyado")
	private Float saldoNoVencidoDanyado;
	
	@Column(name="TAREASPENDIENTESVENCIDAS")
	private Long tareasPendientesVencidas;
	

	@Column(name="TAREASPENDIENTESHOY")
	private Long tareasPendientesHoy;
	

	@Column(name="TAREASPENDIENTESSEMANA")
	private Long tareasPendientesSemana;
	

	@Column(name="TAREASPENDIENTESMES")
	private Long tareasPendientesMes;
	
	public String getOfiCodigo() {
		return ofiCodigo;
	}
	public void setOfiCodigo(String ofiCodigo) {
		this.ofiCodigo = ofiCodigo;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getCod() {
		return cod;
	}
	public void setCod(String cod) {
		this.cod = cod;
	}
	public String getNivel() {
		return nivel;
	}
	public void setNivel(String nivel) {
		this.nivel = nivel;
	}
	public Integer getClientes() {
		return clientes;
	}
	public void setClientes(Integer clientes) {
		this.clientes = clientes;
	}
	public Integer getContratosTotal() {
		return contratosTotal;
	}
	public void setContratosTotal(Integer contratosTotal) {
		this.contratosTotal = contratosTotal;
	}
	public Integer getContratosIrregulares() {
		return contratosIrregulares;
	}
	public void setContratosIrregulares(Integer contratosIrregulares) {
		this.contratosIrregulares = contratosIrregulares;
	}
	public Float getSaldoVencido() {
		return saldoVencido;
	}
	public void setSaldoVencido(Float saldoVencido) {
		this.saldoVencido = saldoVencido;
	}
	public Float getSaldoNoVencido() {
		return saldoNoVencido;
	}
	public void setSaldoNoVencido(Float saldoNoVencido) {
		this.saldoNoVencido = saldoNoVencido;
	}
	public Float getSaldoNoVencidoDanyado() {
		return saldoNoVencidoDanyado;
	}
	public void setSaldoNoVencidoDanyado(Float saldoNoVencidoDanyado) {
		this.saldoNoVencidoDanyado = saldoNoVencidoDanyado;
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
	

}
