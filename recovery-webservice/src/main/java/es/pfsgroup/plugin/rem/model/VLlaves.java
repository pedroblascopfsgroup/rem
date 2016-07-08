package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Modelo para la vista de llaves del activo
 * 
 * @author Carlos Feliu
 *
 */
@Entity
@Table(name = "V_LLAVES", schema = "${entity.schema}")
public class VLlaves implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "MLV_ID")
	private Long idMovimiento;
	
	@Column(name = "LLV_ID")
	private Long idLlave;
	
	@Column(name = "ACT_ID")
	private Long idActivo;
	
	@Column(name = "LLV_NOMBRE_CENTRO")
	private String nomCentroLlave;
	
	@Column(name = "LLV_ARCHIVO1")
	private String archivo1;
	
	@Column(name = "LLV_ARCHIVO2")
	private String archivo2;
	
	@Column(name = "LLV_ARCHIVO3")
	private String archivo3;
	
	@Column(name = "LLV_COMPLETO")
	private Integer juegoCompleto;
	
	@Column(name = "LLV_MOTIVO_INCOMPLETO")
	private String motivoIncompleto;
	
	@Column(name = "DD_TTE_CODIGO")
	private String codigoTipoTenedor;
	
	@Column(name = "DD_TTE_DESCRIPCION")
	private String descripcionTipoTenedor;
	
	@Column(name = "MLV_COD_TENEDOR")
	private String codTenedor;
	
	@Column(name = "MLV_NOM_TENEDOR")
	private String nomTenedor;
	 
	@Column(name = "MLV_FECHA_ENTREGA")
	private Date fechaEntrega;
	
	@Column(name = "MLV_FECHA_DEVOLUCION")
	private Date fechaDevolucion;

	public Long getIdMovimiento() {
		return idMovimiento;
	}

	public void setIdMovimiento(Long idMovimiento) {
		this.idMovimiento = idMovimiento;
	}

	public Long getIdLlave() {
		return idLlave;
	}

	public void setIdLlave(Long idLlave) {
		this.idLlave = idLlave;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public String getNomCentroLlave() {
		return nomCentroLlave;
	}

	public void setNomCentroLlave(String nomCentroLlave) {
		this.nomCentroLlave = nomCentroLlave;
	}

	public String getArchivo1() {
		return archivo1;
	}

	public void setArchivo1(String archivo1) {
		this.archivo1 = archivo1;
	}

	public String getArchivo2() {
		return archivo2;
	}

	public void setArchivo2(String archivo2) {
		this.archivo2 = archivo2;
	}

	public String getArchivo3() {
		return archivo3;
	}

	public void setArchivo3(String archivo3) {
		this.archivo3 = archivo3;
	}

	public Integer getJuegoCompleto() {
		return juegoCompleto;
	}

	public void setJuegoCompleto(Integer juegoCompleto) {
		this.juegoCompleto = juegoCompleto;
	}

	public String getMotivoIncompleto() {
		return motivoIncompleto;
	}

	public void setMotivoIncompleto(String motivoIncompleto) {
		this.motivoIncompleto = motivoIncompleto;
	}

	public String getCodigoTipoTenedor() {
		return codigoTipoTenedor;
	}

	public void setCodigoTipoTenedor(String codigoTipoTenedor) {
		this.codigoTipoTenedor = codigoTipoTenedor;
	}

	public String getDescripcionTipoTenedor() {
		return descripcionTipoTenedor;
	}

	public void setDescripcionTipoTenedor(String descripcionTipoTenedor) {
		this.descripcionTipoTenedor = descripcionTipoTenedor;
	}

	public String getCodTenedor() {
		return codTenedor;
	}

	public void setCodTenedor(String codTenedor) {
		this.codTenedor = codTenedor;
	}

	public String getNomTenedor() {
		return nomTenedor;
	}

	public void setNomTenedor(String nomTenedor) {
		this.nomTenedor = nomTenedor;
	}

	public Date getFechaEntrega() {
		return fechaEntrega;
	}

	public void setFechaEntrega(Date fechaEntrega) {
		this.fechaEntrega = fechaEntrega;
	}

	public Date getFechaDevolucion() {
		return fechaDevolucion;
	}

	public void setFechaDevolucion(Date fechaDevolucion) {
		this.fechaDevolucion = fechaDevolucion;
	}


}
	
	
	