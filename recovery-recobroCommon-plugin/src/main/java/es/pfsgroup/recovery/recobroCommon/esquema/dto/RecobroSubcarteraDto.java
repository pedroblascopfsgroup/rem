package es.pfsgroup.recovery.recobroCommon.esquema.dto;

import es.capgemini.devon.dto.WebDto;

public class RecobroSubcarteraDto extends WebDto{
	
	private static final long serialVersionUID = -2409445448149308929L;
	
	private Long id;
	private Long modeloFacturacion;
	private Long itinerarioMetasVolantes;
	private Long politicaDeAcuerdo;
	private Long modeloDeRanking;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getModeloFacturacion() {
		return modeloFacturacion;
	}
	public void setModeloFacturacion(Long modeloFacturacion) {
		this.modeloFacturacion = modeloFacturacion;
	}
	public Long getItinerarioMetasVolantes() {
		return itinerarioMetasVolantes;
	}
	public void setItinerarioMetasVolantes(Long itinerarioMetasVolantes) {
		this.itinerarioMetasVolantes = itinerarioMetasVolantes;
	}
	public Long getPoliticaDeAcuerdo() {
		return politicaDeAcuerdo;
	}
	public void setPoliticaDeAcuerdo(Long politicaDeAcuerdo) {
		this.politicaDeAcuerdo = politicaDeAcuerdo;
	}
	public Long getModeloDeRanking() {
		return modeloDeRanking;
	}
	public void setModeloDeRanking(Long modeloDeRanking) {
		this.modeloDeRanking = modeloDeRanking;
	}
}
