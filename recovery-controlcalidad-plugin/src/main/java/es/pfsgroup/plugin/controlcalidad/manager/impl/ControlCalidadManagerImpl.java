package es.pfsgroup.plugin.controlcalidad.manager.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.controlcalidad.constantes.ControlCalidadConstants.ControlCalidadConstantes;
import es.pfsgroup.plugin.controlcalidad.constantes.ControlCalidadConstants.Genericas;
import es.pfsgroup.plugin.controlcalidad.manager.api.ControlCalidadManager;
import es.pfsgroup.plugin.controlcalidad.model.ControlCalidad;
import es.pfsgroup.plugin.controlcalidad.model.ControlCalidadDto;
import es.pfsgroup.plugin.controlcalidad.model.ControlCalidadProcedimiento;
import es.pfsgroup.plugin.controlcalidad.model.ControlCalidadProcedimientoDto;
import es.pfsgroup.plugin.controlcalidad.model.DDTipoControlCalidad;

/**
 * Implementación de métodos para el sistema de control de calidad
 * @author Guillem
 *
 */
@Service
public class ControlCalidadManagerImpl implements ControlCalidadManager {

	private static final Log logger = LogFactory.getLog(ControlCalidadManagerImpl.class);
	
	@Autowired
	private GenericABMDao genericDao;
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperationDefinition(ControlCalidadConstantes.BO_CONTROL_CALIDAD_REGISTRAR_INCIDENCIA_PROCEDIMIENTO_RECOBRO)
	public void registrarIncidenciaProcedimientoRecobro(
			ControlCalidadProcedimientoDto controlCalidadProcedimientoDto) {
		ControlCalidadProcedimiento controlCalidadProcedimiento = null;
		ControlCalidadDto controlCalidadDto = null;
		ControlCalidad controlCalidad = null;
		try{
			controlCalidadDto = new ControlCalidadDto();
			controlCalidadDto.setDescripcion(controlCalidadProcedimientoDto.getDescripcion());
			controlCalidadDto.setIdEntidad(controlCalidadProcedimientoDto.getIdEntidad());
			controlCalidadDto.setTipoEntidad(genericDao.get(DDTipoEntidad.class, 
					genericDao.createFilter(FilterType.EQUALS, Genericas.CODIGO, 
					DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE)));
			controlCalidadDto.setTipoControlCalidad(genericDao.get(DDTipoControlCalidad.class, 
					genericDao.createFilter(FilterType.EQUALS, Genericas.CODIGO, 
					DDTipoControlCalidad.CODIGO_TIPO_CONTROL_CALIDAD_PROCEDIMIENTO_RECOBRO)));
			controlCalidad = registrarIncidencia(controlCalidadDto);
			controlCalidadProcedimiento = new ControlCalidadProcedimiento();
			controlCalidadProcedimiento.setControlCalidad(controlCalidad);
			controlCalidadProcedimiento.setDescripcion(controlCalidadProcedimientoDto.getDescripcion());
			controlCalidadProcedimiento.setIdBPM(controlCalidadProcedimientoDto.getIdBPM());
			controlCalidadProcedimiento.setRevisado(false);
			genericDao.save(ControlCalidadProcedimiento.class, controlCalidadProcedimiento);			
		}catch(Throwable e){
			logger.error(ControlCalidadConstantes.EXCEPCION_REGISTRAR_INCIDENCIA_PROCEDIMIENTO_RECOBRO, e);
		}		
	}
	
	/**
	 * Comprueba si existe un registro en la entidad Control de Calidad.
	 * En caso de que exista lo actualiza y sino lo crea nuevo 
	 * @param controlCalidadDto
	 * @return ControlCalidad
	 */
	private ControlCalidad registrarIncidencia(ControlCalidadDto controlCalidadDto){
		ControlCalidad controlCalidad = null;
		try{
			controlCalidad = genericDao.get(ControlCalidad.class, 
					genericDao.createFilter(FilterType.EQUALS, Genericas.ID_ENTIDAD, 
					controlCalidadDto.getIdEntidad()), genericDao.createFilter(FilterType.EQUALS, 
					Genericas.TIPO_CONTROL_CALIDAD, controlCalidadDto.getTipoControlCalidad()),
					genericDao.createFilter(FilterType.EQUALS, Genericas.TIPO_ENTIDAD, 
					controlCalidadDto.getTipoEntidad()));
			if(Checks.esNulo(controlCalidad)){
				controlCalidad = new ControlCalidad();
				controlCalidad.setDescripcion(controlCalidadDto.getDescripcion());
				if(!Checks.esNulo(controlCalidadDto.getIdEntidad()))controlCalidad.setIdEntidad(controlCalidadDto.getIdEntidad());
				controlCalidad.setTipoControlCalidad(controlCalidadDto.getTipoControlCalidad());
				controlCalidad.setTipoEntidad(controlCalidadDto.getTipoEntidad());
				genericDao.save(ControlCalidad.class, controlCalidad);
			}
		}catch(Throwable e){
			logger.error(ControlCalidadConstantes.EXCEPCION_REGISTRAR_INCIDENCIA, e);
		}	
		return controlCalidad;
	}

}
