package es.pfsgroup.recovery.ext.turnadodespachos;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Repository
public class EsquemaTurnadoDaoImpl extends AbstractEntityDao<EsquemaTurnado, Long> implements EsquemaTurnadoDao {

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

		// Consulta inicial b?sica
		hqlSelect.append("select esq ");

		hqlFrom.append("from EsquemaTurnado esq");

		return hqlSelect.append(hqlFrom).append(hqlWhere).toString();
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
}
