package es.pfsgroup.recovery.ext.turnadoProcuradores;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Disjunction;
import org.hibernate.criterion.Expression;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.recovery.ext.turnadodespachos.DDEstadoEsquemaTurnado;
import es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoBusquedaDto;

@Repository
public class EsquemaTurnadoProcuradorDaoImpl extends AbstractEntityDao<EsquemaTurnadoProcurador, Long> implements EsquemaTurnadoProcuradorDao {

	private static final String FORMATO_FECHA_BD = "dd/MM/yyyy 00:00:00";

	private final Log logger = LogFactory.getLog(getClass());

	@Resource
	private PaginationManager paginationManager;

	@Autowired
	private UtilDiccionarioApi utilDiccionario;
	
	@Override
	public EsquemaTurnadoProcurador getEsquemaVigente() {

		// Estado vigente
		DDEstadoEsquemaTurnado estadoVigente = (DDEstadoEsquemaTurnado) utilDiccionario.dameValorDiccionarioByCod(DDEstadoEsquemaTurnado.class, DDEstadoEsquemaTurnado.ESTADO_VIGENTE);
		Assertions.assertNotNull(estadoVigente, "No existe estado de turnado VIGENTE (VIG)");

		HQLBuilder b = new HQLBuilder("from EsquemaTurnadoProcurador d");
		b.appendWhere(Auditoria.UNDELETED_RESTICTION);
		HQLBuilder.addFiltroIgualQue(b, "d.estado.id", estadoVigente.getId());
		EsquemaTurnadoProcurador esquemaVigente = HibernateQueryUtils.uniqueResult(this, b);
		Assertions.assertNotNull(esquemaVigente, "No existe ningún esquema de turnado marcado como vigente");

		return esquemaVigente;
	}

	private void setSortBusquedaEsquemas(EsquemaTurnadoBusquedaDto dto) {
		if (dto.getSort() != null) {
			if (dto.getSort().equals("valorSubasta")) {
				dto.setSort("coalesce(lot.valorBienes,0)");
			} else if (dto.getSort().equals("cargas")) {
				dto.setSort("lot.tieneCargasAnteriores");
			}
		} else {
			dto.setSort("esq.id");
		}
	}
	
	@Override
	public Page buscarEsquemasTurnado(EsquemaTurnadoBusquedaDto dto, Usuario usuLogado) {
		// Establece el orden de la búsqueda
		setSortBusquedaEsquemas(dto);
		return paginationManager.getHibernatePage(getHibernateTemplate(),
				generarHQLBuscarEsquemasTurnado(dto, usuLogado), dto);
	}

	private String generarHQLBuscarEsquemasTurnado(EsquemaTurnadoBusquedaDto dto, Usuario usuLogado) {
		StringBuffer hqlSelect = new StringBuffer();
		StringBuffer hqlFrom = new StringBuffer();
		StringBuffer hqlWhere = new StringBuffer();

		// Consulta inicial básica
		hqlSelect.append("select esq ");

		hqlFrom.append("from EsquemaTurnado esq");

		hqlWhere.append(" where esq.auditoria.borrado = false ");

		if(!Checks.esNulo(dto.getTipoEstado())){
			hqlWhere.append(" and esq.estado.codigo = '").append(dto.getTipoEstado()).append("'");
		}
		if(!Checks.esNulo(dto.getNombreEsquemaTurnado())) {
			hqlWhere.append(" and esq.descripcion like '%").append(dto.getNombreEsquemaTurnado()).append("%'");
		}
		if(!Checks.esNulo(dto.getAutor())){
			hqlWhere.append(" and esq.auditoria.usuarioCrear like '%").append(dto.getAutor()).append("%'");
		}
		if(!Checks.esNulo(dto.getFechaVigente())){
			try {
				Date fechaEnDate = dto.convertirFechaToDate(dto.getFechaVigente());
				String consultaMontad = montaWhere(fechaEnDate, "esq.fechaInicioVigencia");
				hqlWhere.append(consultaMontad);
			} catch (ParseException e) {
				logger.warn("Error al convertir fecha para where en Esquema de turnado Dao", e);
			}
		}
		if(!Checks.esNulo(dto.getFechaFinalizado())){
			try {
				Date fechaEnDate = dto.convertirFechaToDate(dto.getFechaFinalizado());
				String consultaMontad = montaWhere(fechaEnDate, "esq.fechaFinVigencia");
				hqlWhere.append(consultaMontad);
			} catch (ParseException e) {
				logger.warn("Error al convertir fecha para where en Esquema de turnado Dao", e);
			}
		}
		if(!Checks.esNulo(dto.getFechaAlta())){
			try {
				Date fechaEnDate = dto.convertirFechaToDate(dto.getFechaAlta());
				String consultaMontad = montaWhere(fechaEnDate, "esq.auditoria.fechaCrear");
				hqlWhere.append(consultaMontad);
			} catch (ParseException e) {
				logger.warn("Error al convertir fecha para where en Esquema de turnado Dao", e);
			}
		}
		return hqlSelect.append(hqlFrom).append(hqlWhere).toString();
	}

	private String montaWhere(Date fechaEnDate, String cadena){
			Calendar c = Calendar.getInstance();
			c.setTime(fechaEnDate);
			c.add(Calendar.DATE, 1);
			Date diaSiguiente = c.getTime();
			SimpleDateFormat dateFormatInit = new SimpleDateFormat(FORMATO_FECHA_BD);
			String formatInit = dateFormatInit.format(fechaEnDate); //2014/08/06 15:59:48
			String formatFin = dateFormatInit.format(diaSiguiente); //2014/08/06 15:59:48
			
			String montado = String.format("and %s >= to_date('%s', 'DD/MM/YYYY HH24:MI:SS') and %s < to_date('%s', 'DD/MM/YYYY HH24:MI:SS')"
					, cadena
					, formatInit
					, cadena
					, formatFin);

			return montado;
	}

	@Override
	public void turnarProcurador(Long prcId, String username, String plaza, String tpo) {
		Session session = this.getSessionFactory().getCurrentSession();
		Query query = session.createSQLQuery(
				"CALL asignacion_turnado_procu(:idAsunto, :username, :plaza, :tpo)")
				.setParameter("idAsunto", prcId)
				.setParameter("username", username)
				.setParameter("plaza", plaza)
				.setParameter("tpo", tpo);
						
		query.executeUpdate();
	}

	@Override
	public int cuentaLetradosAsignados(List<String> codigosCI
			,List<String> codigosCC
			,List<String> codigosLI
			,List<String> codigosLC
			) {
		
		// No se ha encontrado ninguno
		if (codigosCI.size()==0 
				&& codigosCC.size()==0
				&& codigosLI.size()==0
				&& codigosLC.size()==0
			) {
			return 0;
		}
		
		Disjunction disjunction = Restrictions.disjunction();
		if (codigosCI.size()>0) {
			disjunction.add(Expression.in("desp.turnadoCodigoImporteConcursal", codigosCI));
		}
		if (codigosCC.size()>0) {
			disjunction.add(Expression.in("desp.turnadoCodigoCalidadConcursal", codigosCC));
		}
		if (codigosLI.size()>0) {
			disjunction.add(Expression.in("desp.turnadoCodigoImporteLitigios", codigosLI));
		}
		if (codigosLC.size()>0) {
			disjunction.add(Expression.in("desp.turnadoCodigoCalidadLitigios", codigosLC));
		}
		
		Session session = this.getSessionFactory().getCurrentSession();
		Criteria criteria = session.createCriteria(DespachoExterno.class, "desp");
		criteria.add(Expression.eq("desp.auditoria.borrado", false));
		criteria.add(disjunction);
		
		int result = (Integer)criteria.setProjection(Projections.rowCount()).uniqueResult();
		return result;
	}

	@SuppressWarnings("unused")
	@Override
	public void limpiarTurnadoTodosLosDespachos() {
		String updateQuery= "update DespachoExterno set turnadoCodigoImporteConcursal=null,turnadoCodigoCalidadConcursal=null,"
				+ "turnadoCodigoImporteLitigios=null,turnadoCodigoCalidadLitigios=null where auditoria.borrado=false";
		Query query = this.getSessionFactory().getCurrentSession().createQuery(updateQuery);
		int recordupdated=query.executeUpdate();
	}
	
	@SuppressWarnings("unchecked")
	@Override
    public Collection<? extends TipoPlaza> getPlazas(String query) {
        StringBuilder hql = new StringBuilder();
        hql.append("from TipoPlaza ");
        hql.append("where auditoria.borrado = false ");
        hql.append("and descripcion like '%" + query.toUpperCase() + "%' ");
        hql.append("order by descripcion");

        Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());

        return q.list();
    }
	
	@SuppressWarnings("unchecked")
	@Override
    public Collection<? extends TipoProcedimiento> getTPOs(String query) {
        StringBuilder hql = new StringBuilder();
        hql.append("from TipoProcedimiento ");
        hql.append("where auditoria.borrado = false ");
        hql.append("and upper(descripcion) like '%" + query.toUpperCase() + "%' ");
        hql.append("order by codigo");

        Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());

        return q.list();
    }

	@SuppressWarnings("unchecked")
	@Override
	public List<TipoPlaza> getPlazasEquema(Long idEsquema) {
		StringBuilder hql = new StringBuilder();
        hql.append("select ept.tipoPlaza from EsquemaPlazasTpo ept ");
        hql.append("where ept.auditoria.borrado = false ");
        hql.append("and ept.esquemaTurnadoProcurador.id ="+idEsquema+" ");

        Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());

        return q.list();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<TipoProcedimiento> getTiposProcedimientoPorPlazaEsquema(Long idEsquema, Long idPlaza) {
		StringBuilder hql = new StringBuilder();
		hql.append("select ept.tipoProcedimiento from EsquemaPlazasTpo ept ");
        hql.append("where ept.auditoria.borrado = false ");
        hql.append("and ept.esquemaTurnadoProcurador.id ="+idEsquema+" ");
        hql.append("and ept.tipoPlaza.id ="+idPlaza+" ");
        
        Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());

        return q.list();
	}
	
	/*
	@SuppressWarnings("unchecked")
	@Override
	public List<TurnadoProcuradorConfig> getRangosPorPlazaTPOEsquema(Long idEsquema, Long idPlaza, Long idTPO) {
		StringBuilder hql = new StringBuilder();
		hql.append("from TurnadoProcuradorConfig conf ");
        hql.append("where conf.auditoria.borrado = false ");
        hql.append("and conf.esquemaPlazasTpo.esquemaTurnadoProcurador.id ="+idEsquema+" ");
        if(idPlaza!=null) hql.append("and conf.esquemaPlazasTpo.tipoPlaza.id ="+idPlaza+" ");
        if(idTPO!=null) hql.append("and conf.esquemaPlazasTpo.tipoProcedimiento.id ="+idTPO+" ");
        hql.append("order by conf.esquemaPlazasTpo.tipoProcedimiento ASC, conf.importeDesde ASC, conf.porcentaje ASC");
        
        Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());

        return q.list();
	}
	*/

	@SuppressWarnings("unchecked")
	@Override
	public List<Usuario> getDespachosProcuradores(List<String> despachosValidos) {
		StringBuilder hql = new StringBuilder();
		hql.append("select usd.usuario from GestorDespacho usd ");
        hql.append("where usd.auditoria.borrado = false ");
        hql.append("and usd.usuario.auditoria.borrado = false ");
        hql.append("and usd.despachoExterno.auditoria.borrado = false ");
        hql.append("and usd.despachoExterno.tipoDespacho ='"+DDTipoDespachoExterno.CODIGO_DESPACHO_PROCURADOR+"' ");
        if(!Checks.estaVacio(despachosValidos)){
        	hql.append("and usd.despachoExterno.despacho in (");
        	for(int i = 0; i<despachosValidos.size();i++){
        		if(i==0) hql.append("'"+despachosValidos.get(i)+"'");
        		else hql.append(",'"+despachosValidos.get(i)+"'");
        	}
        	hql.append(") ");
        }
        hql.append("order by usd.usuario.nombre ASC");
        
        Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());

        return q.list();
	}

	@Override
	public void borradoFisicoConfigPlazaTPO(List<Long> idsPlazasTpo) {
		if(!Checks.estaVacio(idsPlazasTpo)){
			//Delete de TUP_TPC_TURNADO_PROCU_CONFIG
			StringBuilder hql = new StringBuilder();
			hql.append("delete conf from TurnadoProcuradorConfig conf ");
	        hql.append("where conf.esquemaPlazasTpo.id in (");
	        for(int i = 0; i<idsPlazasTpo.size(); i++) {
	        	if(i==0) hql.append(idsPlazasTpo.get(i));
	        	else hql.append(","+idsPlazasTpo.get(i));
	        }
	        hql.append(")");
	        Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());
	        q.executeUpdate();
	        
	        //Delete de TUP_EPT_ESQUEMA_PLAZAS_TPO
	        hql = new StringBuilder();
			hql.append("delete ept from EsquemaPlazasTpo ept ");
	        hql.append("where ept.id in (");
	        for(int i = 0; i<idsPlazasTpo.size(); i++) {
	        	if(i==0) hql.append(idsPlazasTpo.get(i));
	        	else hql.append(","+idsPlazasTpo.get(i));
	        }
	        hql.append(")");
	        q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());
	        q.executeUpdate();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Long> getIdsEPTPorCodigoPlaza(String plazaCod) {
		StringBuilder hql = new StringBuilder();
		hql.append("select ept.id from EsquemaPlazasTpo ept ");
        hql.append("where ept.tipoPlaza.codigo = '"+plazaCod+"'");
        
        Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());
        List<Long> list = q.list();
        return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Long> getIdsEPTPorCodigoTPO(String tpoCod, String[] arrayPlazas) {
		StringBuilder hql = new StringBuilder();
		hql.append("select ept.id from EsquemaPlazasTpo ept ");
		hql.append("where ept.tipoProcedimiento.codigo = '"+tpoCod+"'");
        hql.append("and ept.tipoPlaza.codigo in (");
        for(int i = 0; i<arrayPlazas.length; i++) {
        	if(i==0) hql.append("'"+arrayPlazas[i]+"'");
        	else hql.append(",'"+arrayPlazas[i]+"'");
        }
        hql.append(")");
        
        Query q = this.getSessionFactory().getCurrentSession().createQuery(hql.toString());
        List<Long> list = q.list();
        return list;
	}
}
