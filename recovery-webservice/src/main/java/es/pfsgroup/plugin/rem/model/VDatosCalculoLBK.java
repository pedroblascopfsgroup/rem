package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Vista que recoge los datos necesario para el calculo comité liberbank.
 * 
 * @author Joaquin Bahamonde
 */
@Entity
@Table(name = "V_DATOS_CALCULO_LBK", schema = "${entity.schema}")
public class VDatosCalculoLBK implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ACT_ID")
	private Long activo;
	
	@Column(name = "VALOR_NETO_CONTABLE")
	private Double valorNetoContable;
	
	@Column(name = "VALOR_IMPORTE_MINIMO_AUTORIZADO")
	private Double importeMinAutorizado;
	
	@Column(name = "VALOR_RAZONABLE")
	private Double valorRazonable;
	
	@Column(name = "VALOR_TASACION_ACTUAL")
	private Double tasacionActual;

	public Long getActivo() {
		return activo;
	}

	public void setActivo(Long activo) {
		this.activo = activo;
	}

	public Double getValorNetoContable() {
		return valorNetoContable;
	}

	public void setValorNetoContable(Double valorNetoContable) {
		this.valorNetoContable = valorNetoContable;
	}

	public Double getImporteMinAutorizado() {
		return importeMinAutorizado;
	}

	public void setImporteMinAutorizado(Double importeMinAutorizado) {
		this.importeMinAutorizado = importeMinAutorizado;
	}

	public Double getValorRazonable() {
		return valorRazonable;
	}

	public void setValorRazonable(Double valorRazonable) {
		this.valorRazonable = valorRazonable;
	}

	public Double getTasacionActual() {
		return tasacionActual;
	}

	public void setTasacionActual(Double tasacionActual) {
		this.tasacionActual = tasacionActual;
	}
	
	
}
	