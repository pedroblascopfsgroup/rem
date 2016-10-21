package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;

import javax.validation.constraints.NotNull;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.model.dd.DDTipoHabitaculo;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class PlantaDto implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@NotNull(groups = Insert.class)
	private Integer numero;

	@NotNull(groups = Insert.class)
	@Diccionary(clase = DDTipoHabitaculo.class, message = "El codTipoEstancia no existe", groups = { Insert.class,
			Update.class })
	private String codTipoEstancia;

	@NotNull(groups = Insert.class)
	private Long numeroEstancias;

	@NotNull(groups = Insert.class)
	private Float estancias;

	@NotNull(groups = Insert.class)
	private String descripcionEstancias;

	public Integer getNumero() {
		return numero;
	}

	public void setNumero(Integer numero) {
		this.numero = numero;
	}

	public String getCodTipoEstancia() {
		return codTipoEstancia;
	}

	public void setCodTipoEstancia(String codTipoEstancia) {
		this.codTipoEstancia = codTipoEstancia;
	}

	public Long getNumeroEstancias() {
		return numeroEstancias;
	}

	public void setNumeroEstancias(Long numeroEstancias) {
		this.numeroEstancias = numeroEstancias;
	}

	public Float getEstancias() {
		return estancias;
	}

	public void setEstancias(Float estancias) {
		this.estancias = estancias;
	}

	public String getDescripcionEstancias() {
		return descripcionEstancias;
	}

	public void setDescripcionEstancias(String descripcionEstancias) {
		this.descripcionEstancias = descripcionEstancias;
	}

}
