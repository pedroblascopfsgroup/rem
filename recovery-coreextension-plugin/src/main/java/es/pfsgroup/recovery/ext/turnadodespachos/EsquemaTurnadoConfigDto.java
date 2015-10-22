package es.pfsgroup.recovery.ext.turnadodespachos;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.springframework.binding.message.Message;
import org.springframework.binding.message.Severity;
import org.springframework.context.MessageSource;

import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;
import es.pfsgroup.commons.utils.Checks;

public class EsquemaTurnadoConfigDto {

	private Long id;
	private String tipo;
	private String codigo;
	private Double importeDesde;
	private Double importeHasta;
	private Double porcentaje;
	
	public EsquemaTurnadoConfigDto() {
		importeDesde=0D;
		importeHasta=0D;
		porcentaje=0D;
	}
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public Double getImporteDesde() {
		return importeDesde;
	}
	public void setImporteDesde(Double importeDesde) {
		this.importeDesde = importeDesde;
	}
	public Double getImporteHasta() {
		return importeHasta;
	}
	public void setImporteHasta(Double importeHasta) {
		this.importeHasta = importeHasta;
	}
	public Double getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(Double porcentaje) {
		this.porcentaje = porcentaje;
	}

	public void validar(MessageSource messageSource, Locale locale) {

		List<Message> mensajes = new ArrayList<Message>();
		if (
				Checks.esNulo(this.getTipo()) ||
				Checks.esNulo(this.getCodigo())
		) {
			mensajes.add(new Message(this, messageSource.getMessage("plugin.config.esquematurnado.editar.validacion1",null,"**Todos los campos son obligatorios y debe completar todas las tablas del esquema.", locale), Severity.ERROR));
			throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));
		}
		if (this.getImporteDesde()<0) {
			mensajes.add(new Message(this, messageSource.getMessage("plugin.config.esquematurnado.editar.validacion6",null,"**La cantidad debe ser un entero positivo",locale), Severity.ERROR));
			throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));
		}
		if (this.getPorcentaje()<0 || this.getPorcentaje()>100) {
			mensajes.add(new Message(this, messageSource.getMessage("plugin.config.esquematurnado.editar.validacion7",null,"**El porcentaje debe ser un valor comprendido entre 0 y 100%",locale), Severity.ERROR));
			throw new ValidationException(ErrorMessageUtils.convertMessages(mensajes));
		}
	}
	
}
