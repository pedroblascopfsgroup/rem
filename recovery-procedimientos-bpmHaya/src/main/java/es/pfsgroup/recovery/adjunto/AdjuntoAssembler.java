package es.pfsgroup.recovery.adjunto;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.core.api.asunto.EXTAdjuntoDto;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;
import es.pfsgroup.recovery.gestordocumental.dto.AdjuntoGridDto;

public class AdjuntoAssembler {
	
	
	@Autowired
	private static GenericABMDao genericDao;
	

	public static List<ExtAdjuntoGenericoDto> listAdjuntoGridDtoTOListExtAdjuntoGenericoDto(List<AdjuntoGridDto> listDto){
		   
		List<ExtAdjuntoGenericoDto> adjuntosMapeados = new ArrayList<ExtAdjuntoGenericoDto>();

		if (!Checks.estaVacio(listDto)) {
			
			Comparator<AdjuntoGridDto> comparador = new Comparator<AdjuntoGridDto>() {
				@Override
				public int compare(AdjuntoGridDto o1, AdjuntoGridDto o2) {
					if (Checks.esNulo(o1) && Checks.esNulo(o2)) {
						return 0;
					} else if (Checks.esNulo(o1)) {
						return -1;
					} else if (Checks.esNulo(o2)) {
						return 1;
					} else {
						return o2.getDescripcionEntidad().compareTo(o1.getDescripcionEntidad());
					}
				}
			};
			
			Collections.sort(listDto, comparador);

			for(final AdjuntoGridDto adjDto : listDto){
				ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

					@Override
					public Long getId() {
						return adjDto.getId(); ///ENTIDAD.getId();
					}

					@Override
					public String getDescripcion() {
						return adjDto.getDescripcionEntidad();//return asunto.getExpediente().getDescripcion(); ENTIDAD.getDescripcion();
					}

					@Override
					public List getAdjuntosAsList() {
						List<AdjuntoGridDto> l = new ArrayList<AdjuntoGridDto>();
						l.add(adjDto);
						return l;
					}

					@Override
					public List getAdjuntos() {
						List<AdjuntoGridDto> l = new ArrayList<AdjuntoGridDto>();
						l.add(adjDto);
						return l;
					}
				};
				adjuntosMapeados.add(dto);
			}

		}

		return adjuntosMapeados;
		
	}
	
	public static List<ExtAdjuntoGenericoDto> listContratoToListExtAdjuntoGenericoDto(List<Contrato> contratos){
		
		List<ExtAdjuntoGenericoDto> adjuntosMapeados = new ArrayList<ExtAdjuntoGenericoDto>();
		
		for(final Contrato cnt : contratos){
			ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

				@Override
				public Long getId() {
					return cnt.getId(); ///ENTIDAD.getId();
				}

				@Override
				public String getDescripcion() {
					return cnt.getDescripcion();//return asunto.getExpediente().getDescripcion(); ENTIDAD.getDescripcion();
				}

				@Override
				public List getAdjuntosAsList() {
					return null;
				}

				@Override
				public List getAdjuntos() {
					return null;
				}
			};
			adjuntosMapeados.add(dto);
		}
		
		return adjuntosMapeados;
	}
	
	
	public static List<ExtAdjuntoGenericoDto> listPersonaToListExtAdjuntoGenericoDto(List<Persona> personas){
		
		List<ExtAdjuntoGenericoDto> adjuntosMapeados = new ArrayList<ExtAdjuntoGenericoDto>();
		
		for(final Persona prs : personas){
			ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

				@Override
				public Long getId() {
					return prs.getId(); ///ENTIDAD.getId();
				}

				@Override
				public String getDescripcion() {
					return prs.getDescripcion();//return asunto.getExpediente().getDescripcion(); ENTIDAD.getDescripcion();
				}

				@Override
				public List getAdjuntosAsList() {
					return null;
				}

				@Override
				public List getAdjuntos() {
					return null;
				}
			};
			adjuntosMapeados.add(dto);
		}
		
		return adjuntosMapeados;
	}
	
	
	public static List<ExtAdjuntoGenericoDto> listExpedientesToListExtAdjuntoGenericoDto(List<Expediente> expedientes){
		
		List<ExtAdjuntoGenericoDto> adjuntosMapeados = new ArrayList<ExtAdjuntoGenericoDto>();
		
		for(final Expediente exp : expedientes){
			ExtAdjuntoGenericoDto dto = new ExtAdjuntoGenericoDto() {

				@Override
				public Long getId() {
					return exp.getId(); ///ENTIDAD.getId();
				}

				@Override
				public String getDescripcion() {
					return exp.getDescripcion();//return asunto.getExpediente().getDescripcion(); ENTIDAD.getDescripcion();
				}

				@Override
				public List getAdjuntosAsList() {
					return null;
				}

				@Override
				public List getAdjuntos() {
					return null;
				}
			};
			adjuntosMapeados.add(dto);
		}
		
		return adjuntosMapeados;
	}


	public static List<AdjuntoDto> listAdjuntoGridDtoTOListAdjuntoDto(List<AdjuntoGridDto> listDto, final Boolean borrarOtrosUsu){
		
		
		List<AdjuntoDto> adjuntosMapeados = new ArrayList<AdjuntoDto>();

		if (!Checks.estaVacio(listDto)) {
			
			Comparator<AdjuntoGridDto> comparador = new Comparator<AdjuntoGridDto>() {
				@Override
				public int compare(AdjuntoGridDto o1, AdjuntoGridDto o2) {
					if (Checks.esNulo(o1) && Checks.esNulo(o2)) {
						return 0;
					} else if (Checks.esNulo(o1)) {
						return -1;
					} else if (Checks.esNulo(o2)) {
						return 1;
					} else {
						return o2.getAuditoria().getFechaCrear().compareTo(o1.getAuditoria().getFechaCrear());
					}
				}
			};
			
			Collections.sort(listDto, comparador);
			
			for(final AdjuntoGridDto adjDto: listDto){
				
				EXTAdjuntoDto dto = new EXTAdjuntoDto() {
					
					@Override
					public Boolean getPuedeBorrar() {
						if (borrarOtrosUsu /*|| adjAsun.getAuditoria().getUsuarioCrear().equals(usuario.getUsername())*/) {
							return true;
						} else {
							return false;
						}
					}
					
					@Override
					public Object getAdjunto() {
						
						EXTAdjuntoAsunto adjAsu = new EXTAdjuntoAsunto();
						adjAsu.setId(adjDto.getId());
						adjAsu.setNombre(adjDto.getNombre());
						adjAsu.setContentType(adjDto.getContentType());
						adjAsu.setLength(Long.parseLong(adjDto.getLength()));
						adjAsu.setDescripcion(adjDto.getDescripcion());
						adjAsu.getAuditoria().setFechaCrear(adjDto.getAuditoria().getFechaCrear());
						adjAsu.setTipoFichero(genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", adjDto.getTipo())));
						adjAsu.setProcedimiento(genericDao.get(Procedimiento.class, genericDao.createFilter(FilterType.EQUALS, "id", adjDto.getNumActuacion())));
						
						return adjAsu;
					}
					
					@Override
					public Long prcId() {
						return adjDto.getNumActuacion();
					}
					
					@Override
					public String getTipoDocumento() {
						return adjDto.getContentType();
					}
				};

				adjuntosMapeados.add(dto);		
			}
		
		}

		return adjuntosMapeados;
		
	}
	
	
}
