package es.capgemini.pfs.termino;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.termino.dto.TerminoOperacionesDto;
import es.capgemini.pfs.termino.model.TerminoOperaciones;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface TerminoOperacionesApi {
	
	
    
	public static final String ACUERDO_TERMINO_OPERACIONES_CREAR = "termino.operaciones.creaTerminoOperaciones";
	public static final String ACUERDO_TERMINO_OPERACIONES_GUARDAR = "termino.operaciones.guardaTerminoOperaciones";

	
	@BusinessOperationDefinition(ACUERDO_TERMINO_OPERACIONES_CREAR)
    @Transactional(readOnly = false)
    public TerminoOperaciones creaTerminoOperaciones(TerminoOperacionesDto terminoOperacionesDto);
	
	
	@BusinessOperationDefinition(ACUERDO_TERMINO_OPERACIONES_GUARDAR)
    @Transactional(readOnly = false)
    public TerminoOperaciones guardaTerminoOperaciones(TerminoOperaciones terminoOperaciones);
    	

}
