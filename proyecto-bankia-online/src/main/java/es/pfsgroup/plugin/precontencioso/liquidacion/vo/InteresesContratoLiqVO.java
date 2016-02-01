package es.pfsgroup.plugin.precontencioso.liquidacion.vo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import es.capgemini.devon.utils.MessageUtils;

// LQ07
public class InteresesContratoLiqVO {
	private Long INC_PCO_LIQ_ID;
	private Date INC_FEPTDE;
	private Date INC_FEPTHA;
	private BigDecimal INC_CDINTS;

	private final SimpleDateFormat formatoFechaCorta = new SimpleDateFormat("dd/MM/yyyy", MessageUtils.DEFAULT_LOCALE);

	public String CDINTS() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(INC_CDINTS);
	}
	
	public String FEPTDE() {
		return formatoFechaCorta.format(INC_FEPTDE);
	}

	public String FEPTHA() {
		return formatoFechaCorta.format(INC_FEPTHA);
	}
}
