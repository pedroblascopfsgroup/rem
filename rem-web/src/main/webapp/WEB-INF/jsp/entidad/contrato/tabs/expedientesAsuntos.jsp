<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){
   
    var panel = new Ext.Panel({
        title:'<s:message code="contrato.tabExpAsuCnt.titulo" text="**Exp./Asuntos"/>'
        ,bodyStyle:'padding:10px'   
        ,autoHeight:true
    ,nombreTab : 'tabExpedientesAsuntos'
    });
    var Expediente = Ext.data.Record.create([
    ,{name:'pase'}  
         ,{name:'id'}
        ,{name:'descripcion'}
        ,{name:'fechaCrear'}
        ,{name:'origen'}
        ,{name:'situacion'}
        ,{name:'volumenRiesgo'}
        ,{name:'volumenRiesgoVencido'}
        ,{name:'oficina'}
        ,{name:'gestor'}
        ,{name:'fechaVencimiento'}  
    ,{name:'estadoExpediente'}  
    ,{name:'pertenece'}  
    ]);

   var expedientesStore = page.getStore({
            flow:'contratos/expedientesContrato'
            ,storeId: 'expedientesContratoStore'
            ,reader: new Ext.data.JsonReader({
                root: 'expedientes'
            }, Expediente)
        });
    
 
   var expedientesCM  = new Ext.grid.ColumnModel([
        {header:'<s:message code="contrato.tabExpAsuCnt.pase" text="**Pase" />', sortable: false, dataIndex: 'pase',fixed:true},
        {header:'<s:message code="contrato.tabExpAsuCnt.codigo" text="**Código" />', sortable: false, dataIndex: 'id',fixed:true},
        {header:'<s:message code="contrato.tabExpAsuCnt.descripcion" text="**Descripción" />',dataIndex:'descripcion',width:120},
        {header:'<s:message code="contrato.tabExpAsuCnt.creacion" text="**Creación" />',dataIndex:'fechaCrear',width:120},
        {header:'<s:message code="contrato.tabExpAsuCnt.origen" text="**Origen" />',dataIndex:'origen',width:120},
        {header:'<s:message code="contrato.tabExpAsuCnt.estado" text="**Estado" />',dataIndex:'estadoExpediente',width:120},
        {header:'<s:message code="contrato.tabExpAsuCnt.situacion" text="**Situación" />',dataIndex:'situacion',width:120},
        {header:'<s:message code="contrato.tabExpAsuCnt.volRiesgo" text="**Vol. Riesgo" />',dataIndex:'volumenRiesgo',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabExpAsuCnt.volRiesgoVencido" text="**Vol. Riesgo Venc." />',dataIndex:'volumenRiesgoVencido',width:120,renderer:app.format.moneyRenderer,align:'right'},
        {header:'<s:message code="contrato.tabExpAsuCnt.oficina" text="**Oficina" />',dataIndex:'oficina',width:120},
        {header:'<s:message code="contrato.tabExpAsuCnt.gestor" text="**Gestor" />',dataIndex:'gestor',width:120},
        {header:'<s:message code="contrato.tabExpAsuCnt.vencimientoSituacion" text="**Venc. Situac." />',dataIndex:'fechaVencimiento',width:120,align:'right'},
        {header:'<s:message code="contrato.tabExpAsuCnt.pertenece" text="**Pertenece" />',dataIndex:'pertenece',width:120}
    ]);
 
    var expedientesGrid= app.crearGrid(expedientesStore,expedientesCM,{
        title:'<s:message code="contrato.tabExpAsuCnt.expediente" text="**Expedientes"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:210
        ,iconCls : 'icon_expedientes'
    });

    expedientesGrid.on('rowdblclick', function(grid, rowIndex, e){
    if (!app.usuarioLogado.externo){
         var rec = grid.getStore().getAt(rowIndex);
      var id = rec.get('id');
        var desc = rec.get('descripcion');
        app.abreExpediente(id,desc);
    }     
    }); 
    
//FIN EXPEDIENTES   
    
//ASUNTOS    
    var Asunto = Ext.data.Record.create([
         ,{name:'id'}
        ,{name:'descripcion'}
        ,{name:'fechaCrear'}
        ,{name:'gestor'}
        ,{name:'supervisor'}
        ,{name:'despacho'}
    ]);

        var asuntosStore = page.getStore({
            flow:'contratos/asuntosContrato'
      ,storeId : 'asuntosContratoStore'
            ,reader: new Ext.data.JsonReader({
                root: 'asuntos'
            }, Asunto)
        });
    
 
   var asuntosCM  = new Ext.grid.ColumnModel([
        {header:'<s:message code="contrato.tabExpAsuCnt.codigo" text="**Código" />', sortable: false, dataIndex: 'id',fixed:true},
        {header:'<s:message code="contrato.tabExpAsuCnt.descripcion" text="**Descripción" />',dataIndex:'descripcion',width:120},
        {header:'<s:message code="contrato.tabExpAsuCnt.creacion" text="**Creación" />',dataIndex:'fechaCrear',width:120},
        {header:'<s:message code="contrato.tabExpAsuCnt.gestor" text="**Gestor" />',dataIndex:'gestor',width:120},
        {header:'<s:message code="contrato.tabExpAsuCnt.supervisor" text="**Supervisor" />',dataIndex:'supervisor',width:120},
        {header:'<s:message code="contrato.tabExpAsuCnt.despacho" text="**Despacho" />',dataIndex:'despacho',width:120}
    ]);
 
    var asuntosGrid= app.crearGrid(asuntosStore,asuntosCM,{
        title:'<s:message code="contrato.tabExpAsuCnt.asuntos" text="**Asuntos"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:211
        ,iconCls : 'icon_asuntos'
    });

  asuntosGrid.on('rowdblclick', function(grid, rowIndex, e){
      if (!app.usuarioLogado.externo){ 
          var rec = grid.getStore().getAt(rowIndex);
        var nombre_asunto=rec.get('descripcion');
        var id=rec.get('id');
        app.abreAsunto(id, nombre_asunto);
      }
    });

//FIN ASUNTOS    

  panel.add(expedientesGrid);
  panel.add(asuntosGrid);

  panel.getValue = function(){
  }

  panel.setValue = function(){
    var data = entidad.get("data");
    entidad.cacheOrLoad(data, expedientesStore, {idContrato : data.id});
    entidad.cacheOrLoad(data, asuntosStore, {idContrato : data.id});
  }
    return panel;
})
