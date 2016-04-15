package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import es.capgemini.devon.utils.MessageUtils;

//EC05
public class DescubiertoLiqVO {
	private Long CPL_PCO_LIQ_ID;
	private BigDecimal CPL_COEAAH;
	private BigDecimal CPL_COCAAH;
	private BigDecimal CPL_NUDCAH;
	private BigDecimal CPL_NUCTAH;
	private BigDecimal CPL_SAANAH;
	private BigDecimal CPL_COCPAH;
	private BigDecimal CPL_IDPRAH;
	private BigDecimal CPL_IMMOAH;
	private BigDecimal CPL_SAPOAH;
	private Date CPL_FVVAAH;
	private Date CPL_FEOCAH;
	private String CPL_NOCOAH;

	SimpleDateFormat fechaCortaFormat = new SimpleDateFormat("dd/MM/yyyy", MessageUtils.DEFAULT_LOCALE);
	
	public String COEAAH() {
		return CPL_COEAAH == null ? "" : CPL_COEAAH.toString();
	}
	
	public String COCAAH() {
		return CPL_COCAAH == null ? "" : CPL_COCAAH.toString();
	}
	
	public String NUDCAH() {
		return CPL_NUDCAH == null ? "" : CPL_NUDCAH.toString();
	}
	
	public String NUCTAH() {
		return CPL_NUCTAH == null ? "" : CPL_NUCTAH.toString();
	}
	
	public String SAANAH() {
		return CPL_SAANAH == null ? "" : NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(CPL_SAANAH);
	}
	
	public String COCPAH() {
		return CPL_COCPAH == null ? "" : CPL_COCPAH.toString();
	}
	
	public String IDPRAH() {
		return CPL_IDPRAH == null ? "" : CPL_IDPRAH.toString();
	}
	
	public String IMMOAH() {
		return CPL_IMMOAH == null ? "" : NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(CPL_IMMOAH);
	}
	
	public String SAPOAH() {
		return CPL_SAPOAH == null ? "" : NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(CPL_SAPOAH);
	}

	public String FVVAAH() {
		return CPL_FVVAAH == null ? "" : fechaCortaFormat.format(CPL_FVVAAH);
	}
	
	public String FEOCAH() {
		return CPL_FEOCAH == null ? "" : fechaCortaFormat.format(CPL_FEOCAH);
	}

	public String NOCOAH() {
		return CPL_NOCOAH == null ? "" : CPL_NOCOAH.toString();
	}
	
}
