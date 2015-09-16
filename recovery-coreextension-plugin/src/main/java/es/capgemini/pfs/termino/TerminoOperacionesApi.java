package es.capgemini.pfs.termino;

import java.text.ParseException;
import java.util.HashMap;
import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.termino.dto.TerminoOperacionesDto;
import es.capgemini.pfs.termino.model.CamposTerminoTipoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoOperaciones;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface TerminoOperacionesApi {
	
	
    
	public static final String ACUERDO_TERMINO_OPERACIONES_CREAR = "termino.operaciones.creaTerminoOperaciones";
	public static final String ACUERDO_TERMINO_OPERACIONES_GUARDAR = "termino.operaciones.guardaTerminoOperaciones";
	public static final String ACUERDO_TERMINO_OPERACIONES_GET_OPERACIONES_POR_TIPO_ACUERDO = "termino.operaciones.getOperacionesPorTipoAcuerdo";
	public static final String ACUERDO_TERMINO_CAMPOS_OPERACIONES_POR_TIPO_ACUERDO = "termino.operaciones.getCamposOperacionesPorTipoAcuerdo";

	
	@BusinessOperationDefinition(ACUERDO_TERMINO_OPERACIONES_CREAR)
    @Transactional(readOnly = false)
    public TerminoOperaciones creaTerminoOperaciones(TerminoOperacionesDto terminoOperacionesDto) throws ParseException;
	
	
	@BusinessOperationDefinition(ACUERDO_TERMINO_OPERACIONES_GUARDAR)
    @Transactional(readOnly = false)
    public TerminoOperaciones guardaTerminoOperaciones(TerminoOperaciones terminoOperaciones);
	
	
	@BusinessOperationDefinition(ACUERDO_TERMINO_OPERACIONES_GET_OPERACIONES_POR_TIPO_ACUERDO)
    @Transactional(readOnly = false)	
	public List<HashMap<String, Object>> getOperacionesPorTipoAcuerdo(TerminoOperaciones terminoOperaciones);
	
	@BusinessOperationDefinition(ACUERDO_TERMINO_CAMPOS_OPERACIONES_POR_TIPO_ACUERDO)
    @Transactional(readOnly = false)	
	public List<CamposTerminoTipoAcuerdo> getCamposOperacionesPorTipoAcuerdo(Long idTipoAcuerdo);
	

}
