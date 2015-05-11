package es.pfsgroup.recovery.ext.impl.tareas;

import javax.persistence.Column;
import javax.persistence.Entity;

import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;

@Entity
public class EXTTareaExternaValor extends TareaExternaValor{
	
	private static final long serialVersionUID = 9213884805981225959L;
	
	private static final int MAX_SIZE_VALOR_CORTO = 255;

	@Column(name = "TEV_VALOR_CLOB")
	private String valorLargo;

	/*
	 * Si el valor de la clase padre esta relleno devolvemos su valor, sino devolvemos 
	 * el de la clase extendida
	 */
	
	public String getValorLargo() {
		return valorLargo;
	}
 
	
	public void setValorLargo(String v) {
		this.valorLargo = v;
	}

	@Override
	public void setValor(String v) {
		if (Checks.esNulo(v))
			return;
		
		if (MAX_SIZE_VALOR_CORTO < v.length()){
			super.setValor(null);
			this.valorLargo = v;
		}else{
			super.setValor(v);
		}
	}
	
	@Override
	public String getValor() {
		if (super.getValor() != null && !"".equals(super.getValor())){
			return super.getValor();
		}else{
			return valorLargo;
		}
	}
}
