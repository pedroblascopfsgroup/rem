package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

// 113
public class CabeceraExpedienteLiqVO {
	private Long CEL_PCO_LIQ_ID;
	private BigDecimal CEL_COEXPD;
	private String CEL_NOMBRE;
	private BigDecimal CEL_NUCTOP;
	private BigDecimal CEL_IMLIAC;
	private String CEL_NCTAOP;

	public String COEXPD() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(CEL_COEXPD);
	}
	
	public String NOMBRE() {
		return CEL_NOMBRE == null ? "[NO DISPONIBLE]" : CEL_NOMBRE;
	}

	public String NUCTOP() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(CEL_NUCTOP);
	}
	
	public String IMLIAC() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(CEL_IMLIAC);
	}
	
	public String NCTAOP() {
		return CEL_NCTAOP == null ? "[NO DISPONIBLE]" : CEL_NCTAOP;
	}

	/* Getters */

	public BigDecimal getCEL_COEXPD() {
		return CEL_COEXPD;
	}
	
	public BigDecimal getCEL_NUCTOP() {
		return CEL_NUCTOP;
	}

	public BigDecimal getCEL_IMLIAC() {
		return CEL_IMLIAC;
	}
}
