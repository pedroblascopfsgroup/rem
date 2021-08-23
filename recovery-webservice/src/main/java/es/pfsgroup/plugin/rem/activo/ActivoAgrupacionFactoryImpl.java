package es.pfsgroup.plugin.rem.activo;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ActivoAgrupacionDao;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoObraNueva;
import es.pfsgroup.plugin.rem.model.ActivoRestringida;
import es.pfsgroup.plugin.rem.model.ActivoRestringidaAlquiler;
import es.pfsgroup.plugin.rem.model.ActivoRestringidaObrem;
import es.pfsgroup.plugin.rem.model.DtoAgrupacionesCreateDelete;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;

@Component
public class ActivoAgrupacionFactoryImpl implements ActivoAgrupacionFactoryApi {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoAgrupacionDao activoAgrupacionDao;
	
	@Override
	public boolean create(DtoAgrupacionesCreateDelete dtoAgrupacion) {

		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", dtoAgrupacion.getTipoAgrupacion());
		DDTipoAgrupacion tipoAgrupacion = (DDTipoAgrupacion) genericDao.get(DDTipoAgrupacion.class, filtro);
		
		Long numAgrupacionRem = this.getNextNumAgrupacionRemManual();
		
		ActivoAgrupacion activoAgrupacion = this.getAgrupacionInstance(tipoAgrupacion);
		if(activoAgrupacion != null) {
			activoAgrupacion.setDescripcion(dtoAgrupacion.getDescripcion());
			activoAgrupacion.setNombre(dtoAgrupacion.getNombre());
			activoAgrupacion.setTipoAgrupacion(tipoAgrupacion);
			activoAgrupacion.setFechaAlta(new Date());
			activoAgrupacion.setNumAgrupRem(numAgrupacionRem);
				
			Class clazz = activoAgrupacion.getClass();
			genericDao.save(clazz, activoAgrupacion);
			
			return true;
		} else {
			return false;
		}
		
	}

	private ActivoAgrupacion getAgrupacionInstance(DDTipoAgrupacion tipoAgrupacion) {
		if (tipoAgrupacion.getCodigo().equals(DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA)) {
			return new ActivoObraNueva();
		}else if (tipoAgrupacion.getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA)) {
			return new ActivoRestringida();
		}else if (tipoAgrupacion.getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_ALQUILER)) {
			return new ActivoRestringidaAlquiler();
		}else if (tipoAgrupacion.getCodigo().equals(DDTipoAgrupacion.AGRUPACION_RESTRINGIDA_OB_REM)) {
			return new ActivoRestringidaObrem();
		}else{
			return null;
		}
		
	}

	private Long getNextNumAgrupacionRemManual() {
		return activoAgrupacionDao.getNextNumAgrupacionRemManual();
	}

}
