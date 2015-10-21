package es.capgemini.pfs.procesosJudiciales.model;

import javax.persistence.Column;
import javax.persistence.Entity;

@Entity
public class EXTTareaExterna extends TareaExterna implements EXTTareaExternaInfo{
	
	
	private static final long serialVersionUID = 3557767405463034995L;
	
	@Column(name="TEX_NUM_AUTOP")
	private Integer numeroAutoprorrogas;

//	@Override
//	public EXTTareaProcedimiento getTareaProcedimiento(){
//		HeritableEntity h = new HeritableEntity(super.getTareaProcedimiento());
//		return h.getInerited(EXTTareaProcedimiento.class);
//	}

	@Override
	public Integer getNumeroAutoprorrogas() {
		return numeroAutoprorrogas;
	}
	
	public void setNumeroAutoprorrogas(Integer numeroAutoprorrogas){
		this.numeroAutoprorrogas=numeroAutoprorrogas;
	}

}
