package es.capgemini.pfs.direccion.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;

@Embeddable
public class DireccionPersonaId implements Serializable {
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((dirId == null) ? 0 : dirId.hashCode());
		result = prime * result + ((perId == null) ? 0 : perId.hashCode());
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
		DireccionPersonaId other = (DireccionPersonaId) obj;
		if (dirId == null) {
			if (other.dirId != null)
				return false;
		} else if (!dirId.equals(other.dirId))
			return false;
		if (perId == null) {
			if (other.perId != null)
				return false;
		} else if (!perId.equals(other.perId))
			return false;
		return true;
	}

	private static final long serialVersionUID = 2736381971094731344L;

	@Column(name = "DIR_ID")
	private Long dirId;
	
	@Column(name = "PER_ID")
	private Long perId;

	public Long getDirId() {
		return dirId;
	}

	public void setDirId(Long dirId) {
		this.dirId = dirId;
	}

	public Long getPerId() {
		return perId;
	}

	public void setPerId(Long perId) {
		this.perId = perId;
	}

	public DireccionPersonaId(Long dirId, Long perId) {
		super();
		this.dirId = dirId;
		this.perId = perId;
	}

	public DireccionPersonaId() {
	}

}
