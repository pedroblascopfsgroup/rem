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
		title:'<s:message code="contrato.consulta.tabAtipicos.titulo" text="**Atipicos"/>'
		,autoHeight : true
		,bodyStyle:'padding-top:10px;padding-bottom:0px;padding-right:10px;padding-left:10px;margin-bottom:5px'
		,nombreTab : 'tabIntervinientes'
	});
        	
	var atipicos = Ext.data.Record.create([
        {name:'id'}
        ,{name:'fechaDato'}
        ,{name:'codigo'}
        ,{name:'tipoAtipicoContrato'}
        ,{name:'importe'}
        ,{name:'fechaValor'}
        ,{name:'motivoAtipicoContrato'}
    ]);
	
	var atipicosStore = page.getStore({
            flow:'contratos/atipicosContrato'
            ,storeId: 'atipicosContratoStore'
            ,reader: new Ext.data.JsonReader({
                root: 'atipicosContratos'
            }, atipicos)
        });    
 
   var atipicosCM  = new Ext.grid.ColumnModel([
        {header:'<s:message code="contrato.consulta.tabAtipicos.listado.fecha" text="**Fecha" />', dataIndex: 'fechaDato'},
        {header:'<s:message code="contrato.consulta.tabAtipicos.listado.codigo" text="**Código" />',dataIndex:'codigo',width:120},

        {header:'<s:message code="contrato.consulta.tabAtipicos.listado.tipo" text="**Tipo" />',dataIndex:'tipoAtipicoContrato',width:120},
        {header:'<s:message code="contrato.consulta.tabAtipicos.listado.importe" text="**Importe" />',dataIndex:'importe',renderer: app.format.moneyRenderer,width:120},
        {header:'<s:message code="contrato.consulta.tabAtipicos.listado.fechaValor" text="**Fecha valor" />',dataIndex:'fechaValor',width:120},
        {header:'<s:message code="contrato.consulta.tabAtipicos.listado.motivo" text="**Motivo" />',dataIndex:'motivoAtipicoContrato',width:120}
    ]);
    
    var atipicosGrid= app.crearGrid(atipicosStore,atipicosCM,{
        title:'<s:message code="contrato.consulta.tabAtipicos.listado" text="**Listado de operaciones at&iacute;picas"/>'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,clicksToEdit:1
        ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
        ,height:210
        ,iconCls : 'icon_expedientes'
    });
    
    atipicosStore.addListener('load', function(store, meta) {
		store.sort('fechaDato', 'DESC');
    });
       
    panel.add(atipicosGrid);
  
  	panel.getValue = function(){  }

  	panel.setValue = function(){
    	var data = entidad.get("data");
    	entidad.cacheOrLoad(data, atipicosStore, {idContrato : data.id});
  	}
  
    return panel;
})