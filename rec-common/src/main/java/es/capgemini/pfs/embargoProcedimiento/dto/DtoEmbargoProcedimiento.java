package es.capgemini.pfs.embargoProcedimiento.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.embargoProcedimiento.model.EmbargoProcedimiento;

/**
 * Creado el Thu Jan 08 09:32:17 CET 2009.
 *
 * @author: Lisandro Medrano
 */
public class DtoEmbargoProcedimiento extends WebDto {
	/**
	 * serialVersionUID.
	 */
	private static final long serialVersionUID = 2824790152788519236L;
	private EmbargoProcedimiento embargoProcedimiento;
	private Long idProcedimiento;
	/**
	 * @return the embargoProcedimiento
	 */
	public EmbargoProcedimiento getEmbargoProcedimiento() {
		return embargoProcedimiento;
	}
	/**
	 * @param embargoProcedimiento the embargoProcedimiento to set
	 */
	public void setEmbargoProcedimiento(EmbargoProcedimiento embargoProcedimiento) {
		this.embargoProcedimiento = embargoProcedimiento;
	}
	/**
	 * @return the idProcedimiento
	 */
	public Long getIdProcedimiento() {
		return idProcedimiento;
	}
	/**
	 * @param idProcedimiento the idProcedimiento to set
	 */
	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

}
