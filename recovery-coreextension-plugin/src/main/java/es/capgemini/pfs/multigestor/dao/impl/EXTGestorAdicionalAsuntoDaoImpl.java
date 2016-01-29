package es.capgemini.pfs.multigestor.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.multigestor.dao.EXTGestorAdicionalAsuntoDao;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.multigestor.model.EXTTipoGestorPropiedad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;

@Repository("EXTGestorAdicionalAsunto")
public class EXTGestorAdicionalAsuntoDaoImpl extends
		AbstractEntityDao<EXTGestorAdicionalAsunto, Long> implements
		EXTGestorAdicionalAsuntoDao {

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public List<Usuario> findGestoresByAsunto(Long idAsunto, String tipoGestor) {
		List<Usuario> listUsuario = new ArrayList<Usuario>();

		HQLBuilder hb = new HQLBuilder("from EXTGestorAdicionalAsunto p");
		hb.appendWhere("p.auditoria.borrado=false");
		if (!Checks.esNulo(idAsunto)) {
			hb.appendWhere("asunto.id=" + idAsunto);
		}
		if (!Checks.esNulo(tipoGestor)) {
			hb.appendWhere("tipoGestor.codigo='" + tipoGestor + "'");
		}
		List<EXTGestorAdicionalAsunto> listGestorAdicionalAsuntos = HibernateQueryUtils
				.list(this, hb);
		for (EXTGestorAdicionalAsunto gestorAA : listGestorAdicionalAsuntos) {
			listUsuario.add(gestorAA.getGestor().getUsuario());
		}
		return listUsuario;
	}
	
	@Override
	public List<EXTGestorAdicionalAsunto> findGestorAdicionalesByAsunto(Long idAsunto) {
		HQLBuilder hb = new HQLBuilder("from EXTGestorAdicionalAsunto p");
		hb.appendWhere("p.auditoria.borrado=false");
		hb.appendWhere("asunto.id=" + idAsunto);
		
		return HibernateQueryUtils.list(this, hb);
	}
	
	/**
	 * getTipoDespachoExternoList
	 * 
	 * Lista de despachos externos asociados al usuario
	 * 
	 * @param usuId 
	 * 
	 * @return lista despachos
	 * 
	 */
	public List<DespachoExterno> getTipoDespachoExternoList(long usuId){
		List<DespachoExterno> tdeList = new ArrayList<DespachoExterno>();
		
		StringBuffer hql = new StringBuffer();		
		
		hql.append("Select de from GestorDespacho gd ");
		hql.append("join gd.despachoExterno as de ");
		hql.append("join de.tipoDespacho as td ");
		hql.append("join gd.usuario as usu ");
		hql.append(" where usu.id = ").append(usuId);
		
		Query query = getSession().createQuery(hql.toString());
		
		tdeList = query.list();
		
		return tdeList;
	}
	
	/**
	 * getTipoDespachoExternoList
	 * 
	 * Lista de despachos externos asociados al usuario
	 * 
	 * @param usuId 
	 * 
	 * @return lista despachos
	 * 
	 */	
	public List<EXTTipoGestorPropiedad> getTipoGestorPropiedadList(String codSta){
		List<EXTTipoGestorPropiedad> tgpList = new ArrayList<EXTTipoGestorPropiedad>();	
		
		StringBuffer hql = new StringBuffer();		
		
		hql.append("Select tgp from EXTTipoGestorPropiedad tgp, EXTSubtipoTarea sta ");
		hql.append("where tgp.tipoGestor = sta.tipoGestor and sta.codigoSubtarea = '").append(codSta).append("'");
		
		Query query = getSession().createQuery(hql.toString());
		
		tgpList = query.list();
		
		return tgpList;		
	}	

}
