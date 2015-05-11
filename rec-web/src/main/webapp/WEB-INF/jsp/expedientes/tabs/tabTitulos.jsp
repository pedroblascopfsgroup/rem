<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


/* * TAB TITULOS DE UN EXPEDIENTE * */

(function(){
    var show=false;
    var expedienteActivo = '1';
    
    var Titulo = Ext.data.Record.create([
        {name:'idContrato'}
        ,{name:'codigo'}
        ,{name:'tipo'}
        ,{name:'id'}
        ,{name:'tipodocumento'}
        ,{name:'incidencias'}
        ,{name:'intervencion'}
        ,{name:'comentario'}    
    ]);
    
    
   	var limit = 20;

    var titulosStore = page.getStore({
            flow:'expedientes/tabTitulos'
            ,limit:limit
            ,reader: new Ext.data.JsonReader({
                root: 'contratos'
                ,totalProperty : 'total'
            }, Titulo)
        });
    titulosStore.webflow({idExpediente:${expediente.id}});    
    var botonesTablaTitulos = fwk.ux.getPaging(titulosStore);
    
    var titulosCM  = new Ext.grid.ColumnModel([
        {hidden:true,sortable: false, dataIndex: 'id',fixed:true},
        {header:'Contrato',dataIndex:'codigo',width:120},
        {header:'Tipo',dataIndex:'tipo',width:120},
        {header:'Tipo Documento',dataIndex:'tipodocumento',width:120},
        {header:'Incidencias',dataIndex:'incidencias',width:120},
        {header:'Intervencion',dataIndex:'intervencion',width:120,renderer:app.format.booleanToYesNoRenderer},
        {header:'Comentario',dataIndex:'comentario',width:120}
    ]);
    
    
    <sec:authorize ifAllGranted="EDITAR_TITULOS">
        var btnEditarTitulo = new Ext.Button({
                text:'<s:message code="app.editar" text="**Editar" />'
                ,iconCls : 'icon_edit'
                ,cls: 'x-btn-text-icon'
                ,disabled:true
                ,handler:function(){
                    var grid = fwk.dom.findParentPanel(this.id);
                    var rec = grid.getSelectionModel().getSelected();
                    var w = app.openWindow({    
                        flow : 'expedientes/titulo'
                        ,width:600
                        ,title : '<s:message code="titulos.edicion.titulo" text="**Editar titulo" />'
                        ,params : {idContrato:rec.get('idContrato'), idTitulo:rec.get('id')}
                    });
                    w.on(app.event.DONE, function(){
                        w.close();
                        titulosStore.webflow({idExpediente:"${expediente.id}"});
                        deshabilitarBotones();
                    });
                    w.on(app.event.CANCEL, function(){ w.close(); });
                }
                <app:test id="btnEditarABM" addComa="true"/>
            });
    </sec:authorize>    
    
    <sec:authorize ifAllGranted="NUEVO_TITULO">
    var btnAgregarTitulo = new Ext.Button({
                text: '<s:message code="app.agregar" text="**Agregar" />'
                ,iconCls : 'icon_mas'
                ,cls: 'x-btn-text-icon'
                ,disabled:true
                <app:test id="btnAgregarABM" addComa="true"/>
                ,handler:function(){
                    var grid = fwk.dom.findParentPanel(this.id);
                    var rec = grid.getSelectionModel().getSelected();
                    var w = app.openWindow({    
                        flow : 'expedientes/titulo'
                        ,width:580
                        ,title : '<s:message code="titulos.agregar.titulo" text="**Agregar titulo" />'
                        ,params : {idContrato:rec.get('idContrato'),idTitulo:'-1'}
                    });
                    w.on(app.event.DONE, function(){
                        w.close();
                        titulosStore.webflow({idExpediente:"${expediente.id}"});
                        deshabilitarBotones();
                    });
                    w.on(app.event.CANCEL, function(){ w.close(); });
                }
    });
    </sec:authorize>
    
    <sec:authorize ifAllGranted="BORRA_TITULO">
    var btnBorrarTitulo = new Ext.Button({
                text : '<s:message code="titulos.borrar.titulo" text="**Borrar titulo" />'
                ,iconCls : 'icon_menos'
                ,cls: 'x-btn-text-icon'
                ,disabled:true
                ,handler:function(){
                    var grid = fwk.dom.findParentPanel(this.id);
                    var rec = grid.getSelectionModel().getSelected();
                    page.webflow({
                        flow : 'expedientes/borrarTitulo'
                        ,eventName: 'borrar'
                        ,params : {id:rec.get('id')}
                        ,success : function() {
                            titulosStore.webflow({idExpediente:"${expediente.id}"});
                            deshabilitarBotones();
                        } 
                     });
                }
    });
    btnBorrarTitulo.disable();  
    </sec:authorize>    
    
    var perfilGestor = '${expediente.idGestorActual}';
    var perfilSupervisor = '${expediente.idSupervisorActual}';
        
    var bar = [botonesTablaTitulos];
    var pos = 1;
       
    if((permisosVisibilidadGestorSupervisor(perfilGestor) == true 
        || permisosVisibilidadGestorSupervisor(perfilGestor) == true) &&
            ('${expediente.estadoExpediente.codigo}' == expedienteActivo)){
            <sec:authorize ifAllGranted="NUEVO_TITULO">
                bar[pos] = btnAgregarTitulo;
                pos++
            </sec:authorize>
            <sec:authorize ifAllGranted="EDITAR_TITULOS">
                bar[pos]= btnEditarTitulo;
                pos++;
            </sec:authorize>
            <sec:authorize ifAllGranted="BORRA_TITULO">
                bar[pos] = btnBorrarTitulo;
            </sec:authorize>
    }
    
    
    
    var titulosGrid= app.crearGrid(titulosStore,titulosCM,{
        title:'<s:message code="expedientes.consulta.tabtitulos.titulo" text="**Titulos"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:415
        ,bbar:bar
        ,iconCls : 'icon_titulo'
        <app:test id="listaTitulos" addComa="true"/>
    });
    
    titulosGrid.on('rowclick', function(grid, rowIndex, e){                                                                                                         
        
        var rec = grid.getStore().getAt(rowIndex);
        
        if((permisosVisibilidadGestorSupervisor(perfilGestor) == true 
                || permisosVisibilidadGestorSupervisor(perfilGestor) == true) &&
                    ('${expediente.estadoExpediente.codigo}' == expedienteActivo)){
                        
                        <sec:authorize ifAllGranted="NUEVO_TITULO">
                            btnAgregarTitulo.enable();
                        </sec:authorize>
                        
                        if(rec.get('id') != ''){
                            <sec:authorize ifAllGranted="EDITAR_TITULOS">
                                btnEditarTitulo.enable();
                            </sec:authorize>
                            <sec:authorize ifAllGranted="BORRA_TITULO">
                                btnBorrarTitulo.enable();
                            </sec:authorize>    
                        }else{
                            <sec:authorize ifAllGranted="EDITAR_TITULOS">
                                btnEditarTitulo.disable();
                            </sec:authorize>
                            <sec:authorize ifAllGranted="BORRA_TITULO">
                                btnBorrarTitulo.disable();
                            </sec:authorize>
                        }
                }
        }); 

    var panel = new Ext.Panel({
        title:'<s:message code="expedientes.consulta.tabtitulos.titulo" text="**Titulos"/>'
        ,height:445
        ,bodyStyle:'padding:10px'   
        ,items:[titulosGrid]
        ,autoHeight:true
        ,listeners:
        {
            show:function(){
                if(!show){
                    show=true;
                    //le pido los datos al flow
                    //bienesST.webflow({idPersona:"${persona.id}"});
                }

            }
        }
        ,nombreTab : 'tabTitulos'
    });
    
    var deshabilitarBotones = function(){
        if((permisosVisibilidadGestorSupervisor(perfilGestor) == true 
                || permisosVisibilidadGestorSupervisor(perfilGestor) == true) &&
                    ('${expediente.estadoExpediente.codigo}' == expedienteActivo)){
            <sec:authorize ifAllGranted="EDITAR_TITULOS">
                btnEditarTitulo.disable();
            </sec:authorize>
            <sec:authorize ifAllGranted="BORRA_TITULO">
                btnBorrarTitulo.disable();
            </sec:authorize>
            <sec:authorize ifAllGranted="NUEVO_TITULO">
                btnAgregarTitulo.disable();
            </sec:authorize>        
        }           
    }
    
    
    return panel;
})()