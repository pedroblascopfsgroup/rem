<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

var createPanelOperaciones = function() {
//----------------------------------------------------------------------
// Historial de politicas
//----------------------------------------------------------------------
    var analisisOperaciones = Ext.data.Record.create([
         {name : 'id'}
		,{name : 'idContrato'}
		,{name : 'contrato'}
        ,{name : 'tipoContrato'}
        ,{name : 'valoracion'}
        ,{name : 'impacto'}
        ,{name : 'comentario'}
    ]);


    var analisisOperacionesStore = page.getStore({
        event:'listado'
        ,flow : 'politica/analisisOperaciones'
        ,reader : new Ext.data.JsonReader(
            {root:'listadoAnalisisOperaciones'}
            , analisisOperaciones
        )
    });

    var analisisOperacionesCm = new Ext.grid.ColumnModel([                                                                                                                         
         {header : '<s:message code="analisisOperaciones.contrato" text="**Contrato" />', dataIndex : 'contrato'}
        ,{header : '<s:message code="analisisOperaciones.tipoContrato" text="**Tipo Contrato" />', dataIndex : 'tipoContrato'}
        ,{header : '<s:message code="politica.valoracion" text="**Valoraci&oacute;n" />', dataIndex : 'valoracion'}
        ,{header : '<s:message code="politica.impacto" text="**Impacto" />', dataIndex : 'impacto'}
        ,{header : '<s:message code="politica.comentario" text="**Comentario" />', dataIndex : 'comentario'}

    ]);                

	//Este indica el id de app si es que existe en la tabla
	var idAppSeleccionado = null;
	//Este indica el tipo de parcela, para el caso en que no haya registro de app.
	//El tipo de análisis se obtiene de la parcela.
	var idContrato = null;
	
	<c:if test="${!verAnalisis}">
		var btnModificar = 	new Ext.Button({
			text: '<s:message code="analisisPersona.modificar" text="**Modificar" />',
			iconCls: 'icon_edit',
			handler: function(){
				if (idContrato){
					var win = app.openWindow({
						flow: 'politica/editarAnalisisOperaciones'
						,title: '<s:message code="analisisOperacion.editar" text="**Editar Análisis" />'
						,closable:true
						,params:{idPersona:${persona.id},idContrato:idContrato, idAppSeleccionado:idAppSeleccionado}
						,width: 800
					});
					win.on(app.event.CANCEL,function(){win.close();});
					win.on(app.event.DONE,
						function(){
							win.close();
							analisisOperacionesStore.webflow({id:${persona.id}});
						}
					);
				}else{
		           		Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="analisisOperaciones.listado.sinSeleccion" text="**Debe seleccionar un elemento de la lista"/>')	
		        }
			}
		});
		var btnModificarTodo = 	new Ext.Button({
			text: '<s:message code="analisisPersona.modificartodo" text="**Modificar Todo" />',
			iconCls: 'icon_edit',
			handler: function(){
				
				var win = app.openWindow({
					flow: 'politica/edicionMasivaAnalisisOperaciones'
					,title: '<s:message code="analisisOperacion.editar" text="**Editar Análisis" />'
					,closable:true
					,params:{idPersona:${persona.id}}
					,width: 775
				}); 
				win.on(app.event.CANCEL,function(){win.close();});
				win.on(app.event.DONE,
					function(){
						win.close();
						analisisOperacionesStore.webflow({id:${persona.id},tamanio:analisisOperacionesStore.getCount()});
					}
				);
				
			}
		});
	</c:if>

	var analisisOperacionesGrid = app.crearGrid(analisisOperacionesStore,analisisOperacionesCm,{
        title: '<s:message code="analisisOperaciones.titulo" text="**An&aacute;lisis Operaciones" />'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,cls:'cursor_pointer'
        ,iconCls:'icon_personas'
        ,height:125
		<c:if test="${!verAnalisis}">	
			,bbar : [btnModificar,btnModificarTodo]
		</c:if>
    });

	analisisOperacionesGrid.on('rowclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		idAppSeleccionado = rec.get('id');
		idContrato = rec.get('idContrato');
		<c:if test="${!verAnalisis}">	
			btnModificar.enable();
		</c:if>
	});

    var panel = new Ext.Panel({
         autoHeight: true
        ,autoWidth: true
        ,border:false
        ,items: [analisisOperacionesGrid]
    });

	analisisOperacionesStore.webflow({id:${persona.id}});

    return panel;
};