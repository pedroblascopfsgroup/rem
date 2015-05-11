package es.capgemini.pfs.asunto.dto;

import java.util.List;

public class ExtAdjuntoGenericoDtoImpl implements ExtAdjuntoGenericoDto{

	private String descripcion;
	
	private Long id;
	
	private List adjuntosAsList;
	
	private List adjuntos;

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public List getAdjuntosAsList() {
		return adjuntosAsList;
	}

	public void setAdjuntosAsList(List adjuntosAsList) {
		this.adjuntosAsList = adjuntosAsList;
	}

	public List getAdjuntos() {
		return adjuntos;
	}

	public void setAdjuntos(List adjuntos) {
		this.adjuntos = adjuntos;
	}

	
}
