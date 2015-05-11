package es.pfsgroup.plugin.recovery.mejoras.procedimiento;

import javax.persistence.Column;
import javax.persistence.Entity;

import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

@Entity
public class MEJTipoProcedimiento extends TipoProcedimiento{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6180762755455206110L;
	
	
	@Column(name="FLAG_PRORROGA")
	private boolean flagProrroga;

	public boolean isFlagProrroga() {
		return flagProrroga;
	}

	public void setFlagProrroga(boolean flagProrroga) {
		this.flagProrroga = flagProrroga;
	}

}
