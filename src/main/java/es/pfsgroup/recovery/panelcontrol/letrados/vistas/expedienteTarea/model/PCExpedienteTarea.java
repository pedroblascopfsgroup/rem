package es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTarea.model;

import java.io.Serializable;
import java.lang.reflect.Method;
import java.sql.Date;
import java.util.Map;
import java.util.StringTokenizer;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;


@Entity
@Table(name = "V_PC_COT_EXP_TAR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class PCExpedienteTarea implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3730871494367533328L;

	@Column(name="ZON_COD")
	private String codigo;
	
	@Column(name="USU_USERNAME")	
	private String userName;
	
	@Column(name="LETRADO")
	private String letrado;
	
	@Column(name="EXPEDIENTE")
	private String expediente;
	
	@Column(name="SALDO_EXPEDIENTE")
	private Float saldo;
	
	@Column(name="ANYO")
	private String anyo;
	
	@Column(name="MES")
	private String mes;
	
	@Column(name="DIA")
	private String dia;
	
	@Id
	@Column(name="TAR_ID")
	private Long idTarea;
	
	@Column(name="TIPO_TAREA")
	private String tipoTarea;
	
	@Column(name="TIPO_PROCEDIMIENTO")
	private String tipoProcedimiento;
	
	@Column(name="COD_PROD")
	private String codigoProcedimiento;
	
	@Column(name="TIPO_SOLICITUD")
	private String tipoSolicitud;
	
	@Column(name="TAR_FECHA_VENC")
	private Date fechaVencimiento;
	
	@Column(name="TAR_FECHA_VENC_REAL")
	private Date fechaVencimientoReal;
	
	@Column(name="TIPO")
	private String tipo;
	
	@Column(name="DESCRIPCION_TAREA")
	private String descripcionTarea;
	
	@Column(name="TIPO_GESTION")
	private String tipoGestion;
	
	@Column(name="DIAS_VENCIDA")
	private String diasVencida;
	
	@Column(name="VRE")
	private String volumenRiesgo;
	
	@Column(name="NOMBRE_ASUNTO")
	private String nombreAsunto;
	
	@Column(name="GESTOR_INTERNO")
	private String gestorInterno;
	
	@Column(name="GESTOR_EXTERNO")
	private String gestorExterno;
	
	@Column(name="DESPACHO")
	private String despacho;
	
	@Column(name="PROVEEDOR")
	private String proveedor;
	
	@Column(name="CODIGO")
	private String codigoExpediente;
	
	@Column(name="ESTADO_PROCESAL")
	private String estadoProcesal;
	
	@Column(name="GRUPO_INTERNO")
	private String grupoInterno;
	
	@Column(name="SUPERVISOR")
	private String supervisor;
	
	@Column(name="SALDO_TOTAL")
	private String saldoTotal;
	
	@Column(name="ESTADO_ASUNTO")
	private String estadoAsunto;
	
	@Column(name="FECHA_CREAR_ASUNTO")
	private Date fechaCrearAsunto;
	
	@Column(name="CAMPAÑA")
	private String campanya;
	
	@Column(name="CARTERA")
	private String cartera;
	
	@Column(name="LOTE")
	private String lote;
	
	@Column(name="PRC_ID")
	private Long idProcedimiento;
	
	@Column(name="IDJUZGADO")
	private String idJuzgado;
	
	@Column(name="DD_JUZ_DESCRIPCION")
	private String descripcionJuzgado;
	
	@Column(name="IDPLAZA")
	private String idPlaza;
	
	@Column(name="DD_PLA_DESCRIPCION")
	private String descripcionPlaza;
	
	
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getLetrado() {
		return letrado;
	}
	public void setLetrado(String letrado) {
		this.letrado = letrado;
	}
	public String getExpediente() {
		return expediente;
	}
	public void setExpediente(String expediente) {
		this.expediente = expediente;
	}
	public Float getSaldo() {
		return saldo;
	}
	public void setSaldo(Float saldo) {
		this.saldo = saldo;
	}
	public String getAnyo() {
		return anyo;
	}
	public void setAnyo(String anyo) {
		this.anyo = anyo;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getDia() {
		return dia;
	}
	public void setDia(String dia) {
		this.dia = dia;
	}
	public Long getIdTarea() {
		return idTarea;
	}
	public void setIdTarea(Long idTarea) {
		this.idTarea = idTarea;
	}
	public String getTipoTarea() {
		return tipoTarea;
	}
	public void setTipoTarea(String tipoTarea) {
		this.tipoTarea = tipoTarea;
	}
	public String getTipoProcedimiento() {
		return tipoProcedimiento;
	}
	public void setTipoProcedimiento(String tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	public Date getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(Date fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getDescripcionTarea() {
		return descripcionTarea;
	}
	public void setDescripcionTarea(String descripcionTarea) {
		this.descripcionTarea = descripcionTarea;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getCodigo() {
		return codigo;
	}
	public String getTipoSolicitud() {
		return tipoSolicitud;
	}
	public void setTipoSolicitud(String tipoSolicitud) {
		this.tipoSolicitud = tipoSolicitud;
	}
	public Date getFechaVencimientoReal() {
		return fechaVencimientoReal;
	}
	public void setFechaVencimientoReal(Date fechaVencimientoReal) {
		this.fechaVencimientoReal = fechaVencimientoReal;
	}
	public String getTipoGestion() {
		return tipoGestion;
	}
	public void setTipoGestion(String tipoGestion) {
		this.tipoGestion = tipoGestion;
	}
	public String getDiasVencida() {
		return diasVencida;
	}
	public void setDiasVencida(String diasVencida) {
		this.diasVencida = diasVencida;
	}
	public String getVolumenRiesgo() {
		return volumenRiesgo;
	}
	public void setVolumenRiesgo(String volumenRiesgo) {
		this.volumenRiesgo = volumenRiesgo;
	}
	public String getNombreAsunto() {
		return nombreAsunto;
	}
	public void setNombreAsunto(String nombreAsunto) {
		this.nombreAsunto = nombreAsunto;
	}
	public String getGestorInterno() {
		return gestorInterno;
	}
	public void setGestorInterno(String gestorInterno) {
		this.gestorInterno = gestorInterno;
	}
	public String getGestorExterno() {
		return gestorExterno;
	}
	public void setGestorExterno(String gestorExterno) {
		this.gestorExterno = gestorExterno;
	}
	public String getDespacho() {
		return despacho;
	}
	public void setDespacho(String despacho) {
		this.despacho = despacho;
	}
	public String getProveedor() {
		return proveedor;
	}
	public void setProveedor(String proveedor) {
		this.proveedor = proveedor;
	}
	public String getCodigoExpediente() {
		return codigoExpediente;
	}
	public void setCodigoExpediente(String codigoExpediente) {
		this.codigoExpediente = codigoExpediente;
	}
	public String getEstadoProcesal() {
		return estadoProcesal;
	}
	public void setEstadoProcesal(String estadoProcesal) {
		this.estadoProcesal = estadoProcesal;
	}
	public String getGrupoInterno() {
		return grupoInterno;
	}
	public void setGrupoInterno(String grupoInterno) {
		this.grupoInterno = grupoInterno;
	}
	public String getSupervisor() {
		return supervisor;
	}
	public void setSupervisor(String supervisor) {
		this.supervisor = supervisor;
	}
	public String getSaldoTotal() {
		return saldoTotal;
	}
	public void setSaldoTotal(String saldoTotal) {
		this.saldoTotal = saldoTotal;
	}
	public String getEstadoAsunto() {
		return estadoAsunto;
	}
	public void setEstadoAsunto(String estadoAsunto) {
		this.estadoAsunto = estadoAsunto;
	}
	public Date getFechaCrearAsunto() {
		return fechaCrearAsunto;
	}
	public void setFechaCrearAsunto(Date fechaCrearAsunto) {
		this.fechaCrearAsunto = fechaCrearAsunto;
	}
	public String getCodigoProcedimiento() {
		return codigoProcedimiento;
	}
	public void setCodigoProcedimiento(String codigoProcedimiento) {
		this.codigoProcedimiento = codigoProcedimiento;
	}
	public String getCampanya() {
		return campanya;
	}
	public void setCampanya(String campanya) {
		this.campanya = campanya;
	}
	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	public String getCartera() {
		return cartera;
	}
	public void setLote(String lote) {
		this.lote = lote;
	}
	public String getLote() {
		return lote;
	}
	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}
	public void setIdJuzgado(String idJuzgado) {
		this.idJuzgado = idJuzgado;
	}
	public String getIdJuzgado() {
		return idJuzgado;
	}
	public void setDescripcionJuzgado(String descripcionJuzgado) {
		this.descripcionJuzgado = descripcionJuzgado;
	}
	public String getDescripcionJuzgado() {
		return descripcionJuzgado;
	}
	public void setIdPlaza(String idPlaza) {
		this.idPlaza = idPlaza;
	}
	public String getIdPlaza() {
		return idPlaza;
	}
	public void setDescripcionPlaza(String descripcionPlaza) {
		this.descripcionPlaza = descripcionPlaza;
	}
	public String getDescripcionPlaza() {
		return descripcionPlaza;
	}
	
}
