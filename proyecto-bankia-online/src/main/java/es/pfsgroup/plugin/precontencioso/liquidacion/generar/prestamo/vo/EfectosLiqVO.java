package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import es.capgemini.devon.utils.MessageUtils;

// LQ05
public class EfectosLiqVO {
	private Long DEF_PCO_LIQ_ID;
	private String DEF_IDRECV;
	private String DEF_TIPOEF;
	private String DEF_NOLIB9;
	private Date DEF_FEVCTR;
	private Date DEF_FEREAM;
	private BigDecimal DEF_IMCPRC;
	private BigDecimal DEF_IDEGPR;
	private BigDecimal DEF_IDEOTG;
	private BigDecimal DEF_CDINTS;
	private BigDecimal DEF_IMPRTV;
	private BigDecimal DEF_IMDEUD;

	private final SimpleDateFormat formatoFechaCorta = new SimpleDateFormat("dd/MM/yyyy", MessageUtils.DEFAULT_LOCALE);

	public String IDRECV() {
		return DEF_IDRECV == null ? "" : DEF_IDRECV;
	}
	
	public String TIPOEF() {
		return DEF_TIPOEF == null ? "" : DEF_TIPOEF;
	}
	
	public String FEVCTR() {
		return formatoFechaCorta.format(DEF_FEVCTR);
	}
	
	public String FEREAM() {
		return formatoFechaCorta.format(DEF_FEREAM);
	}
	
	public String IMCPRC() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(DEF_IMCPRC);
	}
	
	public String IDEGPR() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(DEF_IDEGPR);
	}
	
	public String IDEOTG() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(DEF_IDEOTG);
	}
	
	public String CDINTS() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(DEF_CDINTS);
	}
	
	public String IMPRTV() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(DEF_IMPRTV);
	}
	
	public String IMDEUD() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(DEF_IMDEUD);
	}
	
	public String NOLIB9() {
		return DEF_IDRECV == null ? "" : DEF_NOLIB9;
	}
	
	/* Getters */

	public BigDecimal getDEF_IMCPRC() {
		return DEF_IMCPRC;
	}

	public BigDecimal getDEF_IDEGPR() {
		return DEF_IDEGPR;
	}

	public BigDecimal getDEF_IDEOTG() {
		return DEF_IDEOTG;
	}

	public BigDecimal getDEF_CDINTS() {
		return DEF_CDINTS;
	}

	public BigDecimal getDEF_IMPRTV() {
		return DEF_IMPRTV;
	}

	public BigDecimal getDEF_IMDEUD() {
		return DEF_IMDEUD;
	}

	public Date getDEF_FEVCTR() {
		return DEF_FEVCTR;
	}
	
	public Date getDEF_FEREAM() {
		return DEF_FEREAM;
	}	
}
