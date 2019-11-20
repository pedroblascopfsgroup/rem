package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.List;

/**
 * DTO para la respuesta del webservice getOfertasVivasActGestoria.
 * HREOS-6229
 * @author ivan.serrano@pfsgroup.es
 *
 */
public class OfertaVivaRespuestaDto implements Serializable{

	private static final long serialVersionUID = -2134861518576629540L;
	
	private Long numOferta;
	private String codEstadoEco;
	private List<Long> resultado;	
	
	public Long getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}
	public String getCodEstadoEco() {
		return codEstadoEco;
	}
	public void setCodEstadoEco(String codEstadoEco) {
		this.codEstadoEco = codEstadoEco;
	}
	public List<Long> getResultado() {
		return resultado;
	}
	public void setResultado(List<Long> resultado) {
		this.resultado = resultado;
	}
}
