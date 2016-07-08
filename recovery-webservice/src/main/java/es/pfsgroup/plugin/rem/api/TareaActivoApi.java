package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.prorroga.dto.DtoSolicitarProrroga;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.TareaActivo;


public interface TareaActivoApi {
    
	    public TareaActivo get(Long id);
	    
	    public TareaActivo getByIdTareaExterna(Long idTareaExterna);

		public void generarAutoprorroga(DtoSolicitarProrroga dto)  throws BusinessOperationException;

		public List<TareaActivo> getTareasActivoByIdTramite(Long idTramite);
		
		public Long getTareasPendientes(Usuario usuario);
		
		public Long getAlertasPendientes(Usuario usuario);
		
		public Long getAvisosPendientes(Usuario usuario);
    }