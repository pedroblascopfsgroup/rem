package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoCalificacionNegativa;
import es.pfsgroup.plugin.rem.model.ActivoCondicionEspecifica;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTasacion;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoActivosPublicacion;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPreciosFilter;
import es.pfsgroup.plugin.rem.model.DtoHistoricoPresupuestosFilter;
import es.pfsgroup.plugin.rem.model.DtoLlaves;
import es.pfsgroup.plugin.rem.model.DtoPropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.DtoPropuestaFilter;
import es.pfsgroup.plugin.rem.model.DtoTrabajoListActivos;
import es.pfsgroup.plugin.rem.model.HistoricoDestinoComercial;
import es.pfsgroup.plugin.rem.model.PropuestaActivosVinculados;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPrecios;
import es.pfsgroup.plugin.rem.model.VBusquedaPublicacionActivo;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.VOfertasTramitadasPendientesActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.utils.MSVREMUtils;

@Repository("ActivoDao")
public class ActivoDaoImpl extends AbstractEntityDao<Activo, Long> implements ActivoDao {

	private static final String REST_USER_USERNAME = "REST-USER";
	private static final String REST_USER_HDC_NAME = "Proceso Excel Masivo";

	@Autowired
	private MSVRawSQLDao rawDao;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GenericAdapter adapter;

    @Override
	public Page getListActivos(DtoActivoFilter dto, Usuario usuLogado) {

		HQLBuilder hb = new HQLBuilder(buildFrom(dto));

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivo", dto.getNumActivo());
		
   		if (dto.getEntidadPropietariaCodigo() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.entidadPropietariaCodigo", dto.getEntidadPropietariaCodigo(), true);

   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.entidadPropietariaCodigo", dto.getEntidadPropietariaCodigoAvanzado(), true);
   		
   		if (dto.getTipoTituloActivoCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoTituloActivoCodigo", dto.getTipoTituloActivoCodigo());

   		if (dto.getSubtipoActivoCodigo() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.subtipoActivoCodigo", dto.getSubtipoActivoCodigo(), true);
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.refCatastral", dto.getRefCatastral(), true);
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.finca", dto.getFinca(), true);
   		if (dto.getProvinciaCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.provinciaCodigo", dto.getProvinciaCodigo());
   		
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadDescripcion", dto.getLocalidadDescripcion(), true);
   		if(dto.getCodigoPromocionPrinex() != null) {
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.codigoPromocionPrinex", dto.getCodigoPromocionPrinex());
   		}
   		
   		//Parámteros para la búsqueda avanzada
   		if (dto.getIdSareb() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoSareb", dto.getIdSareb());
   		
   		if (dto.getIdProp() != null && StringUtils.isNumeric(dto.getIdProp()))
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

   		if (dto.getComboSelloCalidad() != null){
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.selloCalidad", dto.getComboSelloCalidad().equals(Integer.valueOf(1)) ? true : false);
   		}

   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "scr.codigo", dto.getSubcarteraCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "scr.codigo", dto.getSubcarteraCodigoAvanzado());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoActivoCodigo", dto.getTipoActivoCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tud.codigo", dto.getTipoUsoDestinoCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ca.codigo", dto.getClaseActivoBancarioCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "subca.codigo", dto.getSubClaseActivoBancarioCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "subtipotitulo.codigo", dto.getSubtipoTituloActivoCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.divHorizontal", dto.getDivisionHorizontal());

   		if (dto.getInscrito() != null) {
   	   		if (dto.getInscrito() == 0) {
   	   			hb.appendWhere(" tit.fechaInscripcionReg IS NULL ");	
   	   		} else {
   	   			hb.appendWhere(" tit.fechaInscripcionReg IS NOT NULL");
   	   		}
   		}

   		HQLBuilder.addFiltroLikeSiNotNull(hb, "pro.nombre", dto.getPropietarioNombre(), true);
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "pro.docIdentificativo", dto.getPropietarioNIF(), true);

   		if (dto.getConPosesion() != null) {
   	   		if (dto.getConPosesion() == 0) {
   	   			hb.appendWhere(" act.fechaTomaPosesion IS NULL ");	
   	   		} else {
   	   			hb.appendWhere(" act.fechaTomaPosesion IS NOT NULL");
   	   		}
   		}

   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.accesoTapiado", dto.getAccesoTapiado());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.accesoAntiocupa", dto.getAccesoAntiocupa());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.situacionComercialCodigo", dto.getSituacionComercialCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoTituloPosesorio", dto.getTipoTituloPosesorio());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tco.codigo", dto.getTipoComercializacionCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "perac.aplicaGestion", dto.getPerimetroGestion());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.flagRating", dto.getRatingCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conCargas", dto.getConCargas());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gausu.id", dto.getUsuarioGestor());

		return HibernateQueryUtils.page(this, hb, dto);

	}

    private String buildFrom(DtoActivoFilter dto) {
    	StringBuilder sb = new StringBuilder("select act from VBusquedaActivos act ");

    	if (!Checks.esNulo(dto.getSubcarteraCodigo()) || !Checks.esNulo(dto.getSubcarteraCodigoAvanzado())) {
    		sb.append(" join act.subcartera scr ");
    	}

    	if (!Checks.esNulo(dto.getTipoUsoDestinoCodigo())) {
    		sb.append(" join act.tipoUsoDestino tud ");
    	}

    	if (!Checks.esNulo(dto.getClaseActivoBancarioCodigo()) || !Checks.esNulo(dto.getSubClaseActivoBancarioCodigo())) {
    		sb.append(" join act.activoBancario ab");

    		if (!Checks.esNulo(dto.getClaseActivoBancarioCodigo())) {
    			sb.append(" join ab.claseActivo ca ");
    		}

    		if (!Checks.esNulo(dto.getSubClaseActivoBancarioCodigo())) {
    			sb.append(" join ab.subtipoClaseActivo subca ");
    		}
    	}

    	if (!Checks.esNulo(dto.getSubtipoTituloActivoCodigo())) {
    		sb.append(" join act.subtipoTitulo subtipotitulo ");
    	}

    	if (dto.getInscrito() != null) {
    		sb.append(" join act.titulo tit ");
    	}

    	if (!Checks.esNulo(dto.getPropietarioNIF()) || !Checks.esNulo(dto.getPropietarioNombre())) {
    		sb.append(" join act.propietariosActivo pac ");
    		sb.append(" join pac.propietario pro ");
    	}

    	if (!Checks.esNulo(dto.getTipoComercializacionCodigo())) {
    		sb.append(" join act.tipoComercializacion tco ");
    	}

    	if (dto.getPerimetroGestion() != null) {
    		sb.append(" join act.perimetroActivo perac ");
    	}

    	if (dto.getUsuarioGestor() != null) {
    		sb.append(" join act.gestoresActivo ga ");
    		sb.append(" join ga.usuario gausu ");
    	}
    	
    	return sb.toString();
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
   		if(dto.getCodigoPromocionPrinex() != null) {
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.codigoPromocionPrinex", dto.getCodigoPromocionPrinex());
   		}
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

   		if (dto.getComboSelloCalidad() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.selloCalidad", dto.getComboSelloCalidad());
   		
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
    	HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.activo.id = " + id + " and act.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);

   		return ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
	}

    @Override
    public Integer isIntegradoAgrupacionComercial(Long idActivo) {
    	HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.activo.id = " + idActivo + " and act.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL);

   		return ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
    }

    @Override
	public Integer isActivoPrincipalAgrupacionRestringida(Long id) {
    	HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.agrupacion.activoPrincipal.id = " + id + " and act.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);

    	return ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
	}

    @Override
    public ActivoAgrupacionActivo getActivoAgrupacionActivoAgrRestringidaPorActivoID(Long id) {
    	HQLBuilder hb = new HQLBuilder("select act from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.activo.id = " + id + " and act.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);

    	return ((ActivoAgrupacionActivo) getHibernateTemplate().find(hb.toString()).get(0));
	}

    @Override
	public Integer isIntegradoAgrupacionObraNueva(Long id, Usuario usuLogado) {
    	HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.activo.id = " + id + " and act.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA);

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
   	public Long getPresupuestoActual(Long id) {
    	SimpleDateFormat df = new SimpleDateFormat("yyyy");
    	String yearNow = df.format(new Date());
    	
       	HQLBuilder hb = new HQLBuilder("select presupuesto.id from PresupuestoActivo presupuesto "
       			+ " where presupuesto.activo.id = " + id 
       			+ " and presupuesto.ejercicio.anyo = " + yearNow);

       	try {
       		if (getHibernateTemplate().find(hb.toString()).size() > 0)
	       		return ((Long) getHibernateTemplate().find(hb.toString()).get(0));
       		else return null;
       	} catch (Exception e) {
       		e.printStackTrace();
       		return null;
       	}
   	}
    
    @Override
   	public Long getUltimoHistoricoPresupuesto(Long id) {
       	HQLBuilder hb = new HQLBuilder("select presupuesto.id from PresupuestoActivo presupuesto "
       			+ " where presupuesto.activo.id = " + id 
       			+ " order by presupuesto.ejercicio.anyo desc ");

       	try {
       		if (getHibernateTemplate().find(hb.toString()).size() > 0)
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
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.destinoComercialCodigo", dto.getDestinoComercialCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conOfertaAprobada", dto.getConOfertaAprobada());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conReserva", dto.getConReserva());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tieneMediador", dto.getTieneMediador());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tieneLLavesMediador", dto.getTieneLLavesMediador());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.estadoInformeComercial", dto.getEstadoInformeComercial());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conTasacion", dto.getConTasacion());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.codigoProvincia", dto.getProvinciaCodigo());
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.municipio", dto.getMunicipio(), true);
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.codigoPostal", dto.getCodPostal());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.subcarteraCodigo", dto.getSubcarteraCodigo());
   		
   		//caso multiseleccion propietarios
   		if(dto.getPropietario() != null && !dto.getPropietario().isEmpty() && dto.getPropietario().contains(",")){
   			ArrayList<String> valores = new ArrayList<String>();
   			for(String token : dto.getPropietario().split(",")){
   				valores.add(token);
   			}
   			HQLBuilder.addFiltroWhereInSiNotNull(hb, "act.idPropietario", valores);
   			
   		}else{
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.idPropietario", dto.getPropietario());
   		}

   		if (dto.getSubcarteraCodigo() != null) {
   			if("00".equals(dto.getSubcarteraCodigo())) {
   				List<String> lista = new ArrayList<String>();
   				Collections.addAll(lista, "'"+DDSubcartera.CODIGO_BAN_BFA+"'", "'"+DDSubcartera.CODIGO_BAN_BH+"'", "'"+DDSubcartera.CODIGO_BAN_BK+"'");
   				HQLBuilder.addFiltroWhereInSiNotNull(hb, "act.subcarteraCodigo", lista);
   			} else {
   				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.subcarteraCodigo", dto.getSubcarteraCodigo());
   			}
   		}
   		
   		if (dto.getEstadoActivoCodigo() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.estadoActivoCodigo", dto.getEstadoActivoCodigo());
   		
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
   		if(!Checks.esNulo(dto.getMinimoVigente())) {
   			if(BooleanUtils.toBoolean(dto.getMinimoVigente())) {
   				hb.appendWhere("act.precioMinimoAutorizado is not null");
   			} else {
   				hb.appendWhere("act.precioMinimoAutorizado is null");
   			} 			
   		}
   		if(!Checks.esNulo(dto.getVentaWebVigente())) {
   			if(BooleanUtils.toBoolean(dto.getVentaWebVigente())) {
   				hb.appendWhere("act.precioAprobadoVenta is not null");
   			} else {
   				hb.appendWhere("act.precioAprobadoVenta is null");
   			} 			
   		}
   		if(!Checks.esNulo(dto.getMinimoHistorico())) {
   			if(BooleanUtils.toBoolean(dto.getMinimoHistorico())) {
   				hb.appendWhere("act.precioHistoricoMinimoAutorizado is not null");
   			} else {
   				hb.appendWhere("act.precioHistoricoMinimoAutorizado is null");
   			} 			
   		}
   		if(!Checks.esNulo(dto.getWebHistorico())) {
   			if(BooleanUtils.toBoolean(dto.getWebHistorico())) {
   				hb.appendWhere("act.precioHistoricoAprobadoVenta is not null");
   			} else {
   				hb.appendWhere("act.precioHistoricoAprobadoVenta is null");
   			} 			
   		}
   		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conBloqueo", dto.getConBloqueo());
   		
   		//HREOS-639 - Indicador de activos para preciar/repreciar/descuento
   		if(Checks.esNulo(dto.getCheckTodosActivos()) || !dto.getCheckTodosActivos()) {
	   		if(!Checks.esNulo(dto.getTipoPropuestaCodigo())) {
		   		if(dto.getTipoPropuestaCodigo().equals("01")) {
		   			hb.appendWhere("act.fechaPreciar is not null");
		   			hb.appendWhere("act.fechaRepreciar is null");
		   			} else if(dto.getTipoPropuestaCodigo().equals("02")) {
		   				hb.appendWhere("act.fechaRepreciar is not null");
		   				} 
		   			else  if(dto.getTipoPropuestaCodigo().equals("03")){
		   					hb.appendWhere("act.fechaDescuento is not null");
		   		}
	   		}
   		}

		return HibernateQueryUtils.page(this, hb, dto);

	}
    
    @Override
	public Page getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto) {

		HQLBuilder hb = new HQLBuilder(" from ActivoHistoricoValoraciones hist");
	
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "hist.activo.id", Long.parseLong(dto.getIdActivo()));   		
   		
		return HibernateQueryUtils.page(this, hb, dto);

	}

	@Override
	public void deleteValoracionById(Long id) {
	
		StringBuilder sb = new StringBuilder("delete from ActivoValoraciones val where val.id = "+id);		
		this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();
		
	}
	
	@Override
	public boolean deleteValoracionSinDuplicarById(Long id) {

		StringBuilder sb = new StringBuilder("delete from ActivoValoraciones val where val.id = " + id);
		Query query = this.getSessionFactory().getCurrentSession().createQuery(sb.toString());
		int afectado = query.executeUpdate();

		return (afectado > 0) ? true : false;
			
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
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.estadoActivoCodigo", dto.getEstadoActivoCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.idActivo", dto.getIdActivo());
   		HQLBuilder.addFiltroLikeSiNotNull(hb,"propact.gestor", dto.getGestorPrecios(),true);
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb,"propact.tipoPropuesta", dto.getTipoPropuesta());
   		
   		if(!Checks.esNulo(dto.getTipoDeFecha())) {
   			switch(Integer.parseInt(dto.getTipoDeFecha())) {
	   			case 1:
	   				agregarFiltroFecha(hb,dto.getFechaDesde().toString(),dto.getFechaHasta(),"propact.fechaEmision");	
	   				break;
	   			case 2:
	   				agregarFiltroFecha(hb,dto.getFechaDesde().toString(),dto.getFechaHasta(),"propact.fechaEnvio");	
	   				break;
	   			case 3:
	   				agregarFiltroFecha(hb,dto.getFechaDesde().toString(),dto.getFechaHasta(),"propact.fechaSancion");	
	   				break;
	   			case 4:
	   				agregarFiltroFecha(hb,dto.getFechaDesde().toString(),dto.getFechaHasta(),"propact.fechaCarga");	
	   				break;
   				default:
   					break;
   			}
   		}
   		
		return HibernateQueryUtils.page(this, hb, dto);

	}

	@Override
	public Page getActivosPublicacion(DtoActivosPublicacion dto) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaPublicacionActivo activopubli");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.numActivo", dto.getNumActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.tipoActivoCodigo", dto.getTipoActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.subtipoActivoCodigo", dto.getSubtipoActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.cartera", dto.getCartera());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.estadoPublicacionCodigo", dto.getEstadoPublicacionCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.admision", dto.getAdmision());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.gestion", dto.getGestion());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.publicacion", dto.getPublicacion());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.precio", dto.getPrecio());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.informeComercial", dto.getInformeComercial());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.okventa", dto.getOkventa());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.okalquiler", dto.getOkalquiler());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.motivoOcultacionVenta", dto.getMotivosOcultacionCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.motivoOcultacionAlquiler", dto.getMotivosOcultacionAlquilerCodigo());
   		if (!Checks.esNulo(dto.getTipoComercializacionCodigo()))HQLBuilder.addFiltroWhereInSiNotNull(hb, "activopubli.tipoComercializacionCodigo", Arrays.asList(dto.getTipoComercializacionCodigo()));

		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Boolean getDptoPrecio(Activo activo) {
		HQLBuilder hb = new HQLBuilder(" from VBusquedaPublicacionActivo activopubli");
		hb.appendWhere("activopubli.numActivo = " + activo.getNumActivo());
		
		VBusquedaPublicacionActivo busquedaActivo = (VBusquedaPublicacionActivo) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).uniqueResult();
		if(Checks.esNulo(busquedaActivo))
			return null;
		return busquedaActivo.getPrecio();
	}

	@Override
	public Boolean publicarActivoConHistorico(Long idActivo, String username,boolean doFlush) {
    	// Antes de realizar la llamada al SP realizar las operaciones previas con los datos.
		if(doFlush){
			getHibernateTemplate().flush();
		}
		
		return this.publicarActivo(idActivo, username, true, null);
	}
	
	@Override
	public Boolean publicarActivoSinHistorico(Long idActivo, String username, String eleccionUsuarioTipoPublicacionAlquiler,boolean doFlush) {
		// Antes de realizar la llamada al SP realizar las operaciones previas con los datos.
		if(doFlush){
			getHibernateTemplate().flush();
		}
		return this.publicarActivo(idActivo, username, false, eleccionUsuarioTipoPublicacionAlquiler);
	}

	@Override
	public Boolean publicarAgrupacionSinHistorico(Long idAgrupacion, String username, String eleccionUsuarioTipoPublicacionAlquiler,boolean doFlush) {
		if(doFlush){
			getHibernateTemplate().flush();
		}
		return this.publicarAgrupacion(idAgrupacion, username, false, eleccionUsuarioTipoPublicacionAlquiler);
	}
	
	@Override
	public Boolean publicarAgrupacionConHistorico(Long idAgrupacion, String username,boolean doFlush) {
		if(doFlush){
			getHibernateTemplate().flush();
		}
		return this.publicarAgrupacion(idAgrupacion, username, true, null);
	}

	/**
	 * Este método lanza el procedimiento de cambio de estado de publicación
	 *
	 * @param idActivo: ID del activo para el cual se desea realizar la operación.
	 * @param username: nombre del usuario, si la llamada es desde la web, que realiza la operación.
	 * @param historificar: indica si la operación ha de realizar un histórico de los movimientos realizados.
	 * @return Devuelve True si la operación ha sido satisfactoria, False si no ha sido satisfactoria.
	 */
	private Boolean publicarActivo(Long idActivo, String username, Boolean historificar, String eleccionUsuarioTipoPublicacionAlquiler) {
		String procedureHQL = "BEGIN SP_CAMBIO_ESTADO_PUBLICACION(:idActivoParam, :eleccionUsuarioParam, :usernameParam, :historificarParam);  END;";

		Query callProcedureSql = this.getSessionFactory().getCurrentSession().createSQLQuery(procedureHQL);
		callProcedureSql.setParameter("idActivoParam", idActivo);
		callProcedureSql.setParameter("eleccionUsuarioParam", eleccionUsuarioTipoPublicacionAlquiler);
		callProcedureSql.setParameter("usernameParam", username);
		callProcedureSql.setParameter("historificarParam", historificar ? "S" : "N");

		int resultado = callProcedureSql.executeUpdate();

    	return resultado == 1;
	}
	
	/**
	 * Este metodo lanza el procedimiento de cambio de estado de publicación de agrupaciones
	 *
	 * @param idAgrupacion: ID del activo para el cual se desea realizar la operación.
	 * @param username: nombre del usuario, si la llamada es desde la web, que realiza la operación.
	 * @param historificar: indica si la operación ha de realizar un histórico de los movimientos realizados.
	 * @return Devuelve True si la operacion ha sido satisfactoria, False si no ha sido satisfactoria.
	 */
	private Boolean publicarAgrupacion(Long idAgrupacion, String username, Boolean historificar, String eleccionUsuarioTipoPublicacionAlquiler) {
		String procedureHQL = "BEGIN SP_CAMBIO_ESTADO_PUBLI_AGR(:idAgrupacionParam, :eleccionUsusarioParam, :usernameParam, :historificarParam); END;";

		Query callProcedureSql = this.getSessionFactory().getCurrentSession().createSQLQuery(procedureHQL);
		callProcedureSql.setParameter("idAgrupacionParam", idAgrupacion);
		callProcedureSql.setParameter("eleccionUsusarioParam", eleccionUsuarioTipoPublicacionAlquiler);
		callProcedureSql.setParameter("usernameParam", username);
		callProcedureSql.setParameter("historificarParam", historificar ? "S" : "N");

		int resultado = callProcedureSql.executeUpdate();

		return resultado == 1;
	}
	
    public Long getNextNumExpedienteComercial() {
		String sql = "SELECT S_ECO_NUM_EXPEDIENTE.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
	}
    
    public Long getNextNumOferta() {
		String sql = "SELECT S_OFR_NUM_OFERTA.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
	}
    
    public Long getNextClienteRemId() {
		String sql = "SELECT S_CLC_REM_ID.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
	}

	@Override
	public Page getPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto) {
		HQLBuilder hb = new HQLBuilder(" from PropuestaActivosVinculados activosVinculados");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activosVinculados.activoOrigen.id", dto.getActivoOrigenID());
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Activo getActivoByNumActivo(Long activoVinculado) {
    	Session session = getSession();
		Criteria criteria = session.createCriteria(Activo.class);
		criteria.add(Restrictions.eq("numActivo", activoVinculado));

		Activo activo =  HibernateUtils.castObject(Activo.class, criteria.uniqueResult());
		session.disconnect();

		return activo;
	}

	@Override
	public PropuestaActivosVinculados getPropuestaActivosVinculadosByID(Long id) {
		HQLBuilder hb = new HQLBuilder(" from PropuestaActivosVinculados activosVinculados");
		hb.appendWhere("activosVinculados.id = " + id);
		
		return (PropuestaActivosVinculados) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).uniqueResult();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public ActivoTasacion getActivoTasacion(Long id){
		HQLBuilder hb = new HQLBuilder(" from ActivoTasacion tas");
		hb.appendWhere(" tas.activo.id = " + id);
		hb.appendWhere(" tas.fechaRecepcionTasacion is null");
		hb.orderBy("tas.id", HQLBuilder.ORDER_DESC);
		
		List<ActivoTasacion> activoTasacionList = (List<ActivoTasacion>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		
		if(!Checks.estaVacio(activoTasacionList)) {
			return activoTasacionList.get(0);
		}
		
		return null;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoTasacion> getListActivoTasacionByIdActivo(Long idActivo){
		HQLBuilder hb = new HQLBuilder(" from ActivoTasacion tas");
		hb.appendWhere(" tas.activo.id = " + idActivo);
		hb.orderBy("tas.valoracionBien.fechaValorTasacion", HQLBuilder.ORDER_DESC);
		List<ActivoTasacion> activoTasacionList = (List<ActivoTasacion>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		return activoTasacionList;
	}
	
	@Override
	public Page getActivosFromCrearTrabajo(List<String> listIdActivos, DtoTrabajoListActivos dto) {
		
		HQLBuilder hb = new HQLBuilder(" from VBusquedaActivosCrearTrabajo act");
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "numActivoHaya", listIdActivos);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	public Page getLlavesByActivo(DtoLlaves dto) {
		
		HQLBuilder hb = new HQLBuilder(" from ActivoLlave lla");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activo.id", Long.parseLong(dto.getIdActivo()));
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	public Page getListMovimientosLlaveByLlave(WebDto dto, Long idLlave) {
		
		HQLBuilder hb = new HQLBuilder("select mov from ActivoMovimientoLlave mov, ActivoLlave lla ");
		hb.appendWhere("lla.id = mov.activoLlave.id");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "lla.id", idLlave);
		
		this.ordenarMovimientos(dto,hb);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	public Page getListMovimientosLlaveByActivo(WebDto dto, Long idActivo) {
		
		HQLBuilder hb = new HQLBuilder("select mov from ActivoMovimientoLlave mov, ActivoLlave lla " );
		hb.appendWhere("lla.id = mov.activoLlave.id");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "lla.activo.id", idActivo);
		
		this.ordenarMovimientos(dto,hb);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	/**
	 * Inserta un orderBy en la consulta, para los movimientos, ya que al ser una consulta de dos tablas, 
	 * no las ordena por defecto desde sencha.
	 * @param dto
	 * @param hb
	 */
	private void ordenarMovimientos(WebDto dto, HQLBuilder hb) {
		
		if(!Checks.esNulo(dto.getSort())) {
			String numLlave = "numLlave", codigoTipoTenedor = "codigoTipoTenedor";
			if(numLlave.equalsIgnoreCase(dto.getSort())) {
				hb.orderBy("lla.numLlave", dto.getDir().toLowerCase());
			}
			else if(codigoTipoTenedor.equalsIgnoreCase(dto.getSort())) {
				hb.orderBy("mov.codTenedor", dto.getDir().toLowerCase());
			}
			else {
				hb.orderBy("mov."+dto.getSort(), dto.getDir().toLowerCase());
			}
				
		}
	}
	
	@Override
	public Integer isIntegradoAgrupacionObraNuevaOrAsistida(Long id) {

    	HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.activo.id = " + id + " and act.agrupacion.tipoAgrupacion.codigo in ('01','13')");

   		return ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VOfertasActivosAgrupacion> getListOfertasActivo(Long idActivo) {
		
		String hql = " from VOfertasActivosAgrupacion voa ";
		String listaIdsOfertas = "";
		
		HQLBuilder hb = new HQLBuilder(hql);

		if (!Checks.esNulo(idActivo)) {
			Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
			Activo activo = genericDao.get(Activo.class, filtroIdActivo);
			
			List<ActivoOferta> listaActivoOfertas = activo.getOfertas();

			
			for (ActivoOferta activoOferta : listaActivoOfertas){
				listaIdsOfertas = listaIdsOfertas.concat(activoOferta.getPrimaryKey().getOferta().getId().toString()).concat(",");
			}
			listaIdsOfertas = listaIdsOfertas.concat("-1");
			
			hb.appendWhere(" voa.idOferta in (" + listaIdsOfertas + ") ");
		}
		
		return (List<VOfertasActivosAgrupacion>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
				
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<VOfertasTramitadasPendientesActivosAgrupacion> getListOfertasTramitadasPendientesActivo(Long idActivo) {
		
		String hql = " from VOfertasTramitadasPendientesActivosAgrupacion voa2 ";
		String listaIdsOfertas = "";
		
		HQLBuilder hb = new HQLBuilder(hql);

		if (!Checks.esNulo(idActivo)) {
			Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
			Activo activo = genericDao.get(Activo.class, filtroIdActivo);
			
			List<ActivoOferta> listaActivoOfertas = activo.getOfertas();

			
			for (ActivoOferta activoOferta : listaActivoOfertas){
				listaIdsOfertas = listaIdsOfertas.concat(activoOferta.getPrimaryKey().getOferta().getId().toString()).concat(",");
			}
			listaIdsOfertas = listaIdsOfertas.concat("-1");
			
			hb.appendWhere(" voa2.idOferta in (" + listaIdsOfertas + ") ");
		}
		
		return (List<VOfertasTramitadasPendientesActivosAgrupacion>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
				
		
	}
	
	@Override
	public void actualizarRatingActivo(Long idActivo, String username) {	
		Session session = this.getSessionFactory().getCurrentSession();
		Query query = session.createSQLQuery(
		"CALL CALCULO_RATING_ACTIVO_AUTO(:idActivo, :username)")
		.setParameter("idActivo", idActivo)
		.setParameter("username", username);

		query.executeUpdate();
	}
	
	@Override
	public void actualizarSingularRetailActivo(Long idActivo, String username, Integer all_activos, Integer ingore_block) {
		Session session = this.getSessionFactory().getCurrentSession();
		Query query = session.createSQLQuery(
		"CALL CALCULO_SINGULAR_RETAIL_AUTO(:idActivo, :username, :all_activos, :ingore_block)")
		.setParameter("idActivo", idActivo)
		.setParameter("username", username)
		.setParameter("all_activos", all_activos)
		.setParameter("ingore_block", ingore_block);

		query.executeUpdate();
	}
	
	@Override
	public String getCodigoTipoComercializarByActivo(Long idActivo) {
		String codComercializar = rawDao.getExecuteSQL("SELECT tcr.DD_TCR_CODIGO "
				+ "		  FROM ACT_ACTIVO act"
				+ "			INNER JOIN DD_TCR_TIPO_COMERCIALIZAR tcr ON act.dd_tcr_id = tcr.dd_tcr_id"
				+ "			WHERE act.ACT_ID = "+idActivo
				+ "			AND act.BORRADO = 0"				
				+ "         AND ROWNUM = 1 ");
		
		return codComercializar;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<VBusquedaActivosPrecios> getListActivosPreciosFromListId(String cadenaId) {
		
    	HQLBuilder hb = new HQLBuilder("select act from VBusquedaActivosPrecios act where act.id in ("+cadenaId+")");

    	return this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
	}

	@Override
	public Long getNextNumActivoRem() {
		String sql = "SELECT S_ACT_NUM_ACTIVO_REM.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
	}

    private void agregarFiltroFecha(HQLBuilder hb, String fechaD, String fechaH, String tipoFecha) {
    	try {

			if (fechaD != null) {
				Date fechaDesde = DateFormat.toDate(fechaD);
				HQLBuilder.addFiltroBetweenSiNotNull(hb, tipoFecha, fechaDesde, null);
			}

			if (fechaH != null) {
				Date fechaHasta = DateFormat.toDate(fechaH);

				// Se le añade un día para que encuentre las fechas del día anterior hasta las 23:59
				Calendar calendar = Calendar.getInstance();
				if (fechaHasta != null) {
					calendar.setTime(fechaHasta); // Configuramos la fecha que se recibe
				}
				calendar.add(Calendar.DAY_OF_YEAR, 1);  // numero de días a añadir, o restar en caso de días<0

				HQLBuilder.addFiltroBetweenSiNotNull(hb, tipoFecha, null, calendar.getTime());
			}

   		} catch (ParseException e) {
			e.printStackTrace();
		}
    }

	@Override
	public List<Activo> getListActivosPorID(List<Long> activosID) {
		HQLBuilder hb = new HQLBuilder("from Activo act" );

		HQLBuilder.addFiltroWhereInSiNotNull(hb, "id", activosID);
		
		return HibernateQueryUtils.list(this, hb);
	}

	@Override
	public Activo getActivoById(Long activoId) {
		HQLBuilder hb = new HQLBuilder("from Activo act" );
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "id", activoId);

		return HibernateQueryUtils.uniqueResult(this, hb);
	}


	/*Borra todos las distribuciones excelto las de tipo garaje y trastero*/
	public void deleteActivoDistribucion(Long idActivoInfoComercial){
		Session session = this.getSessionFactory().getCurrentSession();
		Query query= session.createSQLQuery("DELETE FROM ACT_DIS_DISTRIBUCION dis1 where dis1.DIS_ID IN"
				+ " ( select dis2.DIS_ID from ACT_DIS_DISTRIBUCION dis2"
				+ "	INNER JOIN DD_TPH_TIPO_HABITACULO tph ON dis2.dd_tph_id = tph.dd_tph_id"
				+ "	WHERE dis2.ICO_ID = "+idActivoInfoComercial
				//+ "	AND tph.DD_TPH_CODIGO NOT IN ('"+DDTipoHabitaculo.TIPO_HABITACULO_TRASTERO + "','"+ DDTipoHabitaculo.TIPO_HABITACULO_GARAJE +"')"
				+ "	)");
		query.executeUpdate();
		

	}

	@Override
	public List<ActivoCalificacionNegativa> getListActivoCalificacionNegativaByIdActivo(Long idActivo) {
		String hql = " from ActivoCalificacionNegativa acn ";
		HQLBuilder hb = new HQLBuilder(hql);
		hb.appendWhere(" acn.activo.id =  "+idActivo+" ");
		hb.appendWhere(" acn.auditoria.borrado IS NOT NULL ");

		return (List<ActivoCalificacionNegativa>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();

	}
	
	@Override
	public Page getListHistoricoOcupacionesIlegalesByActivo(WebDto dto, Long idActivo) {
		//También se puede usar el genericDao en REM, pero hay que ver como devolver un Page porque no he encontrado casos así.
		//List<ActivoOcupacionIlegal> listaOcupacionesIlegales = genericDao.getList(ActivoOcupacionIlegal.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo));
		HQLBuilder hb = new HQLBuilder("select ocu from ActivoOcupacionIlegal ocu ");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activo.id", idActivo);
		
		return HibernateQueryUtils.page(this, hb, dto);

	}

	public void finHistoricoDestinoComercial(Activo activo, Object[] extraArgs) {

		Session session = this.getSessionFactory().getCurrentSession();
		Query query= session.createQuery("UPDATE HistoricoDestinoComercial hdc "
				+ " SET hdc.fechaFin = sysdate, hdc.gestorActualizacion = :gestorActualizacion "
				+ " WHERE hdc.activo.id = :idActivo AND hdc.fechaFin IS NULL");

		query.setParameter("idActivo", activo.getId());

		query.setParameter("gestorActualizacion", getGestorActualizacionHistoricoDestinoComercial(extraArgs));

		query.executeUpdate();

	}

	public void crearHistoricoDestinoComercial(Activo activo, Object[] extraArgs) {

		HistoricoDestinoComercial hdc = new HistoricoDestinoComercial();

		hdc.setActivo(activo);
		hdc.setFechaFin(null);
		hdc.setFechaInicio(new Date());

		hdc.setGestorActualizacion(getGestorActualizacionHistoricoDestinoComercial(extraArgs));

		hdc.setTipoComercializacion(activo.getTipoComercializacion());

		genericDao.save(HistoricoDestinoComercial.class, hdc);

	}

	private String getGestorActualizacionHistoricoDestinoComercial(Object[] extraArgs) {

		Usuario usuario = adapter.getUsuarioLogado();

		String usuarioActualizacion = HistoricoDestinoComercial.GESTOR_ACTUALIZACION_DESCONOCIDO;

		if (!Checks.esNulo(usuario.getNombre())) {

			usuarioActualizacion = usuario.getNombre() + " " + usuario.getApellidos();

		} else if (!Checks.esNulo(usuario.getUsername())) {

			if (REST_USER_USERNAME.equals(usuario.getUsername())) {

				try {

					usuario = (Usuario) extraArgs[MSVREMUtils.MASIVE_PROCES_USER_STARTER_INDEX];

					if (!Checks.esNulo(usuario.getNombre())) {
						usuarioActualizacion = usuario.getNombre() + " " + usuario.getApellidos();
					} else {
						usuarioActualizacion = REST_USER_HDC_NAME;
					}

				} catch (Exception e) {
					usuarioActualizacion = REST_USER_HDC_NAME;
				}

			} else {
				usuarioActualizacion = usuario.getUsername();
			}

		}

		return usuarioActualizacion;
	}
	
	@Override
	public void hibernateFlush() {
		getHibernateTemplate().flush();
	}
}
