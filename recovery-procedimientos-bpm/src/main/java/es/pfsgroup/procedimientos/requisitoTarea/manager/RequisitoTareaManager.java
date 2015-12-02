package es.pfsgroup.procedimientos.requisitoTarea.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.procedimientos.requisitoTarea.api.RequisitoTareaApi;
import es.pfsgroup.procedimientos.requisitoTarea.model.RequisitoTarea;

@Component
public class RequisitoTareaManager implements RequisitoTareaApi {

	@Autowired
	private GenericABMDao genericDao;

	@Override
	@BusinessOperation(BO_EXISTE_REQUISITO_TAREA_TAREA_PROCEDIMIENTO)
	@Transactional(readOnly = true)
	public RequisitoTarea existeRequisito(Long idTareaProcedimiento) {
		// NOTA. Como puede ser que en base de datos haya m�s de unrequisito
		// para la tarea se devuelve el primer elemento de los encontrados
		List<RequisitoTarea> requisitos = genericDao.getList(RequisitoTarea.class, genericDao.createFilter(FilterType.EQUALS, "tareaProcedimiento.id", idTareaProcedimiento),
				genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false));
		if (!Checks.estaVacio(requisitos)) {
			return requisitos.get(0);
		} else {
			return null;
		}
	}

	@Override
	@BusinessOperation(BO_COMPROBAR_REQUISITO_TAREA_TAREA_PROCEDIMIENTO)
	@Transactional(readOnly = true)
	public boolean comprobarRequisito(RequisitoTarea requisito, Long idProcedimiento) {

		boolean cumpleRequisito = false;
		TareaProcedimiento tpRequerida = requisito.getTareaProcedimientoRequerida();
		GenericFormItem campoRequerido = requisito.getCampoRequerido();

		TareaExterna texRequerida = getTareaExterna(idProcedimiento, tpRequerida);

		if (texRequerida != null) {
			// NOTA. Para evitar que, por errores en la generaci�n de los BPM,
			// se puedan devolver resultados duplicados, obtenemos una lista y
			// comprobamos que est� relleno al menos uno de los valores.
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
