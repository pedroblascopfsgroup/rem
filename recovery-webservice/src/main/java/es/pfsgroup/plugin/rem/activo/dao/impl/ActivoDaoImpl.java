package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.math.BigDecimal;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.BooleanUtils;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;

@Repository("ActivoDao")
public class ActivoDaoImpl extends AbstractEntityDao<Activo, Long> implements ActivoDao{

	@Resource
	private PaginationManager paginationManager;

    @Override
	public Page getListActivos(DtoActivoFilter dto, Usuario usuLogado) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaActivos act");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivo", dto.getNumActivo());
		
   		if (dto.getEntidadPropietariaCodigo() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.entidadPropietariaCodigo", dto.getEntidadPropietariaCodigo(), true);

   		if (dto.getTipoTituloActivoCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoTituloActivoCodigo", dto.getTipoTituloActivoCodigo());

   		if (dto.getSubtipoActivoCodigo() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.subtipoActivoCodigo", dto.getSubtipoActivoCodigo(), true);
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.refCatastral", dto.getRefCatastral(), true);
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.finca", dto.getFinca(), true);
   		if (dto.getProvinciaCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.provinciaCodigo", dto.getProvinciaCodigo());
   		
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadDescripcion", dto.getLocalidadDescripcion(), true);
   		
   		//Parámteros para la búsqueda avanzada
   		if (dto.getNumActivoRem() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoRem", dto.getNumActivoRem());
   		
   		if (dto.getIdProp() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoPrinex", Long.valueOf(dto.getIdProp()));
   		
   		if (dto.getIdRecovery() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.idRecovery", Long.valueOf(dto.getIdRecovery()));
   		
   		if (dto.getIdUvem() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoUvem", Long.valueOf(dto.getIdUvem()));
   		
   		if (dto.getEstadoActivoCodigo() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.estadoActivoCodigo", dto.getEstadoActivoCodigo());
   		
   		if (dto.getTipoViaCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoViaCodigo", dto.getTipoViaCodigo());
   		
   		if (dto.getNombreVia() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.nombreVia", dto.getNombreVia(), true);
   		
   		if (dto.getCodPostal() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.codPostal", dto.getCodPostal(), true);
   		
   		if (dto.getProvinciaAvanzada() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.provinciaCodigo", dto.getProvinciaAvanzada());
   		
   		if (dto.getMunicipio() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadDescripcion", dto.getMunicipio(), true);
   		
   		/*if (dto.getUnidadInferior() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.unidadPoblacional.descripcion", dto.getUnidadInferior(), true);*/
   		
   		if (dto.getPaisCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.paisCodigo", dto.getPaisCodigo());
   		
   		if (dto.getNumRegistro() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numRegistro", dto.getNumRegistro());
   		
   		if (dto.getLocalidadRegistroDescripcion() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadRegistroDescripcion", dto.getLocalidadRegistroDescripcion(), true);
   		
   		if (dto.getIdufir() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.idufir", dto.getIdufir(), true);
   		
   		if (dto.getFincaAvanzada() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.finca", dto.getFincaAvanzada(), true);
   		
   		if (dto.getOcupado() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.ocupado", dto.getOcupado());
   		
   		if (dto.getConTitulo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conTitulo", dto.getConTitulo());

		return HibernateQueryUtils.page(this, hb, dto);

	}
    
    @Override
	public List<Activo> getListActivosLista(DtoActivoFilter dto, Usuario usuLogado) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaActivos act");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivo", dto.getNumActivo());
		
   		if (dto.getEntidadPropietariaCodigo() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.entidadPropietariaCodigo", dto.getEntidadPropietariaCodigo(), true);

   		if (dto.getTipoTituloActivoCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoTituloActivoCodigo", dto.getTipoTituloActivoCodigo());

   		if (dto.getSubtipoActivoCodigo() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.subtipoActivoCodigo", dto.getSubtipoActivoCodigo(), true);
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.refCatastral", dto.getRefCatastral(), true);
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.finca", dto.getFinca(), true);
   		if (dto.getProvinciaCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.provinciaCodigo", dto.getProvinciaCodigo());
   		
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadDescripcion", dto.getLocalidadDescripcion(), true);
   		
   		//Parámteros para la búsqueda avanzada
   		if (dto.getNumActivoRem() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoRem", dto.getNumActivoRem());
   		
   		if (dto.getIdProp() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoPrinex", Long.valueOf(dto.getIdProp()));
   		
   		if (dto.getIdRecovery() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.idRecovery", Long.valueOf(dto.getIdRecovery()));
   		
   		if (dto.getIdUvem() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoUvem", Long.valueOf(dto.getIdUvem()));
   		
   		if (dto.getEstadoActivoCodigo() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.estadoActivoCodigo", dto.getEstadoActivoCodigo());
   		
   		if (dto.getTipoViaCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoViaCodigo", dto.getTipoViaCodigo());
   		
   		if (dto.getNombreVia() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.nombreVia", dto.getNombreVia(), true);
   		
   		if (dto.getCodPostal() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.codPostal", dto.getCodPostal(), true);
   		
   		if (dto.getProvinciaAvanzada() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.provinciaCodigo", dto.getProvinciaAvanzada());
   		
   		if (dto.getMunicipio() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadDescripcion", dto.getMunicipio(), true);
   		
   		/*if (dto.getUnidadInferior() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.unidadPoblacional.descripcion", dto.getUnidadInferior(), true);*/
   		
   		if (dto.getPaisCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.paisCodigo", dto.getPaisCodigo());
   		
   		if (dto.getNumRegistro() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numRegistro", dto.getNumRegistro());
   		
   		if (dto.getLocalidadRegistroDescripcion() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadRegistroDescripcion", dto.getLocalidadRegistroDescripcion(), true);
   		
   		if (dto.getIdufir() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.idufir", dto.getIdufir(), true);
   		
   		if (dto.getFincaAvanzada() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.finca", dto.getFincaAvanzada(), true);
   		
   		if (dto.getOcupado() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.ocupado", dto.getOcupado());
   		
   		if (dto.getConTitulo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conTitulo", dto.getConTitulo());

		return HibernateQueryUtils.list(this, hb);

	}
    
    @Override
	public Page getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, Usuario usuLogado) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaPresupuestosActivo pre");
		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pre.idActivo", dto.getIdActivo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pre.id", dto.getIdPresupuesto());
   		
		
   		return HibernateQueryUtils.page(this, hb, dto);

	}
    
    
    
    @Override
	public Integer isIntegradoAgrupacionRestringida(Long id, Usuario usuLogado) {

		/*HQLBuilder hb = new HQLBuilder("select count(*) from Activo act");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.id", id);
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.agrupaciones.agrupacion.tipoAgrupacion.id", 1);
		*/
    	HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo act where act.activo.id = " + id + " and act.agrupacion.tipoAgrupacion.id = " + 2);

		/*HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.activo.id", id);
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.agrupacion.agrupacion.tipoAgrupacion.id", 1);
   		//getHibernateTemplate().*/
    	//Integer cont = ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue();

   		return ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
		//return HibernateQueryUtils.uniqueResult(this, hb);

	}
    
    
    @Override
	public Integer isIntegradoAgrupacionObraNueva(Long id, Usuario usuLogado) {

    	HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo act where act.activo.id = " + id + " and act.agrupacion.tipoAgrupacion.id = " + 1);

    	//Integer cont = ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue();

   		return ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue();

	}
    
    @SuppressWarnings("unchecked")
	@Override
    public List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio) {
    	
		 String hql = "from DDUnidadPoblacional where localidad.codigo= ? and codigo NOT LIKE '%0000'";
		
		 List<DDUnidadPoblacional> list = getHibernateTemplate().find(hql, new Object[] { codigoMunicipio });
		 return list;
	 
    }
    
    @Override
	public Integer getMaxOrdenFotoById(Long id) {

    	HQLBuilder hb = new HQLBuilder("select max(orden) from ActivoFoto foto where foto.activo.id = " + id);
    	try {
    		//Integer cont = ((Integer) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
    		return ((Integer) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
    	} catch (Exception e) {
    		return 0;
    	}

	}
    
    @Override
	public Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, BigDecimal hashSdv) {

    	HQLBuilder hb = new HQLBuilder("select max(orden) from ActivoFoto foto where foto.agrupacion.id = " 
    	+ idEntidad
    	+ " and foto.subdivision = "
    	+ hashSdv);
    	try {
    		//Integer cont = ((Integer) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
    		return ((Integer) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
    	} catch (Exception e) {
    		return 0;
    	}

	}
    
    @Override
   	public Long getUltimoPresupuesto(Long id) {

       	HQLBuilder hb = new HQLBuilder("select presupuesto.id from PresupuestoActivo presupuesto where presupuesto.activo.id = " + id 
       			+ " and presupuesto.ejercicio.anyo = (select max(ejer.anyo) from Ejercicio ejer) ");
       	try {
       		//Integer cont = ((Integer) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
       		if (getHibernateTemplate().find(hb.toString()) != null)
	       		return ((Long) getHibernateTemplate().find(hb.toString()).get(0));
       		else return null;
       	} catch (Exception e) {
       		e.printStackTrace();
       		return null;
       	}

   	}
    
    @Override
	public Page getListActivosPrecios(DtoActivoFilter dto) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaActivosPrecios act");
	
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.entidadPropietariaCodigo", dto.getEntidadPropietariaCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoTituloActivoCodigo", dto.getTipoTituloActivoCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.subTipoTituloActivoCodigo", dto.getSubtipoTituloActivoCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.inscrito", dto.getInscrito());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conPosesion", dto.getConPosesion());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conCargas", dto.getConCargas());
   		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoComercializacion", dto.getTipoComercializacion());
   		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conOfertaAprobada", dto.getConOfertaAprobada());
   		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conReserva", dto.getConReserva());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tieneMediador", dto.getTieneMediador());
   		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tieneLLavesMediador", dto.getTieneLLavesMediador());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.estadoInformeComercial", dto.getEstadoInformeComercial());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conTasacion", dto.getConTasacion());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.codigoProvincia", dto.getProvinciaCodigo());
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.municipio", dto.getMunicipio(), true);
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.codigoPostal", dto.getCodPostal());
   		
   		if(!Checks.esNulo(dto.getConFsvVenta())) {
   			if(BooleanUtils.toBoolean(dto.getConFsvVenta())) {
   				hb.appendWhere("act.fsvVenta is not null");
   			} else {
   				hb.appendWhere("act.fsvVenta is null");
   			}
   		}
   		
   		if(!Checks.esNulo(dto.getConFsvRenta())) {
   			if(BooleanUtils.toBoolean(dto.getConFsvRenta())) {
   				hb.appendWhere("act.fsvRenta is not null");
   			} else {
   				hb.appendWhere("act.fsvRenta is null");
   			}
   		}
   		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conBloqueo", dto.getConBloqueo());
   		
   		
		return HibernateQueryUtils.page(this, hb, dto);

	}
    
    @Override
	public Page getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto) {

		HQLBuilder hb = new HQLBuilder(" from ActivoHistoricoValoraciones hist");
	
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "hist.activo.id", dto.getIdActivo());   		
   		
		return HibernateQueryUtils.page(this, hb, dto);

	}

	@Override
	public void deleteValoracionById(Long id) {
	
		StringBuilder sb = new StringBuilder("delete from ActivoValoraciones val where val.id = "+id);		
		getSession().createQuery(sb.toString()).executeUpdate();
		
	}
    
    @SuppressWarnings("unchecked")
	@Override
    public ActivoCondicionEspecifica getUltimaCondicion(Long idActivo) {
    	
		 String hql = "from ActivoCondicionEspecifica where activo.id = ? and fechaHasta IS NULL";
		
		 List<ActivoCondicionEspecifica> listaCondiciones = getHibernateTemplate().find(hql, new Object[] { idActivo });
		 
		 return !Checks.estaVacio(listaCondiciones)?listaCondiciones.get(0):null;			
	 
    }

	@Override
	public Page getPropuestas(DtoPropuestaFilter dto) {
		
		HQLBuilder hb = new HQLBuilder(" from VBusquedaPropuestasActivo propact");
		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.entidadPropietariaCodigo", dto.getEntidadPropietariaCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.numPropuesta", dto.getNumPropuesta());
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "propact.nombrePropuesta", dto.getNombrePropuesta());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.estadoCodigo", dto.getEstadoCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.estadoActivoCodigo", dto.getEstadoCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.idActivo", dto.getIdActivo());
   		
		return HibernateQueryUtils.page(this, hb, dto);

	}

	@Override
	public Page getActivosPublicacion(DtoActivosPublicacion dto) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaPublicacionActivo activopubli");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.numActivo", dto.getNumActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.tipoActivoCodigo", dto.getTipoActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.subtipoActivoCodigo", dto.getSubtipoActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.cartera", dto.getCartera());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.despublicadoForzado", dto.getDespubliForzado());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.publicadoForzado", dto.getPubliForzado());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.admision", dto.getAdmision());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.gestion", dto.getGestion());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.publicacion", dto.getPublicacion());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.precio", dto.getPrecio());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.precioConsultar", dto.getPrecioConsultar());
   		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@SuppressWarnings("unchecked")
	@Override
	public ActivoHistoricoEstadoPublicacion getUltimoHistoricoEstadoPublicacion(Long activoID) {
		
		String hql = "from ActivoHistoricoEstadoPublicacion historico where historico.activo.id = ? and auditoria.borrado = false order by historico.id desc";
		
		 List<ActivoHistoricoEstadoPublicacion> historicoLista = getHibernateTemplate().find(hql, new Object[] { activoID });
		 
		 return !Checks.estaVacio(historicoLista)?historicoLista.get(0):null;
	}
	
    public Long getNextNumOferta() {
		String sql = "SELECT S_ECO_NUM_EXPEDIENTE.NEXTVAL FROM DUAL ";
		return ((BigDecimal) getSession().createSQLQuery(sql).uniqueResult()).longValue();
	}

}
