package es.pfsgroup.plugin.rem.rest.dto;

import javax.validation.constraints.NotNull;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class PropuestaDto {

	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = Oferta.class, message = "La oferta no existe", foreingField = "numOferta", groups = {
			Insert.class, Update.class })
	private Long ofertaHRE;

	public Long getOfertaHRE() {
		return ofertaHRE;
	}

	public void setOfertaHRE(Long ofertaHRE) {
		this.ofertaHRE = ofertaHRE;
	}
	
}
