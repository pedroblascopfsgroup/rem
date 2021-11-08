package es.pfsgroup.plugin.rem.activo.dao.impl;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.activo.dao.TareaValoresDao;
import org.springframework.stereotype.Repository;

@Repository("TareaValoresDao")
public class TareaValoresDaoImpl extends AbstractEntityDao<TareaExternaValor, Long> implements TareaValoresDao {

	@Override
	public String getValorCampoTarea(String codTarea, Long numExpediente, String nombreCampo) {
		String sql = "          SELECT TEV.TEV_VALOR " +
				"				FROM REM01.ACT_TRA_TRAMITE TRA  " +
				"				INNER JOIN REM01.ACT_TBJ_TRABAJO TBJ ON TRA.TBJ_ID = TBJ.TBJ_ID " +
				"				INNER JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO ON TBJ.TBJ_ID = ECO.TBJ_ID AND ECO.ECO_NUM_EXPEDIENTE = " + numExpediente  + " " +
				"				INNER JOIN REM01.TAC_TAREAS_ACTIVOS TAC ON TRA.TRA_ID = TAC.TRA_ID " +
				"				INNER JOIN REM01.TEX_TAREA_EXTERNA TEX ON TAC.TAR_ID = TEX.TAR_ID " +
				"				INNER JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID AND TAP.TAP_CODIGO = '" + codTarea + "' " +
				"				INNER JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TAC.TAR_ID = TAR.TAR_ID and TAR.TAR_FECHA_FIN IS NOT NULL " +
				"				INNER JOIN REM01.TEV_TAREA_EXTERNA_VALOR TEV ON TEX.TEX_ID = TEV.TEX_ID AND TEV.TEV_NOMBRE = '" + nombreCampo + "' ";


		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((String) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult());
		}

		return null;
	}
}
