package es.pfsgroup.plugin.precontencioso.liquidacion.vo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import es.capgemini.devon.utils.MessageUtils;

public class ConceptoLiqVO {
	private Date fecha;
	private String concepto;
	private BigDecimal debe;
	private BigDecimal haber;
	private BigDecimal saldo;

	SimpleDateFormat fechaCortaFormat = new SimpleDateFormat("dd/MM/yyyy", MessageUtils.DEFAULT_LOCALE);

	public ConceptoLiqVO(Date fecha, String concepto, BigDecimal debe, BigDecimal haber, BigDecimal saldo) {
		super();
		this.fecha = fecha;
		this.concepto = concepto;
		this.debe = debe;
		this.haber = haber;
		this.saldo = saldo;
	}

	public String FECHA() {
		return fechaCortaFormat.format(fecha);
	}

	public String CONCEPTO() {
		return concepto;
	}

	public String DEBE() {
		return debe != null ? NumberFormat.getInstance(new Locale("es", "ES")).format(debe) : "";
	}

	public String HABER() {
		return haber != null ? NumberFormat.getInstance(new Locale("es", "ES")).format(haber) : "";
	}

	public String SALDO() {
		return saldo != null ? NumberFormat.getInstance(new Locale("es", "ES")).format(saldo) : "";
	}
}
