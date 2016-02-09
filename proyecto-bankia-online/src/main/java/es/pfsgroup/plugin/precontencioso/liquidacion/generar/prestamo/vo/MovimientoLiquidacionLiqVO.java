package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import es.capgemini.devon.utils.MessageUtils;

// 117
public class MovimientoLiquidacionLiqVO {
	private Long MLQ_PCO_LIQ_ID;
	private Date MLQ_FECHAO;
	private Date MLQ_FECHAV;
	private String MLQ_CNCORT;
	private String MLQ_IMMOVY;
	private String MLQ_CASALY;
	private String MLQ_CADISY;
	private String MLQ_CANUDY;
	private String MLQ_CANUCY;
	private String MLQ_CANUEY;

	private final SimpleDateFormat formatoFechaCorta = new SimpleDateFormat("dd/MM/yyyy", MessageUtils.DEFAULT_LOCALE);

	public String FECHAO() {
		return formatoFechaCorta.format(MLQ_FECHAO);
	}
	
	public String FECHAV() {
		return formatoFechaCorta.format(MLQ_FECHAV);
	}
	
	public String IMMOVY() {
		return MLQ_IMMOVY == null ? "[NO DISPONIBLE]" : MLQ_IMMOVY;
	}
	
	public String CASALY() {
		return MLQ_CASALY == null ? "[NO DISPONIBLE]" : MLQ_CASALY;
	}
	
	public String CADISY() {
		return MLQ_CADISY == null ? "[NO DISPONIBLE]" : MLQ_CADISY;
	}
	
	public String CNCORT() {
		return MLQ_CNCORT == null ? "[NO DISPONIBLE]" : MLQ_CNCORT;
	}

	public String CANUDY() {
		return MLQ_CANUDY == null ? "[NO DISPONIBLE]" : MLQ_CANUDY;
	}
	public String CANUCY() {
		return MLQ_CANUCY == null ? "[NO DISPONIBLE]" : MLQ_CANUCY;
	}
	public String CANUEY() {
		return MLQ_CANUEY == null ? "[NO DISPONIBLE]" : MLQ_CANUEY;
	}

	/* Getters */

	public Date getMLQ_FECHAO() {
		return MLQ_FECHAO;
	}
	
	public Date getMLQ_FECHAV() {
		return MLQ_FECHAV;
	}
}
