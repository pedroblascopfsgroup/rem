package es.pfsgroup.plugin.rem.comisionamiento.dto;

import java.util.ArrayList;

public class RespuestaComisionDto {
	private String id;
	private String idComision;
	private ConsultaComisionDto body;
	private String headers;
	private ArrayList<RespuestaComisionResultDto> result;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getIdComision() {
		return idComision;
	}
	public void setIdComision(String idComision) {
		this.idComision = idComision;
	}
	public ConsultaComisionDto getBody() {
		return body;
	}
	public void setBody(ConsultaComisionDto body) {
		this.body = body;
	}
	public ArrayList<RespuestaComisionResultDto> getResult() {
		return result;
	}
	public void setResult(ArrayList<RespuestaComisionResultDto> result) {
		this.result = result;
	}
	public String getHeaders() {
		return headers;
	}
	public void setHeaders(String headers) {
		this.headers = headers;
	}
	
}
