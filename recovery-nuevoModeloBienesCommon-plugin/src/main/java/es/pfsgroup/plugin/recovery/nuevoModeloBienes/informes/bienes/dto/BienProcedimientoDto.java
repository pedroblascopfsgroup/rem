package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.bienes.dto;

import java.io.Serializable;

public class BienProcedimientoDto implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 73088922254815811L;

	private String asunto;
	private String autos;
	private String juzgado;
	private String plaza;
	
	public String getAsunto() {
		return asunto;
	}

	public void setAsunto(String asunto) {
		this.asunto = asunto;
	}

	public String getAutos() {
		return autos;
	}

	public void setAutos(String autos) {
		this.autos = autos;
	}

	public String getJuzgado() {
		return juzgado;
	}

	public void setJuzgado(String juzgado) {
		this.juzgado = juzgado;
	}

	public String getPlaza() {
		return plaza;
	}

	public void setPlaza(String plaza) {
		this.plaza = plaza;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((asunto == null) ? 0 : asunto.hashCode());
		result = prime * result + ((autos == null) ? 0 : autos.hashCode());
		result = prime * result + ((juzgado == null) ? 0 : juzgado.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (!(obj instanceof BienProcedimientoDto)) {
			return false;
		}
		BienProcedimientoDto other = (BienProcedimientoDto) obj;
		if (asunto == null) {
			if (other.asunto != null) {
				return false;
			}
		} else if (!asunto.equals(other.asunto)) {
			return false;
		}
		if (autos == null) {
			if (other.autos != null) {
				return false;
			}
		} else if (!autos.equals(other.autos)) {
			return false;
		}
		if (juzgado == null) {
			if (other.juzgado != null) {
				return false;
			}
		} else if (!juzgado.equals(other.juzgado)) {
			return false;
		}
		return true;
	}
}