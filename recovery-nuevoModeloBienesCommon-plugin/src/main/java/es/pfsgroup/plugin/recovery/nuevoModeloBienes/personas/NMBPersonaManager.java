package es.pfsgroup.plugin.recovery.nuevoModeloBienes.personas;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.persona.PersonaApi;
import es.capgemini.pfs.estadoFinanciero.model.DDSituacionEstadoFinanciero;
import es.capgemini.pfs.persona.dto.DtoUmbral;
import es.capgemini.pfs.persona.dto.EXTDtoBuscarClientes;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.users.FuncionManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBContratoBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.personas.dao.impl.NMBPersonaDaoImpl;

@Component
public class NMBPersonaManager extends BusinessOperationOverrider<PersonaApi> implements PersonaApi{

	@Autowired
	private Executor executor;
	
	@Autowired
	private FuncionManager funcionManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private NMBPersonaDaoImpl personaDao;
	
	@Override
	public String managerName() {
		return "personaManager";
	}

	@Override
	public void updateUmbral(DtoUmbral arg0) {
		parent().updateUmbral(arg0);		
	}
	
	@Override
	@BusinessOperation(overrides = PrimariaBusinessOperation.BO_PER_MGR_GET_BIENES)
    public List<Bien> getBienes(Long idPersona) {
		
    	Usuario usuarioLogado = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
    	
    	//BIENES DE LA PERSONA
    	//COMPROBAMOS SI LA PERSONA ESTA EN ALG�N ASUNTO JUDICIAL
    	//PARA ESO TENEMOS QUE COMPROBAR QUE TENGA ALG�N PROCEDIMIENTO
    	Long numProcedimientos = personaDao.getListaProcedimientosDePersona(idPersona);
    	boolean estaEnAsuntos = false;
    	if(numProcedimientos != null && numProcedimientos>0){
    		estaEnAsuntos = true;
    	}
    	
    	
    	boolean visibilidadLimitada = false;
    	if (funcionManager.tieneFuncion(usuarioLogado, "VISIBILIDAD_LIMITADA_BIENES")) 
    		visibilidadLimitada = true;
        
    	//if(estaEnAsuntos && !visibilidadLimitada){ //SI LA PERSONA EST� EN ALG�N ASUNTO, SE RECOGEN TODOS SUS BIENES
    	if(estaEnAsuntos || !visibilidadLimitada){
    		List<Bien> listaBienes = parent().getBienes(idPersona);
	    	try {
	    		
	    		boolean todosLosBienes;
				// si tiene permiso para ver toda la estructura de bienes meto todos los bienes
				// sino solo meto los bienes manuales
	    		if (funcionManager.tieneFuncion(usuarioLogado, "ESTRUCTURA_COMPLETA_BIENES")) todosLosBienes = true; 
	    		else todosLosBienes = false;
	    			
	    		NMBBien bien = new NMBBien();
	    		List<Bien> listNMBBienes = new ArrayList<Bien>();
	    		for (Bien b : listaBienes) {
	    			bien = getNMBBien(b);
	    			if (todosLosBienes || bien.getOrigen().getCodigo().equals("1")) {
	    				NMBBien nuevoBien = new NMBBien();
	    				nuevoBien = getNMBBien(b);
	    				listNMBBienes.add(nuevoBien);
	    			} else {
	    				// si el usuario conectado es externo y el bien esta marcado mostrar
	    				if (usuarioLogado.getUsuarioExterno() && bien.getMarcaExternos()==1)
	    					listNMBBienes.add(bien);
	    			}
	    		}	
	    		return listNMBBienes;
			} catch (Exception e) {
				return listaBienes;
			} 
        }
        else{ //SI LA PERSONA NO EST� EN NING�N ASUNTO, OBTENEMOS SOLO LOS BIENES QUE HACEN REFERENCIA A ALG�N CONTRATO
        	List<Bien> listaBienes = parent().getBienes(idPersona);
        	try {
	    		
	    		boolean todosLosBienes;
				// si tiene permiso para ver toda la estructura de bienes meto todos los bienes
				// sino solo meto los bienes manuales
	    		if (funcionManager.tieneFuncion(usuarioLogado, "ESTRUCTURA_COMPLETA_BIENES")) todosLosBienes = true; 
	    		else todosLosBienes = false;
	    			
	    		NMBBien bien = new NMBBien();
	    		List<Bien> listNMBBienes = new ArrayList<Bien>();
	    		for (Bien b : listaBienes) {
	    			bien = getNMBBien(b);
	    			if (bien.getOrigen().getCodigo().equals("1") || !visibilidadLimitada){
	    				NMBBien nuevoBien = new NMBBien();
	    				nuevoBien = getNMBBien(b);
	    				listNMBBienes.add(nuevoBien);
	    			} else {
		    			List<NMBContratoBien> contratoBien = genericDao.getList(NMBContratoBien.class, genericDao.createFilter(FilterType.EQUALS, "bien.id", bien.getId()), genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		    			if(contratoBien != null && contratoBien.size()>0){ //Si esta relacionado
			    			if (todosLosBienes) {
			    				NMBBien nuevoBien = new NMBBien();
			    				nuevoBien = getNMBBien(b);
			    				listNMBBienes.add(nuevoBien);
			    			} else {
			    				// si el usuario conectado es externo y el bien esta marcado mostrar
			    				if (usuarioLogado.getUsuarioExterno() && bien.getMarcaExternos()==1)
			    					listNMBBienes.add(bien);
			    			}
		    			}
	    			}
	    		}	
	    		return listNMBBienes;
			} catch (Exception e) {
				return listaBienes;
			} 
        }
    }

	private NMBBien getNMBBien(Bien b) {
		NMBBien bien;
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", b.getId());
		bien = genericDao.get(NMBBien.class, f1);
		return bien;
	}

	@Override
	public Persona get(Long idPersona) {
		return parent().get(idPersona);
	}

	@Override
	public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long idPersona) {
		return parent().getAdjuntosPersonaConBorrado(idPersona);
	}
	
	@Override
    public Page findClientesProveedorSolvenciaPaginated(EXTDtoBuscarClientes clientes){
		return parent().findClientesProveedorSolvenciaPaginated(clientes);
	}

	@Override
	public List<DDSituacionEstadoFinanciero> getEstadosFinancieros() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Persona> findClientesProveedorSolvenciaExcel(EXTDtoBuscarClientes clientes) {
		return parent().findClientesProveedorSolvenciaExcel(clientes);
	}

	@Override
	public Long obtenerCantidadDeVencidosUsuario() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Long obtenerCantidadDeSeguimientoSistematicoUsuario() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Long obtenerCantidadDeSeguimientoSintomaticoUsuario() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Persona getPersonaByCodClienteEntidad(Long arg0) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Boolean getAccionFSRByIdPersona(Long idPersona) {
		// TODO Auto-generated method stub
		return null;
	}	
}
