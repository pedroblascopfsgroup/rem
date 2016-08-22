package es.pfsgroup.plugin.rem.requisitotarea;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.rem.api.ActivoRequisitoTareaApi;
import es.pfsgroup.plugin.rem.model.ActivoRequisitoTarea;

@Component
public class ActivoRequisitoTareaManager implements ActivoRequisitoTareaApi {

	@Autowired
	private GenericABMDao genericDao;

	@Transactional(readOnly = true)
	public ActivoRequisitoTarea existeRequisito(Long idTareaProcedimiento) {
		// NOTA. Como puede ser que en base de datos haya más de unrequisito
		// para la tarea se devuelve el primer elemento de los encontrados
		List<ActivoRequisitoTarea> requisitos = genericDao.getList(ActivoRequisitoTarea.class, genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", idTareaProcedimiento),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		if (!Checks.estaVacio(requisitos)) {
			return requisitos.get(0);
		} else {
			return null;
		}
	}

	@Transactional(readOnly = true)
	public boolean comprobarRequisito(ActivoRequisitoTarea requisito, Long idProcedimiento) {

		boolean cumpleRequisito = false;
		TareaProcedimiento tpRequerida = requisito.getTareaProcedimientoRequerida();
		GenericFormItem campoRequerido = requisito.getCampoRequerido();

		TareaExterna texRequerida = getTareaExterna(idProcedimiento, tpRequerida);

		if (texRequerida != null) {
			// NOTA. Para evitar que, por errores en la generación de los BPM,
			// se puedan devolver resultados duplicados, obtenemos una lista y
			// comprobamos que esté relleno al menos uno de los valores.
			List<TareaExternaValor> requeridos = genericDao.getList(TareaExternaValor.class, genericDao.createFilter(FilterType.EQUALS, "tareaExterna.id", texRequerida.getId()),
					genericDao.createFilter(FilterType.EQUALS, "nombre", campoRequerido.getNombre()));
			if (!Checks.estaVacio(requeridos)) {
				for (TareaExternaValor tevRequerida : requeridos) {
					if (tevRequerida != null) {
						if (tevRequerida.getValor() != null && tevRequerida.getValor() != "")
							cumpleRequisito = true;
					}
				}
			}

		}
		return cumpleRequisito;
	}

	private TareaExterna getTareaExterna(Long idProcedimiento, TareaProcedimiento tpRequerida) {
		List<TareaExterna> lista = genericDao.getListOrdered(TareaExterna.class, new Order(OrderType.DESC, "id"),
				genericDao.createFilter(FilterType.EQUALS, "tareaPadre.procedimiento.id", idProcedimiento), genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", tpRequerida.getId()));

		if (Checks.estaVacio(lista)) {
			return null;
		} else {
			return lista.get(0);
		}
	}
}
