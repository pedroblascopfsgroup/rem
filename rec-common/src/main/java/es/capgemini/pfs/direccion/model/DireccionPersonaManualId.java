package es.capgemini.pfs.direccion.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class DireccionPersonaManualId implements Serializable {
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((dirId == null) ? 0 : dirId.hashCode());
		result = prime * result + ((pemId == null) ? 0 : pemId.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		DireccionPersonaManualId other = (DireccionPersonaManualId) obj;
		if (dirId == null) {
			if (other.dirId != null)
				return false;
		} else if (!dirId.equals(other.dirId))
			return false;
		if (pemId == null) {
			if (other.pemId != null)
				return false;
		} else if (!pemId.equals(other.pemId))
			return false;
		return true;
	}

	private static final long serialVersionUID = 2736381971094731344L;

	@Column(name = "DIR_ID")
	private Long dirId;
	
	@Column(name = "PEM_ID")
	private Long pemId;

	public Long getDirId() {
		return dirId;
	}

	public void setDirId(Long dirId) {
		this.dirId = dirId;
	}

	public Long getPemId() {
		return pemId;
	}

	public void setPemId(Long pemId) {
		this.pemId = pemId;
	}

	public DireccionPersonaManualId(Long dirId, Long pemId) {
		super();
		this.dirId = dirId;
		this.pemId = pemId;
	}

}
