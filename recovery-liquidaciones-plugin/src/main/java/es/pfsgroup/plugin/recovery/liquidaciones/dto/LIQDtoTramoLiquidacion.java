package es.pfsgroup.plugin.recovery.liquidaciones.dto;

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
 * Dto para la búsqueda de clientes.
 */
public class LIQDtoTramoLiquidacion extends WebDto {

    private static final long serialVersionUID = 1L;
    
    private Date fechaMovimiento;
    private Float deuda = null;
    private Float interes;
    private Date fLiquidacion;
    private Long dias;
    private Float coefic = null;
    private Float intereses = null;
    private Float entregado = null;

    public Date getFechaMovimiento() {
		return fechaMovimiento;
	}
	public void setFechaMovimiento(Date fechaMovimiento) {
		this.fechaMovimiento = fechaMovimiento;
	}
	public Float getDeuda() {
		return deuda;
	}
	public void setDeuda(Float deuda) {
		this.deuda = deuda;
	}
	public Float getInteres() {
		return interes;
	}
	public void setInteres(Float interes) {
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
	public Float getIntereses() {
		return intereses;
	}
	public void setIntereses(Float intereses) {
		this.intereses = intereses;
	}
	public Float getEntregado() {
		return entregado;
	}
	public void setEntregado(Float entregado) {
		this.entregado = entregado;
	}
    
    
	
    
}
