package es.capgemini.pfs.politica.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.politica.dao.DDParcelasPersonasDao;
import es.capgemini.pfs.politica.model.DDParcelasPersonas;
import es.capgemini.pfs.segmento.model.DDSegmento;

/**
 * Implementación del dao de DDParcelasPersona.
 * @author pamuller
 *
 */
@Repository("DDParcelasPersonasDao")
public class DDParcelasPersonasDaoImpl extends AbstractEntityDao<DDParcelasPersonas, Long> implements DDParcelasPersonasDao {

	/**
	 * Devuelve la lista de DDParcelasPersonas correspondiente a ese tipo de persona y segmento de cliente.
	 * Si no hay un registro para tipo de persona + segmento se devuelve el correspondiente a tipo de persona
	 * y segmento null.
	 * @param tipoPersona el tipo de persona.
	 * @param segmento el segmento del cliente.
	 * @return la lista de parcelas de ese tipo de persona y tipo de cliente
	 */
	@SuppressWarnings("unchecked")
    @Override
	public List<DDParcelasPersonas> buscarPorTipoPersonaYSegmento(DDTipoPersona tipoPersona, DDSegmento segmento) {
		StringBuffer hql = new StringBuffer();
		hql.append("Select pps.parcela from ParcelaPersonaSegmento pps ");
		hql.append("where ( ");
		hql.append("	pps.tipoPersona.id = :tipoPersona ");
		hql.append("	and pps.segmentoCliente.id = :segmento ");
		hql.append(") ");
		hql.append("or ( ");
		hql.append("	pps.tipoPersona.id = :tipoPersona ");
		hql.append("	and pps.segmentoCliente is null ");
		hql.append("	and not exists ( ");
		hql.append("		select pps1 from ParcelaPersonaSegmento pps1 ");
		hql.append("		where ( ");
		hql.append("			pps1.tipoPersona.id = :tipoPersona ");
		hql.append("			and pps1.segmentoCliente.id = :segmento ");
		hql.append("			and pps1.parcela = pps.parcela ");
		hql.append("		) ");
		hql.append("	) ");
		hql.append(") ");
		Query query = getSession().createQuery(hql.toString());
		query.setParameter("tipoPersona", tipoPersona.getId());
		query.setParameter("segmento", segmento.getId());
		List<DDParcelasPersonas> lista = query.list();
		return lista;
	}

}
