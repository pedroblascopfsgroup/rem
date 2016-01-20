package es.pfsgroup.plugin.recovery.liquidaciones.dto;

import java.math.BigDecimal;
import java.util.Date;

import es.capgemini.devon.dto.WebDto;
/*
import org.apache.commons.lang.builder.ReflectionToStringBuilder;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.capgemini.pfs.users.domain.Perfil;
*/
/**
 * Dto para la b�squeda de clientes.
 */
public class LIQDtoTramoLiquidacion extends WebDto {

    private static final long serialVersionUID = 1L;
    
    private String fechaMovimiento;
    private BigDecimal deuda = null;
    private BigDecimal interes;
    private Date fLiquidacion;
    private Long dias;
    private Float coefic = null;
    private BigDecimal intereses = null;
    private BigDecimal entregado = null;
    
    private String descrMov;
    private BigDecimal aCNominal;
    private BigDecimal interesCalculado;

    public String getFechaMovimiento() {
		return fechaMovimiento;
	}
	public void setFechaMovimiento(String fechaMovimiento) {
		this.fechaMovimiento = fechaMovimiento;
	}
	public BigDecimal getDeuda() {
		return deuda;
	}
	public void setDeuda(BigDecimal deuda) {
		this.deuda = deuda;
	}
	public BigDecimal getInteres() {
		return interes;
	}
	public void setInteres(BigDecimal interes) {
		this.interes = interes;
	}
	public Date getfLiquidacion() {
		return fLiquidacion;
	}
	public void setfLiquidacion(Date fLiquidacion) {
		this.fLiquidacion = fLiquidacion;
	}
	public Long getDias() {
		return dias;
	}
	public void setDias(Long dias) {
		this.dias = dias;
	}
	public Float getCoefic() {
		return coefic;
	}
	public void setCoefic(Float coefic) {
		this.coefic = coefic;
	}
	public BigDecimal getIntereses() {
		return intereses;
	}
	public void setIntereses(BigDecimal intereses) {
		this.intereses = intereses;
	}
	public BigDecimal getEntregado() {
		return entregado;
	}
	public void setEntregado(BigDecimal entregado) {
		this.entregado = entregado;
	}
	public String getDescrMov() {
		return descrMov;
	}
	public void setDescrMov(String descrMov) {
		this.descrMov = descrMov;
	}
	public BigDecimal getaCNominal() {
		return aCNominal;
	}
	public void setaCNominal(BigDecimal aCNominal) {
		this.aCNominal = aCNominal;
	}
	public BigDecimal getInteresCalculado() {
		return interesCalculado;
	}
	public void setInteresCalculado(BigDecimal interesCalculado) {
		this.interesCalculado = interesCalculado;
	}
    
    
	
    
}
