package es.capgemini.pfs.persona.dto;

import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.persona.model.PersonaManual;

public class DtoPersonaManual {
	private Persona persona;
	private Boolean manual;
	
	public Persona getPersona() {
		return persona;
	}
	public void setPersona(Persona persona) {
		this.persona = persona;
	}
	public Boolean getManual() {
		return manual;
	}
	public void setManual(Boolean manual) {
		this.manual = manual;
	}
	
	public DtoPersonaManual(){
		
	}
	
	public DtoPersonaManual(Persona persona){
		this.persona = persona;
		this.manual = false;
	}
	
	public DtoPersonaManual(PersonaManual personaManual){
		
		Persona persona = new Persona();
		persona.setId(personaManual.getId());
		persona.setNom50(personaManual.getNombre()+" "+personaManual.getApellido1()+" "+personaManual.getApellido2());
		persona.setDocId(personaManual.getDocId());
		persona.setNombre(personaManual.getNombre());
		persona.setApellido1(personaManual.getApellido1());
		persona.setApellido2(personaManual.getApellido2());
		
		this.persona = persona;
		this.manual = true;
	}
}
