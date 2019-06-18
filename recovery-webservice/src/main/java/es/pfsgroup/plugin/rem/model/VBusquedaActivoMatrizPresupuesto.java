package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_PRESUPUESTO_ACTIVO_MATRIZ_EJERCICIO", schema = "${entity.schema}")
public class VBusquedaActivoMatrizPresupuesto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name="ACTIVO_MATRIZ")
	private String activoMatriz;
	
	@Column(name="INICIAL")
	private Double inicial;
	
	@Column(name="INCREMENTOS")
	private Double incrementos;
	
	@Column(name="IMPORTES_TRABAJOS")
	private Double importeTrabajos;
	
	@Column(name="SALDO_DISPONIBLE")
	private Double saldoDisponible;
	
	@Column(name="SALDO_NECESARIO")
	private Double saldoNecesario;
	
	@Column(name="EJE_ANYO")
	private String ejercicioAnyo;
	
	@Column(name="IMPORTE_TRABAJO_PENDIENTE_PAGO")
	private Double importeTrabajosPendientesPago;

	public String getActivoMatriz() {
		return activoMatriz;
	}
	
	public void setActivoMatriz(String activoMatriz) {
		this.activoMatriz = activoMatriz;
	}

	public Double getInicial() {
		return inicial;
	}

	public void setInicial(Double inicial) {
		this.inicial = inicial;
	}

	public Double getIncrementos() {
		return incrementos;
	}

	public void setIncrementos(Double incrementos) {
		this.incrementos = incrementos;
	}

	public Double getImporteTrabajos() {
		return importeTrabajos;
	}

	public void setImporteTrabajos(Double importeTrabajos) {
		this.importeTrabajos = importeTrabajos;
	}

	public Double getSaldoDisponible() {
		return saldoDisponible;
	}

	public void setSaldoDisponible(Double saldoDisponible) {
		this.saldoDisponible = saldoDisponible;
	}

	public Double getSaldoNecesario() {
		return saldoNecesario;
	}

	public void setSaldoNecesario(Double saldoNecesario) {
		this.saldoNecesario = saldoNecesario;
	}

	public String getEjercicioAnyo() {
		return ejercicioAnyo;
	}

	public void setEjercicioAnyo(String ejercicioAnyo) {
		this.ejercicioAnyo = ejercicioAnyo;
	}

	public Double getImporteTrabajosPendientesPago() {
		return importeTrabajosPendientesPago;
	}

	public void setImporteTrabajosPendientesPago(Double importeTrabajosPendientesPago) {
		this.importeTrabajosPendientesPago = importeTrabajosPendientesPago;
	}
	
}
