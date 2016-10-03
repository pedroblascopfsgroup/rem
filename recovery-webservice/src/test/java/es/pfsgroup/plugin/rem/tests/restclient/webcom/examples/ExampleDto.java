package es.pfsgroup.plugin.rem.tests.restclient.webcom.examples;

import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.WebcomRESTDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.NestedDto;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

/**
 * Este es un DTO de ejemplo para usarlo durante los tests
 * @author bruno
 *
 */
public class ExampleDto implements WebcomRESTDto{
	
	public static final String GROUP_BY_FIELD = "idObjeto";

	@WebcomRequired
	private LongDataType idUsuarioRemAccion = LongDataType.longDataType(1L);
	
	@WebcomRequired
	private DateDataType fechaAccion = DateDataType.dateDataType(new Date());
	
	@WebcomRequired
	private LongDataType idObjeto;

	@WebcomRequired
	private StringDataType campoObligatorio;
	
	
	private StringDataType campoOpcional;
	
	@NestedDto(type=ExampleSubDto.class, groupBy=GROUP_BY_FIELD)
	private List<ExampleSubDto> listado1;
	
	@NestedDto(type=ExampleSubDto.class, groupBy=GROUP_BY_FIELD)
	private List<ExampleSubDto> listado2;


	public LongDataType getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}


	public void setIdUsuarioRemAccion(LongDataType idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}


	public DateDataType getFechaAccion() {
		return fechaAccion;
	}


	public void setFechaAccion(DateDataType fechaAccion) {
		this.fechaAccion = fechaAccion;
	}


	public StringDataType getCampoObligatorio() {
		return campoObligatorio;
	}


	public void setCampoObligatorio(StringDataType campoObligatorio) {
		this.campoObligatorio = campoObligatorio;
	}


	public StringDataType getCampoOpcional() {
		return campoOpcional;
	}


	public void setCampoOpcional(StringDataType campoOpcional) {
		this.campoOpcional = campoOpcional;
	}


	public LongDataType getIdObjeto() {
		return idObjeto;
	}


	public void setIdObjeto(LongDataType idObjeto) {
		this.idObjeto = idObjeto;
	}


	public List<ExampleSubDto> getListado1() {
		return listado1;
	}


	public void setListado1(List<ExampleSubDto> listado1) {
		this.listado1 = listado1;
	}


	public List<ExampleSubDto> getListado2() {
		return listado2;
	}


	public void setListado2(List<ExampleSubDto> listado2) {
		this.listado2 = listado2;
	}


}
