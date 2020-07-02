package es.pfsgroup.plugin.rem.activo.admision.evolucion.manager;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.plugin.rem.activo.admision.evolucion.api.ActivoAdmisionEvolucionApi;
import es.pfsgroup.plugin.rem.activo.admision.evolucion.dao.ActivoAgendaEvolucionDao;
import es.pfsgroup.plugin.rem.model.ActivoAgendaEvolucion;
import es.pfsgroup.plugin.rem.model.DtoActivoAdmisionEvolucion;

@Service("activoAdmisionEvolucionManager")
public class ActivoAdmisionEvolucionManager implements ActivoAdmisionEvolucionApi {
	
	@Autowired
	ActivoAgendaEvolucionDao activoAgendaEvolucionDao;

	@Override
	public List<DtoActivoAdmisionEvolucion> getListActivoAgendaEvolucion(Long id) {
		
		List<ActivoAgendaEvolucion> listaEvolucion =  activoAgendaEvolucionDao.getListAgendaEvolucionByIdActivo(id);
		List<DtoActivoAdmisionEvolucion> dtoList = new ArrayList<DtoActivoAdmisionEvolucion>();
		DtoActivoAdmisionEvolucion dto = new DtoActivoAdmisionEvolucion();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		if(!listaEvolucion.isEmpty()) {
			for (ActivoAgendaEvolucion evolucion : listaEvolucion) {
				
				if(evolucion.getEstadoAdmision() != null) {
					dto.setEstadoEvolucion(evolucion.getEstadoAdmision().getDescripcion());
				}
				if(evolucion.getSubEstadoAdmision() != null) {
					dto.setSubestadoEvolucion(evolucion.getSubEstadoAdmision().getDescripcion());
				}
				
				if(evolucion.getFechaAgendaEv() != null) {
					String fecha = evolucion.getFechaAgendaEv().toString();
					dto.setFechaEvolucion(fecha);
				}
				
				if(evolucion.getObservaciones() != null) {
					dto.setObservacionesEvolucion(evolucion.getObservaciones());
				}
				if(evolucion.getUsuario() != null) {
					dto.setGestorEvolucion(evolucion.getUsuario().getUsername());
				}
				
				dtoList.add(dto);
			}
			
		}
		
		return dtoList;
	}



	

}
