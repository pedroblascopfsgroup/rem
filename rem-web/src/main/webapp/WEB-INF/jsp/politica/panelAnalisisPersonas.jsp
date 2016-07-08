<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

var createPanelPersonas = function() {
//----------------------------------------------------------------------
// Historial de politicas
//----------------------------------------------------------------------
    var analisisPersona = Ext.data.Record.create([
         {name : 'id'}
		,{name : 'tipo'}
        ,{name : 'parcela'}
		,{name : 'idParcela'}
        ,{name : 'valoracion'}
        ,{name : 'impacto'}
        ,{name : 'comentario'}
        ,{name : 'none'}
    ]);


    var analisisPersonaStore = page.getStore({
        event:'listado'
        ,flow : 'politica/analisisPersona'
        ,reader : new Ext.data.JsonReader(
            {root:'listadoAnalisis'}
            , analisisPersona
        )
    });

    var analisisPersonaCm = new Ext.grid.ColumnModel([                                                                                                                         
        {header : '<s:message code="analisisPersona.tipo" text="**Tipo" />', dataIndex : 'tipo'}
        ,{header : '<s:message code="politica.parcela" text="**Parcela" />', dataIndex : 'parcela'}
        ,{header : '<s:message code="politica.valoracion" text="**Valoraci&oacute;n" />', dataIndex : 'valoracion'}
        ,{header : '<s:message code="politica.impacto" text="**Impacto" />', dataIndex : 'impacto'}
        ,{header : '<s:message code="politica.comentario" text="**Comentario" />', dataIndex : 'comentario'}
        ,{header : '', dataIndex : 'none'}

    ]);                

	//Este indica el id de app si es que existe en la tabla
	var idAppSeleccionado = null;
	//Este indica el tipo de parcela, para el caso en que no haya registro de app.
	//El tipo de análisis se obtiene de la parcela.
	var idParcela = null;

	<c:if test="${!verAnalisis}">	
		var btnModificar = 	new Ext.Button({
			text: '<s:message code="analisisPersona.modificar" text="**Modificar" />',
			iconCls: 'icon_edit',
			handler: function(){
				if (idParcela){
					var win = app.openWindow({
						flow: 'politica/editarAnalisisPersona'
						,title: '<s:message code="analisisPersona.editar" text="**Editar Análisis" />'
						,closable:true
						,params:{idPersona:${persona.id},idParcela:idParcela, idAppSeleccionado:idAppSeleccionado}
						,width: 680
						
					});
					win.on(app.event.CANCEL,function(){win.close();});
					win.on(app.event.DONE,
						function(){
							win.close();
							analisisPersonaStore.webflow({id:${persona.id}});
						}
					);
				}else{
		           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisisPersona.listado.sinSeleccion" text="**Debe seleccionar un elemento de la lista"/>')	
		        }
			}
		});
		var btnModificarTodo = 	new Ext.Button({
			text: '<s:message code="analisisPersona.modificartodo" text="**Modificar Todo" />',
			iconCls: 'icon_edit',
			handler: function(){
				
					var win = app.openWindow({
						flow: 'politica/edicionMasivaAnalisisPersona'
						,title: '<s:message code="analisisPersona.editar" text="**Editar Análisis" />'
						,closable:true
						,params:{idPersona:${persona.id},idParcela:idParcela, idAppSeleccionado:idAppSeleccionado}
						,width: 775
						
					});
					win.on(app.event.CANCEL,function(){win.close();});
					win.on(app.event.DONE,
						function(){
							win.close();
							analisisPersonaStore.webflow({id:${persona.id},tamanio:analisisPersonaStore.getCount()});
						}
					);
				
			}
		});
	</c:if>
	var analisisPersonaGrid = app.crearGrid(analisisPersonaStore,analisisPersonaCm,{
		title: '<s:message code="analisisPersonas.titulo" text="**An&aacute;lisis de la Persona" />'        
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,cls:'cursor_pointer'
        ,iconCls:'icon_personas'
        ,height:125
		<c:if test="${!verAnalisis}">			
			,bbar : [btnModificar,btnModificarTodo]
		</c:if>
    });

	analisisPersonaGrid.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		idAppSeleccionado = rec.get('id');
		idParcela = rec.get('idParcela');
		<c:if test="${!verAnalisis}">
			btnModificar.enable();
		</c:if>
	});

    var panel = new Ext.Panel({
         autoHeight: true
        ,autoWidth: true
        ,border:false
		,style:'padding-bottom:10px'
        ,items: [analisisPersonaGrid]
    });

	analisisPersonaStore.webflow({id:${persona.id}});

    return panel;
};