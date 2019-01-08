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
	
	@Column(name = "PRECIO_APROBADO")
	private Double importePrecioAprobado;
	
	@Column(name = "PRECIO_MINIMO")
	private Double importePrecioMinimo;
	
	@Column(name = "PRECIO_DESCUENTO")
	private Double importePrecioDescuento;
	
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

	public Double getImportePrecioAprobado() {
		return importePrecioAprobado;
	}

	public void setImportePrecioAprobado(Double importePrecioAprobado) {
		this.importePrecioAprobado = importePrecioAprobado;
	}

	public Double getImportePrecioMinimo() {
		return importePrecioMinimo;
	}

	public void setImportePrecioMinimo(Double importePrecioMinimo) {
		this.importePrecioMinimo = importePrecioMinimo;
	}

	public Double getImportePrecioDescuento() {
		return importePrecioDescuento;
	}

	public void setImportePrecioDescuento(Double importePrecioDescuento) {
		this.importePrecioDescuento = importePrecioDescuento;
	}

	public Date getFechaTasacion() {
		return fechaTasacion;
	}

	public void setFechaTasacion(Date fechaTasacion) {
		this.fechaTasacion = fechaTasacion;
	}
	
	
}