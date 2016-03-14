package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import es.capgemini.devon.utils.MessageUtils;

// 115
public class CabeceraLiquidacionLiqVO {
	private Long CLQ_PCO_LIQ_ID;
	private Date CLQ_FEFCON;
	private BigDecimal CLQ_POINDB;
	private BigDecimal CLQ_IMLIAC;
	private String CLQ_NCTAOP;
	private String CLQ_DESLIQ;
	private Date CLQ_FANTLQ;
	private Date CLQ_FEVALQ;

	private final SimpleDateFormat formatoFechaCorta = new SimpleDateFormat("dd/MM/yyyy", MessageUtils.DEFAULT_LOCALE);
	
	public String NCTAOP() {
		return CLQ_NCTAOP == null ? "" : CLQ_NCTAOP;
	}
	
	public String DESLIQ() {
		return CLQ_DESLIQ == null ? "" : CLQ_DESLIQ;
	}

	public String FEFCON() {
		return formatoFechaCorta.format(CLQ_FEFCON);
	}
	
	public String FANTLQ() {
		return formatoFechaCorta.format(CLQ_FANTLQ);
	}
	
	public String FEVALQ() {
		return formatoFechaCorta.format(CLQ_FEVALQ);
	}

	public String POINDB() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(CLQ_POINDB);
	}

	public String IMLIAC() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(CLQ_IMLIAC);
	}


	/* Getters */

	public BigDecimal getCLQ_POINDB() {
		return CLQ_POINDB;
	}

	public BigDecimal getCLQ_IMLIAC() {
		return CLQ_IMLIAC;
	}
	
	public Date getCLQ_FEFCON() {
		return CLQ_FEFCON;
	}
	
	public Date getCLQ_FANTLQ() {
		return CLQ_FANTLQ;
	}
	
	public Date getCLQ_FEVALQ() {
		return CLQ_FEVALQ;
	}
}
