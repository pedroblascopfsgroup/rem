package es.capgemini.pfs.contrato.model;

import javax.persistence.Column;
import javax.persistence.Entity;

import org.hibernate.annotations.Formula;

import es.capgemini.pfs.APPConstants;

@Entity
public class EXTContrato extends Contrato  {

	private static final long serialVersionUID = -4430015010175105253L;
	
	@Column(name = "CONTRATO_PADRE_NIVEL_2")
    private Long contratoPadreNivel2;
    	
  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.NUM_EXTRA4 + "'))")
  	private String numextra4;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.NUM_EXTRA5 + "'))")
  	private String numextra5;
  	
  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.NUM_EXTRA6 + "'))")
  	private String numextra6;
  	
  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.NUM_EXTRA7 + "'))")
  	private String numextra7;
  	
  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.NUM_EXTRA8 + "'))")
  	private String numextra8;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.DATE_EXTRA2 + "'))")
  	private String dateextra2;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.DATE_EXTRA3 + "'))")
  	private String dateextra3;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.DATE_EXTRA4 + "'))")
  	private String dateextra4;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.DATE_EXTRA5 + "'))")
  	private String dateextra5;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.DATE_EXTRA6 + "'))")
  	private String dateextra6;
  	
  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.DATE_EXTRA7 + "'))")
  	private String dateextra7;
  	
  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.DATE_EXTRA9 + "'))")
  	private String dateextra9;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA9 + "'))")
  	private String charextra9;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.CHAR_EXTRA10 + "'))")
  	private String charextra10;

  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.FLAG_EXTRA4 + "'))")
  	private String flagextra4;
  	
  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.FLAG_EXTRA5 + "'))")
  	private String flagextra5;
  	
  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.FLAG_EXTRA6 + "'))")
  	private String flagextra6;
  	
  	@Formula("(select iac.iac_value from ext_iac_info_add_contrato iac where iac.cnt_id = cnt_id "
  			+ "  and iac.dd_ifc_id = ("
  			+ "select ifc.dd_ifc_id from ext_dd_ifc_info_contrato ifc where ifc.dd_ifc_codigo = '"
  			+ APPConstants.FLAG_EXTRA7 + "'))")
  	private String flagextra7;

	/**
	 * @return the contratoPadreNivel2
	 */
	public Long getContratoPadreNivel2() {
		return contratoPadreNivel2;
	}

	/**
	 * @param contratoPadreNivel2 the contratoPadreNivel2 to set
	 */
	public void setContratoPadreNivel2(Long contratoPadreNivel2) {
		this.contratoPadreNivel2 = contratoPadreNivel2;
	}

	/**
	 * @return the numextra4
	 */
	public String getNumextra4() {
		return numextra4;
	}

	/**
	 * @param numextra4 the numextra4 to set
	 */
	public void setNumextra4(String numextra4) {
		this.numextra4 = numextra4;
	}

	/**
	 * @return the numextra5
	 */
	public String getNumextra5() {
		return numextra5;
	}

	/**
	 * @param numextra5 the numextra5 to set
	 */
	public void setNumextra5(String numextra5) {
		this.numextra5 = numextra5;
	}

	/**
	 * @return the dateextra2
	 */
	public String getDateextra2() {
		return dateextra2;
	}

	/**
	 * @param dateextra2 the dateextra2 to set
	 */
	public void setDateextra2(String dateextra2) {
		this.dateextra2 = dateextra2;
	}

	/**
	 * @return the dateextra3
	 */
	public String getDateextra3() {
		return dateextra3;
	}

	/**
	 * @param dateextra3 the dateextra3 to set
	 */
	public void setDateextra3(String dateextra3) {
		this.dateextra3 = dateextra3;
	}

	/**
	 * @return the dateextra4
	 */
	public String getDateextra4() {
		return dateextra4;
	}

	/**
	 * @param dateextra4 the dateextra4 to set
	 */
	public void setDateextra4(String dateextra4) {
		this.dateextra4 = dateextra4;
	}

	/**
	 * @return the dateextra5
	 */
	public String getDateextra5() {
		return dateextra5;
	}

	/**
	 * @param dateextra5 the dateextra5 to set
	 */
	public void setDateextra5(String dateextra5) {
		this.dateextra5 = dateextra5;
	}

	/**
	 * @return the dateextra6
	 */
	public String getDateextra6() {
		return dateextra6;
	}

	/**
	 * @param dateextra6 the dateextra6 to set
	 */
	public void setDateextra6(String dateextra6) {
		this.dateextra6 = dateextra6;
	}

	/**
	 * @return the charextra9
	 */
	public String getCharextra9() {
		return charextra9;
	}

	/**
	 * @param charextra9 the charextra9 to set
	 */
	public void setCharextra9(String charextra9) {
		this.charextra9 = charextra9;
	}

	/**
	 * @return the charextra10
	 */
	public String getCharextra10() {
		return charextra10;
	}

	/**
	 * @param charextra10 the charextra10 to set
	 */
	public void setCharextra10(String charextra10) {
		this.charextra10 = charextra10;
	}

	/**
	 * @return the flagextra4
	 */
	public String getFlagextra4() {
		return flagextra4;
	}

	/**
	 * @param flagextra4 the flagextra4 to set
	 */
	public void setFlagextra4(String flagextra4) {
		this.flagextra4 = flagextra4;
	}

	public String getNumextra6() {
		return numextra6;
	}

	public void setNumextra6(String numextra6) {
		this.numextra6 = numextra6;
	}

	public String getNumextra7() {
		return numextra7;
	}

	public void setNumextra7(String numextra7) {
		this.numextra7 = numextra7;
	}

	public String getNumextra8() {
		return numextra8;
	}

	public void setNumextra8(String numextra8) {
		this.numextra8 = numextra8;
	}

	public String getDateextra7() {
		return dateextra7;
	}

	public void setDateextra7(String dateextra7) {
		this.dateextra7 = dateextra7;
	}

	public String getFlagextra5() {
		return flagextra5;
	}

	public void setFlagextra5(String flagextra5) {
		this.flagextra5 = flagextra5;
	}

	public String getFlagextra6() {
		return flagextra6;
	}

	public void setFlagextra6(String flagextra6) {
		this.flagextra6 = flagextra6;
	}
	
	public String getFlagextra7() {
		return flagextra7;
	}

	public void setFlagextra7(String flagextra7) {
		this.flagextra7 = flagextra7;
	}

	public String getDateextra9() {
		return dateextra9;
	}

	public void setDateextra9(String dateextra9) {
		this.dateextra9 = dateextra9;
	}
	
}
