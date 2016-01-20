package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.recovery.ext.impl.utils.EXTNumberToLetterConverter;

public class DatosGeneralesLiqVO {
	private Long DGC_PCO_LIQ_ID;
	private String DGC_IDPRIG;
	private Date DGC_FEVACM;
	private BigDecimal DGC_IMCCNS;
	private BigDecimal DGC_IMCPAM;
	private Date DGC_FEFOEZ;
	private String DGC_NOMFED1;
	private BigDecimal DGC_IMDEUD;
	private String DGC_NMPRTO;
	private String DGC_COIBTQ;
	private BigDecimal DGC_IMVRE2;
	private Date DGC_FFCTTO;

	SimpleDateFormat fechaLargaFormat = new SimpleDateFormat(FormatUtils.DD_DE_MES_DE_YYYY, MessageUtils.DEFAULT_LOCALE);

	/*
	 * FORMAT ATRIBUTES
	 */

	public String IMCCNS() {
		return NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(DGC_IMCCNS);
	}

	public String IMCPAM() {
		return NumberFormat.getCurrencyInstance(new Locale("es", "ES")).format(DGC_IMCPAM);
	}

	public String FEFOEZ() {
		return fechaLargaFormat.format(DGC_FEFOEZ);
	}

	public String FEVACM() {
		return fechaLargaFormat.format(DGC_FEVACM);
	}

	public String NOMFED1() {
		return DGC_NOMFED1 == null ? "[NO DISPONIBLE]" : DGC_NOMFED1;
	}

	public String NMPRTO() {
		return DGC_NMPRTO == null ? "[NO DISPONIBLE]" : DGC_NMPRTO;
	}

	public String IDPRIG() {
		return DGC_IDPRIG == null ? "[NO DISPONIBLE]" : DGC_IDPRIG;
	}

	public String COIBTQ() {
		return DGC_COIBTQ == null ? "[NO DISPONIBLE]" : DGC_COIBTQ;
	}

	public String IMDEUD() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(DGC_IMDEUD);
	}

	public String IMDEUD_LETRAS() {
		String numberInLetters = EXTNumberToLetterConverter.convertNumberToLetter(DGC_IMDEUD.doubleValue());

		if (numberInLetters != null) {
			numberInLetters = numberInLetters.replace("CON", "euros CON");
			return numberInLetters + "céntimos";
		}

		return "NO DISPONIBLE";
	}

	public String IMVRE2() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(DGC_IMVRE2);
	}
	
	public String FFCTTO() {
		return fechaLargaFormat.format(DGC_FFCTTO);
	}

	/*
	 * GETTERS WITHOUT FORMAT MANIPULATION
	 */

	public Date getDGC_FEFOEZ() {
		return DGC_FEFOEZ;
	}

	public BigDecimal getDGC_IMCCNS() {
		return DGC_IMCCNS;
	}

	public BigDecimal getDGC_IMCPAM() {
		return DGC_IMCPAM;
	}

	public Date getDGC_FEVACM() {
		return DGC_FEVACM;
	}
	
	public BigDecimal getDGC_IMVRE2() {
		return DGC_IMVRE2;
	}
}
