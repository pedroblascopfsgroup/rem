package es.pfsgroup.plugin.rem.buzontareas;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.tareaNotificacion.model.EXTSubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.api.registro.MEJRegistroApi;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJInfoRegistro;
import es.pfsgroup.plugin.recovery.mejoras.web.tareas.BuzonTareasViewHandler;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.model.DtoSolicitarProrrogaTarea;
import es.pfsgroup.recovery.api.TareaNotificacionApi;

@Component
public class ListadoTareaProrrogaAbrirDetalle implements BuzonTareasViewHandler {

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private MEJRegistroApi mejRegistroApi;

	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Override
	public String getJspName() {
		return "plugin/agendaMultifuncion/asunto/detalleAnotacion";
	}

	@Override
	public Object getModel(Long idTarea) {
		DtoSolicitarProrrogaTarea result = new DtoSolicitarProrrogaTarea();
		
		if (!Checks.esNulo(idTarea)) {
			SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");

			Filter f1 = genericDao.createFilter(FilterType.EQUALS, "clave", "tareaActivo");
			Filter f2 = genericDao.createFilter(FilterType.EQUALS, "valorCorto", idTarea.toString());
			MEJInfoRegistro infoRegistro = getInfoRegistro(f1, f2);
			
			if (!Checks.esNulo(infoRegistro)) {
						
				Map<String, String> info = mejRegistroApi.getMapaRegistro(infoRegistro.getRegistro().getId());
				
				Filter f3 = genericDao.createFilter(FilterType.EQUALS, "registro.id", infoRegistro.getRegistro().getId());
				Filter f4 = genericDao.createFilter(FilterType.EQUALS, "clave", "tarId");
				Filter filtroTarea = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(genericDao.get(MEJInfoRegistro.class, f3, f4).getValor()));
				TareaExterna tex = genericDao.get(TareaExterna.class, filtroTarea);
					
				result.setDescripcionTareaProrrogada(tex.getTareaProcedimiento().getDescripcion());
				
				//result.setMotivoAutoprorroga(info.get(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_MOTIVO));
				result.setMotivoAutoprorroga(info.get(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_DETALLE));
				
				String nuevaFechaProrroga = info.get(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_FECHA_VENCIMIENTO_PROPUESTA);
				result.setNuevaFechaProrroga(nuevaFechaProrroga);
				String antiguaFechaProrroga = info.get(MEJDDTipoRegistro.TrazaAutoProrroga.CLAVE_FECHA_VENCIMIENTO_ORIGINAL);
				result.setAntiguaFechaProrroga(antiguaFechaProrroga);
				
			}
		}
		return result;
	}

	@Override
	public String getValidString() {
		return EXTSubtipoTarea.CODIGO_SOLICITAR_PRORROGA_PROCEDIMIENTO;
	}

	private MEJInfoRegistro getInfoRegistro(Filter f1, Filter f2) {
		List<MEJInfoRegistro> infoRegistroList = genericDao.getList(MEJInfoRegistro.class, f1, f2);
		MEJInfoRegistro infoRegistro = null;
		if (!Checks.estaVacio(infoRegistroList)) {
			infoRegistro = infoRegistroList.get(0);
		}
		return infoRegistro;
	}

}
