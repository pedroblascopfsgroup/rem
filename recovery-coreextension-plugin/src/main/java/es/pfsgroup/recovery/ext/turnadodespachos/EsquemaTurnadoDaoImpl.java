package es.pfsgroup.recovery.ext.turnadodespachos;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

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
		
		hqlWhere.append(" where esq.auditoria.borrado = false ");
		if(dto.getTipoEstado() != "" && dto.getTipoEstado() != null){
			hqlWhere.append(" and esq.estado.codigo = '".concat(dto.getTipoEstado()).concat("'"));
		}
		if(dto.getNombreEsquemaTurnado() != "" && dto.getNombreEsquemaTurnado() != null){
			hqlWhere.append(" and esq.descripcion like '%".concat(dto.getNombreEsquemaTurnado()).concat("%'"));
		}
		if(dto.getAutor() != "" && dto.getAutor() != null){
			hqlWhere.append(" and esq.auditoria.usuarioCrear like '%".concat(dto.getAutor()).concat("%'"));
		}
		if(dto.getFechaVigente() != "" && dto.getFechaVigente() != null){
			try {
				Date fechaEnDate = dto.convertirFechaToDate(dto.getFechaVigente());
				/*Calendar c = Calendar.getInstance();
				c.setTime(fechaEnDate);
				c.add(Calendar.DATE, 1);
				Date diaSiguiente = c.getTime();
				SimpleDateFormat dateFormatInit = new SimpleDateFormat("dd/MM/yyyy 00:00:00");
				String formatInit = dateFormatInit.format(fechaEnDate); //2014/08/06 15:59:48
				String formatFin = dateFormatInit.format(diaSiguiente); //2014/08/06 15:59:48*/
				
				String consultaMontad = montaWhere(fechaEnDate, "esq.fechaInicioVigencia");
				//hqlWhere.append(" and esq.fechaInicioVigencia >= to_date('").append(formatInit).append("', 'DD/MM/YYYY HH24:MI:SS') and esq.fechaInicioVigencia < to_date('").append(formatFin).append("', 'DD/MM/YYYY HH24:MI:SS')");
				hqlWhere.append(consultaMontad);
				
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(dto.getFechaFinalizado() != "" && dto.getFechaFinalizado() != null ){
			try {
				Date fechaEnDate = dto.convertirFechaToDate(dto.getFechaFinalizado());
				/*Calendar c = Calendar.getInstance();
				c.setTime(fechaEnDate);
				c.add(Calendar.DATE, 1);
				Date diaSiguiente = c.getTime();
				SimpleDateFormat dateFormatInit = new SimpleDateFormat("dd/MM/yyyy 00:00:00");
				String formatInit = dateFormatInit.format(fechaEnDate); //2014/08/06 15:59:48
				String formatFin = dateFormatInit.format(diaSiguiente); //2014/08/06 15:59:48
				hqlWhere.append(" and esq.fechaFinVigencia >= to_date('").append(formatInit).append("', 'DD/MM/YYYY HH24:MI:SS') and esq.fechaFinVigencia < to_date('").append(formatFin).append("', 'DD/MM/YYYY HH24:MI:SS')");*/
				String consultaMontad = montaWhere(fechaEnDate, "esq.fechaFinVigencia");
				hqlWhere.append(consultaMontad);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(dto.getFechaAlta() != "" && dto.getFechaAlta() != null){
			try {
				Date fechaEnDate = dto.convertirFechaToDate(dto.getFechaAlta());
				/*Calendar c = Calendar.getInstance();
				c.setTime(fechaEnDate);
				c.add(Calendar.DATE, 1);
				Date diaSiguiente = c.getTime();
				SimpleDateFormat dateFormatInit = new SimpleDateFormat("dd/MM/yyyy 00:00:00");
				String formatInit = dateFormatInit.format(fechaEnDate); //2014/08/06 15:59:48
				String formatFin = dateFormatInit.format(diaSiguiente); //2014/08/06 15:59:48
				hqlWhere.append(" and esq.auditoria.fechaCrear >= to_date('").append(formatInit).append("', 'DD/MM/YYYY HH24:MI:SS') and esq.auditoria.fechaCrear < to_date('").append(formatFin).append("', 'DD/MM/YYYY HH24:MI:SS')");*/
				String consultaMontad = montaWhere(fechaEnDate, "esq.auditoria.fechaCrear");
				hqlWhere.append(consultaMontad);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		//String consulta = hqlSelect.append(hqlFrom).append(hqlWhere).toString();
		return hqlSelect.append(hqlFrom).append(hqlWhere).toString();
	}
	
	private String convertirFecha(Date fecha) throws ParseException{
		SimpleDateFormat dateFormatInit = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		String formatInit = dateFormatInit.format(fecha); 
		//DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'hh:mm:ss");
		//String fechaBuena = df.format(fecha);
		return formatInit;
	}
	
	private String montaWhere(Date fechaEnDate, String cadena){
			Calendar c = Calendar.getInstance();
			c.setTime(fechaEnDate);
			c.add(Calendar.DATE, 1);
			Date diaSiguiente = c.getTime();
			SimpleDateFormat dateFormatInit = new SimpleDateFormat("dd/MM/yyyy 00:00:00");
			String formatInit = dateFormatInit.format(fechaEnDate); //2014/08/06 15:59:48
			String formatFin = dateFormatInit.format(diaSiguiente); //2014/08/06 15:59:48
			
			String montado= " and ".concat(cadena).concat(">= to_date('").concat(formatInit).concat("', 'DD/MM/YYYY HH24:MI:SS') and ").concat(cadena).concat("< to_date('").concat(formatFin).concat("', 'DD/MM/YYYY HH24:MI:SS')");
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

}
