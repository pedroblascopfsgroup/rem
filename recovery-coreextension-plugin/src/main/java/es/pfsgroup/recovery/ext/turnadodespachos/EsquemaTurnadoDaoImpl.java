package es.pfsgroup.recovery.ext.turnadodespachos;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
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
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Repository
public class EsquemaTurnadoDaoImpl extends AbstractEntityDao<EsquemaTurnado, Long> implements EsquemaTurnadoDao {

	private static final String FORMATO_FECHA_BD = "dd/MM/yyyy 00:00:00";

	private final Log logger = LogFactory.getLog(getClass());

	@Resource
	private PaginationManager paginationManager;

	@Autowired
	private UtilDiccionarioApi utilDiccionario;
	
	@Override
	public EsquemaTurnado getEsquemaVigente() {

		// Estado vigente
		DDEstadoEsquemaTurnado estadoVigente = (DDEstadoEsquemaTurnado)utilDiccionario.dameValorDiccionarioByCod(DDEstadoEsquemaTurnado.class, DDEstadoEsquemaTurnado.ESTADO_VIGENTE);
		Assertions.assertNotNull(estadoVigente, "No existe estado de turnado VIGENTE (VIG)");

		HQLBuilder b = new HQLBuilder("from EsquemaTurnado d");
		b.appendWhere(Auditoria.UNDELETED_RESTICTION);
		HQLBuilder.addFiltroIgualQue(b, "d.estado.id", estadoVigente.getId());
		EsquemaTurnado esquemaVigente = HibernateQueryUtils.uniqueResult(this, b);
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
	public void turnar(Long idAsunto, String username, String codigoGestor) {
		Session session = this.getSessionFactory().getCurrentSession();
		Query query = session.createSQLQuery(
				"CALL asignacion_asuntos_turnado(:idAsunto, :username, :codigoGestor)")
				.setParameter("idAsunto", idAsunto)
				.setParameter("username", username)
				.setParameter("codigoGestor", codigoGestor);
						
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

	@Override
	public void limpiarTurnadoTodosLosDespachos() {
		String updateQuery= "update DespachoExterno set turnadoCodigoImporteConcursal=null,turnadoCodigoCalidadConcursal=null,"
				+ "turnadoCodigoImporteLitigios=null,turnadoCodigoCalidadLitigios=null where auditoria.borrado=false";
		Query query = this.getSessionFactory().getCurrentSession().createQuery(updateQuery);
		int recordupdated=query.executeUpdate();
	}
	
}
