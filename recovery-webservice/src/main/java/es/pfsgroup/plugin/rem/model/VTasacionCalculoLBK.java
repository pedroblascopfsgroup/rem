package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_TASACION_CALCULO_LBK", schema = "${entity.schema}")
public class VTasacionCalculoLBK implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	

	@Id
	@Column(name = "ID_VISTA")  
	private Long id;	
	
	@Column(name = "ACT_ID")  
	private Long idActivo;
	
	@Column(name = "AGR_ID")  
	private Long idAgrupacion;
	
	@Column(name = "TASACION")
	private Double importeTasacion;
	
	@Column(name = "DD_TPC_CODIGO")
	private String codigoTipoPrecio;

	@Column(name = "VAL_IMPORTE")
	private Double importeTipoPrecio;
	
	@Column(name="FECHA_VALOR_TASACION")
	private Date fechaTasacion;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public Double getImporteTasacion() {
		return importeTasacion;
	}

	public void setImporteTasacion(Double importeTasacion) {
		this.importeTasacion = importeTasacion;
	}

	public String getCodigoTipoPrecio() {
		return codigoTipoPrecio;
	}

	public void setCodigoTipoPrecio(String codigoTipoPrecio) {
		this.codigoTipoPrecio = codigoTipoPrecio;
	}

	public Double getImporteTipoPrecio() {
		return importeTipoPrecio;
	}

	public void setImporteTipoPrecio(Double importeTipoPrecio) {
		this.importeTipoPrecio = importeTipoPrecio;
	}

	public Date getFechaTasacion() {
		return fechaTasacion;
	}

	public void setFechaTasacion(Date fechaTasacion) {
		this.fechaTasacion = fechaTasacion;
	}
	
	
}