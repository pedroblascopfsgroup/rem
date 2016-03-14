package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import es.capgemini.devon.utils.MessageUtils;

// LQ04
public class RecibosLiqVO {
	private Long RCB_PCO_LIQ_ID;
	private String RCB_IDRECV;
	private Date RCB_FEVCTR;
	private BigDecimal RCB_CDINTS;
	private BigDecimal RCB_CDINTM;
	private BigDecimal RCB_IMCPRC;
	private BigDecimal RCB_IMPRTV;
	private BigDecimal RCB_IMCGTA;
	private BigDecimal RCB_IMINDR;
	private BigDecimal RCB_IMBIM4;
	private BigDecimal RCB_IMDEUD;

	private final SimpleDateFormat formatoFechaCorta = new SimpleDateFormat("dd/MM/yyyy", MessageUtils.DEFAULT_LOCALE);

	public String IDRECV() {

		// Para los registros 00999 se pinta vacio
		if ("00999".equals(RCB_IDRECV)) {
			return "";
		}

		return RCB_IDRECV == null ? "" : RCB_IDRECV;
	}

	public String FEVCTR() {
		return formatoFechaCorta.format(RCB_FEVCTR);
	}

	public String CDINTS() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(RCB_CDINTS);
	}

	public String CDINTM() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(RCB_CDINTM);
	}

	public String IMCPRC() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(RCB_IMCPRC);
	}

	public String IMPRTV() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(RCB_IMPRTV);
	}

	public String IMCGTA() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(RCB_IMCGTA);
	}

	public String IMINDR() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(RCB_IMINDR);
	}

	public String IMBIM4() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(RCB_IMBIM4);
	}

	public String IMDEUD() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(RCB_IMDEUD);
	}

	/* Getters */

	public BigDecimal getRCB_CDINTM() {
		return RCB_CDINTM;
	}

	public BigDecimal getRCB_CDINTS() {
		return RCB_CDINTS;
	}

	public BigDecimal getRCB_IMCPRC() {
		return RCB_IMCPRC;
	}

	public BigDecimal getRCB_IMPRTV() {
		return RCB_IMPRTV;
	}

	public BigDecimal getRCB_IMCGTA() {
		return RCB_IMCGTA;
	}

	public BigDecimal getRCB_IMINDR() {
		return RCB_IMINDR;
	}

	public BigDecimal getRCB_IMBIM4() {
		return RCB_IMBIM4;
	}

	public BigDecimal getRCB_IMDEUD() {
		return RCB_IMDEUD;
	}

	public Date getRCB_FEVCTR() {
		return RCB_FEVCTR;
	}
}
