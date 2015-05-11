package es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.SQLQuery;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.asunto.dto.DtoReportAnotacionAgenda;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.model.TipoTarea;
import es.pfsgroup.plugin.recovery.mejoras.devolucionAsunto.dao.MEJAsuntoDao;
import es.pfsgroup.plugin.recovery.mejoras.registro.model.MEJDDTipoRegistro;

@Repository("MEJAsuntoDao")
public class MEJAsuntoDaoImpl extends AbstractEntityDao<Asunto, Long> implements MEJAsuntoDao {

	@Override
	public List<Long> getListTrazasConCorreo(Long idAsunto) {
		String queryString = "Select reg_id from mej_reg_registro mej join mej_dd_trg_tipo_registro mej_dd on mej.dd_trg_id = mej_dd.dd_trg_id "
				+ " WHERE dd_trg_codigo = '"
				+ MEJDDTipoRegistro.CODIGO_ENVIO_EMAILS
				+ "' AND trg_ein_codigo = 3 AND trg_ein_id = '"
				+ idAsunto
				+ "'" + " and mej.borrado=0 ";

		SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory()
				.getCurrentSession().createSQLQuery(queryString);

		List<Long> listado = new ArrayList<Long>();
		List<Object> lista = sqlQuery.list();
		for (Object obj : lista) {
			listado.add(Long.parseLong(obj.toString()));
		}

		return listado;
	}
	
}
