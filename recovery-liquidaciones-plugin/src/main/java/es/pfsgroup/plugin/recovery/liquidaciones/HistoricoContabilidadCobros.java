package es.pfsgroup.plugin.recovery.liquidaciones;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.registro.HistoricoAsuntoBuilder;
import es.capgemini.pfs.registro.HistoricoAsuntoDto;
import es.capgemini.pfs.tareaNotificacion.model.EXTTareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.liquidaciones.api.ContabilidadCobrosApi;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.DtoContabilidadCobros;
import es.pfsgroup.plugin.recovery.liquidaciones.model.ContabilidadCobros;

/**
 * Muestra las tareas de la contabilidad de cobros en el historico del asunto.
 */
@Component
public class HistoricoContabilidadCobros implements HistoricoAsuntoBuilder{

	//public static final String NOMBRE_TAREA = "Envío de contabilizar cobro al gestor de contabilidad";

	//protected static final long ID_TIPO_ENTIDAD_INFORMACION = 3L;

	protected static final boolean REQUIERE_RESPUESTA = false;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ContabilidadCobrosApi ccoApi;

	@Override
	public List<HistoricoAsuntoDto> getHistorico(long idAsunto) {
		DtoContabilidadCobros dtoCCO = new DtoContabilidadCobros();
		dtoCCO.setId(idAsunto);
		List<ContabilidadCobros> ccoList = ccoApi.getListadoContabilidadCobros(dtoCCO);
		for (ContabilidadCobros cco : ccoList){
			// Quitar registros de la lista sin TAR_ID asociado.
			if(Checks.esNulo(cco.getTarID())){
				ccoList.remove(cco);
			}
		}
		

		ArrayList<HistoricoAsuntoDto> historico = new ArrayList<HistoricoAsuntoDto>();
		if (ccoList != null){
			for (ContabilidadCobros cco : ccoList){
				EXTTareaNotificacion tarea = genericDao.get(EXTTareaNotificacion.class, genericDao.createFilter(FilterType.EQUALS, "id" , cco.getTarID()));
				historico.add(dtoHistorico(idAsunto,cco,tarea));
			}
		}
		return historico;
	}

	private HistoricoAsuntoDto dtoHistorico(final long idAsunto, final ContabilidadCobros cco, final EXTTareaNotificacion tarea) {
		HistoricoAsuntoDto dto = new HistoricoAsuntoDto() {
			
			@Override
			public String getSubtipoTarea() {
				return tarea.getSubtipoTarea().getDescripcion();
			}
			
			@Override
			public String getDescripcionTarea() {
				return tarea.getDescripcionTarea();
			}
			
			@Override
			public String getTipoRegistro() {
				return "";
			}
			
			@Override
			public long getTipoEntidad() {
				return tarea.getTipoEntidad().getId();
			}
			
			@Override
			public boolean getRespuesta() {
				return REQUIERE_RESPUESTA;
			}
			
			@Override
			public String getNombreUsuario() {
				return "";
			}
			
			@Override
			public String getNombreTarea() {
				return tarea.getDescripcionTarea();
			}
			
			@Override
			public long getIdProcedimiento() {
				return idAsunto;
			}
			
			@Override
			public long getIdEntidad() {
				return tarea.getIdEntidad();
			}
			
			@Override
			public Date getFechaVencimiento() {
				return tarea.getFechaVenc();
			}
			
			@Override
			public Date getFechaRegistro() {
				return null;
			}
			
			@Override
			public Date getFechaIni() {
				return tarea.getFechaInicio();
			}
			
			@Override
			public Date getFechaFin() {
				return tarea.getFechaFin();
			}

			@Override
			public Long getIdTarea() {
				return tarea.getId();
			}

			@Override
			public Long getIdTraza() {
				return cco.getId();
			}

			@Override
			public String getTipoTraza() {
				return "";
			}

			@Override
			public String getGroup() {
				// Tipo 'Contabilizar cobros'
				return "F";
			}
		};
		return dto;
	}

}
