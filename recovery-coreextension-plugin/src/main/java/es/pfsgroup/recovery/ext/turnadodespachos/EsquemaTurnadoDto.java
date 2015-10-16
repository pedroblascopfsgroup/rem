package es.pfsgroup.recovery.ext.turnadodespachos;

import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.binding.message.Message;
import org.springframework.binding.message.MessageBuilder;

import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;

public class EsquemaTurnadoDto {

	@Resource
	private Properties appProperties;
	
	private Long id;
	private String descripcion;
	private Double limiteStockConcursos;
	private Double limiteStockLitigios;
	private EsquemaTurnadoConfigDto[] lineasConfiguracion;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Double getLimiteStockConcursos() {
		return limiteStockConcursos;
	}
	public void setLimiteStockConcursos(Double limiteStockConcursos) {
		this.limiteStockConcursos = limiteStockConcursos;
	}
	public Double getLimiteStockLitigios() {
		return limiteStockLitigios;
	}
	public void setLimiteStockLitigios(Double limiteStockLitigios) {
		this.limiteStockLitigios = limiteStockLitigios;
	}
	public EsquemaTurnadoConfigDto[] getLineasConfiguracion() {
		return lineasConfiguracion;
	}
	public void setLineasConfiguracion(EsquemaTurnadoConfigDto[] lineasConfiguracion) {
		this.lineasConfiguracion = lineasConfiguracion;
	}
	
	/**
	 * Valida el Dto para comprobar que está todo correcto.
	 * 
	 * @return
	 */
	public boolean validar() {
		return true;
	}
	
}
