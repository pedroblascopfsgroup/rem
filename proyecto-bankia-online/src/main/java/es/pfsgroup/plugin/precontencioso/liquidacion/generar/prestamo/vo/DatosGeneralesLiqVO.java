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
	private BigDecimal DGC_CODICE;
	private BigDecimal DGC_IMCGTA;

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
		return DGC_FEFOEZ == null ? "" : fechaLargaFormat.format(DGC_FEFOEZ);
	}

	public String FEVACM() {
		return DGC_FEVACM == null ? "" : fechaLargaFormat.format(DGC_FEVACM);
	}

	public String NOMFED1() {
		return DGC_NOMFED1 == null ? "" : DGC_NOMFED1;
	}

	public String NMPRTO() {
		return DGC_NMPRTO == null ? "" : DGC_NMPRTO;
	}

	public String IDPRIG() {
		return DGC_IDPRIG == null ? "" : DGC_IDPRIG;
	}

	public String COIBTQ() {
		return DGC_COIBTQ == null ? "" : DGC_COIBTQ;
	}

	public String IMDEUD() {
		//Comprobamos si el numero es negativo
		if((DGC_IMDEUD).compareTo(BigDecimal.ZERO) < 0){
			//Si lo es devolvemos el valor absoluto para mostrarlo positivamente
			BigDecimal absNumero = DGC_IMDEUD.abs();
			return NumberFormat.getInstance(new Locale("es", "ES")).format(absNumero);
		}else{
			return NumberFormat.getInstance(new Locale("es", "ES")).format(DGC_IMDEUD);
		}
	}

	public String IMDEUD_LETRAS() {
		String numberInLetters = EXTNumberToLetterConverter.convertNumberToLetter(DGC_IMDEUD.doubleValue());

		if (numberInLetters != null) {
			numberInLetters = numberInLetters.replace("CON", "euros CON");
			return numberInLetters + "céntimos";
		}

		return "";
	}

	public String IMVRE2() {
		return NumberFormat.getInstance(new Locale("es", "ES")).format(DGC_IMVRE2);
	}
	
	public String FFCTTO() {
		return DGC_FFCTTO == null ? "" : fechaLargaFormat.format(DGC_FFCTTO);
	}
	
	public String CODICE(){
		return DGC_CODICE == null ? "" : DGC_CODICE.toString();
	}
	
	public String IMCGTA(){
		//return DGC_IMCGTA == null ? "" : DGC_IMCGTA.toString();
		return NumberFormat.getInstance(new Locale("es", "ES")).format(DGC_IMCGTA);
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
	
	public BigDecimal getDGC_CODICE() {
		return DGC_CODICE;
	}
	
	public BigDecimal getDGC_IMCGTA(){
		return DGC_IMCGTA;
	}
}
