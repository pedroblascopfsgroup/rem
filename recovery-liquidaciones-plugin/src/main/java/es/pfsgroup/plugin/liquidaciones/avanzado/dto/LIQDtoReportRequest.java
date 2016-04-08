package es.pfsgroup.plugin.liquidaciones.avanzado.dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;

public class LIQDtoReportRequest extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3639389959078769158L;
	
	private Long actuacion;
	private Long contrato;
	private String nombre;
	private String dni;
	
	private BigDecimal capital;
	private BigDecimal interesesOrdinarios;
	private BigDecimal interesesDemora;
	private BigDecimal comisiones;
	private BigDecimal gastos;
	private BigDecimal impuestos;
	private Float tipoInteres;
	private String fechaCierre;
	
	private BigDecimal costasLetrado;
	private BigDecimal costasProcurador;
	private BigDecimal otrosGastos;
	
	private Integer baseCalculo;
	private String fechaDeLiquidacion;
	private Float tipoDemoraCierre;
	
	private String tiposIntereses;
	private List<LIQReportTiposIntereses> lTiposInteres;

	public Long getActuacion() {
		return actuacion;
	}

	public void setActuacion(Long actuacion) {
		this.actuacion = actuacion;
	}

	public Long getContrato() {
		return contrato;
	}

	public void setContrato(Long contrato) {
		this.contrato = contrato;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDni() {
		return dni;
	}

	public void setDni(String dni) {
		this.dni = dni;
	}

	public BigDecimal getCapital() {
		return capital;
	}

	public void setCapital(BigDecimal capital) {
		this.capital = capital;
	}

	public BigDecimal getInteresesOrdinarios() {
		return interesesOrdinarios;
	}

	public void setInteresesOrdinarios(BigDecimal interesesOrdinarios) {
		this.interesesOrdinarios = interesesOrdinarios;
	}

	public BigDecimal getInteresesDemora() {
		return interesesDemora;
	}

	public void setInteresesDemora(BigDecimal interesesDemora) {
		this.interesesDemora = interesesDemora;
	}

	public BigDecimal getComisiones() {
		return comisiones;
	}

	public void setComisiones(BigDecimal comisiones) {
		this.comisiones = comisiones;
	}

	public BigDecimal getGastos() {
		return gastos;
	}

	public void setGastos(BigDecimal gastos) {
		this.gastos = gastos;
	}

	public BigDecimal getImpuestos() {
		return impuestos;
	}

	public void setImpuestos(BigDecimal impuestos) {
		this.impuestos = impuestos;
	}

	public Float getTipoInteres() {
		return tipoInteres;
	}

	public void setTipoInteres(Float tipoInteres) {
		this.tipoInteres = tipoInteres;
	}

	public String getFechaCierre() {
		return fechaCierre;
	}

	public void setFechaCierre(String fechaCierre) {
		this.fechaCierre = fechaCierre;
	}

	public BigDecimal getCostasLetrado() {
		return costasLetrado;
	}

	public void setCostasLetrado(BigDecimal costasLetrado) {
		this.costasLetrado = costasLetrado;
	}

	public BigDecimal getCostasProcurador() {
		return costasProcurador;
	}

	public void setCostasProcurador(BigDecimal costasProcurador) {
		this.costasProcurador = costasProcurador;
	}

	public BigDecimal getOtrosGastos() {
		return otrosGastos;
	}

	public void setOtrosGastos(BigDecimal otrosGastos) {
		this.otrosGastos = otrosGastos;
	}

	public Integer getBaseCalculo() {
		return baseCalculo;
	}

	public void setBaseCalculo(Integer baseCalculo) {
		this.baseCalculo = baseCalculo;
	}

	public String getFechaDeLiquidacion() {
		return fechaDeLiquidacion;
	}

	public void setFechaDeLiquidacion(String fechaDeLiquidacion) {
		this.fechaDeLiquidacion = fechaDeLiquidacion;
	}

	public Float getTipoDemoraCierre() {
		return tipoDemoraCierre;
	}

	public void setTipoDemoraCierre(Float tipoDemoraCierre) {
		this.tipoDemoraCierre = tipoDemoraCierre;
	}

	public String getTiposIntereses() {
		return tiposIntereses;
	}

	public void setTiposIntereses(String tiposIntereses) {
		this.tiposIntereses = tiposIntereses;
		
		lTiposInteres = new ArrayList<LIQReportTiposIntereses>();
		for (String regTipoInteres : tiposIntereses.split(",")) {
			if (!Checks.esNulo(regTipoInteres)) {
				LIQReportTiposIntereses lReg = new LIQReportTiposIntereses();
				
				String partes[] = regTipoInteres.split("#");
				lReg.setFecha(partes[0]);
				lReg.setTipoInteres(Float.parseFloat(partes[1]));
				
				lTiposInteres.add(lReg);
			}
		};
		
		//Nos guardamos la lista ordenada por fecha
		Collections.sort(lTiposInteres);
	}

	public List<LIQReportTiposIntereses> getlTiposInteres() {
		return lTiposInteres;
	}
	
	//Metodos
	
	/**
	 * Encuentra el primer cambio de tipo de interes entre las fechas
	 * @param desde
	 * @param hasta
	 * @return un cambio encontrado o null
	 */
	public LIQReportTiposIntereses getPrimerCambioEntreFechas(Date desde, Date hasta) {
		Calendar c = Calendar.getInstance();
		
		LIQReportTiposIntereses resultado = null;
		
		Date fecha = desde;
		while (fecha.compareTo(hasta)<=0) {
			for (LIQReportTiposIntereses tipo : lTiposInteres) {
				if (DateFormat.toString(fecha).equals(tipo.getFecha())) {
					return tipo;
				}
			}

			//Avanzamos un día
			c.setTime(fecha); 
			c.add(Calendar.DATE, 1);
			fecha = c.getTime();
		}
		
		return resultado;
	}
	

}
