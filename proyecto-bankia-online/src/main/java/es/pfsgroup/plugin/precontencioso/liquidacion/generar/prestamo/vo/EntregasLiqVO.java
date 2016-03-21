package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import es.capgemini.devon.utils.MessageUtils;

// LQ06
public class EntregasLiqVO {
	private Long ECL_PCO_LIQ_ID;
	private Date ECL_FEDOEN;
	private Date ECL_FEREAM;
	private BigDecimal ECL_IMENOP;
	private BigDecimal ECL_CDINTS;
	private BigDecimal ECL_IMINEO;
	private BigDecimal ECL_IMDEUD;

	private final SimpleDateFormat formatoFechaCorta = new SimpleDateFormat("dd/MM/yyyy", MessageUtils.DEFAULT_LOCALE);
	
	public String FEDOEN() {
		return ECL_FEDOEN == null ? "" : formatoFechaCorta.format(ECL_FEDOEN);
	}
	
	public String FEREAM() {
		return ECL_FEREAM == null ? "" : formatoFechaCorta.format(ECL_FEREAM);
	}
	
	public String IMENOP() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(ECL_IMENOP);
	}
	
	public String IMINEO() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(ECL_IMINEO);
	}
	
	
	public String CDINTS() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(ECL_CDINTS);
	}
	
	public String IMDEUD() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(ECL_IMDEUD);
	}
	
	
	/* Getters */

	public BigDecimal getECL_IMENOP() {
		return ECL_IMENOP;
	}

	public BigDecimal getECL_IMINEO() {
		return ECL_IMINEO;
	}

	public BigDecimal getECL_CDINTS() {
		return ECL_CDINTS;
	}

	public BigDecimal getECL_IMDEUD() {
		return ECL_IMDEUD;
	}

	public Date getECL_FEDOEN() {
		return ECL_FEDOEN;
	}
	
	public Date getECL_FEREAM() {
		return ECL_FEREAM;
	}	
}
