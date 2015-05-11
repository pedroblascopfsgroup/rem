package es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTarea.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.SQLQuery;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoDetallePanelControlLetrados;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelControlFiltros;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTarea.dao.PCExpedienteTareaDao;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTarea.model.PCExpedienteTarea;

@Repository
public class PCExpedienteTareaDaoImpl extends
		AbstractEntityDao<PCExpedienteTarea, Long> implements
		PCExpedienteTareaDao {

	/**
	 * Obtiene la lista de los ids de los letrados(USU_USERNAME)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<String> getLetrados(String cod) {
		StringBuffer query = new StringBuffer();
		
		query.append(" select distinct tar.userName from PCExpedienteTarea tar");
		if (!Checks.esNulo(cod)) {
			query.append(" where tar.codigo like '" + cod + "%' ");
		}
		
		List<String> listaLetrados = new ArrayList<String>();
		
		try {
			listaLetrados = getSession().createQuery(query.toString()).list();
		} catch (Exception e) {
		}
		return listaLetrados;
	}

	@Override
	public List<String> getTodosLetrados() {
		return getLetrados(null);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Object[]> getExpedientes(DtoDetallePanelControlLetrados dto) {
		String queryString = "select * from V_PC_COT_EXP_TAR tar where ";

		if (dto.getNivel().equals(305L))
			queryString += " tar.usu_username like '" + dto.getUserName() + "' ";
		else
			queryString += " tar.zon_cod like '" + dto.getCod() + "%' ";
			//queryString += " CONTAINS(tar.zon_cod , '" + dto.getCod() + "%')>0 ";
		
		if (dto.getTipoProcedimiento() != null && !dto.getTipoProcedimiento().equals(""))
			queryString += " and tar.cod_prod ='" + dto.getTipoProcedimiento() + "'";
			
		if (dto.getTipoTarea() != null && !dto.getTipoTarea().equals(""))
			queryString += " and tar.tipo_Tarea ='" + dto.getTipoTarea() + "'";
		
		if (dto.getCampanya()!= null && !dto.getCampanya().equals(""))
			queryString += " and tar.campaña ='" + dto.getCampanya() + "'";
		
		if (dto.getLetradoGestor()!= null && !dto.getLetradoGestor().equals(""))
			queryString += " and tar.letrado ='" + dto.getLetradoGestor() + "'";
		
        if (dto.getMaxImporteFiltro() == null) {
            dto.setMaxImporteFiltro((double) Integer.MAX_VALUE);
        }
        
        if (dto.getMinImporteFiltro() == null) {
            dto.setMinImporteFiltro(0d);
        }
        
        if (!Checks.esNulo(dto.getCartera())){
        	queryString += " and tar.cartera ='" + dto.getCartera() + "'";
        }
        if (!Checks.esNulo(dto.getLote())){
        	queryString += " and tar.lote ='" + dto.getLote() + "'";
        }
        if (!Checks.esNulo(dto.getIdPlaza())){
        	queryString += " and tar.idPlaza ='" + dto.getIdPlaza()+"'";
        }
        if (!Checks.esNulo(dto.getIdJuzgado())){
        	queryString += " and tar.idJuzgado ='" + dto.getIdJuzgado()+"'";
        }

        queryString +=" and tar.saldo_expediente between " +  dto.getMinImporteFiltro() + " and " + dto.getMaxImporteFiltro();

        SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory()
				.getCurrentSession().createSQLQuery(queryString);

		List lista = sqlQuery.list();

		return lista;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Object[]> getTareasPendientes(
			DtoDetallePanelControlLetrados dto, boolean letrado, String rango) {
		String queryString = "select * from V_PC_COT_EXP_TAR tar where ";
	
		if (dto.getNivel().equals(305L))
			queryString += " tar.usu_username like '" + dto.getUserName() + "'";
		else
			queryString += " tar.zon_cod like '" + dto.getCod() + "%'";

		queryString += " and tar.tipo = '" + rango + "'";
		
		if (dto.getTipoProcedimiento() != null && !dto.getTipoProcedimiento().equals(""))
			queryString += " and tar.cod_prod ='" + dto.getTipoProcedimiento() + "'";
		
		if (dto.getTipoTarea() != null && !dto.getTipoTarea().equals(""))
			queryString += " and tar.tipo_Tarea ='" + dto.getTipoTarea() + "'";
		
		if (dto.getCampanya()!= null && !dto.getCampanya().equals(""))
			queryString += " and tar.campaña ='" + dto.getCampanya() + "'";
		
		if (dto.getLetradoGestor()!= null && !dto.getLetradoGestor().equals(""))
			queryString += " and tar.letrado ='" + dto.getLetradoGestor() + "'";
		
        if (dto.getMaxImporteFiltro() == null) {
            dto.setMaxImporteFiltro((double) Integer.MAX_VALUE);
        }
        
        if (dto.getMinImporteFiltro() == null) {
            dto.setMinImporteFiltro(0d);
        }
        
        if (!Checks.esNulo(dto.getCartera())){
        	queryString += " and tar.cartera ='" + dto.getCartera() + "'";
        }
        if (!Checks.esNulo(dto.getLote())){
        	queryString += " and tar.lote ='" + dto.getLote() + "'";
        }
        
        if (!Checks.esNulo(dto.getIdPlaza())){
        	queryString += " and tar.idPlaza ='" + dto.getIdPlaza()+"'";
        }
        if (!Checks.esNulo(dto.getIdJuzgado())){
        	queryString += " and tar.idJuzgado ='" + dto.getIdJuzgado()+"'";
        }
        
        queryString +=" and tar.saldo_expediente between " +  dto.getMinImporteFiltro() + " and " + dto.getMaxImporteFiltro();
		
		SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory()
				.getCurrentSession().createSQLQuery(queryString);

		List lista = sqlQuery.list();

		return lista;

	}
	
	@Override
	public Long getNumeroExpedientes(String cod,DtoPanelControlFiltros dto) {
		StringBuffer query = new StringBuffer();
		query.append(" select count(tar.expediente) from PCExpedienteTarea tar where  ");

		query.append(" tar.codigo like '"+cod+"%' ");
		
		if (dto.getTipoProcedimiento() != null && !dto.getTipoProcedimiento().equals(""))
			query.append(" and tar.codigoProcedimiento = '"+ dto.getTipoProcedimiento() +"'");

		if (dto.getTipoTarea() != null && !dto.getTipoTarea().equals(""))
			query.append(" and tar.tipoTarea = '"+ dto.getTipoTarea() +"'");
		
		if (dto.getCampanya()!= null && !dto.getCampanya().equals(""))
			query.append(" and tar.campanya = '"+ dto.getCampanya() +"'");
		
		if (dto.getLetradoGestor()!= null && !dto.getLetradoGestor().equals(""))
			query.append(" and tar.letrado = '"+ dto.getLetradoGestor() +"'");
		
        if (dto.getMaxImporteFiltro() == null) {
            dto.setMaxImporteFiltro((double) Integer.MAX_VALUE);
        }
        
        if (dto.getMinImporteFiltro() == null) {
            dto.setMinImporteFiltro(0d);
        }
        if (!Checks.esNulo(dto.getCartera())){
        	query.append(" and tar.cartera ='" + dto.getCartera() + "'");
        }
        if (!Checks.esNulo(dto.getLote())){
        	query.append(" and tar.lote ='" + dto.getLote()+ "'" );
        }
        
        if (!Checks.esNulo(dto.getIdPlaza())){
        	query.append(" and tar.idPlaza ='" + dto.getIdPlaza()+"'");
        }
        if (!Checks.esNulo(dto.getIdJuzgado())){
        	query.append(" and tar.idJuzgado ='" + dto.getIdJuzgado()+"'");
        }

        query.append(" and tar.saldo between " +  dto.getMinImporteFiltro() + " and " + dto.getMaxImporteFiltro());
        
		Long total = new Long(0);
		try{
			total = (Long)getSession().createQuery(query.toString()).uniqueResult();
		}
		catch(Exception e){
		}
		return total;
	} 
	
	@Override
	public Float getImporteExpedientes(String cod,DtoPanelControlFiltros dto) {
		StringBuffer query = new StringBuffer();
		query.append(" select sum(tar.saldo) from PCExpedienteTarea tar where  ");
		
		query.append(" tar.codigo like '"+cod+"%' ");
		
		if (dto.getTipoProcedimiento() != null && !dto.getTipoProcedimiento().equals(""))
			query.append(" and tar.codigoProcedimiento = '"+ dto.getTipoProcedimiento() +"'");
		
		if (dto.getTipoTarea() != null && !dto.getTipoTarea().equals(""))
			query.append(" and tar.tipoTarea = '"+ dto.getTipoTarea() +"'");
		
		if (dto.getCampanya()!= null && !dto.getCampanya().equals(""))
			query.append(" and tar.campanya = '"+ dto.getCampanya() +"'");
		
		if (!Checks.esNulo(dto.getCartera())){
        	query.append(" and tar.cartera ='" + dto.getCartera() + "'");
        }
		if (!Checks.esNulo(dto.getLote())){
        	query.append(" and tar.lote ='" + dto.getLote() + "'" );
        }
		if (!Checks.esNulo(dto.getIdPlaza())){
        	query.append(" and tar.idPlaza ='" + dto.getIdPlaza()+"'");
        }
        if (!Checks.esNulo(dto.getIdJuzgado())){
        	query.append(" and tar.idJuzgado ='" + dto.getIdJuzgado()+"'");
        }
		if (dto.getLetradoGestor()!= null && !dto.getLetradoGestor().equals(""))
			query.append(" and tar.letrado = '"+ dto.getLetradoGestor() +"'");
		
        if (dto.getMaxImporteFiltro() == null) {
            dto.setMaxImporteFiltro((double) Integer.MAX_VALUE);
        }
        
        if (dto.getMinImporteFiltro() == null) {
            dto.setMinImporteFiltro(0d);
        }

        query.append(" and tar.saldo between " +  dto.getMinImporteFiltro() + " and " + dto.getMaxImporteFiltro());
        
		Float importe = new Float(0);
		try{
			importe = ((Double)getSession().createQuery(query.toString()).uniqueResult()).floatValue();
		}
		catch(Exception e){
		}
		return importe;
	}
	
	@Override
	public Long totalTareasPendientes(String cod, String rango ,DtoPanelControlFiltros dto) {
		StringBuffer query = new StringBuffer();
		query.append(" select count(tar.idTarea) from PCExpedienteTarea tar where  ");
		
		query.append(" tar.codigo like '"+cod+"%' ");
		query.append(" and tar.tipo = '"+rango+"'");
		
		if (dto.getTipoProcedimiento() != null && !dto.getTipoProcedimiento().equals(""))
			query.append(" and tar.codigoProcedimiento = '"+ dto.getTipoProcedimiento() +"'");

		if (dto.getTipoTarea() != null && !dto.getTipoTarea().equals(""))
			query.append(" and tar.tipoTarea = '"+ dto.getTipoTarea() +"'");
		
		if (dto.getCampanya()!= null && !dto.getCampanya().equals(""))
			query.append(" and tar.campanya = '"+ dto.getCampanya() +"'");
		
		if (!Checks.esNulo(dto.getCartera())){
        	query.append(" and tar.cartera ='" + dto.getCartera() + "'");
        }
		if (!Checks.esNulo(dto.getLote())){
        	query.append(" and tar.lote ='" + dto.getLote() + "'" );
        }
		if (!Checks.esNulo(dto.getIdPlaza())){
        	query.append(" and tar.idPlaza ='" + dto.getIdPlaza()+"'");
        }
        if (!Checks.esNulo(dto.getIdJuzgado())){
        	query.append(" and tar.idJuzgado ='" + dto.getIdJuzgado()+"'");
        }
		if (dto.getLetradoGestor()!= null && !dto.getLetradoGestor().equals(""))
			query.append(" and tar.letrado = '"+ dto.getLetradoGestor() +"'");
		
        if (dto.getMaxImporteFiltro() == null) {
            dto.setMaxImporteFiltro((double) Integer.MAX_VALUE);
        }
        
        if (dto.getMinImporteFiltro() == null) {
            dto.setMinImporteFiltro(0d);
        }

        query.append(" and tar.saldo between " +  dto.getMinImporteFiltro() + " and " + dto.getMaxImporteFiltro());
        
		Long total = new Long(0);
		try{
			total = (Long)getSession().createQuery(query.toString()).uniqueResult();
		}
		catch(Exception e){
		}
		return total;
	}
	
	/**
	 * Obtiene la lista de todas las campañas
	 */
	@SuppressWarnings("unchecked")
	@Override
    public List<String> getCampanyas() {
		StringBuffer query = new StringBuffer();
		query.append("select distinct tar.campanya from PCExpedienteTarea tar");
		List<String> listaCampanyas = new ArrayList<String>();
		try {
			listaCampanyas = getSession().createQuery(query.toString()).list();
		} catch (Exception e) {
		}
		
        return listaCampanyas;
    }
	/**
	 * Obtiene la lista de todos los letrados
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<String> getLetradoGestor() {
		StringBuffer query = new StringBuffer();
		query.append("select distinct tar.letrado from PCExpedienteTarea tar");
		List<String> listaLetrados = new ArrayList<String>();
		try {
			listaLetrados = getSession().createQuery(query.toString()).list();
		} catch (Exception e) {
		}
		
		return listaLetrados;
	}
	
	@Override
	public Long getNumeroExpedientesPorLetrado(String idLetrado,DtoPanelControlFiltros dtoFiltros) {
		StringBuffer query = new StringBuffer();
		query.append(" select count(tar.expediente) from PCExpedienteTarea tar where 1=1 ");

		query.append(" and tar.userName like '"+ idLetrado +"'");
		
		if (dtoFiltros.getTipoProcedimiento() != null && !dtoFiltros.getTipoProcedimiento().equals(""))
			query.append(" and tar.codigoProcedimiento = '"+ dtoFiltros.getTipoProcedimiento() +"'");

		if (dtoFiltros.getTipoTarea() != null && !dtoFiltros.getTipoTarea().equals(""))
			query.append(" and tar.tipoTarea = '"+ dtoFiltros.getTipoTarea() +"'");
		
		if (dtoFiltros.getCampanya()!= null && !dtoFiltros.getCampanya().equals(""))
			query.append(" and tar.campanya = '"+ dtoFiltros.getCampanya() +"'");
		
		if (!Checks.esNulo(dtoFiltros.getCartera())){
        	query.append(" and tar.cartera ='" + dtoFiltros.getCartera() + "'");
        }
		if (!Checks.esNulo(dtoFiltros.getLote())){
        	query.append(" and tar.lote ='" + dtoFiltros.getLote()+ "'");
        }
		if (!Checks.esNulo(dtoFiltros.getIdPlaza())){
        	query.append(" and tar.idPlaza ='" + dtoFiltros.getIdPlaza()+"'");
        }
        if (!Checks.esNulo(dtoFiltros.getIdJuzgado())){
        	query.append(" and tar.idJuzgado ='" + dtoFiltros.getIdJuzgado()+"'");
        }
		
		if (dtoFiltros.getLetradoGestor()!= null && !dtoFiltros.getLetradoGestor().equals(""))
			query.append(" and tar.letrado = '"+ dtoFiltros.getLetradoGestor() +"'");
		
        if (dtoFiltros.getMaxImporteFiltro() == null) {
        	dtoFiltros.setMaxImporteFiltro((double) Integer.MAX_VALUE);
        }
        
        if (dtoFiltros.getMinImporteFiltro() == null) {
        	dtoFiltros.setMinImporteFiltro(0d);
        }

        query.append(" and tar.saldo between " +  dtoFiltros.getMinImporteFiltro() + " and " + dtoFiltros.getMaxImporteFiltro());
    
		Long total = new Long(0);
		try{
			total = (Long)getSession().createQuery(query.toString()).uniqueResult();
		}
		catch(Exception e){
		}
		return total;
	} 
	
	@Override
	public Float getImporteExpedientesPorLetrado(String idLetrado,DtoPanelControlFiltros dtoFiltros) {
		StringBuffer query = new StringBuffer();
		query.append(" select sum(tar.saldo) from PCExpedienteTarea tar where 1=1 ");

		query.append(" and tar.userName like '"+ idLetrado +"'");
		
		if (dtoFiltros.getTipoProcedimiento() != null && !dtoFiltros.getTipoProcedimiento().equals(""))
			query.append(" and tar.codigoProcedimiento = '"+ dtoFiltros.getTipoProcedimiento() +"'");

		if (dtoFiltros.getTipoTarea() != null && !dtoFiltros.getTipoTarea().equals(""))
			query.append(" and tar.tipoTarea = '"+ dtoFiltros.getTipoTarea() +"'");
		
		if (dtoFiltros.getCampanya()!= null && !dtoFiltros.getCampanya().equals(""))
			query.append(" and tar.campanya = '"+ dtoFiltros.getCampanya() +"'");
		
		if (!Checks.esNulo(dtoFiltros.getCartera())){
        	query.append(" and tar.cartera ='" + dtoFiltros.getCartera() + "'");
        }
		if (!Checks.esNulo(dtoFiltros.getLote())){
        	query.append(" and tar.lote ='" + dtoFiltros.getLote() + "'" );
        }
		if (!Checks.esNulo(dtoFiltros.getIdPlaza())){
        	query.append(" and tar.idPlaza ='" + dtoFiltros.getIdPlaza()+"'");
        }
        if (!Checks.esNulo(dtoFiltros.getIdJuzgado())){
        	query.append(" and tar.idJuzgado ='" + dtoFiltros.getIdJuzgado()+"'");
        }
		
		if (dtoFiltros.getLetradoGestor()!= null && !dtoFiltros.getLetradoGestor().equals(""))
			query.append(" and tar.letrado = '"+ dtoFiltros.getLetradoGestor() +"'");
		
        if (dtoFiltros.getMaxImporteFiltro() == null) {
        	dtoFiltros.setMaxImporteFiltro((double) Integer.MAX_VALUE);
        }
        
        if (dtoFiltros.getMinImporteFiltro() == null) {
        	dtoFiltros.setMinImporteFiltro(0d);
        }

        query.append(" and tar.saldo between " +  dtoFiltros.getMinImporteFiltro() + " and " + dtoFiltros.getMaxImporteFiltro());
        
		
		Float importe = new Float(0);
		try{
			importe = ((Double)getSession().createQuery(query.toString()).uniqueResult()).floatValue();
		}
		catch(Exception e){
		}
		return importe;
	}
	
	@Override
	public Long totalTareasPendientesPorLetrado(String rango,String idLetrado,DtoPanelControlFiltros dto) {
		StringBuffer query = new StringBuffer();
		query.append(" select count(tar.idTarea) from PCExpedienteTarea tar where 1=1 ");
		
		query.append(" and tar.userName like '"+ idLetrado +"'");
		query.append(" and tar.tipo = '"+ rango +"'");
		
		if (dto.getTipoProcedimiento() != null && !dto.getTipoProcedimiento().equals(""))
			query.append(" and tar.codigoProcedimiento = '"+ dto.getTipoProcedimiento() +"'");

		if (dto.getTipoTarea() != null && !dto.getTipoTarea().equals(""))
			query.append(" and tar.tipoTarea = '"+ dto.getTipoTarea() +"'");
		
		if (dto.getCampanya()!= null && !dto.getCampanya().equals(""))
			query.append(" and tar.campanya = '"+ dto.getCampanya() +"'");
		
		if (!Checks.esNulo(dto.getCartera())){
        	query.append(" and tar.cartera ='" + dto.getCartera() + "'");
        }
		if (!Checks.esNulo(dto.getLote())){
        	query.append(" and tar.lote ='" + dto.getLote() + "'");
        }
		if (!Checks.esNulo(dto.getIdPlaza())){
        	query.append(" and tar.idPlaza ='" + dto.getIdPlaza()+"'");
        }
        if (!Checks.esNulo(dto.getIdJuzgado())){
        	query.append(" and tar.idJuzgado ='" + dto.getIdJuzgado()+"'");
        }
		
		if (dto.getLetradoGestor()!= null && !dto.getLetradoGestor().equals(""))
			query.append(" and tar.letrado = '"+ dto.getLetradoGestor() +"'");
		
        if (dto.getMaxImporteFiltro() == null) {
        	dto.setMaxImporteFiltro((double) Integer.MAX_VALUE);
        }
        
        if (dto.getMinImporteFiltro() == null) {
        	dto.setMinImporteFiltro(0d);
        }

        query.append(" and tar.saldo between " +  dto.getMinImporteFiltro() + " and " + dto.getMaxImporteFiltro());
        
		Long total = new Long(0);
		try{
			total = (Long)getSession().createQuery(query.toString()).uniqueResult();
		}
		catch(Exception e){
		}
		return total;
	}

	@Override
	public List<String> getCarteras() {
		StringBuffer query = new StringBuffer();
		query.append("select distinct tar.cartera from PCExpedienteTarea tar");
		List<String> listaCarteras = new ArrayList<String>();
		try {
			listaCarteras = getSession().createQuery(query.toString()).list();
		} catch (Exception e) {
		}
		
        return listaCarteras;
	}

	@Override
	public List<String> getLotes(String cartera) {
		StringBuffer query = new StringBuffer();
		query.append("select distinct tar.lote from PCExpedienteTarea tar where 1=1");
		query.append("and tar.cartera ='" + cartera + "'");
		List<String> listaLotes = new ArrayList<String>();
		try {
			listaLotes = getSession().createQuery(query.toString()).list();
		} catch (Exception e) {
		}
		
        return listaLotes;
	}

	@Override
	public Float getImportePorTareas(String cod, String rango,
			DtoPanelControlFiltros dto) {
		StringBuffer query = new StringBuffer();
		query.append(" select sum(tar.saldo) from PCExpedienteTarea tar where  ");
		
		query.append(" tar.codigo like '"+cod+"%' ");
		query.append(" and tar.tipo = '"+rango+"'");
		
		if (dto.getTipoProcedimiento() != null && !dto.getTipoProcedimiento().equals(""))
			query.append(" and tar.codigoProcedimiento = '"+ dto.getTipoProcedimiento() +"'");
		
		if (dto.getTipoTarea() != null && !dto.getTipoTarea().equals(""))
			query.append(" and tar.tipoTarea = '"+ dto.getTipoTarea() +"'");
		
		if (dto.getCampanya()!= null && !dto.getCampanya().equals(""))
			query.append(" and tar.campanya = '"+ dto.getCampanya() +"'");
		
		if (!Checks.esNulo(dto.getCartera())){
        	query.append(" and tar.cartera ='" + dto.getCartera() + "'");
        }
		if (!Checks.esNulo(dto.getLote())){
        	query.append(" and tar.lote ='" + dto.getLote() + "'" );
        }
		if (!Checks.esNulo(dto.getIdPlaza())){
        	query.append(" and tar.idPlaza ='" + dto.getIdPlaza()+"'");
        }
        if (!Checks.esNulo(dto.getIdJuzgado())){
        	query.append(" and tar.idJuzgado ='" + dto.getIdJuzgado()+"'");
        }
		if (dto.getLetradoGestor()!= null && !dto.getLetradoGestor().equals(""))
			query.append(" and tar.letrado = '"+ dto.getLetradoGestor() +"'");
		
        if (dto.getMaxImporteFiltro() == null) {
            dto.setMaxImporteFiltro((double) Integer.MAX_VALUE);
        }
        
        if (dto.getMinImporteFiltro() == null) {
            dto.setMinImporteFiltro(0d);
        }

        query.append(" and tar.saldo between " +  dto.getMinImporteFiltro() + " and " + dto.getMaxImporteFiltro());
        
		Float importe = new Float(0);
		try{
			importe = ((Double)getSession().createQuery(query.toString()).uniqueResult()).floatValue();
		}
		catch(Exception e){
		}
		return importe;
	}

	@Override
	public List<String> getCodigosTipoProcedimiento() {
		StringBuffer query = new StringBuffer();
		query.append("select distinct tar.codigoProcedimiento from PCExpedienteTarea tar");
		List<String> listaCarteras = new ArrayList<String>();
		try {
			listaCarteras = getSession().createQuery(query.toString()).list();
		} catch (Exception e) {
		}
		
        return listaCarteras;
	}

	@Override
	public List<String> getListaLotes() {
		StringBuffer query = new StringBuffer();
		query.append("select distinct tar.lote from PCExpedienteTarea tar where 1=1");
		List<String> listaLotes = new ArrayList<String>();
		try {
			listaLotes = getSession().createQuery(query.toString()).list();
		} catch (Exception e) {
		}
		
        return listaLotes;
	}
	
}
