package es.pfsgroup.plugin.rem.model;

/**
 * Dto para el comprador del webService de Bankia (ursus)
 * @author Luis Caballero
 *
 */
public class DtoClienteUrsus {
	
	public final static String DNI= "1";
	public final static String CIF= "2";
	public final static String TARJETA_RESIDENTE= "3";
	public final static String PASAPORTE= "4";
	public final static String CIF_EXTRANJERO= "5";
	public final static String DNI_EXTRANJERO= "6";
	public final static String TARJETA_DIPLOMATICA= "7";
	public final static String MENOR= "8";
	public final static String OTROS_PERSONA_FISICA= "F";
	public final static String OTROS_PESONA_JURIDICA= "J";
	
	public final static String ENTIDAD_REPRESENTADA_BANKIA= "00000";
	public final static String ENTIDAD_REPRESENTADA_BANKIA_HABITAT= "05021";
	
	
    public String numDocumento;
	public String tipoDocumento;
	public String qcenre;
	
	
	public String getNumDocumento() {
		return numDocumento;
	}
	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
	}
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getQcenre() {
		return qcenre;
	}
	public void setQcenre(String qcenre) {
		this.qcenre = qcenre;
	}
	
	
    
}