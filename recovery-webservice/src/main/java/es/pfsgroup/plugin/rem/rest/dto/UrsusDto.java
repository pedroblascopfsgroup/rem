package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.List;

import javax.validation.constraints.NotNull;

import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.Diccionary;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.EntityDefinition;
import es.pfsgroup.plugin.rem.rest.validator.groups.Insert;
import es.pfsgroup.plugin.rem.rest.validator.groups.Update;

public class UrsusDto implements Serializable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1879436383802722423L;

	@NotNull(groups = { Insert.class, Update.class })
	@Diccionary(clase = DDTipoDocumento.class, message = "El código del tipo de documento no se corresponde con ninguno del diccionario", 
		foreingField = "codigo", groups = {Insert.class, Update.class })
	private String tipoDocumentoCodigo;

	@NotNull(groups = { Insert.class, Update.class })
	@EntityDefinition(propertyName = "numeroDocumento")
	private String numeroDocumento;
	
	private List<Long> idsUrsus;
	
	private List<Long> idsUrsusBh;

	public List<Long> getIdsUrsus() {
		return idsUrsus;
	}

	public void setIdsUrsus(List<Long> idsUrsus) {
		this.idsUrsus = idsUrsus;
	}

	public List<Long> getIdsUrsusBh() {
		return idsUrsusBh;
	}

	public void setIdsUrsusBh(List<Long> idsUrsusBh) {
		this.idsUrsusBh = idsUrsusBh;
	}

	public String getTipoDocumentoCodigo() {
		return tipoDocumentoCodigo;
	}

	public void setTipoDocumentoCodigo(String tipoDocumentoCodigo) {
		this.tipoDocumentoCodigo = tipoDocumentoCodigo;
	}

	public String getNumeroDocumento() {
		return numeroDocumento;
	}

	public void setNumeroDocumento(String numeroDocumento) {
		this.numeroDocumento = numeroDocumento;
	}
		
}
