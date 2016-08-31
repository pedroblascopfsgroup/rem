package es.pfsgroup.plugin.rem.rest.dto;

import java.io.Serializable;
import java.util.List;

public class DataDto implements Serializable{

	private static final long serialVersionUID = 2475336521980059853L;

	private List<Long> idActivoBien;
	public List<Long> getIdActivoBien() {
		return idActivoBien;
	}

	public void setIdActivoBien(List<Long> idActivoBien) {
		this.idActivoBien = idActivoBien;
	}


}
