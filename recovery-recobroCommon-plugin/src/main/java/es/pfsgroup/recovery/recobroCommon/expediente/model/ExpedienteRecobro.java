package es.pfsgroup.recovery.recobroCommon.expediente.model;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.PrimaryKeyJoinColumn;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.expediente.model.Expediente;

@Entity
@Table(name = "EXR_EXPEDIENTE_RECOBRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@PrimaryKeyJoinColumn(name = "EXP_ID")
public class ExpedienteRecobro extends Expediente implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@OneToMany(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "EXP_ID")
	private List<CicloRecobroExpediente> ciclosRecobro;

	public List<CicloRecobroExpediente> getCiclosRecobro() {
		return ciclosRecobro;
	}

	public void setCiclosRecobro(List<CicloRecobroExpediente> ciclosRecobro) {
		this.ciclosRecobro = ciclosRecobro;
	}

	public CicloRecobroExpediente getCicloRecobroActivo() {
		if (this.ciclosRecobro != null && this.ciclosRecobro.size() > 0){
			for (CicloRecobroExpediente cre :ciclosRecobro){
				if (cre.getFechaBaja() == null){
					return cre;
				}
			}
		}
		return null;
	}

}
