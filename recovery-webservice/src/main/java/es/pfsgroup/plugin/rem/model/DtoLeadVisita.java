package es.pfsgroup.plugin.rem.model;

import org.codehaus.jackson.map.ObjectMapper;

/**
 * 
 * Dto para enviar los datos de la visita al webservice de Salesforce
 *
 */
public class DtoLeadVisita {

	private class Attributes {
		
		private String type = "HAY_LOAD_VISITAS__c"; // Campo obligatorio , se omite seter
		private int referenceId;
		
		public String getType() {
			return type;
		}

		public int getReferenceId() {
			return referenceId;
		}
		public void setReferenceId(int referenceId) {
			this.referenceId = referenceId;
		}
		
	}
	
	private Attributes attributes;
	
	private String CANAL_WEB_ENTRADA__c = "X002";  // Campo obligatorio , se omite seter
	private int MEDIO_INTERNET__c = 6;  // Campo obligatorio , se omite seter
	private boolean HAY_Es_llamada__c = false;  // Campo obligatorio , se omite seter
	private int CODPCE__c;
	private int COD_ID_ACTIVO_ESP__c;
	private String PRIMER_APELLIDO__c;
	private String NUM_TELEFONO__c;
	private String MAIL__c;
	private boolean HAY_Es_Portal__c = true; // Campo obligatorio , se omite seter
	private boolean HAY_NoProcesar__c = true; // Campo obligatorio , se omite seter

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
		
		Attributes attributes = new Attributes();
		this.setAttributes(attributes);
		
		System.out.println("Constructor 2");
	}
	
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
	
	public Attributes getAttributes() {
		return attributes;
	}

	public void setAttributes(Attributes attributes) {
		this.attributes = attributes;
	}

	public String getCANAL_WEB_ENTRADA__c() {
		return CANAL_WEB_ENTRADA__c;
	}

	public int getMEDIO_INTERNET__c() {
		return MEDIO_INTERNET__c;
	}

	public boolean isHAY_Es_llamada__c() {
		return HAY_Es_llamada__c;
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

	public boolean isHAY_NoProcesar__c() {
		return HAY_NoProcesar__c;
	}

}
