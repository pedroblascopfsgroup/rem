package es.pfsgroup.plugin.rem.model;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * 
 * Dto para enviar los datos de la visita al webservice de Salesforce
 *
 */
@XmlRootElement
public class DtoLeadVisita {
	
	private DtoLeadVisitaAttributes attributes;
	
	private String CANAL_WEB_ENTRADA__c = "X002";  // Campo obligatorio , no cambiar valor
	private int MEDIO_INTERNET__c = 6;  // Campo obligatorio , no cambiar valor
	private boolean HAY_Es_llamada__c = false;  // Campo obligatorio , no cambiar valor
	private int CODPCE__c;
	private int COD_ID_ACTIVO_ESP__c;
	private String PRIMER_APELLIDO__c;
	private String NUM_TELEFONO__c;
	private String MAIL__c;
	private boolean HAY_Es_Portal__c = true; // Campo obligatorio , no cambiar valor
	private boolean HAY_NoProcesar__c = true; // Campo obligatorio , no cambiar valor

	public DtoLeadVisita (DtoAltaVisita dto) {
		System.out.println("Constructor 1");
		this.setCOD_ID_ACTIVO_ESP__c(dto.getIdActivo().intValue());
		this.setPRIMER_APELLIDO__c(dto.getNombre());
		this.setNUM_TELEFONO__c(dto.getTelefono());
		
		String email = dto.getEmail();
		if (dto.getObservaciones() != null) {
			email = email.concat(dto.getObservaciones());
		}
		this.setMAIL__c(email);
		
		DtoLeadVisitaAttributes attributes = new DtoLeadVisitaAttributes();
		this.setAttributes(attributes);
		
		System.out.println("Constructor 2");
	}
	
	public DtoLeadVisita () {
		
	}
	/**
	public String toBodyString() {
		System.out.println("Constructor 3");
		ObjectMapper mapper = new ObjectMapper();
		try {
			System.out.println("Constructor 4");
			return mapper.writeValueAsString(this);
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Constructor 5");
		return null;
	}
	*/
	public DtoLeadVisitaAttributes getAttributes() {
		return attributes;
	}

	public void setAttributes(DtoLeadVisitaAttributes attributes) {
		this.attributes = attributes;
	}

	public String getCANAL_WEB_ENTRADA__c() {
		return CANAL_WEB_ENTRADA__c;
	}

	public void setCANAL_WEB_ENTRADA__c(String cANAL_WEB_ENTRADA__c) {
		CANAL_WEB_ENTRADA__c = cANAL_WEB_ENTRADA__c;
	}

	public int getMEDIO_INTERNET__c() {
		return MEDIO_INTERNET__c;
	}

	public void setMEDIO_INTERNET__c(int mEDIO_INTERNET__c) {
		MEDIO_INTERNET__c = mEDIO_INTERNET__c;
	}

	public boolean isHAY_Es_llamada__c() {
		return HAY_Es_llamada__c;
	}

	public void setHAY_Es_llamada__c(boolean hAY_Es_llamada__c) {
		HAY_Es_llamada__c = hAY_Es_llamada__c;
	}

	public int getCODPCE__c() {
		return CODPCE__c;
	}

	public void setCODPCE__c(int cODPCE__c) {
		CODPCE__c = cODPCE__c;
	}

	public int getCOD_ID_ACTIVO_ESP__c() {
		return COD_ID_ACTIVO_ESP__c;
	}

	public void setCOD_ID_ACTIVO_ESP__c(int cOD_ID_ACTIVO_ESP__c) {
		COD_ID_ACTIVO_ESP__c = cOD_ID_ACTIVO_ESP__c;
	}

	public String getPRIMER_APELLIDO__c() {
		return PRIMER_APELLIDO__c;
	}

	public void setPRIMER_APELLIDO__c(String pRIMER_APELLIDO__c) {
		PRIMER_APELLIDO__c = pRIMER_APELLIDO__c;
	}

	public String getNUM_TELEFONO__c() {
		return NUM_TELEFONO__c;
	}

	public void setNUM_TELEFONO__c(String nUM_TELEFONO__c) {
		NUM_TELEFONO__c = nUM_TELEFONO__c;
	}

	public String getMAIL__c() {
		return MAIL__c;
	}

	public void setMAIL__c(String mAIL__c) {
		MAIL__c = mAIL__c;
	}

	public boolean isHAY_Es_Portal__c() {
		return HAY_Es_Portal__c;
	}

	public void setHAY_Es_Portal__c(boolean hAY_Es_Portal__c) {
		HAY_Es_Portal__c = hAY_Es_Portal__c;
	}

	public boolean isHAY_NoProcesar__c() {
		return HAY_NoProcesar__c;
	}

	public void setHAY_NoProcesar__c(boolean hAY_NoProcesar__c) {
		HAY_NoProcesar__c = hAY_NoProcesar__c;
	}
	
	

}
