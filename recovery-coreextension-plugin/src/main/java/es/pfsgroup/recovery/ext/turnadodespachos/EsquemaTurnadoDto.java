package es.pfsgroup.recovery.ext.turnadodespachos;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import org.springframework.binding.message.Message;
import org.springframework.binding.message.Severity;
import org.springframework.context.MessageSource;
import org.springframework.util.AutoPopulatingList;

import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.pfsgroup.commons.utils.Checks;

public class EsquemaTurnadoDto {

	private Long id;
	private String descripcion;
	private Double limiteStockConcursos;
	private Double limiteStockLitigios;
	private List<EsquemaTurnadoConfigDto> lineasConfiguracion;
	
	public EsquemaTurnadoDto() {
		lineasConfiguracion = new AutoPopulatingList(EsquemaTurnadoConfigDto.class);
	}
	
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
	public List<EsquemaTurnadoConfigDto> getLineasConfiguracion() {
		return lineasConfiguracion;
	}
	public void setLineasConfiguracion(List<EsquemaTurnadoConfigDto> lineasConfiguracion) {
		this.lineasConfiguracion = lineasConfiguracion;
	}
	
	/**
	 * Valida el Dto para comprobar que está todo correcto.
	 * 
	 * @return
	 */
	public void validar(MessageSource messageSource, Locale locale) {

		List<Message> mensajes = new ArrayList<Message>();
		if (
				Checks.esNulo(this.getDescripcion()) ||
				Checks.esNulo(this.getLimiteStockLitigios()) ||
				Checks.esNulo(this.getLimiteStockConcursos()) ||
				Checks.esNulo(this.getLineasConfiguracion())
				) {
			mensajes.add(new Message(this, messageSource.getMessage("plugin.config.esquematurnado.editar.validacion1", null, "**Todos los campos son obligatorios y debe completar todas las tablas del esquema.", locale), Severity.ERROR));
			throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));
		}

		if (
				this.getLimiteStockLitigios()>100 || this.getLimiteStockLitigios()<0 ||
				this.getLimiteStockConcursos()>100 || this.getLimiteStockConcursos()<0
				) {
			mensajes.add(new Message(this, messageSource.getMessage("plugin.config.esquematurnado.editar.validacion4",null,"**El límite de stock debe ser un valor comprendido entre 0 y 100%",locale), Severity.ERROR));
			throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));
		}

		// Comprueba que se ha indicado cantidad para los todos los tipos de litigios.
		Set<String> codigosCI = new HashSet<String>(); 
		Set<String> codigosCC = new HashSet<String>(); 
		Set<String> codigosLI = new HashSet<String>(); 
		Set<String> codigosLC = new HashSet<String>(); 
		double totalCalidadLit = 0D;
		double totalCalidadCon = 0D;
		
		for (EsquemaTurnadoConfigDto config : this.lineasConfiguracion) {

			// Comprueba las líneas 
			config.validar(messageSource, locale);

			if (config.getTipo().equals(EsquemaTurnadoConfig.TIPO_CONCURSAL_IMPORTE)) {
			
				if (codigosCI.size()>0 && codigosCI.contains(config.getCodigo())) {
					mensajes.add(new Message(this, messageSource.getMessage("plugin.config.esquematurnado.editar.grid.error.codigoExistente",null,"**Este codigo ya existe, no se creará la línea.",locale), Severity.ERROR));
					throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));
				}
				if (!codigosCI.contains(config.getCodigo())) codigosCI.add(config.getCodigo());
				
			} else if (config.getTipo().equals(EsquemaTurnadoConfig.TIPO_CONCURSAL_CALIDAD)) {
				
				if (codigosCC.size()>0 && codigosCC.contains(config.getCodigo())) {
					mensajes.add(new Message(this, messageSource.getMessage("plugin.config.esquematurnado.editar.grid.error.codigoExistente",null,"**Este codigo ya existe, no se creará la línea.",locale), Severity.ERROR));
					throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));
				}
				if (!codigosCC.contains(config.getCodigo())) codigosCC.add(config.getCodigo());

				totalCalidadCon+=config.getPorcentaje();
			} else if (config.getTipo().equals(EsquemaTurnadoConfig.TIPO_LITIGIOS_IMPORTE)) {

				if (codigosLI.size()>0 && codigosLI.contains(config.getCodigo())) {
					mensajes.add(new Message(this, messageSource.getMessage("plugin.config.esquematurnado.editar.grid.error.codigoExistente",null,"**Este codigo ya existe, no se creará la línea.",locale), Severity.ERROR));
					throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));
				}
				if (!codigosLI.contains(config.getCodigo())) codigosLI.add(config.getCodigo());
				
			} else if (config.getTipo().equals(EsquemaTurnadoConfig.TIPO_LITIGIOS_CALIDAD)) {

				if (codigosLC.size()>0 && codigosLC.contains(config.getCodigo())) {
					mensajes.add(new Message(this, messageSource.getMessage("plugin.config.esquematurnado.editar.grid.error.codigoExistente",null,"**Este codigo ya existe, no se creará la línea.",locale), Severity.ERROR));
					throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));
				}
				if (!codigosLC.contains(config.getCodigo())) codigosLC.add(config.getCodigo());

				totalCalidadLit+=config.getPorcentaje();
			}
		} 
		
		if (codigosCI.size()==0 || codigosCC.size()==0 || codigosLI.size()==0 || codigosLC.size()==0) {
			mensajes.add(new Message(this, messageSource.getMessage("plugin.config.esquematurnado.editar.validacion1",null,"**Todos los campos son obligatorios y debe completar todas las tablas del esquema.",locale), Severity.ERROR));
			throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));
		}

		if (totalCalidadLit!=100 || totalCalidadCon!=100) {
			mensajes.add(new Message(this, messageSource.getMessage("plugin.config.esquematurnado.editar.grid.error.percentSuperado",null,"**Las diferentes opciones no pueden superar el 100%",locale), Severity.ERROR));
			throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));
		}

	}
	
}
