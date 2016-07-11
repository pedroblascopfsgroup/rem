package es.pfsgroup.plugin.recovery.mejoras.acuerdos.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

/**
 * Dto para asuntos. Por el momento la �nica propiedad que se necesita es el id
 * del gestor.
 * 
 * @author pamuller
 * 
 */
public class DtoAcuerdoTermino extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1775644806273657344L;

	private EXTAcuerdo acuerdo;
	private TerminoAcuerdo termino;

	public EXTAcuerdo getAcuerdo() {
		return acuerdo;
	}

	public void setAcuerdo(EXTAcuerdo acuerdo) {
		this.acuerdo = acuerdo;
	}

	public TerminoAcuerdo getTermino() {
		return termino;
	}

	public void setTermino(TerminoAcuerdo termino) {
		this.termino = termino;
	}

}